require 'spec_helper'

describe Roc::Rolodex do
  before do
    @rolodex_path = "#{temp_directory}/rolodex"
    @rolodex = Roc::Rolodex.new(@rolodex_path, 'password')
  end

  after do
    FileUtils.rm_f @rolodex_path
  end

  describe "#create" do
    it "should raise an error if the file already exists" do
      FileUtils.touch @rolodex_path
      lambda{Roc::Rolodex.create(@rolodex_path, 'password')}.should raise_error(Roc::FileError)
    end

    it "should write a file at the given path" do
      Roc::Rolodex.create(@rolodex_path, 'password')
      File.exist?(@rolodex_path).should be_true
    end

    it "should return an empty Rolodex" do
      rolodex = Roc::Rolodex.create(@rolodex_path, 'password')
      rolodex.keys.should be_empty
    end

    it "should roundtrip to an empty Rolodex" do
      Roc::Rolodex.create(@rolodex_path, 'password')
      Roc::Rolodex.load(@rolodex_path, 'password').keys.should be_empty
    end
  end

  describe "#load" do
    before do
      @rolodex = Roc::Rolodex.create(@rolodex_path, 'password')
      @rolodex['one'] = 'blah'
      @rolodex['two'] = 'other blah'
      @rolodex.save
    end

    it "should return a Rolodex with the card data from the file" do
      rolodex = Roc::Rolodex.load(@rolodex_path, 'password')
      rolodex.data.should == {'one' => 'blah', 'two' => 'other blah'}
    end

    it "should raise a CipherError if the password is wrong" do
      lambda{Roc::Rolodex.load(@rolodex_path, 'wrong password')}.should raise_error(Roc::CipherError)
    end

    it "should raise an error if the file does not exist" do
      FileUtils.rm_f @rolodex_path
      lambda{Roc::Rolodex.load(@rolodex_path, 'password')}.should raise_error(Roc::FileError)
    end
  end

  describe "#save" do
    before do
      @rolodex = Roc::Rolodex.new(@rolodex_path, 'password')
      @rolodex['one'] = 'blah'
      @rolodex['two'] = 'other blah'
    end

    it "should write the data out to the given path" do
      @rolodex.save
      File.exist?(@rolodex_path).should be_true
    end

    it "should encrypt the file with the current password" do
      @rolodex.password = 'new password'
      @rolodex.save
      rolodex = Roc::Rolodex.load(@rolodex_path, 'new password')
      rolodex.data.should == {'one' => 'blah', 'two' => 'other blah'}
    end

    it "should not write any card names or contents in clear text" do
      @rolodex.save
      File.read(@rolodex_path).should_not include('one')
      File.read(@rolodex_path).should_not include('blah')
    end

    it "should not contain the password in cleartext" do
      @rolodex.save
      File.read(@rolodex_path).should_not include('password')
    end

    it "should set the file mode to 600" do
      @rolodex.save
      mode = File.stat(@rolodex_path).mode & 0777
      mode.should == 0600
    end

    it "should roundtrip successfully using #load" do
      @rolodex.save
      rolodex = Roc::Rolodex.load(@rolodex_path, 'password')
      rolodex.data.should == {'one' => 'blah', 'two' => 'other blah'}
    end
  end
end

describe "For a new Rolodex" do
  before do
    @rolodex = Roc::Rolodex.new("#{temp_directory}/rolodex", 'password')
    @rolodex['one'] = 'blah'
    @rolodex['two'] = 'other blah'
  end

  describe "#each" do
    it "should yield each name with its card contents" do
      yields = []
      @rolodex.each{|*args| yields << args}
      yields.sort.should == [['one', 'blah'], ['two', 'other blah']]
    end
  end

  describe "#[]" do
    it "should return the contents of the named card if it exists" do
      @rolodex['one'].should == 'blah'
      @rolodex['two'].should == 'other blah'
    end

    it "should return nil if there is no card with the given name" do
      @rolodex['non-existent'].should be_nil
    end
  end

  describe "#[]=" do
    it "should set the contents of the named card" do
      @rolodex['three'] = 'new'
      @rolodex.data.should == {'one' => 'blah', 'two' => 'other blah', 'three' => 'new'}
    end

    it "should overwrite the contents of an existing card" do
      @rolodex['one'] = 'new'
      @rolodex.data.should == {'one' => 'new', 'two' => 'other blah'}
    end
  end

  describe "#keys" do
    it "should return a list of names of all cards" do
      @rolodex.keys.sort.should == ['one', 'two']
    end
  end

  describe "#delete" do
    it "should delete the named card if there is a card with the given name" do
      @rolodex.delete('one')
      @rolodex.data.should == {'two' => 'other blah'}
    end

    it "should do nothing if there is no card with the given name" do
      @rolodex.delete('non-existent')
      @rolodex.data.should == {'one' => 'blah', 'two' => 'other blah'}
    end
  end
end
