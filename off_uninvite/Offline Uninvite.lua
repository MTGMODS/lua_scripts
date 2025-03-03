local sampev = require('samp.events')

local day_afk = 30
local reason_day = 30
local uninvite = false

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
            local nick, days, rank, online = line:match("(.+)%s+(%d+)%s+����.-%[(%d+)%]%s+%[%s+([%d%.]+)%s+���")
            if days and tonumber(days) >= tonumber(day_afk) then
                reason_day = days
                sampSendDialogResponse(dialogid, 1, counter - 1, "")
                return false
            elseif not line:find('��������� ���� � ����') then
                sampAddChatMessage('������ ���� ������� ������� ' .. day_afk .. " ���� �� � ����!", -1)
                uninvite = false
                break
            end
       end 
    end
    if uninvite and text:find("������� ������") and text:find("�������� ���� ������") then
        sampSendDialogResponse(dialogid, 1, 0, '')  
        return false
    end
    if uninvite and text:find("������� �������(.+)����������(.+)������ �� �������") then
        sampSendDialogResponse(dialogid, 1,  0, '������� (' .. reason_day .. ' ���� �� � ����)')
        return false
    end

end

function sampev.onServerMessage(color, text)
    if uninvite and text:find("(.+) ������ (.+) �� �����������. �������%: �������") then
        sampSendChat('/lmenu')
        return false
    end
end