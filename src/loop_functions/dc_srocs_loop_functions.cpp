#include "dc_srocs_loop_functions.h"

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
         }
      }
   }

   /****************************************/
   /****************************************/

   REGISTER_LOOP_FUNCTIONS(CDCSRoCSLoopFunctions, "dc_srocs_loop_functions");

}
