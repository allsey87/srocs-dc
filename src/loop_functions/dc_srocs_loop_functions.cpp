#include "dc_srocs_loop_functions.h"

#include <argos3/core/simulator/entity/floor_entity.h>
#include <argos3/plugins/simulator/entities/block_entity.h>
#include <argos3/plugins/robots/builderbot/simulator/builderbot_entity.h>
#include <argos3/plugins/simulator/entities/light_entity.h>
#include <argos3/plugins/simulator/media/led_medium.h>

namespace argos {

   /****************************************/
   /****************************************/

   CDCSRoCSLoopFunctions::CDCSRoCSLoopFunctions() {}

   /****************************************/
   /****************************************/

   void CDCSRoCSLoopFunctions::Init(TConfigurationNode& t_tree) {
      /* get the lights node and the medium for the lights */
      TConfigurationNode& tLights = GetNode(t_tree, "lights");
      std::string strLightMedium;
      GetNodeAttribute(tLights, "medium", strLightMedium);
      CLEDMedium& cLightMedium = 
         CSimulator::GetInstance().GetMedium<CLEDMedium>(strLightMedium);
      std::string strLightToggle;
      GetNodeAttribute(tLights, "toggle", strLightToggle);
      std::vector<std::string> vecToggle;
      Tokenize(strLightToggle, vecToggle, ",");
      for(const std::string& str : vecToggle) {
         m_vecToggle.push_back(static_cast<UInt32>(std::stoul(str)));
      }
      /* create lights */
      for(const std::tuple<const char*, CVector3, CColor, Real>& c_config : m_vecLightConfigs) {
         CLightEntity* pcLight = 
            new CLightEntity(std::get<const char*>(c_config),
                             std::get<CVector3>(c_config),
                             std::get<CColor>(c_config),
                             std::get<Real>(c_config));
         AddEntity(*pcLight);
         cLightMedium.AddEntity(*pcLight);
         m_vecLights.push_back(pcLight);
      }
      cLightMedium.Update();
   }

   /****************************************/
   /****************************************/

   void CDCSRoCSLoopFunctions::Reset() {
      /* clear output streams */
      m_mapOutputStreams.clear();
   }

   /****************************************/
   /****************************************/

   void CDCSRoCSLoopFunctions::PreStep() {
      UInt32 m_unClock = GetSpace().GetSimulationClock();
      for(UInt32 un_toggle : m_vecToggle) {
         if(un_toggle == m_unClock) {
            for(CLightEntity* pc_light : m_vecLights) {
               if(pc_light->GetColor() == m_cLightOn) {
                  pc_light->SetColor(m_cLightOff);
               }
               else {
                  pc_light->SetColor(m_cLightOn);
               }
            }
            break;
         }
      }
      /* if floor exists, mark it as changed */
      try {
         GetSpace().GetFloorEntity().SetChanged();
      }
      catch(CARGoSException& ex) {}
   }

   /****************************************/
   /****************************************/

   void CDCSRoCSLoopFunctions::PostStep() {
      using TValueType = std::pair<const std::string, CAny>;
      try {
         for(TValueType& t_robot : GetSpace().GetEntitiesByType("builderbot")) {
            CBuilderBotEntity* pcBuilderBot =
               any_cast<CBuilderBotEntity*>(t_robot.second);
            LogEmbodiedEntityToFile(t_robot.first, pcBuilderBot->GetEmbodiedEntity());
         }
      }
      catch(CARGoSException &ex) {}
      try {
         for(TValueType& t_block : GetSpace().GetEntitiesByType("block")) {
            CBlockEntity* pcBlock =
               any_cast<CBlockEntity*>(t_block.second);
            LogEmbodiedEntityToFile(t_block.first, pcBlock->GetEmbodiedEntity());
         }
      }
      catch(CARGoSException &ex) {}
   }

   /****************************************/
   /****************************************/

   CColor CDCSRoCSLoopFunctions::GetFloorColor(const CVector2& c_position) {
      Real fTotalLight = 0.0;
      CVector3 cFloorPosition(c_position.GetX(), c_position.GetY(), 0.0);
      /* accumulate the light sources */
      for(CLightEntity* pc_light : m_vecLights) {
         const CVector3& cLightPosition = pc_light->GetPosition();
         const CColor& cLightColor = pc_light->GetColor();
         /* initialize brightness with the grayscale value of the light */
         Real fBrightness = cLightColor.ToGrayScale();
         /* decrease fBrightness with respect to inverse square law */
         fBrightness *= 1.0 / (1.0 + SquareDistance(cLightPosition, cFloorPosition));
         /* decrease fBrightness with respect to the angle between the light source and the sensor */
         CVector3 cFloorToLight(cLightPosition - cFloorPosition);
         Real fCosine = (CVector3::Z.DotProduct(cFloorToLight) / (CVector3::Z.Length() * cFloorToLight.Length()));
         fBrightness *= (fCosine + 1.0) / 2.0;
         /* decrease fBrightness with respect to obstacles between the light source and the sensor */
         /*
         CRay3 cLightRay(cFloorPosition, cLightPosition);
         SEmbodiedEntityIntersectionItem sIntersection;
         if(GetClosestEmbodiedEntityIntersectedByRay(sIntersection, cLightRay)) {
            fBrightness *= Abs(0.5 - sIntersection.TOnRay);
         }
         */
         fTotalLight += fBrightness;
      }
      fTotalLight = std::min(fTotalLight, static_cast<Real>(UINT8_MAX));
      UInt8 unTotalLight = static_cast<UInt8>(fTotalLight);
      return CColor(unTotalLight, unTotalLight, unTotalLight);
   }

   /****************************************/
   /****************************************/

   void CDCSRoCSLoopFunctions::LogEmbodiedEntityToFile(const std::string& str_entity_id,
                                                       const CEmbodiedEntity& c_embodied_entity) {
      UInt32 unClock = GetSpace().GetSimulationClock();
      std::map<std::string, std::ofstream>::iterator itOutputStream =
         m_mapOutputStreams.find(str_entity_id);
      if(itOutputStream == std::end(m_mapOutputStreams)) {
         std::pair<std::map<std::string, std::ofstream>::iterator,bool> cResult =
            m_mapOutputStreams.emplace(std::piecewise_construct,
                                       std::forward_as_tuple(str_entity_id),
                                       std::forward_as_tuple(str_entity_id + ".csv",
                                                             std::ios_base::out |
                                                             std::ios_base::trunc));
         if(cResult.second) {
            itOutputStream = cResult.first;
         }
         else {
            THROW_ARGOSEXCEPTION("Could not insert output stream into map");
         }
      }
      itOutputStream->second 
         << unClock
         << ","
         << c_embodied_entity.GetOriginAnchor().Position
         << std::endl;
   }

   /****************************************/
   /****************************************/

   const CColor CDCSRoCSLoopFunctions::m_cLightOn = CColor(255, 240, 100);

   const CColor CDCSRoCSLoopFunctions::m_cLightOff = CColor(40, 40, 30);

   const std::vector<std::tuple<const char*, CVector3, CColor, Real> > CDCSRoCSLoopFunctions::m_vecLightConfigs = {
      std::make_tuple("North", CVector3(1.45,0,0.25), m_cLightOn, 1.0),
      std::make_tuple("East", CVector3(0,-1.45,0.25), m_cLightOff, 1.0),
      std::make_tuple("South", CVector3(-1.45,0,0.25), m_cLightOn, 1.0),
      std::make_tuple("West", CVector3(0,1.45,0.25), m_cLightOff, 1.0),
   };

   /****************************************/
   /****************************************/

   REGISTER_LOOP_FUNCTIONS(CDCSRoCSLoopFunctions, "dc_srocs_loop_functions");

}
