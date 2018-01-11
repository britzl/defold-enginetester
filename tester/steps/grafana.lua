require "cucumber.cucumber"
local grafana = require "tester.utils.grafana"
local metrics = require "tester.utils.metrics"

local enabled = false

Before(function()
	enabled = false
end)

After(function()
	if enabled then
		grafana.send(what, data)
	end
end)


Given("metrics is sent to grafana", function()
	enabled = true
end)
