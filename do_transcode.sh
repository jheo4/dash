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
  if [ $resolution = "480" ]; then
    target_res="720x480"
  elif [ $resolution = "720" ]; then
    target_res="1280x720"
  elif [ $resolution = "1080" ]; then
    target_res="1920x1080"
  elif [ $resolution = "4k" ]; then
    target_res="3840x2160"
  else
    echo "invalid resolution..."
    exit 1
  fi

  ./bin/ffmpeg -y -i "$input" -threads 4 -preset fast -an -c:v $codec \
    -s $target_res -b:v $bitrate \
    -f "$container" $output"_"$resolution"."$container
}
