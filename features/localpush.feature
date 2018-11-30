Feature: Local Push test

	@push
	Scenario: Schedule and wait for local notification
		Given I have scheduled a local push notification in 3 seconds
		When I wait 5 seconds
		Then I should have received a local push notification
