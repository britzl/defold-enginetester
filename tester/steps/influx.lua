require "cucumber.cucumber"
local influx = require "tester.utils.influx"
local metrics = require "tester.utils.metrics"

local settings = {}

Before(function()
	settings.enabled = false
	settings.url = nil
	settings.prefix = nil
end)

After(function()
	if settings.enabled then
		influx.send_metrics(settings.url, settings.prefix)
	end
end)

Given("metrics is sent to the influx instance at (.*) with prefix (.*)", function(url, prefix)
	settings.url = url
	settings.prefix = prefix
	settings.enabled = true
end)
