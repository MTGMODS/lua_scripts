local sampev = require('samp.events')

local day_afk
local uninvite = false
local reason_day = 'X'

local players_to_kick = {}
function kick_players()
    lua_thread.create(function ()
        for index, value in ipairs(players_to_kick) do
            reason_day = value.day
            sampSendChat('/uninviteoff ' .. value.nickname)
            printStringNow(index .. '/' .. #players_to_kick, 250)
            wait(250)
        end
        uninvite = false
    end)
end

sampRegisterChatCommand('fcleaner', function (arg)
    if arg:find('(%d+)') then
        day_afk = tonumber(arg)
        uninvite = true
        sampSendChat('/lmenu')
    else
        sampAddChatMessage('����������� /fcleaner [���-�� ���� ���]', -1)
    end
end)

function sampev.onShowDialog(dialogid, style, title, button1, button2, text)
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
        for line in text:gmatch('([^\n\r]+)') do
            counter = counter + 1
            --sampAddChatMessage(line, -1)

            -- {FFFFFF}Alexsander_Martelli 6 ���� ������� ���������[6] [ 0.0 ����� ]
            -- {FFFFFF}Daisuke_Tachibana 5 ���� {90EE90}������� ���������[6] (24 ����) [ 0.2 ����� ]
            -- {FFFFFF}Lina_Samura 0 ���(��) {90EE90}���������� ���������[8] (28 ����) [ 6.0 ����� ]
            -- if line:find('%{90EE90%}') then
            --     nick, days, rank, rank_number = line:match('{FFFFFF}([%w_]+) (%d+) ���� %{90EE90%}([^%[]+)%[(%d+)%]')
            --     print(nick, days, rank, rank_number)
            -- else
            --     nick, days, rank, rank_number = line:match('{FFFFFF}([%w_]+) (%d+) ���� ([^%[]+)%[(%d+)%]')
            --     nick, days, rank, rank_number = line:match('%{FFFFFF%}(.+) (%d+) ���� (.+)%[(%d+)')
            --     print(nick, days, rank, rank_number)
            -- end
            --local nick, days, rank, online = line:match("(.+)%s+(%d+)%s+����.-%[(%d+)%]%s+%[%s+([%d%.]+)%s+���")


            local nick, days = line:match("{FFFFFF}(.+)%s+(%d+) ����")
            if days and tonumber(days) >= tonumber(day_afk) then
                -- reason_day = days
                -- sampAddChatMessage(nick .. ', ' .. days, -1)
                -- sampSendDialogResponse(dialogid, 1, counter - 1, "")
                -- return false
                
                table.insert(players_to_kick, {nickname = nick, day = days})
                printStringNow('find ' .. #players_to_kick, 500)
            elseif line:find('{B0E73A}������') then
                sampSendDialogResponse(dialogid, 1, counter - 1, "")
                return false
            elseif ((not text:find('{B0E73A}������'))) then
                sampAddChatMessage('������ ���� ������� ������� ' .. day_afk .. " ���� �� � ����!", -1)
                sampSendDialogResponse(dialogid, 2, 0, 0)
                kick_players()
                return false
            -- elseif not line:find('��������� ���� � ����') then
            --     sampAddChatMessage('������ ���� ������� ������� ' .. day_afk .. " ���� �� � ����!", -1)
            --     uninvite = false
            --     sampSendDialogResponse(dialogid, 2, 0, 0)
            --     return false
            end
       end 
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

-- function sampev.onServerMessage(color, text)
    -- if uninvite and text:find("(.+) ������ (.+) �� �����������. �������%: �������") then
    --     sampSendChat('/lmenu')
    --     return false
    -- end
-- end