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

      virtual void PreStep();

      virtual void PostStep();

      virtual CColor GetFloorColor(const CVector2& c_position);

   private:

      void LogEmbodiedEntityToFile(const std::string& str_entity_id,
                                   const CEmbodiedEntity& c_embodied_entity);

      std::vector<CLightEntity*> m_vecLights;
      std::vector<UInt32> m_vecToggle;

      std::map<std::string, std::ofstream> m_mapOutputStreams;

      const static CColor m_cLightOn;
      const static CColor m_cLightOff;
      const static std::vector<std::tuple<const char*, CVector3, CColor, Real> > m_vecLightConfigs;
   };


}

#endif

