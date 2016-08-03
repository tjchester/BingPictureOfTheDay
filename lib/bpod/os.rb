require 'os'
require 'tmpdir'

module Bpod

  class Os

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
      else
        puts "Unknown OS"
      end
    end

  end

end