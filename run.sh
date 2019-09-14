./bin/ffmpeg -i Samples/panasonic.vid -c:v libvpx-vp9 -s 160x90 -b:v 250k -keyint_min 150 -g 150 -an -f webm -dash 1 Outputs/vp9_video_160x90_250k.webm &&
./bin/ffmpeg -i Samples/panasonic.vid -c:v libvpx-vp9 -s 320x180 -b:v 500k -keyint_min 150 -g 150 -an -f webm -dash 1 Outputs/vp9_video_320x180_500k.webm &&
./bin/ffmpeg -i Samples/panasonic.vid -c:v libvpx-vp9 -s 640x360 -b:v 750k -keyint_min 150 -g 150 -an -f webm -dash 1 Outputs/vp9_video_640x360_750k.webm &&
./bin/ffmpeg -i Samples/panasonic.vid -c:v libvpx-vp9 -s 1280x720 -b:v 1500k -keyint_min 150 -g 150 -an -f webm -dash 1 Outputs/vp9_video_1280x720_500k.webm &&
./bin/ffmpeg -i Samples/panasonic.vid -c:v libvpx-vp9 -s 160x90 -b:v 500k -keyint_min 150 -g 150 -an -f webm -dash 1 Outputs/vp9_video_160x90_250k.webm &&
./bin/ffmpeg -i Samples/panasonic.vid -c:v libvpx-vp9 -s 320x180 -b:v 750k -keyint_min 150 -g 150 -an -f webm -dash 1 Outputs/vp9_video_320x180_500k.webm &&
./bin/ffmpeg -i Samples/panasonic.vid -c:v libvpx-vp9 -s 640x360 -b:v 1000k -keyint_min 150 -g 150 -an -f webm -dash 1 Outputs/vp9_video_640x360_750k.webm &&
./bin/ffmpeg -i Samples/panasonic.vid -c:v libvpx-vp9 -s 1280x720 -b:v 2000k -keyint_min 150 -g 150 -an -f webm -dash 1 Outputs/vp9_video_1280x720_500k.webm
