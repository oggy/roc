require 'spec_helper'

describe Roc::Cipher do
  before do
    @plaintext = 'message'

    cipher = Roc::Cipher.new('password', 'initialization vector')
    @ciphertext = cipher.encrypt(@plaintext)
  end

  it "should successfully roundtrip a message if the same password and initialization vector is used" do
    cipher = Roc::Cipher.new('password', 'initialization vector')
    cipher.decrypt(@ciphertext).should == @plaintext
  end

  it "should fail to decrypt a message if the wrong password is used" do
    cipher = Roc::Cipher.new('wrong password', 'initialization vector')
    lambda{cipher.decrypt(@ciphertext)}.should raise_error(Roc::CipherError)
  end

  it "should fail to decrypt a message if the wrong initialization vector is used" do
    cipher = Roc::Cipher.new('password', 'wrong initialization vector')
    lambda{cipher.decrypt(@ciphertext)}.should raise_error(Roc::CipherError)
  end
end
