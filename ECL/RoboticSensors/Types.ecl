IMPORT PBblas.Internal.Types AS iTypes;

EXPORT Types := MODULE
	EXPORT layout_raw := RECORD
		DATA content;
	END;

	EXPORT layout_gnss := RECORD
		UNSIGNED8 timestamp_e6;  // Multiplied by 10^6
		REAL latitude;
		REAL longitude;
		REAL altitude;
		iTypes.matrix_t coordinate_covariance;
		UNSIGNED1 covariance_type;
		INTEGER1 status;
		UNSIGNED2 service_;
	END;
	
	EXPORT layout_image := RECORD
		UNSIGNED8 timestamp_e6;
		UNSIGNED4 image_height;
		UNSIGNED4 image_width;
		STRING image_encoding;
		UNSIGNED1 is_bigendian;
		UNSIGNED4 row_length;
		DATA image_data;
	END;
	
	EXPORT layout_laserscan := RECORD
		UNSIGNED8 timestamp_e6;
		REAL4 angle_min;
		REAL4 angle_max;
		REAL4 angle_increment;
		REAL4 scan_time;
		REAL4 range_min;
		REAL4 range_max;
		SET OF REAL4 ranges;
		SET OF REAL4 intensities;
	END;
	
	EXPORT layout_odometry := RECORD
		UNSIGNED8 timestamp_e6;
		iTypes.matrix_t position;
		iTypes.matrix_t orientation;
		iTypes.matrix_t pose_covariance;
		iTypes.matrix_t linear_velocity;
		iTypes.matrix_t angular_velocity;
		iTypes.matrix_t twist_covariance;
	END;
	
	EXPORT layout_imu := RECORD
		UNSIGNED8 timestamp_e6;
		iTypes.matrix_t orientation;
		iTypes.matrix_t orientation_covariance;
		iTypes.matrix_t angular_velocity;
		iTypes.matrix_t angular_velocity_covariance;
		iTypes.matrix_t linear_acceleration;
		iTypes.matrix_t linear_acceleration_covariance;
	END;
	
	EXPORT layout_occupancygrid := RECORD
		UNSIGNED8 timestamp_e6;
		UNSIGNED8 map_load_time_e6;
		REAL4 resolution;
		UNSIGNED4 grid_width;
		UNSIGNED4 grid_height;
		iTypes.matrix_t origin_position;
		iTypes.matrix_t origin_orientation;
		SET OF INTEGER1 grid_data;
	END;
	
	EXPORT layout_range := RECORD
		UNSIGNED8 timestamp_e6;
		UNSIGNED1 radiation_type;
		REAL4 field_of_view;
		REAL4 min_range;
		REAL4 max_range;
		REAL4 reading;
	END;
	
	EXPORT layout_temperature := RECORD
		UNSIGNED8 timestamp_e6;
		REAL temperature;
		REAL sensor_variance;
	END;
	
	EXPORT layout_compressedimage := RECORD
		UNSIGNED8 timestamp_e6;
		STRING image_format;
		DATA image_data;
	END;
END;