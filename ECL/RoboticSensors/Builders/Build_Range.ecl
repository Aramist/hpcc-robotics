IMPORT $.^ AS RoboticSensors;
IMPORT RoboticSensors.Sensors.Range;

topic := 'ultrasound';
outputPath := '~robotics::out::range::' + topic;
processedInput := Range.getDataset(topic);

OUTPUT(processedInput, , outputPath, THOR, OVERWRITE, COMPRESSED);
Range.constructIndex(topic);