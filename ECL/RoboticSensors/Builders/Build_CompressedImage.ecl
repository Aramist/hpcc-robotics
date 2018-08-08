IMPORT $.^ AS RoboticSensors;
IMPORT RoboticSensors.Sensors.CompressedImage;

topic := 'camera_compressedfeed';
outputPath := '~robotics::out::compressedimage::' + topic;
processedInput := CompressedImage.getDataset(topic);

OUTPUT(processedInput, , outputPath, THOR, OVERWRITE, COMPRESSED);
CompressedImage.constructIndex(topic);