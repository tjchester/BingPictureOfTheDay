require 'ostruct'
require 'json'

module Bpod

  class Parser

    attr_reader :obj

    def initialize(json_string)
      @obj = JSON.parse(json_string, object_class: OpenStruct)
      self
    end

  end

end