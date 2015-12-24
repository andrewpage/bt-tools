require 'spec_helper'

describe Tools::InvalidCommandException do
  before do
    @exception = Tools::InvalidCommandException.new(:not_create, [:create, :transcode])
  end

  describe '#message' do
    before { @message = @exception.message }

    it 'should include the invalid command' do
      expect(@message).to include('not_create')
    end

    it 'should include the valid options' do
      expect(@message).to include('create')
      expect(@message).to include('transcode')
    end
  end

  describe '#available_commands_string' do
    it 'should join all available commands by comma' do
      expect(@exception.send(:available_commands_string)).to eq('create, transcode')
    end
  end
end

describe Tools::MissingKeysException do
  before do
    @exception = Tools::MissingKeysException.new([:key1, :key2])
  end

  describe '#message' do
    before { @message = @exception.message }

    it 'should include the missing keys' do
      expect(@message).to include('key1')
      expect(@message).to include('key2')
    end
  end

  describe '#required_keys_string' do
    it 'should join all required keys by comma' do
      expect(@exception.send(:required_keys_string)).to eq("'key1', 'key2'")
    end
  end
end
