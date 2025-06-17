local day_afk
local reason_day
local uninvite = false
local players_to_kick = {}

function kick_players()
    lua_thread.create(function ()
        wait(1000)
        for index, value in ipairs(players_to_kick) do
            reason_day = value.day
            sampSendChat('/uninviteoff ' .. value.nickname)
            printStringNow(index .. '/' .. #players_to_kick, 300)
            wait(1000)
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
            sampAddChatMessage('����������� /fcleaner [���-�� ���� ���]', -1)
        end
    end)

end

require('samp.events').onShowDialog = function(dialogid, style, title, button1, button2, text)
    if uninvite and title:find('$') and text:find('���������� ������� �����������') then
		sampSendDialogResponse(dialogid, 1, 1, 0)
		return false 
	end
    if uninvite and text:find('������ ������') and text:find("������ �������") then
        sampSendDialogResponse(dialogid, 1, 1, 0)
		return false 
    end
    if uninvite and title:find('���������� %(�������%)') then
        local counter = -1
        local checker1 = false
        for line in text:gmatch('([^\n\r]+)') do
            counter = counter + 1
            if line:find("{FFFFFF}(.+)%s+(%d+) ����") then
                local nick, days = line:match("{FFFFFF}(.+)%s+(%d+) ����")
                if days and tonumber(days) >= tonumber(day_afk) then
                    table.insert(players_to_kick, {nickname = nick, day = days})
                end            
            elseif line:find('{B0E73A}������') then
                sampSendDialogResponse(dialogid, 1, counter - 1, "")
                return false
            end
        end 
        if #players_to_kick > 0 then
            printStringNow('find ' .. #players_to_kick, 1000)
            sampAddChatMessage('������ ���� ������� ������� ' .. day_afk .. " ���� �� � ����!", -1)
            kick_players()
        else
            sampAddChatMessage('���� ������� ������� ' .. day_afk .. " ���� �� � ����!", -1)
        end
        sampSendDialogResponse(dialogid, 2, 0, 0)
        return false
    end
    -- if uninvite and text:find("������� ������") and text:find("�������� ���� ������") then
    --     sampSendDialogResponse(dialogid, 1, 0, '')  
    --     return false
    -- end
    if uninvite and text:find("������� �������(.+)����������(.+)������ �� �������") then
        sampSendDialogResponse(dialogid, 1,  0, '������� (' .. reason_day .. ' ���� �� � ����)')
        return false
    end
end