require_relative '../../lib/davinci_us_drug_formulary_test_kit/must_support_test'

RSpec.describe DaVinciUSDrugFormularyTestKit::MustSupportTest do
  let(:suite) { Inferno::Repositories::TestSuites.new.find('davinci_us_drug_formulary_v201') }
  let(:session_data_repo) { Inferno::Repositories::SessionData.new }
  let(:test_session) { repo_create(:test_session, test_suite_id: suite.id) }
  # let(:patient_ref) { 'Patient/85' }

  def run(runnable, inputs = {})
    test_run_params = { test_session_id: test_session.id }.merge(runnable.reference_hash)
    test_run = Inferno::Repositories::TestRuns.new.create(test_run_params)
    inputs.each do |name, value|
      session_data_repo.save(
        test_session_id: test_session.id,
        name:,
        value:,
        type: runnable.config.input_type(name)
      )
    end
    Inferno::TestRunner.new(test_session:, test_run:).run(runnable)
  end

  describe 'must support test for MedicationKnowledge elements' do
    let(:medication_must_support_test) do
      Inferno::Repositories::Tests.new.find('usdf_v201_medication_knowledge_must_support_test')
    end
    let(:medication1) do
      FHIR::MedicationKnowledge.new(
        id: 'Drug-1607990',
        meta: {
          versionId: '1',
          lastUpdated: '2019-10-09T14:20:10.188+00:00',
          source: '#40b42833446031a9'
        },
        status: 'active',
        code: {
          coding: [{
            system: 'http://www.nlm.nih.gov/research/umls/rxnorm',
            code: '1607990',
            display: '{24 (ethinyl estradiol 0.025 MG /
            norethindrone 0.8 MG Chewable Tablet) / 4 (ferrous fumarate 75 MG Chewable Tablet) } Pack'
          }]
        },
        doseForm: {
          coding: [
            {
              system: 'http://www.snomed.org/',
              code: '66076007',
              display: 'Chewable tablet'
            }
          ]
        }
      )
    end

    it 'passes if server suports all MS elements for formulary drug' do
      allow_any_instance_of(medication_must_support_test)
        .to receive(:scratch_resources).and_return(
          {
            all: [medication1]
          }
        )

      result = run(medication_must_support_test)
      expect(result.result).to eq('pass')
    end

    it 'fails if server does not support one MS element' do
      medication1.status = nil
      allow_any_instance_of(medication_must_support_test)
        .to receive(:scratch_resources).and_return(
          {
            all: [medication1]
          }
        )

      result = run(medication_must_support_test)
      expect(result.result).to eq('skip')
      expect(result.result_message).to include('status')
    end
  end

  describe 'must support test for extensions' do
    let(:formulary_item_must_support_test) do
      Inferno::Repositories::Tests.new.find('usdf_v201_basic_must_support_test')
    end
    let(:formulary_item) do
      FHIR::Basic.new(
        resourceType: 'Basic',
        id: 'FormularyItem-D1002-1000091',
        meta: {
          lastUpdated: '2021-08-22T18:36:03.000+00:00',
          profile: [
            'http://hl7.org/fhir/us/davinci-drug-formulary/StructureDefinition/usdf-FormularyItem'
          ]
        },
        extension: [
          {
            url: 'http://hl7.org/fhir/us/davinci-drug-formulary/StructureDefinition/usdf-FormularyReference-extension',
            valueReference: {
              reference: 'InsurancePlan/FormularyD1002'
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
                  system: 'http://hl7.org/fhir/us/davinci-drug-formulary/CodeSystem/usdf-PharmacyBenefitTypeCS-TEMPORARY-TRIAL-USE',
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
                  system: 'http://hl7.org/fhir/us/davinci-drug-formulary/CodeSystem/usdf-DrugTierCS-TEMPORARY-TRIAL-USE',
                  code: 'generic',
                  display: 'Generic'
                }
              ]
            }
          },
          {
            url: 'http://hl7.org/fhir/us/davinci-drug-formulary/StructureDefinition/usdf-AvailabilityPeriod-extension',
            valuePeriod: {
              start: '2021-01-01',
              end: '2021-12-31'
            }
          },
          {
            url: 'http://hl7.org/fhir/us/davinci-drug-formulary/StructureDefinition/usdf-PharmacyBenefitType-extension',
            valueCodeableConcept: {
              coding: [
                {
                  system: 'http://hl7.org/fhir/us/davinci-drug-formulary/CodeSystem/usdf-PharmacyBenefitTypeCS-TEMPORARY-TRIAL-USE',
                  code: '1-month-in-mail',
                  display: '1 month in network mail order'
                }
              ]
            }
          },
          {
            url: 'http://hl7.org/fhir/us/davinci-drug-formulary/StructureDefinition/usdf-PharmacyBenefitType-extension',
            valueCodeableConcept: {
              coding: [
                {
                  system: 'http://hl7.org/fhir/us/davinci-drug-formulary/CodeSystem/usdf-PharmacyBenefitTypeCS-TEMPORARY-TRIAL-USE',
                  code: '3-month-in-retail',
                  display: '3 month in network retail'
                }
              ]
            }
          },
          {
            url: 'http://hl7.org/fhir/us/davinci-drug-formulary/StructureDefinition/usdf-PharmacyBenefitType-extension',
            valueCodeableConcept: {
              coding: [
                {
                  system: 'http://hl7.org/fhir/us/davinci-drug-formulary/CodeSystem/usdf-PharmacyBenefitTypeCS-TEMPORARY-TRIAL-USE',
                  code: '3-month-in-mail',
                  display: '3 month in network mail order'
                }
              ]
            }
          },
          {
            url: 'http://hl7.org/fhir/us/davinci-drug-formulary/StructureDefinition/usdf-PriorAuthorization-extension',
            valueBoolean: false
          },
          {
            url: 'http://hl7.org/fhir/us/davinci-drug-formulary/StructureDefinition/usdf-StepTherapyLimit-extension',
            valueBoolean: true
          },
          {
            url: 'http://hl7.org/fhir/us/davinci-drug-formulary/StructureDefinition/usdf-StepTherapyLimitNewStartsOnly-extension',
            valueBoolean: true
          },
          {
            url: 'http://hl7.org/fhir/us/davinci-drug-formulary/StructureDefinition/usdf-QuantityLimit-extension',
            valueBoolean: true
          }
        ],
        code: {
          coding: [
            {
              system: 'http://hl7.org/fhir/us/davinci-drug-formulary/CodeSystem/usdf-InsuranceItemTypeCS',
              code: 'formulary-item',
              display: 'Formulary Item'
            }
          ]
        },
        subject: {
          reference: 'MedicationKnowledge/FormularyDrug-1000091'
        }
      )
    end

    it 'passes if server suports all MS extensions' do
      allow_any_instance_of(formulary_item_must_support_test)
        .to receive(:scratch_resources).and_return(
          {
            all: [formulary_item]
          }
        )

      result = run(formulary_item_must_support_test)

      expect(result.result).to eq('pass')
    end

    it 'fails if server does not support one MS extensions' do
      formulary_item.extension.delete_at(0)

      allow_any_instance_of(formulary_item_must_support_test)
        .to receive(:scratch_resources).and_return(
          {
            all: [formulary_item]
          }
        )

      result = run(formulary_item_must_support_test)

      expect(result.result).to eq('skip')
      expect(result.result_message).to include('Basic.extension:usdf-FormularyReference-extension')
    end
  end

  # example includes slice by type, value
  describe 'must support test for slices' do
    context 'when slicing with pattern' do
      let(:payer_insurance_plan_must_support_test) do
        Inferno::Repositories::Tests.new.find('usdf_v201_payer_insurance_plan_must_support_test')
      end
      let(:payer_insurance_plan) do
        FHIR::InsurancePlan.new(
          resourceType: 'InsurancePlan',
          id: 'PayerInsurancePlanA1002',
          meta: {
            lastUpdated: '2021-08-22T18:36:03.000+00:00',
            profile: [
              'http://hl7.org/fhir/us/davinci-drug-formulary/StructureDefinition/usdf-PayerInsurancePlan'
            ]
          },
          identifier: [
            {
              value: 'A1002'
            }
          ],
          status: 'active',
          type: [
            {
              coding: [
                {
                  system: 'http://hl7.org/fhir/us/davinci-pdex-plan-net/CodeSystem/InsuranceProductTypeCS',
                  code: 'mediadv'
                }
              ]
            }
          ],
          name: 'Sample Medicare Advantage Plan A1002',
          period: {
            start: '2021-01-01',
            end: '2021-12-31'
          },
          coverageArea: [
            {
              reference: 'Location/StateOfCTLocation'
            }
          ],
          contact: [
            {
              purpose: {
                coding: [
                  {
                    system: 'http://terminology.hl7.org/CodeSystem/contactentity-type',
                    code: 'PATINF'
                  }
                ]
              },
              telecom: [
                {
                  system: 'phone',
                  value: '+1 (888) 555-1002'
                }
              ]
            },
            {
              purpose: {
                coding: [
                  {
                    system: 'http://hl7.org/fhir/us/davinci-drug-formulary/CodeSystem/usdf-PlanContactTypeCS-TEMPORARY-TRIAL-USE',
                    code: 'MARKETING'
                  }
                ]
              },
              name: {
                text: 'Sample Medicare Advantage Plan Marketing Website'
              },
              telecom: [
                {
                  system: 'url',
                  value: 'http://url/to/health/plan/information'
                }
              ]
            },
            {
              purpose: {
                coding: [
                  {
                    system: 'http://hl7.org/fhir/us/davinci-drug-formulary/CodeSystem/usdf-PlanContactTypeCS-TEMPORARY-TRIAL-USE',
                    code: 'SUMMARY'
                  }
                ]
              },
              name: {
                text: 'Sample Medicare Advantage Drug Plan Benefit Website'
              },
              telecom: [
                {
                  system: 'url',
                  value: 'http://url/to/health/plan/information'
                }
              ]
            },
            {
              purpose: {
                coding: [
                  {
                    system: 'http://hl7.org/fhir/us/davinci-drug-formulary/CodeSystem/usdf-PlanContactTypeCS-TEMPORARY-TRIAL-USE',
                    code: 'FORMULARY'
                  }
                ]
              },
              name: {
                text: 'Sample Medicare Advantage Drug Plan Formulary Website'
              },
              telecom: [
                {
                  system: 'url',
                  value: 'http://url/to/health/plan/information'
                }
              ]
            }
          ],
          coverage: [
            {
              extension: [
                {
                  url: 'http://hl7.org/fhir/us/davinci-drug-formulary/StructureDefinition/usdf-FormularyReference-extension',
                  valueReference: {
                    reference: 'InsurancePlan/FormularyD1002'
                  }
                }
              ],
              type: {
                coding: [
                  {
                    system: 'http://terminology.hl7.org/CodeSystem/v3-ActCode',
                    code: 'DRUGPOL'
                  }
                ]
              },
              benefit: [
                {
                  type: {
                    coding: [
                      {
                        system: 'http://terminology.hl7.org/CodeSystem/insurance-plan-type',
                        code: 'drug',
                        display: 'Drug'
                      }
                    ]
                  }
                }
              ]
            }
          ],
          plan: [
            {
              type: {
                coding: [
                  {
                    system: 'http://terminology.hl7.org/CodeSystem/insurance-plan-type',
                    code: 'drug',
                    display: 'Drug'
                  }
                ]
              },
              specificCost: [
                {
                  category: {
                    coding: [
                      {
                        system: 'http://hl7.org/fhir/us/davinci-drug-formulary/CodeSystem/usdf-PharmacyBenefitTypeCS-TEMPORARY-TRIAL-USE',
                        code: '1-month-in-retail',
                        display: '1 month in network retail'
                      }
                    ]
                  },
                  benefit: [
                    {
                      type: {
                        coding: [
                          {
                            system: 'http://hl7.org/fhir/us/davinci-drug-formulary/CodeSystem/usdf-DrugTierCS-TEMPORARY-TRIAL-USE',
                            code: 'brand',
                            display: 'Brand'
                          }
                        ]
                      },
                      cost: [
                        {
                          type: {
                            coding: [
                              {
                                system: 'http://hl7.org/fhir/us/davinci-drug-formulary/CodeSystem/usdf-BenefitCostTypeCS-TEMPORARY-TRIAL-USE',
                                code: 'copay',
                                display: 'Copay'
                              }
                            ]
                          },
                          qualifiers: [
                            {
                              coding: [
                                {
                                  system: 'http://hl7.org/fhir/us/davinci-drug-formulary/CodeSystem/usdf-CostShareOptionCS-TEMPORARY-TRIAL-USE',
                                  code: 'after-deductible',
                                  display: 'After Deductible'
                                }
                              ]
                            }
                          ],
                          value: {
                            value: 20,
                            unit: '$',
                            system: 'urn:iso:std:iso:4217',
                            code: 'USD'
                          }
                        },
                        {
                          type: {
                            coding: [
                              {
                                system: 'http://hl7.org/fhir/us/davinci-drug-formulary/CodeSystem/usdf-BenefitCostTypeCS-TEMPORARY-TRIAL-USE',
                                code: 'coinsurance',
                                display: 'Coinsurance'
                              }
                            ]
                          },
                          qualifiers: [
                            {
                              coding: [
                                {
                                  system: 'http://hl7.org/fhir/us/davinci-drug-formulary/CodeSystem/usdf-CostShareOptionCS-TEMPORARY-TRIAL-USE',
                                  code: 'after-deductible',
                                  display: 'After Deductible'
                                }
                              ]
                            }
                          ],
                          value: {
                            value: 20,
                            system: 'http://unitsofmeasure.org',
                            code: '%'
                          }
                        }
                      ]
                    }
                  ]
                }
              ]
            }
          ]
        )
      end

      it 'passes if server suports all MS slices (payer plan)' do
        allow_any_instance_of(payer_insurance_plan_must_support_test)
          .to receive(:scratch_resources).and_return(
            {
              all: [payer_insurance_plan]
            }
          )

        result = run(payer_insurance_plan_must_support_test)
        expect(result.result).to eq('pass')
      end

      it 'passes if server does not support one MS slice (payer plan)' do
        payer_insurance_plan.plan.first.type.coding.first.code = nil
        allow_any_instance_of(payer_insurance_plan_must_support_test)
          .to receive(:scratch_resources).and_return(
            {
              all: [payer_insurance_plan]
            }
          )

        result = run(payer_insurance_plan_must_support_test)

        expect(result.result).to eq('skip')
        expect(result.result_message).to include('InsurancePlan.plan:drug-plan')
      end

      it 'passes if sub-elements of missing slice are displayed' do
        payer_insurance_plan.plan.first.type.coding.first.code = nil
        allow_any_instance_of(payer_insurance_plan_must_support_test)
          .to receive(:scratch_resources).and_return(
            {
              all: [payer_insurance_plan]
            }
          )

        result = run(payer_insurance_plan_must_support_test)
        expect(result.result).to eq('skip')
        expect(result.result_message).to include('plan:drug-plan.specificCost')
      end
    end

    context 'when slicing with value / list of extensions' do
      let(:basic_must_support_test) do
        Inferno::Repositories::Tests.new.find('usdf_v201_basic_must_support_test')
      end
      let(:formulary_item) do
        FHIR::Basic.new(
          resourceType: 'Basic',
          id: 'FormularyItem-D1002-1000091',
          meta: {
            lastUpdated: '2021-08-22T18:36:03.000+00:00',
            profile: [
              'http://hl7.org/fhir/us/davinci-drug-formulary/StructureDefinition/usdf-FormularyItem'
            ]
          },
          extension: [
            {
              url: 'http://hl7.org/fhir/us/davinci-drug-formulary/StructureDefinition/usdf-FormularyReference-extension',
              valueReference: {
                reference: 'InsurancePlan/FormularyD1002'
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
                    system: 'http://hl7.org/fhir/us/davinci-drug-formulary/CodeSystem/usdf-PharmacyBenefitTypeCS-TEMPORARY-TRIAL-USE',
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
                    system: 'http://hl7.org/fhir/us/davinci-drug-formulary/CodeSystem/usdf-DrugTierCS-TEMPORARY-TRIAL-USE',
                    code: 'generic',
                    display: 'Generic'
                  }
                ]
              }
            },
            {
              url: 'http://hl7.org/fhir/us/davinci-drug-formulary/StructureDefinition/usdf-AvailabilityPeriod-extension',
              valuePeriod: {
                start: '2021-01-01',
                end: '2021-12-31'
              }
            },
            {
              url: 'http://hl7.org/fhir/us/davinci-drug-formulary/StructureDefinition/usdf-PharmacyBenefitType-extension',
              valueCodeableConcept: {
                coding: [
                  {
                    system: 'http://hl7.org/fhir/us/davinci-drug-formulary/CodeSystem/usdf-PharmacyBenefitTypeCS-TEMPORARY-TRIAL-USE',
                    code: '1-month-in-mail',
                    display: '1 month in network mail order'
                  }
                ]
              }
            },
            {
              url: 'http://hl7.org/fhir/us/davinci-drug-formulary/StructureDefinition/usdf-PharmacyBenefitType-extension',
              valueCodeableConcept: {
                coding: [
                  {
                    system: 'http://hl7.org/fhir/us/davinci-drug-formulary/CodeSystem/usdf-PharmacyBenefitTypeCS-TEMPORARY-TRIAL-USE',
                    code: '3-month-in-retail',
                    display: '3 month in network retail'
                  }
                ]
              }
            },
            {
              url: 'http://hl7.org/fhir/us/davinci-drug-formulary/StructureDefinition/usdf-PharmacyBenefitType-extension',
              valueCodeableConcept: {
                coding: [
                  {
                    system: 'http://hl7.org/fhir/us/davinci-drug-formulary/CodeSystem/usdf-PharmacyBenefitTypeCS-TEMPORARY-TRIAL-USE',
                    code: '3-month-in-mail',
                    display: '3 month in network mail order'
                  }
                ]
              }
            },
            {
              url: 'http://hl7.org/fhir/us/davinci-drug-formulary/StructureDefinition/usdf-PriorAuthorization-extension',
              valueBoolean: false
            },
            {
              url: 'http://hl7.org/fhir/us/davinci-drug-formulary/StructureDefinition/usdf-StepTherapyLimit-extension',
              valueBoolean: true
            },
            {
              url: 'http://hl7.org/fhir/us/davinci-drug-formulary/StructureDefinition/usdf-StepTherapyLimitNewStartsOnly-extension',
              valueBoolean: true
            },
            {
              url: 'http://hl7.org/fhir/us/davinci-drug-formulary/StructureDefinition/usdf-QuantityLimit-extension',
              valueBoolean: true
            }
          ],
          code: {
            coding: [
              {
                system: 'http://hl7.org/fhir/us/davinci-drug-formulary/CodeSystem/usdf-InsuranceItemTypeCS',
                code: 'formulary-item',
                display: 'Formulary Item'
              }
            ]
          },
          subject: {
            reference: 'MedicationKnowledge/FormularyDrug-1000091'
          }
        )
      end

      it 'passes if server suports all MS slices (formulary item)' do
        allow_any_instance_of(basic_must_support_test)
          .to receive(:scratch_resources).and_return(
            {
              all: [formulary_item]
            }
          )

        result = run(basic_must_support_test)
        expect(result.result).to eq('pass')
      end

      it 'fails if server does not support one MS extensions (formulary item)' do
        formulary_item.extension.shift
        allow_any_instance_of(basic_must_support_test)
          .to receive(:scratch_resources).and_return(
            {
              all: [formulary_item]
            }
          )

        result = run(basic_must_support_test)
        expect(result.result).to eq('skip')
        expect(result.result_message).to include('Basic.extension:usdf-FormularyReference-extension')
      end
    end
  end
end
