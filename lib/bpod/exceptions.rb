module Bpod

  # Exception that occurs when the -f (force) option is not specified and the 
  # latest downloaded image matches the current date. The Bing home page image
  # generally only changes once per day so only one download should be needed
  # per day.
  class NoDownloadWindowException < RuntimeError
  end

  #class DownloadQuotaExceededException < RuntimeError
  #end

  # Exception that occurs if the Bing metainformation url returns a "null" payload.
  # This usually indicates an internal error where there are invalid parameters specified.
  # The issue can be tracked back to the **URL_TEMPLATE** string in the *app.rb* file.
  class InvalidMetadataUrlParameterException < RuntimeError
  end

  # Exception thrown when the -s (set wallpaper) option is used and the the
  # operating system does not resolve to *osx* or *windows*.
  class UnknownOsException < RuntimeError
  end
end