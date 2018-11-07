require "cucumber.cucumber"
local influx = require "tester.utils.influx"
local wait = require "cucumber.automation.wait"

local settings = {}

Before(function()
	settings.enabled = false
	settings.url = nil
	settings.prefix = nil
end)

After(function()
	if settings.enabled then
		wait.until_callback(function(cb)
			influx.send_metrics(settings.url, settings.prefix, cb)
		end)
	end
end)

Given("metrics are sent to the influx instance at (.*) with prefix (.*)", function(url, prefix)
	settings.url = url
	settings.prefix = prefix
	settings.enabled = true
end)
