local wait = require "tester.utils.wait"

local errors = {}

local _pcall = pcall
local _xpcall = xpcall

Before(function()
	errors = {}
	_pcall = pcall
	_xpcall = xpcall
end)

After(function()
	pcall = _pcall
	xpcall = _xpcall
end)

Given("the (.*) collection is loaded", function(proxy_url)
	wait.load_proxy(proxy_url)
end)

Given("I check for errors", function()
	pcall = function(f, ...)
		local success, err = _pcall(f, ...)
		if not success then
			table.insert(errors, { message = err, traceback = debug.traceback() })
		end
		return true
	end
	--[[sys.set_error_handler(function(source, message, traceback)
		table.insert(errors, { source = source, message = message, traceback = traceback })
	end)--]]
end)

When("I wait (.*) seconds?", function(seconds)
	wait.seconds(tonumber(seconds))
end)

Then("an error should have happened", function()
	assert(#errors > 0, "Expected an error")
end)