Feature: Engine stress test

	Background:
		Given the tests:/proxies#stress collection is loaded

	@stress
	@sprite
	Scenario: Spawn and delete many game objects with sprites
		Given fps metrics is collected with a 1 second interval
		And cpu metrics is collected with a 1 second interval
		And mem metrics is collected with a 1 second interval
		When I run a stress test with 500 instances using factory stress:/go#spritefactory for 25 seconds
		Then fps metrics should not deteriorate over time
		And cpu metrics should not deteriorate over time
		And mem metrics should not deteriorate over time

	@stress
	@spine
	Scenario: Spawn and delete many game objects with spine models
		Given fps metrics is collected with a 1 second interval
		And cpu metrics is collected with a 1 second interval
		And mem metrics is collected with a 1 second interval
		When I run a stress test with 50 instances using factory stress:/go#spinefactory for 25 seconds
		Then fps metrics should not deteriorate over time
		And cpu metrics should not deteriorate over time
		And mem metrics should not deteriorate over time

	@stress
	@particlefx
	Scenario: Spawn and delete many game objects with particle fx
		Given fps metrics is collected with a 1 second interval
		And cpu metrics is collected with a 1 second interval
		And mem metrics is collected with a 1 second interval
		When I run a stress test with 50 instances using factory stress:/go#particlefxfactory for 50 seconds
		Then fps metrics should not deteriorate over time
		And cpu metrics should not deteriorate over time
		And mem metrics should not deteriorate over time


	@stress
	@gui
	@font
	Scenario: Spawn and delete many game objects with gui components
		Given fps metrics is collected with a 1 second interval
		And cpu metrics is collected with a 1 second interval
		And mem metrics is collected with a 1 second interval
		When I run a stress test with 50 instances using factory stress:/go#guifactory for 25 seconds
		Then fps metrics should not deteriorate over time
		And cpu metrics should not deteriorate over time
		And mem metrics should not deteriorate over time


	@stress
	@label
	@font
	Scenario: Spawn and delete many game objects with label components
		Given fps metrics is collected with a 1 second interval
		And cpu metrics is collected with a 1 second interval
		And mem metrics is collected with a 1 second interval
		When I run a stress test with 50 instances using factory stress:/go#labelfactory for 25 seconds
		Then fps metrics should not deteriorate over time
		And cpu metrics should not deteriorate over time
		And mem metrics should not deteriorate over time
