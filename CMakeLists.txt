cmake_minimum_required(VERSION 2.8.3)
project(hpcc-robotics)

# C++14 is the standard for ROS Melodic
add_compile_options(-std=c++14)

# List dependencies
find_package(catkin REQUIRED COMPONENTS
  message_generation rospy sensor_msgs nav_msgs
)


catkin_package(
  CATKIN_DEPENDS message_runtime
)

catkin_python_setup()
catkin_install_python(PROGRAMS bin/main
  DESTINATION ${CATKIN_PACKAGE_BIN_DESTINATION})