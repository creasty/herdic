require 'cgi'


module Herdic
  module Util
    class << self

      def find_files_upward(filename, base, count = 0)
        found = []
        found_count = 0

        while count == 0 || found_count <= count
          file = File.join base, filename

          if File.exists? file
            found << file
            found_count += 1
          end

          break if '.' == base || '/' == base

          base = File.dirname base
        end

        found
      end

      COLORS = {
        black:   0,
        red:     1,
        green:   2,
        yellow:  3,
        blue:    4,
        magenta: 5,
        cyan:    6,
        white:   7,
      }

      def color(str, c)
        "\e[1;#{30+COLORS[c]}m#{str}\e[0m"
      end

    end
  end
end
