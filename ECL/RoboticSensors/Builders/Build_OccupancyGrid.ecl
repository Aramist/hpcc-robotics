IMPORT $.^ AS RoboticSensors;
IMPORT RoboticSensors.Sensors.OccupancyGrid;

topic := 'map';
outputPath := '~robotics::out::grid::' + topic;
processedInput := OccupancyGrid.getDataset(topic);

OUTPUT(processedInput, , outputPath, THOR, OVERWRITE, COMPRESSED);
OccupancyGrid.constructIndex(topic);