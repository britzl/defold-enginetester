require "cucumber.cucumber"
local wait = require "cucumber.automation.wait"

local previous_dump_handle = nil

Given("I have set user field (.*) to (.*)", function(index, value)
	index = tonumber(index)
	crash.set_user_field(index, value)
end)

When("the app crashes", function()
	if previous_dump_handle then
		crash.release(previous_dump_handle)
	end
	crash.write_dump()

end)

Then("I should be able to load a crash dump", function()
	previous_dump_handle = crash.load_previous()
	assert(previous_dump_handle, "Expected to get a handle to the crash dump")
end)

Then("crash signum should exist", function()
	local signum = crash.get_signum(previous_dump_handle)
	assert(signum, "Expected signum to exist")
end)

Then("crash backtrace should exist", function()
	local backtrace = crash.get_backtrace(previous_dump_handle)
	pprint(backtrace)
	assert(backtrace and #backtrace > 0, "Expected backtrace to exist")
end)

Then("crash backtrace should contain at least (.*) entries", function(min_entries)
	local backtrace = crash.get_backtrace(previous_dump_handle)
	pprint(backtrace)
	assert(backtrace, "Expected backtrace to exist")
	assert(#backtrace >= tonumber(min_entries), ("Expected backtrace to contain at least %s entries"):format(min_entries))
end)

Then("crash extra data should exist", function()
	local extra_data = crash.get_extra_data(previous_dump_handle)
	pprint(extra_data)
	assert(extra_data and #extra_data > 0, "Expected extra data to exist")
end)

Then("crash extra data should contain (.*)", function(data)
	local extra_data = crash.get_extra_data(previous_dump_handle)
	pprint(extra_data)
	assert(extra_data and #extra_data > 0, "Expected extra data to exist")
	assert(extra_data:find(data), ("Expected extra data to contain %s"):format(data))
end)

Then("crash modules should exist", function()
	local modules = crash.get_modules(previous_dump_handle)
	pprint(modules)
	assert(modules and #modules > 0, "Expected modules to exist")
end)

Then("crash modules should contain (.*)", function(name)
	local modules = crash.get_modules(previous_dump_handle)
	pprint(modules)
	assert(modules and #modules > 0, "Expected modules to exist")
	local found = false
	for _,module in ipairs(modules) do
		if module.name == name then
			found = true
			break
		end
	end
	assert(found, ("Expected modules to contain %s"):format(name))
end)


Then("crash sys field (.*) should be (.*)", function(sys_field, expected_value)
	local actual_value = crash.get_sys_field(previous_dump_handle, crash["SYSFIELD_" .. sys_field])
	assert(actual_value == expected_value, ("Expected sys field %s to be %s but it was %s"):format(sys_field, expected_value, actual_value))
end)

Then("crash sys fields should be set", function()
	local function check_field(name, expected, actual)
		assert(expected == actual, ("Expected %s to be set to %s but was %s"):format(name, expected, actual))
	end
	local android_build_fingerprint = crash.get_sys_field(previous_dump_handle, crash.SYSFIELD_ANDROID_BUILD_FINGERPRINT)
	local device_language = crash.get_sys_field(previous_dump_handle, crash.SYSFIELD_DEVICE_LANGUAGE)
	local manufacturer = crash.get_sys_field(previous_dump_handle, crash.SYSFIELD_MANUFACTURER)
	local device_model = crash.get_sys_field(previous_dump_handle, crash.SYSFIELD_DEVICE_MODEL)
	local engine_hash = crash.get_sys_field(previous_dump_handle, crash.SYSFIELD_ENGINE_HASH)
	local engine_version = crash.get_sys_field(previous_dump_handle, crash.SYSFIELD_ENGINE_VERSION)
	local language = crash.get_sys_field(previous_dump_handle, crash.SYSFIELD_LANGUAGE)
	local system_name = crash.get_sys_field(previous_dump_handle, crash.SYSFIELD_SYSTEM_NAME)
	local system_version = crash.get_sys_field(previous_dump_handle, crash.SYSFIELD_SYSTEM_VERSION)
	local territory = crash.get_sys_field(previous_dump_handle, crash.SYSFIELD_TERRITORY)

	local sys_info = sys.get_sys_info()
	local engine_info = sys.get_engine_info()
	check_field("device_language", sys_info.device_language, device_language)
	check_field("manufacturer", sys_info.manufacturer, manufacturer)
	check_field("device_model", sys_info.device_model, device_model)
	check_field("engine_hash", engine_info.version_sha1, engine_hash)
	check_field("engine_version", engine_info.version, engine_version)
	check_field("language", sys_info.language, language)
	check_field("system_name", sys_info.system_name, system_name)
	check_field("system_version", sys_info.system_version, system_version)
	check_field("territory", sys_info.territory, territory)
	if sys_info.system_name == "Android" then
		assert(android_build_fingerprint, "Expected android_build_fingerprint to be set")
	end
end)

Then("crash user field (.*) should be (.*)", function(index, expected_value)
	local actual_value = crash.get_user_field(previous_dump_handle, tonumber(index))
	assert(actual_value == expected_value, ("Expected user field %s to be %s but it was %s"):format(index, expected_value, actual_value))
end)
