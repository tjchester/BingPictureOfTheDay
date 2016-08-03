#!/usr/bin/env ruby

require 'optparse'

require_relative '../lib/bpod'

options = {}

optparse = OptionParser.new do |opts|
  opts.banner = "Usage: bpod [options]"

  opts.on("-d", "--image-folder FOLDER", "Full file path where images will be stored.") do |folder|
    options[:image_folder] = folder
  end
  
  opts.on("-r", "--region-code REGION", "Region code for Bing market area, for example en-US.") do |region|
    if Bpod::REGIONS.has_key? region
      options[:region] = region
    else
      puts "#{region} is not a valid region code. Defaulting to en-US."
    end
  end

  opts.on("-h", "--help", "Display usage information") do
    puts opts
    exit
  end
  
end

begin
  optparse.parse!
  if options[:image_folder].nil?
    options[:image_folder] = Bpod::Os.create_wallpaper_folder "bpod"
  end

  if options[:region].nil?
    options[:region] = 'en-US'
  end

  if !Bpod::Downloader.download_window_exists?(options[:image_folder])
    puts "Home page image only changes once per day. You already have the latest image."
    exit 
  end

  puts "Images will be downloaded for the market"
  puts Bpod::REGIONS[options[:region]]

  puts "Images will be downloaded to the folder"
  puts options[:image_folder]

  puts "Creating downloader object"
  downloader = Bpod::Downloader.new("js", options[:region], 1, 0)

  puts "Downloading the image metafile"
  downloader.execute

  puts "Metafile saved to the following location"
  metafile = downloader.metafile
  puts metafile

  puts "Building JSON object from saved metafile"
  json_object = Bpod::Parser.new(File.read(metafile)).obj

  puts "URL of image to fetch is"
  image_url = json_object.images[0].url
  puts image_url

  puts "Downloading image of the day"
  image_name = File.basename(image_url)
  puts image_name
  downloader.execute image_name, options[:image_folder], "http://www.bing.com#{image_url}"

  puts "Setting downloaded image as the wallpaper"
  Bpod::Os.set_wallpaper image_name, options[:image_folder]

end
