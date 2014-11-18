require 'ap'


module Herdic
  class Printer

    def initialize(options)
      @options = options
    end

    def start_message(specs)
      puts 'Running %d spec(s)' % specs.size
    end

    def title(meta)
      puts "\n\n"
      hr rule: '=', color: :green

      puts [meta['method'].green, meta['endpoint']].join('  ')

      if meta['title']
        indent = ' ' * meta['method'].size
        puts [indent, meta['title'].white].join('  ')
      end

      hr rule: '=', color: :green
    end

    def subtitle(text)
      puts
      puts "==> #{text}".blue
      puts
    end

    def request(header, body)
      subtitle 'Request'

      if header.empty?
        puts 'no header'.white
      else
        print_header header
      end

      hr

      ap body
    end

    def response(response, body)
      subtitle "Response: #{response.code} #{response.message}"

      print_header response.to_hash

      hr

      if body.empty?
        puts 'no body'.white
      elsif 'application/json' == response.content_type
        ap body
      elsif @options['html']
        puts body
      else
        puts 'N/A'.white
      end
    end

    private def print_header(header)
      max_cols = header.keys.map(&:size).max
      header.each do |k, v|
        puts [("%#{max_cols}s" % k).white, v].join ' '
      end
    end

    private def hr(rule: '-', color: :black)
      puts (rule * terminal_cols).send(color)
    end

    private def terminal_cols
      @terminal_cols ||= Integer(`tput cols`)
    end

  end
end

