#include "dc_srocs_loop_functions.h"

#include <argos3/core/simulator/entity/floor_entity.h>
#include <argos3/plugins/simulator/entities/block_entity.h>
#include <argos3/plugins/robots/builderbot/simulator/builderbot_entity.h>
#include <argos3/plugins/simulator/entities/light_entity.h>
#include <argos3/plugins/simulator/media/led_medium.h>

namespace argos {

   /****************************************/
   /****************************************/

   CDCSRoCSLoopFunctions::CDCSRoCSLoopFunctions() :
      m_unStep(0) {}

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
         m_vecToggle.push_back(std::stoul(str));
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
      m_unStep = 0;
   }

   /****************************************/
   /****************************************/

   void CDCSRoCSLoopFunctions::PostStep() {
      m_unStep += 1;
      for(unsigned long un_toggle : m_vecToggle) {
         if(un_toggle == m_unStep) {
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
         CRay3 cLightRay(cFloorPosition, cLightPosition);
         SEmbodiedEntityIntersectionItem sIntersection;
         if(GetClosestEmbodiedEntityIntersectedByRay(sIntersection, cLightRay)) {
            fBrightness *= Abs(0.5 - sIntersection.TOnRay);
         }
         fTotalLight += fBrightness;
      }
      fTotalLight = std::min(fTotalLight, static_cast<Real>(UINT8_MAX));
      UInt8 unTotalLight = static_cast<UInt8>(fTotalLight);
      return CColor(unTotalLight, unTotalLight, unTotalLight);
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
