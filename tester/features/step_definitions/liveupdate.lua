require "cucumber.cucumber"
local wait = require "tester.utils.wait"

Then("collection proxy (.*) should have (%d*) missing resources", function(proxy_url, count)
	wait.switch_context(proxy_url)
	local resources = collectionproxy.missing_resources(proxy_url)
	assert(#resources == tonumber(count), ("Expected %d missing resources for %s but got %d"):format(tonumber(count), proxy_url, #resources))
end)

When("I download missing resources for collection proxy (.*) from (.*)", function(proxy_url, download_url)
	wait.switch_context(proxy_url)
	local resources = collectionproxy.missing_resources(proxy_url)
	local manifest = resource.get_current_manifest()

	local count = #resources
	for k,v in ipairs(resources) do
		local url = download_url .. tostring(v)
		http.request(url, "GET", function(self, id, response)
			if response.status > 199 and response.status < 400 then
				resource.store_resource(manifest, response.response, v, function (self, hexdigest, success)
					assert(success, ("resource.store_resource() failed for %s"):format(v))
					count = count - 1
				end)
			else
				assert(false, ("Download of resource %s failed"):format(v))
			end
		end)
	end

	wait.until_true(function()
		return count == 0
	end, 30)

	assert(count == 0, "Timeout while downloading resources")
end)
