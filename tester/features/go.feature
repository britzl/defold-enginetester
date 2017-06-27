Feature: go

	Background:
		Given the tests:/proxies#go collection is loaded

	@animation
	@position
	Scenario: Animate position
		Given game object go:/go1 is positioned at 400,500,0
		When I animate game object go:/go1 position to 100,200,0 in 0.5 seconds
		And I wait 1 second
		Then game object go:/go1 should be positioned at 100,200,0

	@animation
	@position
	Scenario: Animate position backward
		Given game object go:/go1 is positioned at 400,500,0
		When I animate game object go:/go1 position to 100,200,0 in 4 seconds ONCE_BACKWARD
		Then game object go:/go1 should be positioned within 20 pixels of 100,200,0
		And I wait 4 second
		Then game object go:/go1 should be positioned at 400,500,0

	@animation
	@position
	Scenario: Animate position pingpong
		Given game object go:/go1 is positioned at 400,500,0
		When I animate game object go:/go1 position to 100,200,0 in 4 seconds ONCE_PINGPONG
		And I wait 2 seconds
		Then game object go:/go1 should be positioned within 20 pixels of 100,200,0
		And I wait 2 seconds
		And game object go:/go1 should be positioned at 400,500,0

	@animation
	@position
	Scenario: Animate position.x
		Given game object go:/go1 is positioned at 400,500,0
		When I animate game object go:/go1 position.x to 300 in 0.5 seconds
		And I wait 1 second
		Then game object go:/go1 should be positioned at 300,500,0

	@animation
	@position
	Scenario: Animate position.y
		Given game object go:/go1 is positioned at 400,500,0
		When I animate game object go:/go1 position.y to 300 in 0.5 seconds
		And I wait 1 second
		Then game object go:/go1 should be positioned at 400,300,0

	@animation
	@position
	Scenario: Animate position.z
		Given game object go:/go1 is positioned at 400,500,0
		When I animate game object go:/go1 position.z to 300 in 0.5 seconds
		And I wait 1 second
		Then game object go:/go1 should be positioned at 400,500,300

	@animation
	@rotation
	Scenario: Animate rotation.x
		Given game object go:/go1 is rotated 0,0,0 degrees
		When I animate game object go:/go1 rotation 45,0,0 degrees in 0.5 seconds
		And I wait 1 second
		Then game object go:/go1 should be rotated 45,0,0 degrees

	@animation
	@rotation
	Scenario: Animate rotation.y
		Given game object go:/go1 is rotated 0,0,0 degrees
		When I animate game object go:/go1 rotation 0,45,0 degrees in 0.5 seconds
		And I wait 1 second
		Then game object go:/go1 should be rotated 0,45,0 degrees

	@animation
	@rotation
	Scenario: Animate rotation.z
		Given game object go:/go1 is rotated 0,0,0 degrees
		When I animate game object go:/go1 rotation 0,0,45 degrees in 0.5 seconds
		And I wait 1 second
		Then game object go:/go1 should be rotated 0,0,45 degrees

	@animation
	@property
	Scenario: Animate property
		Given I set the prop_number property of game object go:/go1#script to number 100
		When I animate game object go:/go1#script prop_number to 666 in 0.5 seconds
		And I wait 1 second
		Then game object go:/go1#script should have the prop_number property set to number 666

	@animation
	@rotation
	Scenario: Cancel position animation
		Given game object go:/go1 is positioned at 400,500,0
		When I animate game object go:/go1 position to 100,200,0 in 0.5 seconds
		And I cancel the position animation on game object go:/go1
		And I wait 1 second
		Then game object go:/go1 should not be positioned at 100,200,0

	@animation
	@rotation
	Scenario: Cancel rotation animation
		Given game object go:/go1 is rotated 0,0,0 degrees
		When I animate game object go:/go1 rotation 0,0,45 degrees in 0.5 seconds
		And I cancel the rotation animation on game object go:/go1
		And I wait 1 second
		Then game object go:/go1 should not be rotated 0,0,45 degrees

	@animation
	@position
	@rotation
	Scenario: Animate position and rotation and cancel position animation should still finish rotation
		Given game object go:/go1 is positioned at 400,500,0
		And game object go:/go1 is rotated 0,0,0 degrees
		When I animate game object go:/go1 rotation 0,0,45 degrees in 0.5 seconds
		And I animate game object go:/go1 position to 100,200,0 in 0.5 seconds
		And I cancel the position animation on game object go:/go1
		And I wait 1 second
		Then game object go:/go1 should not be positioned at 100,200,0
		And game object go:/go1 should be rotated 0,0,45 degrees

	Scenario: Delete game object
		Given error checking is enabled
		When I delete game object go:/go1
		And I animate game object go:/go1 position to 100,200,0 in 0.5 seconds
		Then an error should have happened

	@properties
	Scenario: Getting and setting properties
		When I set the prop_hash property of game object go:/go1#script to hash testing
		And I set the prop_number property of game object go:/go1#script to number 666
		And I set the prop_url property of game object go:/go1#script to url tester:/tester#script
		And I set the prop_v3 property of game object go:/go1#script to vector3 20,30,40
		And I set the prop_v4 property of game object go:/go1#script to vector4 20,30,40,50
		Then game object go:/go1#script should have the prop_hash property set to hash testing
		And game object go:/go1#script should have the prop_number property set to number 666
		And game object go:/go1#script should have the prop_url property set to url tester:/tester#script
		And game object go:/go1#script should have the prop_v3 property set to vector3 20,30,40
		And game object go:/go1#script should have the prop_v4 property set to vector4 20,30,40,50

	@position
	Scenario: Setting and getting position
		When I set game object go:/go1 position to 400,500,0
		Then game object go:/go1 should be positioned at 400,500,0

	@position
	Scenario: World position
		When I set game object go:/go1 position to 400,500,0
		And I set game object go:/child1 position to 100,200,0
		Then game object go:/go1 should be world positioned at 400,500,0
		And game object go:/child1 should be world positioned at 500,700,0

	@foo
	@rotation
	Scenario: World rotation
		When I set game object go:/go1 rotation to 10,20,0 degrees
		And I set game object go:/child1 rotation to 20,30,40 degrees
		Then game object go:/go1 should be world rotated 10,20,0 degrees
		And game object go:/child1 should be world rotated 30,50,40 degrees

	@rotation
	Scenario: Setting and getting rotation
		When I set game object go:/go1 rotation to 10,20,30 degrees
		Then game object go:/go1 should be rotated 10,20,30 degrees

	@scale
	Scenario: Setting and getting non-uniform scale
		When I set game object go:/go1 scale to 2,3,4
		Then game object go:/go1 should be scaled to 2,3,4

	@scale
	Scenario: Setting non-uniform scale and getting uniform scale
		When I set game object go:/go1 scale to 2,3,4
		Then game object go:/go1 should be scaled to 2

	@scale
	Scenario: Setting and getting uniform scale
		When I set game object go:/go1 scale to 3
		Then game object go:/go1 should be scaled to 3

	@scale
	Scenario: Setting uniform scale and getting non-uniform scale
		When I set game object go:/go1 scale to 3
		Then game object go:/go1 should be scaled to 3,3,3

	@scale
	Scenario: Setting and getting uniform world scale
		When I set game object go:/go1 scale to 3
		And I set game object go:/child1 scale to 2
		Then game object go:/go1 should be world scaled to 3
		And game object go:/child1 should be world scaled to 6

	@scale
	Scenario: Setting and getting non-uniform world scale
		When I set game object go:/go1 scale to 3,4,5
		And I set game object go:/child1 scale to 2,3,4
		Then game object go:/go1 should be world scaled to 3,4,5
		And game object go:/child1 should be world scaled to 6,12,20

	@parent
	Scenario: Setting parent of game object
		Given game object go:/go1 is positioned at 400,500,10
		And game object go:/go2 is positioned at 10,20,1
		When I set the game object go1 as parent of game object go:/go2
		Then game object go:/go2 should be positioned at 10,20,1
		And game object go:/go2 should be world positioned at 410,520,11

	@parent
	Scenario: Setting parent of game object while keeping world transform
		Given game object go:/go1 is positioned at 400,500,10
		And game object go:/go2 is positioned at 10,20,1
		When I set the game object go1 as parent of game object go:/go2 and keep the world transform
		Then game object go:/go2 should be positioned at -390,-480,-9
		And game object go:/go2 should be world positioned at 10,20,1
