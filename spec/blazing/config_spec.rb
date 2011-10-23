require 'spec_helper'
require 'blazing/config'

describe Blazing::Config do

  describe '#initialize' do
    it 'takes the path of the config file as an argument' do
      config = Blazing::Config.new('/some/where/config.rb')
      config.file.should == '/some/where/config.rb'
    end

    it 'takes the default config path if no path is specified' do
      config = Blazing::Config.new
      config.file.should == 'config/blazing.rb'
    end
  end

  describe '.parse' do

    it 'returns a config object' do
      Blazing::Config.parse('spec/support/empty_config.rb').should be_a Blazing::Config
    end

  end

  describe 'DSL' do

    before :each do
      @config = Blazing::Config.new
    end

    describe 'target' do

      it 'creates a target object for each target call' do
        @config.target :somename, :location => 'someuser@somehost:/path/to/deploy/to'
        @config.target :someothername, :location => 'someuser@somehost:/path/to/deploy/to'

        @config.targets.each { |t| t.should be_a Blazing::Target }
        @config.targets.size.should be 2
      end

      it 'does not allow the creation of two targets with the same name' do
        @config.target :somename, :location => 'someuser@somehost:/path/to/deploy/to'
        lambda { @config.target :somename, :location => 'someuser@somehost:/path/to/deploy/to' }.should raise_error
      end
    end

    describe 'repository' do
      it 'assigns the repository if a value is given' do
        @config.repository('somewhere')
        @config.instance_variable_get("@repository").should == 'somewhere'
      end

      it 'returns the repository string if no value is given' do
        @config.repository('somewhere')
        @config.repository.should == 'somewhere'
      end
    end

    describe 'recipes' do

      before :each do
        class Blazing::Recipe::Dummy < Blazing::Recipe
        end
      end

      it 'is an empty recipe if nothing was set' do
        @config.recipes.should be_a Array
      end

      it 'accepts a single recipe as argument' do
        @config.recipes :dummy
        @config.recipes.first.should be_a Blazing::Recipe::Dummy
      end
    end

    describe 'rake' do

    end

    describe 'rvm' do

    end
  end
end
