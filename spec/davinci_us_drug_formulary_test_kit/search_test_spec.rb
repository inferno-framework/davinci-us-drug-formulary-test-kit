require_relative '../../lib/davinci_us_drug_formulary_test_kit/search_test'

RSpec.describe DaVinciUSDrugFormularyTestKit::SearchTest, :runnable do
  let(:suite_id) { 'davinci_us_drug_formulary_v201' }
  let(:url) { 'http://example.com/fhir' }
  let(:error_outcome) { FHIR::OperationOutcome.new(issue: [{ severity: 'error' }]) }

  # 1. Search for each of the 4 profiles types
  # 2. RESTful behavior according to FHIR spec
  #  - https://www.hl7.org/fhir/search.html
  # 3. 4 response cases:
  #   - 400 invalid param
  #   - 401 unauthorized request
  #   - 403 insufficient scope
  #   - 404 unkown resource
  # 4. Support json source formats for all interactions
  # 5. Support search params for each profile individually and in combination

  describe 'search for medication knowledge by ID' do
    let(:medication_knowledge_search_test) do
      Class.new(Inferno::Test) do
        include DaVinciUSDrugFormularyTestKit::SearchTest

        def properties
          @properties ||= DaVinciUSDrugFormularyTestKit::SearchTestProperties.new(
            first_search: true,
            resource_type: 'MedicationKnowledge',
            search_param_names: ['status'],
            test_post_search: true
          )
        end

        def self.metadata
          @metadata ||=
            DaVinciUSDrugFormularyTestKit::Generator::GroupMetadata.new(
              YAML.load_file(
                File.join(
                  __dir__,
                  '..',
                  'fixtures',
                  'medication_knowledge_metadata.yml'
                )
              )
            )
        end

        def scratch_resources
          scratch[:medication_knowledge_resources] ||= {}
        end

        fhir_client { url :url }
        input :url

        run do
          run_search_test
        end
      end
    end

    let(:medication_knowledge1) do
      FHIR::MedicationKnowledge.new(
        id: '41446',
        meta: {
          versionId: '1',
          lastUpdated: '2019-10-09T14:20:10.188+00:00',
          source: '#40b42833446031a9'
        },
        status: 'active',
        code: {
          coding: [{
            system: 'http://hl7.org/fhir/sid/ndc',
            code: '0069-2587-10',
            display: 'Vancomycin Hydrochloride (VANCOMYCIN HYDROCHLORIDE)'
          }]
        }
      )
    end

    let(:bundle) { FHIR::Bundle.new(entry: [{ resource: medication_knowledge1 }]) }
    let(:test_scratch) { {} }

    before do
      Inferno::Repositories::Tests.new.insert(medication_knowledge_search_test)
    end

    it 'passes' do
      get_request =
        stub_request(:get, "#{url}/MedicationKnowledge?status=active")
          .to_return(status: 200, body: bundle.to_json)
      post_request =
        stub_request(:post, 'http://example.com/fhir/MedicationKnowledge/_search')
          .with(
            body: { 'status' => 'active' },
            headers: {
              'Content-Type' => 'application/x-www-form-urlencoded'
            }
          )
          .to_return(status: 200, body: bundle.to_json)

      result = run(medication_knowledge_search_test, url:)

      expect(result.result).to eq('pass')

      expect(get_request).to have_been_made.once
      expect(post_request).to have_been_made.once
    end
  end

  describe 'search using _include' do
    let(:input_ids) { 'FormularyItem-123' }
    let(:formulary_item) do
      FHIR::Basic.new(
        id: input_ids,
        meta: {
          lastUpdated: '2022-09-12T18:07:56.948+00:00'
        },
        extension: [
          {
            url: 'http://hl7.org/fhir/us/davinci-drug-formulary/StructureDefinition/usdf-FormularyReference-extension',
            valueReference: {
              reference: 'InsurancePlan/Formulary-10207VA0380003',
              type: 'InsurancePlan'
            }
          },
          {
            url: 'http://hl7.org/fhir/us/davinci-drug-formulary/StructureDefinition/usdf-AvailabilityStatus-extension',
            valueCode: 'active'
          },
          {
            url: 'http://hl7.org/fhir/us/davinci-drug-formulary/StructureDefinition/usdf-PharmacyBenefitType-extension',
            valueCodeableConcept: {
              coding: [
                {
                  system: 'http://hl7.org/fhir/us/davinci-drug-formulary/CodeSystem/usdf-PharmacyBenefitTypeCS',
                  code: '1-month-in-retail',
                  display: '1 month in network retail'
                }
              ]
            }
          },
          {
            url: 'http://hl7.org/fhir/us/davinci-drug-formulary/StructureDefinition/usdf-DrugTierID-extension',
            valueCodeableConcept: {
              coding: [
                {
                  system: 'http://hl7.org/fhir/us/davinci-drug-formulary/CodeSystem/usdf-DrugTierCS',
                  code: 'generic',
                  display: 'Generic'
                }
              ]
            }
          }
        ],
        code: {
          coding: [
            {
              system: 'http://example.com/fhir/CodeSystem/usdf-InsuranceItemTypeCS',
              code: 'formulary-item',
              display: 'Formulary Item'
            }
          ]
        },
        subject: {
          reference: 'MedicationKnowledge/Drug-123',
          type: 'MedicationKnowledge'
        }
      )
    end
    let(:medication_knowledge) do
      FHIR::MedicationKnowledge.new(
        id: 'Drug-123',
        meta: {
          versionId: '1',
          lastUpdated: '2019-10-09T14:20:10.188+00:00',
          source: '#40b42833446031a9'
        },
        status: 'active',
        code: {
          coding: [{
            system: 'http://hl7.org/fhir/sid/ndc',
            code: '0069-2587-10',
            display: 'Vancomycin Hydrochloride (VANCOMYCIN HYDROCHLORIDE)'
          }]
        }
      )
    end
    let(:formulary_item_include_test) do
      Class.new(Inferno::Test) do
        include DaVinciUSDrugFormularyTestKit::SearchTest

        def properties
          @properties ||= DaVinciUSDrugFormularyTestKit::SearchTestProperties.new(
            include_param: 'Basic:subject',
            include_search_look_up_param: 'subject',
            resource_type: 'Basic',
            search_param_names: ['code']
          )
        end

        def self.metadata
          @metadata ||=
            DaVinciUSDrugFormularyTestKit::Generator::GroupMetadata.new(
              YAML.load_file(
                File.join(
                  __dir__,
                  '..',
                  'fixtures',
                  'formulary_item_metadata.yml'
                )
              )
            )
        end

        fhir_client { url :url }
        input :url, :input_ids

        run do
          run_include_search_test
        end
      end
    end

    let(:bundle) do
      FHIR::Bundle.new(entry: [{ resource: formulary_item, search: { mode: 'match' } },
                               { resource: medication_knowledge, search: { mode: 'include' } }])
    end

    before { Inferno::Repositories::Tests.new.insert(formulary_item_include_test) }

    it 'passes when the referenced resource is included in the bundle' do
      get_request =
        stub_request(:get, "#{url}/Basic?_include=Basic:subject&code=formulary-item")
          .to_return(status: 200, body: bundle.to_json)

      result = run(formulary_item_include_test, url:, input_ids:)

      expect(result.result).to eq('pass')
      expect(get_request).to have_been_made.once
    end

    it 'fails when the referenced resource is not included in the bundle' do
      bundle.entry.pop

      get_request =
        stub_request(:get, "#{url}/Basic?_include=Basic:subject&code=formulary-item")
          .to_return(status: 200, body: bundle.to_json)

      result = run(formulary_item_include_test, url:, input_ids:)

      expect(result.result).to eq('fail')
      expect(get_request).to have_been_made.once
    end

    it 'skips when the resource has no include references' do
      bundle.entry.first.resource.subject = nil

      get_request =
        stub_request(:get, "#{url}/Basic?_include=Basic:subject&code=formulary-item")
          .to_return(status: 200, body: bundle.to_json)

      result = run(formulary_item_include_test, url:, input_ids:)

      expect(result.result).to eq('skip')
      expect(get_request).to have_been_made.once
    end
  end
end
