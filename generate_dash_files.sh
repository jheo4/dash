# $1: output, ./Outputs/file_name /codec/file_name_resolution.container
# $2: file_name
# $3: codec
# $4: resolutions
# $5: container
generate_dash_files(){
  out=$1
  fn=$2
  codec=$3
  resolutions=$4
  container=$5

  for i in `seq 0 $((${#resolutions[@]}-1))`; do
    input[i]=$out/$fn/$codec/$fn"_"${resolutions[$i]}"."$container
  done


  if [ $container="mp4" ]; then
    ./bin/ffmpeg -y -re \
      -i ${input[0]} \
      -i ${input[1]} \
      -i ${input[2]} \
      -i ${input[3]} \
      -i $out"/"$fn"/"$fn"_audio.m4a" \
      -map 0 -map 1 -map 2 -map 3 -map 4 -c copy \
      -use_timeline 1 -use_template 1 -window_size 20 -seg_duration 10 \
      -init_seg_name '$RepresentationID$-init.m4s' \
      -media_seg_name '$RepresentationID$-$Time$,m4s' \
      -adaptation_sets "id=0,streams=0,1,2,3 id=1,streams=4" \
      -f dash $out"/"$fn"/"$codec"/"$codec".mpd"

    #MP4Box -dash-strict 2000 -rap -frag-rap  -bs-switching no \
    #  -profile "dashavc264:live"\
    #  "${input[0]}" "${input[1]}" "${input[2]}" "${input[3]}" \
    #  $out"/"$fn"/"$fn"_audio.m4a" -out $out"/"$fn"/"$codec"/"$codec".mpd"

  elif [ $container="webm" ]; then
    ./bin/ffmpeg \
      -f webm_dash_manifest -i ${input[0]} \
      -f webm_dash_manifest -i ${input[1]} \
      -f webm_dash_manifest -i ${input[2]} \
      -f webm_dash_manifest -i ${input[3]} \
      -f webm_dash_manifest -i $out"/"$fn"/"$fn"_audio.m4a" \
      -c copy -map 0 -map 1 -map 2 -map 3 -map 4 \
      -f webm_dash_manifest \
      -adaptation_sets "id=0,streams=0,1,2,3 id=4,streams=1" \
      $out"/"$fn"/"$codec"/"$codec".mpd"
  fi
}

