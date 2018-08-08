IMPORT $.^ as RoboticSensors;
IMPORT RoboticSensors.Types AS mTypes;
IMPORT RoboticSensors.Utils AS mUtils;

EXPORT IMU := MODULE
	EXPORT mTypes.layout_imu convert(mTypes.layout_raw raw) := TRANSFORM
		DATA cont := raw.content;
		contents := mUtils.castToDoubleArray(cont);
		SELF.timestamp_e6 := (UNSIGNED8) (contents[1] * 1000000);
		SELF.orientation := contents[2..5];
		SELF.orientation_covariance :=
			mUtils.doubleToMatrix(3, 3, cont[65..136]);
		SELF.angular_velocity := contents[18..20];
		SELF.angular_velocity_covariance := 
			mUtils.doubleToMatrix(3, 3, cont[161..232]);
		SELF.linear_acceleration := contents[30..32];
		SELF.linear_acceleration_covariance := 
			mUtils.doubleToMatrix(3, 3, cont[257..]);
	END;
	
	EXPORT DATASET(mTypes.layout_imu) getDataset(STRING topic) := FUNCTION
		logical_path := '~robotics::imu::' + topic;
		rawDataset := dataset(logical_path, mTypes.layout_raw, FLAT);
		transformed := project(rawDataset, convert(LEFT));
		RETURN transformed;
	END;
	
	EXPORT IMUByTimestamp(STRING topic) := FUNCTION
		dset := DATASET(
			'~robotics::out::imu::' + topic,
			{mTypes.layout_imu, UNSIGNED8 fpos {virtual(fileposition)}},
			THOR
		);
		imu_index := INDEX(
			dset,
			{timestamp_e6, fpos},
			{orientation, orientation_covariance, angular_velocity,
			 angular_velocity_covariance, linear_acceleration,
			 linear_acceleration_covariance},
			'~robotics::out::imu::' + topic + '_IMUByTimestamp'
		);
		RETURN imu_index;
	END;
	
	EXPORT constructIndex(STRING topic) := FUNCTION
		RETURN BUILDINDEX(IMUByTimestamp(topic), OVERWRITE);
	END;
END;