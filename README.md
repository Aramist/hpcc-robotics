# hpcc-robotics
A ROS package and ECL modules for importing data from commonly used sensors in robotics into HPCC Systems.

## Getting Started
* Clone the repository into the package directory of your catkin workspace
```bash
cd catkin-workspace/src
git clone https://github.com/Aramist/hpcc-robotics.git
cd ..
```

* Build the package and source setup.bash
```bash
catkin_make
source devel/setup.bash
```

* Change the output directory parameter and any sensor-related parameters in core.launch
```bash
rosed hpcc-robotics core.launch
```

* Give execution permissions to bin/main
```bash
roscd hpcc-robotics/bin
chmod +x main
```

* Launch the node to begin data collection
```bash
roslaunch hpcc-robotics core.launch
```

* After the node has been stopped, upload the generated files to a landing zone through ECL Watch

* Perform a fixed spray on each of the files with 'nosplit' enabled

* Use the modules in ECL/RoboticSensors/Builders to convert the files into structured records