Feature: go

	Background:
		Given the tests:/proxies#factory collection is loaded

	Scenario: Spawn game object with callers position
		Given game object factory:/go is positioned at 400,500,0
		And game object factory:/cucumber is positioned at 100,200,0
		When I use factory factory:/go#factory1 to spawn 1 game object
		Then game object factory:/instance0 should be positioned at 100,200,0

	Scenario: Spawn game object with callers rotation
		Given game object factory:/go is rotated 20,30,40 degrees
		And game object factory:/cucumber is rotated 10,20,30 degrees
		When I use factory factory:/go#factory1 to spawn 1 game object
		Then game object factory:/instance0 should be rotated 10,20,30 degrees

	Scenario: Spawn game object with callers scale
		Given game object factory:/go is scaled to 2,3,4
		And game object factory:/cucumber is scaled to 3,4,5
		When I use factory factory:/go#factory1 to spawn 1 game object
		Then game object factory:/instance0 should be scaled to 3,4,5

	Scenario: Spawn game object at specific position
		Given game object factory:/go is positioned at 400,500,0
		And game object factory:/cucumber is positioned at 100,200,0
		When I use factory factory:/go#factory1 to spawn 1 game object at position 200,300,10
		Then game object factory:/instance0 should be positioned at 200,300,10

	Scenario: Spawn game object with specific rotation
		Given game object factory:/go is rotated 50,60,70 degrees
		And game object factory:/cucumber is rotated 20,30,40 degrees
		When I use factory factory:/go#factory1 to spawn 1 game object with rotation 10,20,30 degrees
		Then game object factory:/instance0 should be rotated 10,20,30 degrees

	Scenario: Spawn game object with specific scale
		Given game object factory:/go is scaled to 1,2,3
		And game object factory:/cucumber is scaled to 2,3,4
		When I use factory factory:/go#factory1 to spawn 1 game object with scale 3,4,5
		Then game object factory:/instance0 should be scaled to 3,4,5

	Scenario: Spawn game object with properties set
		When I use factory factory:/go#factory1 to spawn 1 game object with the prop_hash property set to hash testing
		And I use factory factory:/go#factory1 to spawn 1 game object with the prop_number property set to number 666
		And I use factory factory:/go#factory1 to spawn 1 game object with the prop_url property set to url factory:/cucumber#script
		And I use factory factory:/go#factory1 to spawn 1 game object with the prop_v3 property set to vector3 1,2,3
		And I use factory factory:/go#factory1 to spawn 1 game object with the prop_v4 property set to vector4 1,2,3,4
		Then game object factory:/instance0#script should have the prop_hash property set to hash testing
		And game object factory:/instance1#script should have the prop_number property set to number 666
		And game object factory:/instance2#script should have the prop_url property set to url factory:/cucumber#script
		And game object factory:/instance3#script should have the prop_v3 property set to vector3 1,2,3
		And game object factory:/instance4#script should have the prop_v4 property set to vector4 1,2,3,4
