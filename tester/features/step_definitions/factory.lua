local wait = require "tester.utils.wait"

local function to_quat(x, y, z)
	local qx = vmath.quat_rotation_x(math.rad(tonumber(x)))
	local qy = vmath.quat_rotation_y(math.rad(tonumber(y)))
	local qz = vmath.quat_rotation_z(math.rad(tonumber(z)))
	return qx*qy*qz
end



local spawned_ids = {}

Before(function()
	spawned_ids = {}
end)


local function spawn(url, amount, position, rotation, properties, scale)
	wait.switch_context(url)
	spawned_ids[url] = spawned_ids[url] or {}

	for i=1,tonumber(amount) do
		local id = factory.create(url, position, rotation, properties, scale)
		table.insert(spawned_ids[url], id)
	end
end

When("I use factory (.*) to spawn (%d*) game objects?", function(url, amount)
	spawn(url, amount, nil, nil, {}, nil)
end)
When("I use factory (.*) to spawn (%d*) game objects? at position (.*),(.*),(.*)", function(url, amount, x, y, z)
	spawn(url, amount, vmath.vector3(x, y, z), nil, {}, nil)
end)
When("I use factory (.*) to spawn (%d*) game objects? with rotation (.*),(.*),(.*) degrees", function(url, amount, x, y, z)
	spawn(url, amount, nil, to_quat(x,y,z), {}, nil)
end)
When("I use factory (.*) to spawn (%d*) game objects? with scale (.*)", function(url, amount, scale)
	spawn(url, amount, nil, nil, {}, tonumber(scale))
end)
When("I use factory (.*) to spawn (%d*) game objects? with scale (.*),(.*),(.*)", function(url, amount, x, y, z)
	spawn(url, amount, nil, nil, {}, vmath.vector3(x,y,z))
end)
When("I use factory (.*) to spawn (%d*) game objects? with the (.*) property set to hash (.*)", function(url, amount, property, value)
	local properties = { [property] = hash(value) }
	spawn(url, amount, nil, nil, properties)
end)
When("I use factory (.*) to spawn (%d*) game objects? with the (.*) property set to number (.*)", function(url, amount, property, value)
	local properties = { [property] = tonumber(value) }
	spawn(url, amount, nil, nil, properties)
end)
When("I use factory (.*) to spawn (%d*) game objects? with the (.*) property set to url (.*)", function(url, amount, property, value)
	local properties = { [property] = msg.url(value) }
	spawn(url, amount, nil, nil, properties)
end)
When("I use factory (.*) to spawn (%d*) game objects? with the (.*) property set to vector3 (.*),(.*),(.*)", function(url, amount, property, x, y, z)
	local properties = { [property] = vmath.vector3(x, y, z) }
	spawn(url, amount, nil, nil, properties)
end)
When("I use factory (.*) to spawn (%d*) game objects? with the (.*) property set to vector4 (.*),(.*),(.*),(.*)", function(url, amount, property, x, y, z, w)
	local properties = { [property] = vmath.vector4(x, y, z, w) }
	spawn(url, amount, nil, nil, properties)
end)
