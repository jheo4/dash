import os
import re
import subprocess


class FFmpeg_Manager:
  __instance = None
  ffmpeg = None
  ffprobe = None
  input_dir = None
  output_dir = None


  @staticmethod
  def get_instance():
    if FFmpeg_Manager.__instance is None:
      FFmpeg_Manager.__instance = FFmpeg_Manager()
    return FFmpeg_Manager.__instance


  def __init__(self):
    if FFmpeg_Manager.__instance is not None:
      raise Exception("Singleton violation")


  def set_dirs(self, input_dir, output_dir):
    self.input_dir = input_dir
    self.output_dir = output_dir


  def set_ffmpeg(self, dash_dir):
    self.ffmpeg = os.path.join(dash_dir, "bin/ffmpeg")
    self.ffprobe = os.path.join(dash_dir, "bin/ffprobe")
    if (os.path.isfile(self.ffmpeg) is not True):
      raise Exception("No ffmpeg")

    if (os.path.isfile(self.ffprobe) is not True):
      raise Exception("No ffprobe")


  def get_ffmpeg(self):
    return self.ffmpeg


  def get_ffprobe(self):
    return self.ffprobe

  
  def create_target_dir(self, input_fn, codec):
    if not os.path.exists(self.output_dir):
      os.makedirs(self.output_dir)

    target_dir = os.path.join(self.output_dir, input_fn)
    if not os.path.exists(target_dir):
      os.makedirs(target_dir)

    target_dir = os.path.join(target_dir, codec)
    if not os.path.exists(target_dir):
      os.makedirs(target_dir)

    return target_dir


  def get_video_info(self, video):
    command = [self.ffprobe, os.path.join(self.input_dir, video),
        "-select_streams","v","-print_format","flat","-show_entries",
        "stream=r_frame_rate,width,height,bit_rate"]

    output = subprocess.check_output(command).decode('utf-8')

    width = re.search("width=[0-9]+", output)
    width = int(width[0].split("=")[1])

    height = re.search("height=[0-9]+", output)
    height = int(height[0].split("=")[1])

    framerate = re.search("frame_rate=\"[0-9]+", output)
    framerate = int(framerate[0].split("\"")[1])

    bitrate = re.search("bit_rate=\"[0-9]+", output)
    bitrate = int(bitrate[0].split("\"")[1])

    return width, height, framerate, bitrate


  def get_variants_lists(self, width, height, framerate, bitrate):
    resolutions = []
    bitrates = []
    bitrate = int(bitrate)

    if(height >= 480):
      resolutions.append("720x480")
      if(bitrate > 400000):
        bitrates.append("400000")
      else:
        bitrates.append(str(bitrate))

    if(height >= 720):
      resolutions.append("1280x720")
      if(bitrate > 1200000):
        bitrates.append("1200000")
      else:
        bitrates.append(str(bitrate))

    if(height >= 1080):
      resolutions.append("1920x1080")
      if(bitrate > 4000000):
        bitrates.append("4000000")
      else:
        bitrates.append(str(bitrate))

    if(height >= 2160):
      resolutions.append("3840x2160")
      if(bitrate > 8000000):
        bitrates.append("8000000")
      else:
        bitrates.append(str(bitrate))

    return resolutions, bitrates


  def transcode(self, codec, container):
    # static video
    input_videos = (video for video in os.listdir(self.input_dir))

    # bitrates
    for input_video in input_videos:
      input_fn = input_video.split('.')[0]
      target_dir = self.create_target_dir(input_fn, codec)

      width, height, framerate, bitrate = self.get_video_info(input_video)
      resolutions, bitrates = self.get_variants_lists(width, height, framerate,
          bitrate)

      for resolution, bitrate in zip(resolutions, bitrates):
        output_fn = resolution + "." + container
        target_output = os.path.join(target_dir, output_fn)
        command = [self.ffmpeg, "-y", "-i",
            os.path.join(self.input_dir, input_video), "-threads", "4",
            "-preset", "fast", "-an", "-c:v", codec, "-s", resolution, "-b:v",
            bitrate, "-f", container, target_output]
        subprocess.run(command)

