add_library(dc_srocs_loop_functions MODULE
   dc_srocs_loop_functions.h
   dc_srocs_loop_functions.cpp)

target_link_libraries(dc_srocs_loop_functions
   ${SROCS_ENTITIES_LIBRARY})

