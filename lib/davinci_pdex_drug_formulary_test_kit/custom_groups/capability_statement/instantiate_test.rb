module DaVinciPDEXDrugFormularyTestKit
  class InstantiateTest < Inferno::Test
    id :usdf_instantiate
    title 'Server instantiates US Drug Formulary Server'
    description %(
        This test inspects the CapabilityStatement returned by the server to
        verify that the server instantiates http://hl7.org/fhir/us/davinci-drug-formulary/CapabilityStatement/usdf-server
      )
    uses_request :capability_statement

    run do
      assert_resource_type(:capability_statement)
      capability_statement = resource

      assert capability_statement.instantiates.include?('http://hl7.org/fhir/us/davinci-drug-formulary/CapabilityStatement/usdf-server'),
             "Server CapabilityStatement.instantiates does not include 'http://hl7.org/fhir/us/davinci-drug-formulary/CapabilityStatement/usdf-server'"
    end
  end
end
