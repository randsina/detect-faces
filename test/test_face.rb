require 'minitest/autorun'
require 'colorize'
require_relative '../face'

class TestFace < Minitest::Test
  def setup
    @face = Face.new
  end

  def test_that_it_open_file_with_image
    assert_equal 'Successfully open image'.colorize(:green), @face.load_image('/home/roman/Pictures/image.jpg') # It's assumed that you have file with image in this path
  end
end
