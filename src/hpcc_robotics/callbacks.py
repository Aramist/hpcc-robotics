"""Module containing callback methods for all message types being recorded."""
from struct import pack

def convert(data):
  """Creates a bytearray from a list of tuples
  Each tuple in the list gives a datatype and a value
  """
  return_val = b''
  for entry in data:
    return_val += pack(*entry)
  return return_val


def gnss_callback(file_ctx, data):
  info = [
    ('d', data.header.stamp.to_sec()),  # Timestamp
    # Latitude, in degrees, returned by the sensor
    ('d', data.latitude),
    # Longitude, in degrees, returned by the sensor
    ('d', data.longitude),
    # Altitude, in meters above WGS84, returned by the sensor
    ('d', data.altitude)
  ]
  # This turns the covariance into a list of tuples of the form ('d', float)
  info.extend([('d', cov) for cov in data.position_covariance])
  info.extend([
    ('B', data.position_covariance_type),  # uint8_t
    ('b', data.status.status),  # int8_t
    ('H', data.status.service)  # uint16_t
  ])
  converted = convert(info)
  length = pack('I', len(converted))
  file_ctx.write(length + converted)


def image_callback(file_ctx, data):
  info = [
    ('d', data.header.stamp.to_sec()),  # Timestamp
    # Image height, in pixels
    ('I', data.height),
    # Image width, in pixels
    ('I', data.width),
    # Boolean byte that is true (1) when the image data is big-endian, otherwise false (0)
    ('B', data.is_bigendian),
    # The length, in bytes, of one row of pixels in the image
    ('I', data.step),
    # Length of the string containing the image's encoding
    ('I', len(data.encoding))
  ]

  converted = convert(info)
  # String containing the image's encoding
  encoding = bytearray(data.encoding)
  # Uncompressed image data
  image_data = bytearray(data.data)
  length = len(image_data) + len(encoding) + len(converted)
  length = pack('I', length)
  file_ctx.write(length + converted + encoding + image_data)


def laserscan_callback(file_ctx, data):
  info = [
    ('d', data.header.stamp.to_sec()),
    # The angle, in radians, of the first measurement in the scan
    ('f', data.angle_min),
    # The angle, in radians, of the last measurement in the scan
    ('f', data.angle_max),
    # The difference between the angles of two consecutive scans
    ('f', data.angle_increment),
    # The amount of time elapsed between two successive measurements in a scan
    ('f', data.scan_time),
    # The minimum range of the sensor
    ('f', data.range_min),
    # The maximum range of the sensor
    ('f', data.range_max),
    # The number of measurements in the scan (helper variable)
    ('I', len(data.ranges))
  ]
  # All of the measurements in the scan
  info.extend([('f', r) for r in data.ranges])
  # Intensities for each measurement, meaning is implementation specific
  info.extend([('f', i) for i in data.intensities])

  converted = convert(info)
  length = len(converted)
  length = pack('I', length)
  file_ctx.write(length + converted)


def odometry_callback(file_ctx, data):
  info = [
    ('d', data.header.stamp.to_sec())
  ]
  pose = data.pose.pose
  pose_cov = data.pose.covariance
  twist = data.twist.twist
  twist_cov = data.twist.covariance
  # 3 doubles, position vector
  info.extend([('d', p) for p in pose.position])
  # 4 doubles, orientation quaternion
  info.extend([('d', o) for o in pose.orientation])
  # 36 doubles, position and orientation covariance
  info.extend([('d', c) for c in pose_cov])
  # 3 doubles, linear velocity vector
  info.extend([('d', v) for v in twist.linear])
  # 3 doubles, angular velocity vector
  info.extend([('d', w) for w in twist.angular])
  # 36 doubles, twist covariance matrix
  info.extend([('d', c) for c in twist_cov])

  converted = convert(info)
  length = len(converted)
  length = pack('I', length)
  file_ctx.write(length + converted)


def imu_callback(file_ctx, data):
  info = [
    ('d', data.header.stamp.to_sec())
  ]
  orientation = data.orientation
  orientation = (orientation.x, orientation.y, orientation.z, orientation.w)
  ocov = data.orientation_covariance
  angular = data.angular_velocity
  angular = (angular.x, angular.y, angular.z)
  acov = data.angular_velocity_covariance
  accel = data.linear_acceleration
  accel = (accel.x, accel.y, accel.z)
  lcov = data.linear_acceleration_covariance

  # Orientation quaternion and covariance (about x, y, and z axes)
  info.extend([('d', quat) for quat in orientation])
  info.extend([('d', qcov) for qcov in ocov])
  # Angular velocity and covariance
  info.extend([('d', ang) for ang in angular])
  info.extend([('d', ang_cov) for ang_cov in acov])
  # Linear acceleration and covariance
  info.extend([('d', lin) for lin in accel])
  info.extend([('d', lin_cov) for lin_cov in lcov])

  converted = convert(info)
  length = len(converted)
  length = pack('I', length)
  file_ctx.write(length + converted)


def map_callback(file_ctx, data):
  info = [
    ('d', data.header.stamp.to_sec())
  ]

  metadata = data.info

  info.extend([
    # The time at which the map was loaded
    ('d', metadata.map_load_time.to_sec()),
    # The resolution of the map (cell side length in meters)
    ('f', metadata.resolution),
    # Width of the map (in cells)
    ('I', metadata.width),
    # Height of the map (in cells)
    ('I', metadata.height)
  ])

  # Real world position of the map's origin (Point)
  o_pos = metadata.origin.position
  o_pos = (o_pos.x, o_pos.y, o_pos.z)
  # Real world orientation of the map's origin (Quaternion)
  o_qua = metadata.origin.orientation
  o_qua = (o_qua.x, o_qua.y, o_qua.z, o_qua.w)

  info.extend([('d', pos) for pos in o_pos])
  info.extend([('d', qua) for qua in o_qua])

  # A row-major list of unsigned bytes giving the map's values.
  # Values are probabilities (between 0 and 100) with -1 representing unknown
  info.extend([('b', cell) for cell in data.data])

  converted = convert(info)
  length = len(converted)
  length = pack('I', length)
  file_ctx.write(length + converted)


def range_callback(file_ctx, data):
  info = [
    ('d', data.header.stamp.to_sec()),
    # The type of radiation used by the sensor. 0 for ultrasound and 1 for infrared.
    # Any other values are not formally defined.
    ('B', data.radiation_type),
    # The width, in radians, of the sensors field of view (typically a cone)
    ('f', data.field_of_view),
    # The minimum range of the sensor
    ('f', data.min_range),
    # The maximum range of the sensor
    ('f', data.max_range),
    # The range returned by the sensor
    ('f', data.range)
  ]

  converted = convert(info)
  length = len(converted)
  length = pack('I', length)
  file_ctx.write(length + converted)


def temperature_callback(file_ctx, data):
  info = [
    ('d', data.header.stamp.to_sec()),
    # Temperature recorded, in Celsius
    ('d', data.temperature),
    # Variance of thermometer, 0 represents an unknown variance
    ('d', data.variance)
  ]

  converted = convert(info)
  length = len(converted)
  length = pack('I', length)
  file_ctx.write(length + converted)


def compressedimage_callback(file_ctx, data):
  info = [
    ('d', data.header.stamp.to_sec())
  ]

  # Format of the image: either 'png' or 'jpeg'
  format_barray = bytearray(data.format)

  # Length of image format string (in bytes)
  info.append(('I', len(format_barray)))

  # Compressed image data
  data_barray = bytearray(data.data)

  # Length of compressed image data
  info.append(('I', len(data_barray)))

  converted = convert(info)
  length = len(converted) + len(format_barray) + len(data_barray)
  length = pack('I', length)
  file_ctx.write(length + converted + format_barray + data_barray)