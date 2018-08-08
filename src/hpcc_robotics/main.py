#!/usr/bin/env python
from collections import namedtuple
from functools import partial
import os
from os import path

import rospy
from sensor_msgs.msg import CompressedImage
from sensor_msgs.msg import Image
from sensor_msgs.msg import Imu
from sensor_msgs.msg import LaserScan
from sensor_msgs.msg import NavSatFix
from sensor_msgs.msg import Range
from sensor_msgs.msg import Temperature
from nav_msgs.msg import OccupancyGrid
from nav_msgs.msg import Odometry

from .context import LimitedWriter
from .callbacks import *


OUTPUT_DIR = '~output_directory'
SensorLog = namedtuple('SensorLog', (
  'callback_function',
  'parameter_name',
  'message_class',
))
# Contains information about each of the types of messages being recorded
MSG_INFO = (
  SensorLog(gnss_callback, '~gnss', NavSatFix),
  SensorLog(image_callback, '~image', Image),
  SensorLog(laserscan_callback, '~laserscan', LaserScan),
  SensorLog(odometry_callback, '~odometry', Odometry),
  SensorLog(imu_callback, '~imu', Imu),
  SensorLog(map_callback, '~occupancygrid', OccupancyGrid),
  SensorLog(range_callback, '~range', Range),
  SensorLog(temperature_callback, '~temperature', Temperature),
  SensorLog(compressedimage_callback, '~compressedimage', CompressedImage)
)


def validate_path(directory):
  if not path.exists(directory):
    rospy.loginfo('Creating output directory %s', str(directory))
    os.makedirs(directory)
    return True
  else:
    if path.isdir(directory):
      rospy.loginfo('Using existing output directory %s', str(directory))
      return True
  return False


def add_logger(output_dir, callback_function, parameter, message_type):
  if not rospy.has_param(parameter):
    rospy.logwarn('Missing parameter {}'
      .format(rospy.resolve_name(parameter)))
    return

  param_dict = rospy.get_param(parameter)
  resolved = rospy.resolve_name(parameter)

  if 'enabled' not in param_dict:
    rospy.logwarn('Missing parameter {}/enabled'.format(resolved))
    return
  if not param_dict['enabled']:
    return

  if 'topics' not in param_dict:
    rospy.logwarn('Missing parameter {}/topics'.format(resolved))
    return
  topics = param_dict['topics']

  split_files = False
  if 'split' not in param_dict:
    rospy.logwarn('Missing parameter {}/split'.format(resolved))
  else:
    split_files = param_dict['split']

  split_size = 2147483648
  if 'filesize' not in param_dict:
    rospy.logwarn('Missing parameter: {}/filesize'.format(resolved))
  else:
    split_size = param_dict['filesize']

  subscribers = list()

  for topic in topics.split(','):
    topic = topic.strip()
    if len(topic) <= 1:
      continue
    filename = topic[1:].replace('/', '_')
    if split_files:
      ctx = LimitedWriter(path.join(output_dir, filename), 'wb', split_size * (2**20))
    else:
      ctx = open(path.join(output_dir, filename), 'wb')
    part = partial(callback_function, ctx)
    subscribers.append(rospy.Subscriber(topic, message_type, part))

  return subscribers


def run():
  rospy.init_node('hpcc_robotics')
  if not rospy.has_param(OUTPUT_DIR):
    rospy.logerr('No parameter for output directory')
    rospy.signal_shutdown('No output directory to write to')
    return
  output_dir = path.abspath(rospy.get_param(OUTPUT_DIR))
  if not validate_path(output_dir):
    rospy.logerr('Invalid output directory')
    rospy.signal_shutdown('No output directory to write to')
    return

  for callback_tuple in MSG_INFO:
    add_logger(output_dir, *callback_tuple)

  rospy.spin()
