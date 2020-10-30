# InterbotiX X-Series Arm & Turret ROS Packages
![banner](images/banner.png)

NOTE: AS OF OCTOBER 29, 2020, THIS REPO IS IN LEGACY MODE!!!!!!

Check out the new and improved arm repo at https://github.com/Interbotix/interbotix_ros_manipulators or turret repo at https://github.com/Interbotix/interbotix_ros_turrets. No hardware changes are needed to use those repos. Please note that to work with the new code, you should either delete or rename your old *interbotix_ws* catkin workspace to something else. Also note, that if you are commanding arm (not turret) joint positions directly in your code (not by commanding an end-effector pose, but actually commanding a joint position directly), the positive direction of the 'elbow' and 'wrist_angle' joints have been inverted. This is to keep consistency in the ROS frames at each joint. So just flip the sign on those commands if needed in your custom ROS packages or python scripts.

## Overview
Welcome to the *interbotix_ros_arms_pi* repo! This repository is a 'lighter' version of the [interbotix_ros_arms](https://github.com/Interbotix/interbotix_ros_arms) repo that is meant to run on a Raspberry Pi 3B+. It is mainly geared for those who would like to create a Plug-N-Play solution to control the many [X-Series robotic arms](https://www.trossenrobotics.com/robotic-arms.aspx) and [X-Series Turrets](https://www.trossenrobotics.com/c/robot-turrets.aspx) sold by Trossen Robotics. Packages were tested on Ubuntu Mate 18.04 for the Raspberry Pi using ROS Melodic. Communication with the robot is done over USB via the [U2D2](https://www.trossenrobotics.com/dynamixel-u2d2.aspx). This device converts USB signals to TTL which allows a computer to 'talk' with each of the [Dynamixel servo motors](https://www.trossenrobotics.com/dynamixel-x-series-robot-servos) that make up each robot. For the most part, the ROS nodes were written in C++ with a couple nodes written in Python. However, any programming language capable of sending ROS messages can be used to control the robots. To that effect, the core packages that make up this repo are as follows:
- **interbotix_descriptions:** contains the meshes and URDFs (including accurate inertial models for the robot-arm links) for the arms and turrets
- **interbotix_sdk:** contains the driver node that controls the physical robot and publishes joint states
- **interbotix_joy_control:** contains the nodes to allow PS4 control of a robotic arm (not turret)
- **interbotix_turret_control:** contains the nodes to allow PS4 control of a turret

## Requirements
Below is a list of the hardware you will need to get started:
- [Raspberry Pi 3B+ Kit](https://www.amazon.com/CanaKit-Raspberry-Starter-Premium-Black/dp/B07BCC8PK7/ref=sr_1_14?keywords=raspberry+pi+3b%2B&qid=1574291604&sr=8-14) (including Pi, Case, 5V Power Supply, EVO+ microSD card, HDMI cable)
- An [X-Series robot kit](https://www.trossenrobotics.com/robot-kits.aspx) from Trossen Robotics that should include (among other things):
  - 1 x robotic arm or turret and accompanying 12V power supply
  - 1 x [U2D2](https://www.trossenrobotics.com/dynamixel-u2d2.aspx) and accompanying micro-usb cable
  - 1 x [X-Series power hub](http://www.support.interbotix.com/html/electronics/index.html#control-boards) to distribute power to the Dynamixel motors and allow communication with the U2D2
- 1 x Original Sony PS4 Controller

## Raspberry Pi Setup

To work with ROS, you should install Ubuntu Mate 18.04 on the Raspberry Pi followed by ROS Melodic. The two guides below are excellent and should help with this step. Note that when setting up your username, you should either use 'turretbot' if setting up a Turret or 'armbot' if setting up an Arm. Also, when prompted, you should choose to have the Pi log you in automatically. Finally, when completing the second tutorial, stop short of the *Start developing!* section as that will be covered in the **Quickstart** section below.
- [Install Ubuntu MATE 18.04 on Raspberry Pi 3B+](https://roboticsbackend.com/install-ubuntu-mate-18-04-on-raspberry-pi-3-b/)
- [Install ROS Melodic on Raspberry Pi 3](https://roboticsbackend.com/install-ros-on-raspberry-pi-3/)

While not necessary, it could be helpful to create a Hotspot on the Pi so that you can connect to it from your own personal computer easily over SSH. The tutorial below does a great job of explaining how to do this.
- [How to Create Wi-Fi Hotspot in Ubuntu 18.04 / Gnome](https://www.linuxuprising.com/2018/09/how-to-create-wi-fi-hotspot-in-ubuntu.html)

Similarly, if you plan on using a monitor with the Pi, make sure to plug it in before turning on the computer. If you plug it in later, there's a good chance that the Pi will not detect it and you will not be able to see anything. Or, you can fix this issue by doing the following steps.
- Open a terminal and type `sudo nano /boot/config.txt`
- In the file that pops up, uncomment the line that says `#hdmi_force_hotplug=1`. What this will do is trick the Pi into thinking that an HDMI monitor is plugged in even if it's not.
- Then scroll down and uncomment the line that says `hdmi_group=2`. This step tells the Pi to 'imagine' that it is connected to an HDMI monitor of the DMT (Display Monitor Timings) variety.
- Finally scroll down, uncomment the line that says `#hdmi_mode=1` and modify it to `hdmi_mode=82`. This tells the Pi to configure the imaginary monitor to have a 1080p resolution with a refresh rate of 60Hz. Now, if you plug in an actual monitor any point after boot, the Pi will detect it and configure it with the resolution above.

## Hardware Setup
There is not much required to get the robot up and running as most of the setup is done for you. Just make sure to do the following steps:
 - Remove the robot from its packaging and place on a sturdy tabletop surface near an electrical outlet. To prevent it from potentially toppling during operation, secure it to a flat surface by placing the available thumb screws through the mounting holes around the base. At your own risk, you could instead place a small heavy bean-bag on top of the acrylic plate by the robot base. Finally, make sure that there are no obstacles within the workspace of the robot.
 - Plug the 12V Power Supply cable into an outlet and insert the barrel plug into the barrel jack on the X-Series power hub (located under the see-through acrylic on the robot base). You should briefly see the LEDs on the motors flash red.
 - Plug the microUSB cable into the U2D2 (also located under the see-through acrylic on the robot base), and into a USB port on the Raspberry Pi.
 - Finally, plug the 5V Raspberry Pi Power Supply cable into an outlet and insert the other side into the microUSB port on the Pi. If turning on the Pi for the first time, make sure to connect a keyboard, mouse, and HDMI monitor to it. Then, flick on the switch on the power cable and login.

## Quickstart
1. Open a terminal on the Pi and create a new catkin workspace called `interbotix_ws`
```
$ mkdir -p ~/interbotix_ws/src
$ cd ~/interbotix_ws/
$ catkin_make
```

2. Make sure that your new workspace is sourced every time a terminal is opened
```
$ source ~/interbotix_ws/devel/setup.bash
$ echo "source ~/interbotix_ws/devel/setup.bash" >> ~/.bashrc
```

3. Change into your `src` directory and clone the repository (install 'git' first).
```
$ cd ~/interbotix_ws/src
$ git clone https://github.com/Interbotix/interbotix_ros_arms_pi.git
```

4. Before doing another `catkin_make`, make sure that all required dependencies are installed. `rosdep` will be used to do this efficiently.
```
$ cd ~/interbotix_ws
$ rosdep update
$ rosdep install --from-paths src --ignore-src -r -y
```

5. There is one dependency that `rosdep` doesn't know about that must be installed manually. It's called [modern_robotics](https://github.com/NxRLab/ModernRobotics/tree/master/packages/Python), which is a robotic manipulation library that was created at Northwestern University. This package is used in the [interbotix_joy_control](armbot/interbotix_joy_control) example package to perform velocity-ik on the arm.
```
$ sudo apt install python-pip
$ sudo pip install modern_robotics
```

6. Now that all the dependencies are installed, it's time to build! Since there is only 1 GB of memory on the Pi, only use two cores. Also, make sure to disable diagnostic notes about ABI warnings as explained in bullet point #5 under *Caveats* [here](https://gcc.gnu.org/gcc-7/changes.html) (the RPI 3B+ has ARM based processors and Ubuntu Mate by default uses GCC 7).
```
$ cd ~/interbotix_ws
$ catkin_make -j2 -DCMAKE_CXX_FLAGS="-Wno-psabi"
```

Note that if the terminal freezes up during compilation (for more than 30 seconds), lower the number of cores to 1 as shown below.
```
$ catkin_make -j1 -DCMAKE_CXX_FLAGS="-Wno-psabi"
```

7. Copy over the udev rules to the right directory. The rules create a symlink for the port to which the U2D2 is connected. This ensures that the Pi always 'recognizes' the U2D2. It also reduces USB latency to 1 ms so that there is minimal lag during communication. Afterwards, reload and trigger the updated udev rules.
```
$ sudo cp ~/interbotix_ws/src/interbotix_ros_arms_pi/interbotix_sdk/10-interbotix-udev.rules /etc/udev/rules.d
$ sudo udevadm control --reload-rules && udevadm trigger
```

8. Unplug and replug in the micro-usb cable (that should already be connected to the U2D2) to the Pi and verify that the port shows up under the symlink `/dev/ttyDXL`
```
$ cd /dev
$ ls
```

9. If you would like to make the Pi launch the robot nodes at startup, then do the following (this explanation is for the 'armbot' nodes but the procedure is similar for the 'turretbot' as well):
```
$ chmod +x ~/interbotix_ws/src/interbotix_ros_arms_pi/armbot/start_armbot.sh
$ sudo cp ~/interbotix_ws/src/interbotix_ros_arms_pi/armbot/start_armbot.service /lib/systemd/system/
$ sudo systemctl daemon-reload
$ sudo systemctl enable start_armbot.service
```

10. If controlling a Turret, you can add a Desktop Shortcut to start the GUI by typing:
```
$ sudo cp ~/interbotix_ws/src/interbotix_ros_arms_pi/turretbot/turret.desktop /usr/share/applications/
```
Now if you navigate to the Menu icon on the top-left of the Pi's Desktop and type 'Interbotix Turret', a shortcut should pop up; click and drag it to your desktop.

11. Complete the **PS4 Controller Setup** and **Specify Robot Arm/Turret Type** sections located [here](armbot/Robot%20Arm%20Quickstart.pdf) if controlling a Robot Arm or [here](turretbot/Turret%20Quickstart.pdf) if controlling a Turret. These sections should help you pair a PS4 controller to the Pi via Bluetooth and let the ROS nodes 'know' which specific robot you will be controlling. At the end, don't forget to restart the Pi!

12. To get familiar with the joystick button mappings and/or the Turret Control GUI, navigate to the [armbot](armbot/) or [turretbot](turretbot/) directories and look through the Quickstart and/or Tutorial guides.

13. If you just want to control the platform without a controller, you can do that as well! Either create your own custom ROS package or head over to the [python_demos](python_demos/) folder to get started!

## Contributors
- [Matt Trossen](https://www.trossenrobotics.com/) - **Project Lead**
- [Solomon Wiznitzer](https://github.com/swiz23) - **ROS Engineer**
- [Levi Todes](https://github.com/LeTo37) - **CAD Engineer**
