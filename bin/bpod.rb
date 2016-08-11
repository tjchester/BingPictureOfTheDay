#!/usr/bin/env ruby

require 'optparse'

require_relative '../lib/bpod'

options = {}

optparse = OptionParser.new do |opts|
  opts.banner = "Usage: bpod [options]"

  opts.on("-f", "--image-folder FOLDER", "Full file path where images will be stored.") do |folder|
    if Bpod::Os.folder_exists? folder
      options[:image_folder] = folder
    else
      puts "#{folder} does not exist. Creating a bpod folder within your Pictures folder."
      options[:image_folder] = Bpod::Os.create_wallpaper_folder("bpod")
    end
  end
  
  opts.on("-r", "--region-code REGION", "Region code for Bing market area, for example en-US.") do |region|
    if Bpod::REGION.has_key? region
      options[:region] = region
    else
      puts "#{region} is not a valid region code. Defaulting to en-US."
    end
  end

  opts.on("-d", "--download-image", "Download the image of the day.") do
    options[:download] = true
  end

  opts.on("-f", "--force-download", "Download image even if not within download window.") do 
    options[:force] = true
  end

  opts.on("-s", "--set-wallpaper", "Set desktop wallpaper using latest downloaded image") do
    options[:set_wallpaper] = true
  end

  opts.on("-v", "--verbose", "Display messages about which actions are occurring.") do
    options[:verbose] = true
  end

  opts.on("-h", "--help", "Display usage information") do
    puts opts
    exit
  end
  
end

begin
  optparse.parse!
  
  app = Bpod::App.new options[:image_folder], options[:region] do |obj|
    obj.force = options[:force] ||= false
    obj.verbose = options[:verbose] ||= false
  end

  if options[:download]
    begin
      app.download
    rescue Bpod::NoDownloadWindowException
      puts "Home page image only changes once per day. You already have the latest image."
      puts app if options[:verbose]
    rescue Bpod::DownloadQuotaExceeded
      puts "Bing download quota exceeded, try again later"
      puts app if options[:verbose]
    end  
  end

  begin
    app.set_wallpaper if options[:set_wallpaper]
  rescue Bpod::UnknownOsException
    puts "Unable to set wallpaper for current operating system."
  end

end
