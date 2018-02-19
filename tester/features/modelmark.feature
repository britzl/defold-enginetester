Feature: Model test

	Background:
		Given the tests:/proxies#model collection is loaded

	@model
	@grafana
	Scenario: Spawn and animate static models
		Given frame time metrics is collected every frame
		And metrics is sent to the influx instance at http://metrics.defold.com:8086/write?db=engine_metrics with prefix staticmodel_500
		When I run a modelmark test with 500 instances with scale 208.0 using factory model:/go#staticfactory for 100 frames
		Then average frame time should be less than 0.017 seconds

	@model
	@grafana
	Scenario: Spawn and animate skinned models
		Given frame time metrics is collected every frame
		And metrics is sent to the influx instance at http://metrics.defold.com:8086/write?db=engine_metrics with prefix skinnedmodel_500
		When I run a modelmark test with 500 instances with scale 1.0 using factory model:/go#skinnedfactory for 100 frames
		Then average frame time should be less than 0.017 seconds
