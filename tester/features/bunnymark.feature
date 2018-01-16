Feature: Bunnymark test

	Background:
		Given the tests:/proxies#bunnymark collection is loaded

	@bunnymark
	@sprite
	Scenario: Spawn and bounce using go.animate()
		Given frame time metrics is collected every frame
		And metrics is sent to the influx instance at http://metrics.defold.com:8086/write?db=engine_metrics with prefix bunnymark_5000
		When I run a bunnymark test with 5000 instances using factory bunnymark:/go#bunnyfactory for 1000 frames
		Then aggregated frame time should be less than 17 seconds

	@bunnymark
	@sprite
	Scenario: Spawn and bounce using go.animate()
		Given frame time metrics is collected every frame
		And metrics is sent to the influx instance at http://metrics.defold.com:8086/write?db=engine_metrics with prefix bunnymark_500
		When I run a bunnymark test with 500 instances using factory bunnymark:/go#bunnyfactory for 1000 frames
		Then aggregated frame time should be less than 17 seconds
