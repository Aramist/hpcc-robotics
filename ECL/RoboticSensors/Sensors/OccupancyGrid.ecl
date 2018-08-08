IMPORT $.^ as RoboticSensors;
IMPORT RoboticSensors.Types AS mTypes;
IMPORT RoboticSensors.Utils AS mUtils;

EXPORT OccupancyGrid := MODULE
	EXPORT mTypes.layout_occupancygrid convert(mTypes.layout_raw raw) := TRANSFORM
		DATA cont := raw.content;
		times := mUtils.castToDoubleArray(cont[1..16]);
		SELF.timestamp_e6 := (UNSIGNED8) (times[1] * 1000000);
		SELF.map_load_time_e6 := (UNSIGNED8) (times[1] * 1000000);
		SELF.resolution := TRANSFER(cont[17..20], REAL4);
		SELF.grid_width := TRANSFER(cont[21..24], UNSIGNED4);
		SELF.grid_height := TRANSFER(cont[25..28], UNSIGNED4);
		origin_pose := mUtils.castToDoubleArray(cont[29..84]);
		SELF.origin_position := origin_pose[1..3];
		SELF.origin_orientation := origin_pose[4..];
		SELF.grid_data := mUtils.castToByteArray(cont[85..]);
	END;
	
	EXPORT DATASET(mTypes.layout_occupancygrid) getDataset(STRING topic) := FUNCTION
		logical_path := '~robotics::grid::' + topic;
		rawDataset := dataset(logical_path, mTypes.layout_raw, FLAT);
		transformed := project(rawDataset, convert(LEFT));
		RETURN transformed;
	END;
	
	EXPORT GridByTimestamp(STRING topic) := FUNCTION
		dset := DATASET(
			'~robotics::out::grid::' + topic,
			{mTypes.layout_occupancygrid, UNSIGNED8 fpos {virtual(fileposition)}},
			THOR
		);
		grid_index := INDEX(
			dset,
			{timestamp_e6, fpos},
			{map_load_time_e6, resolution, grid_width, grid_height, origin_position,
			origin_orientation, grid_data},
			'~robotics::out::grid::' + topic + '_GridByTimestamp'
		);
		RETURN grid_index;
	END;
	
	EXPORT constructIndex(STRING topic) := FUNCTION
		RETURN BUILDINDEX(GridByTimestamp(topic), OVERWRITE);
	END;
END;