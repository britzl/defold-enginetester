Feature: liveupdate

	Background:
		Given the tests:/proxies#liveupdate collection is loaded

	@liveupdate
	Scenario: Check missing resources
		Then collection proxy liveupdate:/alpha#collectionproxy-alpha should have 5 missing resources
		And collection proxy liveupdate:/beta#collectionproxy-beta should have 4 missing resources

	@liveupdate
	Scenario: Download missing resources
		When I download missing resources for collection proxy liveupdate:/beta#collectionproxy-beta from https://britzl.github.io/defold-enginetester/
		Then collection proxy liveupdate:/beta#collectionproxy-beta should have 0 missing resources

	@liveupdate
	Scenario: Download missing resources and load and unload collection twice
		Given I download missing resources for collection proxy liveupdate:/alpha#collectionproxy-alpha from https://britzl.github.io/defold-enginetester/
		When the liveupdate:/alpha#collectionproxy-alpha collection is loaded
		And the liveupdate:/alpha#collectionproxy-alpha collection is unloaded
		And the liveupdate:/alpha#collectionproxy-alpha collection is loaded
		And the liveupdate:/alpha#collectionproxy-alpha collection is unloaded
		Then collection proxy liveupdate:/alpha#collectionproxy-alpha should have 0 missing resources

	@liveupdate
	Scenario: Check missing resources in sub collection
		Given I download missing resources for collection proxy liveupdate:/beta#collectionproxy-beta from https://britzl.github.io/defold-enginetester/
		And the liveupdate:/beta#collectionproxy-beta collection is loaded
		Then collection proxy beta01:/go#collectionproxy-beta2 should have 5 missing resources

	@liveupdate
	Scenario: Download missing resources in sub collection
		Given I download missing resources for collection proxy liveupdate:/beta#collectionproxy-beta from https://britzl.github.io/defold-enginetester/
		And the liveupdate:/beta#collectionproxy-beta collection is loaded
		When I download missing resources for collection proxy beta01:/go#collectionproxy-beta2 from https://britzl.github.io/defold-enginetester/
		Then collection proxy beta01:/go#collectionproxy-beta2 should have 0 missing resources
