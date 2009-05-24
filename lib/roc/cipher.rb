require 'openssl'
require 'digest/sha2'

module Roc
  class Cipher
    def initialize(password, iv)
      @key = Digest::SHA256.digest(password)
      @iv = iv
    end

    #
    # The initialization vector to use.
    #
    attr_reader :iv

    #
    # Encrypt the given cleartext.
    #
    def encrypt(message)
      xcrypt(:encrypt, message)
    end

    #
    # Decrypt the given encoded message.
    #
    def decrypt(message)
      xcrypt(:decrypt, message)
    rescue OpenSSL::Cipher::CipherError
      raise CipherError, 'invalid password'
    end

    private  # ---------------------------------------------------------

    def xcrypt(operation, message)
      cipher = OpenSSL::Cipher::Cipher.new('aes-256-cbc')
      cipher.send(operation)
      cipher.key = @key
      cipher.iv = @iv
      cipher.update(message) << cipher.final
    end

    class << self
      #
      # Ensure this module never blocks, at the expense of security.
      #
      # Used for testing.
      #
      attr_accessor :dont_block
    end
  end
end
