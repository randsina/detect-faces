#!/bin/bash

DATE=$(date +"%Y-%m-%d_%H:%M:%S")

fswebcam -r 1280x720 --no-banner ./pictures/$DATE.jpg
ruby lib/face.rb ./pictures/$DATE.jpg ./out/$DATE.jpg
ruby lib/image_mail.rb ./out/$DATE.jpg
