# IG Supersede Files

The files in this directory will supersede files in the <ig package>.tgz IG.
Add files to this directory if you need to correct errors in the IG.

## CapabilityStatement-usdf-server.json
The original capability statement includes the following:

``` json
"searchInclude": [
    "formulary-coverage"
],
...

"searchInclude": [
    "subject",
    "formulary"
],
```

The [FHIR documentation](https://hl7.org/fhir/r4/search.html#table) states that the allowable content for `_include` is `SourceType:searchParam(:targetType)`.



This capability statement supersedes the original with the following:

``` json
"searchInclude": [
    "InsurancePlan:formulary-coverage"
],
...

"searchInclude": [
    "Basic:subject",
    "Basic:formulary"
],
```

With this modification, the test generator can properly create tests for `_include`.

### Notes:

#### 06/19/2024
This issue should be raised with the Da Vinci IG developers. Once this issue is resolved in the IG, this file should be removed.
