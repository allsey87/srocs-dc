#ifndef DC_SROCS_LOOP_FUNCTIONS_H
#define DC_SROCS_LOOP_FUNCTIONS_H

namespace argos {
   class CBlockEntity;
   class CBuilderBotEntity;
   class CLightEntity;
}

#include <argos3/core/simulator/space/space.h>
#include <argos3/core/simulator/loop_functions.h>

#include <argos3/core/utility/math/vector3.h>
#include <argos3/core/utility/math/range.h>

namespace argos {

   class CDCSRoCSLoopFunctions : public CLoopFunctions {

   public:

      struct SLight {
         /* constructor */
         SLight(CLightEntity* pc_light_entity,
                const CVector3& c_start,
                const CVector3& c_end,
                UInt32 un_duration) :
            Entity(pc_light_entity),
            Start(c_start),
            End(c_end),
            Duration(un_duration) {}
         /* members */
         CLightEntity* Entity;
         CVector3 Start;
         CVector3 End;
         UInt32 Duration;
      };

   public:

      CDCSRoCSLoopFunctions();

      virtual ~CDCSRoCSLoopFunctions() {}

      virtual void Init(TConfigurationNode& t_tree);

      //virtual void Reset();

      //virtual void Destroy();

      //virtual void PreStep();

      virtual void PostStep();

      virtual CColor GetFloorColor(const CVector2& c_position);

   private:
      CSpace& m_cSpace;

      std::vector<SLight> m_vecLights;

      std::vector<CBuilderBotEntity*> m_vecRobots;
      std::vector<CBlockEntity*> m_vecBlocks;

   };


}

#endif

