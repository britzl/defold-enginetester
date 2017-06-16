local wait = require "tester.utils.wait"

local spawned_ids = {}

Before(function()
	spawned_ids = {}
end)

When("I use factory (.*) to spawn (%d*) game objects?", function(url, amount)
	wait.switch_context(url)
	spawned_ids[url] = spawned_ids[url] or {}

	for i=1,tonumber(amount) do
		local id = factory.create(url)
		table.insert(spawned_ids[url], id)
	end
end)
