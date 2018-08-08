IMPORT $.^ as RoboticSensors;
IMPORT RoboticSensors.Types AS mTypes;
IMPORT RoboticSensors.Utils AS mUtils;

EXPORT CompressedImage := MODULE
	EXPORT mTypes.layout_compressedimage convert(mTypes.layout_raw raw) := TRANSFORM
		DATA cont := raw.content;
		SELF.timestamp_e6 := (UNSIGNED8) (TRANSFER(cont[1..8], REAL) * 1000000);
		formLen := TRANSFER(cont[9..12], UNSIGNED4); // Length of the format string
		// dataLen := TRANSFER(cont[13..16], UNSIGNED4); // Length of the image data
		SELF.image_format := mUtils.toString(cont[17..16 + formLen]);
		SELF.image_data := cont[17 + formLen..];
	END;
	
	EXPORT DATASET(mTypes.layout_compressedimage) getDataset(STRING topic) := FUNCTION
		logical_path := '~robotics::compressedimage:' + topic;
		rawDataset := dataset(logical_path, mTypes.layout_raw, FLAT);
		transformed := project(rawDataset, convert(LEFT));
		RETURN transformed;
	END;
	
	EXPORT CompressedImageByTimestamp(STRING topic) := FUNCTION
		dset := DATASET(
			'~robotics::out::compressedimage::' + topic,
			{mTypes.layout_compressedimage, UNSIGNED8 fpos {virtual(fileposition)}},
			THOR
		);
		compressedimage_index := INDEX(
			dset,
			{timestamp_e6, fpos},
			{},
			'~robotics::out::compressedimage::' + topic 
				+ '_CompressedImageByTimestamp'
		);
		RETURN compressedimage_index;
	END;
	
	EXPORT constructIndex(STRING topic) := FUNCTION
		RETURN BUILDINDEX(CompressedImageByTimestamp(topic), OVERWRITE);
	END;
END;