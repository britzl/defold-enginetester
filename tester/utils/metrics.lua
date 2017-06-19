local M = {}


M.FPS = "FPS"
M.CPU = "CPU"
M.MEM = "MEM"

local function collect_fps(data)
	local now = socket.gettime()
	if now >= data.nextsample then
		data.samples[#data.samples + 1] = data.current_sample[1]
		data.nextsample = now + data.interval
		data.current_sample[1] = 0
	end
	data.current_sample[1] = data.current_sample[1] + 1
end


local function collect_cpu(data)
	local now = socket.gettime()
	if now >= data.nextsample then
		data.samples[#data.samples + 1] = profiler.get_cpu_usage()
		data.nextsample = now + data.interval
	end
end


local function collect_mem(data)
	local now = socket.gettime()
	if now >= data.nextsample then
		data.samples[#data.samples + 1] = profiler.get_memory_usage()
		data.nextsample = now + data.interval
	end
end



local metrics = {
	[M.FPS] = { fn = collect_fps },
	[M.CPU] = { fn = collect_cpu },
	[M.MEM] = { fn = collect_mem },
}



function M.stop()
	for metric,data in pairs(metrics) do
		data.enabled = false
	end
end

function M.collect(metric, interval)
	assert(metrics[metric], ("Unknown metric %s"):format(metric))
	assert(interval > 0, "Interval must be greater than 0")
	metrics[metric].interval = interval
	metrics[metric].samples = {}
	metrics[metric].current_sample = { 0 }
	metrics[metric].nextsample = socket.gettime() + interval
	metrics[metric].enabled = true
end

-- call once per frame
-- if called more often the FPS metrics will be wrong
function M.update()
	for metric,data in pairs(metrics) do
		if data.enabled then
			data.fn(data)
		end
	end
end


function M.samples(metric)
	assert(metrics[metric], ("Unknown metric %s"):format(metric))
	return metrics[metric].samples
end

function M.average(metric)
	assert(metrics[metric], ("Unknown metric %s"):format(metric))
	local samples = M.samples(metric)
	if #samples == 0 then
		return 0
	end
	
	local total = 0
	for _,sample in ipairs(samples) do
		total = total + samples
	end
	return total / #samples
end

return M
