import argparse
import os
import re
import subprocess
import FFmpeg_Manager as fm
from timeit import default_timer as tm


if __name__ == "__main__":
  arg_parser = argparse.ArgumentParser(description="This program generates\
      dash files.")
  arg_parser.add_argument("INPUT", type=str, help="dir/input_filename")
  arg_parser.add_argument("OUTPUT_DIR", type=str, help="output_dir")
  arg_parser.add_argument("CODEC", type=str,
      help="codecs(mpeg4/libx264/libvpx-vp9)")
  arg_parser.add_argument("CONTAINER", type=str, help="mp4")

  args = arg_parser.parse_args()

  cur_dir = os.getenv("DASH_DIR")

  # set ffmpeg
  ffmpeg_manager = fm.FFmpeg_Manager.get_instance()
  ffmpeg_manager.set_ffmpeg(cur_dir)
  print(ffmpeg_manager.get_ffmpeg())
  ffmpeg_manager.set_dirs(os.path.join(cur_dir, args.INPUT),
      os.path.join(cur_dir, args.OUTPUT_DIR))

  # transcode...
  ffmpeg_manager.transcode(codec=args.CODEC, container=args.CONTAINER)

  # generate dash files...
