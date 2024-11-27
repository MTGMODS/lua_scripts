script_name("{7ef3fa}RestartPowerOff")
script_author("{7ef3fa}MTG MODS")
script_version("1.0.0")
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
require "lib.moonloader"
local sampev = require "samp.events"

function main()

    if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(0) end 
	
	sampAddChatMessage('{ff0000}[INFO] {ffffff}������ "RestartPowerOff" �������� � ����� � ������! �����: MTG MODS | ������: 1.0',-1)
	sampAddChatMessage('{ff0000}[INFO] {ffffff}����� ���. �������� ������� ��� ��/������� ����� ��������! �������� ��������: {00ccff}/cancel_off',-1)
	
	sampRegisterChatCommand("cancel_off", function() 
		sampAddChatMessage('{ff0000}[INFO] {ffffff}������ "RestartPowerOff" ������������ ���� ������ � ��� ��������!',-1)
		sampAddChatMessage('{ff0000}[INFO] {ffffff}����� ���. �������� ������� ��� ��/������� �� ����� ����������.',-1)
		thisScript():unload()
	end)
	
	wait(-1)
	
end

function sampev.onServerMessage(color,text)
	
	if color == -1104335361 and text:find("����������� ������� ����� 02 �����. �������� ��������� ������� ������") or text:find("����������� ������� ����� 01 �����. ������ ����� ��������� �������������") then
		sampAddChatMessage('{ff0000}[INFO] {ffffff}����� ���. �������� ������� ��� ��/������� ����� ��������! �������� ��������: {00ccff}/cancel_off',-1)
	end
	
	if color == -1104335361 and text:find("����������� �������! ������ ��������� �������������") then
		os.execute('shutdown /s /t 0')
	end
	
end


