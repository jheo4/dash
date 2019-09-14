encode_audio(){
  # $1: dir/input
  # $2: dir/output
  # $3: codec
  # $4: bitrate
  input=$1
  output=$2
  codec=$3
  bitrate=$4
  container=$5

  echo "Encode Audio..."
  echo "Input: $input"
  echo "Output: $output"
  echo "Codec: $codec"
  echo "Bitrate: $bitrate"
  echo "Container: $container"

  ./bin/ffmpeg -y -i $input -c:a "$codec" -b:a "$bitrate" -vn\
    $output"_audio."$container
}
