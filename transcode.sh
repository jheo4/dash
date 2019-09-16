MYDIR=$(pwd)
INPUTDIR=$(pwd)"/Inputs"
OUTPUTDIR=$(pwd)"/Outputs"

source $(pwd)"/audio.sh"
source $(pwd)"/do_transcode.sh"
source $(pwd)"/generate_dash_files.sh"

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
  resolutions=("480" "720" "1080" "4k")
  codecs=("libx264" "mpeg4" "libvpx-vp9")

  #resolutions=("480")
  #codecs=("libvpx-vp9")

  for cod in ${codecs[*]}; do
    if [ ! -d "$OUTPUTDIR/${file_name}/$cod" ]; then
      mkdir "$OUTPUTDIR/${file_name}/$cod"
    fi

    if [ $cod = "libvpx-vp9" ]; then
      container="webm"
    else
      container="mp4"
    fi

    output="$OUTPUTDIR/${file_name}/$cod/${file_name}"

    for res in ${resolutions[*]}; do
      if [ $res = "480" ]; then
        br="400k"
      elif [ $res = "720" ]; then
        br="1200k"
      elif [ $res = "1080" ]; then
        br="4M"
      elif [ $res = "4k" ]; then
        br="8M"
      fi
      #do_transcode "$INPUTDIR/${input_file}" "$output" "$cod" "$res" "$br"\
      #  "$container"
    done

    # generate_dash_files OUTPUTDIR FN CODEC RESOLUTIONS CONTAINER
    generate_dash_files "$OUTPUTDIR" "${file_name}" "$cod" "$resolutions"\
      "$container"
  done

done
