module Roc
  module Random
    class << self
      #
      # Return a random string of the given length.
      #
      def string(length)
        device = dont_block ? '/dev/urandom' : '/dev/random'
        IO.read(device, length)
      end

      #
      # When true, ensure this module never blocks, at the expense of
      # security.
      #
      # Used for testing.
      #
      attr_accessor :dont_block
    end
  end
end
