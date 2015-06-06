#!/usr/bin/env ruby

require 'opencv'
require 'colorize'

class Face
  include OpenCV
  DATA = '/usr/local/share/OpenCV/haarcascades/haarcascade_frontalface_alt.xml' # Use this configuration to detect faces

  def initialize
    @detector = CvHaarClassifierCascade::load(DATA)
  end

  def detect
    @detector.detect_objects(@image).each do |region|
      color = CvColor::Blue
      @image.rectangle! region.top_left, region.bottom_right, color: color # Cut around of face
    end
    'Detect faces'.colorize(:green)
  end

  def load_image(image_source_path)
    begin
      @image = CvMat.load(image_source_path) # Read the file.
      'Successfully open image'.colorize(:green)
    rescue
      puts 'Could not open or find the image'.colorize(:red)
      exit
    end
  end

  def save_image(image_destination_path)
    begin
      @image.save_image(image_destination_path) # Write the file
      'Save final photo'.colorize(:green)
    rescue
      puts 'Could not save image in the file'.colorize(:red)
      exit
    end
  end
end

if ARGV.length < 2
  puts "Usage: ruby #{__FILE__} source dest".colorize(:red)
  exit
end

face = Face.new
puts face.load_image(ARGV[0])
puts face.detect
puts face.save_image(ARGV[1])
