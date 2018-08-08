IMPORT $.^ as RoboticSensors;
IMPORT RoboticSensors.Types AS mTypes;
IMPORT RoboticSensors.Utils AS mUtils;

EXPORT Odometry := MODULE
	EXPORT mTypes.layout_odometry convert(mTypes.layout_raw raw) := TRANSFORM
		DATA cont := raw.content;
		contents := mUtils.castToDoubleArray(cont);
		SELF.timestamp_e6 := (UNSIGNED8) (contents[1] * 1000000);
		SELF.position := contents[2..4];
		SELF.orientation := contents[5..8];
		// Has to be transposed to be in column-major order, consistent with PBblas
		SELF.pose_covariance := mUtils.doubleToMatrix(6, 6, cont[65..352]);
		SELF.linear_velocity := contents[45..47];
		SELF.angular_velocity := contents[48..50];
		// Has to be transposed to be in column-major order, consistent with PBblas
		SELF.twist_covariance := mUtils.doubleToMatrix(6, 6, cont[401..]);
	END;
	
	EXPORT DATASET(mTypes.layout_odometry) getDataset(STRING topic) := FUNCTION
		logical_path := '~robotics::odometry::' + topic;
		rawDataset := dataset(logical_path, mTypes.layout_raw, FLAT);
		transformed := project(rawDataset, convert(LEFT));
		RETURN transformed;
	END;
	
	EXPORT OdometryByTimestamp(STRING topic) := FUNCTION
		dset := DATASET(
			'~robotics::out::odometry::' + topic,
			{mTypes.layout_odometry, UNSIGNED8 fpos {virtual(fileposition)}},
			THOR
		);
		odom_index := INDEX(
			dset,
			{timestamp_e6, fpos},
			{position, orientation, pose_covariance, linear_velocity, angular_velocity, twist_covariance},
			'~robotics::out::odometry::' + topic + '_OdometryByTimestamp'
		);
		RETURN odom_index;
	END;
	
	EXPORT constructIndex(STRING topic) := FUNCTION
		RETURN BUILDINDEX(OdometryByTimestamp(topic), OVERWRITE);
	END;
END;