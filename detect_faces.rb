#!/usr/bin/env ruby

require 'opencv'
require 'colorize'
include OpenCV

if ARGV.length < 2
  puts "Usage: ruby #{__FILE__} source dest".colorize(:red)
  exit
end

data = '/usr/local/share/OpenCV/haarcascades/haarcascade_frontalface_alt.xml'
detector = CvHaarClassifierCascade::load(data)
begin
  image = CvMat.load(ARGV[0]) # Read the file.
rescue
  puts 'Could not open or find the image'.colorize(:red)
  exit
end
detector.detect_objects(image).each do |region|
  color = CvColor::Blue
  image.rectangle! region.top_left, region.bottom_right, color: color
end
puts 'Detect faces'.colorize(:green)

image.save_image(ARGV[1])
puts 'Save final photo'.colorize(:green)
# window = GUI::Window.new('Face detection')
# window.show(image)
# GUI::wait_key
