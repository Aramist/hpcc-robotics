IMPORT $.^ as RoboticSensors;
IMPORT RoboticSensors.Types AS mTypes;
IMPORT RoboticSensors.Utils AS mUtils;

EXPORT Range := MODULE
	EXPORT mTypes.layout_range convert(mTypes.layout_raw raw) := TRANSFORM
		DATA cont := raw.content;
		SELF.timestamp_e6 := (UNSIGNED8) (TRANSFER(cont[1..8], REAL) * 1000000);
		SELF.radiation_type := TRANSFER(cont[9], UNSIGNED1);
		SELF.field_of_view := TRANSFER(cont[10..13], REAL4);
		SELF.min_range := TRANSFER(cont[14..17], REAL4);
		SELF.max_range := TRANSFER(cont[18..21], REAL4);
		SELF.reading := TRANSFER(cont[22..25], REAL4);
	END;
	
	EXPORT DATASET(mTypes.layout_range) getDataset(STRING topic) := FUNCTION
		logical_path := '~robotics::range::' + topic;
		rawDataset := dataset(logical_path, mTypes.layout_raw, FLAT);
		transformed := project(rawDataset, convert(LEFT));
		RETURN transformed;
	END;
	
	EXPORT RangeByTimestamp(STRING topic) := FUNCTION
		dset := DATASET(
			'~robotics::out::range::' + topic,
			{mTypes.layout_range, UNSIGNED8 fpos {virtual(fileposition)}},
			THOR
		);
		range_index := INDEX(
			dset,
			{timestamp_e6, fpos},
			{radiation_type, field_of_view, min_range, max_range, reading},
			'~robotics::out::range::' + topic + '_RangeByTimestamp'
		);
		RETURN range_index;
	END;
	
	EXPORT constructIndex(STRING topic) := FUNCTION
		RETURN BUILDINDEX(RangeByTimestamp(topic), OVERWRITE);
	END;
END;