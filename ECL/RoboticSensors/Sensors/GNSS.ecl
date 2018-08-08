IMPORT $.^ as RoboticSensors;
IMPORT RoboticSensors.Types AS mTypes;
IMPORT RoboticSensors.Utils AS mUtils;

EXPORT GNSS := MODULE

	EXPORT mTypes.layout_gnss convert(mTypes.layout_raw raw) := TRANSFORM
		// First 13 entries are doubles
		cont := raw.content;
		position := mUtils.castToDoubleArray(cont[1..32]);
		SELF.timestamp_e6 := (UNSIGNED8) (position[1] * 1000000);
		SELF.latitude := position[2];
		SELF.longitude := position[3];
		SELF.altitude := position[4];
		SELF.coordinate_covariance := mUtils.doubleToMatrix(3, 3, cont[33..8*13]);
		SELF.covariance_type := TRANSFER(cont[105], UNSIGNED1);
		SELF.status := TRANSFER(cont[106], INTEGER1);
		SELF.service_ := TRANSFER(cont[107 .. 108], UNSIGNED2);
	END;

	EXPORT DATASET(mTypes.layout_gnss) getDataset(STRING topic) := FUNCTION
		logical_path := '~robotics::gnss::' + topic;
		rawDataset := DATASET(logical_path, mTypes.layout_raw, FLAT);
		transformed := PROJECT(rawDataset, convert(LEFT));
		RETURN transformed;
	END;
	
	EXPORT GNSSByTimestamp(STRING topic) := FUNCTION
		dset := DATASET(
			'~robotics::out::gnss::' + topic,
			{mTypes.layout_gnss, UNSIGNED8 fpos {virtual(fileposition)}},
			THOR
		);
		gnss_index := INDEX(
			dset,
			{timestamp_e6, fpos},
			{latitude, longitude, altitude, coordinate_covariance, covariance_type,
			 status, service_},
			'~robotics::out::gnss::' + topic + '_GNSSByTimestamp'
		);
		RETURN gnss_index;
	END;
	
	EXPORT constructIndex(STRING topic) := FUNCTION
		RETURN BUILDINDEX(GNSSByTimestamp(topic), OVERWRITE);
	END;
END;