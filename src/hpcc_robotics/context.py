""" This modules defines a class that allows for the segmentation of
files written in realtime.
"""

class LimitedWriter(object):
  """ A class that imitates a file context, but creates a new file when
  the number of bytes written to the file exceeds a given amount.
  """
  def __init__(self, path, mode='wb', max_filesize=2147483648):
    self.index = 0
    self.bytes_written = 0
    self.max_filesize = max_filesize
    self.mode = mode
    self.original_path = path
    self.context = open(path, mode)

  def write(self, data):
    """ Writes to the file and checks byte count. Files are guaranteed
    to be smaller than or equal to the size limit.
    """
    self.bytes_written += len(data)
    if self.bytes_written > self.max_filesize:
      self.bytes_written = 0
      self.context.close()
      # This should make the first 'extra' file have a (1) at the end
      self.index += 1
      new_path = '{}-({})'.format(self.original_path, self.index)
      self.context = open(new_path, self.mode)
    self.context.write(data)