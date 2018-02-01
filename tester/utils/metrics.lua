local M = {}


M.FPS = "FPS"
M.CPU = "CPU"
M.MEM = "MEM"
M.FRAMETIME = "FRAMETIME"

local function collect_fps(data, dt)
	if data.interval() then
		data.samples[#data.samples + 1] = data.current_sample[1]
		data.current_sample[1] = 0
	end
	data.current_sample[1] = data.current_sample[1] + 1
end


local function collect_cpu(data, dt)
	if data.interval() then
		data.samples[#data.samples + 1] = profiler.get_cpu_usage()
	end
end


local function collect_mem(data, dt)
	if data.interval() then
		data.samples[#data.samples + 1] = profiler.get_memory_usage()
	end
end

local function collect_frametime(data, dt)
	if data.interval() then
		data.samples[#data.samples + 1] = dt
	end
end



local metrics = {
	[M.FPS] = { fn = collect_fps },
	[M.CPU] = { fn = collect_cpu },
	[M.MEM] = { fn = collect_mem },
	[M.FRAMETIME] = { fn = collect_frametime },
}


--- Create a frame interval function
-- @param interval Frame interval, 0=every frame, 1=every second frame
-- @return Interval function
function M.frame_interval(interval)
	local c = interval
	return function()
		c = c - 1
		if c == -1 then
			c = interval
			return true
		end
		return false
	end
end

--- Create a time interval function
-- @param interval Time in seconds between when samples should be collected
-- @return Interval function
function M.time_interval(interval)
	local t = socket.gettime() + interval
	return function()
		local now = socket.gettime()
		if now >= t then
			t = now + interval
			return true
		end
		return false
	end
end


--- Stop collecting metrics
function M.stop()
	for metric,data in pairs(metrics) do
		data.enabled = false
	end
end

--- Collect samples for a specific metric
-- @param metric
-- @param interval A function that should return true whenever it is time to collect
-- data for the metric. Create using either Mtime_interval(interval) or M.frame_interval(interval)
function M.collect(metric, interval)
	assert(metrics[metric], ("Unknown metric %s"):format(metric))
	assert(interval and type(interval) == "function", "Interval must be a function")
	metrics[metric].interval = interval
	metrics[metric].samples = {}
	metrics[metric].current_sample = { 0 }
	metrics[metric].enabled = true
end

--- Get list of enabled metrics
-- @return Enabled metrics
function M.enabled_metrics()
	local enabled = {}
	for metric,data in pairs(metrics) do
		if data.enabled then
			enabled[#enabled + 1] = metric
		end
	end
	return enabled
end

--- Check if a metric is enabled or not
-- @param metric
-- @return true if the metric is enabled
function M.is_enabled(metric)
	assert(metrics[metric], ("Unknown metric %s"):format(metric))
	return metrics[metric].enabled
end

--- Check if a metric has collected any samples
-- @param metric
-- @return true if samples has been collected
function M.has_samples(metric)
	assert(metrics[metric], ("Unknown metric %s"):format(metric))
	return #metrics[metric].samples
end

-- call once per frame
-- if called more often the FPS metrics will be wrong
function M.update(dt)
	for metric,data in pairs(metrics) do
		if data.enabled then
			data.fn(data, dt)
		end
	end
end


local function copy(t)
	local c = {}
	for k,v in pairs(t) do
		c[k] = v
	end
	return c
end


--- Get all samples collected for a metric
-- @param metric
-- @return Collected samples (copy)
function M.samples(metric)
	assert(metrics[metric], ("Unknown metric %s"):format(metric))
	return copy(metrics[metric].samples)
end

--- Count the number of collected samples for a metric
-- @param metric
-- @return Number of collected samples
function M.sample_count(metric)
	assert(metrics[metric], ("Unknown metric %s"):format(metric))
	return #metrics[metric].samples
end

--- Get the sum up the total value of all collected sample for a metric
-- @param metric
-- @return Sum of collected samples when added
function M.total(metric)
	assert(metrics[metric], ("Unknown metric %s"):format(metric))
	local samples = M.samples(metric)
	local total = 0
	for _,sample in ipairs(samples) do
		total = total + sample
	end
	return total
end

--- Get the average value of all collected samples for a metric
-- @param metric
-- @return Average of collected samples
function M.average(metric)
	assert(metrics[metric], ("Unknown metric %s"):format(metric))
	local sample_count = M.sample_count(metric)
	if sample_count == 0 then
		return 0
	end
	return M.total(metric) / sample_count
end

--- Get the minimum value of all collected samples for a metric
-- @param metric
-- @return Minimum value
function M.minimum(metric)
	assert(metrics[metric], ("Unknown metric %s"):format(metric))
	local samples = M.samples(metric)
	local min = samples[1]
	for _,sample in ipairs(samples) do
		min = math.min(min, sample)
	end
	return min
end

--- Get the maximum value of all collected samples for a metric
-- @param metric
-- @return Maximum value
function M.maximum(metric)
	assert(metrics[metric], ("Unknown metric %s"):format(metric))
	local samples = M.samples(metric)
	local max = samples[1]
	for _,sample in ipairs(samples) do
		max = math.max(max, sample)
	end
	return max
end

--- Get the median value of all collected samples for a metric
-- @param metric
-- @return Median of collected samples
function M.median(metric)
	assert(metrics[metric], ("Unknown metric %s"):format(metric))
	local samples = M.samples(metric)
	local half = #samples / 2
	table.sort(samples)
	if #samples % 2 == 1 then
		return (samples[math.floor(half)] + samples[math.ceil(half)]) / 2
	else
		return samples[half]
	end
end

return M
