script_name('AutoSell Fish & Items')
script_author('MTG MODS')

local se = require "samp.events"

function se.onShowDialog(id, style, title, but_1, but_2, text)
	if string.find(title, "������� ����") then
		-- if string.find(text, ".+\n{%x+}%s%-%s{%x+}���������%s1%s��:%s{%x+}.+\n{%x+}%s%-%s{%x+}�%s���%s�%s�������:%s{%x+}(%d+)%s��%.") then
		-- 	local count = string.match(text, ".+\n{%x+}%s%-%s{%x+}���������%s1%s��:%s{%x+}.+\n{%x+}%s%-%s{%x+}�%s���%s�%s�������:%s{%x+}(%d+)%s��%.")
		-- 	if tonumber(count) > 0 then
		-- 		if tonumber(count) > 100 then
		-- 			count = '100'
		-- 		end
		-- 		sampSendDialogResponse(id, 1, 0, count)
		-- 		return false
		-- 	end
		-- end
		if string.find(text, "����(.+)����(.+)����(.+)����") then
			local index = -1
			local finded_fish = false
			for line in text:gmatch('[^\n]+') do
				if line:find('������� ��� ����') then
					if not line:find('0 ��') then
						sampSendDialogResponse(id, 1, index, 0)
						finded_fish = true
					else
						sampSendDialogResponse(id, 2, index, 0)
						sampAddChatMessage('[AutoSell Fish Items] � ��� ���� ���� ��� �������!', -1)
						finded_fish = true
					end
				else
					index = index + 1
				end
			end
			if finded_fish then
				return false
			end
		end
	end
	if string.find(title, "������� ������ �����") then
		if string.find(text, ".+\n{%x+}%s%-%s{%x+}���������%s1%s��:%s{%x+}.+\n{%x+}%s%-%s{%x+}�%s���%s�%s�������:%s{%x+}(%d+)%s��%.") then
			local count = string.match(text, ".+\n{%x+}%s%-%s{%x+}���������%s1%s��:%s{%x+}.+\n{%x+}%s%-%s{%x+}�%s���%s�%s�������:%s{%x+}(%d+)%s��%.")
			if tonumber(count) > 0 then
				if tonumber(count) > 100 then
					count = '100'
				end
				sampSendDialogResponse(id, 1, 0, count)
				return false
			end
		end
		if string.find(text, "�����(.+)�����(.+)�����(.+)�����") then
			local index = -1
			local finded_artef = false
			for line in text:gmatch('[^\n]+') do
				if line:find('%{ffff00%}') then
					sampSendDialogResponse(id, 1, index, 0)
					finded_artef = true
				else
					index = index + 1
				end
			end
			if finded_artef then
				return false
			else
				sampAddChatMessage('[AutoSell Fish Items] � ��� ���� ������ ����� ��� �������!', -1)
				sampSendDialogResponse(id, 2, index, 0)
				return false
			end
			
		end
	end
	if string.find(title, "������� ���� ����") then
		sampSendDialogResponse(id, 1, 0, 0)
		return false
	end
end