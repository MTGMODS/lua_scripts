script_name("CamHack V3")
script_description('CamHack for MonetLoader X64')
script_author("MTG MODS")
script_version(3)

require('lib.moonloader')

local camhack_active = false
local camhack_speed = 0.2

local posX
local posY
local posZ
local angZ
local angY
local radZ
local radY
local sinZ
local cosZ
local sinY
local cosY
local poiX
local poiY
local poiZ
local curZ
local curY

local widgets = require('widgets')

------------------------------------------- Main -----------------------------------------------------

function main()

	while (true) do
		wait(0)

		if (camhack_active) then
			camhack_update()
			if (isWidgetPressed(WIDGET_ZOOM_IN)) then
				camhack_speed_plus()
			end
			if (isWidgetPressed(WIDGET_ZOOM_OUT)) then
				camhack_speed_minus()
			end
			if (isWidgetPressed(WIDGET_CRANE_UP)) then
				camhack_up()
			end
			if (isWidgetPressed(WIDGET_CRANE_DOWN)) then
				camhack_down()
			end
			if (isWidgetPressed(WIDGET_RACE_LEFT)) then
				camhack_angle_left()
			end
			if (isWidgetPressed(WIDGET_RACE_RIGHT)) then
				camhack_angle_right()
			end
			local result, var_1, var_2 = isWidgetPressedEx(WIDGET_PED_MOVE, 0)
			if (result and var_1 ~= 0 and var_2 ~= 0) then
				handleJoystick(var_1, var_2)
			end
			if (isWidgetPressed(WIDGET_MISSION_CANCEL)) then
				camhack_off()
			end
		else
            if (isWidgetPressed(WIDGET_CAM_TOGGLE)) then
			    camhack_on()
            end
		end
	end
end

function camhack_on()
	posX, posY, posZ = getCharCoordinates(playerPed)
	setFixedCameraPosition(posX, posY, posZ, 0.0, 0.0, 0.0)
	angZ = getCharHeading(playerPed)
	angZ = angZ * -1.0
	angY = 0.0
	lockPlayerControl(true)
	camhack_active = true
	camhack_disable_hud()
end
function camhack_off()
	camhack_active = false
	angPlZ = angZ * -1.0
	restoreCameraJumpcut()
	setCameraBehindPlayer()
	lockPlayerControl(false)
	camhack_enable_hud()
end
function camhack_update()
	radZ, radY = math.rad(angZ), math.rad(angY)
	sinZ, cosZ = math.sin(radZ), math.cos(radZ)
	sinY, cosY = math.sin(radY), math.cos(radY)
	sinZ, cosZ, sinY = sinZ * cosY, cosZ * cosY, sinY * 1.0
	poiX, poiY, poiZ = posX + sinZ, posY + cosZ, posZ + sinY
	pointCameraAtPoint(poiX, poiY, poiZ, 2)
end
function camhack_foward()
	radZ = math.rad(angZ)
	radY = math.rad(angY)
	sinZ = math.sin(radZ)
	cosZ = math.cos(radZ)
	sinY = math.sin(radY)
	cosY = math.cos(radY)
	sinZ = sinZ * cosY
	cosZ = cosZ * cosY
	sinZ = sinZ * camhack_speed 
	cosZ = cosZ * camhack_speed 
	sinY = sinY * camhack_speed 
	posX = posX + sinZ
	posY = posY + cosZ
	posZ = posZ + sinY
	setFixedCameraPosition(posX, posY, posZ, 0.0, 0.0, 0.0)
end
function camhack_back()
	curZ = angZ + 180.0
	curY = angY * -1.0
	radZ = math.rad(curZ)
	radY = math.rad(curY)
	sinZ = math.sin(radZ)
	cosZ = math.cos(radZ)
	sinY = math.sin(radY)
	cosY = math.cos(radY)
	sinZ = sinZ * cosY
	cosZ = cosZ * cosY
	sinZ = sinZ * camhack_speed
	cosZ = cosZ * camhack_speed
	sinY = sinY * camhack_speed
	posX = posX + sinZ
	posY = posY + cosZ
	posZ = posZ + sinY
	setFixedCameraPosition(posX, posY, posZ, 0.0, 0.0, 0.0)
end
function camhack_left()
	curZ = angZ - 90.0
	radZ = math.rad(curZ)
	radY = math.rad(angY)
	sinZ = math.sin(radZ)
	cosZ = math.cos(radZ)
	sinZ = sinZ * camhack_speed
	cosZ = cosZ * camhack_speed
	posX = posX + sinZ
	posY = posY + cosZ
	setFixedCameraPosition(posX, posY, posZ, 0.0, 0.0, 0.0)
end
function camhack_right()
	curZ = angZ + 90.0
	radZ = math.rad(curZ)
	radY = math.rad(angY)
	sinZ = math.sin(radZ)
	cosZ = math.cos(radZ)
	sinZ = sinZ * camhack_speed
	cosZ = cosZ * camhack_speed
	posX = posX + sinZ
	posY = posY + cosZ
	setFixedCameraPosition(posX, posY, posZ, 0.0, 0.0, 0.0)
end
function camhack_up()
	posZ = posZ + camhack_speed
	setFixedCameraPosition(posX, posY, posZ, 0.0, 0.0, 0.0)
end
function camhack_down()
	posZ = posZ - camhack_speed
	setFixedCameraPosition(posX, posY, posZ, 0.0, 0.0, 0.0)
end
function camhack_left_foward()
    curZ = angZ - 45.0  
    radZ = math.rad(curZ)
    radY = math.rad(angY)
    sinZ = math.sin(radZ)
    cosZ = math.cos(radZ)
    sinY = math.sin(radY)
    cosY = math.cos(radY)
    sinZ = sinZ * camhack_speed
    cosZ = cosZ * camhack_speed
    sinY = sinY * camhack_speed
    posX = posX + sinZ
    posY = posY + cosZ
    posZ = posZ + sinY
    setFixedCameraPosition(posX, posY, posZ, 0.0, 0.0, 0.0)
end
function camhack_left_back()
    curZ = angZ - 135.0  
    radZ = math.rad(curZ)
    radY = math.rad(angY)
    sinZ = math.sin(radZ)
    cosZ = math.cos(radZ)
    sinY = math.sin(radY)
    cosY = math.cos(radY)
    sinZ = sinZ * camhack_speed
    cosZ = cosZ * camhack_speed
    sinY = sinY * camhack_speed
    posX = posX + sinZ
    posY = posY + cosZ
    posZ = posZ + sinY
    setFixedCameraPosition(posX, posY, posZ, 0.0, 0.0, 0.0)
end
function camhack_right_foward()
    curZ = angZ + 45.0  
    radZ = math.rad(curZ)
    radY = math.rad(angY)
    sinZ = math.sin(radZ)
    cosZ = math.cos(radZ)
    sinY = math.sin(radY)
    cosY = math.cos(radY)
    sinZ = sinZ * camhack_speed
    cosZ = cosZ * camhack_speed
    sinY = sinY * camhack_speed
    posX = posX + sinZ
    posY = posY + cosZ
    posZ = posZ + sinY
    setFixedCameraPosition(posX, posY, posZ, 0.0, 0.0, 0.0)
end
function camhack_right_back()
    curZ = angZ + 135.0  
    radZ = math.rad(curZ)
    radY = math.rad(angY)
    sinZ = math.sin(radZ)
    cosZ = math.cos(radZ)
    sinY = math.sin(radY)
    cosY = math.cos(radY)
    sinZ = sinZ * camhack_speed
    cosZ = cosZ * camhack_speed
    sinY = sinY * camhack_speed
    posX = posX + sinZ
    posY = posY + cosZ
    posZ = posZ + sinY
    setFixedCameraPosition(posX, posY, posZ, 0.0, 0.0, 0.0)
end
function camhack_left_up()
    curZ = angZ - 45.0  
    radZ = math.rad(curZ)
    radY = math.rad(angY)
    sinZ = math.sin(radZ)
    cosZ = math.cos(radZ)
    sinY = math.sin(radY)
    cosY = math.cos(radY)
    sinZ = sinZ * camhack_speed
    cosZ = cosZ * camhack_speed
    sinY = sinY * camhack_speed
    posX = posX + sinZ
    posY = posY + cosZ
    posZ = posZ + sinY
	posZ = posZ + camhack_speed
    setFixedCameraPosition(posX, posY, posZ, 0.0, 0.0, 0.0)
end
function camhack_left_down()
    curZ = angZ - 135.0  
    radZ = math.rad(curZ)
    radY = math.rad(angY)
    sinZ = math.sin(radZ)
    cosZ = math.cos(radZ)
    sinY = math.sin(radY)
    cosY = math.cos(radY)
    sinZ = sinZ * camhack_speed
    cosZ = cosZ * camhack_speed
    sinY = sinY * camhack_speed
    posX = posX + sinZ
    posY = posY + cosZ
    posZ = posZ + sinY
	posZ = posZ - camhack_speed
    setFixedCameraPosition(posX, posY, posZ, 0.0, 0.0, 0.0)
end
function camhack_right_up()
    curZ = angZ + 45.0  
    radZ = math.rad(curZ)
    radY = math.rad(angY)
    sinZ = math.sin(radZ)
    cosZ = math.cos(radZ)
    sinY = math.sin(radY)
    cosY = math.cos(radY)
    sinZ = sinZ * camhack_speed
    cosZ = cosZ * camhack_speed
    sinY = sinY * camhack_speed
    posX = posX + sinZ
    posY = posY +cosZ
    posZ = posZ + sinY
	posZ = posZ + camhack_speed
    setFixedCameraPosition(posX, posY, posZ, 0.0, 0.0, 0.0)
end
function camhack_right_down()
    curZ = angZ + 135.0  
    radZ = math.rad(curZ)
    radY = math.rad(angY)
    sinZ = math.sin(radZ)
    cosZ = math.cos(radZ)
    sinY = math.sin(radY)
    cosY = math.cos(radY)
    sinZ = sinZ * camhack_speed
    cosZ = cosZ * camhack_speed
    sinY = sinY * camhack_speed
    posX = posX + sinZ
    posY = posY + cosZ
    posZ = posZ + sinY
	posZ = posZ - camhack_speed
    setFixedCameraPosition(posX, posY, posZ, 0.0, 0.0, 0.0)
end
function camhack_speed_plus()
	camhack_speed = camhack_speed + 0.01
	printStringNow("[CamHack V3] Speed: ".. camhack_speed, 1000)
end
function camhack_speed_minus()
	camhack_speed = camhack_speed - 0.01
	if camhack_speed < 0.01 then
		camhack_speed = 0.01
	end
	printStringNow("[CamHack V3] Speed: " .. camhack_speed, 1000)
end
function camhack_enable_hud()
	displayRadar(true)
	displayHud(true)
end
function camhack_disable_hud()
	displayRadar(false)
	displayHud(false)
end
function camhack_angle_left() 
    local angle = 1 + camhack_speed / 10 
    angZ = (angZ - angle) % 360.0
    setFixedCameraPosition(posX, posY, posZ, 0.0, angY, angZ)
end
function camhack_angle_right()
    local angle = 1 + camhack_speed / 10
    angZ = (angZ + angle) % 360.0
    setFixedCameraPosition(posX, posY, posZ, 0.0, angY, angZ)
end
function handleJoystick(x, y)
    normalizedX = x / 127.0
    normalizedY = y / 127.0

    if normalizedX > 0.5 then
        if normalizedY > 0.5 then
            camhack_right_back()
        elseif normalizedY < -0.5 then
            camhack_right_foward()
            camhack_update()
        else
            camhack_right()
            camhack_update()
        end
    elseif normalizedX < -0.5 then
        if normalizedY > 0.5 then
            camhack_left_back()
        elseif normalizedY < -0.5 then
            camhack_left_foward()
            camhack_update()
        else
            camhack_left()
            camhack_update()
        end
    else
        if normalizedY > 0.5 then
			camhack_back()
			camhack_update() 
        elseif normalizedY < -0.5 then
            camhack_foward()
            camhack_update()
        end
    end
end

function onScriptTerminate(script, quit) 
	if script == thisScript() and not quit then
		if camhack_active then camhack_off() end
	end
end
