# 2.0.0-b1
The dcli and settings_yaml actually need to be dependencies. In conduit common_test is a dev dependency so these will still unlitmatly be dev dependencies.
Added linting.
Added a license.
Fixed the how we get the correct db setting and clearly defined the precendence. environment, .settings.yaml then default
Initial release of common_test. Primary component is the PostgresTestConfig class which provides defautls/configuration for the postgres connections required by the unit tests and the test harness.



