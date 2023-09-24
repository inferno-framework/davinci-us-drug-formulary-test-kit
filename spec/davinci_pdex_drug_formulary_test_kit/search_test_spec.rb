require_relative '../../lib/davinci_pdex_drug_formulary_test_kit/search_test'

RSpec.describe DaVinciPDEXDrugFormularyTestKit::SearchTest do
  let(:suite) { Inferno::Repositories::TestSuites.new.find('usdf_v200') }
  let(:session_data_repo) { Inferno::Repositories::SessionData.new }
  let(:test_session) { repo_create(:test_session, test_suite_id: suite.id) }
  let(:url) { 'http://example.com/fhir' }
  let(:error_outcome) { FHIR::OperationOutcome.new(issue: [{ severity: 'error' }]) }

  def run(runnable, inputs = {})
    test_run_params = { test_session_id: test_session.id }.merge(runnable.reference_hash)
    test_run = Inferno::Repositories::TestRuns.new.create(test_run_params)
    inputs.each do |name, value|
      session_data_repo.save(test_session_id: test_session.id, name:, value:,
                             type: runnable.config.input_type(name))
    end
    Inferno::TestRunner.new(test_session:, test_run:).run(runnable)
  end

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
        include DaVinciPDEXDrugFormularyTestKit::SearchTest

        def properties
          @properties ||= DaVinciPDEXDrugFormularyTestKit::SearchTestProperties.new(
            first_search: true,
            resource_type: 'MedicationKnowledge',
            search_param_names: ['status'],
            test_post_search: true
          )
        end

        def self.metadata
          @metadata ||=
            DaVinciPDEXDrugFormularyTestKit::Generator::GroupMetadata.new(
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
      allow_any_instance_of(medication_knowledge_search_test)
        .to receive(:scratch).and_return(test_scratch)
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
end
