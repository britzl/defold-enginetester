require "cucumber.cucumber"
local wait = require "cucumber.automation.wait"

local received_notifications = nil

Before(function()
	if not push then return end
	received_notifications = {}
	push.set_listener(function(self, payload, origin, activated)
		received_notifications[#received_notifications + 1] = {
			payload = payload,
			origin = origin,
			activated = activated,
		}
		pprint(received_notifications)
	end)
end)

Given("I have scheduled a local push notification in (%d*) seconds", function(seconds)
	if not push then return end
	seconds = tonumber(seconds)
	push.schedule(seconds, "Footitle", "Foobody", "{}", {
		action = "Fooaction",
		badge_count = 1,
		priority = 2
	})
end)

Then("I should have received a local push notification", function()
	if not push then return end
	assert(#received_notifications > 0, "Expected a local notification")
end)
