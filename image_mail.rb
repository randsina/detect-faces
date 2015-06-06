#!/usr/bin/env ruby

require 'pony'
require 'colorize'

class ImageMail
  def initialize(image_source)
    @image_source = image_source
  end

  def send
    Pony.mail({
      to:          'roman.vakulchik@gmail.com',
      subject:     'Raspberry Pi photo',
      body:        'Hi. I send photo from Raspberry Pi.',
      attachments: {
        'image.jpg' => File.read(@image_source)
      },
      via:         :smtp,
      via_options: {
        address:              'smtp.gmail.com',
        port:                 '587',
        enable_starttls_auto: true,
        user_name:            'rvakulchik@gmail.com',
        password:             ENV['PASSWORD'],
        authentication:       :plain, # :plain, :login, :cram_md5, no auth by default
        domain:               'localhost.localdomain' # the HELO domain provided by the client to the server
      }
    })
    'Send photo'.colorize(:green)
  end
end

if ARGV.length < 1
  puts "Usage: ruby #{__FILE__} image_source".colorize(:red)
  exit
end

mail = ImageMail.new(ARGV[0])
mail.send
