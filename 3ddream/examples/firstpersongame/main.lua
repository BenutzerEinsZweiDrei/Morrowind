--load the 3D lib
dream = require("3DreamEngine")
love.window.setTitle("Castle")


tableHelper = {}

local json = require("dkjson")
-- Get a string with a table's contents where every value is on its own row
--
-- Based on http://stackoverflow.com/a/13398936
function tableHelper.getPrintableTable(inputTable, maxDepth, indentStr, indentLevel)

    if type(inputTable) ~= "table" then
        return type(inputTable)
    end

    local str = ""
    local currentIndent = ""

    if indentLevel == nil then indentLevel = 0 end
    if indentStr == nil then indentStr = "\t" end
    if maxDepth == nil then maxDepth = 50 end

    for i = 0, indentLevel do
        currentIndent = currentIndent .. indentStr
    end

    for index, value in pairs(inputTable) do

        if type(value) == "table" and maxDepth > 0 then
            value = "\n" .. tableHelper.getPrintableTable(value, maxDepth - 1, indentStr, indentLevel + 1)
        else
            if type(value) ~= "string" then
                value = tostring(value)
            end

            value = value .. "\n"
        end

        str = str .. currentIndent .. index .. ": " .. value
    end

    return str
end

function tableHelper.print(inputTable, maxDepth, indentStr, indentLevel)
    local text = tableHelper.getPrintableTable(inputTable, maxDepth, indentStr, indentLevel)
    print(text)
end














--settings
dream.objectDir = "examples/firstpersongame"

dream.AO_enabled = true       --ambient occlusion?
dream.AO_strength = 0.75      --blend strength
dream.AO_quality = 24         --samples per pixel (8-32 recommended)
dream.AO_quality_smooth = 2   --smoothing steps, 1 or 2 recommended, lower quality (< 12) usually requires 2 steps
dream.AO_resolution = 0.75    --resolution factor

dream.bloom_size = 12.0
dream.bloom_strength = 8.0




dream.cloudDensity = 0.6
dream.clouds = love.graphics.newImage(dream.objectDir .. "/clouds.jpg")
dream.sky = love.graphics.newImage(dream.objectDir .. "/sky.jpg")
dream.night = love.graphics.newImage(dream.objectDir .. "/night.jpg")

dream.startWithMissing = true

dream:init()

--generate mipmaps from the leaves texture
--dream:generateMipMaps(dream.objectDir .. "/objects/leaves.png")
--dream:generateMipMaps(dream.objectDir .. "/objects/grass.png")

castle = dream:loadObject("objects/scene", {splitMaterials = true, export3do = true})
ground = dream:loadObject("untitled")
water = dream:loadObject("models/terrain_water")
water:scale(200,70,200)
ground:scale(1.5,1,1.5)
barrel = dream:loadObject("models/contain_barrel_01")
--contain_barrel_01 again
siltPos = {0,0,0}
	
collision = dream:loadCollObject("/ground")
chunk = love.filesystem.read("seydaneen.json")
seyda = json.decode(chunk)
ground:rotateY(-90 *math.pi / 180)

local redTab = {}
for i, silt in pairs(seyda) do
	redTab[silt.model] = {silt.rotX, silt.rotY, silt.rotZ}
end

local v = 40
local b = 41
seydaLoaded = {}
	for i, silt in pairs(seyda) do
		
			seydaLoaded[i] = {}
			seydaLoaded[i].model = silt.model
			seydaLoaded[i].object = dream:loadObject("models/"..silt.model)
			seydaLoaded[i].x =  (silt.x)
			seydaLoaded[i].y =  (silt.y)
			seydaLoaded[i].z =  (silt.z) --[[
			silt.rotX = 0
			silt.rotY =  silt.r   *math.pi / 180
			silt.rotZ = 0]]
			seydaLoaded[i].rotX =  (silt.rotX) 
			seydaLoaded[i].rotY =  (silt.rotY) 
			seydaLoaded[i].rotZ =  (silt.rotZ) 
			seydaLoaded[i].object:rotateX(silt.rotX)
			seydaLoaded[i].object:rotateY(silt.rotY)
			seydaLoaded[i].object:rotateZ(silt.rotZ)
		
	end
--[[ -- code to translate morrowinD.js json
for i, ob in pairs(seydaLoaded) do
	-- vektor zu cs house berechnen
	local function vektorAzuB(x1,x2,y1,y2,z1,z2)
		local xr = x2 - x1
		local yr = y2 - y1
		local zr = z2 - z1
		return {xr, yr, zr}
	end
	
	local houseCS = {
	x =  -12136.000,
	y =  952.000, -- getauscht
	z =  -70368.000
	}
	
	local vek = vektorAzuB(houseCS.x,ob.x,houseCS.y,ob.y,houseCS.z,ob.z)
	
	-- diesen vektor durch standard teilen
	
	vek[1] = vek[1] /-40 -- -42
	vek[2] = vek[2] / 35,81
	vek[3] = vek[3] /41 --39
	
	-- mit neuem vektor punkt relativ zu house brechnen
	local houseDD = {  
		x =  25.631964322497,
        y =  0.94512503736296,
        z =  -91.85127646461
    }
	ob.x =   houseDD.x + vek[1]
	ob.y = 	 houseDD.y + vek[2]
	ob.z =   houseDD.z + vek[3] 


end
]]
print(success, message)
collision.objects = {}
love.graphics.setBackgroundColor(128/255, 218/255, 235/255)

math.randomseed(os.time())
io.stdout:setvbuf("no")

love.mouse.setRelativeMode(true)

player = {
	x = 0,
	y = 0,
	z = 0,
	ax = 0,
	ay = 0,
	az = 0,
	w = 0.4,
	h = 0.4,
	d = 0.6,
}

--because it is easier to work with two rotations
dream.cam.rx = 0
dream.cam.ry = 0


-- necessary vars
taken = {}
taken.tru = false
lookingAt =  {0,0,0}

local conf = {}
conf.takeSensitivity = 4
conf.lookingAtDistance = 8


function take(mod)

local tak = {}
tak.tru = false

	-- give ability to take specific object
	if mod then
			for i, ob in pairs(seydaLoaded) do
				if ob.model == mod then
					tak.tru = true
					tak.object = ob.object
					tak.c = i
					print(ob.model)
					return tak
				end
			end
	end


	-- collision with lookingAt
	function coll(var1, var2)
		if (var1 + conf.takeSensitivity > var2 and var1 - conf.takeSensitivity < var2) then
			return true
		end
		return false
	end
	
	--get take code 
	for i, ob in pairs(seydaLoaded) do
		if coll(ob.x, lookingAt[1]) and coll(ob.y, lookingAt[2]) and coll(ob.z, lookingAt[3]) then
			print("looking at box")
			tak.tru = true
			tak.object = ob.object
			tak.c = i
			print(ob.model)
			return tak
		end
	end
	return tak
end



function love.draw()

	dream.color_sun, dream.color_ambient = dream:getDayLight()
	dream.dayTime = 1 --love.timer.getTime() * 0.05 
	dream.sun = {0.3, math.cos(dream.dayTime*math.pi*2), math.sin(dream.dayTime*math.pi*2)}
	
	--update camera
	dream.cam:reset()
	dream.cam:translate(-dream.cam.x, -dream.cam.y, -dream.cam.z) --note that x, y, z are usually extracted from the camera matrix in prepare(), but we use it that way.
	dream.cam:rotateY(dream.cam.ry)
	dream.cam:rotateX(dream.cam.rx)
	
	--update light
	dream:resetLight()
	dream:addLight(player.x, player.y, player.z, 1.0, 0.75, 0.1, 1.0 + love.math.noise(love.timer.getTime()*2, 1.0)*0.5, 1.5)
	
	dream:prepare()
	
	castle:reset()
	--dream:draw(castle)
	dream:draw(ground, 200, -18, -100)
	dream:draw(water, 0, -28, 0)

	for i, ob in pairs(seydaLoaded) do
		
		if taken.tru and ob.object == taken.object then
				
				if rotVar then
					ob.rotY = ob.rotY + 0.1
					ob.object:rotateY(0.1)
					rotVar = false
				end
				
			
			dream:draw(ob.object, lookingAt[1] ,lookingAt[2] ,lookingAt[3] )		
		else
			dream:draw(ob.object, ob.x,ob.y,ob.z )
		end
	end

	--dream:draw(silt)
	
	if love.keyboard.isDown("f") and taken.tru then -- rotate
		rotVar = true
	end

	
	if love.keyboard.isDown("e") and not taken.tru then -- take
			taken = take()
	end
	
	if love.keyboard.isDown("r") and taken.tru then -- drop
			taken.tru = false
			seydaLoaded[taken.c].x = lookingAt[1]
			seydaLoaded[taken.c].y = lookingAt[2]
			seydaLoaded[taken.c].z = lookingAt[3]
	end	
	
	if love.keyboard.isDown("v") then -- take specific object
		taken = take("ex_common_house_tall_02")
	end

	if love.keyboard.isDown("t") then
				function translate(ta)
					local re = {}
					
					for i, it in pairs(ta) do
						re[i] = {}
						re[i].model = it.model
						re[i].x = it.x
						re[i].y = it.y 
						re[i].z = it.z
						re[i].rotX = it.rotX or 0
						re[i].rotY = it.rotY or 0
						re[i].rotZ = it.rotZ or 0
					end
					
					return re
				end
		local se = translate(seydaLoaded)			
					
		chunk = json.encode(se)
		success = love.filesystem.write("seydaneen.json", chunk)
		print("saved json", success)
	end
	
	
	dream:present()


	
	
	if love.keyboard.isDown(".") then
		love.graphics.print("Stats" ..
			"\ndifferent shaders: " .. dream.stats.shadersInUse ..
			"\ndifferent materials: " .. dream.stats.materialDraws ..
			"\ndraws: " .. dream.stats.draws,
			15, 400)
		end
		
	if love.keyboard.isDown("x") then
		print(player.x, player.y, player.z)
	end
end

function love.mousemoved(_, _, x, y)
	local speedH = 0.005
	local speedV = 0.005
	dream.cam.ry = dream.cam.ry - x * speedH
	
	winkelY = dream.cam.rx * 180 / math.pi --  0 to 180
	winkelX = dream.cam.ry * 180 / math.pi -- 0 to 360	
	
	if winkelX < 0 then
		winkelX = winkelX * -1 -- use positive
	end
	
	if winkelX > 360 then
		local equ = math.floor(winkelX / 360)
		winkelX = winkelX - (360 * equ) -- gets bigger than 360
	end
	
	winkelY = winkelY + 90 -- 0 top to 180 bottom
	
	-- point on sphere
	x = {}
	x[1] = 2 * math.sin(winkelY) * math.cos(winkelX)
	x[2] = 2 * math.sin(winkelY) * math.sin(winkelX)
	x[3] = 2 * math.cos(winkelY)
	
	
									function vektor(p1, p2)
										redX = ( p1[1] - p2[1] ) 
										redY = ( p1[2] - p2[2] )
										redZ = ( p1[3] - p2[3] ) 
										return {redX, redY, redZ}
									end
	-- from 0 to cam								
	ort = vektor({dream.cam.x, dream.cam.y, dream.cam.z}, {0,0,0})
	-- from cam to sphere point
	da = vektor(x, {0,0,0})
	
										function newPoint(point, Lvek)
											return {point[1] + (Lvek[1]*conf.lookingAtDistance), point[2] + (Lvek[2]*conf.lookingAtDistance), point[3] + (Lvek[3]*conf.lookingAtDistance)}
										end
	-- new cam pos point
	--camPos = newPoint({0,0,0}, ort)

	-- add sphere point vek to find looking at now
	lookingAt = newPoint({dream.cam.x,dream.cam.y,dream.cam.z}, dream.cam.normal)
	
	

	
	dream.cam.rx = math.max(-math.pi/2, math.min(math.pi/2, dream.cam.rx + y * speedV))
end

--collision not implemented yet
function collide(x, y, z, w, h, d)

	for i, c in pairs(collision.objects) do
		-- ground of this
		if (x < c.highest[1] and y < (c.highest[2] - 2) and z < c.highest[3] and x > c.lowest[1] and y > ( c.lowest[2] - 2) and z > c.lowest[2]) then
						tableHelper.print(c)
						return true
		end
	end


	return false
end

function love.update(dt)
	local d = love.keyboard.isDown
	local speed = 40*dt
	
	
	--gravity
	--player.ay = player.ay - dt * 15
	
	--collision
	local oldX = player.x
	player.x = player.x + player.ax * dt
	local b = collide(player.x-player.w/2, player.y-player.h/2, player.z-player.d/2, player.w, player.h, player.d)
	if b then
		player.x = oldX
		player.ax = 0
	end
	
	local oldY = player.y
	player.y = player.y + player.ay * dt
	local b = collide(player.x-player.w/2, player.y-player.h/2, player.z-player.d/2, player.w, player.h, player.d)
	if b then
		player.y = oldY
		
		if love.keyboard.isDown("space") and player.ay < 0 then
			player.ay = 8
		else
			speed = 40*dt
			player.ay = 0
		end
		
		player.ax = player.ax * (1 - dt*10)
		player.az = player.az * (1 - dt*10)
	end
	
	local oldZ = player.z
	player.z = player.z + player.az * dt
	local b = collide(player.x-player.w/2, player.y-player.h/2, player.z-player.d/2, player.w, player.h, player.d)
	if b then
		player.z = oldZ
		player.az = 0
	end
	
	if d("w") then
		player.ax = player.ax + math.cos(-dream.cam.ry-math.pi/2) * speed
		player.az = player.az + math.sin(-dream.cam.ry-math.pi/2) * speed
	end
	if d("s") then
		player.ax = player.ax + math.cos(-dream.cam.ry+math.pi-math.pi/2) * speed
		player.az = player.az + math.sin(-dream.cam.ry+math.pi-math.pi/2) * speed
	end
	if d("a") then
		player.ax = player.ax + math.cos(-dream.cam.ry-math.pi/2-math.pi/2) * speed
		player.az = player.az + math.sin(-dream.cam.ry-math.pi/2-math.pi/2) * speed
	end
	if d("d") then
		player.ax = player.ax + math.cos(-dream.cam.ry+math.pi/2-math.pi/2) * speed
		player.az = player.az + math.sin(-dream.cam.ry+math.pi/2-math.pi/2) * speed
	end
	if d("space") then
		player.ay = player.ay + speed
	end
	if d("lshift") then
		player.ay = player.ay - speed
	end
	

	
	--air resistance
	player.ax = player.ax * (1 - dt*3)
	player.ay = player.ay * (1 - dt*3)
	player.az = player.az * (1 - dt*3)
	
	--mount cam
	dream.cam.x = player.x
	dream.cam.y = player.y+0.3
	dream.cam.z = player.z
	
	--load world, then if done load high res textures
	dream.resourceLoader:update()
	
end

function love.keypressed(key)
	--screenshots!
	if key == "f2" then
		if love.keyboard.isDown("lctrl") then
			love.system.openURL(love.filesystem.getSaveDirectory() .. "/screenshots")
		else
			love.filesystem.createDirectory("screenshots")
			if not screenShotThread then
				screenShotThread = love.thread.newThread([[
					require("love.image")
					channel = love.thread.getChannel("screenshots")
					while true do
						local screenshot = channel:demand()
						screenshot:encode("png", "screenshots/screen_" .. tostring(os.time()) .. ".png")
					end
				]]):start()
			end
			love.graphics.captureScreenshot(love.thread.getChannel("screenshots"))
		end
	end
	
	if key == "3" then
		dream.anaglyph3D = not dream.anaglyph3D
	end

	--fullscreen
	if key == "f11" then
		love.window.setFullscreen(not love.window.getFullscreen())
	end
end

function love.resize()
	dream:init()
end