require 'active_support/core_ext'
require 'erb'
require 'fileutils'
require 'json'
require 'net/http'
require 'open-uri'
require 'optparse'
require 'psych'
require 'uri'


module Herdic
  class Client

    attr_reader :registry, :config

    def initialize(file, options)
      @file, @options = file, options

      @context = binding

      @config_file = @options['c'] || Util.find_files_upward(Herdic.config_filename, Herdic.pwd, 1)[0]
      load_config @config_file if @config_file

      @printer = Printer.new @options
      @printer.start_message @config_file

      @store = Store.new @config_file
      @registry = @store.data
    end

    def load_config(file)
      @config = {}

      File.open(file, 'r') do |f|
        @config = ERB.new(f.read).result @context
      end

      @config = Psych.load @config
    end

    def run_all
      if @options['e']
        FileUtils.cp @file, Herdic.edit_request_file
        system "$EDITOR '%s'" % Herdic.edit_request_file

        @specs = Loader.new Herdic.edit_request_file, @file
      else
        @specs = Loader.new @file
      end

      @specs.each do |spec|
        # FIXME: figure out better way
        spec = Psych.dump spec
        spec = ERB.new(spec).result @context
        spec = Psych.load spec

        run spec
      end

      @store.save
    end

    private def run(spec)
      setup_spec spec

      uri = URI.parse @meta['endpoint']
      http = Net::HTTP.new uri.host, uri.port
      http.use_ssl = @options['use-ssl']

      response = http.start do
        case @meta['method']
        when 'GET', 'POST', 'PATCH', 'PUT', 'DELETE'
          http.send_request @meta['method'], uri.request_uri, @body.to_query, @header
        else
          raise "Unsupported method: #{@meta['method']}"
        end
      end

      body = response.body
      body = JSON.parse body if 'application/json' == response.content_type

      @printer.title @meta
      @printer.request @header, @body
      @printer.response response, body

      register response, body
    end

    private def setup_spec(spec)
      @meta     = spec.slice 'title', 'method', 'endpoint'
      @register = spec['register'] || {}
      @header   = spec['header'] || {}
      @body     = spec['body'] || {}

      @meta['method'].upcase!
      @header = @header.map { |k, v| [k, v.to_s] }.to_h
    end

    private def register(response, body)
      return unless 'application/json' == response.content_type

      @register.each do |name, path|
        next if path.empty?

        val = body

        path.to_s.split('.').each do |key|
          key = key.to_i if key === /\A\d+\z/
          val = val.try :[], key
        end

        @registry[name] = val
      end
    end

  end
end
