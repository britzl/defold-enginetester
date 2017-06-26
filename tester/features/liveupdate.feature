Feature: liveupdate

	Background:
		Given the tests:/proxies#liveupdate collection is loaded

	@liveupdate
	Scenario: Check missing resources
		Then collection proxy liveupdate:/beta#collectionproxy-beta should have 10 missing resources

	@liveupdate
	Scenario: Download missing resources
		When I download and store missing resources for collection proxy liveupdate:/beta#collectionproxy-beta from https://s3-eu-west-1.amazonaws.com/defold-resources-qa/defoldtest/
		Then collection proxy liveupdate:/beta#collectionproxy-beta should have 0 missing resources

	@liveupdate
	Scenario: Download missing resources in sub collection
		When I download and store missing resources for collection proxy liveupdate:/beta#collectionproxy-beta from https://s3-eu-west-1.amazonaws.com/defold-resources-qa/defoldtest/
		When I download and store missing resources for collection proxy beta01:/go#collectionproxy-beta2 from https://s3-eu-west-1.amazonaws.com/defold-resources-qa/defoldtest/
		Then collection proxy beta01:/go#collectionproxy-beta2 should have 0 missing resources
