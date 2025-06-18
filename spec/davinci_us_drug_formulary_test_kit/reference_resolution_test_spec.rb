require_relative '../../lib/davinci_us_drug_formulary_test_kit/reference_resolution_test'

RSpec.describe DaVinciUSDrugFormularyTestKit::ReferenceResolutionTest, :runnable do
  let(:suite_id) { 'davinci_us_drug_formulary_v201' }

  describe '#validate_reference_resolution' do
    let(:test_class) do
      Class.new(Inferno::Entities::Test) do
        include DaVinciUSDrugFormularyTestKit::ReferenceResolutionTest

        fhir_client { url 'https://example.com/fhir' }
      end
    end

    let(:test) { test_class.new(scratch: {}) }
    let(:base_url) { 'https://example.com/fhir' }

    context 'when the reference has already been resolved' do
      let(:reference_string) { 'Encounter/123' }
      let(:resource) do
        FHIR::Observation.new(encounter: { reference: reference_string })
      end
      let(:reference) { resource.encounter }

      it 'returns true' do
        target_profile = 'abc'
        test.record_resolved_reference(reference, target_profile)

        expect(test.validate_reference_resolution(resource, reference, target_profile)).to be(true)
        expect(test.is_reference_resolved?(reference, target_profile)).to be(true)
        expect(test.requests.length).to eq(0)
      end
    end

    context 'with a reference to a contained resource' do
      let(:reference_string) { '#123' }

      it 'returns true if the contained resource is present' do
        resource =
          FHIR::Observation.new(encounter: { reference: reference_string }, contained: [FHIR::Encounter.new(id: '123')])
        reference = resource.encounter

        expect(test.validate_reference_resolution(resource, reference, nil)).to be(true)
        expect(test.requests.length).to eq(0)
      end

      it 'returns false if the contained resource is not present' do
        resource =
          FHIR::Observation.new(encounter: { reference: reference_string })
        reference = resource.encounter

        expect(test.validate_reference_resolution(resource, reference, nil)).to be(false)

        resource =
          FHIR::Observation.new(encounter: { reference: reference_string }, contained: [FHIR::Encounter.new(id: '456')])

        expect(test.validate_reference_resolution(resource, reference, nil)).to be(false)
        expect(test.requests.length).to eq(0)
      end
    end

    context 'with a relative reference' do
      let(:reference_string) { 'Encounter/123' }
      let(:resource) do
        FHIR::Observation.new(encounter: { reference: reference_string })
      end
      let(:reference) { resource.encounter }
      let(:referenced_resource) { FHIR::Encounter.new(id: '123') }

      it 'returns true if the reference can be resolved' do
        # set target_profile to be nil to skip calling validator
        target_profile = nil
        request =
          stub_request(:get, "#{base_url}/#{reference_string}")
            .to_return(status: 200, body: referenced_resource.to_json)

        expect(test.validate_reference_resolution(resource, reference, target_profile)).to be(true)
        expect(request).to have_been_made.once
        expect(test.is_reference_resolved?(reference, target_profile)).to be(true)
        expect(test.requests.length).to eq(1)
      end

      it 'returns false if the reference can not be resolved' do
        request =
          stub_request(:get, "#{base_url}/#{reference_string}")
            .to_return(status: 404, body: '')

        expect(test.validate_reference_resolution(resource, reference, nil)).to be(false)
        expect(request).to have_been_made.once
        expect(test.requests.length).to eq(1)
      end
    end

    context 'with an absolute reference to the same server' do
      let(:reference_string) { "#{base_url}/Encounter/123" }
      let(:resource) do
        FHIR::Observation.new(encounter: { reference: reference_string })
      end
      let(:reference) { resource.encounter }
      let(:referenced_resource) { FHIR::Encounter.new(id: '123') }

      it 'returns true if the reference can be resolved' do
        request =
          stub_request(:get, reference_string)
            .to_return(status: 200, body: referenced_resource.to_json)

        expect(test.validate_reference_resolution(resource, reference, nil)).to be(true)
        expect(request).to have_been_made.once
        expect(test.requests.length).to eq(1)
      end

      it 'returns false if the reference can not be resolved' do
        request =
          stub_request(:get, reference_string)
            .to_return(status: 404, body: '')

        expect(test.validate_reference_resolution(resource, reference, nil)).to be(false)
        expect(request).to have_been_made.once
        expect(test.requests.length).to eq(1)
      end
    end

    context 'with an absolute reference to a different server' do
      let(:reference_string) { 'https://example.org/fhir/Encounter/123' }
      let(:resource) do
        FHIR::Observation.new(encounter: { reference: reference_string })
      end
      let(:reference) { resource.encounter }
      let(:referenced_resource) { FHIR::Encounter.new(id: '123') }

      it 'returns true if the reference can be resolved' do
        request =
          stub_request(:get, reference_string)
            .to_return(status: 200, body: referenced_resource.to_json)

        expect(test.validate_reference_resolution(resource, reference, nil)).to be(true)
        expect(request).to have_been_made.once
        expect(test.requests.length).to eq(1)
      end

      it 'returns false if the reference can not be resolved' do
        request =
          stub_request(:get, reference_string)
            .to_return(status: 404, body: '')

        expect(test.validate_reference_resolution(resource, reference, nil)).to be(false)
        expect(request).to have_been_made.once
        expect(test.requests.length).to eq(1)
      end
    end

    context 'with a target profile' do
      context 'with a contained reference' do
        let(:reference_string) { '#123' }
        let(:contained_resource) { FHIR::Encounter.new(id: '123') }
        let(:resource) do
          FHIR::Observation.new(encounter: { reference: reference_string }, contained: [contained_resource])
        end
        let(:reference) { resource.encounter }

        it 'returns true if the contained resource conforms to the target profile' do
          allow(test).to receive(:resource_is_valid_with_target_profile?).with(contained_resource,
                                                                               'PROFILE').and_return(true)

          expect(test.validate_reference_resolution(resource, reference, 'PROFILE')).to be(true)
        end

        it 'returns false if the contained resource does not conform to the target profile' do
          allow(test).to receive(:resource_is_valid_with_target_profile?).with(contained_resource,
                                                                               'PROFILE').and_return(false)

          expect(test.validate_reference_resolution(resource, reference, 'PROFILE')).to be(false)
        end
      end

      context 'with a non-contained reference' do
        let(:reference_string) { 'Encounter/123' }
        let(:resource) do
          FHIR::Observation.new(encounter: { reference: reference_string })
        end
        let(:reference) { resource.encounter }
        let(:referenced_resource) { FHIR::Encounter.new(id: '123') }

        before do
          stub_request(:get, "#{base_url}/#{reference_string}")
            .to_return(status: 200, body: referenced_resource.to_json)
        end

        it 'returns true if the referenced resource conforms to the target profile' do
          allow(test).to receive(:resource_is_valid_with_target_profile?).with(referenced_resource,
                                                                               'PROFILE').and_return(true)

          expect(test.validate_reference_resolution(resource, reference, 'PROFILE')).to be(true)
        end

        it 'returns false if the referenced resource does not conform to the target profile' do
          allow(test).to receive(:resource_is_valid_with_target_profile?).with(referenced_resource,
                                                                               'PROFILE').and_return(false)

          expect(test.validate_reference_resolution(resource, reference, 'PROFILE')).to be(false)
        end
      end
    end
  end

  describe '#perform_reference_resolution_test' do
    let(:url) { 'http://example.com/fhir' }
    let(:error_outcome) { FHIR::OperationOutcome.new(issue: [{ severity: 'error' }]) }

    describe 'reference validation with target profiles' do
      let(:test_class) do
        Class.new(DaVinciUSDrugFormularyTestKit::DaVinciUSDrugFormularyV201::PayerInsurancePlanReferenceResolutionTest) do # rubocop:disable Layout/LineLength
          fhir_client { url :url }
          input :url
        end
      end

      let(:plan_id) { 'ABC' }
      let(:location_id) { 'DEF' }
      let(:formulary_id) { 'GHI' }

      let(:plan_ref) { "InsurancePlan/#{plan_id}" }
      let(:location_ref) { "Location/#{location_id}" }
      let(:formulary_ref) { "InsurancePlan/#{formulary_id}" }

      let(:plan) do
        FHIR::InsurancePlan.new(
          id: plan_id,
          coverageArea: [{ reference: location_ref }],
          coverage: [
            {
              type: {
                coding: [
                  {
                    system: 'http://terminology.hl7.org/CodeSystem/v3-ActCode',
                    code: 'DRUGPOL'
                  }
                ]
              },
              extension: {
                url: 'http://hl7.org/fhir/us/davinci-drug-formulary/StructureDefinition/usdf-FormularyReference-extension',
                valueReference: formulary_ref
              }
            }
          ]
        )
      end

      let(:formulary) do
        FHIR::InsurancePlan.new(id: formulary_id)
      end
      let(:location) do
        FHIR::Location.new(id: location_id)
      end

      before do
        allow_any_instance_of(test_class)
          .to receive(:scratch_resources).and_return(
            {
              all: [plan]
            }
          )

        stub_request(:get, "#{url}/#{location_ref}")
          .to_return(status: 200, body: location.to_json)

        stub_request(:get, "#{url}/#{formulary_ref}")
          .to_return(status: 200, body: formulary.to_json)
      end

      context 'when reference read returns ok' do
        before do
          stub_request(:get, "#{url}/#{location_ref}")
            .to_return(status: 200, body: location.to_json)
          stub_request(:get, "#{url}/#{formulary_ref}")
            .to_return(status: 200, body: formulary.to_json)
        end

        it 'passes if all MS references can be read' do
          allow_any_instance_of(test_class)
            .to receive(:resource_is_valid_with_target_profile?).and_return(true)

          result = run(test_class, url:)
          expect(result.result).to eq('pass')
        end

        it 'skips if one MS references with MS target_profiles cannot be validated' do
          allow_any_instance_of(test_class)
            .to receive(:resource_is_valid_with_target_profile?).and_return(false)

          result = run(test_class, url:)
          expect(result.result).to eq('skip')
          expect(result.result_message).to include('coverageArea(http://hl7.org/fhir/us/davinci-drug-formulary/StructureDefinition/usdf-InsurancePlanLocation)')
        end
      end

      context 'when reference read returns error' do
        before do
          stub_request(:get, "#{url}/#{location_ref}")
            .to_return(status: 401)
        end

        it 'skips if one MS references cannot be read' do
          allow_any_instance_of(test_class)
            .to receive(:resource_is_valid_with_target_profile?).and_return(true)

          result = run(test_class, url:)
          expect(result.result).to eq('skip')
          expect(result.result_message).to start_with('Could not resolve Must Support references coverageArea')
        end
      end
    end
  end
end
