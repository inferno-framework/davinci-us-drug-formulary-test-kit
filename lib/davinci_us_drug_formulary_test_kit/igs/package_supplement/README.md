# IG Supplement Files

The files in this directory will supplement files in the <ig package>.tgz IG.
Add files to this directory if you need to add information that may be missing from the IG (e.g., adding in base definitions that are not defined in the IG).
These files will not supersede the files in the IG.

## r4_search-parameters.json

The US Drug Formulary IG (v2.0.1) only includes definitions for parameters it changes from the base definitions. However, the code generator assumes all definitions are present in the IG. By adding in the `r4_search-parameters.json` file, we provide any missing definitions. However, we want to make sure we don't supersede any definitions in the IG, because those take precedence.