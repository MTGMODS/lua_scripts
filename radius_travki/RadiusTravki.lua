local active = false

function main()
	
	while not isSampAvailable() do wait(0) end
	
	sampRegisterChatCommand('travka',function() active = not active sampAddChatMessage('[Travka] ' .. (active and 'Работает!' or 'Отключено!'), -1) end)
	
	while true do wait(0)
		if active then

			for index, v in pairs(getAllObjects()) do
                if getObjectModel(v) == 874 and isObjectOnScreen(v) and not isPauseMenuActive() then
                    local _, x, y, z = getObjectCoordinates(v)
					local myPos = {getCharCoordinates(1)}
					drawCircleIn3d(x, y, z, 3, 36, 1.5, getDistanceBetweenCoords3d(x,y,0,myPos[1],myPos[2],0) > 3 and 0xFFFFFFFF or 0xFFFF0000)
                    drawCircleIn3d(x, y, z, 0.1, 36, 1.5, getDistanceBetweenCoords3d(x,y,0,myPos[1],myPos[2],0) > 3 and 0xFFFFFFFF or 0xFFFF0000)
				end
			end

	    end
	end
end

drawCircleIn3d = function(x, y, z, radius, polygons,width,color)
    local step = math.floor(360 / (polygons or 36))
    local sX_old, sY_old
    for angle = 0, 360, step do
        local lX = radius * math.cos(math.rad(angle)) + x
        local lY = radius * math.sin(math.rad(angle)) + y
        local lZ = z
        local _, sX, sY, sZ, _, _ = convert3DCoordsToScreenEx(lX, lY, lZ)
        if sZ > 1 then
            if sX_old and sY_old then
                renderDrawLine(sX, sY, sX_old, sY_old, width, color)
            end
            sX_old, sY_old = sX, sY
        end
    end
end
