local day_afk
local reason_day
local uninvite = false
local players_to_kick = {}

function kick_players()
    lua_thread.create(function ()
        for index, value in ipairs(players_to_kick) do
            reason_day = value.day
            sampSendChat('/uninviteoff ' .. value.nickname)
            printStringNow(index .. '/' .. #players_to_kick, 2000)
            wait(2000)
        end
        uninvite = false
    end)
end

function main()
    if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(0) end

    sampRegisterChatCommand('fcleaner', function (arg)
        if arg:find('(%d+)') then
            day_afk = tonumber(arg)
            uninvite = true
            sampSendChat('/lmenu')
        else
            sampAddChatMessage('Используйте /fcleaner [кол-во дней афк]', -1)
        end
    end)

end

require('samp.events').onShowDialog = function(dialogid, style, title, button1, button2, text)
    if uninvite and title:find('$') and text:find('Управление членами организации') then
		sampSendDialogResponse(dialogid, 1, 1, 0)
		return false 
	end
    if uninvite and text:find('Игроки онлайн') and text:find("Игроки оффлайн") then
        sampSendDialogResponse(dialogid, 1, 1, 0)
		return false 
    end
    if uninvite and title:find('Увольнение %(оффлайн%)') then
        local counter = -1
        local checker1 = false
        for line in text:gmatch('([^\n\r]+)') do
            counter = counter + 1
            if line:find("{FFFFFF}(.+)%s+(%d+) дней") then
                local nick, days = line:match("{FFFFFF}(.+)%s+(%d+) дней")
                if days and tonumber(days) >= tonumber(day_afk) then
                    table.insert(players_to_kick, {nickname = nick, day = days})
                end            
            elseif line:find('{B0E73A}Вперед') then
                sampSendDialogResponse(dialogid, 1, counter - 1, "")
                return false
            end
        end 
        if #players_to_kick > 0 then
            printStringNow('find ' .. #players_to_kick, 1000)
            sampAddChatMessage('Больше нету игроков которые ' .. day_afk .. " дней не в сети!", -1)
            kick_players()
        else
            sampAddChatMessage('Нету игроков которые ' .. day_afk .. " дней не в сети!", -1)
        end
        sampSendDialogResponse(dialogid, 2, 0, 0)
        return false
    end
    -- if uninvite and text:find("Уволить игрока") and text:find("Изменить ранг игроку") then
    --     sampSendDialogResponse(dialogid, 1, 0, '')  
    --     return false
    -- end
    if uninvite and text:find("Укажите причину(.+)увольнения(.+)игрока из фракции") then
        sampSendDialogResponse(dialogid, 1,  0, 'Неактив (' .. reason_day .. ' дней не в игре)')
        return false
    end
end