require 'psych'


module Herdic
  class Loader

    include Enumerable

    def initialize(file, original = nil)
      @file, @original = file, original
    end

    def load(file, original, included_from = nil)
      file = File.expand_path file, included_from

      specs = ''

      File.open(file, 'r') do |f|
        specs = f.read
      end

      specs = Psych.load specs

      specs.each do |spec|
        spec['file'] = original || file

        if spec['include']
          load spec['include'], nil, File.dirname(spec['file'])
        else
          @block.call spec
        end
      end
    end

    def each(&block)
      return unless block

      @block = block
      load @file, @original
    end

  end
end
