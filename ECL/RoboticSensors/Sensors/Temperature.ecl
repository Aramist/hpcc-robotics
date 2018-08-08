IMPORT $.^ as RoboticSensors;
IMPORT RoboticSensors.Types AS mTypes;
IMPORT RoboticSensors.Utils AS mUtils;

EXPORT Temperature := MODULE
	EXPORT mTypes.layout_temperature convert(mTypes.layout_raw raw) := TRANSFORM
		DATA cont := raw.content;
		content := mUtils.castToDoubleArray(cont);
		SELF.timestamp_e6 := (UNSIGNED8) (content[1] * 1000000);
		SELF.temperature := content[2];
		SELF.sensor_variance := content[3];
	END;
	
	EXPORT DATASET(mTypes.layout_temperature) getDataset(STRING topic) := FUNCTION
		logical_path := '~robotics::temperature::' + topic;
		rawDataset := dataset(logical_path, mTypes.layout_raw, FLAT);
		transformed := project(rawDataset, convert(LEFT));
		RETURN transformed;
	END;
	
	EXPORT TemperatureByTimestamp(STRING topic) := FUNCTION
		dset := DATASET(
			'~robotics::out::temperature::' + topic,
			{mTypes.layout_temperature, UNSIGNED8 fpos {virtual(fileposition)}},
			THOR
		);
		temperature_index := INDEX(
			dset,
			{timestamp_e6, fpos},
			{temperature, sensor_variance},
			'~robotics::out::temperature::' + topic + '_TemperatureByTimestamp'
		);
		RETURN temperature_index;
	END;
	
	EXPORT constructIndex(STRING topic) := FUNCTION
		RETURN BUILDINDEX(TemperatureByTimestamp(topic), OVERWRITE);
	END;
END;