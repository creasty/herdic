require 'json'
require 'pygments'


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

      puts [Util.color(meta['method'], :green), meta['endpoint']].join('  ')

      if meta['title']
        indent = ' ' * meta['method'].size
        puts [indent, Util.color(meta['title'], :white)].join('  ')
      end

      hr rule: '=', color: :green
    end

    def subtitle(text)
      puts
      puts Util.color(text, :green)
      hr color: :green
    end

    def request(header, body)
      subtitle 'Request'

      if header.empty?
        puts Util.color('no header', :white)
      else
        print_header header
      end

      hr

      print_json body
    end

    def response(response, body)
      subtitle "Response: #{response.code} #{response.message}"

      print_header response.to_hash

      hr

      if body.empty?
        puts Util.color('no body', :white)
      elsif 'application/json' == response.content_type
        print_json body
      else
        puts body
      end
    end

    private def print_header(header)
      max_cols = header.keys.map(&:size).max
      header.each do |k, v|
        puts [Util.color("%#{max_cols}s" % k, :white), v].join ' '
      end
    end

    private def print_json(json)
      if json.empty?
        puts '{}'
        return
      end

      puts Pygments.highlight(JSON.pretty_generate(json), {
        formatter: 'terminal',
        lexer:     'json',
        options:   { encoding: 'utf-8' },
      })
    end

    private def hr(rule: '-', color: :black)
      puts Util.color(rule * terminal_cols, color)
    end

    private def terminal_cols
      @terminal_cols ||= Integer(`tput cols`)
    end

  end
end

