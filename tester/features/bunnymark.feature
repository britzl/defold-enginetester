Feature: Bunnymark test

	Background:
		Given the tests:/proxies#bunnymark collection is loaded

	@bunnymark
	@sprite
	@grafana
	Scenario: Spawn and bounce using go.animate()
		Given frame time metrics are collected every frame
		And metrics are sent to the influx instance at http://metrics.defold.com:8086/write?db=engine_metrics with prefix bunnymark_5000
		When I run a bunnymark test with 5000 instances using factory bunnymark:/go#bunnyfactory for 100 frames
		Then average frame time should be less than 0.017 seconds

	@bunnymark
	@sprite
	@grafana
	Scenario: Spawn and bounce using go.animate()
		Given frame time metrics are collected every frame
		And metrics are sent to the influx instance at http://metrics.defold.com:8086/write?db=engine_metrics with prefix bunnymark_500
		When I run a bunnymark test with 500 instances using factory bunnymark:/go#bunnyfactory for 100 frames
		Then average frame time should be less than 0.017 seconds
