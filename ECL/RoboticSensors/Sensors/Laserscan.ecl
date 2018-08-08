IMPORT $.^ as RoboticSensors;
IMPORT RoboticSensors.Types AS mTypes;
IMPORT RoboticSensors.Utils AS mUtils;

EXPORT Laserscan := MODULE
	EXPORT mTypes.layout_laserscan convert(mTypes.layout_raw raw) := TRANSFORM
		DATA cont := raw.content;
		SELF.timestamp_e6 := (UNSIGNED8) (TRANSFER(cont[1..8], REAL) * 1000000);
		info := mUtils.castToFloatArray(cont[9..32]);
		SELF.angle_min := info[1];
		SELF.angle_max := info[2];
		SELF.angle_increment := info[3];
		SELF.scan_time := info[4];
		SELF.range_min := info[5];
		SELF.range_max := info[6];
		range_len := TRANSFER(cont[33..36], UNSIGNED4);
		rangeAndInt := mUtils.castToFloatArray(cont[37..]);
		SELF.ranges := rangeAndInt[1..range_len];
		SELF.intensities := rangeAndInt[range_len+1..];
	END;
	
	EXPORT DATASET(mTypes.layout_laserscan) getDataset(STRING topic) := FUNCTION
		logical_path := '~robotics::laserscan::' + topic;
		rawDataset := dataset(logical_path, mTypes.layout_raw, FLAT);
		transformed := project(rawDataset, convert(LEFT));
		RETURN transformed;
	END;
	
	EXPORT LaserscanByTimestamp(STRING topic) := FUNCTION
		dset := DATASET(
			'~robotics::out::laserscan::' + topic,
			{mTypes.layout_laserscan, UNSIGNED8 fpos {virtual(fileposition)}},
			THOR
		);
		scan_index := INDEX(
			dset,
			{timestamp_e6, fpos},
			{angle_min, angle_max, scan_time, range_min, range_max, ranges, intensities},
			'~robotics::out::laserscan::' + topic + '_LaserscanByTimestamp'
		);
		RETURN scan_index;
	END;
	
	EXPORT constructIndex(STRING topic) := FUNCTION
		RETURN BUILDINDEX(LaserscanByTimestamp(topic), OVERWRITE);
	END;
END;