local wait = require "tester.utils.wait"

Given("the game object (.*) is at position (%d*),(%d*),(%d*)", function(url, x, y, z)
	wait.switch_context(url)
	go.set_position(vmath.vector3(x, y, z), url)
end)


When("I set game object (.*) position to (%d*),(%d*),(%d*)", function(url, x, y, z)
	wait.switch_context(url)
	go.set_position(vmath.vector3(x, y, z), url)
end)
When("I set game object (.*) rotation to (%d*),(%d*),(%d*) degrees", function(url, x, y, z)
	wait.switch_context(url)
	local qx = vmath.quat_rotation_x(math.rad(x))
	local qy = vmath.quat_rotation_y(math.rad(y))
	local qz = vmath.quat_rotation_z(math.rad(z))
	local quat = qx*qy*qz
	go.set_rotation(quat, url)
end)
When("I set game object (.*) scale to (%d*),(%d*),(%d*)", function(url, x, y, z)
	wait.switch_context(url)
	go.set_scale(vmath.vector3(x, y, z), url)
end)
When("I set game object (.*) scale to (%d*)", function(url, scale)
	wait.switch_context(url)
	go.set_scale(scale, url)
end)

When("I animate game object (.*) position to (%d*),(%d*),(%d*) in (.*) second", function(url, x, y, z, duration)
	wait.switch_context(url)
	go.cancel_animations(url, "position")
	go.animate(url, "position", go.PLAYBACK_ONCE_FORWARD, vmath.vector3(x, y, z), go.EASING_LINEAR, tonumber(duration))
end)
When("I animate game object (.*) (.*) to (%d*) in (.*) second", function(url, property, value, duration)
	wait.switch_context(url)
	go.cancel_animations(url, property)
	go.animate(url, property, go.PLAYBACK_ONCE_FORWARD, tonumber(value), go.EASING_LINEAR, tonumber(duration))
end)
When("I animate game object (.*) rotation (%d*),(%d*),(%d*) degrees in (.*) second", function(url, x, y, z, duration)
	wait.switch_context(url)
	go.cancel_animations(url, "rotation")
	local qx = vmath.quat_rotation_x(math.rad(x))
	local qy = vmath.quat_rotation_y(math.rad(y))
	local qz = vmath.quat_rotation_z(math.rad(z))
	local quat = qx*qy*qz
	go.animate(url, "rotation", go.PLAYBACK_ONCE_FORWARD, quat, go.EASING_LINEAR, tonumber(duration))
end)
When("I cancel the (.*) animation on game object (.*)", function(property, url)
	wait.switch_context(url)
	go.cancel_animations(url, property)
end)
When("I delete game object (.*)", function(url)
	wait.switch_context(url)
	go.delete(url)
end)
When("I set the (.*) property of game object (.*) to hash (.*)", function(property, url, value)
	wait.switch_context(url)
	go.set(url, property, hash(value))
end)
When("I set the (.*) property of game object (.*) to number (.*)", function(property, url, value)
	wait.switch_context(url)
	go.set(url, property, tonumber(value))
end)
When("I set the (.*) property of game object (.*) to url (.*)", function(property, url, value)
	wait.switch_context(url)
	go.set(url, property, msg.url(value))
end)
When("I set the (.*) property of game object (.*) to vector3 (%d*),(%d*),(%d*)", function(property, url, x, y, z)
	wait.switch_context(url)
	go.set(url, property, vmath.vector3(x, y, z))
end)
When("I set the (.*) property of game object (.*) to vector4 (%d*),(%d*),(%d*),(%d*)", function(property, url, x, y, z, w)
	wait.switch_context(url)
	go.set(url, property, vmath.vector4(x, y, z, w))
end)


Then("game object (.*) should not be at position (%d*),(%d*),(%d*)", function (url, x, y, z)
	wait.switch_context(url)
	assert(go.get_position(url) ~= vmath.vector3(x, y, z), "Did not expected position")
end)
Then("game object (.*) should be at position (%d*),(%d*),(%d*)", function (url, x, y, z)
	wait.switch_context(url)
	assert(go.get_position(url) == vmath.vector3(x, y, z), "Expected position")
end)
Then("game object (.*) should be at world position (%d*),(%d*),(%d*)", function (url, x, y, z)
	wait.switch_context(url)
	assert(go.get_world_position(url) == vmath.vector3(x, y, z), "Expected position")
end)
Then("game object (.*) should be rotated (%d*),(%d*),(%d*) degrees", function (url, x, y, z)
	wait.switch_context(url)
	local qx = vmath.quat_rotation_x(math.rad(x))
	local qy = vmath.quat_rotation_y(math.rad(y))
	local qz = vmath.quat_rotation_z(math.rad(z))
	local quat = qx*qy*qz
	assert(go.get_rotation(url) == quat, "Expected rotation")
end)
Then("game object (.*) should not be rotated (%d*),(%d*),(%d*) degrees", function (url, x, y, z)
	wait.switch_context(url)
	local qx = vmath.quat_rotation_x(math.rad(x))
	local qy = vmath.quat_rotation_y(math.rad(y))
	local qz = vmath.quat_rotation_z(math.rad(z))
	local quat = qx*qy*qz
	assert(go.get_rotation(url) ~= quat, "Did not expected rotation")
end)
Then("game object (.*) should have the (.*) property set to hash (.*)", function(url, property, value)
	wait.switch_context(url)
	assert(go.get(url, property) == hash(value))
end)
Then("game object (.*) should have the (.*) property set to number (.*)", function(url, property, value)
	wait.switch_context(url)
	assert(go.get(url, property) == tonumber(value))
end)
Then("game object (.*) should have the (.*) property set to url (.*)", function(url, property, value)
	wait.switch_context(url)
	assert(go.get(url, property) == msg.url(value))
end)
Then("game object (.*) should have the (.*) property set to vector3 (.*),(.*),(.*)", function(url, property, x, y, z)
	wait.switch_context(url)
	assert(go.get(url, property) == vmath.vector3(x, y, z))
end)
Then("game object (.*) should have the (.*) property set to vector4 (.*),(.*),(.*),(.*)", function(url, property, x, y, z, w)
	wait.switch_context(url)
	assert(go.get(url, property) == vmath.vector4(x, y, z, w))
end)
Then("game object (.*) should be scaled to (.*),(.*),(.*)", function(url, x, y, z)
	wait.switch_context(url)
	assert(go.get_scale(url) == vmath.vector3(x, y, z))
end)
Then("game object (.*) should be scaled to (%d*)", function(url, scale)
	wait.switch_context(url)
	assert(go.get_scale_uniform(url) == tonumber(scale), ("Expected %d but got %d"):format(tonumber(scale), go.get_scale_uniform(url)))
end)

