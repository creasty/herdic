require 'psych'


module Herdic
  class Loader

    attr_accessor :specs

    def initialize(file)
      @specs = []

      load file
    end

    def load(file, included_from = nil)
      file = File.expand_path file, included_from

      File.open(file, 'r') do |f|
        @_specs = f.read
      end

      @_specs = Psych.load @_specs

      @_specs.each do |spec|
        spec['file'] = file

        if spec['include']
          load spec['include'], File.dirname(file)
        else
          @specs << spec
        end
      end

      @_specs = nil
    end

  end
end
