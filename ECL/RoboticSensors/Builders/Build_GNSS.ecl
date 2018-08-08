IMPORT $.^ AS RoboticSensors;
IMPORT RoboticSensors.Sensors.GNSS;

topic := 'gps_fix';
outputPath := '~robotics::out::gnss::' + topic;
processedInput := GNSS.getDataset(topic);

OUTPUT(processedInput, , outputPath, THOR, OVERWRITE, COMPRESSED);
GNSS.constructIndex(topic);