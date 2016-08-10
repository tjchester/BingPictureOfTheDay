require 'os'
require 'tmpdir'

module Bpod

  class Os

    SPI_SETDESKWALLPAPER = 20
    SPIF_UPDATEINIFILE = 0x1
    SPIF_SENDWININICHANGE = 0x2

	  def self.get_picture_folder
      File.join(Dir.home, "Pictures")
    end

    def self.create_wallpaper_folder(folder)
      new_folder = File.join(get_picture_folder, folder)

      Dir.mkdir(new_folder) unless Dir.exists?(new_folder)

      new_folder
    end

    def self.get_temp_folder
      Dir.tmpdir
    end

    def self.set_wallpaper(file_name, file_path)
      image = File.join(file_path, file_name)

      puts "Setting wallpaper to #{image}"

      if OS.osx?
        %x{osascript -e 'tell application \"Finder\" to set desktop picture to POSIX file \"#{image}\"'}
        puts "Set wallpaper returned: #{$?}"
	    elsif OS.windows?
        require "Win32API" 

        api = Win32API.new('user32', 'SystemParametersInfoA', ['I', 'I', 'P', 'I'], 'I')
        rc = api.call(SPI_SETDESKWALLPAPER, 0, image, SPIF_UPDATEINIFILE | SPIF_SENDWININICHANGE)
        puts "Set wallpaper returned: #{rc}"
      else
        puts "Unknown OS"
      end
    end

  end

end