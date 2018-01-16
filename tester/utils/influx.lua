local metrics = require "tester.utils.metrics"

local M = {}


local function send_measurement(url, name, tags, field_key, field_value)
	assert(url, "You must provide a URL")
	assert(name, "You must provide a measurement name")
	assert(not tags or (tags and type(tags) == "table"), "You must either provide no tags or a list of tags")
	assert(field_key, "You must provide a field key")
	assert(field_value, "You must provide a field value")

	local timestamp = math.floor(socket.gettime() * 1000)
	local tagged_name
	if tags then
		local joined_tags = {}
		for k,v in pairs(tags) do
			joined_tags[#joined_tags + 1] = k .. "=" .. tostring(v)
		end
		tagged_name = name .. "," .. table.concat(joined_tags, ",")
	else
		tagged_name = name
	end

	local post_data = ("%s %s=%s %s"):format(tagged_name, field_key, tostring(field_value), tostring(timestamp))
	local headers = {}
	local function response_handler(self, id, response)
		print("Response")
		pprint(response)
	end
	url = url .. "&precision=ms"
	print("Sending metrics", url, post_data)
	http.request(url, "POST", response_handler, {}, post_data)
end

function M.send_metrics(url, prefix)
	print("send_metrics", url, prefix)
	if metrics.has_samples(metrics.FRAMETIME) then
		print("send_metrics has FRAMETIME metrics")
		local frametime = metrics.average(metrics.FRAMETIME)
		local engine_info = sys.get_engine_info()
		local sys_info = sys.get_sys_info()

		local tags = { sha1 = engine_info.version_sha1 }
		if sys_info.device_model and sys_info.device_model ~= "" then
			tags.device_model = sys_info.device_model
		else
			tags.device_model = sys_info.system_name .. sys_info.system_version
		end

		send_measurement(url, prefix .. "_frametime", tags, "average_frametime", frametime)
	end
end


return M