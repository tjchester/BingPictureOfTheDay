require 'os'
require 'tmpdir'

module Bpod

  class Os

    # Constant used by the Win32 *SystemParametersInfoA* function.
    SPI_SETDESKWALLPAPER = 20

    # Constant used by the Win32 *SystemParametersInfoA* function.
    SPIF_UPDATEINIFILE = 0x1

    # Constant used by the Win32 *SystemParametersInfoA* function.
    SPIF_SENDWININICHANGE = 0x2

    # Returns true if the specified *folder* exists.
    def self.folder_exists?(folder)
      return false if Dir[directory] == nil
      true
    end

    # Returns path of the *Pictures* folder within the current user's
    # home folder. This does not necessarily mean that the folder
    # actually exists.
	  def self.get_picture_folder
      File.join(Dir.home, "Pictures")
    end

    # Creates folder and returns full path to a specified *folder*
    # created within the user's *Pictures* folder. This folder will
    # be used as the default folder to hold the downloaded image folders
    # when a specific folder is not supplied.
    def self.create_wallpaper_folder(folder)
      new_folder = File.join(get_picture_folder, folder)

      Dir.mkdir(new_folder) unless Dir.exists?(new_folder)

      new_folder
    end

    # Returns path of the operating system specific *Temp* folder
    def self.get_temp_folder
      Dir.tmpdir
    end

    # Returns true if command can be found (linx, osx only)
    def self.found?(program)
      system("which #{program} > /dev/null 2>&1")
    end

    # Sets the desktop wallpaper to the specified file name and path
    # specified by *file*.
    def self.set_wallpaper(file)
      if OS.osx?
        %x{osascript -e 'tell application \"Finder\" to set desktop picture to POSIX file \"#{file}\"'}
        $?
	    elsif OS.windows?
        require "Win32API"

        api = Win32API.new('user32', 'SystemParametersInfoA', ['I', 'I', 'P', 'I'], 'I')
        api.call(SPI_SETDESKWALLPAPER, 0, file, SPIF_UPDATEINIFILE | SPIF_SENDWININICHANGE)
      elsif OS.linux?
        if found? "gsettings" # Gnome3
          %x{gsettings set org.gnome.desktop.background picture-uri 'file://#{file}'}
        elsif found? "feh" # X Windows
          %x{feh --bg-scale #{file}}
          $?
        else
          raise "Unable to locate program to set linux background."
        end
      else
        raise "Unable to set wallpaper for current operating system."
      end
    end

    # Displays a notification message after the image has been
    # downloaded.
    def self.show_notification(message)
      message.gsub! "'", ""
      if OS.osx?
        %x{osascript -e 'display notification \"#{message}\" with title \"Bing Picture of the Day\"'}
        $?
      elsif OS.windows?
        raise "Unable to locate program to set Windows background."
      elsif OS.linux?
        %x{notify-send -t 3000 'Bing Picture of the Day', '#{message}'}
      else
        raise "Unable to set wallpaper for current operating system."
      end
    end

  end

end
