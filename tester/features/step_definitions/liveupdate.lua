require "cucumber.cucumber"
local wait = require "tester.utils.wait"


Then("collection proxy (.*) should have (.*) missing resources", function(url, count)
	wait.switch_context(url)
	local resources = collectionproxy.missing_resources(url)
	assert(#resources == tonumber("count"), ("Expected %s missing resources for %s but got %d"):format(count, url, #resources))
end)

--"https://s3-eu-west-1.amazonaws.com/defold-resources-qa/defoldtest/"
When("I download and store missing resources for collection proxy (.*) from (.*)", function(proxy_url, download_url)
	wait.switch_context(proxy_url)
	local resources = collectionproxy.missing_resources(proxy_url)
	local manifest = resource.get_current_manifest()

	local count = #resources

	for k,v in ipairs(resources) do
		http.request(download_url .. tostring(v), "GET", function(self, id, response)
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

	local timeout = socket.gettime() + 30
	wait.until_true(function()
		return count == 0 or socket.gettime() > timeout
	end)

	assert(count == 0, "Timeout while downloading resources")
end)
