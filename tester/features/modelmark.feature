Feature: Model test

	Background:
		Given the tests:/proxies#model collection is loaded

	@model
	Scenario: Spawn static
		Given frame time metrics is collected every frame
		When I run a modelmark test with 500 instances with scale 208.0 using factory model:/go#staticfactory for 100 frames
		Then average frame time should be less than 0.017 seconds

	@model
	Scenario: Spawn static
		Given frame time metrics is collected every frame
		When I run a modelmark test with 500 instances with scale 1.0 using factory model:/go#skinnedfactory for 100 frames
		Then average frame time should be less than 0.017 seconds
