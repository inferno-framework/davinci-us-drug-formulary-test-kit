require_relative 'version'

module DaVinciUSDrugFormularyTestKit 
  class Metadata < Inferno::TestKit
    id :davinci_us_drug_formulary_test_kit
    title 'Da Vinci US Drug Formulary Test Kit'
    suite_ids ['davinci_us_drug_formulary_v201']
    tags ['Da Vinci']
    last_updated ::DaVinciUSDrugFormularyTestKit::LAST_UPDATED
    version ::DaVinciUSDrugFormularyTestKit::VERSION
    maturity 'Low'
    authors ['Stephen MacVicar', 'Tom Strassner', 'Robert Passas']
    repo 'https://github.com/inferno-framework/davinci-us-drug-formulary-test-kit'
    description <<~DESCRIPTION
      The DaVinci US Drug Formulary Test Kit validates the conformance of a server
      implementation to the
      [DaVinci Payer Data Exchange (PDex) US Drug Formulary Implementation Guide v2.0.1](http://hl7.org/fhir/us/davinci-drug-formulary/STU2.0.1).

      <!-- break -->
  
      These tests check the following behaviors as defined in the IG:
  
      - FHIR Interactions
        + Capabilities
        + Read
        + Search
          * Individual search parameters
          * _include searches
      - FHIR Data
        + Validation against IG profiles
        + Presence of all Must Support fields
          * Resolution of Must Support references
  
      The DaVinci US Drug Formulary Test Kit is built using the
      [Inferno Framework](https://inferno-framework.github.io/).
      The Inferno Framework is designed for reuse and aims to make it easier to
      build test kits for any FHIR-based data exchange.
      
      ### Known Limitations
  
      The following areas of the IG are not fully tested in this draft version
      of the test kit:
  
      - Must Support checks are not performed for all elements of Formulary Drug
        resources due to the use of an intensional value set for slicing
        `MedicationKnowledge.code.coding` elements.
      - The following search features are not tested:
        + Combination searches
        + Multiple Or
        + Multiple And
        + Comparators
  
      ## Reporting Issues
  
      Please report any issues with this set of tests in the
      [GitHub Issues](https://github.com/inferno-framework/davinci-us-drug-formulary-test-kit/issues)
      section of this repository.
    DESCRIPTION
  end
end
