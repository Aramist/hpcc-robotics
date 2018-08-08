IMPORT $.^ AS RoboticSensors;
IMPORT RoboticSensors.Sensors.Odometry;

topic := 'gps_rtkfix';
outputPath := '~robotics::out::odometry::' + topic;
processedInput := Odometry.getDataset(topic);

OUTPUT(processedInput, , outputPath, THOR, OVERWRITE, COMPRESSED);
Odometry.constructIndex(topic);