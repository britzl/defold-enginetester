Feature: Bunnymark test

	Background:
		Given the tests:/proxies#bunnymark collection is loaded

	@bunnymark
	@sprite
	Scenario: Spawn and bounce using go.animate()
		Given frame time metrics is collected with a 0 frame interval
		When I run a bunnymark test with 5000 instances using factory bunnymark:/go#bunnyfactory for 1000 frames
		Then aggregated frame time should be less than 17 seconds
