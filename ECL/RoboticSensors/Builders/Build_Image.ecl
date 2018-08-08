IMPORT $.^ AS RoboticSensors;
IMPORT RoboticSensors.Sensors.Image;

topic := 'camera_feed';
outputPath := '~robotics::out::image::' + topic;
processedInput := Image.getDataset(topic);

OUTPUT(processedInput, , outputPath, THOR, OVERWRITE, COMPRESSED);
Image.constructIndex(topic);