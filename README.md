# Da Vinci US Drug Formulary Test Kit

This is an [Inferno](https://inferno-framework.github.io/inferno-core/) test kit
for the [Da Vinci Payer Data Exchange (PDex) US Drug Formulary Implementation Guide v2.0.1](http://hl7.org/fhir/us/davinci-drug-formulary/STU2.0.1).

## Instructions

Refer to the [Inferno Framework
Documentation](https://inferno-framework.github.io/inferno-core/getting-started.html#running-an-existing-test-kit)
for instructions on how to run this test kit.

## Status

These tests check the following behaviors as defined in the IG:
- FHIR Interactions
  - Capabilities
  - Read
  - Search
    - Individual search parameters
    - _include searches
- FHIR Data
  - Validation against IG profiles
  - Presence of all Must Support fields
    - Resolution of Must Support references

### Known Issues
The following areas of the IG are not fully tested:
- Must Support checks are not performed for all elements of Formulary Drug
  resources due to the use of an intensional value set for slicing
  `MedicationKnowledge.code.coding` elements.
- The following search features are not tested
  - Combination searches
  - Multiple Or
  - Multiple And
  - Comparators

## Reporting Issues

Please report any problems with these tests in Github Issues. The team may also
be reached in the [#inferno Zulip
stream](https://chat.fhir.org/#narrow/stream/179309-inferno).

## License

Licensed under the Apache License, Version 2.0 (the "License"); you may not use
this file except in compliance with the License. You may obtain a copy of the
License at
```
http://www.apache.org/licenses/LICENSE-2.0
```
Unless required by applicable law or agreed to in writing, software distributed
under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
CONDITIONS OF ANY KIND, either express or implied. See the License for the
specific language governing permissions and limitations under the License.

## Trademark Notice

HL7, FHIR and the FHIR [FLAME DESIGN] are the registered trademarks of Health
Level Seven International and their use does not constitute endorsement by HL7.
