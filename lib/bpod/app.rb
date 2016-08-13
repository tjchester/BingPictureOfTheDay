require 'open-uri'
require 'date'

require 'ostruct'
require 'json'

require_relative 'os'
require_relative 'region'

module Bpod

  class App

    # String template used downloading image metadata information from Bing about current home page image.
    URL_TEMPLATE = "http://www.bing.com/HPImageArchive.aspx?format=$FORMAT&idx=$IDX&n=$NUMBER&mkt=$REGION"    
    #FORMATS = ["xml", "js", "rss"]
    #RESOLUTIONS = { :high => "1920x1080", :low => "1366x768"}

    # True if -v (verbose) option was specified
    attr_accessor :verbose

    # True if -f (force download) option was specified
    attr_accessor :force

    # Full path to folder where images will be found
    attr_reader :image_folder

    # Marketing region code option (defaults to 'en-US')
    attr_reader :region

    # Name without path of latest image in the image folder.
    attr_reader :image_name

    # Url of image to be downloaded (must be appended to *http://www.bing.com* to be complete.)
    attr_reader :image_url

    # Full path of file containing downloaded metadata information.
    attr_reader :meta_file

    # Parameters [optional]:
    # - image_folder - Full path of folder to store images in (defaults to $HOME/Pictures/bpod)
    # - region - Marketing region code of images to download (defaults to 'en-US')
    # 
    # If a block is supplied then this function will return a reference to the object.
    def initialize(image_folder, region)
      @verbose = false
      @force = false

      @image_folder = Bpod::Os.create_wallpaper_folder("bpod") if image_folder.nil?
      @region = 'en-US' if region.nil?
      @meta_file = File.join(Os::get_temp_folder, "bpod.json")
      @image_name = nil

      yield self if block_given?
    end

    # Downloads the latest image
    def download
      raise Bpod::NoDownloadWindowException if !download_window_exists? && !@force
  
      @url = URL_TEMPLATE.sub(/\$FORMAT/, "js").sub(/\$IDX/, "0").sub(/\$NUMBER/, "1").sub(/\$REGION/, region) 

      verbose "Downloading meta information from url #{@url}"
      verbose "  and saving to file #{@meta_file}"
      download_file @meta_file, @url

      verbose "Building internal object from saved metafile"
      contents = File.read(@meta_file)

      raise InvalidMetadataUrlParameterException if contents == "null"

      json_object = string_to_json_object contents

      @image_url = json_object.images[0].url
      verbose "The latest image is located at #{image_url}"

      @image_name = File.basename(@image_url)
      verbose "Downloading #{image_name} to #{@image_folder}"
      download_file File.join(@image_folder, @image_name), "http://www.bing.com#{image_url}"
    end

    # Sets the desktop wallpaper to the latest downloaded image
    def set_wallpaper
      @image_name = File.basename(newest_file_in_folder(@image_folder)) if @image_name.nil?
      target = File.join(@image_folder, @image_name)
      verbose "Setting wallpaper to #{target}"

      begin
        Bpod::Os.set_wallpaper target
      rescue
        raise UnknownOsException
      end
    end

    # String representation of object for debugging purposes
    def to_s
        "#{self.class} \n" +
        "  object_id: #{self.object_id} \n" + 
        "  version: #{Bpod::VERSION} \n" +  
        "  verbose: #{@verbose} \n" + 
        "  force: #{@force} \n" + 
        "  image_folder: #{@image_folder} \n" + 
        "  region: #{@region} \n" +
        "  image_name: #{@image_name} \n" +
        "  image_url: #{@image_url} \n" + 
        "  meta_file: #{@meta_file} \n" +
        "end"
    end

  private
    
    def download_window_exists?
      newest_file = newest_file_in_folder @image_folder

      return true if newest_file == nil

      Date.today.strftime("%Y-%m-%d") > File.mtime(newest_file).strftime("%Y-%m-%d")
    end

    def download_file(to_file, from_url)
      open(to_file, "wb") do |file|
        file << open(from_url).read
      end
    end
  
    def newest_file_in_folder(folder)
      Dir.glob("#{folder}/*").max_by {|f| File.mtime(f)}
    end

    def string_to_json_object(json_string)
      JSON.parse json_string, object_class: OpenStruct
    end

    def verbose(message)
      puts message if @verbose
    end

  end

end