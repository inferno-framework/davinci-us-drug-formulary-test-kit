module DaVinciUSDrugFormularyTestKit
  class Generator
    module SpecialCases
      class << self

        def search_param(include_param)
          # include_params should be formatted as `SourceType:searchParam(:targetType)`
          # (https://hl7.org/fhir/R4/search.html#table)
          # We need to use the `searchParam` as a key for `search_definitions`.
          # This extracts the `searchParam`.
          params = include_param.split(':')
          params.length > 1 ? params[1] : params[0]
        end

      end
    end
  end
end
