module Bpod
  class NoDownloadWindowException < RuntimeError
  end

  class DownloadQuotaExceeded < RuntimeError
  end

  class UnknownOsException < RuntimeError
  end
end