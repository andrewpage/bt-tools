require 'spec_helper'

describe Tools::API do
  before do
    # Include the module
    class FooClass; end

    @klass = FooClass
    @klass.extend Tools::API
  end

  describe '#create' do
    it 'should read configuration and call the Create action' do
      allow(File).to receive(:read)
      allow(JSON).to receive(:parse).and_return(mock_configuration)
      expect_any_instance_of(Tools::Actions::Create).to receive(:execute)

      @klass.create('config_path')
    end
  end

  describe '#transcode' do
    it 'should read configuration' do
      expect(@klass).to receive(:read_config).with('config_path', :transcode)

      @klass.transcode('config_path')
    end
  end

  describe '#validate_configuration' do
    it 'should raise an exception when there are missing keys' do
      required = [:a, :b, :c, :d, :e]
      config = { d: 1, e: 2, f: 3, g: 4 }

      expect do
        @klass.send(:validate_configuration, config, required)
      end.to raise_error(Tools::MissingKeysException)
    end

    it 'should not raise an exception when all required keys are present' do
      required = [:a, :b, :c, :d, :e]
      config = { a: 1, b: 2, c: 3, d: 4, e: 5 }

      expect do
        @klass.send(:validate_configuration, config, required)
      end.to_not raise_error
    end
  end

  xdescribe '#required_keys' do
  end

  describe '#read_config' do
    configuration_fixture_path = fixture_path('config/configuration.json')

    it 'should read and parse JSON with an action' do
      result = @klass.send(:read_config, configuration_fixture_path, :transcode)

      expect(result).to have_key('formats')
      expect(result).to have_key('source')
      expect(result).to have_key('output')
    end

    it 'should read and parse JSON without an action' do
      result = @klass.send(:read_config, configuration_fixture_path)

      expect(result).to have_key('create')
      expect(result).to have_key('transcode')
    end
  end

  describe '#relative_config_path' do
    it 'should return a relative config path' do
      primary = 'config/configurations/myconfig.json'
      secondary = 'manifest.json'

      result = @klass.send(:relative_config_path, primary, secondary)
      expect(result).to eq('config/configurations/manifest.json')
    end
  end
end
