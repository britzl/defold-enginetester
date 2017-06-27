local M = {}


local instances = {}

local sequence_count = 0


local function create_instance()
	local co = coroutine.running()
	assert(co, "You must call this function from within a coroutine")
	sequence_count = sequence_count + 1

	local instance = {
		id = sequence_count,
		co = co,
	}
	table.insert(instances, instance)
	return instance
end


local function remove_instance(instance)
	for k,v in pairs(instances) do
		if v.id == instance.id then
			instances[k] = nil
			return
		end
	end
end


--- Wait until a function returns true when called
-- @param fn Function that must return true, will receive dt as its only argument
-- @param timeout Optional timeout in seconds
function M.until_true(fn, timeout)
	local instance = create_instance()
	instance.update = true

	local timestamp = socket.gettime()
	local dt = 0
	while not fn(dt) do
		dt = coroutine.yield()
		if timeout and socket.gettime() >= (timestamp + timeout)  then
			break
		end
	end

	remove_instance(instance)
end

--- Wait until a message is received
-- @param fn Function that will receive message and return true if message is the correct one
-- @param timeout Optional timeout in seconds
function M.until_message(fn, timeout)
	local instance = create_instance()
	instance.message = true

	local timestamp = socket.gettime()
	local message_id, message, sender
	while not fn(message_id, message, sender) do
		message_id, message, sender = coroutine.yield()
		if timeout and socket.gettime() >= (timestamp + timeout) then
			break
		end
	end

	remove_instance(instance)
end

--- Wait until a certain number of seconds have elapsed
-- @param seconds Seconds to wait
function M.seconds(seconds)
	assert(seconds and seconds >= 0, "You must provide a positive number of seconds to wait")
	M.until_true(function(dt)
		seconds = seconds - dt
		return seconds <= 0
	end)
end

--- Wait a single frame
function M.one_frame()
	M.until_true(function(dt)
		return true
	end)
end


function M.load_proxy(url)
	url = msg.url(url)
	msg.post(url, "load")
	M.until_message(function(message_id, message, sender)
		return message_id == hash("proxy_loaded") and sender == url
	end)
	msg.post(url, "enable")
end

function M.unload_proxy(url)
	url = msg.url(url)
	msg.post(url, "disable")
	msg.post(url, "final")
	msg.post(url, "unload")
	M.until_message(function(message_id, message, sender)
		return message_id == hash("proxy_unloaded") and sender == url
	end)
end


function M.switch_context(url)
	url = msg.url(url)
	url = msg.url(url.socket, hash("/cucumber"), "script")
	msg.post(url, "switch_cucumber_context")
	M.until_message(function(message_id, message, sender)
		return message_id == hash("switch_cucumber_context")
	end)
end

function M.animate(url, property, playback, to, easing, duration, delay)
	local done = false
	M.switch_context(url)
	go.cancel_animations(url, property)
	go.animate(url, property, playback, to, easing, duration, delay, function()
		done = true
	end)
	M.until_true(function()
		return done
	end)
end

function M.update(dt)
	for i=#instances,1,-1 do
		local instance = instances[i]
		if coroutine.status(instance.co) == "dead" then
			instances[i] = nil
		else
			if instance.update then
				coroutine.resume(instance.co, dt)
			end
			return
		end
	end
end

function M.on_message(message_id, message, sender)
	for i=#instances,1,-1 do
		local instance = instances[i]
		if coroutine.status(instance.co) == "dead" then
			instances[i] = nil
		else
			if instance.message then
				coroutine.resume(instance.co, message_id, message, sender)
			end
			return
		end
	end
end


return setmetatable(M, { __call = function(self, fn)
	M.until_true(fn)
end })
