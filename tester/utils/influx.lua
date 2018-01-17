local metrics = require "tester.utils.metrics"

local M = {}

local VERSION_TO_TS = {
	["1afccdb2cd42ca3bc7612a0496dfa6d434a8ebf9"] = { version = "1.2.100", ts = math.floor(os.time({ year = 2017, month = 3, day = 17 }) * 1000) },
	["1e53d81a6306962b64381195f081d442d033ead1"] = { version = "1.2.101", ts = math.floor(os.time({ year = 2017, month = 3, day = 29 }) * 1000) },
	["d530758af74c2800d0898c591cc7188cc4515476"] = { version = "1.2.102", ts = math.floor(os.time({ year = 2017, month = 4, day = 19 }) * 1000) },
	["d126b0348d27c684d020e0bd43fde0a2771746f0"] = { version = "1.2.103", ts = math.floor(os.time({ year = 2017, month = 5, day = 2 }) * 1000) },
	["298b7ce75a1386a26124061dbccfa822df9bc982"] = { version = "1.2.104", ts = math.floor(os.time({ year = 2017, month = 5, day = 18 }) * 1000) },
	["a285bcf69ac6de9d1cab399768b74968c80cd864"] = { version = "1.2.105", ts = math.floor(os.time({ year = 2017, month = 5, day = 26 }) * 1000) },
	["dc92d10b96eaa8c0b3e527c76fecb22186d7cd60"] = { version = "1.2.106", ts = math.floor(os.time({ year = 2017, month = 6, day = 7 }) * 1000) },
	["597b94fc8d88b8f24264d54a59851951d04eae5c"] = { version = "1.2.107", ts = math.floor(os.time({ year = 2017, month = 6, day = 21 }) * 1000) },
	["8c2083883fdf321a3fa2aa1a1a5d319a82635c10"] = { version = "1.2.108", ts = math.floor(os.time({ year = 2017, month = 7, day = 5 }) * 1000) },
	["d1aad61476af35638fb6201574c7cc9869733aa6"] = { version = "1.2.109", ts = math.floor(os.time({ year = 2017, month = 7, day = 21 }) * 1000) },
	["de8a2aeb1843f573c81ab89c07c0ffb5f1c12e58"] = { version = "1.2.110", ts = math.floor(os.time({ year = 2017, month = 8, day = 1 }) * 1000) },
	["7ba1ba8d65588009458c7f389307d1943d25a683"] = { version = "1.2.111", ts = math.floor(os.time({ year = 2017, month = 8, day = 22 }) * 1000) },
	["0dde28ca92551934cf34137e33d029cce19b2447"] = { version = "1.2.112", ts = math.floor(os.time({ year = 2017, month = 9, day = 6 }) * 1000) },
	["e0ad6b7ed96333a156d95855641664f4b76fd0f6"] = { version = "1.2.113", ts = math.floor(os.time({ year = 2017, month = 9, day = 18 }) * 1000) },
	["5de6a24af5821865121237c3f77f8a42c8a044e2"] = { version = "1.2.114", ts = math.floor(os.time({ year = 2017, month = 10, day = 3 }) * 1000) },
	["57fb5f1ad5df59262aa415f298f97694debc991c"] = { version = "1.2.115", ts = math.floor(os.time({ year = 2017, month = 10, day = 12 }) * 1000) },
	["33da4aa91761d531471f364ef1693c2acec16de7"] = { version = "1.2.116", ts = math.floor(os.time({ year = 2017, month = 10, day = 27 }) * 1000) },
	["4ac025d15c25a9e0dbf14140d2e5d443c2edfdc4"] = { version = "1.2.117", ts = math.floor(os.time({ year = 2017, month = 11, day = 10 }) * 1000) },
	["0faa10db6bb28907d67358ad5810f3962437f3fd"] = { version = "1.2.118", ts = math.floor(os.time({ year = 2017, month = 12, day = 12 }) * 1000) },
	["2406775912d235d2579cfe723ab4dbcea2ca77ca"] = { version = "1.2.119", ts = math.floor(os.time({ year = 2018, month = 1, day = 4 }) * 1000) },
}

local function timestamp_from_sha1(sha1)
	return VERSION_TO_TS[sha1] and VERSION_TO_TS[sha1].ts
end

local function escape_tag(tag)
	return tag:gsub(" ", "\\ "):gsub(",", "\\,")
end

local function url_encode(str)
	if (str) then
		str = string.gsub (str, "\n", "\r\n")
		str = string.gsub (str, "([^%w %-%_%.%~])",
		function (c) return string.format ("%%%02X", string.byte(c)) end)
			str = string.gsub (str, " ", "+")
		end
	return str
end


local function send_measurement(url, name, tags, field_key, field_value, timestamp)
	assert(url, "You must provide a URL")
	assert(name, "You must provide a measurement name")
	assert(not tags or (tags and type(tags) == "table"), "You must either provide no tags or a list of tags")
	assert(field_key, "You must provide a field key")
	assert(field_value, "You must provide a field value")

	timestamp = timestamp or math.floor(socket.gettime() * 1000)
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
	http.request(url, "POST", response_handler, headers, post_data)
end

function M.send_metrics(url, prefix)
	if metrics.has_samples(metrics.FRAMETIME) then
		local frametime = metrics.average(metrics.FRAMETIME)
		local engine_info = sys.get_engine_info()
		local sys_info = sys.get_sys_info()

		local tags = {}
		if sys_info.device_model and sys_info.device_model ~= "" then
			tags.device_model = escape_tag(sys_info.device_model)
		end
		if sys_info.manufacturer and sys_info.manufacturer ~= "" then
			tags.manufacturer = escape_tag(sys_info.manufacturer)
		end
		tags.system_name = escape_tag(sys_info.system_name)
		tags.system_version = escape_tag(sys_info.system_version)
		tags.api_version = escape_tag(sys_info.api_version)
		tags.engine_sha1 = escape_tag(engine_info.version_sha1)
		tags.engine_version = escape_tag(engine_info.version)

		local timestamp = timestamp_from_sha1(engine_info.version_sha1)
		send_measurement(url, prefix .. "_frametime", tags, "average_frametime", frametime, timestamp)
	end
end


return M
