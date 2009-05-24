require 'yaml'
require 'forwardable'

module Roc
  class Rolodex
    def initialize(path, password)
      @path = File.expand_path(path)
      @password = password
      @iv = nil
      @data = {}
      @version = 1
    end

    #
    # Password to encrypt with.
    #
    attr_accessor :password

    #
    # Create a new rolodex at the given +path+, with the given
    # +password+.
    #
    def self.create(path, password)
      if File.exist?(path)
        raise FileError, "file already exists: #{path}"
      else
        rolodex = Rolodex.new(path, password)
        rolodex.save
        rolodex
      end
    end

    #
    # Create a Rolodex from the given file, and return it.
    #
    # If the +password+ is incorrect, return nil.  If the file doesn't
    # exist, raise FileError.
    #
    def self.load(path, password)
      File.exist?(path) or
        raise FileError, "no such file: #{path}"
      rolodex = new(path, password)
      text = File.read(path)
      rolodex.send(:deserialize, text)
      rolodex
    end

    #
    # Save the rolodex.
    #
    def save
      @iv ||= Random.string(16)
      open(@path, 'w'){|f| f.write(serialize)}
      File.chmod(0600, @path)
    end

    #
    # The hash of card names to content.
    #
    attr_reader :data

    extend Forwardable
    def_delegators :@data, :replace, :[], :[]=, :keys, :delete

    #
    # Yield each card name with its content.
    #
    def each
      @data.each do |name, content|
        yield name, content
      end
    end
    include Enumerable

    private  # -------------------------------------------------------

    def cipher
      Cipher.new(@password, @iv)
    end

    def serialize
      version = [@version].pack('V')
      iv = @iv
      cards = cipher.encrypt(@data.to_yaml)
      version + iv + cards
    end

    def deserialize(text)
      @version = text.unpack('V')[0]
      @iv = text[4...20]
      @data = YAML.load(cipher.decrypt(text[20..-1]))
    end
  end
end
