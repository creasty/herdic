module Herdic
  module Util

    def self.find_files_upward(filename, base, count = 0)
      found = []

      while count >= 1 || count < 0
        file = File.join base, filename

        if File.exists? file
          found << file
          count -= 1
        end

        break if '.' == base

        base = File.dirname base
      end

      found
    end

  end
end
