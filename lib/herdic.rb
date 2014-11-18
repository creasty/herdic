require_relative 'herdic/version'
require_relative 'herdic/util'
require_relative 'herdic/store'
require_relative 'herdic/loader'
require_relative 'herdic/printer'
require_relative 'herdic/client'

require 'fileutils'


module Herdic

  class Configuration

    attr_accessor :pwd,
      :herdic_path,
      :store_path,
      :edit_request_file,
      :config_filename

    def initialize
      @pwd               = File.expand_path '.'
      @herdic_path       = File.expand_path '~/.herdic'
      @store_path        = File.join @herdic_path, 'store'
      @edit_request_file = File.join @herdic_path, 'edit_request.yaml'
      @config_filename   = 'herdic.yaml'
    end

  end

  class << self

    def setup
      @config ||= Configuration.new

      yield @config if block_given?

      ensure_directory!
    end

    def ensure_directory!
      FileUtils.mkdir_p self.herdic_path
      FileUtils.mkdir_p self.store_path
    end

    def method_missing(method_name, *args, &block)
      if @config.respond_to? method_name
        @config.send method_name, *args, &block
      else
        super
      end
    end

    def respond_to?(method_name, include_private = false)
      @config.respond_to? method_name
    end

  end

end
