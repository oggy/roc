require 'spec'
require 'roc'
require 'fileutils'

module SpecHelper
  def project_root
    File.expand_path(File.dirname(File.dirname(__FILE__)))
  end

  def temp_directory
    "#{project_root}/tmp"
  end
end

Spec::Runner.configure do |config|
  config.include SpecHelper
end

Roc::Random.dont_block = true
