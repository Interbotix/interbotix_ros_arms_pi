#! /bin/bash

# This script is called by the 'start_turretbot.service' file when
# the Raspberry Pi boots. It can also be called by the 'Turret Control'
# Desktop shortcut. It just sources the ROS related workspaces and
# launches the turret_control launch file. Make sure it is placed in
# /home/turretbot/interbotix_ws/src/interbotix_ros_arms_pi/turretbot/ (which
# it should be by default). Also set the right permissions for the
# script by 'chmod +x start_turretbot.sh'

source /opt/ros/melodic/setup.bash
source /home/turretbot/interbotix_ws/devel/setup.bash

# if the interbotix_sdk node is already running...
if pgrep -x "roslaunch" > /dev/null
then
	echo "Launching turret GUI node only"
	roslaunch interbotix_turret_control turret_control.launch start_non_gui_nodes:=False
else
	echo "Launching..."
	roslaunch interbotix_turret_control turret_control.launch
fi
