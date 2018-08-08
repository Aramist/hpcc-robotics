IMPORT $.^ AS RoboticSensors;
IMPORT RoboticSensors.Sensors.IMU;

topic := 'navx';
outputPath := '~robotics::out::imu::' + topic;
processedInput := IMU.getDataset(topic);

OUTPUT(processedInput, , outputPath, THOR, OVERWRITE, COMPRESSED);
IMU.constructIndex(topic);