cmake_minimum_required(VERSION 3.0.2)
project(trajectory_following)


find_package(catkin REQUIRED COMPONENTS
  geometry_msgs
  nav_msgs
  roscpp
  rospy
  std_msgs
)


catkin_package(
#  INCLUDE_DIRS include
#  LIBRARIES trajectory_following
#  CATKIN_DEPENDS geometry_msgs nav_msgs roscpp rospy std_msgs
#  DEPENDS system_lib
)


include_directories(
  include
  ${catkin_INCLUDE_DIRS}
)


add_executable(rectangle src/rectangle.cpp)
target_link_libraries(rectangle ${catkin_LIBRARIES})

add_executable(star src/star.cpp)
target_link_libraries(star ${catkin_LIBRARIES})

add_executable(cycle src/cycle.cpp)
target_link_libraries(cycle ${catkin_LIBRARIES})

add_executable(hexagon src/hexagon.cpp)
target_link_libraries(hexagon ${catkin_LIBRARIES})
