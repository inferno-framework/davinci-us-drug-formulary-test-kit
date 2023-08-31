require_relative '../../lib/davinci_pdex_drug_formulary_test_kit/custom_groups/capability_statement/profile_support_test'

RSpec.describe DaVinciPDEXDrugFormularyTestKit::ProfileSupportTest do
  def run(runnable, inputs = {})
    test_run_params = { test_session_id: test_session.id }.merge(runnable.reference_hash)
    test_run = Inferno::Repositories::TestRuns.new.create(test_run_params)
    inputs.each do |name, value|
      session_data_repo.save(
        test_session_id: test_session.id,
        name: name,
        value: value,
        type: runnable.config.input_type(name) || 'text'
      )
    end
    Inferno::TestRunner.new(test_session: test_session, test_run: test_run).run(runnable)
  end

  let(:session_data_repo) { Inferno::Repositories::SessionData.new }
  let(:test_session) { repo_create(:test_session, test_suite_id: suite.id) }
  let(:suite) { Inferno::Repositories::TestSuites.new.find('usdf_v200') }
  let(:test) { described_class }
  let(:url) { 'http://example.com/fhir' }

  context 'with no required resources' do
    before do
      allow_any_instance_of(test).to receive(:config).and_return(
                                       OpenStruct.new(
                                         options: {
                                          # omitting 'GraphDefinition'
                                           required_resources: ['InsurancePlan', 'Basic', 'MedicationKnowledge', 'Location']
                                         }
                                       )
                                     )
    end

    it 'fails if not all base resources are supported' do
      response_body =
        FHIR::CapabilityStatement.new(
          rest: [
            {
              resource: [
                {
                  type: 'InsurancePlan'
                },
                {
                  type: 'Basic'
                },
                {
                  type: 'MedicationKnowledge'
                }
                # ,
                # {
                #   type: 'GraphDefinition'
                # }
              ]
            }
          ]
        ).to_json
      repo_create(:request, response_body:, name: 'capability_statement', test_session_id: test_session.id)

      result = run(test, url:)

      expect(result.result).to eq('fail')
      expect(result.result_message).to include('Location')
    end


    it 'passes if only required resources are supported' do
      response_body =
        FHIR::CapabilityStatement.new(
          rest: [
            {
              resource: [
                {
                  type: 'InsurancePlan'
                },
                {
                  type: 'Basic'
                },
                {
                  type: 'MedicationKnowledge'
                },
                {
                  type: 'Location'
                }
                # ,
                # {
                #   type: 'GraphDefinition'
                # }
              ]
            }
          ]
        ).to_json
      repo_create(:request, response_body:, name: 'capability_statement', test_session_id: test_session.id)

      result = run(test, url:)

      expect(result.result).to eq('pass')
    end

    it 'passes if unrequired resources are supported as well' do
      response_body =
        FHIR::CapabilityStatement.new(
          rest: [
            {
              resource: [
                {
                  type: 'InsurancePlan'
                },
                {
                  type: 'Basic'
                },
                {
                  type: 'MedicationKnowledge'
                },
                {
                  type: 'Location'
                },
                {
                  type: 'GraphDefinition'
                },
                {
                  type: 'Patient'
                }
              ]
            }
          ]
        ).to_json
      repo_create(:request, response_body:, name: 'capability_statement', test_session_id: test_session.id)

      result = run(test, url:)
      expect(result.result).to eq('pass')
    end
  end
end
