script_name("AutoDoor")
script_author("MTG MODS")
script_version("5.0")
script_description('Script for Auto Open doors and other objects...')

require "lib.moonloader"

local active = false
local use_autodoor = true

function isMonetLoader() 
	return MONET_VERSION ~= nil 
end

function main()

    if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(0) end

	sampAddChatMessage('{ff0000}[INFO] {ffffff}������ "AutoDoor" �������� � ����� � ������! �����: MTG MODS | ������: ' .. thisScript().version .. ' | �����������: {00ccff}/door',-1)
	
    sampRegisterChatCommand('door', function ()
        use_autodoor = not use_autodoor
        sampAddChatMessage('{ff0000}[INFO] {ffffff}������ "AutoDoor" ' .. (use_autodoor and '����������� � ����� ��������� �����/���������/���! ��������������: {00ccff}/door' or '������������� � �� ����� ��������� �����/���������/���! ������������: {00ccff}/door'),-1)
    end)

	while true do wait(333) 
		if (use_autodoor and ((isMonetLoader()) or (not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive() and not sampIsCursorActive()))) then
            pcall(AutoDoor) 
		end
	end

end

function AutoDoor()
    for key, hObj in pairs(getAllObjects()) do
        if doesObjectExist(hObj) then
            local objModel = getObjectModel(hObj)
            local res, ox, oy, oz = getObjectCoordinates(hObj)
			local objHeading = getObjectHeading(hObj)
			local px, py, pz = getCharCoordinates(PLAYER_PED)
            local distance = getDistanceBetweenCoords3d(px, py, pz, ox, oy, oz)
            -- �����
            if objModel == 1495 or objModel == 3089 or objModel == 1557 or objModel == 1808 or objModel == 19857 or objModel == 19302 or objModel == 2634 or objModel == 19303 then
                if (objHeading > 179 and objHeading < 181) or (objHeading > 89 and objHeading < 91) or (objHeading > -1 and objHeading < 1) or (objHeading > 269 and objHeading < 271) then
					if distance <= 2 then
                        active = true
                        sampSendChat("/opengate")
                        return
					end
                end
            -- ��������� � ������
            elseif objModel == 968 or objModel == 975 or objModel == 1374 or objModel == 19912 or objModel == 988 or objModel == 19313 or objModel == 11327 or objModel == 19313 or objModel == 980 then
				if distance < (isCharInAnyCar(PLAYER_PED) and 12 or 5) then
                    active = true
                    sampSendChat("/opengate")
                    return
                end
            end
        end
    end
end

require("samp.events").onServerMessage = function(color,text)
	if (text:find("� ��� ��� ������ �� ������� ���������") or text:find("� ��� ��� ������ �� ����� ���������!") or  text:find("� ��� ��� ������ �� ���� �����!") or text:find("� ��� ��� ������ �� ������ �����")) then
        show_arz_notify('error', 'AutoDoor', '� ��� ��� �������/����� ��� ����� �������!', 1500)
        return false
	end
    if text:find("�� �����") and active then
        active = false
        return false
    end
end

function show_arz_notify(type, title, text, time)
    if MONET_VERSION ~= nil then
        if type == 'info' then
            type = 3
        elseif type == 'error' then
            type = 2
        elseif type == 'success' then
            type = 1
        end
        local bs = raknetNewBitStream()
        raknetBitStreamWriteInt8(bs, 62)
        raknetBitStreamWriteInt8(bs, 6)
        raknetBitStreamWriteBool(bs, true)
        raknetEmulPacketReceiveBitStream(220, bs)
        raknetDeleteBitStream(bs)
        local json = encodeJson({
            styleInt = type,
            title = title,
            text = text,
            duration = time
        })
        local interfaceid = 6
        local subid = 0
        local bs = raknetNewBitStream()
        raknetBitStreamWriteInt8(bs, 84)
        raknetBitStreamWriteInt8(bs, interfaceid)
        raknetBitStreamWriteInt8(bs, subid)
        raknetBitStreamWriteInt32(bs, #json)
        raknetBitStreamWriteString(bs, json)
        raknetEmulPacketReceiveBitStream(220, bs)
        raknetDeleteBitStream(bs)
    else
        local str = ('window.executeEvent(\'event.notify.initialize\', \'["%s", "%s", "%s", "%s"]\');'):format(type, title, text, time)
        local bs = raknetNewBitStream()
        raknetBitStreamWriteInt8(bs, 17)
        raknetBitStreamWriteInt32(bs, 0)
        raknetBitStreamWriteInt32(bs, #str)
        raknetBitStreamWriteString(bs, str)
        raknetEmulPacketReceiveBitStream(220, bs)
        raknetDeleteBitStream(bs)
    end
end