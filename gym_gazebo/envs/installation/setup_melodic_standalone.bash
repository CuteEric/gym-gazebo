#!/bin/bash

source /opt/ros/melodic/setup.bash

if [ -z "$ROS_DISTRO" ]; then
  echo "ROS not installed. Check the installation steps: https://github.com/erlerobot/gym#installing-the-gazebo-environment"
  exit 1
fi

program="gazebo"
condition=$(which $program 2>/dev/null | grep -v "not found" | wc -l)
if [ $condition -eq 0 ] ; then
    echo "Gazebo is not installed. Check the installation steps: https://github.com/erlerobot/gym#installing-the-gazebo-environment"
fi



# Create catkin_ws
ws="catkin_ws"
if [ -d $ws ]; then
  echo "Error: catkin_ws directory already exists" 1>&2
fi
src=$ws"/src"
mkdir -p $src
cd $src
catkin_init_workspace

mv ../../dependencies/* ./
cd ..
touch catkin_ws/src/ecl_navigation/ecl_mobile_robot/CATKIN_IGNORE
catkin_make
bash -c 'echo source `pwd`/devel/setup.bash >> ~/.bashrc'
echo "## ROS workspace compiled ##"

# add own models path to gazebo models path
if [ -z "$GAZEBO_MODEL_PATH" ]; then
  bash -c 'echo "export GAZEBO_MODEL_PATH="`pwd`/../../assets/models >> ~/.bashrc'
  exec bash #reload bashrc
fi