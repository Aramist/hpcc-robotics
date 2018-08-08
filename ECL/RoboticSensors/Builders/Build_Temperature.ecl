IMPORT $.^ AS RoboticSensors;
IMPORT RoboticSensors.Sensors.Temperature;

topic := 'thermometer';
outputPath := '~robotics::out::temperature::' + topic;
processedInput := Temperature.getDataset(topic);

OUTPUT(processedInput, , outputPath, THOR, OVERWRITE, COMPRESSED);
Temperature.constructIndex(topic);