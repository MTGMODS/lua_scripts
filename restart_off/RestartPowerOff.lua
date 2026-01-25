script_name("RestartPowerOff")
script_author("MTG MODS")
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
require "lib.moonloader"
local sampev = require "samp.events"

function main()

    if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(0) end 
	
	sampAddChatMessage('{ff0000}[INFO] {ffffff}Скрипт "RestartPowerOff" загружен и готов к работе! Автор: MTG MODS | Версия: 1.0',-1)
	sampAddChatMessage('{ff0000}[INFO] {ffffff}После тех. рестарта сервера ваш ПК/ноутбук будет выключен! Отменить выклюние: {00ccff}/cancel_off',-1)
	
	sampRegisterChatCommand("cancel_off", function() 
		sampAddChatMessage('{ff0000}[INFO] {ffffff}Скрипт "RestartPowerOff" приостановил свою работу и был выгружен!',-1)
		sampAddChatMessage('{ff0000}[INFO] {ffffff}После тех. рестарта сервера ваш ПК/ноутбук не будет выключатся.',-1)
		thisScript():unload()
	end)
	
	wait(-1)
	
end

function sampev.onServerMessage(color,text)
	
	if color == -1104335361 and text:find("Технический рестарт через 02 минут. Советуем завершить текущую сессию") or text:find("Технический рестарт через 01 минут. Сессия будет завершена принудительно") then
		sampAddChatMessage('{ff0000}[INFO] {ffffff}После тех. рестарта сервера ваш ПК/ноутбук будет выключен! Отменить выклюние: {00ccff}/cancel_off',-1)
	end
	                                       
	if text:find("^Технический рестарт сервера! Сессия завершена принудительно.") then
		os.execute('shutdown /s /t 0')
	end
	
end


