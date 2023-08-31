module DaVinciPDEXDrugFormularyTestKit
  class ProfileSupportTest < Inferno::Test
    id :usdf_profile_support
    title 'Capability Statement lists support for required US Drug Formulary Profiles'
    description %(
      The US Drug Formulary Implementation Guide states:

      ```
      The US Drug Formulary Server SHALL:
      1. Support all profiles defined in the USDF Implementation Guide.

      ```
    )
    uses_request :capability_statement

    run do
      assert_resource_type(:capability_statement)
      capability_statement = resource

      supported_resources =
        capability_statement.rest
          &.each_with_object([]) do |rest, resources|
            rest.resource.each { |resource| resources << resource.type }
          end.uniq
      usdf_resources = config.options[:required_resources]
      unsupported_resources = usdf_resources - supported_resources

      all_resources_supported =  !unsupported_resources.any?

      unsupported_resource_list =
          unsupported_resources
          .map { |resource| "`#{resource}`" }
          .join(', ')

      assert all_resources_supported, "Not all US Drug Formulary resources are supported. Missing support for: #{unsupported_resource_list}"
    end
  end
end
