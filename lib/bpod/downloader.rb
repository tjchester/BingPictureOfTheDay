require 'open-uri'
require 'date'

require_relative 'os'

module Bpod

  class Downloader

    URL_TEMPLATE = "http://www.bing.com/HPImageArchive.aspx?format=$FORMAT&idx=$IDX&n=$NUMBER&mkt=$REGION"
    
    FORMATS = ["xml", "js", "rss"]

    RESOLUTIONS = { :high => "1920x1080", :low => "1366x768"}

    attr_reader :url
    attr_reader :metafile

    def initialize(format = "js", region = "en-US", number = 1, idx = 0)
  
      @format = format
      @url = URL_TEMPLATE.sub(/\$FORMAT/, format).
        sub(/\$IDX/, idx.to_s).
        sub(/\$NUMBER/, number.to_s).
        sub(/\$REGION/, region) 
    end

    def self.download_window_exists?(folder)
      newest_file = Dir.glob("#{folder}/*").max_by {|f| File.mtime(f)}

      return true if newest_file == nil

      Date.today.strftime("%Y-%m-%d") > File.mtime(newest_file).strftime("%Y-%m-%d")
    end

    def execute(to_file = 'bpod.txt', to_folder = Bpod::Os.get_temp_folder, url = @url)
      @metafile = File.join(to_folder, to_file)
      open(@metafile, "w") do |file|
        file << open(url).read
      end
    end

  end

end
