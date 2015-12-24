require 'spec_helper'

describe Tools::CLI do
  before do
    # add some fake args
    @args = %w(create -c config/configuration.json)
  end

  describe '#initialize' do
    it 'should initialize a CLI object' do
      expect_any_instance_of(Tools::CLI).to receive(:set_default_options)
      expect_any_instance_of(Tools::CLI).to receive(:parse)
      expect_any_instance_of(Tools::CLI).to receive(:validate!)

      Tools::CLI.new(@args)
    end

    it 'should set `options` to a new OpenStruct' do
      cli = Tools::CLI.new(@args)

      options = cli.options
      expect(options).to be_an_instance_of(OpenStruct)
    end
  end

  describe '#execute' do
    before :each do
      @cli = Tools::CLI.new(@args)
    end

    it 'should execute a create' do
      allow(@cli).to receive(:command).and_return(:create)

      expect(Tools).to receive(:create)
    end

    it 'should execute a transcode' do
      allow(@cli).to receive(:command).and_return(:transcode)

      expect(Tools).to receive(:transcode)
    end

    after :each do
      @cli.execute
    end
  end

  describe '#set_default_options' do
    before do
      # Don't set defaults
      allow_any_instance_of(Tools::CLI).to receive(:set_default_options)

      @cli = Tools::CLI.new(@args)

      # Revert back to the original
      allow_any_instance_of(Tools::CLI).to receive(:set_default_options).and_call_original
    end

    it 'should set the default configuration path' do
      stub_const('Tools::CLI::DEFAULT_CONFIGURATION_PATH', 'my/config/path')

      @cli.send(:set_default_options)

      expect(@cli.options.configuration_path).to eq('my/config/path')
    end
  end

  describe '#parse' do
    before :each do
      # Don't validate
      allow_any_instance_of(Tools::CLI).to receive(:validate)

      # Don't call parse
      allow_any_instance_of(Tools::CLI).to receive(:parse)

      @cli = Tools::CLI.new(@args)

      # Revert back to the original
      allow_any_instance_of(Tools::CLI).to receive(:parse).and_call_original
    end

    it 'should delegate option parsing to the OptionParser' do
      option_parser = @cli.send(:option_parser)

      expect(option_parser).to receive(:parse!).with(@args)

      @cli.send(:parse)
    end

    it 'should parse a command when it is present' do
      allow(@cli).to receive(:arguments).and_return(['mycommand'])

      @cli.send(:parse)

      expect(@cli.options.command).to eq(:mycommand)
    end

    it 'should raise an exception when command is not present' do
      allow(@cli).to receive(:arguments).and_return([])

      expect { @cli.send(:parse) }.to raise_error(OptionParser::MissingArgument)
    end

    describe 'when parsing options' do
      it 'should parse a configuration path' do
        allow(@cli).to receive(:arguments).and_return(['create', '-c', 'config/myconfig.json'])

        @cli.send(:parse)

        expect(@cli.options.configuration_path).to eq('config/myconfig.json')
      end
    end
  end

  describe '#arguments' do
    it 'should return the arguments that were passed into the initializer' do
      cli = Tools::CLI.new(@args)
      result = cli.send(:arguments)

      expect(@args).to eq(result)
    end
  end

  describe '#command' do
    it 'should return the command stored in the options' do
      cli = Tools::CLI.new(@args)
      allow(cli).to receive(:options).and_return(OpenStruct.new(command: '123abc'))

      result = cli.send(:command)
      expect(result).to eq '123abc'
    end
  end

  describe '#validate' do
    before { @cli = Tools::CLI.new(@args) }

    it 'should not raise an error if the command is valid' do
      allow(@cli).to receive(:valid_command?).and_return(true)

      expect { @cli.send(:validate) }.to_not raise_error
    end

    it 'should raise an error if the command is invalid' do
      allow(@cli).to receive(:valid_command?).and_return(false)

      expect { @cli.send(:validate) }.to raise_error(Tools::InvalidCommandException)
    end
  end

  describe '#valid_command?' do
    before do
      @cli = Tools::CLI.new(@args)
      stub_const('Tools::CLI::AVAILABLE_COMMANDS', [:good_command, :best_command])
    end

    it 'should return true for a valid command' do
      allow(@cli).to receive(:command).and_return(:good_command)

      result = @cli.send(:valid_command?)

      expect(result).to eq(true)
    end

    it 'should return false for an invalid command' do
      allow(@cli).to receive(:command).and_return(:bad_command)

      result = @cli.send(:valid_command?)

      expect(result).to eq(false)
    end
  end

  describe '#option_parser' do
    before :each do
      # Don't call parse
      allow_any_instance_of(Tools::CLI).to receive(:parse)
      # Stub command so we don't trip validation
      allow_any_instance_of(Tools::CLI).to receive(:command).and_return(:create)
      # Initialize
      @cli = Tools::CLI.new(@args)
      # Revert back to original
      allow_any_instance_of(Tools::CLI).to receive(:parse).and_call_original
    end

    it 'should initialize an OptionParser' do
      expect(OptionParser).to receive(:new)

      @cli.send(:option_parser)
    end

    it 'should only ever initialize one OptionParser' do
      hash1 = @cli.send(:option_parser).hash
      hash2 = @cli.send(:option_parser).hash

      expect(hash1).to eq(hash2)
    end
  end
end
