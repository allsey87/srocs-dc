#
# Create the DC QtOpenGL user functions library
#
add_library(dc_qtopengl_user_functions MODULE
  dc_qtopengl_user_functions.h
  dc_qtopengl_user_functions.cpp)

target_link_libraries(dc_qtopengl_user_functions
  ${SROCS_ENTITIES_LIBRARY}
  ${ARGOS_QTOPENGL_LIBRARY})
