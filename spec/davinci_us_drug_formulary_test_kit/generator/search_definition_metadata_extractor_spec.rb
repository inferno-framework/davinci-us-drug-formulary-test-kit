require_relative '../../../lib/davinci_us_drug_formulary_test_kit/generator/search_metadata_extractor'

RSpec.describe DaVinciUSDrugFormularyTestKit::Generator::SearchDefinitionMetadataExtractor do
  # really slime the subject here because we don't care about interactions
  # if this test file grows, this will likely break and more stubbing and setup will be required
  subject(:metadata_extractor) { described_class.new('test', 'nothing', 'nope', 'no') }

  describe '#full_paths' do
    let(:param) do
      ig_resource = double
      allow(ig_resource).to receive(:expression).and_return(expression)
      ig_resource
    end

    context 'with a single dateTime expression' do
      let(:expression) { 'Condition.onset.as(dateTime)' }

      it 'parses correctly' do
        allow(metadata_extractor).to receive(:param).and_return(param)

        expected = ['Condition.onsetDateTime']
        expect(metadata_extractor.full_paths).to eq(expected)
      end
    end

    context 'with a single period expression' do
      let(:expression) { 'Condition.onset.as(Period)' }

      it 'parses correctly' do
        allow(metadata_extractor).to receive(:param).and_return(param)

        expected = ['Condition.onsetPeriod']
        expect(metadata_extractor.full_paths).to eq(expected)
      end
    end

    context 'with two expressions' do
      let(:expression) { 'Condition.onset.as(dateTime)|Condition.onset.as(Period)' }

      it 'parses correctly' do
        allow(metadata_extractor).to receive(:param).and_return(param)

        expected = ['Condition.onsetDateTime', 'Condition.onsetPeriod']
        expect(metadata_extractor.full_paths).to eq(expected)
      end
    end
  end
end
