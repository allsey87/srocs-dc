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

      CDCSRoCSLoopFunctions();

      virtual ~CDCSRoCSLoopFunctions() {}

      virtual void Init(TConfigurationNode& t_tree);

      virtual void Reset();

      //virtual void Destroy();

      //virtual void PreStep();

      virtual void PostStep();

      virtual CColor GetFloorColor(const CVector2& c_position);

   private:
      unsigned long m_unStep;
      std::vector<CLightEntity*> m_vecLights;
      std::vector<unsigned long> m_vecToggle;

      const static CColor m_cLightOn;
      const static CColor m_cLightOff;
      const static std::vector<std::tuple<const char*, CVector3, CColor, Real> > m_vecLightConfigs;


   };


}

#endif

