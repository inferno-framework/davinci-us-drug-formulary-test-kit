require_relative '../../../lib/davinci_us_drug_formulary_test_kit/generator/must_support_metadata_extractor'

RSpec.describe DaVinciUSDrugFormularyTestKit::Generator::MustSupportMetadataExtractor do
  subject(:metadata_extractor) { described_class.new([profile_element], profile, 'resourceConstructor', ig_resources) }

  let(:profile) do
    profile = instance_double(FHIR::StructureDefinition)
    allow(profile).to receive_messages(baseDefinition: 'baseDefinition', name: 'name', type: 'type', version: 'version')
    profile
  end

  let(:ig_resources) do
    ig_resources = double
    allow(ig_resources).to receive(:value_set_by_url).and_return(nil)
    ig_resources
  end

  let(:type) do
    type = double
    allow(type).to receive(:profile).and_return(['profile_url'])
    type
  end

  let(:profile_element) { double }

  before do
    allow(profile_element).to receive_messages(mustSupport: true, path: 'foo.extension', id: 'id', type: [type])
  end

  describe '#get_type_must_support_metadata' do
    let(:metadata) do
      { path: 'path' }
    end

    let(:type) do
      type = double
      allow(type).to receive_messages(extension: 'extension', code: 'code')
      type
    end

    let(:element) do
      element = double
      allow(element).to receive(:type).and_return([type])
      element
    end

    it 'returns a path and an original path when type_must_support_extension is true' do
      allow(metadata_extractor).to receive(:type_must_support_extension?).and_return(true)

      result = metadata_extractor.get_type_must_support_metadata(metadata, element)

      expected = [{ original_path: 'path', path: 'pathCode' }]
      expect(result).to eq(expected)
    end

    it 'returns an empty array when type_must_support_extension is false' do
      allow(metadata_extractor).to receive(:type_must_support_extension?).and_return(false)

      result = metadata_extractor.get_type_must_support_metadata(metadata, element)

      expected = []
      expect(result).to eq(expected)
    end
  end
end
