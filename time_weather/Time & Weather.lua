script_name("Time & Weather")
script_description('Time & Weather Changer')
script_author("MTG MODS")
script_version("1.0")

local inicfg = require 'inicfg'
local local_ini = "Time & Weather.ini"
local ini = inicfg.load( {
	settings = {
		my_time = 12,
		my_weather = 1,
		block_time = false,
		block_weather = false,
	}
}, local_ini)

local time = -1
local weather = -1

function main()

	if not isSampLoaded() or not isSampfuncsLoaded() then return end
	while not isSampAvailable() do wait(0) end 

	sampAddChatMessage('{ff0000}[INFO] {ffffff}������ "Time & Weather" �������� � ����� � ������! �����: MTG MODS | ������: ' .. thisScript().version .. ' | ����������� {00ccff}/shelp',-1)

	sampRegisterChatCommand('st', function(arg) 
		if arg ~= nil and tostring(arg):find('%d') and not tostring(arg):find('%D') and tonumber(arg) >= 0 and tonumber(arg) <= 23 then
			ini.settings.my_time = arg
			inicfg.save(ini, local_ini)
		else
			sampAddChatMessage('{ff0000}[Time & Weather]{ffffff} ����� �������� ����� ����������� /st [0-23]', -1)
		end
	end)
	
	sampRegisterChatCommand('bt', function()
		if ini.settings.block_time then
			ini.settings.block_time = false
			sampAddChatMessage('{ff0000}[Time & Weather]{ffffff} ������ ������ ����� �������� ��� �����!', -1)
		else
			ini.settings.block_time = true
			time = -1
			sampAddChatMessage('{ff0000}[Time & Weather]{ffffff} ������ ������ �� ������ �������� ���� �����!', -1)
		end
		inicfg.save(ini, local_ini)
	end)
	
	sampRegisterChatCommand('sw', function(arg) 
		if arg ~= nil and tostring(arg):find('%d') and not tostring(arg):find('%D') and tonumber(arg) >= 0 and tonumber(arg) <= 45 then
			ini.settings.my_weather = arg
			inicfg.save(ini, local_ini)
		else
			sampAddChatMessage('{ff0000}[Time & Weather]{ffffff} ����� �������� ������ ����������� /sw [0-45]', -1)
		end
	end)
	
	sampRegisterChatCommand('bw', function() 
	  	if ini.settings.block_weather then
			ini.settings.block_weather = false
			sampAddChatMessage('{ff0000}[Time & Weather]{ffffff} ������ ������ ����� �������� ��� ������!', -1)
		else
			ini.settings.block_weather = true
			weather = -1
			sampAddChatMessage('{ff0000}[Time & Weather]{ffffff} ������ ������ �� ������ �������� ���� ������!', -1)
		end
		inicfg.save(ini, local_ini)
	end)

	sampRegisterChatCommand('shelp', function() 
		sampShowDialog(999999, "Time & Weather", "���������� �����: /st [0-23]\n��������� ������� �������� �����: /bt\n\n���������� ������: /sw [0-45]\n��������� ������� �������� ������: /bw\n\nDiscord ������ MTG MODS: https://discord.com/invite/qBPEYjfNhv", "�������", '', 0)
 	end)
	
	while true do
		wait(0)
		if getActiveInterior() == 0 or getActiveInterior() == 20 then 
			if weather == -1 then forceWeatherNow(ini.settings.my_weather) end
			if time == -1 then setTimeOfDay(ini.settings.my_time, 0) end
		end
	end
	
end

local sampev = require 'samp.events' -- samp events ��� ������� ������
function sampev.onSetWorldTime(hour)
	if not ini.settings.block_time then
		time = hour
		--sampAddChatMessage('{ff0000}[Time & Weather]{ffffff} ������ ������� ����� �� ' .. hour .. '!', -1)
		--sampAddChatMessage('{ff0000}[Time & Weather]{ffffff} ����� ������ �� ��� �������� �����, ����������� /bt', -1)
	end
end
function sampev.onSetWeather(weatherId)
	if not ini.settings.block_weather then
		weather = weatherId
		--sampAddChatMessage('{ff0000}[Time & Weather]{ffffff} ������ ������� ������ �� ' .. weatherId .. ' ID!', -1)
		--sampAddChatMessage('{ff0000}[Time & Weather]{ffffff} ����� ������ �� ��� �������� ������, ����������� /bw', -1)
	end
end

