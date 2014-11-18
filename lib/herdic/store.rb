require 'digest'


module Herdic
  class Store

    attr_reader :data

    def initialize(path = nil)
      hash = Digest::MD5.hexdigest File.expand_path(path.to_s)
      @file = File.join Herdic.store_path, hash

      load
    end

    def load
      data = nil
      File.open(@file, 'a+b') { |f| data = f.read }
      @data = Marshal.load(data) rescue {}
    end

    def save
      data = Marshal.dump @data
      File.open(@file, 'wb') { |f| f.write data }
    end

  end
end
