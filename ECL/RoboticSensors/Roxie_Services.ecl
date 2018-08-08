IMPORT RoboticSensors;
IMPORT RoboticSensors.Types;
IMPORT RoboticSensors.Sensors.GNSS;
IMPORT RoboticSensors.Sensors.Image;
IMPORT RoboticSensors.Sensors.Laserscan;
IMPORT RoboticSensors.Sensors.Odometry;
IMPORT RoboticSensors.Sensors.IMU;
IMPORT RoboticSensors.Sensors.OccupancyGrid;
IMPORT RoboticSensors.Sensors.Range;
IMPORT RoboticSensors.Sensors.Temperature;
IMPORT RoboticSensors.Sensors.CompressedImage;

EXPORT Roxie_Services := MODULE

	EXPORT gnss_service(STRING topic) := FUNCTION
		min_timestamp := 0.00 : STORED('min_timestamp');
		max_timestamp := 1.00 : STORED('max_timestamp');
		
		dset := DATASET(
			'~robotics::out::gnss::' + topic,
			{Types.layout_gnss, UNSIGNED8 fpos {virtual(fileposition)}},
			THOR
		);
		
		min_dset := MIN(dset, dset.timestamp_e6);
		
		// Since the client doesn't necessarily know the first timestamp in the
		// data, we must allow the requests to be relative, rather than absolute
		min_e6 := (UNSIGNED8) (min_timestamp * 1000000) + min_dset;
		max_e6 := (UNSIGNED8) (max_timestamp * 1000000) + min_dset;
		
		filter := GNSS.GNSSByTimestamp(topic)(
			timestamp_e6 >= min_e6 AND
			timestamp_e6 <= max_e6
		);
		
		result := FETCH(dset, filter, RIGHT.fpos);
		
		RETURN OUTPUT(result, NAMED(topic));
	END;
	
	EXPORT image_service(STRING topic) := FUNCTION
		min_timestamp := 0.00 : STORED('min_timestamp');
		max_timestamp := 1.00 : STORED('max_timestamp');
		
		dset := DATASET(
			'~robotics::out::image::' + topic,
			{Types.layout_image, UNSIGNED8 fpos {virtual(fileposition)}},
			THOR
		);
		
		min_dset := MIN(dset, dset.timestamp_e6);
		
		// Since the client doesn't necessarily know the first timestamp in the
		// data, we must allow the requests to be relative, rather than absolute
		min_e6 := (UNSIGNED8) (min_timestamp * 1000000) + min_dset;
		max_e6 := (UNSIGNED8) (max_timestamp * 1000000) + min_dset;
		
		filter := Image.ImageByTimestamp(topic)(
			timestamp_e6 >= min_e6 AND
			timestamp_e6 <= max_e6
		);
		
		result := FETCH(dset, filter, RIGHT.fpos);
		
		RETURN OUTPUT(result, NAMED(topic));
	END;
	
	EXPORT laserscan_service(STRING topic) := FUNCTION
		min_timestamp := 0.00 : STORED('min_timestamp');
		max_timestamp := 1.00 : STORED('max_timestamp');
		
		dset := DATASET(
			'~robotics::out::laserscan::' + topic,
			{Types.layout_laserscan, UNSIGNED8 fpos {virtual(fileposition)}},
			THOR
		);
		
		min_dset := MIN(dset, dset.timestamp_e6);
		
		// Since the client doesn't necessarily know the first timestamp in the
		// data, we must allow the requests to be relative, rather than absolute
		min_e6 := (UNSIGNED8) (min_timestamp * 1000000) + min_dset;
		max_e6 := (UNSIGNED8) (max_timestamp * 1000000) + min_dset;
		
		filter := Laserscan.LaserscanByTimestamp(topic)(
			timestamp_e6 >= min_e6 AND
			timestamp_e6 <= max_e6
		);
		
		result := FETCH(dset, filter, RIGHT.fpos);
		
		RETURN OUTPUT(result, NAMED(topic));
	END;
	
	EXPORT odometry_service(STRING topic) := FUNCTION
		min_timestamp := 0.00 : STORED('min_timestamp');
		max_timestamp := 1.00 : STORED('max_timestamp');
		
		dset := DATASET(
			'~robotics::out::odometry::' + topic,
			{Types.layout_odometry, UNSIGNED8 fpos {virtual(fileposition)}},
			THOR
		);
		
		min_dset := MIN(dset, dset.timestamp_e6);
		
		// Since the client doesn't necessarily know the first timestamp in the
		// data, we must allow the requests to be relative, rather than absolute
		min_e6 := (UNSIGNED8) (min_timestamp * 1000000) + min_dset;
		max_e6 := (UNSIGNED8) (max_timestamp * 1000000) + min_dset;
		
		filter := Odometry.OdometryByTimestamp(topic)(
			timestamp_e6 >= min_e6 AND
			timestamp_e6 <= max_e6
		);
		
		result := FETCH(dset, filter, RIGHT.fpos);
		
		RETURN OUTPUT(result, NAMED(topic));
	END;
	
	EXPORT imu_service(STRING topic) := FUNCTION
		min_timestamp := 0.00 : STORED('min_timestamp');
		max_timestamp := 1.00 : STORED('max_timestamp');
		
		dset := DATASET(
			'~robotics::out::imu::' + topic,
			{Types.layout_imu, UNSIGNED8 fpos {virtual(fileposition)}},
			THOR
		);
		
		min_dset := MIN(dset, dset.timestamp_e6);
		
		// Since the client doesn't necessarily know the first timestamp in the
		// data, we must allow the requests to be relative, rather than absolute
		min_e6 := (UNSIGNED8) (min_timestamp * 1000000) + min_dset;
		max_e6 := (UNSIGNED8) (max_timestamp * 1000000) + min_dset;
		
		filter := IMU.IMUByTimestamp(topic)(
			timestamp_e6 >= min_e6 AND
			timestamp_e6 <= max_e6
		);
		
		result := FETCH(dset, filter, RIGHT.fpos);
		
		RETURN OUTPUT(result, NAMED(topic));
	END;
	
	EXPORT occupancygrid_service(STRING topic) := FUNCTION
		min_timestamp := 0.00 : STORED('min_timestamp');
		max_timestamp := 1.00 : STORED('max_timestamp');
		
		dset := DATASET(
			'~robotics::out::grid::' + topic,
			{Types.layout_occupancygrid, UNSIGNED8 fpos {virtual(fileposition)}},
			THOR
		);
		
		min_dset := MIN(dset, dset.timestamp_e6);
		
		// Since the client doesn't necessarily know the first timestamp in the
		// data, we must allow the requests to be relative, rather than absolute
		min_e6 := (UNSIGNED8) (min_timestamp * 1000000) + min_dset;
		max_e6 := (UNSIGNED8) (max_timestamp * 1000000) + min_dset;
		
		filter := OccupancyGrid.GridByTimestamp(topic)(
			timestamp_e6 >= min_e6 AND
			timestamp_e6 <= max_e6
		);
		
		result := FETCH(dset, filter, RIGHT.fpos);
		
		RETURN OUTPUT(result, NAMED(topic));
	END;
	
	EXPORT range_service(STRING topic) := FUNCTION
		min_timestamp := 0.00 : STORED('min_timestamp');
		max_timestamp := 1.00 : STORED('max_timestamp');
		
		dset := DATASET(
			'~robotics::out::range::' + topic,
			{Types.layout_range, UNSIGNED8 fpos {virtual(fileposition)}},
			THOR
		);
		
		min_dset := MIN(dset, dset.timestamp_e6);
		
		// Since the client doesn't necessarily know the first timestamp in the
		// data, we must allow the requests to be relative, rather than absolute
		min_e6 := (UNSIGNED8) (min_timestamp * 1000000) + min_dset;
		max_e6 := (UNSIGNED8) (max_timestamp * 1000000) + min_dset;
		
		filter := RoboticSensors.Sensors.Range.RangeByTimestamp(topic)(
			timestamp_e6 >= min_e6 AND
			timestamp_e6 <= max_e6
		);
		
		result := FETCH(dset, filter, RIGHT.fpos);
		
		RETURN OUTPUT(result, NAMED(topic));
	END;
	
	EXPORT temperature_service(STRING topic) := FUNCTION
		min_timestamp := 0.00 : STORED('min_timestamp');
		max_timestamp := 1.00 : STORED('max_timestamp');
		
		dset := DATASET(
			'~robotics::out::temperature::' + topic,
			{Types.layout_temperature, UNSIGNED8 fpos {virtual(fileposition)}},
			THOR
		);
		
		min_dset := MIN(dset, dset.timestamp_e6);
		
		// Since the client doesn't necessarily know the first timestamp in the
		// data, we must allow the requests to be relative, rather than absolute
		min_e6 := (UNSIGNED8) (min_timestamp * 1000000) + min_dset;
		max_e6 := (UNSIGNED8) (max_timestamp * 1000000) + min_dset;
		
		filter := Temperature.TemperatureByTimestamp(topic)(
			timestamp_e6 >= min_e6 AND
			timestamp_e6 <= max_e6
		);
		
		result := FETCH(dset, filter, RIGHT.fpos);
		
		RETURN OUTPUT(result, NAMED(topic));
	END;
	
	EXPORT compressedimage_service(STRING topic) := FUNCTION
		min_timestamp := 0.00 : STORED('min_timestamp');
		max_timestamp := 1.00 : STORED('max_timestamp');
		
		dset := DATASET(
			'~robotics::out::compressedimage::' + topic,
			{Types.layout_compressedimage, UNSIGNED8 fpos {virtual(fileposition)}},
			THOR
		);
		
		min_dset := MIN(dset, dset.timestamp_e6);
		
		// Since the client doesn't necessarily know the first timestamp in the
		// data, we must allow the requests to be relative, rather than absolute
		min_e6 := (UNSIGNED8) (min_timestamp * 1000000) + min_dset;
		max_e6 := (UNSIGNED8) (max_timestamp * 1000000) + min_dset;
		
		filter := CompressedImage.CompressedImageByTimestamp(topic)(
			timestamp_e6 >= min_e6 AND
			timestamp_e6 <= max_e6
		);
		
		result := FETCH(dset, filter, RIGHT.fpos);
		
		RETURN OUTPUT(result, NAMED(topic));
	END;
END;