require 'spec_helper'

describe Roc::Random do
  describe ".string" do
    it "should return a string of the given length" do
      Roc::Random.string(20).length.should == 20
    end

    it "should not return the same string twice in a row" do
      Roc::Random.string(20).should_not == Roc::Random.string(20)
    end
  end
end
