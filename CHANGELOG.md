# 0.12.0
## Breaking Change
This release updates the Da Vinci US Drug Formulary Test Kit to use AuthInfo
rather than OAuthCredentials for storing auth information. As a result of this
change, any test kits which rely on this test kit will need to be updated to use
AuthInfo rather than OAuthCredentials inputs.

* FI-3746: Use AuthInfo by @Jammjammjamm in https://github.com/inferno-framework/davinci-us-drug-formulary-test-kit/pull/19

# 0.11.0
## Breaking Changes:
- **Ruby Version Update:** Upgraded Ruby to `3.3.6`.
- **Inferno Core Update:** Bumped to version `0.6`.
- **Gemspec Updates:**
  - Switched to `git` for specifying files.
  - Added `presets` to the gem package.
  - Updated any test kit dependencies
- **Test Kit Metadata:** Implemented Test Kit metadata for Inferno Platform.
- **Environment Updates:** Updated Ruby version in the Dockerfile and GitHub
  Actions workflow.

* FI-3648 Add metadata and make platform deployable by @Shaumik-Ashraf in https://github.com/inferno-framework/davinci-us-drug-formulary-test-kit/pull/17

# 0.10.4
* re-release of gem, dependency updates

# 0.10.3
* Fi 2718 _include search parameter fix. by @edeyoung in https://github.com/inferno-framework/davinci-us-drug-formulary-test-kit/pull/12
* Dependency Updates 2024-07-03 by @Jammjammjamm in https://github.com/inferno-framework/davinci-us-drug-formulary-test-kit/pull/13

# 0.10.2
* Fi 2718 _include search parameter fix. by @edeyoung in https://github.com/inferno-framework/davinci-us-drug-formulary-test-kit/pull/12
* Dependency Updates 2024-07-03 by @Jammjammjamm in https://github.com/inferno-framework/davinci-us-drug-formulary-test-kit/pull/13

# 0.10.1
* Fix preset suite id by @Jammjammjamm in https://github.com/inferno-framework/davinci-us-drug-formulary-test-kit/pull/10

# 0.10.0
* Dependency Updates 2024-03-19 by @Jammjammjamm in https://github.com/inferno-framework/davinci-us-drug-formulary-test-kit/pull/3
* Dependency Updates 2024-04-05 by @Jammjammjamm in https://github.com/inferno-framework/davinci-us-drug-formulary-test-kit/pull/4
* FI-2429: Migrate to HL7 validator wrapper by @dehall in https://github.com/inferno-framework/davinci-us-drug-formulary-test-kit/pull/6
* Dependency Updates 2024-06-05 by @Jammjammjamm in https://github.com/inferno-framework/davinci-us-drug-formulary-test-kit/pull/8
* Bump core version in gemspec by @dehall in https://github.com/inferno-framework/davinci-us-drug-formulary-test-kit/pull/7

# 0.9.1
* Da Vinci -> DaVinci to match IG by @karlnaden in
  https://github.com/inferno-framework/davinci-us-drug-formulary-test-kit/pull/1

# 0.9.0

* Initial public release.
