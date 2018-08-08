IMPORT $.^ as RoboticSensors;
IMPORT RoboticSensors.Types AS mTypes;
IMPORT RoboticSensors.Utils AS mUtils;

EXPORT Image := MODULE
	EXPORT mTypes.layout_image convert(mTypes.layout_raw raw) := TRANSFORM
		DATA cont := raw.content;
		SELF.timestamp_e6 := (UNSIGNED8) (TRANSFER(cont[1..8], REAL) * 1000000);
		SELF.image_height := TRANSFER(cont[9..12], UNSIGNED4);
		SELF.image_width := TRANSFER(cont[13..16], UNSIGNED4);
		SELF.is_bigendian := TRANSFER(cont[17], UNSIGNED1);
		SELF.row_length := TRANSFER(cont[18..21], UNSIGNED4);
		encLen := TRANSFER(cont[22..25], UNSIGNED4); // Length of the encoding string
		SELF.image_encoding := mUtils.toString(cont[26..25+encLen]);
		SELF.image_data := cont[26+encLen..];
	END;
	
	EXPORT DATASET(mTypes.layout_image) getDataset(STRING topic) := FUNCTION
		logical_path := '~robotics::image::' + topic;
		rawDataset := dataset(logical_path, mTypes.layout_raw, FLAT);
		transformed := project(rawDataset, convert(LEFT));
		RETURN transformed;
	END;
	
	EXPORT ImageByTimestamp(STRING topic) := FUNCTION
		dset := DATASET(
			'~robotics::out::image::' + topic,
			{mTypes.layout_image, UNSIGNED8 fpos {virtual(fileposition)}},
			THOR
		);
		image_index := INDEX(
			dset,
			{timestamp_e6, fpos},
			{image_height, image_width, is_bigendian, row_length,
			 image_encoding, image_data},
			'~robotics::out::image::' + topic + '_ImageByTimestamp'
		);
		RETURN image_index;
	END;
	
	EXPORT constructIndex(STRING topic) := FUNCTION
		RETURN BUILDINDEX(ImageByTimestamp(topic), OVERWRITE);
	END;
END;