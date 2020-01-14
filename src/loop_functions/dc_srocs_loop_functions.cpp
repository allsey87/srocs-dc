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
      m_cSpace(CSimulator::GetInstance().GetSpace()) {}

   /****************************************/
   /****************************************/

   void CDCSRoCSLoopFunctions::Init(TConfigurationNode& t_tree) {
      /* get the lights node and the medium for the lights */
      TConfigurationNode& tLights = GetNode(t_tree, "lights");
      std::string strLightMedium;
      GetNodeAttribute(tLights, "medium", strLightMedium);
      CLEDMedium& cLightMedium = 
         CSimulator::GetInstance().GetMedium<CLEDMedium>(strLightMedium);
      /* get the individual lights */
      TConfigurationNodeIterator itLight("light");
      std::string strId;
      CVector3 cStart;
      CVector3 cEnd;
      UInt32 unDuration;
      for(itLight =  itLight.begin(&tLights);
          itLight != itLight.end();
          ++itLight) {
         GetNodeAttribute(*itLight, "id", strId);
         GetNodeAttribute(*itLight, "start", cStart);
         GetNodeAttribute(*itLight, "end", cEnd);
         GetNodeAttribute(*itLight, "duration", unDuration);
         m_vecLights.emplace_back(new CLightEntity(strId, cStart, CColor::YELLOW, 1.0),
                                  cStart, cEnd, unDuration);
      }
      for(SLight& s_light : m_vecLights) {
         AddEntity(*s_light.Entity);
         cLightMedium.AddEntity(*s_light.Entity);
      }
      cLightMedium.Update();
   }

   /****************************************/
   /****************************************/

   void CDCSRoCSLoopFunctions::PostStep() {
      CVector3 cPosition;
      for(SLight& s_light : m_vecLights) {
         if(m_cSpace.GetSimulationClock() < s_light.Duration) {
            Real fProgress = static_cast<Real>(m_cSpace.GetSimulationClock()) /
               static_cast<Real>(s_light.Duration);
            cPosition = s_light.Start + ((s_light.End - s_light.Start) * fProgress);
            s_light.Entity->MoveTo(cPosition, CQuaternion());
            try {
               /* if floor exists, mark it as changed */
               m_cSpace.GetFloorEntity().SetChanged();
            }
            catch(CARGoSException& ex) {}
         }
      }
   }

   /****************************************/
   /****************************************/

   CColor CDCSRoCSLoopFunctions::GetFloorColor(const CVector2& c_position) {
      Real fTotalLight = 0.0;
      CVector3 cFloorPosition(c_position.GetX(), c_position.GetY(), 0.0);
      /* accumulate the light sources */
      for(SLight& s_light : m_vecLights) {
         const CVector3& cLightPosition = s_light.Entity->GetPosition();
         const CColor& cLightColor = s_light.Entity->GetColor();
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

   REGISTER_LOOP_FUNCTIONS(CDCSRoCSLoopFunctions, "dc_srocs_loop_functions");

}
