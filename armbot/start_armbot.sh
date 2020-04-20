#!/bin/bash

# This script is called by the 'start_armbot.service' file when
# the Raspberry Pi boots. It just sources the ROS related workspaces
# and launches the joy_control launch file. Make sure it is placed in
# /home/armbot/interbotix_ws/src/interbotix_ros_arms_pi/armbot/ (which
# it should be by default). Also set the right permissions for the
# script by 'chmod +x start_armbot.sh'

source /opt/ros/melodic/setup.bash
source /home/armbot/interbotix_ws/devel/setup.bash
roslaunch interbotix_joy_control joy_control.launch use_default_rviz:=false
