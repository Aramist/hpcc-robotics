IMPORT $.^ AS RoboticSensors;
IMPORT RoboticSensors.Sensors.Laserscan;

topic := 'scan';
outputPath := '~robotics::out::laserscan::' + topic;
processedInput := Laserscan.getDataset(topic);

OUTPUT(processedInput, , outputPath, THOR, OVERWRITE, COMPRESSED);
Laserscan.constructIndex(topic);