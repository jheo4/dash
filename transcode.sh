MYDIR=$(pwd)
INPUTDIR=$(pwd)"/Inputs"
OUTPUTDIR=$(pwd)"/Outputs"

source $(pwd)"/audio.sh"
source $(pwd)"/do_transcode.sh"

if [ -z "$MYDIR/bin/ffmpeg" ]; then
  echo "No ffmpeg..."
  exit 1
fi

if [ -z "$(which MP4Box)" ]; then
  echo "No MP4Box..."
  exit 1
fi

MP4_FILES=$(find ./Inputs/ -type f \( -name "*.mp4" \))
for f in $MP4_FILES
do
  input_file=$(basename "$f")
  file_name="${input_file%.*}" # FN without extension: "${FNext%.*}"
                               # extension from FN.ext "${FNext##*.}"

  echo "$file_name"
  if [ ! -d "$OUTPUTDIR/${file_name}" ]; then # -d DIR: test there is the directory
    mkdir "$OUTPUTDIR/${file_name}"
  fi

  echo "$file_name"

  # Audio
  # encode_audio INPUT OUTPUT CODEC BITRATE CONTAINER
  encode_audio "$INPUTDIR/${input_file}" \
    "$OUTPUTDIR/${file_name}/${file_name}" "aac" "192k" "m4a"

  # Video
  # do_transcode INPUT OUTPUT CODEC RESOLUTION BITRATE CONTAINER
  resolution=("480" "720" "1080" "4k")
  codecs=("libx264" "libx265" "libvpx-vp9")
  for cod in ${codecs[*]}; do
    for res in ${resolution[*]}; do
      output="$OUTPUTDIR/${file_name}/$cod/${file_name}"
      if [ $resolution = "480" ]; then
        br="400k"
      elif [ $resolution="720" ]; then
        br="1200k"
      elif [ $resolution="1080" ]; then
        br="4000k"
      elif [ $resolution="4k"] || [ $resolution="4K" ]; then
        br="8000k"
      fi
      do_transcode "$INPUTDIR/${input_file}" "$output" "$cod" "$res" "$br"\
        "mp4"
    done
    # Mp4Box

  done

done
