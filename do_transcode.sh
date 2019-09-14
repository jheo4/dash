do_transcode() {
  # $1: dir/input
  # $2: dir/output
  # $3: codec
  # $4: resolution
  # $5: bitrate
  input=$1
  output=$2
  codec=$3
  resolution=$4
  bitrate=$5
  container=$6

  echo "Video Encoding"
  echo "Input: $input"
  echo "Output: $output"
  echo "Codec: $codec"
  echo "Resolution: $resolution"
  echo "Bitrate: $bitrate"
  echo "container: $container"

  # resolution
  # 480: 720*480
  # 720: 1280*720
  # 1080: 1920*1080
  # 4K: 3840*2160
  if [ $resolution = "480" ]; then
    target_res="720x480"
  elif [ $resolution="720" ]; then
    target_res="1280x720"
  elif [ $resolution="1080" ]; then
    target_res="1920x1080"
  elif [ $resolution="4k"] || [ $resolution="4K" ]; then
    target_res="3840x2160"
  else
    echo "invalid resolution..."
    exit 1
  fi

  ./bin/ffmpeg -y -i "$input" -preset medium -an -c:v $codec \
    -b:v $bitrate -s $target_res \
    -f "$container" $output"_$resolution.$container"
}
