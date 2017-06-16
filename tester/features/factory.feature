Feature: go

	Background:
		Given the tests:/proxies#factory collection is loaded

	Scenario: Spawn game object at callers position
		Given game object factory:/go is positioned at 400,500,0
		And game object factory:/cucumber is positioned at 100,200,0
		When I use factory factory:/go#factory1 to spawn 1 game object
		Then game object factory:/instance0 should be positioned at 100,200,0
