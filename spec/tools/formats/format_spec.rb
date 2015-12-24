require 'spec_helper'

describe Tools::Formats::Format do
  describe '#create_from_configuration' do
    before do
      allow_any_instance_of(Tools::Formats::Format).to receive(:extract_files)
    end
    let(:configuration) do
      {
        '320' => 'path/to/transcode-320.json',
        'V0' => 'path/to/transcode-V0.json',
        'V2' => 'path/to/transcode-V2.json'
      }
    end

    it 'should generate a namespaced class for each format' do
      expect(Tools::Formats::Format).to receive(:namespaced_class).with('F320').and_return(Tools::Formats::F320)
      expect(Tools::Formats::Format).to receive(:namespaced_class).with('FV0').and_return(Tools::Formats::FV0)
      expect(Tools::Formats::Format).to receive(:namespaced_class).with('FV2').and_return(Tools::Formats::FV2)

      Tools::Formats::Format.create_from_configuration(configuration)
    end

    it 'should return a list of Formats' do
      result = Tools::Formats::Format.create_from_configuration(configuration)

      expect(result).to be_kind_of(Array)

      result.each { |ft| expect(ft).to be_kind_of(Tools::Formats::Format) }
    end
  end

  describe '#format_class_name' do
    it 'should prefix the format name with an F' do
      result = Tools::Formats::Format.send(:format_class_name, 'MyClass')

      expect(result).to eq('FMyClass')
    end
  end

  describe '#namespaced_class' do
    it 'should correctly namespace the class' do
      result = Tools::Formats::Format.send(:namespaced_class, 'F320')

      expect(result).to eq(Tools::Formats::F320)
    end

    it "should raise an exception if the class doesn't exist" do
      expect do
        Tools::Formats::Format.send(:namespaced_class, 'Nope')
      end.to raise_error(NameError)
    end
  end

  describe '#initialize' do
    it 'should extract files from the specified manifest' do
      manifest = 'path/to/manifest.json'

      expect_any_instance_of(Tools::Formats::Format).to receive(:extract_files).with(manifest)

      Tools::Formats::Format.send(:new, manifest)
    end
  end
end
