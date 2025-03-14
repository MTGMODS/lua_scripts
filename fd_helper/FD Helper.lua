---@diagnostic disable: undefined-global, need-check-nil, lowercase-global, cast-local-type, unused-local

script_name("FD Helper")
script_description('This is a Cross-platform Lua script helper for Arizona RP players who work in the Ministry of')
script_author("MTG MODS")
script_version("1.3")

require('lib.moonloader')
require('encoding').default = 'CP1251'
local u8 = require('encoding').UTF8
local ffi = require('ffi')
local sampev = require('samp.events')

print('[FD Helper] ������ ���������������. ������: ' .. thisScript().version)
-------------------------------------------- JSON SETTINGS ---------------------------------------------
local configDirectory = getWorkingDirectory():gsub('\\','/') .. "/FD Helper"
local path_helper = getWorkingDirectory():gsub('\\','/') .. "/FD Helper.lua"
local path_settings = configDirectory .. "/Settings.json"
local settings = {}
local default_settings = {
	general = {
		version = thisScript().version,
		accent_enable = true,
		rp_chat = true,
        rp_gun = true,
		auto_update_members = true,
		auto_notify_payday = true,
		auto_uval = false,
		auto_doklad_1 = true,
		auto_doklad_2 = true,
		auto_doklad_3 = true,
		auto_doklad_4 = true,
		auto_doklad_5 = true,
		auto_doklad_6 = true,
		auto_doklad_7 = true,
		moonmonet_theme_enable = true,
		moonmonet_theme_color = 16744192,
		mobile_stop_button = true,
		use_binds = true,
		use_info_menu = true,
		bind_mainmenu = '[113]',
		bind_leader_fastmenu = '[71]',
		bind_command_stop = '[123]',
		custom_dpi = 1.0,
		autofind_dpi = false,
	},
	player_info = {
		name_surname = '',
		accent = '[����������� ������]:',
		fraction = '����������',
		fraction_tag = '����������',
		fraction_rank = '����������',
		fraction_rank_number = 0,
		sex = '����������',
	},
	deportament = {
		dep_fm = '-',
		dep_tag1 = '',
		dep_tag2 = '[����]',
		dep_tags = {
			"[����]",
			"[����������]",
			"[���������]",
			"[���������]",
			'skip',
			"[��]",
			"[���.���.]",
			"[����]",
			"[����]",
			"[����]",
			"[����]",
			"[����]",
			"[���]",
			'skip',
			"[��]",
			"[���.�������]",
			"[���]",
			"[���]",
			"[���]",
			'skip',
			"[��]",
			"[���]",
			"[���.�����.]",
			"[����]",
			"[����]",
			"[����]",
			"[���]",
			"[��]",
			'skip',
			"[��]",
			"[��]",
			"[��]",
			"[���-��]",
			"[����������]",
			"[��������]",
			'skip',
			"[���]",
			"[��� ��]",
			"[��� ��]",
			"[��� ��]",
		},
		dep_tags_en = {
			"[ALL]",
			'skip',
			"[MJ]",
			"[Min.Just.]",
			"[LSPD]",
			"[SFPD]",
			"[LVPD]",
			"[RCSD]",
			"[SWAT]",
			"[FBI]",
			'skip',
			"[MD]",
			"[Mid.Def.]",
			"[LSa]",
			"[SFa]",
			"[MSP]",
			'skip',
			"[MH]",
			"[MHF]",
			"[Min.Healt]",
			"[LSMC]",
			"[SFMC]",
			"[LVMC]",
			"[JMC]",
			"[FD]",
			'skip',
			"[GOV]",
			"[Prosecutor]",
			"[LC]",
			"[INS]",
			'skip',
			"[CNN]",
			"[CNN LS]",
			"[CNN LV]",
			"[CNN SF]",
		},
		dep_tags_custom = {},
		dep_fms = {
			'-',
			'- �.�. -',
		},
		dep_fms_custom = {},
	},
}
function load_settings()
    if not doesDirectoryExist(configDirectory) then
        createDirectory(configDirectory)
    end
    if not doesFileExist(path_settings) then
        settings = default_settings
		print('[FD Helper] ���� � ����������� �� ������, ��������� ����������� ���������!')
    else
        local file = io.open(path_settings, 'r')
        if file then
            local contents = file:read('*a')
            file:close()
			if #contents == 0 then
				settings = default_settings
				print('[FD Helper] �� ������� ������� ���� � �����������, ��������� ����������� ���������!')
			else
				local result, loaded = pcall(decodeJson, contents)
				if result then
					settings = loaded
					-- for category, _ in pairs(default_settings) do
					-- 	if settings[category] == nil then
					-- 		settings[category] = {}
					-- 	end
					-- 	for key, value in pairs(default_settings[category]) do
					-- 		if settings[category][key] == nil then
					-- 			settings[category][key] = value
					-- 		end
					-- 	end
					-- end
					if settings.general.version ~= thisScript().version then
						print('[FD Helper] ����� ������, ����� ��������!')
						settings = default_settings
						save_settings()
						reload_script = true
					else
						print('[FD Helper] ��������� ������� ���������!')
					end
				else
					print('[FD Helper] �� ������� ������� ���� � �����������, ��������� ����������� ���������!')
				end
			end
        else
            settings = default_settings
			print('[FD Helper] �� ������� ������� ���� � �����������, ��������� ����������� ���������!')
        end
    end
end
function save_settings()
    local file, errstr = io.open(path_settings, 'w')
    if file then
        local result, encoded = pcall(encodeJson, settings)
        file:write(result and encoded or "")
        file:close()
		print('[FD Helper] ��������� ���������!')
        return result
    else
        print('[FD Helper] �� ������� ��������� ��������� �������, ������: ', errstr)
        return false
    end
end
load_settings()
-------------------------------------------- JSON MY NOTES ---------------------------------------------
local notes = {
	note = {
		{ note_name = '��������', note_text = '������ ���� �������� ����� ���� ������, ��� �������:&- ���� � ��� ���� ����� (���/�����) �� � ��� ����� -20 ��������� ��&- ���� � ��� ���� ������� �� � ��� ����� -20 ��������� ��&- ��-�� ����� ��������� (�� ��������) � ��� ����� -10 ��������� ��&&��� �������� ���� ��������:&- �������� � ���� ����� � ������ ����� ����� +7 ��������� �� &( �� 20 ������� ��� ���� ����� Martelli )&- �������� \"������� �����\" ����� ����� +15 ��������� ��&- ������ ��������� �� \"�� �������\" ����� ����� �� +25 ��������� ��&- ����������� �� ���� ������'},
	}
}
local path_notes = configDirectory .. "/Notes.json"
function load_notes()
	if doesFileExist(path_notes) then
		local file, errstr = io.open(path_notes, 'r')
        if file then
            local contents = file:read('*a')
            file:close()
			if #contents == 0 then
				print('[FD Helper] �� ������� ������� ���� � ���������!')
				print('[FD Helper] �������: ���� ���� ������')
			else
				local result, loaded = pcall(decodeJson, contents)
				if result then
					notes = loaded
					print('[FD Helper] ������� ����������������!')
				else
					print('[FD Helper] �� ������� ������� ���� � ���������!')
					print('[FD Helper] �������: �� ������� ������������ json (������ � �����)')
				end
			end
        else
			print('[FD Helper] �� ������� ������� ���� � ���������!')
			print('[FD Helper] �������: ')
        end
	else
		print('[FD Helper] �� ������� ������� ���� � ���������!')
		print('[FD Helper] �������: ����� ����� ���� � ����� '..configDirectory)
	end
end
function save_notes()
    local file, errstr = io.open(path_notes, 'w')
    if file then
        local result, encoded = pcall(encodeJson, notes)
        file:write(result and encoded or "")
        file:close()
		print('[FD Helper] ������� ���������!')
        return result
    else
        print('[FD Helper] �� ������� ��������� �������, ������: ', errstr)
        return false
    end
end
load_notes()
-------------------------------------------- JSON COMMANDS ---------------------------------------------
local commands = {
	commands = {
		{ cmd = 'zd' , description = '���������� ������' , text = '����������� {get_ru_nick({arg_id})}&� {my_ru_nick} - {fraction_rank} {fraction_tag}&��� � ���� ��� ������?', arg = '{arg_id}' , enable = true , waiting = '1.500', bind = "{}" },
		{ cmd = 'siren' , description = '���/���� ������� � �/�' , text = '{switchCarSiren}', arg = '' , enable = true , waiting = '1.500', bind = "{}" },
        { cmd = 'cure' , description = '������� ������ �� ������' ,  text = '/me ����������� ��� ���������, � ����������� ��� ����� �� ������ �������&/cure {arg_id}&/do ����� �����������.&/me �������� ������ �������� �������� ������ ������, ����� �� ������� �������� �����&/do ������ ��������� ����� ������ �������� �������� ������.&/do ������� ������ � ��������.&/todo �������*��������' , arg = '{arg_id}' , enable = true , waiting = '1.500' , bind = "{}"  },
		{ cmd = 'time' , description = '���������� �����' ,  text = '/me ��������{sex} �� ���� ���� � ����������� MTG MODS � ���������{sex} �����&/time&/do �� ����� ����� ����� {get_time}.' , arg = '' , enable = true, waiting = '1.500' , bind = "{}"  },
	},
	commands_manage = {
		{ cmd = 'book' , description = '������ ������ �������� �����' , text = '����������� � ��� ���� �������� �����, �� �� �����������!&������ � ��� ����� �, ��� �� ����� ������ �����, �������...&/me ������ �� ������ ������� ����� �������� ������ � ������ �� ��� ������ {fraction_tag}&/todo ������*��������� �������� ����� ������ ��������&/givewbook {arg_id} 100&/n {get_nick({arg_id})}, ������� ����������� � /offer ����� �������� �������� �����!' , arg = '{arg_id}', enable = true, waiting = '1.500' , bind = "{}"  },
		{ cmd = 'inv' , description = '�������� ������ � �������' , text = '/do � ������� ���� ������ � ������� �� ����������.&/me ������ �� ������� ���� ���� �� ������ ������ �� ����������&/todo ��������, ��� ���� �� ����� ����������*��������� ���� �������� ��������&/invite {arg_id}&/n {get_ru_nick({arg_id})} , ������� ����������� � /offer ����� �������� ������!' , arg = '{arg_id}', enable = true, waiting = '1.500'  , bind = "{}"  },
		{ cmd = 'rp' , description = '������ ���������� /fractionrp' , text = '/fractionrp {arg_id}' , arg = '{arg_id}', enable = true, waiting = '1.500' , bind = "{}"  },
		{ cmd = 'gr' , description = '���������/��������� c���������' , text = '{show_rank_menu}&/me ������ �� ������� ���� ������� � ������� � ���� ������ {fraction_tag}&/me �������� ���������� � ���������� {get_ru_nick({arg_id})} � ���� ������ {fraction_tag}&/me ������� � ���� ������ � ������� ������� ������� � ������&/giverank {arg_id} {get_rank}&/r ��������� {get_ru_nick({arg_id})} ������� ����� ���������!' , arg = '{arg_id}', enable = true, waiting = '1.500', bind = "{}"   },
		{ cmd = 'cjob' , description = '���������� ���������� ����������' , text = '/checkjobprogress {arg_id}' , arg = '{arg_id}', enable = true, waiting = '1.500' , bind = "{}"   },	
		{ cmd = 'fmutes' , description = '������ ��� ���������� (10 min)' , text = '/fmutes {arg_id} �.�.&/r ��������� {get_ru_nick({arg_id})} ������� ����� ������������ ����� �� 10 �����!' , arg = '{arg_id}', enable = true, waiting = '1.500' , bind = "{}"   },
		{ cmd = 'funmute' , description = '����� ��� ����������' , text = '/funmute {arg_id}&/r ��������� {get_ru_nick({arg_id})} ������ ����� ������������ ������!' , arg = '{arg_id}', enable = true, waiting = '1.500' , bind = "{}"   },
		{ cmd = 'vig' , description = '������ �������� c���������' , text = '/me ������ �� ������� ���� ������� � ������� � ���� ������ {fraction_tag}&/me �������� ���������� � ���������� {get_ru_nick({arg_id})} � ���� ������ {fraction_tag}&/me ������� � ���� ������ � ������� ������� ������� � ������&/fwarn {arg_id} {arg2}&/r ���������� {get_ru_nick({arg_id})} ����� �������! �������: {arg2}' , arg = '{arg_id} {arg2}', enable = true, waiting = '1.500'  , bind = "{}"  },
		{ cmd = 'unvig' , description = '������ �������� c���������' , text = '/me ������ �� ������� ���� ������� � ������� � ���� ������ {fraction_tag}&/me �������� ���������� � ���������� {get_ru_nick({arg_id})} � ���� ������ {fraction_tag}&/me ������� � ���� ������ � ������� ������� ������� � ������&/unfwarn {arg_id}&/r ���������� {get_ru_nick({arg_id})} ��� ���� �������!' , arg = '{arg_id}', enable = true, waiting = '1.500' , bind = "{}"   },
		{ cmd = 'unv' , description = '���������� ������ �� �������' , text = '/me ������ �� ������� ���� ������� � ������� � ���� ������ {fraction_tag}&/me �������� ���������� � ���������� {get_ru_nick({arg_id})} � ���� ������ {fraction_tag}&/me ������� � ���� ������ � ������� ���� ������� ������� � ������&/uninvite {arg_id} {arg2}&/r ��������� {get_ru_nick({arg_id})} ��� ������ �� �������: {arg2}' , arg = '{arg_id} {arg2}', enable = true, waiting = '1.500' , bind = "{}"   },
		{ cmd = 'point' , description = '���������� ����� ��� �����������' , text = '/r ������ ������������ �� ���, ��������� ��� ����������...&/point' , arg = '', enable = true, waiting = '1.500' , bind = "{}"  },
		{ cmd = 'govka' , description = '������������� �� ����.�����' , text = '/d [{fraction_tag}] - [����]: ������� ��������������� �����, ������� �� ����������!&/gov [{fraction_tag}]: ������� ������� �����, ��������� ������ ������ �����!&/gov [{fraction_tag}]: ������ �������� ������������� � ����������� {fraction}}&/gov [{fraction_tag}]: ��� ���������� ��� ����� ����� ���������, �����, � �������� � ��� � ����.&/d [{fraction_tag}] - [����]: ����������  ��������������� �����, ������� ��� �� ����������.' , arg = '', enable = true, waiting = '1.300', bind = "{}"  },
	}
}
local path_commands = configDirectory .. "/Commands.json"
function load_commands()
	if doesFileExist(path_commands) then
		local file, errstr = io.open(path_commands, 'r')
        if file then
            local contents = file:read('*a')
            file:close()
			if #contents == 0 then
				print('[FD Helper] �� ������� ������� ���� � ���������!')
				print('[FD Helper] �������: ���� ���� ������')
			else
				local result, loaded = pcall(decodeJson, contents)
				if result then
					if tostring(settings.general.version) ~= tostring(thisScript().version) then 
						print('[FD Helper] ���������� ���� ������, ������ �������� ����� �������')
						local temp_commands = loaded
						for category, _ in pairs(commands) do
							if temp_commands[category] == nil then
								temp_commands[category] = {}
							end
							for key, value in pairs(commands[category]) do
								if temp_commands[category][key] == nil then
									temp_commands[category][key] = value
									print('[FD Helper] �������� ������� /' .. value.cmd)
								end
							end
						end
						save_commands()
						thisScript():reload()
					else
						-- ��������� �������� �� .bind
						for _, command in pairs(loaded.commands) do
							if not command.bind then
								print('[FD Helper] �������� ������� /' .. command.cmd .. ' (��������� ������)')
								command.bind = "{}"
							end
						end
						for _, command in pairs(loaded.commands_manage) do
							if not command.bind then
								print('[FD Helper] �������� ������� /' .. command.cmd .. ' (��������� ������)')
								command.bind = "{}"
							end
						end
						commands = loaded
						save_commands()
					end
					print('[FD Helper] ��� ������� ���������������!')
					
				else
					print('[FD Helper] �� ������� ������� ���� � ���������!')
					print('[FD Helper] �������: �� ������� ������������ json (������ � �����)')
				end
			end
        else
			print('[FD Helper] �� ������� ������� ���� � ���������!')
			print('[FD Helper] �������: ', errstr)
        end
	else
		print('[FD Helper] �� ������� ������� ���� � ���������!')
		print('[FD Helper] �������: ����� ����� ���� � ����� '..configDirectory)
		print('[FD Helper] ������������� ����������� ������...')
		save_commands()
		load_commands()
	end
end
function save_commands()
    local file, errstr = io.open(path_commands, 'w')
    if file then
        local result, encoded = pcall(encodeJson, commands)
        file:write(result and encoded or "")
        file:close()
		print('[FD Helper] ���� ������� ���������!')
        return result
    else
        print('[FD Helper] �� ������� ��������� ������� �������, ������: ', errstr)
        return false
    end
end
load_commands()
------------------------------------------- MonetLoader --------------------------------------------------
function isMonetLoader() return MONET_VERSION ~= nil end
if isMonetLoader() then
	gta = ffi.load('GTASA') 
	ffi.cdef[[ void _Z12AND_OpenLinkPKc(const char* link); ]] -- ������� ��� �������� ������
end
if not settings.general.autofind_dpi then
	print('[FD Helper] ���������� ����-������� �������...')
	if isMonetLoader() then
		settings.general.custom_dpi = MONET_DPI_SCALE
	else
		local base_width = 1366
		local base_height = 768
		local current_width, current_height = getScreenResolution()
		local width_scale = current_width / base_width
		local height_scale = current_height / base_height
		settings.general.custom_dpi = (width_scale + height_scale) / 2
	end
	settings.general.autofind_dpi = true
	print('[FD Helper] ����������� ��������: ' .. settings.general.custom_dpi)
	save_settings()
end
---------------------------------------------- Mimgui -----------------------------------------------------
local imgui = require('mimgui')
local fa = require('fAwesome6_solid')
local sizeX, sizeY = getScreenResolution()

local MainWindow = imgui.new.bool()
local checkboxone = imgui.new.bool(false)
local checkbox_accent_enable = imgui.new.bool(settings.general.accent_enable or true)
local checkbox_update_members = imgui.new.bool(settings.general.auto_update_members or true)
local checkbox_notify_payday = imgui.new.bool(settings.general.auto_notify_payday or true)
local checkbox_auto_doklad_1 = imgui.new.bool(settings.general.auto_doklad_1 or true)
local checkbox_auto_doklad_2 = imgui.new.bool(settings.general.auto_doklad_2 or true)
local checkbox_auto_doklad_3 = imgui.new.bool(settings.general.auto_doklad_3 or true)
local checkbox_auto_doklad_4 = imgui.new.bool(settings.general.auto_doklad_4 or true)
local checkbox_auto_doklad_5 = imgui.new.bool(settings.general.auto_doklad_5 or true)
local checkbox_auto_doklad_6 = imgui.new.bool(settings.general.auto_doklad_6 or true)
local checkbox_auto_doklad_7 = imgui.new.bool(settings.general.auto_doklad_7 or true)
local checkbox_notify_payday = imgui.new.bool(settings.general.auto_notify_payday or true)


local input_accent = imgui.new.char[256](u8(settings.player_info.accent))
local input_name_surname = imgui.new.char[256](u8(settings.player_info.name_surname))
local input_fraction_tag = imgui.new.char[256](u8(settings.player_info.fraction_tag))
local theme = imgui.new.int(0)
slider_dpi = imgui.new.float(tonumber(settings.general.custom_dpi) or 1)

local DeportamentWindow = imgui.new.bool()
local input_dep_fm = imgui.new.char[32](u8(settings.deportament.dep_fm))
local input_dep_text = imgui.new.char[256]()
local input_dep_tag1 = imgui.new.char[32](u8(settings.deportament.dep_tag1))
local input_dep_tag2 = imgui.new.char[32](u8(settings.deportament.dep_tag2))
local input_dep_new_tag = imgui.new.char[32]()

local MembersWindow = imgui.new.bool()
local members = {}
local members_new = {}
local members_check = false
local members_fraction = ''
local update_members_check = false

local GiveRankMenu = imgui.new.bool()
local giverank = imgui.new.int(5)

local SobesMenu = imgui.new.bool()
local CommandStopWindow = imgui.new.bool()
local CommandPauseWindow = imgui.new.bool()
local LeaderFastMenu = imgui.new.bool()

local NoteWindow = imgui.new.bool()
local show_note_name = nil
local show_note_text = nil

local InformationWindow = imgui.new.bool()

local BinderWindow = imgui.new.bool()
local waiting_slider = imgui.new.float(0)
local ComboTags = imgui.new.int()
local item_list = {u8'��� ����������', u8'{arg} - ��������� ����� ��������', u8'{arg_id} - ��������� ������ �������� ID ������', u8'{arg_id} {arg2} - ��������� 2 ���������: ID ������ � ����� ��������', u8'{arg_id} {arg2} {arg3} - ��������� 3 ���������: ID ������, ���� �����, � ����� ��������'}
local ImItems = imgui.new['const char*'][#item_list](item_list)
local change_waiting = nil
local change_cmd_bool = false
local change_cmd = nil
local change_text = nil
local change_arg = nil
local change_bind = nil
local binder_create_command_9_10 = false
local tagReplacements = {
	my_id = function() return select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)) end,
    my_nick = function() return sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))) end,
    my_rp_nick = function() return sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))):gsub('_',' ') end,
    my_doklad_nick = function() 
		local nick
		if isMonetLoader() then
			nick = ReverseTranslateNick(settings.player_info.name_surname)
		else
			nick = sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)))
		end
		if nick:find('(.+)%_(.+)') then
			local name, surname = nick:match('(.+)%_(.+)')
			return name:sub(1, 1)  .. '.' .. surname
		else
			return nick
		end
    end,
	my_ru_nick = function() return TranslateNick(settings.player_info.name_surname) end,
	fraction_rank_number = function() return settings.player_info.fraction_rank_number end,
	fraction_rank = function() return settings.player_info.fraction_rank end,
	fraction_tag = function() return settings.player_info.fraction_tag end,
	fraction = function() return settings.player_info.fraction end,
	sex = function() 
		if settings.player_info.sex == '�������' then
			local temp = '�'
			return temp
		else
			return ''
		end
	end,
	get_time = function ()
		return os.date("%H:%M:%S")
	end,
	get_rank = function ()
		return giverank[0]
	end,
	get_city = function ()
		local city = {
			[0] = "��� ������",
			[1] = "��� ������",
			[2] = "��� ������",
			[3] = "��� ��������"
		}
		return city[getCityPlayerIsIn(PLAYER_PED)]
	end,
	switchCarSiren = function ()
		if isCharInAnyCar(PLAYER_PED) then
			local car = storeCarCharIsInNoSave(PLAYER_PED)
			if getDriverOfCar(car) == PLAYER_PED then
				switchCarSiren(car, not isCarSirenOn(car))
				return '/me ' .. ( isCarSirenOn(car) and '��������' or '���������') .. ' ������� � ���� ������������ ��������'
			else
				sampAddChatMessage('[FD Helper] {ffffff}�� �� �� ����!', 0x009EFF)
				return (isCarSirenOn(car) and '�������' or '������') .. ' �������!'
			end
		else
			sampAddChatMessage('[FD Helper] {ffffff}�� �� � ����������!', 0x009EFF)
			return "���"
		end
	end
}
local binder_tags_text = [[
{my_id} - ��� ID
{my_nick} - ��� ������� 
{my_rp_nick} - ��� ������� ��� _
{my_ru_nick} - ���� ��� � �������
{my_doklad_nick} - ������ ����� ������ ����� � �������

{fraction} - ���� �������
{fraction_rank} - ���� ����������� ���������
{fraction_tag} - ��� ����� �������

{sex} - ��������� ����� "�" ���� � ������� ������ ������� ���

{get_time} - �������� ������� �����
{get_city} - �������� ������� �����
{get_nick({arg_id})} - �������� ������� �� ��������� ID ������
{get_rp_nick({arg_id})} - �������� ������� ��� ������� _ �� ��������� ID ������
{get_ru_nick({arg_id})} - �������� ������� �� �������� �� ��������� ID ������ 

{pause} - ��������� ��������� ������� �� ����� � �������]]

-------------------------------------------- MoonMonet ----------------------------------------------------

local monet_no_errors, moon_monet = pcall(require, 'MoonMonet') -- ��������� ���������� ����������

local message_color = 0x009EFF
local message_color_hex = '{009EFF}'

if settings.general.moonmonet_theme_enable and monet_no_errors then
	function rgbToHex(rgb)
		local r = bit.band(bit.rshift(rgb, 16), 0xFF)
		local g = bit.band(bit.rshift(rgb, 8), 0xFF)
		local b = bit.band(rgb, 0xFF)
		local hex = string.format("%02X%02X%02X", r, g, b)
		return hex
	end
	message_color = settings.general.moonmonet_theme_color
	message_color_hex = '{' ..  rgbToHex(settings.general.moonmonet_theme_color) .. '}'
   
	theme[0] = 1
else
	theme[0] = 0
end
local tmp = imgui.ColorConvertU32ToFloat4(settings.general.moonmonet_theme_color)
local mmcolor = imgui.new.float[3](tmp.z, tmp.y, tmp.x)

------------------------------------------- Mimgui Hotkey  -----------------------------------------------------
local hotkeys = {}
if not isMonetLoader() then
	hotkey_no_errors, hotkey = pcall(require, 'mimgui_hotkeys')
	if hotkey_no_errors then
		hotkey.Text.NoKey = u8'< click and select keys >'
		hotkey.Text.WaitForKey = u8'< wait keys >'
		MainMenuHotKey = hotkey.RegisterHotKey('Open MainMenu', false, decodeJson(settings.general.bind_mainmenu), function()
			if settings.general.use_binds then 
				if not MainWindow[0] then
					MainWindow[0] = true
				end
			end
		end)
		
		LeaderFastMenuHotKey = hotkey.RegisterHotKey('Open LeaderFastMenu', false, decodeJson(settings.general.bind_leader_fastmenu), function() 
			if settings.general.use_binds then 
				if tonumber(settings.player_info.fraction_rank_number) >= 9 then 
					local valid, ped = getCharPlayerIsTargeting(PLAYER_HANDLE)
					if valid and doesCharExist(ped) then
						local result, id = sampGetPlayerIdByCharHandle(ped)
						if result and id ~= -1 then
							show_leader_fast_menu(id)
						end
					end
				end
			end
		end)
		CommandStopHotKey = hotkey.RegisterHotKey('Stop Command', false, decodeJson(settings.general.bind_command_stop), function() 
			if settings.general.use_binds then 
				sampProcessChatInput('/stop')
			end
		end)

		function getNameKeysFrom(keys)
			local keys = decodeJson(keys)
			local keysStr = {}
			for _, keyId in ipairs(keys) do
				local keyName = require('vkeys').id_to_name(keyId) or ''
				table.insert(keysStr, keyName)
			end
			return tostring(table.concat(keysStr, ' + '))
		end

		function loadHotkeys()
			for _, command in ipairs(commands.commands) do
				updateHotkeyForCommand(command)
			end
			for _, command in ipairs(commands.commands_manage) do
				updateHotkeyForCommand(command)
			end
		end
		
		function updateHotkeyForCommand(command)
			local hotkeyName = command.cmd .. "HotKey"
			if hotkeys[hotkeyName] then
				hotkey.RemoveHotKey(hotkeyName)
			end
			if command.arg == '' and command.bind ~= nil and command.bind ~= '{}' and command.bind ~= '[]' then
				hotkeys[hotkeyName] = hotkey.RegisterHotKey(hotkeyName, false, decodeJson(command.bind), function()
					if sampIsChatInputActive() or sampIsDialogActive() or isSampfuncsConsoleActive() then
					
					else
						sampProcessChatInput('/' .. command.cmd)
					end
				end)
				print('[FD Helper] ������ ������ ��� ������� /' .. command.cmd .. ' �� ������� ' .. getNameKeysFrom(command.bind))
				--sampAddChatMessage('[FD Helper] {ffffff}������ ������ ��� ������� ' .. message_color_hex .. '/' .. command.cmd .. ' {ffffff}�� ������� '  .. message_color_hex .. getNameKeysFrom(command.bind), message_color)
			end
		end

		addEventHandler('onWindowMessage', function(msg, key, lparam)
			if msg == 641 or msg == 642 or lparam == -1073741809 then  hotkey.ActiveKeys = {} end
			if msg == 0x0005 then hotkey.ActiveKeys = {} end
		end)
	end
end
------------------------------------------------- Other --------------------------------------------------------
local PlayerID = nil
local player_id = nil
local check_stats = false
local anti_flood_auto_uval = false
local spawncar_bool = false

local isActiveCommand = false

local debug_mode = false

local command_stop = false
local command_pause = false

local auto_uval_checker = false

local dialogid_fires = -1
local active_fire_locations = ''
local active_fire_location = ''
local active_fire_lvl = '?'
local isFireDialog = false
local isFireZone = false

function getFireLocation(id)
	count = 0
	for line in active_fire_locations:gmatch('.-\n') do
		if id == count then
			local line2 = line:match('%].+%](.+){.+{.+{'):gsub("^%s+", ""):gsub("%s+$", "")
			active_fire_location = line2 or '�����'
			-- if line:find('%*%*%*') then
			-- 	active_fire_lvl = 3
			-- elseif line:find('%*%*') then
			-- 	active_fire_lvl = 2
			-- elseif line:find('%*') then
			-- 	active_fire_lvl = 1
			-- end
			if settings.general.auto_doklad_1 then
				sampSendChat('/r ����������� ' .. tagReplacements.my_doklad_nick() .. ', ������' .. tagReplacements.sex() .. ' �� ' .. active_fire_location .. ' ' .. active_fire_lvl .. '-� �������')
			end
			return
		else
			count = count + 1
		end
	end
end

------------------------------------------- Main -----------------------------------------------------
function welcome_message()
	if not sampIsLocalPlayerSpawned() then 
		sampAddChatMessage('[FD Helper] {ffffff}������������� ������� ������ �������!',message_color)
		sampAddChatMessage('[FD Helper] {ffffff}��� ������ �������� ������� ������� ������������ (������� �� ������)',message_color)
		repeat wait(0) until sampIsLocalPlayerSpawned()
	end
	sampAddChatMessage('[FD Helper] {ffffff}�������� ������� ������ �������!', message_color)
	print('[FD Helper] �������� ������� ������ �������!')
	show_arz_notify('info', 'FD Helper', "�������� ������� ������ �������!", 3000)
	if isMonetLoader() or settings.general.bind_mainmenu == nil or not settings.general.use_binds then	
		sampAddChatMessage('[FD Helper] {ffffff}���� ������� ���� ������� ������� ������� ' .. message_color_hex .. '/fh', message_color)
	elseif hotkey_no_errors and settings.general.bind_mainmenu and settings.general.use_binds then
		sampAddChatMessage('[FD Helper] {ffffff}���� ������� ���� ������� ������� ' .. message_color_hex .. getNameKeysFrom(settings.general.bind_mainmenu) .. ' {ffffff}��� ������� ������� ' .. message_color_hex .. '/fh', message_color)
	else
		sampAddChatMessage('[FD Helper] {ffffff}���� ������� ���� ������� ������� ������� ' .. message_color_hex .. '/fh', message_color)
	end
end
function registerCommandsFrom(array)
	for _, command in ipairs(array) do
		if command.enable then
			register_command(command.cmd, command.arg, command.text, tonumber(command.waiting))
		end
	end
end
function register_command(chat_cmd, cmd_arg, cmd_text, cmd_waiting)
	sampRegisterChatCommand(chat_cmd, function(arg)
		if not isActiveCommand then
			if command_stop then
				command_stop = false
			end
			local arg_check = false
			local modifiedText = cmd_text
			if cmd_arg == '{arg}' then
				if arg and arg ~= '' then
					modifiedText = modifiedText:gsub('{arg}', arg or "")
					arg_check = true
				else
					sampAddChatMessage('[FD Helper] {ffffff}����������� ' .. message_color_hex .. '/' .. chat_cmd .. ' [��������]', message_color)
					play_error_sound()
				end
			elseif cmd_arg == '{arg_id}' then
				if isParamSampID(arg) then
					arg = tonumber(arg)
					modifiedText = modifiedText:gsub('%{get_nick%(%{arg_id%}%)%}', sampGetPlayerNickname(arg) or "")
					modifiedText = modifiedText:gsub('%{get_rp_nick%(%{arg_id%}%)%}', sampGetPlayerNickname(arg):gsub('_',' ') or "")
					modifiedText = modifiedText:gsub('%{get_ru_nick%(%{arg_id%}%)%}', TranslateNick(sampGetPlayerNickname(arg)) or "")
					modifiedText = modifiedText:gsub('%{arg_id%}', arg or "")
					arg_check = true
				else
					sampAddChatMessage('[FD Helper] {ffffff}����������� ' .. message_color_hex .. '/' .. chat_cmd .. ' [ID ������]', message_color)
					play_error_sound()
				end
			elseif cmd_arg == '{arg_id} {arg2}' then
				if arg and arg ~= '' then
					local arg_id, arg2 = arg:match('(%d+) (.+)')
					if isParamSampID(arg_id) and arg2 then
						arg_id = tonumber(arg_id)
						modifiedText = modifiedText:gsub('%{get_nick%(%{arg_id%}%)%}', sampGetPlayerNickname(arg_id) or "")
						modifiedText = modifiedText:gsub('%{get_rp_nick%(%{arg_id%}%)%}', sampGetPlayerNickname(arg_id):gsub('_',' ') or "")
						modifiedText = modifiedText:gsub('%{get_ru_nick%(%{arg_id%}%)%}', TranslateNick(sampGetPlayerNickname(arg_id)) or "")
						modifiedText = modifiedText:gsub('%{arg_id%}', arg_id or "")
						modifiedText = modifiedText:gsub('%{arg2%}', arg2 or "")
						arg_check = true
					else
						sampAddChatMessage('[FD Helper] {ffffff}����������� ' .. message_color_hex .. '/' .. chat_cmd .. ' [ID ������] [��������]', message_color)
						play_error_sound()
					end
				else
					sampAddChatMessage('[FD Helper] {ffffff}����������� ' .. message_color_hex .. '/' .. chat_cmd .. ' [ID ������] [��������]', message_color)
					play_error_sound()
				end
            elseif cmd_arg == '{arg_id} {arg2} {arg3}' then
				if arg and arg ~= '' then
					local arg_id, arg2, arg3 = arg:match('(%d+) (%d) (.+)')
					if isParamSampID(arg_id) and arg2 and arg3 then
						arg_id = tonumber(arg_id)
						modifiedText = modifiedText:gsub('%{get_nick%(%{arg_id%}%)%}', sampGetPlayerNickname(arg_id) or "")
						modifiedText = modifiedText:gsub('%{get_rp_nick%(%{arg_id%}%)%}', sampGetPlayerNickname(arg_id):gsub('_',' ') or "")
						modifiedText = modifiedText:gsub('%{get_ru_nick%(%{arg_id%}%)%}', TranslateNick(sampGetPlayerNickname(arg_id)) or "")
						modifiedText = modifiedText:gsub('%{arg_id%}', arg_id or "")
						modifiedText = modifiedText:gsub('%{arg2%}', arg2 or "")
                        modifiedText = modifiedText:gsub('%{arg3%}', arg3 or "")
						arg_check = true
					else
						sampAddChatMessage('[FD Helper] {ffffff}����������� ' .. message_color_hex .. '/' .. chat_cmd .. ' [ID ������] [��������] [��������]', message_color)
						play_error_sound()
					end
				else
					sampAddChatMessage('[FD Helper] {ffffff}����������� ' .. message_color_hex .. '/' .. chat_cmd .. ' [ID ������] [��������] [��������]', message_color)
					play_error_sound()
				end
			elseif cmd_arg == '' then
				arg_check = true
			end
			if arg_check then
				lua_thread.create(function()
					isActiveCommand = true
					command_pause = false
					if modifiedText:find('&.+&') then
						if isMonetLoader() and settings.general.mobile_stop_button then
							sampAddChatMessage('[FD Helper] {ffffff}����� ���������� ��������� ������� ����������� ' .. message_color_hex .. '/stop {ffffff}��� ������� ������ ����� ������', message_color)
							CommandStopWindow[0] = true
						elseif not isMonetLoader() and hotkey_no_errors and settings.general.bind_command_stop and settings.general.use_binds then
							sampAddChatMessage('[FD Helper] {ffffff}����� ���������� ��������� ������� ����������� ' .. message_color_hex .. '/stop {ffffff}��� ������� ' .. message_color_hex .. getNameKeysFrom(settings.general.bind_command_stop), message_color)
						else
							sampAddChatMessage('[FD Helper] {ffffff}����� ���������� ��������� ������� ����������� ' .. message_color_hex .. '/stop', message_color)
						end
					end
					local lines = {}
					for line in string.gmatch(modifiedText, "[^&]+") do
						table.insert(lines, line)
					end
					for line_index, line in ipairs(lines) do
						if command_stop then 
							command_stop = false 
							isActiveCommand = false
							if isMonetLoader() and settings.general.mobile_stop_button then
								CommandStopWindow[0] = false
							end
							sampAddChatMessage('[FD Helper] {ffffff}��������� ������� /' .. chat_cmd .. " ������� �����������!", message_color) 
							break	
						else
							for tag, replacement in pairs(tagReplacements) do
								if line:find("{" .. tag .. "}") then
									local success, result = pcall(string.gsub, line, "{" .. tag .. "}", replacement())
									if success then
										line = result
									end
								end
							end
							if line == '{lmenu_vc_vize}' then
								if cmd_arg == '{arg_id}' then
									vc_vize_player_id = arg
								elseif cmd_arg == '{arg_id} {arg2}' then
									local arg_id, arg2 = arg:match('(%d+) (.+)')
									if arg_id and arg2 and isParamSampID(arg_id) then
										vc_vize_player_id = tonumber(arg_id)
									end
								end
								vc_vize_bool = true
								sampSendChat("/lmenu")
								break
							elseif line == '{show_rank_menu}' then
								if cmd_arg == '{arg_id}' then
									player_id = arg
								elseif cmd_arg == '{arg_id} {arg2}' then
									local arg_id, arg2 = arg:match('(%d+) (.+)')
									if arg_id and arg2 and isParamSampID(arg_id) then
										player_id = arg_id
									end
								end
								GiveRankMenu[0] = true
								break
							elseif line == "{pause}" then
								sampAddChatMessage('[FD Helper] {ffffff}������� /' .. chat_cmd .. ' ���������� �� �����!', message_color)
								command_pause = true
								CommandPauseWindow[0] = true
								while command_pause do
									wait(0)
								end
								if not command_stop then
									sampAddChatMessage('[FD Helper] {ffffff}��������� ��������� ������� /' .. chat_cmd, message_color)	
								end					
							else
								if line_index ~= 1 then wait(cmd_waiting * 1000) end
								if not command_stop then
									sampSendChat(line)
								else
									command_stop = false 
									isActiveCommand = false
									if isMonetLoader() and settings.general.mobile_stop_button then
										CommandStopWindow[0] = false
									end
									sampAddChatMessage('[FD Helper] {ffffff}��������� ������� /' .. chat_cmd .. " ������� �����������!", message_color) 	
									break
								end
							end
						end
						
					end
					isActiveCommand = false
					if isMonetLoader() and settings.general.mobile_stop_button then
						CommandStopWindow[0] = false
					end
				end)
			end
		else
			sampAddChatMessage('[FD Helper] {ffffff}��������� ���������� ��������� ���������� �������!', message_color)
			play_error_sound()
		end
	end)
end
function find_and_use_command(cmd, cmd_arg)
	local check = false
	for _, command in ipairs(commands.commands) do
		if command.enable and command.text:find(cmd) then
			check = true
			sampProcessChatInput("/" .. command.cmd .. " " .. cmd_arg)
			return
		end
	end
	if not check then
		for _, command in ipairs(commands.commands_manage) do
			if command.enable and command.text:find(cmd) then
				check = true
				sampProcessChatInput("/" .. command.cmd .. " " .. cmd_arg)
				return
			end
		end
	end
	if not check then
		sampAddChatMessage('[FD Helper] {ffffff}������, �� ���� ����� ���� ��� ���������� ���� �������!', message_color)
		play_error_sound()
		return
	end
end
function initialize_commands()
	sampRegisterChatCommand("fh", function() MainWindow[0] = not MainWindow[0] end)
	sampRegisterChatCommand("stop", function() 
		if isActiveCommand then 
			command_stop = true 
		else 
			sampAddChatMessage('[FD Helper] {ffffff}� ������ ������ ���� ������� �������� �������/���������!', message_color) 
		end
	end)
	sampRegisterChatCommand("sob", function(arg)
		if not isActiveCommand then
			if isParamSampID(arg) then
				player_id = tonumber(arg)
				SobesMenu[0] = not SobesMenu[0]
			else
				sampAddChatMessage('[FD Helper] {ffffff}����������� ' .. message_color_hex .. '/sob [ID ������]', message_color)
				play_error_sound()
			end	
		else
			sampAddChatMessage('[FD Helper] {ffffff}��������� ���������� ��������� ���������� �������!', message_color)
			play_error_sound()
		end
	end)
	sampRegisterChatCommand("debug", function() debug_mode = not debug_mode sampAddChatMessage('[FD DEBUG] {ffffff}������������ ������ ' .. (debug_mode and '��������!' or '���������!'), message_color) end)
	sampRegisterChatCommand("mb", function(arg)
		if not isActiveCommand then
			if MembersWindow[0] then
				MembersWindow[0] = false
			else
				members_new = {} 
				members_check = true 
				sampSendChat("/members")
			end
		else
			sampAddChatMessage('[FD Helper] {ffffff}��������� ���������� ��������� ���������� �������!', message_color)
			play_error_sound()
		end
	end)
	sampRegisterChatCommand("dep", function(arg)
		if not isActiveCommand then
			DeportamentWindow[0] = not DeportamentWindow[0]
		else
			sampAddChatMessage('[FD Helper] {ffffff}��������� ���������� ��������� ���������� �������!', message_color)
			play_error_sound()
		end
	end)
	-- ����������� ���� ������ ������� ���� � json
	registerCommandsFrom(commands.commands)
	if tonumber(settings.player_info.fraction_rank_number) >= 9 then 
		sampRegisterChatCommand("flm", show_leader_fast_menu)
		sampRegisterChatCommand("spcar", function()
			if not isActiveCommand then
				lua_thread.create(function()
					isActiveCommand = true
					if isMonetLoader() and settings.general.mobile_stop_button then
						sampAddChatMessage('[FD Helper] {ffffff}����� ���������� ��������� ������� ����������� ' .. message_color_hex .. '/stop {ffffff}��� ������� ������ ����� ������', message_color)
						CommandStopWindow[0] = true
					elseif not isMonetLoader() and hotkey_no_errors and settings.general.bind_command_stop and settings.general.use_binds then
						sampAddChatMessage('[FD Helper] {ffffff}����� ���������� ��������� ������� ����������� ' .. message_color_hex .. '/stop {ffffff}��� ������� ' .. message_color_hex .. getNameKeysFrom(settings.general.bind_command_stop), message_color)
					else
						sampAddChatMessage('[FD Helper] {ffffff}����� ���������� ��������� ������� ����������� ' .. message_color_hex .. '/stop', message_color)
					end
					sampSendChat("/rb ��������! ����� 15 ������ ����� ����� ���������� �����������.")
					wait(1500)
					if command_stop then 
						command_stop = false 
						isActiveCommand = false
						if isMonetLoader() and settings.general.mobile_stop_button then
							CommandStopWindow[0] = false
						end
						sampAddChatMessage('[FD Helper] {ffffff}��������� ������� /spcar ������� �����������!', message_color) 
						return
					end
					sampSendChat("/rb ������� ���������, ����� �� ����� ���������.")
					wait(13500)	
					if command_stop then 
						command_stop = false 
						isActiveCommand = false
						if isMonetLoader() and settings.general.mobile_stop_button then
							CommandStopWindow[0] = false
						end
						sampAddChatMessage('[FD Helper] {ffffff}��������� ������� /spcar ������� �����������!', message_color) 
						return
					end
					spawncar_bool = true
					sampSendChat("/lmenu")
					isActiveCommand = false
					if isMonetLoader() and settings.general.mobile_stop_button then
						CommandStopWindow[0] = false
					end
				end)
			else
				sampAddChatMessage('[FD Helper] {ffffff}��������� ���������� ��������� ���������� �������!', message_color)
			end
		end)
		-- ����������� ���� ������ ������� ���� � json ��� 9/10
		registerCommandsFrom(commands.commands_manage) 
	end
end
local russian_characters = {
    [168] = '�', [184] = '�', [192] = '�', [193] = '�', [194] = '�', [195] = '�', [196] = '�', [197] = '�', [198] = '�', [199] = '�', [200] = '�', [201] = '�', [202] = '�', [203] = '�', [204] = '�', [205] = '�', [206] = '�', [207] = '�', [208] = '�', [209] = '�', [210] = '�', [211] = '�', [212] = '�', [213] = '�', [214] = '�', [215] = '�', [216] = '�', [217] = '�', [218] = '�', [219] = '�', [220] = '�', [221] = '�', [222] = '�', [223] = '�', [224] = '�', [225] = '�', [226] = '�', [227] = '�', [228] = '�', [229] = '�', [230] = '�', [231] = '�', [232] = '�', [233] = '�', [234] = '�', [235] = '�', [236] = '�', [237] = '�', [238] = '�', [239] = '�', [240] = '�', [241] = '�', [242] = '�', [243] = '�', [244] = '�', [245] = '�', [246] = '�', [247] = '�', [248] = '�', [249] = '�', [250] = '�', [251] = '�', [252] = '�', [253] = '�', [254] = '�', [255] = '�',
}
function string.rlower(s)
    s = s:lower()
    local strlen = s:len()
    if strlen == 0 then return s end
    s = s:lower()
    local output = ''
    for i = 1, strlen do
        local ch = s:byte(i)
        if ch >= 192 and ch <= 223 then -- upper russian characters
            output = output .. russian_characters[ch + 32]
        elseif ch == 168 then -- �
            output = output .. russian_characters[184]
        else
            output = output .. string.char(ch)
        end
    end
    return output
end
function string.rupper(s)
    s = s:upper()
    local strlen = s:len()
    if strlen == 0 then return s end
    s = s:upper()
    local output = ''
    for i = 1, strlen do
        local ch = s:byte(i)
        if ch >= 224 and ch <= 255 then -- lower russian characters
            output = output .. russian_characters[ch - 32]
        elseif ch == 184 then -- �
            output = output .. russian_characters[168]
        else
            output = output .. string.char(ch)
        end
    end
    return output
end
function ReverseTranslateNick(name)
    local translit_table = {
        ['�'] = 'f', ['�'] = 'F', ['�'] = 'ch', ['�'] = 'Ch',
        ['�'] = 't', ['�'] = 'T', ['�'] = 'sh', ['�'] = 'Sh',
        ['�'] = 'i', ['�'] = 'E', ['�'] = 'e', ['�'] = 's',
        ['�'] = 'zh', ['�'] = 'Zh', ['�'] = 'yu', ['�'] = 'Yu',
        ['�'] = 'yo', ['�'] = 'Yo', ['�'] = 'ts', ['�'] = 'Ts',
        ['�'] = 'ya', ['�'] = 'Ya', ['��'] = 'ov', ['��'] = 'ey',
        ['�'] = 'u', ['�'] = 'U', ['�'] = 'I', ['��'] = 'an',
        ['��'] = 'tsi', ['��'] = 'uz', ['����'] = 'kate', ['��'] = 'yau',
        ['����'] = 'rown', ['���'] = 'uev', ['�����'] = 'Baby',
        ['�������'] = 'Jason', ['���'] = 'liy', ['���'] = 'ein', ['���'] = 'ame'
    }
    
    for k, v in pairs(translit_table) do
        name = name:gsub(k, v)
    end
    
    local char_table = {
        ['�'] = 'A', ['�'] = 'B', ['�'] = 'V', ['�'] = 'G', ['�'] = 'D',
        ['�'] = 'E', ['�'] = 'Yo', ['�'] = 'Zh', ['�'] = 'Z', ['�'] = 'I',
        ['�'] = 'Y', ['�'] = 'K', ['�'] = 'L', ['�'] = 'M', ['�'] = 'N',
        ['�'] = 'O', ['�'] = 'P', ['�'] = 'R', ['�'] = 'S', ['�'] = 'T',
        ['�'] = 'U', ['�'] = 'F', ['�'] = 'H', ['�'] = 'Ts', ['�'] = 'Ch',
        ['�'] = 'Sh', ['�'] = 'Sch', ['�'] = '', ['�'] = 'Y', ['�'] = '',
        ['�'] = 'E', ['�'] = 'Yu', ['�'] = 'Ya',
        ['�'] = 'a', ['�'] = 'b', ['�'] = 'v', ['�'] = 'g', ['�'] = 'd',
        ['�'] = 'e', ['�'] = 'yo', ['�'] = 'zh', ['�'] = 'z', ['�'] = 'i',
        ['�'] = 'y', ['�'] = 'k', ['�'] = 'l', ['�'] = 'm', ['�'] = 'n',
        ['�'] = 'o', ['�'] = 'p', ['�'] = 'r', ['�'] = 's', ['�'] = 't',
        ['�'] = 'u', ['�'] = 'f', ['�'] = 'h', ['�'] = 'ts', ['�'] = 'ch',
        ['�'] = 'sh', ['�'] = 'sch', ['�'] = '', ['�'] = 'y', ['�'] = '',
        ['�'] = 'e', ['�'] = 'yu', ['�'] = 'ya'
    }
    
    for k, v in pairs(char_table) do
        name = name:gsub(k, v)
    end
    
    return name
end
function TranslateNick(name)
	if name:match('%a+') then
        for k, v in pairs({['ph'] = '�',['Ph'] = '�',['Ch'] = '�',['ch'] = '�',['Th'] = '�',['th'] = '�',['Sh'] = '�',['sh'] = '�', ['ea'] = '�',['Ae'] = '�',['ae'] = '�',['size'] = '����',['Jj'] = '��������',['Whi'] = '���',['lack'] = '���',['whi'] = '���',['Ck'] = '�',['ck'] = '�',['Kh'] = '�',['kh'] = '�',['hn'] = '�',['Hen'] = '���',['Zh'] = '�',['zh'] = '�',['Yu'] = '�',['yu'] = '�',['Yo'] = '�',['yo'] = '�',['Cz'] = '�',['cz'] = '�', ['ia'] = '�', ['ea'] = '�',['Ya'] = '�', ['ya'] = '�', ['ove'] = '��',['ay'] = '��', ['rise'] = '����',['oo'] = '�', ['Oo'] = '�', ['Ee'] = '�', ['ee'] = '�', ['Un'] = '��', ['un'] = '��', ['Ci'] = '��', ['ci'] = '��', ['yse'] = '��', ['cate'] = '����', ['eow'] = '��', ['rown'] = '����', ['yev'] = '���', ['Babe'] = '�����', ['Jason'] = '�������', ['liy'] = '���', ['ane'] = '���', ['ame'] = '���'}) do
            name = name:gsub(k, v) 
        end
		for k, v in pairs({['B'] = '�',['Z'] = '�',['T'] = '�',['Y'] = '�',['P'] = '�',['J'] = '��',['X'] = '��',['G'] = '�',['V'] = '�',['H'] = '�',['N'] = '�',['E'] = '�',['I'] = '�',['D'] = '�',['O'] = '�',['K'] = '�',['F'] = '�',['y`'] = '�',['e`'] = '�',['A'] = '�',['C'] = '�',['L'] = '�',['M'] = '�',['W'] = '�',['Q'] = '�',['U'] = '�',['R'] = '�',['S'] = '�',['zm'] = '���',['h'] = '�',['q'] = '�',['y'] = '�',['a'] = '�',['w'] = '�',['b'] = '�',['v'] = '�',['g'] = '�',['d'] = '�',['e'] = '�',['z'] = '�',['i'] = '�',['j'] = '�',['k'] = '�',['l'] = '�',['m'] = '�',['n'] = '�',['o'] = '�',['p'] = '�',['r'] = '�',['s'] = '�',['t'] = '�',['u'] = '�',['f'] = '�',['x'] = 'x',['c'] = '�',['``'] = '�',['`'] = '�',['_'] = ' '}) do
            name = name:gsub(k, v) 
        end
        return name
    end
	return name
end
function isParamSampID(id)
	id = tonumber(id)
	if id ~= nil and tostring(id):find('%d') and not tostring(id):find('%D') and string.len(id) >= 1 and string.len(id) <= 3 then
		if id == select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)) then
			return true
		elseif sampIsPlayerConnected(id) then
			return true
		else
			return false
		end
	else
		return false
	end
end
function play_error_sound()
	if not isMonetLoader() and sampIsLocalPlayerSpawned() then
		addOneOffSound(getCharCoordinates(PLAYER_PED), 1149)
	end
	show_arz_notify('error', 'FD Helper', "��������� ������!", 1500)
end
function show_leader_fast_menu(id)
	if isParamSampID(id) then
		player_id = tonumber(id)
		LeaderFastMenu[0] = true
	else
		if isMonetLoader() or settings.general.bind_leader_fastmenu == nil then
			sampAddChatMessage('[FD Helper] {ffffff}����������� ' .. message_color_hex .. '/flm [ID]', message_color)
		elseif settings.general.bind_leader_fastmenu and settings.general.use_binds and hotkey_no_errors then
			sampAddChatMessage('[FD Helper] {ffffff}����������� ' .. message_color_hex .. '/flm [ID] {ffffff}��� ���������� �� ������ ����� ' .. message_color_hex .. '��� + ' .. getNameKeysFrom(settings.general.bind_leader_fastmenu), message_color) 
		else
			sampAddChatMessage('[FD Helper] {ffffff}����������� ' .. message_color_hex .. '/flm [ID]', message_color)
		end 
		play_error_sound()
	end
end
function ifCommandPause()
	if command_stop then 
		command_stop = false 
		isActiveCommand = false
		if isMonetLoader() and settings.general.mobile_stop_button then
			CommandStopWindow[0] = false
		end
		sampAddChatMessage('[FD Helper] {ffffff}��������� ������� ������� �����������!', message_color)  
		return true
	else
		return false
	end
end
function show_arz_notify(type, title, text, time)
	-- if isMonetLoader() then
	-- 	if type == 'info' then
	-- 		type = 3
	-- 	elseif type == 'error' then
	-- 		type = 2
	-- 	elseif type == 'success' then
	-- 		type = 1
	-- 	end
	-- 	local bs = raknetNewBitStream()
	-- 	raknetBitStreamWriteInt8(bs, 62)
	-- 	raknetBitStreamWriteInt8(bs, 6)
	-- 	raknetBitStreamWriteBool(bs, true)
	-- 	raknetEmulPacketReceiveBitStream(220, bs)
	-- 	raknetDeleteBitStream(bs)
	-- 	local json = encodeJson({
	-- 		styleInt = type,
	-- 		title = title,
	-- 		text = text,
	-- 		duration = time
	-- 	})
	-- 	local interfaceid = 6
	-- 	local subid = 0
	-- 	local bs = raknetNewBitStream()
	-- 	raknetBitStreamWriteInt8(bs, 84)
	-- 	raknetBitStreamWriteInt8(bs, interfaceid)
	-- 	raknetBitStreamWriteInt8(bs, subid)
	-- 	raknetBitStreamWriteInt32(bs, #json)
	-- 	raknetBitStreamWriteString(bs, json)
	-- 	raknetEmulPacketReceiveBitStream(220, bs)
	-- 	raknetDeleteBitStream(bs)
	-- else
	-- 	local str = ('window.executeEvent(\'event.notify.initialize\', \'["%s", "%s", "%s", "%s"]\');'):format(type, title, text, time)
	-- 	local bs = raknetNewBitStream()
	-- 	raknetBitStreamWriteInt8(bs, 17)
	-- 	raknetBitStreamWriteInt32(bs, 0)
	-- 	raknetBitStreamWriteInt32(bs, #str)
	-- 	raknetBitStreamWriteString(bs, str)
	-- 	raknetEmulPacketReceiveBitStream(220, bs)
	-- 	raknetDeleteBitStream(bs)
	-- end
end
function run_code(code)
    local bs = raknetNewBitStream();
    raknetBitStreamWriteInt8(bs, 17);
    raknetBitStreamWriteInt32(bs, 0);
    raknetBitStreamWriteInt32(bs, string.len(code));
    raknetBitStreamWriteString(bs, code);
    raknetEmulPacketReceiveBitStream(220, bs);
    raknetDeleteBitStream(bs);
end
function openLink(link)
	if isMonetLoader() then
		gta._Z12AND_OpenLinkPKc(link)
	else
		os.execute("explorer " .. link)
	end
end
function sampGetPlayerIdByNickname(nick)
	local id = nil
	nick = tostring(nick)
	local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
	if sampGetPlayerNickname(myid):find(nick) then return myid end
	for i = 0, 999 do
	    if sampIsPlayerConnected(i) and sampGetPlayerNickname(i):find(nick) then
		   id = i
		   break
	    end
	end
	if id == nil then
		sampAddChatMessage('[FD Helper] {ffffff}������: �� ������� �������� ID ������!', message_color)
		id = ''
	end
	return id
end
local weapons = {
	FIST = 0,
	BRASSKNUCKLES = 1,
	GOLFCLUB = 2,
	NIGHTSTICK = 3,
	KNIFE = 4,
	BASEBALLBAT = 5,
	SHOVEL = 6,
	POOLCUE = 7,
	KATANA = 8,
	CHAINSAW = 9,
	PURPLEDILDO = 10,
	WHITEDILDO = 11,
	WHITEVIBRATOR = 12,
	SILVERVIBRATOR = 13,
	FLOWERS = 14,
	CANE = 15,
	GRENADE = 16,
	TEARGAS = 17,
	MOLOTOV = 18,
	COLT45 = 22,
	SILENCED = 23,
	DESERTEAGLE = 24,
	SHOTGUN = 25,
	SAWNOFFSHOTGUN = 26,
	COMBATSHOTGUN = 27,
	UZI = 28,
	MP5 = 29,
	AK47 = 30,
	M4 = 31,
	TEC9 = 32,
	RIFLE = 33,
	SNIPERRIFLE = 34,
	ROCKETLAUNCHER = 35,
	HEATSEEKER = 36,
	FLAMETHROWER = 37,
	MINIGUN = 38,
	SATCHELCHARGE = 39,
	DETONATOR = 40,
	SPRAYCAN = 41,
	FIREEXTINGUISHER = 42,
	CAMERA = 43,
	NIGHTVISION = 44,
	THERMALVISION = 45,
	PARACHUTE = 46,
	WEAPON_VEHICLE = 49,
	HELI = 50,
	BOMB = 51,
	COLLISION = 54,
	-- ARZ CUSTOM GUN
	DEAGLE_STEEL = 71,
	DEAGLE_GOLD = 72,
	GLOCK_GRADIENT = 73,
	DEAGLE_FLAME = 74,
	PYTHON_ROYAL = 75,
	PYTHON_SILVER = 76,
	AK47_ROSES = 77,
	AK47_GOLD = 78,
	M249_GRAFFITI = 79,
	SAIGA_GOLD = 80,
	PPSH_STANDART = 81,
	M249_STANDART = 82,
	SKORP_STANDART = 83,
	AKS74_CAMOUFLAGE1 = 84,
	AK47_CAMOUFLAGE1 = 85,
	REBECCA_SHOTGUN = 86,
	OBJ58_PORTALGUN = 87,
	ICE_SWORD = 88,
	PORTALGUN = 89,
	SOUND_GRENADE = 90,
	EYE_GRENADE = 91,
	MCMILLIAN_TAC50 = 92
}
local id = weapons
weapons.names = {
	[id.FIST] = '������',
	[id.BRASSKNUCKLES] = '�������',
	[id.GOLFCLUB] = '������ ��� ������',
	[id.NIGHTSTICK] = '�������',
	[id.KNIFE] = '������ ���',
	[id.BASEBALLBAT] = '����',
	[id.SHOVEL] = '������',
	[id.POOLCUE] = '���',
	[id.KATANA] = '������',
	[id.CHAINSAW] = '���������',
	[id.PURPLEDILDO] = '�����',
	[id.WHITEDILDO] = '�����',
	[id.WHITEVIBRATOR] = '��������',
	[id.SILVERVIBRATOR] = '��������',
	[id.FLOWERS] = '����� ������',
	[id.CANE] = '������',
	[id.GRENADE] = '���������� �������',
	[id.TEARGAS] = '������� �������',
	[id.MOLOTOV] = '�������� ��������',
	[id.COLT45] = '�������� Colt45',
	[id.SILENCED] = "������������ Taser-X26P",
	[id.DESERTEAGLE] = '�������� Desert Eagle',
	[id.SHOTGUN] = '��������',
	[id.SAWNOFFSHOTGUN] = '�����',
	[id.COMBATSHOTGUN] = '���������� �����',
	[id.UZI] = '��������-������ Micro Uzi',
	[id.MP5] = '��������-������ MP5',
	[id.AK47] = '������� AK-47',
	[id.M4] = '������� M4',
	[id.TEC9] = '��������-������ Tec-9',
	[id.RIFLE] = '�������� Rifle',
	[id.SNIPERRIFLE] = '����������� �������� Rifle',
	[id.ROCKETLAUNCHER] = '������ ��������������� ������',
	[id.HEATSEEKER] = '���������� ��� ������� �����',
	[id.FLAMETHROWER] = '������',
	[id.MINIGUN] = '�������',
	[id.SATCHELCHARGE] = '�������',
	[id.DETONATOR] = '���������',
	[id.SPRAYCAN] = '�������� ��������',
	[id.FIREEXTINGUISHER] = '������������',
	[id.CAMERA] = '���������� Canon',
	[id.NIGHTVISION] = '������ ������� �������',
	[id.THERMALVISION] = '����������',
	[id.PARACHUTE] = '������ �������',
	[id.WEAPON_VEHICLE] = '����������',
	[id.HELI] = '������� ��������',
	[id.BOMB] = '�����',
	[id.COLLISION] = '��������',
	-- ARZ LAUNCHER GUNS
	[id.DEAGLE_STEEL] = '�������� Desert Eagle Steel',
	[id.DEAGLE_GOLD] = '�������� Desert Eagle Gold',
	[id.GLOCK_GRADIENT] = '�������� Glock',
	[id.DEAGLE_FLAME] = '�������� Desert Eagle Flame',
	[id.PYTHON_ROYAL] = '�������� Colt Python',
	[id.PYTHON_SILVER] = '�������� Colt Python Silver',
	[id.AK47_ROSES] = '������� AK-47 Roses',
	[id.AK47_GOLD] = '������� AK-47 Gold',
	[id.M249_GRAFFITI] = '������ M249 Graffiti',	
	[id.SAIGA_GOLD] = '������� �����',
	[id.PPSH_STANDART] = '��������-������ Standart',
	[id.M249_STANDART] = '������ M249',
	[id.SKORP_STANDART] = '��������-������ Skorp',
	[id.AKS74_CAMOUFLAGE1] = '������� AKS-74 �����������',
	[id.AK47_CAMOUFLAGE1] = '������� AK-47 �����������',
	[id.REBECCA_SHOTGUN] = '�������� Rebecca',
	[id.OBJ58_PORTALGUN] = '���������� �����',
	[id.PORTALGUN] = '���������� �����',
	[id.ICE_SWORD] = '������� ���',
	[id.SOUND_GRENADE] = '���������� �������',
	[id.EYE_GRENADE] = '����������� �������',
	[id.MCMILLIAN_TAC50] = '����������� �������� McMillian TAC-50'
}
function weapons.get_name(id) 
	return weapons.names[id]
end
local gunOn = {}
local gunOff = {}
local gunPartOn = {}
local gunPartOff = {}
local oldGun = nil
local nowGun = 0
local rpTakeNames = {{"��-�� �����", "�� �����"}, {"�� �������", "� ������"}, {"�� �����", "�� ����"}, {"�� ������", "� ������"}}
local rpTake = {
	[2]=1, [5]=1, [6]=1, [7]=1, [8]=1, [9]=1, [14]=1, [15]=1, [25]=1, [26]=1, [27]=1, [28]=1, [29]=1, [30]=1, [31]=1, [32]=1, [33]=1, [34]=1, [35]=1, [36]=1, [37]=1, [38]=1, [42]=1, [77]=1, [78]=1, [78]=1, [79]=1, [80]=1, [81]=1, [82]=1, [83]=1, [84]=1, [85]=1, [86]=1, [92]=1, [87]=1, [88]=1, [49]=1, [50]=1, [51]=1, [54]=1, -- �����
	[1]=2, [4]=2, [10]=2, [11]=2, [12]=2, [13]=2, [41]=2, [43]=2, [44]=2, [45]=2, [46]=2, -- ������
	[16]=3, [17]=3, [18]=3, [39]=3, [40]=3, [90]=3, [91]=3, [3]=3,  -- ����
	[22]=4, [23]=4, [24]=4, [71]=4, [72]=4, [73]=4, [74]=4, [75]=4, [76]=4, [89]=4, -- ������
}
for id, weapon in pairs(weapons.names) do
	if (id == 3 or (id > 15 and id < 19) or (id == 90 or id == 91)) then -- 3 16 17 18 (for gunOn)
		if settings.player_info.sex == "�������" or settings.player_info.sex == "����������" then
			gunOn[id] = '����'
		elseif settings.player_info.sex == "�������" then
			gunOn[id] = '����a'
		end
	else
		if settings.player_info.sex == "�������" or settings.player_info.sex == "����������" then
			gunOn[id] = '������'
		elseif settings.player_info.sex == "�������" then
			gunOn[id] = '������a'
		end
	end
	if (id == 3 or (id > 15 and id < 19) or (id > 38 and id < 41) or (id == 90 or id == 91)) then -- 3 16 17 18 39 40 (for gunOff)
		if settings.player_info.sex == "�������" or settings.player_info.sex == "����������" then
			gunOff[id] = '�������'
		elseif settings.player_info.sex == "�������" then
			gunOff[id] = '�������a'
		end
	else
		if settings.player_info.sex == "�������" or settings.player_info.sex == "����������" then
			gunOff[id] = '�����'
		elseif settings.player_info.sex == "�������" then
			gunOff[id] = '�����a'
		end
	end
	if id > 0 then
		gunPartOn[id] = rpTakeNames[rpTake[id]][1]
		gunPartOff[id] = rpTakeNames[rpTake[id]][2]
	end
end
function argbToRgbNormalized(argb)
    local a = math.floor(argb / 0x1000000) % 0x100
    local r = math.floor(argb / 0x10000) % 0x100
    local g = math.floor(argb / 0x100) % 0x100
    local b = argb % 0x100
    local normalizedR = r / 255.0
    local normalizedG = g / 255.0
    local normalizedB = b / 255.0
    return {normalizedR, normalizedG, normalizedB}
end
local servers = {
	{name = 'Phoenix', number = '01'},
	{name = 'Tucson', number = '02'},
	{name = 'Scottdale', number = '03'},
	{name = 'Chandler', number = '04'},
	{name = 'Brainburg', number = '05'},
	{name = 'Saint%-Rose', number = '06'},
	{name = 'Mesa', number = '07'},
	{name = 'Red%-Rock', number = '08'},
	{name = 'Yuma', number = '09'},
	{name = 'Surprise', number = '10'},
	{name = 'Prescott', number = '11'},
	{name = 'Glendale', number = '12'},
	{name = 'Kingman', number = '13'},
	{name = 'Winslow', number = '14'},
	{name = 'Payson', number = '15'},
	{name = 'Gilbert', number = '16'},
	{name = 'Show Low', number = '17'},
	{name = 'Casa%-Grande', number = '18'},
	{name = 'Page', number = '19'},
	{name = 'Sun%-City', number = '20'},
	{name = 'Queen%-Creek', number = '21'},
	{name = 'Sedona', number = '22'},
	{name = 'Holiday', number = '23'},
	{name = 'Wednesday', number = '24'},
	{name = 'Yava', number = '25'},
	{name = 'Faraway', number = '26'},
	{name = 'Bumble Bee', number = '27'},
	{name = 'Christmas', number = '28'},
	{name = 'Mirage', number = '29'},
	{name = 'Love', number = '30'},
	{name = 'Drake', number = '31'},
	{name = 'Mobile III', number = '103'},
	{name = 'Mobile II', number = '102'},
	{name = 'Mobile I', number = '101'},
	{name = 'Vice City', number = '200'},
}
function getARZServerNumber()
	local server = 0
	for _, s in ipairs(servers) do
		if sampGetCurrentServerName():find(s.name) then
			server = s.number
			break
		end
	end
	return server
end
function getARZServerName(number)
	local server = ''
	for _, s in ipairs(servers) do
		if tostring(number) == tostring(s.number) then
			server = s.name
			break
		end
	end
	return server
end
function sampev.onServerMessage(color,text)
	--sampAddChatMessage('color = ' .. color .. ' ' .. argbToHex(color) ' text = '..text,-1)
	if (settings.general.auto_uval and tonumber(settings.player_info.fraction_rank_number) >= 9) then
		if text:find("%[(.-)%] (.-) (.-)%[(.-)%]: (.+)") and color == 766526463 then -- /f /fb ��� /r /rb ��� ���� 
			local tag, rank, name, playerID, message = string.match(text, "%[(.-)%] (.+) (.-)%[(.-)%]: (.+)")
			lua_thread.create(function ()
				wait(50)
				if ((not message:find(" ��������� (.+) +++ ����� �������� ���!") and not message:find("��������� (.+) ��� ������ �� �������(.+)")) and (message:rupper():find("���") or message:rupper():find("���.") or message:rupper():find("�������") or message:find("�������.") or message:rupper():find("����") or message:rupper():find("����."))) then
					message3 = message2
					message2 = message1
					message1 = text
					PlayerID = playerID
					sampAddChatMessage(text, 0xFF2DB043)
					if message3 == text then
						auto_uval_checker = true
						sampSendChat('/fmute ' .. playerID .. ' 1 [AutoUval] ��������...')
					elseif tag == "R" then
						sampSendChat("/rb "..name.." ��������� /rb +++ ����� �������� ���!")
					elseif tag == "F" then
						sampSendChat("/fb "..name.." ��������� /fb +++ ����� �������� ���!")
					end
				elseif ((message == "(( +++ ))" or message == "(( +++. ))") and (PlayerID == playerID)) then
					sampAddChatMessage(text, 0xFF2DB043)
					auto_uval_checker = true
					sampSendChat('/fmute ' .. PlayerID .. ' 1 [AutoUval] ��������...')
				end
			end)
		elseif text:find("%[(.-)%] %[(.-)%] (.+) (.-)%[(.-)%]: (.+)") and color == 766526463 then -- /r ��� /f � �����
			local tag, tag2, rank, name, playerID, message = string.match(text, "%[(.-)%] %[(.-)%] (.+) (.-)%[(.-)%]: (.+)")
			lua_thread.create(function ()
				wait(50)
				if not message:find(" ��������� (.+) +++ ����� �������� ���!") and not message:find("��������� (.+) ��� ������ �� �������(.+)") and message:rupper():find("���") or message:rupper():find("���.") or message:rupper():find("�������") or message:find("�������.") or message:rupper():find("����") or message:rupper():find("����.") then
					message3 = message2
					message2 = message1
					message1 = text
					PlayerID = playerID	
					sampAddChatMessage(text, 0xFF2DB043)
					if message3 == text then
						auto_uval_checker = true
						sampSendChat('/fmute ' .. playerID .. ' 1 [AutoUval] ��������...')
					elseif tag == "R" then
						sampSendChat("/rb "..name.."["..playerID.."], ��������� /rb +++ ����� �������� ���!")
					elseif tag == "F" then
						sampSendChat("/fb "..name.."["..playerID.."], ��������� /fb +++ ����� �������� ���!")
					end
				elseif ((message == "(( +++ ))" or  message == "(( +++. ))") and (PlayerID == playerID)) then
					auto_uval_checker = true
					sampSendChat('/fmute ' .. playerID .. ' 1 [AutoUval] ��������...')
				end
			end)
		end
		
		if text:find("(.+) ��������%(�%) ������ (.+) �� 1 �����. �������: %[AutoUval%] ��������...") and auto_uval_checker then
			local Name, PlayerName, Time, Reason = text:match("(.+) ��������%(�%) ������ (.+) �� (%d+) �����. �������: (.+)")
			local MyName = sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)))
			lua_thread.create(function ()
				wait(50)
				if Name == MyName then
					sampAddChatMessage('[FD Helper] {ffffff}�������� ������ ' .. sampGetPlayerNickname(PlayerID) .. '!', message_color)
					auto_uval_checker = false
					temp = PlayerID .. ' ���'
					find_and_use_command("/uninvite {arg_id} {arg2}", temp)
				else
					sampAddChatMessage('[FD Helper] {ffffff}������ �����������/����� ��� ��������� ������ ' .. sampGetPlayerNickname(PlayerID) .. '!', message_color)
					auto_uval_checker = false
				end
			end)
		end
	end
	if (text:find("� (.+) ����������� �������� ������. �� ������ ������ ��� ������ � ������� ������� /givewbook") and tonumber(settings.player_info.fraction_rank_number) >= 9) then
		local nick = text:match("� (.+) ����������� �������� ������. �� ������ ������ ��� ������ � ������� ������� /givewbook")
		local cmd = '/givewbook'
		for _, command in ipairs(commands.commands_manage) do
			if command.enable and command.text:find('/givewbook {arg_id}') then
				cmd =  '/' .. command.cmd
			end
		end
		sampAddChatMessage('[FD Helper] {ffffff}� ������ ' .. nick .. ' ���� �������� ������, ������� � ��������� ' .. message_color_hex .. cmd .. ' ' .. sampGetPlayerIdByNickname(nick), message_color)
		return false
	end
	if text:find("1%.{6495ED} 111 %- {FFFFFF}��������� ������ ��������") or
		text:find("2%.{6495ED} 060 %- {FFFFFF}������ ������� �������") or
		text:find("3%.{6495ED} 911 %- {FFFFFF}����������� �������") or
		text:find("4%.{6495ED} 912 %- {FFFFFF}������ ������") or
		text:find("5%.{6495ED} 914 %- {FFFFFF}�����") or
		text:find("5%.{6495ED} 914 %- {FFFFFF}�������") or
		text:find("6%.{6495ED} 8828 %- {FFFFFF}���������� ������������ �����") or
		text:find("7%.{6495ED} 997 %- {FFFFFF}������ �� �������� ����� ������������ %(������ ��������� ����%)") then
		return false
	end
	if text:find("������ ��������� ��������������� �����:") then
		sampAddChatMessage('[FD Helper] {ffffff}������ ��������� ��������������� �����:', message_color)
		sampAddChatMessage('[FD Helper] {ffffff}111 ������ | 60 ����� | 911 �� | 912 �� | 913 ����� | 914 ���� | 8828 ���� | 997 ����', message_color)
		return false
	end
	if (text:find('Bogdan_Martelli%[%d+%]') and getARZServerNumber():find('20')) or text:find('%[20%]Bogdan_Martelli') then
		local lastColor = text:match("(.+){%x+}$")
   		if not lastColor then
			lastColor = "{" .. rgba_to_hex(color) .. "}"
		end
		if text:find('%[VIP ADV%]') or text:find('%[FOREVER%]') then
			lastColor = "{FFFFFF}"
		end
		if text:find('%[20%]Bogdan_Martelli%[%d+%]') then
			-- ������ 2: [20]Bogdan_Martelli[123]
			local id = text:match('%[20%]Bogdan_Martelli%[(%d+)%]') or ''
			text = string.gsub(text, '%[20%]Bogdan_Martelli%[%d+%]', message_color_hex .. '[20]MTG MODS[' .. id .. ']' .. lastColor)
		
		elseif text:find('%[20%]Bogdan_Martelli') then
			-- ������ 1: [20]Bogdan_Martelli
			text = string.gsub(text, '%[20%]Bogdan_Martelli', message_color_hex .. '[20]MTG MODS' .. lastColor)
		
		elseif text:find('Bogdan_Martelli%[%d+%]') then
			-- ������ 3: Bogdan_Martelli[123]
			local id = text:match('Bogdan_Martelli%[(%d+)%]') or ''
			text = string.gsub(text, 'Bogdan_Martelli%[%d+%]', message_color_hex .. 'MTG MODS[' .. id .. ']' .. lastColor)
		elseif text:find('Bogdan_Martelli') then
			-- ������ 3: Bogdan_Martelli
			text = string.gsub(text, 'Bogdan_Martelli', message_color_hex .. 'MTG MODS' .. lastColor)
		end
		return {color,text}
	end

	if text:find("����������(.+)�� ������� �� ����� ������") then
		isFireZone = true
		sampAddChatMessage('[FD Helper] {ffffff}�� ������� �� ����� ������.', message_color)
		if settings.general.auto_doklad_2 then 
			sampSendChat('/r ����������� ' .. tagReplacements.my_doklad_nick() .. ', ������' .. tagReplacements.sex() .. ' �� ����� ������ ' .. active_fire_lvl .. ' ������� ���������!')
		end
		return false
	end

	if text:find("����������(.+)��� ����� ���������� �������������") and isFireZone then
		sampAddChatMessage('[FD Helper] {ffffff}��� ����� ���������� �������������!', message_color)
		if settings.general.auto_doklad_3 then
			sampSendChat('/r ����������� ' .. tagReplacements.my_doklad_nick() .. ', ��� ����� ���������� ������ ' .. active_fire_lvl .. ' ������� ��������� �������������!')
		end
		return false
	end

	if text:find("����������(.+)�������� ������������� � �������.") and isFireZone then
		sampAddChatMessage('[FD Helper] {ffffff}�������� ������������� � �������.', message_color)
		if settings.general.auto_doklad_4 then 
			sampSendChat('/r ����������� ' .. tagReplacements.my_doklad_nick() .. ', ��������' .. tagReplacements.sex() .. ' ������������� �� �������, ������ � �������.')
		end
		return false
	end

	if text:find("����������(.+)�������! �� ������ �������������!") and isFireZone then
		sampAddChatMessage('[FD Helper] {ffffff}�� ������ �������������!', message_color)
		if settings.general.auto_doklad_5 then 
			sampSendChat('/r ����������� ' .. tagReplacements.my_doklad_nick() .. ', ������������� ������� ������� ������!')
		end
		return false
	end

	if text:find("�� ���������� �� ������������(.+)������� �������������� ����� �� ���� �����������") and isFireZone then
		isFireZone = false
		sampAddChatMessage('[FD Helper] {ffffff}����� �������, �� ��� ���������� �� ����������:' .. (text:match('������������(.+) �������') or ' error'), message_color)
		if settings.general.auto_doklad_6 then
			lua_thread.create(function ()
				wait(500)
				sampSendChat('/r ����������� ' .. tagReplacements.my_doklad_nick() .. ', ����� ' .. active_fire_lvl .. ' ������� ��������� �������� �������!')
			end)
		end
		return false
	end

	if text:find("����������(.+)������� ���������� ��� � ���������.") then
		sampAddChatMessage('[FD Helper] {ffffff}������� ���������� ��� � ���������.', message_color)
		if settings.general.auto_doklad_7 then 
			sampSendChat('/r ����������� ' .. tagReplacements.my_doklad_nick() .. ', �����' .. tagReplacements.sex() .. ' ������� � ����� �����������.')
		end
		return false
	end

	if text:find("�������� ������ ����� ������������ ����� (%d+) �����") then
		local min = text:match("�������� ������ ����� ������������ ����� (%d+) �����")
		sampAddChatMessage('[FD Helper] {ffffff}�������� ������ ����� ������������ ����� ' .. (min or 'nil') .. ' �����!', message_color)
		return false
	end

	if text:find("������������(.+)� ����� ��������� �����! ���� ��������� (%d) ������") then
		active_fire_lvl = text:match('���� ��������� (%d) ������')
		sampAddChatMessage('[FD Helper] {ffffff}� ����� ����� ����� ' .. active_fire_lvl .. ' ������ ���������!', message_color)
		if tonumber(active_fire_lvl) >= 2 then
			sampAddChatMessage('[FD Helper] {ffffff}��������� ���������� ������� �� ���������� ������ ��-�� �������� ������ ���������.', message_color)
		end
		sampSendChat('/fires')
		return false
	end

end
function sampev.onSendChat(text)
	if debug_mode then
		sampAddChatMessage('[FD DEBUG] {ffffff}' .. text, message_color)
	end
	local ignore = {
		[";)"] = true,
		[":D"] = true,
		[":O"] = true,
		[":|"] = true,
		[")"] = true,
		["))"] = true,
		["("] = true,
		["(("] = true,
		["xD"] = true,
		["q"] = true,
		["(+)"] = true,
		["(-)"] = true,
		[":)"] = true,
		[":("] = true,
		["=)"] = true,
		[":p"] = true,
		[";p"] = true,
		["(rofl)"] = true,
		["XD"] = true,
		["(agr)"] = true,
		["O.o"] = true,
		[">.<"] = true,
		[">:("] = true,
		["<3"] = true,
	}
	if ignore[text] then
		return {text}
	end
	if settings.general.rp_chat then
		text = text:sub(1, 1):rupper()..text:sub(2, #text) 
		if not text:find('(.+)%.') and not text:find('(.+)%!') and not text:find('(.+)%?') then
			text = text .. '.'
		end
	end
	if settings.general.accent_enable then
		text = settings.player_info.accent .. ' ' .. text 
	end
	return {text}
end
function sampev.onSendCommand(text)
	if debug_mode then
		sampAddChatMessage('[FD DEBUG] {ffffff}' .. text, message_color)
	end
	if settings.general.rp_chat then
		local chats =  { '/vr', '/fam', '/al', '/s', '/b', '/n', '/r', '/rb', '/f', '/fb', '/j', '/jb', '/m', '/do'} 
		for _, cmd in ipairs(chats) do
			if text:find('^'.. cmd .. ' ') then
				local cmd_text = text:match('^'.. cmd .. ' (.+)')
				if cmd_text ~= nil then
					cmd_text = cmd_text:sub(1, 1):rupper()..cmd_text:sub(2, #cmd_text)
					text = cmd .. ' ' .. cmd_text
					if not text:find('(.+)%.') and not text:find('(.+)%!') and not text:find('(.+)%?') then
						text = text .. '.'
					end
				end
			end
		end
	end
	return {text}
end
function sampev.onShowDialog(dialogid, style, title, button1, button2, text)
	
	if title:find('�������� ����������') and check_stats then -- ��������� ����������
		if text:find("{FFFFFF}���: {B83434}%[(.-)]") then
			settings.player_info.name_surname = TranslateNick(text:match("{FFFFFF}���: {B83434}%[(.-)]"))
			input_name_surname = imgui.new.char[256](u8(settings.player_info.name_surname))
			sampAddChatMessage('[FD Helper] {ffffff}���� ��� � ������� ����������, �� - ' .. settings.player_info.name_surname, message_color)
		end
		if text:find("{FFFFFF}���: {B83434}%[(.-)]") then
			settings.player_info.sex = text:match("{FFFFFF}���: {B83434}%[(.-)]")
			sampAddChatMessage('[FD Helper] {ffffff}��� ��� ���������, �� - ' .. settings.player_info.sex, message_color)
		end
		if text:find("{FFFFFF}�����������: {B83434}%[(.-)]") then
			settings.player_info.fraction = text:match("{FFFFFF}�����������: {B83434}%[(.-)]")
			if settings.player_info.fraction == '�� �������' then
				sampAddChatMessage('[FD Helper] {ffffff}�� �� �������� � �����������!',message_color)
				settings.player_info.fraction_tag = "����������"
			else
				sampAddChatMessage('[FD Helper] {ffffff}���� ����������� ����������, ���: '..settings.player_info.fraction, message_color)
				settings.player_info.fraction_tag = '��'
				settings.deportament.dep_tag1 = '[' .. settings.player_info.fraction_tag .. ']'
				input_dep_tag1 = imgui.new.char[32](u8(settings.deportament.dep_tag1))
				input_fraction_tag = imgui.new.char[256](u8(settings.player_info.fraction_tag))
				sampAddChatMessage('[FD Helper] {ffffff}����� ����������� �������� ��� '..settings.player_info.fraction_tag .. ". �� �� ������ �������� ���.", message_color)
			end
		end
		if text:find("{FFFFFF}���������: {B83434}(.+)%((%d+)%)") then
			settings.player_info.fraction_rank, settings.player_info.fraction_rank_number = text:match("{FFFFFF}���������: {B83434}(.+)%((%d+)%)(.+)������� �������")
			sampAddChatMessage('[FD Helper] {ffffff}���� ��������� ����������, ���: '..settings.player_info.fraction_rank.." ("..settings.player_info.fraction_rank_number..")", message_color)
			if tonumber(settings.player_info.fraction_rank_number) >= 9 then
				settings.general.auto_uval = true
				initialize_commands()
			end
		else
			settings.player_info.fraction_rank = "����������"
			settings.player_info.fraction_rank_number = 0
			sampAddChatMessage('[FD Helper] {ffffff}��������� ������, �� ���� �������� ��� ����!',message_color)
		end
		save_settings()
		sampSendDialogResponse(dialogid, 0, 0, 0)
		check_stats = false
		return false
	end

	if spawncar_bool and title:find('$') and text:find('����� ����������') then -- ����� ����������
		sampSendDialogResponse(dialogid, 1, 3, 0)
		spawncar_bool = false
		return false 
	end

	if title:find('�������� �����') then -- arz fastmenu
		sampSendDialogResponse(dialogid, 0, 2, 0)
		return false 
	end

	if members_check and title:find('(.+)%(� ����: (%d+)%)') then -- ������� 
	
        local count = 0
        local next_page = false
        local next_page_i = 0
		members_fraction = string.match(title, '(.+)%(� ����')
		members_fraction = string.gsub(members_fraction, '{(.+)}', '')
        for line in text:gmatch('[^\r\n]+') do
            count = count + 1
            if not line:find('���') and not line:find('��������') then

				line = line:gsub("{FFA500}%(��%)", "")
				line = line:gsub(" %/ � ���������", "")

				--line = line:gsub("  ", "")
				--local color, nickname, id, rank, rank_number, rank_time, warns, afk = string.match(line, "{(......)}(.+)%((%d+)%)(.+)%((%d+)%)(.+){FFFFFF}(%d+) %[%d+%] %/ (%d+) %d+ ��")

				-- if nickname:find('%[%:(.+)%] (.+)') then
				-- 	tag, nick = nickname:match('%[(.+)%] (.+)')
				-- 	nickname = nick
				-- end

				if line:find('{FFA500}%(%d+.+%)') then
					local color, nickname, id, rank, rank_number, color2, rank_time, warns, afk = string.match(line, "{(%x%x%x%x%x%x)}([%w_]+)%((%d+)%)%s*([^%(]+)%((%d+)%)%s*{(%x%x%x%x%x%x)}%(([^%)]+)%)%s*{FFFFFF}(%d+)%s*%[%d+%]%s*/%s*(%d+)%s*%d+ ��")
					if color ~= nil and nickname ~= nil and id ~= nil and rank ~= nil and rank_number ~= nil and warns ~= nil and afk ~= nil then
						local working = false
						if color:find('90EE90') then
							working = true
						end
						if rank_time then
							rank_number = rank_number .. ') (' .. rank_time
						end
						table.insert(members_new, { nick = nickname, id = id, rank = rank, rank_number = rank_number, warns = warns, afk = afk, working = working})
					end
				else
					local color, nickname, id, rank, rank_number, rank_time, warns, afk = string.match(line, "{(%x%x%x%x%x%x)}%s*([^%(]+)%((%d+)%)%s*([^%(]+)%((%d+)%)%s*([^{}]+){FFFFFF}%s*(%d+)%s*%[%d+%]%s*/%s*(%d+)%s*%d+ ��")
					if color ~= nil and nickname ~= nil and id ~= nil and rank ~= nil and rank_number ~= nil and warns ~= nil and afk ~= nil then
						local working = false
						if color:find('90EE90') then
							working = true
						end

						table.insert(members_new, { nick = nickname, id = id, rank = rank, rank_number = rank_number, warns = warns, afk = afk, working = working})
					end
				end
				
				
				
            end
            if line:match('��������� ��������') then
                next_page = true
                next_page_i = count - 2
            end
        end
        if next_page then
            sampSendDialogResponse(dialogid, 1, next_page_i, 0)
            next_page = false
            next_pagei = 0
		elseif #members_new ~= 0 then
            sampSendDialogResponse(dialogid, 0, 0, 0)
			members = members_new
			members_check = false
			MembersWindow[0] = true
		else
			sampSendDialogResponse(dialogid, 0, 0, 0)
			sampAddChatMessage('[FD Helper]{ffffff} ������ ����������� ����!', message_color)
			members_check = false
        end
        return false
    end

	if title:find('�������� ���� ��� (.+)') and text:find('��������') then -- invite
		sampSendDialogResponse(dialogid, 1, 0, 0)
		return false
	end

	if title:find('������ ������������') then
		if text:find('� ������ ������ ��� ��������') then
			sampAddChatMessage('[FD Helper] {ffffff}� ������ ������ ��� ��������, ������� ����', message_color)
			sampSendDialogResponse(dialogid, 1, 0, 0)
		else
			dialogid_fires = dialogid
			isFireDialog = true
			active_fire_locations = text:match('�������� �������\n(.+)') .. '\n'
			sampShowDialog(999, title, text, button1, button2, style)
		end
		
		return false
	end
	
end

imgui.OnInitialize(function()
	imgui.GetIO().IniFilename = nil
	if isMonetLoader() then
		fa.Init(14 * settings.general.custom_dpi)
	else
		fa.Init()
	end
	if settings.general.moonmonet_theme_enable and monet_no_errors then
		apply_moonmonet_theme()
	else 
		apply_dark_theme()
	end
end)
function change_dpi()
	if isMonetLoader() then
		
	else
		imgui.SetWindowFontScale(settings.general.custom_dpi)
	end
end
function give_rank()
	local command_find = false
			for _, command in ipairs(commands.commands_manage) do
				if command.enable and command.text:find('/giverank {arg_id}') then
					command_find = true
					local modifiedText = command.text
					local wait_tag = false
					local arg_id = player_id
					modifiedText = modifiedText:gsub('%{get_nick%(%{arg_id%}%)%}', sampGetPlayerNickname(arg_id) or "")
					modifiedText = modifiedText:gsub('%{get_rp_nick%(%{arg_id%}%)%}', sampGetPlayerNickname(arg_id):gsub('_',' ') or "")
					modifiedText = modifiedText:gsub('%{get_ru_nick%(%{arg_id%}%)%}', TranslateNick(sampGetPlayerNickname(arg_id)) or "")
					modifiedText = modifiedText:gsub('%{arg_id%}', arg_id or "")
					lua_thread.create(function()
						isActiveCommand = true
						if isMonetLoader() and settings.general.mobile_stop_button then
							sampAddChatMessage('[FD Helper] {ffffff}����� ���������� ��������� ������� ����������� ' .. message_color_hex .. '/stop {ffffff}��� ������� ������ ����� ������', message_color)
							CommandStopWindow[0] = true
						elseif not isMonetLoader() and hotkey_no_errors and settings.general.bind_command_stop and settings.general.use_binds then
							sampAddChatMessage('[FD Helper] {ffffff}����� ���������� ��������� ������� ����������� ' .. message_color_hex .. '/stop {ffffff}��� ������� ' .. message_color_hex .. getNameKeysFrom(settings.general.bind_command_stop), message_color)
						else
							sampAddChatMessage('[FD Helper] {ffffff}����� ���������� ��������� ������� ����������� ' .. message_color_hex .. '/stop', message_color)
						end
						local lines = {}
						for line in string.gmatch(modifiedText, "[^&]+") do
							table.insert(lines, line)
						end
						for _, line in ipairs(lines) do 
							if command_stop then 
								command_stop = false 
								isActiveCommand = false
								if isMonetLoader() and settings.general.mobile_stop_button then
									CommandStopWindow[0] = false
								end
								sampAddChatMessage('[FD Helper] {ffffff}��������� ������� /' .. command.cmd .. " ������� �����������!", message_color) 
								return 
							end
							if wait_tag then
								for tag, replacement in pairs(tagReplacements) do
									if line:find("{" .. tag .. "}") then
										local success, result = pcall(string.gsub, line, "{" .. tag .. "}", replacement())
										if success then
											line = result
										end
									end
								end
								sampSendChat(line)
								wait(1500)	
							end
							if not wait_tag then
								if line == '{show_rank_menu}' then
									wait_tag = true
								end
							end
						end
						isActiveCommand = false
						if isMonetLoader() and settings.general.mobile_stop_button then
							CommandStopWindow[0] = false
						end
					end)
				end
			end
			if not command_find then
				sampAddChatMessage('[FD Helper] {ffffff}���� ��� ��������� ����� ����������� ���� ��������!', message_color)
				sampAddChatMessage('[FD Helper] {ffffff}���������� �������� ��������� �������!', message_color)
				sampSendChat('/giverank ' .. player_id .. " " .. giverank[0])
			end
end

imgui.OnFrame(
    function() return MainWindow[0] end,
    function(player)
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(600 * settings.general.custom_dpi, 425	* settings.general.custom_dpi), imgui.Cond.FirstUseEver)
		imgui.Begin(fa.FIRE_EXTINGUISHER .. " FD Helper##main", MainWindow, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize )
		change_dpi()
		if imgui.BeginTabBar('���') then	
			if imgui.BeginTabItem(fa.HOUSE..u8' ������� ���� ') then
				if imgui.BeginChild('##1', imgui.ImVec2(589 * settings.general.custom_dpi, 171 * settings.general.custom_dpi), true) then
					imgui.CenterText(fa.USER_NURSE .. u8' ���������� ��� ����������')
					imgui.Separator()
					imgui.Columns(3)
					imgui.CenterColumnText(u8"��� � �������:")
					imgui.SetColumnWidth(-1, 230 * settings.general.custom_dpi)
					imgui.NextColumn()
					imgui.CenterColumnText(u8(settings.player_info.name_surname))
					imgui.SetColumnWidth(-1, 250 * settings.general.custom_dpi)
					imgui.NextColumn()
					if imgui.CenterColumnSmallButton(u8'��������##name_surname') then
						settings.player_info.name_surname = TranslateNick(sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))))
						input_name_surname = imgui.new.char[256](u8(settings.player_info.name_surname))
						save_settings()
						imgui.OpenPopup(fa.USER_NURSE .. u8' ��� � �������##name_surname')
					end
					if imgui.BeginPopupModal(fa.USER_NURSE .. u8' ��� � �������##name_surname', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize ) then
						if not isMonetLoader() then imgui.SetWindowFontScale(settings.general.custom_dpi) end
						imgui.PushItemWidth(405 * settings.general.custom_dpi)
						imgui.InputText(u8'##name_surname', input_name_surname, 256) 
						imgui.Separator()
						if imgui.Button(fa.CIRCLE_XMARK .. u8' ������', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
							imgui.CloseCurrentPopup()
						end
						imgui.SameLine()
						if imgui.Button(fa.FLOPPY_DISK .. u8' ���������', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
							settings.player_info.name_surname = u8:decode(ffi.string(input_name_surname))
							save_settings()
							imgui.CloseCurrentPopup()
						end
						imgui.End()
					end
					imgui.SetColumnWidth(-1, 100 * settings.general.custom_dpi)
					imgui.Columns(1)
					imgui.Separator()
					imgui.Columns(3)
					imgui.CenterColumnText(u8"���:")
					imgui.NextColumn()
					imgui.CenterColumnText(u8(settings.player_info.sex))
					imgui.NextColumn()
					if imgui.CenterColumnSmallButton(u8'��������##sex') then
						if settings.player_info.sex == '����������' then
							settings.player_info.sex = '�������'
							save_settings()
						elseif settings.player_info.sex == '�������' then
							settings.player_info.sex = '�������'
							save_settings()
						elseif settings.player_info.sex == '�������' then
							settings.player_info.sex = '�������'
							save_settings()
						end
					end
					imgui.Columns(1)
					imgui.Separator()
					imgui.Columns(3)
					imgui.CenterColumnText(u8"������:")
					imgui.NextColumn()
					if checkbox_accent_enable[0] then
						imgui.CenterColumnText(u8(settings.player_info.accent))
					else 
						imgui.CenterColumnText(u8'���������')
					end
					imgui.NextColumn()
					if imgui.CenterColumnSmallButton(u8'��������##accent') then
						imgui.OpenPopup(fa.USER_NURSE .. u8' ������ ���������##accent')
					end
					if imgui.BeginPopupModal(fa.USER_NURSE .. u8' ������ ���������##accent', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize  ) then
						if not isMonetLoader() then imgui.SetWindowFontScale(settings.general.custom_dpi) end
						if imgui.Checkbox('##checkbox_accent_enable', checkbox_accent_enable) then
							settings.general.accent_enable = checkbox_accent_enable[0]
							save_settings()
						end
						imgui.SameLine()
						imgui.PushItemWidth(375 * settings.general.custom_dpi)
						imgui.InputText(u8'##accent_input', input_accent, 256) 
						imgui.Separator()
						if imgui.Button(fa.CIRCLE_XMARK .. u8' ������', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
							imgui.CloseCurrentPopup()
						end
						imgui.SameLine()
						if imgui.Button(fa.FLOPPY_DISK .. u8' ���������', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then 
							settings.player_info.accent = u8:decode(ffi.string(input_accent))
							save_settings()
							imgui.CloseCurrentPopup()
						end
						imgui.End()
					end
					imgui.Columns(1)
					imgui.Separator()
					imgui.Columns(3)
					imgui.CenterColumnText(u8"�����������:")
					imgui.NextColumn()
					imgui.CenterColumnText(u8(settings.player_info.fraction))
					imgui.NextColumn()
					if imgui.CenterColumnSmallButton(u8'��������##fraction') then
						check_stats = true
						sampSendChat('/stats')
					end
					imgui.Columns(1)
					imgui.Separator()
					imgui.Columns(3)
					imgui.CenterColumnText(u8"��� �����������:")
					imgui.NextColumn()
					imgui.CenterColumnText(u8(settings.player_info.fraction_tag))
					imgui.NextColumn()
					if imgui.CenterColumnSmallButton(u8'��������##fraction_tag') then
						imgui.OpenPopup(fa.FIRE_EXTINGUISHER .. u8' ��� �����������##fraction_tag')
					end
					if imgui.BeginPopupModal(fa.FIRE_EXTINGUISHER .. u8' ��� �����������##fraction_tag', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize  ) then
						if not isMonetLoader() then imgui.SetWindowFontScale(settings.general.custom_dpi) end
						imgui.PushItemWidth(405 * settings.general.custom_dpi)
						imgui.InputText(u8'##input_fraction_tag', input_fraction_tag, 256)
						imgui.Separator()
						if imgui.Button(fa.CIRCLE_XMARK .. u8' ������', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
							imgui.CloseCurrentPopup()
						end
						imgui.SameLine()
						if imgui.Button(fa.FLOPPY_DISK .. u8' ���������', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
							settings.player_info.fraction_tag = u8:decode(ffi.string(input_fraction_tag))
							save_settings()
							imgui.CloseCurrentPopup()
						end
						imgui.End()
					end
					imgui.Columns(1)
					imgui.Separator()
					imgui.Columns(3)
					imgui.CenterColumnText(u8"��������� � �����������:")
					imgui.NextColumn()
					imgui.CenterColumnText(u8(settings.player_info.fraction_rank) .. " (" .. settings.player_info.fraction_rank_number .. ")")
					imgui.NextColumn()
					if imgui.CenterColumnSmallButton(u8"��������##rank") then
						check_stats = true
						sampSendChat('/stats')
					end
					imgui.Columns(1)
				
				imgui.EndChild()
				end
				if imgui.BeginChild('##2', imgui.ImVec2(589 * settings.general.custom_dpi, 52 * settings.general.custom_dpi), true) then
					imgui.CenterText(fa.ROBOT .. u8' ���������')
					imgui.Separator()
					imgui.Columns(2)
					imgui.CenterColumnText(u8("��� ����������� �������� ��� ������������� ��������� ��������"))
					imgui.SetColumnWidth(-1, 480 * settings.general.custom_dpi)
					imgui.NextColumn()
					if imgui.CenterColumnSmallButton(u8'����������') then
						imgui.OpenPopup(fa.ROBOT .. u8' ��������� ��� ������������� ��������� ����� ��������')
					end
					if imgui.BeginPopupModal(fa.ROBOT .. u8' ��������� ��� ������������� ��������� ����� ��������', _, imgui.WindowFlags.NoCollapse  + imgui.WindowFlags.NoResize ) then
						if not isMonetLoader() then imgui.SetWindowFontScale(settings.general.custom_dpi) end
						imgui.BeginChild('##ai', imgui.ImVec2(589 * settings.general.custom_dpi, 360 * settings.general.custom_dpi), true)
						if imgui.Checkbox(u8(' ���� �� PAYDAY �������� 5 �����, �� ���������� ��� ���� � ����'), checkbox_notify_payday) then
							settings.general.auto_notify_payday = checkbox_notify_payday[0]
							save_settings()
						end
						if imgui.Checkbox(u8(' �������������� ������ ����������� � /mb ������ 3 �������'), checkbox_update_members) then
							settings.general.auto_update_members = checkbox_update_members[0]
							save_settings()
						end
						if imgui.Checkbox(u8(' ���������� � ����� /r ��� �������� ������ �� /fires � ����� � ����'), checkbox_auto_doklad_1) then
							settings.general.auto_doklad_1 = checkbox_auto_doklad_1[0]
							save_settings()
						end
						if imgui.Checkbox(u8(' ���������� � ����� /r ��� �������� � ���� ������'), checkbox_auto_doklad_2) then
							settings.general.auto_doklad_2 = checkbox_auto_doklad_2[0]
							save_settings()
						end
						if imgui.Checkbox(u8(' ���������� � ����� /r ��� ���������� ������ ������'), checkbox_auto_doklad_3) then
							settings.general.auto_doklad_3 = checkbox_auto_doklad_3[0]
							save_settings()
						end
						if imgui.Checkbox(u8(' ���������� � ����� /r ��� ������� � ���� ������'), checkbox_auto_doklad_4) then
							settings.general.auto_doklad_4 = checkbox_auto_doklad_4[0]
							save_settings()
						end
						if imgui.Checkbox(u8(' ���������� � ����� /r ��� �������� ������������� � ���� ������'), checkbox_auto_doklad_5) then
							settings.general.auto_doklad_5 = checkbox_auto_doklad_5[0]
							save_settings()
						end
						if imgui.Checkbox(u8(' ���������� � ����� /r ��� ���������� ������'), checkbox_auto_doklad_6) then
							settings.general.auto_doklad_6 = checkbox_auto_doklad_6[0]
							save_settings()
						end
						if imgui.Checkbox(u8(' ���������� � ����� /r ��� ���� ������� � ������'), checkbox_auto_doklad_7) then
							settings.general.auto_doklad_7 = checkbox_auto_doklad_7[0]
							save_settings()
						end
						imgui.EndChild()
						if imgui.Button(fa.CIRCLE_XMARK .. u8" �������", imgui.ImVec2(589 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
							imgui.CloseCurrentPopup()
						end
						imgui.EndPopup()
					end
					imgui.SetColumnWidth(-1, 100 * settings.general.custom_dpi)
					imgui.Columns(1)
				imgui.EndChild()
				end
				if imgui.BeginChild('##3', imgui.ImVec2(589 * settings.general.custom_dpi, 97 * settings.general.custom_dpi), true) then
					imgui.CenterText(fa.SITEMAP .. u8' �������������� ������� �������')
					imgui.Separator()
					imgui.Columns(3)
					imgui.CenterColumnText(u8"RP ��������� ������������")
					imgui.SameLine(nil, 5) imgui.TextDisabled("[?]")
					if imgui.IsItemHovered() then
						imgui.SetTooltip(u8"��� �������������/������� ������ � ���� ����� RP ���������.")
					end
					imgui.SetColumnWidth(-1, 230 * settings.general.custom_dpi)
					imgui.NextColumn()
					if settings.general.rp_gun then
						imgui.CenterColumnText(u8'��������')
					else
						imgui.CenterColumnText(u8'���������')
					end
					imgui.SetColumnWidth(-1, 250 * settings.general.custom_dpi)
					imgui.NextColumn()
					if settings.general.rp_gun then
						if imgui.CenterColumnSmallButton(u8'���������##rp_gun') then
							settings.general.rp_gun = false
							save_settings()
						end
					else
						if imgui.CenterColumnSmallButton(u8'��������##rp_gun') then
							settings.general.rp_gun = true
							save_settings()
						end
					end
					imgui.SetColumnWidth(-1, 100 * settings.general.custom_dpi)
					imgui.Columns(1)
					imgui.Separator()
					imgui.Columns(3)
					imgui.CenterColumnText(u8"����� RP ������� � �����")
					imgui.SameLine(nil, 5) imgui.TextDisabled("[?]")
					if imgui.IsItemHovered() then
						imgui.SetTooltip(u8"��� ���� ��������� ����� � ��������� ����� � � ������ � �����.\n�������� � ������� ���� � ��������� ����� ������������ ��������:\n/r /rb /j /jb /m /s /b /n /do /vr /fam /al")
					end
					imgui.NextColumn()
					if settings.general.rp_chat then
						imgui.CenterColumnText(u8'��������')
					else
						imgui.CenterColumnText(u8'���������')
					end
					imgui.NextColumn()
					if settings.general.rp_chat then
						if imgui.CenterColumnSmallButton(u8'���������##rp_chat') then
							settings.general.rp_chat = false
							save_settings()
						end
						else
						if imgui.CenterColumnSmallButton(u8'��������##rp_chat') then
							settings.general.rp_chat = true
							save_settings()
						end
					end
					imgui.Columns(1)
					imgui.Separator()
					imgui.Columns(3)
					imgui.CenterColumnText(u8"�������������� ����")
					imgui.SameLine(nil, 5) imgui.TextDisabled("[?]")
					if imgui.IsItemHovered() then
						imgui.SetTooltip(u8"������� ������ ��� ������ ��� ��� ������������!\n��������� ������������� ��������� ��� ��� ������ ���\n� ������������� �� ������, ���� �������� ��������� � /rb")
					end
					imgui.NextColumn()
					if settings.general.auto_uval then
						imgui.CenterColumnText(u8'��������')
					else
						imgui.CenterColumnText(u8'���������')
					end
					imgui.NextColumn()
					if settings.general.auto_uval then
						if imgui.CenterColumnSmallButton(u8'���������##auto_uval') then
							settings.general.auto_uval = false
							save_settings()
						end
					else
						if imgui.CenterColumnSmallButton(u8'��������##auto_uval') then
							if tonumber(settings.player_info.fraction_rank_number) == 9 or tonumber(settings.player_info.fraction_rank_number) == 10 then 
								settings.general.auto_uval = true
								save_settings()
							else
								settings.general.auto_uval = false
								sampAddChatMessage('[FD Helper] {ffffff}��� ������� �������� ������ ������ � ������������!',message_color)
							end
						end
					end
					imgui.Columns(1)
					-- imgui.Separator()
				imgui.EndChild()
				end
				if imgui.BeginChild('##4', imgui.ImVec2(589 * settings.general.custom_dpi, 28 * settings.general.custom_dpi), true) then
					imgui.Columns(2)
					imgui.Text(fa.HAND_HOLDING_DOLLAR .. u8" �� ������ ��������� ���������� ������ ������� (MTG MODS) ������� " .. fa.HAND_HOLDING_DOLLAR)
					imgui.SetColumnWidth(-1, 480 * settings.general.custom_dpi)
					imgui.NextColumn()
					if imgui.CenterColumnSmallButton(u8'���������') then
						imgui.OpenPopup(fa.SACK_DOLLAR .. u8' ��������� ������������')
					end
					if imgui.BeginPopupModal(fa.SACK_DOLLAR .. u8' ��������� ������������', _, imgui.WindowFlags.NoCollapse  + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar) then
						change_dpi()
						if not isMonetLoader() then imgui.SetWindowFontScale(settings.general.custom_dpi) end
						imgui.CenterText(u8'��������� � MTG MODS:')
						--imgui.SetCursorPosX(20*settings.general.custom_dpi)
						if imgui.Button(u8('Telegram'), imgui.ImVec2(imgui.GetMiddleButtonX(2), 25 * settings.general.custom_dpi)) then
							openLink('https://t.me/mtg_mods')
						end
						imgui.SameLine()
						if imgui.Button(u8('Discord'), imgui.ImVec2(imgui.GetMiddleButtonX(2), 25 * settings.general.custom_dpi)) then
							openLink('https://discordapp.com/users/514135796685602827')
						end
						imgui.Separator()
						if imgui.Button(fa.CIRCLE_XMARK .. u8' �������', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
							imgui.CloseCurrentPopup()
						end
						imgui.End()
					end
					imgui.SetColumnWidth(-1, 100 * settings.general.custom_dpi)
					imgui.Columns(1)
					imgui.EndChild()
				end
				
				imgui.EndTabItem()
			end
			if imgui.BeginTabItem(fa.RECTANGLE_LIST..u8' ������� � ��������� ') then 
				if imgui.BeginTabBar('Tabs2') then
					if imgui.BeginTabItem(fa.BARS..u8' ����� RP ������� ��� ����') then 
						if imgui.BeginChild('##1', imgui.ImVec2(589 * settings.general.custom_dpi, 303 * settings.general.custom_dpi), true) then
							imgui.Columns(3)
							imgui.CenterColumnText(u8"�������")
							imgui.SetColumnWidth(-1, 170 * settings.general.custom_dpi)
							imgui.NextColumn()
							imgui.CenterColumnText(u8"��������")
							imgui.SetColumnWidth(-1, 300 * settings.general.custom_dpi)
							imgui.NextColumn()
							imgui.CenterColumnText(u8"��������")
							imgui.SetColumnWidth(-1, 150 * settings.general.custom_dpi)
							imgui.Columns(1)
							imgui.Separator()
							imgui.Columns(3)
							imgui.CenterColumnText(u8"/mb")
							imgui.NextColumn()
							imgui.CenterColumnText(u8"������� ���� ������ ������ /members")
							imgui.NextColumn()
							imgui.CenterColumnText(u8"����������")
							imgui.Columns(1)
							imgui.Separator()
							imgui.Columns(3)
							imgui.CenterColumnText(u8"/dep")
							imgui.NextColumn()
							imgui.CenterColumnText(u8"������� ���� ����� ������������")
							imgui.NextColumn()
							imgui.CenterColumnText(u8"����������")
							imgui.Columns(1)
							imgui.Separator()
							imgui.Columns(3)
							imgui.CenterColumnText(u8"/sob")
							imgui.NextColumn()
							imgui.CenterColumnText(u8"������� ���� ���������� �������������")
							imgui.NextColumn()
							imgui.CenterColumnText(u8"����������")
							imgui.Columns(1)
							imgui.Separator()
							imgui.Columns(3)
							imgui.CenterColumnText(u8"/stop")
							imgui.NextColumn()
							imgui.CenterColumnText(u8"������������� ��������� ����� RP �������")
							imgui.NextColumn()
							imgui.CenterColumnText(u8"����������")
							imgui.Columns(1)
							imgui.Separator()
							for index, command in ipairs(commands.commands) do
								imgui.Columns(3)
								if command.enable then
									imgui.CenterColumnText('/' .. u8(command.cmd))
									imgui.NextColumn()
									imgui.CenterColumnText(u8(command.description))
									imgui.NextColumn()
								else
									imgui.CenterColumnTextDisabled('/' .. u8(command.cmd))
									imgui.NextColumn()
									imgui.CenterColumnTextDisabled(u8(command.description))
									imgui.NextColumn()
								end
								imgui.Text(' ')
								imgui.SameLine()
								if command.enable then
									if imgui.SmallButton(fa.TOGGLE_ON .. '##'..command.cmd) then
										command.enable = not command.enable
										save_commands()
										sampUnregisterChatCommand(command.cmd)
									end
									if imgui.IsItemHovered() then
										imgui.SetTooltip(u8"���������� ������� /"..command.cmd)
									end
								else
									if imgui.SmallButton(fa.TOGGLE_OFF .. '##'..command.cmd) then
										command.enable = not command.enable
										save_commands()
										register_command(command.cmd, command.arg, command.text, tonumber(command.waiting))
									end
									if imgui.IsItemHovered() then
										imgui.SetTooltip(u8"��������� ������� /"..command.cmd)
									end
								end
								imgui.SameLine()
								if imgui.SmallButton(fa.PEN_TO_SQUARE .. '##'..command.cmd) then
									input_description = imgui.new.char[256](u8(command.description))
									change_arg = command.arg
									if command.arg == '' then
										ComboTags[0] = 0
									elseif command.arg == '{arg}' then	
										ComboTags[0] = 1
									elseif command.arg == '{arg_id}' then
										ComboTags[0] = 2
									elseif command.arg == '{arg_id} {arg2}' then
										ComboTags[0] = 3
									elseif command.arg == '{arg_id} {arg2} {arg3}' then
										ComboTags[0] = 4
									end
									change_cmd = command.cmd
									change_bind = command.bind
									input_cmd = imgui.new.char[256](u8(command.cmd))
									change_text = command.text:gsub('&', '\n')		
									input_text = imgui.new.char[8192](u8(change_text))
									change_waiting = command.waiting
									waiting_slider = imgui.new.float(tonumber(command.waiting))	
									BinderWindow[0] = true
								end
								if imgui.IsItemHovered() then
									imgui.SetTooltip(u8"��������� ������� /"..command.cmd)
								end
								imgui.SameLine()
								if imgui.SmallButton(fa.TRASH_CAN .. '##'..command.cmd) then
									imgui.OpenPopup(fa.TRIANGLE_EXCLAMATION .. u8' �������������� ##' .. command.cmd)
								end
								if imgui.IsItemHovered() then
									imgui.SetTooltip(u8"�������� ������� /"..command.cmd)
								end
								if imgui.BeginPopupModal(fa.TRIANGLE_EXCLAMATION .. u8' �������������� ##' .. command.cmd, _, imgui.WindowFlags.NoResize ) then
									if not isMonetLoader() then imgui.SetWindowFontScale(settings.general.custom_dpi) end
									imgui.CenterText(u8'�� ������������� ������ ������� ������� /' .. u8(command.cmd) .. '?')
									imgui.Separator()
									if imgui.Button(fa.CIRCLE_XMARK .. u8' ���, ��������', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
										imgui.CloseCurrentPopup()
									end
									imgui.SameLine()
									if imgui.Button(fa.TRASH_CAN .. u8' ��, �������', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
										sampUnregisterChatCommand(command.cmd)
										table.remove(commands.commands, index)
										save_commands()
										imgui.CloseCurrentPopup()
									end
									imgui.End()
								end
								imgui.Columns(1)
								imgui.Separator()
							end
							imgui.EndChild()
						end
						if imgui.Button(fa.CIRCLE_PLUS .. u8' ������� ����� �������##new_cmd',imgui.ImVec2(imgui.GetMiddleButtonX(1), 0)) then
							local new_cmd = {cmd = '', description = '', text = '', arg = '', enable = true , waiting = '1.500' , bind = "{}"  }
							binder_create_command_9_10 = false
							table.insert(commands.commands, new_cmd)
							input_description = imgui.new.char[256](u8(new_cmd.description))
							change_arg = new_cmd.arg
							change_bind = new_cmd.bind
							ComboTags[0] = 0
							change_cmd = new_cmd.cmd
							input_cmd = imgui.new.char[256](u8(new_cmd.cmd))
							change_text = new_cmd.text:gsub('&', '\n')
							input_text = imgui.new.char[8192](u8(change_text))
							change_waiting = 1.200
							waiting_slider = imgui.new.float(1.200)	
							BinderWindow[0] = true
						end
						imgui.EndTabItem()
					end
					if imgui.BeginTabItem(fa.BARS..u8' RP ������� ������ ��� 9/10') then 
						if tonumber(settings.player_info.fraction_rank_number) == 9 or tonumber(settings.player_info.fraction_rank_number) == 10 then
							if imgui.BeginChild('##1', imgui.ImVec2(589 * settings.general.custom_dpi, 303 * settings.general.custom_dpi), true) then
								imgui.Columns(3)
								imgui.CenterColumnText(u8"�������")
								imgui.SetColumnWidth(-1, 170 * settings.general.custom_dpi)
								imgui.NextColumn()
								imgui.CenterColumnText(u8"��������")
								imgui.SetColumnWidth(-1, 300 * settings.general.custom_dpi)
								imgui.NextColumn()
								imgui.CenterColumnText(u8"��������")
								imgui.SetColumnWidth(-1, 150 * settings.general.custom_dpi)
								imgui.Columns(1)
								imgui.Separator()
								imgui.Columns(3)
								imgui.CenterColumnText(u8"/spcar")
								imgui.NextColumn()
								imgui.CenterColumnText(u8"���������� ���������� �����������")
								imgui.NextColumn()
								imgui.CenterColumnText(u8"����������")
								imgui.Columns(1)
								imgui.Separator()	
								imgui.Columns(3)
								imgui.CenterColumnText(u8"/flm")
								imgui.NextColumn()
								imgui.CenterColumnText(u8"������� ������� ���� ���������� �������")
								imgui.NextColumn()
								imgui.CenterColumnText(u8"����������")
								imgui.Columns(1)
								imgui.Separator()	
								for index, command in ipairs(commands.commands_manage) do
									imgui.Columns(3)
									if command.enable then
										imgui.CenterColumnText('/' .. u8(command.cmd))
										imgui.NextColumn()
										imgui.CenterColumnText(u8(command.description))
										imgui.NextColumn()
									else
										imgui.CenterColumnTextDisabled('/' .. u8(command.cmd))
										imgui.NextColumn()
										imgui.CenterColumnTextDisabled(u8(command.description))
										imgui.NextColumn()
									end
									imgui.Text('  ')
									imgui.SameLine()
									if command.enable then
										if imgui.SmallButton(fa.TOGGLE_ON .. '##'..command.cmd) then
											command.enable = not command.enable
											save_commands()
											sampUnregisterChatCommand(command.cmd)
										end
										if imgui.IsItemHovered() then
											imgui.SetTooltip(u8"���������� ������� /"..command.cmd)
										end
									else
										if imgui.SmallButton(fa.TOGGLE_OFF .. '##'..command.cmd) then
											command.enable = not command.enable
											save_commands()
											register_command(command.cmd, command.arg, command.text, tonumber(command.waiting))
										end
										if imgui.IsItemHovered() then
											imgui.SetTooltip(u8"��������� ������� /"..command.cmd)
										end
									end
									imgui.SameLine()
									if imgui.SmallButton(fa.PEN_TO_SQUARE .. '##'..command.cmd) then
										input_description = imgui.new.char[256](u8(command.description))
										change_arg = command.arg
										if command.arg == '' then
											ComboTags[0] = 0
										elseif command.arg == '{arg}' then	
											ComboTags[0] = 1
										elseif command.arg == '{arg_id}' then
											ComboTags[0] = 2
										elseif command.arg == '{arg_id} {arg2}' then
											ComboTags[0] = 3
										elseif command.arg == '{arg_id} {arg2} {arg3}' then
											ComboTags[0] = 4
										end
										change_cmd = command.cmd
										change_bind = command.bind
										input_cmd = imgui.new.char[256](u8(command.cmd))
										change_text = command.text:gsub('&', '\n')
										input_text = imgui.new.char[8192](u8(change_text))
										binder_create_command_9_10 = true
										change_waiting = command.waiting
										waiting_slider = imgui.new.float( tonumber(command.waiting) )	
										BinderWindow[0] = true
									end
									if imgui.IsItemHovered() then
										imgui.SetTooltip(u8"��������� ������� /"..command.cmd)
									end
									imgui.SameLine()
									if imgui.SmallButton(fa.TRASH_CAN .. '##'..command.cmd) then
										imgui.OpenPopup(fa.TRIANGLE_EXCLAMATION .. u8' �������������� ##9-10' .. command.cmd)
									end
									if imgui.IsItemHovered() then	
										imgui.SetTooltip(u8"�������� ������� /"..command.cmd)
									end
									if imgui.BeginPopupModal(fa.TRIANGLE_EXCLAMATION .. u8' �������������� ##9-10' .. command.cmd, _, imgui.WindowFlags.NoResize ) then
										if not isMonetLoader() then imgui.SetWindowFontScale(settings.general.custom_dpi) end
										imgui.CenterText(u8'�� ������������� ������ ������� ������� /' .. u8(command.cmd) .. '?')
										imgui.Separator()
										if imgui.Button(fa.CIRCLE_XMARK .. u8' ���, ��������', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
											imgui.CloseCurrentPopup()
										end
										imgui.SameLine()
										if imgui.Button(fa.TRASH_CAN .. u8' ��, �������', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
											sampUnregisterChatCommand(command.cmd)
											table.remove(commands.commands_manage, index)
											save_commands()
											imgui.CloseCurrentPopup()
										end
										imgui.End()
									end
									imgui.Columns(1)
									imgui.Separator()
								end
								imgui.EndChild()
							end
							if imgui.Button(fa.CIRCLE_PLUS .. u8' ������� ����� �������##new_cmd_9-10', imgui.ImVec2(imgui.GetMiddleButtonX(1), 0)) then
								binder_create_command_9_10 = true
								local new_cmd = {cmd = '', description = '', text = '', arg = '', enable = true, waiting = '1.500', bind = "{}" }
								table.insert(commands.commands_manage, new_cmd)
								input_description = imgui.new.char[256](u8(new_cmd.description))
								change_arg = new_cmd.arg
								ComboTags[0] = 0
								change_cmd = new_cmd.cmd
								change_bind = new_cmd.bind
								input_cmd = imgui.new.char[256](u8(new_cmd.cmd))
								change_text = new_cmd.text:gsub('&', '\n')
								input_text = imgui.new.char[8192](u8(change_text))
								change_waiting = 1.200
								waiting_slider = imgui.new.float(1.200)	
								BinderWindow[0] = true
							end
						else
							imgui.CenterText(fa.TRIANGLE_EXCLAMATION)
							imgui.Separator()
							imgui.CenterText(u8"� ��� ��� ������� � ������ ��������!")
							imgui.CenterText(u8"���������� ����� 9 ��� 10 ����, � ��� �� "..settings.player_info.fraction_rank_number..u8" ����!")
							imgui.Separator()
						end
						imgui.EndTabItem() 
					end
					if imgui.BeginTabItem(fa.BARS..u8' �������������� �������') then 
						if imgui.BeginChild('##999', imgui.ImVec2(589 * settings.general.custom_dpi, 333 * settings.general.custom_dpi), true) then
							if isMonetLoader() then
								if imgui.Checkbox(u8(' ����������� ������ "����������" (������ /stop)'), checkbox_mobile_stop_button) then
									settings.general.mobile_stop_button = checkbox_mobile_stop_button[0]
									save_settings()
								end
							else
								imgui.CenterText(fa.KEYBOARD .. u8(' Hotkeys'))
								imgui.CenterText(u8('������������ ������������ ������� (�����) ������ ������� ����� �������'))
								imgui.CenterText(u8' ����������������� Hotkeys:')
								imgui.SameLine()
								if hotkey_no_errors then
									if settings.general.use_binds then
										if imgui.SmallButton(fa.TOGGLE_ON .. '##enable_binds') then
											settings.general.use_binds = not settings.general.use_binds
											save_settings()
										end
										if imgui.IsItemHovered() then
											imgui.SetTooltip(u8"��������� ������� ������")
										end
										if settings.general.use_binds and hotkey_no_errors then
											imgui.Separator()
											imgui.CenterText(u8'�������� �������� ���� ������� (������ /fh):')
											local width = imgui.GetWindowWidth()
											local calc = imgui.CalcTextSize(getNameKeysFrom(settings.general.bind_mainmenu))
											imgui.SetCursorPosX( width / 2 - calc.x / 2 )
											if MainMenuHotKey:ShowHotKey() then
												settings.general.bind_mainmenu = encodeJson(MainMenuHotKey:GetHotKey())
												save_settings()
											end
											imgui.Separator()
											imgui.CenterText(u8'�������� �������� ���� ���������� ������� (������ /flm):')
											imgui.CenterText(u8'��������� �� ������ ����� ��� � ������')
											local width = imgui.GetWindowWidth()
											local calc = imgui.CalcTextSize(getNameKeysFrom(settings.general.bind_leader_fastmenu))
											imgui.SetCursorPosX(width / 2 - calc.x / 2)
											if LeaderFastMenuHotKey:ShowHotKey() then
												settings.general.bind_leader_fastmenu = encodeJson(LeaderFastMenuHotKey:GetHotKey())
												save_settings()
											end
											imgui.Separator()
											imgui.CenterText(u8'������������� ��������� ������� (������ /stop):')
											local width = imgui.GetWindowWidth()
											local calc = imgui.CalcTextSize(getNameKeysFrom(settings.general.bind_command_stop))
											imgui.SetCursorPosX(width / 2 - calc.x / 2)
											if CommandStopHotKey:ShowHotKey() then
												settings.general.bind_command_stop = encodeJson(CommandStopHotKey:GetHotKey())
												save_settings()
											end
											imgui.Separator()
											imgui.CenterText(u8'��������� ����� ������� ��� ������ RP ������� � ������� �������������� �������')
										end
									else
										if imgui.SmallButton(fa.TOGGLE_OFF .. '##enable_binds') then
											settings.general.use_binds = not settings.general.use_binds
											save_settings()
										end
										if imgui.IsItemHovered() then
											imgui.SetTooltip(u8"�������� ������� ������")
										end
										imgui.Separator()
										imgui.CenterText(u8'������� ������� (������) ���������!')
									end
									
								else
									imgui.SameLine()
									imgui.SmallButton(fa.TOGGLE_OFF .. '##enable_binds')
									imgui.CenterText(fa.TRIANGLE_EXCLAMATION .. u8' ������: ���������� ����� ����������!')
								end
								
								if imgui.BeginPopupModal(fa.KEYBOARD .. u8' ��������� ������', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize  ) then
									imgui.SetWindowSizeVec2(imgui.ImVec2(600 * settings.general.custom_dpi, 415	* settings.general.custom_dpi))
									if not isMonetLoader() then imgui.SetWindowFontScale(settings.general.custom_dpi) end
									
									imgui.End()
								end
							end
							imgui.EndChild()
						end
						
						
					imgui.EndTabItem() 
				end
				imgui.EndTabBar() 
				end
				imgui.EndTabItem()
			end
			-- if imgui.BeginTabItem(fa.MONEY_CHECK_DOLLAR .. u8' ������ �� ������') then 
			-- 	if imgui.BeginChild('##premium', imgui.ImVec2(590 * settings.general.custom_dpi, 362 * settings.general.custom_dpi), true) then
			-- 		imgui.CenterText(fa.MONEY_CHECK_DOLLAR .. u8' ������� �������� ��� ������')
			-- 		imgui.Separator()
			-- 		imgui.CenterText(u8'�������� ����� � �������� �����������')
			-- 		imgui.EndChild()
			-- 	end
			-- imgui.EndTabItem()
			-- end
			if imgui.BeginTabItem(fa.FILE_PEN..u8' ������� (���������) ') then 
			 	imgui.BeginChild('##1', imgui.ImVec2(589 * settings.general.custom_dpi, 330 * settings.general.custom_dpi), true)
				imgui.Columns(2)
				imgui.CenterColumnText(u8"������ ���� ����� �������/���������:")
				imgui.SetColumnWidth(-1, 495 * settings.general.custom_dpi)
				imgui.NextColumn()
				imgui.CenterColumnText(u8"��������")
				imgui.SetColumnWidth(-1, 150 * settings.general.custom_dpi)
				imgui.Columns(1)
				imgui.Separator()
				for i, note in ipairs(notes.note) do
					imgui.Columns(2)
					imgui.CenterColumnText(u8(note.note_name))
					imgui.NextColumn()
					if imgui.SmallButton(fa.UP_RIGHT_FROM_SQUARE .. '##' .. i) then
						show_note_name = u8(note.note_name)
						show_note_text = u8(note.note_text)
						NoteWindow[0] = true
					end
					if imgui.IsItemHovered() then
						imgui.SetTooltip(u8'������� ������� "' .. u8(note.note_name) .. '"')
					end
					imgui.SameLine()
					if imgui.SmallButton(fa.PEN_TO_SQUARE .. '##' .. i) then
						local note_text = note.note_text:gsub('&','\n')
						input_text_note = imgui.new.char[16384](u8(note_text))
						input_name_note = imgui.new.char[256](u8(note.note_name))
						imgui.OpenPopup(fa.PEN_TO_SQUARE .. u8' ��������� �������' .. '##' .. i)	
					end
					if imgui.IsItemHovered() then
						imgui.SetTooltip(u8'�������������� ������� "' .. u8(note.note_name) .. '"')
					end
					if imgui.BeginPopupModal(fa.PEN_TO_SQUARE .. u8' ��������� �������' .. '##' .. i, _, imgui.WindowFlags.NoCollapse  + imgui.WindowFlags.NoResize ) then
						if not isMonetLoader() then imgui.SetWindowFontScale(settings.general.custom_dpi) end
						if imgui.BeginChild('##9992', imgui.ImVec2(589 * settings.general.custom_dpi, 360 * settings.general.custom_dpi), true) then	
							imgui.PushItemWidth(578 * settings.general.custom_dpi)
							imgui.InputText(u8'##note_name', input_name_note, 256)
							imgui.InputTextMultiline("##note_text", input_text_note, 16384, imgui.ImVec2(578 * settings.general.custom_dpi, 320 * settings.general.custom_dpi))
							imgui.EndChild()
						end	
						if imgui.Button(fa.CIRCLE_XMARK .. u8' ������', imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
							imgui.CloseCurrentPopup()
						end
						imgui.SameLine()
						if imgui.Button(fa.FLOPPY_DISK .. u8' ��������� �������', imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
							note.note_name = u8:decode(ffi.string(input_name_note))
							local temp = u8:decode(ffi.string(input_text_note))
							note.note_text = temp:gsub('\n', '&')
							save_notes()
							imgui.CloseCurrentPopup()
						end
						imgui.End()
					end
					imgui.SameLine()
					if imgui.SmallButton(fa.TRASH_CAN .. '##' .. i) then
						imgui.OpenPopup(fa.TRIANGLE_EXCLAMATION .. u8' �������������� ##' .. note.note_name)
					end
					if imgui.IsItemHovered() then
						imgui.SetTooltip(u8'�������� ������� "' .. u8(note.note_name) .. '"')
					end
					if imgui.BeginPopupModal(fa.TRIANGLE_EXCLAMATION .. u8' �������������� ##' .. note.note_name, _, imgui.WindowFlags.NoResize ) then
						if not isMonetLoader() then imgui.SetWindowFontScale(settings.general.custom_dpi) end
						imgui.CenterText(u8'�� ������������� ������ ������� ������� "' .. u8(note.note_name) .. '" ?')
						imgui.Separator()
						if imgui.Button(fa.CIRCLE_XMARK .. u8' ���, ��������', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
							imgui.CloseCurrentPopup()
						end
						imgui.SameLine()
						if imgui.Button(fa.TRASH_CAN .. u8' ��, �������', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
							table.remove(notes.note, i)
							save_notes()
							imgui.CloseCurrentPopup()
						end
						imgui.End()
					end
					imgui.Columns(1)
					imgui.Separator()
				end
				imgui.EndChild()
				if imgui.Button(fa.CIRCLE_PLUS .. u8' ������� ����� �������', imgui.ImVec2(imgui.GetMiddleButtonX(1), 0)) then
					input_name_note = imgui.new.char[256](u8("��������"))
					input_text_note = imgui.new.char[16384](u8("�����"))
					imgui.OpenPopup(fa.PEN_TO_SQUARE .. u8' �������� �������')	
				end
				if imgui.BeginPopupModal(fa.PEN_TO_SQUARE .. u8' �������� �������', _, imgui.WindowFlags.NoCollapse  + imgui.WindowFlags.NoResize ) then
					
					if imgui.BeginChild('##999999', imgui.ImVec2(589 * settings.general.custom_dpi, 360 * settings.general.custom_dpi), true) then	
						imgui.PushItemWidth(578 * settings.general.custom_dpi)
						imgui.InputText(u8'##note_name', input_name_note, 256)
						imgui.InputTextMultiline("##note_text", input_text_note, 16384, imgui.ImVec2(578 * settings.general.custom_dpi, 320 * settings.general.custom_dpi))
						imgui.EndChild()
					end	
					if imgui.Button(fa.CIRCLE_XMARK .. u8' ������', imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
						imgui.CloseCurrentPopup()
					end
					imgui.SameLine()
					if imgui.Button(fa.FLOPPY_DISK .. u8' ������� �������', imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
						local temp = u8:decode(ffi.string(input_text_note))
						local new_note = {note_name = u8:decode(ffi.string(input_name_note)), note_text = temp:gsub('\n', '&') }
						table.insert(notes.note, new_note)
						save_notes()
						imgui.CloseCurrentPopup()
					end
					imgui.End()
				end
				imgui.EndTabItem()
			end
			if imgui.BeginTabItem(fa.GEAR..u8' ��������� �������') then 
				imgui.BeginChild('##1', imgui.ImVec2(589 * settings.general.custom_dpi, 145 * settings.general.custom_dpi), true)
				imgui.CenterText(fa.CIRCLE_INFO .. u8' �������������� ���������� ��� ������')
				imgui.Separator()
				imgui.Text(fa.CIRCLE_USER..u8" ����������� ������� �������: MTG MODS")
				imgui.Separator()
				imgui.Text(fa.CIRCLE_INFO..u8" ������������� ������ �������: " .. u8(thisScript().version))
				imgui.Separator()
				imgui.Text(fa.BOOK ..u8" ���� �� ������������� �������:")
				imgui.SameLine()
				if imgui.SmallButton(u8'https://youtu.be/-q_5_2uWsc0') then
					openLink('https://youtu.be/-q_5_2uWsc0')
				end
				imgui.Separator()
				imgui.Text(fa.HEADSET..u8" ���.��������� �� �������:")
				imgui.SameLine()
				if imgui.SmallButton('https://discord.gg/qBPEYjfNhv') then
					openLink('https://discord.gg/qBPEYjfNhv')
				end
				imgui.Separator()
				imgui.Text(fa.GLOBE..u8" ���� ������� �� ������ BlastHack:")
				imgui.SameLine()
				if imgui.SmallButton(u8'https://www.blast.hk/threads/228070/') then
					openLink('https://www.blast.hk/threads/228070/')
				end
				imgui.EndChild()
				imgui.BeginChild('##3', imgui.ImVec2(589 * settings.general.custom_dpi, 87 * settings.general.custom_dpi), true)
				imgui.CenterText(fa.PALETTE .. u8' �������� ���� �������:')
				imgui.Separator()
				if imgui.RadioButtonIntPtr(u8" Dark Theme ", theme, 0) then	
					theme[0] = 0
                    message_color = 0x009EFF
                    message_color_hex = '{009EFF}'
					settings.general.moonmonet_theme_enable = false
					save_settings()
					
					apply_dark_theme()
				end
				if monet_no_errors then
					if imgui.RadioButtonIntPtr(u8" MoonMonet Theme ", theme, 1) then
						theme[0] = 1
						local r,g,b = mmcolor[0] * 255, mmcolor[1] * 255, mmcolor[2] * 255
						local argb = join_argb(0, r, g, b)
						settings.general.moonmonet_theme_enable = true
						settings.general.moonmonet_theme_color = argb
						message_color = "0x" .. argbToHexWithoutAlpha(0, r, g, b)
						message_color_hex = '{' .. argbToHexWithoutAlpha(0, r, g, b) .. '}'
						apply_moonmonet_theme()
						save_settings()
					end
					imgui.SameLine()
					if theme[0] == 1 and imgui.ColorEdit3('## COLOR', mmcolor, imgui.ColorEditFlags.NoInputs) then
						local r,g,b = mmcolor[0] * 255, mmcolor[1] * 255, mmcolor[2] * 255
						local argb = join_argb(0, r, g, b)
						-- settings.general.message_color = 
						-- settings.general.message_color_hex = 
						settings.general.moonmonet_theme_color = argb
						message_color = "0x" .. argbToHexWithoutAlpha(0, r, g, b)
						message_color_hex = '{' .. argbToHexWithoutAlpha(0, r, g, b) .. '}'
						if theme[0] == 1 then
							apply_moonmonet_theme()
							save_settings()
						end
					end
				else
					if imgui.RadioButtonIntPtr(u8" MoonMonet Theme | "..fa.TRIANGLE_EXCLAMATION .. u8' ������: ���������� ����� ����������!', theme, 1) then
						theme[0] = 0
					end
				end
				imgui.EndChild()
				imgui.BeginChild("##2",imgui.ImVec2(589 * settings.general.custom_dpi, 80 * settings.general.custom_dpi),true)
				imgui.CenterText(fa.MAXIMIZE .. u8' ������ ������� �������:')
				if settings.general.custom_dpi == slider_dpi[0] then
					
				else
					imgui.SameLine()
					if imgui.SmallButton(fa.CIRCLE_ARROW_RIGHT .. u8' ��������� � ���������') then
						settings.general.custom_dpi = slider_dpi[0]
						save_settings()
						sampAddChatMessage('[FD Helper] {ffffff}������������ ������� ��� ���������� ������� ����...', message_color)
						reload_script = true
						thisScript():reload()
					end
				end
				imgui.PushItemWidth(578 * settings.general.custom_dpi)
				imgui.SliderFloat('##2223233333333', slider_dpi, 0.5, 3) 
				imgui.Separator()
				imgui.CenterText(u8('���� ������� ������� "�������" �� ������, ��������� ������ � ��������� ��������'))
				imgui.EndChild()
				imgui.BeginChild("##4",imgui.ImVec2(589 * settings.general.custom_dpi, 35 * settings.general.custom_dpi),true)
				if imgui.Button(fa.POWER_OFF .. u8" ���������� ", imgui.ImVec2(imgui.GetMiddleButtonX(4), 25 * settings.general.custom_dpi)) then
					imgui.OpenPopup(fa.TRIANGLE_EXCLAMATION .. u8' �������������� ##off')
				end
				if imgui.BeginPopupModal(fa.TRIANGLE_EXCLAMATION .. u8' �������������� ##off', _, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar ) then
					if not isMonetLoader() then imgui.SetWindowFontScale(settings.general.custom_dpi) end
					imgui.CenterText(u8'�� ������������� ������ ��������� (���������) ������?')
					imgui.Separator()
					if imgui.Button(fa.CIRCLE_XMARK .. u8' ���, ��������', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
						imgui.CloseCurrentPopup()
					end
					imgui.SameLine()
					if imgui.Button(fa.POWER_OFF .. u8' ��, ���������', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
						reload_script = true
						play_error_sound()
						sampAddChatMessage('[FD Helper] {ffffff}������ ������������ ���� ������ �� ��������� ����� � ����!', message_color)
						if not isMonetLoader() then 
							sampAddChatMessage('[FD Helper] {ffffff}���� ����������� ' .. message_color_hex .. 'CTRL {ffffff}+ ' .. message_color_hex .. 'R {ffffff}����� ��������� ������.', message_color)
						end
						thisScript():unload()
					end
					imgui.End()
				end
				imgui.SameLine()
				if imgui.Button(fa.ROTATE_RIGHT .. u8" ������������ ", imgui.ImVec2(imgui.GetMiddleButtonX(4), 25 * settings.general.custom_dpi)) then
					reload_script = true
					thisScript():reload()
				end
				imgui.SameLine()
				if imgui.Button(fa.CLOCK_ROTATE_LEFT .. u8" ����� �������� ", imgui.ImVec2(imgui.GetMiddleButtonX(4), 25 * settings.general.custom_dpi)) then
					imgui.OpenPopup(fa.TRIANGLE_EXCLAMATION .. u8' �������������� ##reset')
				end
				if imgui.BeginPopupModal(fa.TRIANGLE_EXCLAMATION .. u8' �������������� ##reset', _, imgui.WindowFlags.NoResize ) then
					if not isMonetLoader() then imgui.SetWindowFontScale(settings.general.custom_dpi) end
					imgui.CenterText(u8'�� ������������� ������ �������� ��� ��������� �������?')
					imgui.Separator()
					if imgui.Button(fa.CIRCLE_XMARK .. u8' ���, ��������', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
						imgui.CloseCurrentPopup()
					end
					imgui.SameLine()
					if imgui.Button(fa.CLOCK_ROTATE_LEFT .. u8' ��, ��������', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
						os.remove(path_notes)
						os.remove(path_settings)
						os.remove(path_commands)
						imgui.CloseCurrentPopup()
						reload_script = true
						thisScript():reload()
					end
					imgui.End()
				end
				imgui.SameLine()
				if imgui.Button(fa.TRASH_CAN .. u8" �������� ", imgui.ImVec2(imgui.GetMiddleButtonX(4), 25 * settings.general.custom_dpi)) then
					imgui.OpenPopup(fa.TRIANGLE_EXCLAMATION .. u8' �������������� ##delete')
				end
				if imgui.BeginPopupModal(fa.TRIANGLE_EXCLAMATION .. u8' �������������� ##delete', _, imgui.WindowFlags.NoResize ) then
					if not isMonetLoader() then imgui.SetWindowFontScale(settings.general.custom_dpi) end
					imgui.CenterText(u8'�� ������������� ������ ������� FD Helper?')
					imgui.Separator()
					if imgui.Button(fa.CIRCLE_XMARK .. u8' ���, ��������', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
						imgui.CloseCurrentPopup()
					end
					imgui.SameLine()
					if imgui.Button(fa.TRASH_CAN .. u8' ��, � ���� �������', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
						sampAddChatMessage('[FD Helper] {ffffff}������ �������� ����� �� ������ ����������!', message_color)
						sampShowDialog(9998, message_color_hex .. "FD Helper", "�� ������� ������� FD Helper �� ������ ����������.\n���� �������� ������� � ���������� ������ �������������, � �� ������������ � ������ ��� ����������, ��\n�������� ��� ��� ������ ��������� ��� ������� ������ �� ����� Discord ������� ��� �� ������ BlastHack\n\nDiscord: https://discord.com/invite/qBPEYjfNhv\nBlastHack: https://www.blast.hk/threads/195388/\nTelegram @mtgmods\n\n���� ���, �� ������ ������ ������� � ���������� ������ � ����� ������ :)", "�������", '', 0)
						reload_script = true
						os.remove(path_helper)
						os.remove(path_settings)
						os.remove(path_commands)
						os.remove(path_notes)
						thisScript():unload()
					end
					imgui.End()
				end
				imgui.EndChild()
				imgui.EndTabItem()
			end
		imgui.EndTabBar() end
		imgui.End()
    end
)

imgui.OnFrame(
    function() return DeportamentWindow[0] end,
    function(player)
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.Begin(fa.WALKIE_TALKIE .. u8" ����� ������������", DeportamentWindow, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize)
		if not isMonetLoader() then imgui.SetWindowFontScale(settings.general.custom_dpi) end
		imgui.BeginChild('##2', imgui.ImVec2(589 * settings.general.custom_dpi, 160 * settings.general.custom_dpi), true)
		imgui.Columns(3)
		imgui.CenterColumnText(u8('��� ���:'))
		imgui.PushItemWidth(215 * settings.general.custom_dpi)
		if imgui.InputText('##input_dep_tag1', input_dep_tag1, 256) then
			settings.deportament.dep_tag1 = u8:decode(ffi.string(input_dep_tag1))
			save_settings()
		end
		if imgui.CenterColumnButton(u8('������� ���##1')) then
			imgui.OpenPopup(fa.TAG .. u8' ���� �����������##1')
		end
		if imgui.BeginPopupModal(fa.TAG .. u8' ���� �����������##1', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize) then
			if not isMonetLoader() then imgui.SetWindowFontScale(settings.general.custom_dpi) end
			if imgui.BeginTabBar('TabTags') then
				if imgui.BeginTabItem(fa.BARS..u8' ����������� ���� (ru) ') then 
					local line_started = false
					for i, tag in ipairs(settings.deportament.dep_tags) do
						if tag ~= 'skip' then
							if line_started then
								imgui.SameLine()
							else
								line_started = true
							end
							if imgui.Button(' ' .. u8(tag) .. ' ##' .. i) then
								input_dep_tag1 = imgui.new.char[256](u8(tag))
								settings.deportament.dep_tag1 = u8:decode(ffi.string(input_dep_tag1))
								save_settings()
								imgui.CloseCurrentPopup()
							end
						else
							line_started = false
						end
					end
					imgui.Separator()
					if imgui.Button(fa.CIRCLE_XMARK .. u8' �������', imgui.ImVec2( imgui.GetMiddleButtonX(1), 25 * settings.general.custom_dpi)) then
						imgui.CloseCurrentPopup()
					end
				imgui.EndTabItem() end
				if imgui.BeginTabItem(fa.BARS..u8' ����������� ���� (en) ') then 
					local line_started = false
					for i, tag in ipairs(settings.deportament.dep_tags_en) do
						if tag ~= 'skip' then
							if line_started then
								imgui.SameLine()
							else
								line_started = true
							end
							if imgui.Button(' ' .. u8(tag) .. ' ##' .. i) then
								input_dep_tag1 = imgui.new.char[256](u8(tag))
								settings.deportament.dep_tag1 = u8:decode(ffi.string(input_dep_tag1))
								save_settings()
								imgui.CloseCurrentPopup()
							end
						else
							line_started = false
						end
					end
					imgui.Separator()
					if imgui.Button(fa.CIRCLE_XMARK .. u8' �������', imgui.ImVec2( imgui.GetMiddleButtonX(1), 25 * settings.general.custom_dpi)) then
						imgui.CloseCurrentPopup()
					end
				imgui.EndTabItem() end
				if imgui.BeginTabItem(fa.BARS..u8' ���� ��������� ���� ') then 
					local line_started = false
					for i, tag in ipairs(settings.deportament.dep_tags_custom) do
						if tag ~= 'skip' then
							if line_started then
								imgui.SameLine()
							else
								line_started = true
							end
							if imgui.Button(' ' .. u8(tag) .. ' ##' .. i) then
								input_dep_tag1 = imgui.new.char[256](u8(tag))
								settings.deportament.dep_tag1 = u8:decode(ffi.string(input_dep_tag1))
								save_settings()
								imgui.CloseCurrentPopup()
							end
						else
							line_started = false
						end
					end
					imgui.Separator()
					if imgui.Button(fa.CIRCLE_PLUS .. u8' �������� ���', imgui.ImVec2( imgui.GetMiddleButtonX(2), 25 * settings.general.custom_dpi)) then
						imgui.OpenPopup(fa.TAG .. u8' ���������� ������ ����##1')	
					end
					if imgui.BeginPopupModal(fa.TAG .. u8' ���������� ������ ����##1', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize) then
						
						imgui.PushItemWidth(215 * settings.general.custom_dpi)
						imgui.InputText('##input_dep_new_tag', input_dep_new_tag, 256) 
						imgui.Separator()
						if imgui.Button(fa.CIRCLE_XMARK .. u8' ������', imgui.ImVec2( imgui.GetMiddleButtonX(2), 25 * settings.general.custom_dpi)) then
							imgui.CloseCurrentPopup()
						end
						imgui.SameLine()
						if imgui.Button(fa.FLOPPY_DISK .. u8' ���������', imgui.ImVec2( imgui.GetMiddleButtonX(2), 25 * settings.general.custom_dpi)) then
							table.insert(settings.deportament.dep_tags_custom, u8:decode(ffi.string(input_dep_new_tag)))
							save_settings()
							imgui.CloseCurrentPopup()
						end
						imgui.End()
					end
					imgui.SameLine()
					if imgui.Button(fa.CIRCLE_XMARK .. u8' �������', imgui.ImVec2( imgui.GetMiddleButtonX(2), 25 * settings.general.custom_dpi)) then
						imgui.CloseCurrentPopup()
					end
				imgui.EndTabItem() end
			imgui.EndTabBar() 
			end
			imgui.End()
		end
		imgui.SetColumnWidth(-1, 230 * settings.general.custom_dpi)
		imgui.NextColumn()
		imgui.CenterColumnText(u8('������� �����:'))
		imgui.PushItemWidth(140 * settings.general.custom_dpi)
		if imgui.InputText('##input_dep_fm', input_dep_fm, 256) then
			settings.deportament.dep_fm = u8:decode(ffi.string(input_dep_fm))
			save_settings()
		end
		if imgui.CenterColumnButton(u8('������� �������##1')) then
			imgui.OpenPopup(fa.WALKIE_TALKIE .. u8' ������� ��� ������������� ����� /d')
		end
		if imgui.BeginPopupModal(fa.WALKIE_TALKIE .. u8' ������� ��� ������������� ����� /d', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize) then
			imgui.SetWindowSizeVec2(imgui.ImVec2(400 * settings.general.custom_dpi, 95 * settings.general.custom_dpi))
			if not isMonetLoader() then imgui.SetWindowFontScale(settings.general.custom_dpi) end
			for i, tag in ipairs(settings.deportament.dep_fms) do
				imgui.SameLine()
				if imgui.Button(' ' .. u8(tag) .. ' ##' .. i) then
					input_dep_fm = imgui.new.char[256](u8(tag))
					settings.deportament.dep_fm = u8:decode(ffi.string(input_dep_fm))
					save_settings()
					imgui.CloseCurrentPopup()
				end
			end
			imgui.Separator()
			if imgui.Button(fa.CIRCLE_PLUS .. u8' �������� �������', imgui.ImVec2(imgui.GetMiddleButtonX(2), 25 * settings.general.custom_dpi)) then
				imgui.OpenPopup(fa.TAG .. u8' ���������� ����� �������##2')	
			end
			if imgui.BeginPopupModal(fa.TAG .. u8' ���������� ����� �������##2', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize) then
				--if not isMonetLoader() then imgui.SetWindowFontScale(settings.general.custom_dpi) end
				imgui.PushItemWidth(215 * settings.general.custom_dpi)
				imgui.InputText('##input_dep_new_tag', input_dep_new_tag, 256) 
				imgui.Separator()
				if imgui.Button(fa.CIRCLE_XMARK .. u8' ������', imgui.ImVec2(imgui.GetMiddleButtonX(2), 25 * settings.general.custom_dpi)) then
					imgui.CloseCurrentPopup()
				end
				imgui.SameLine()
				if imgui.Button(fa.FLOPPY_DISK .. u8' ���������', imgui.ImVec2( imgui.GetMiddleButtonX(2), 25 * settings.general.custom_dpi)) then
					table.insert(settings.deportament.dep_fms, u8:decode(ffi.string(input_dep_new_tag)))
					save_settings()
					imgui.CloseCurrentPopup()
				end
				imgui.End()
			end
			imgui.SameLine()
			if imgui.Button(fa.CIRCLE_XMARK .. u8' �������', imgui.ImVec2(imgui.GetMiddleButtonX(2), 25 * settings.general.custom_dpi)) then
				imgui.CloseCurrentPopup()
			end
			imgui.End()
		end
		imgui.SetColumnWidth(-1, 150 * settings.general.custom_dpi)
		imgui.NextColumn()
		imgui.CenterColumnText(u8('���, � ���� �� �����������:'))
		imgui.PushItemWidth(195 * settings.general.custom_dpi)
		if imgui.InputText('##input_dep_tag2', input_dep_tag2, 256) then
			settings.deportament.dep_tag2 = u8:decode(ffi.string(input_dep_tag2))
			save_settings()
		end
		if imgui.CenterColumnButton(u8('������� ���##2')) then
			imgui.OpenPopup(fa.TAG .. u8' ���� �����������##2')
		end
		if imgui.BeginPopupModal(fa.TAG .. u8' ���� �����������##2', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize) then
			if not isMonetLoader() then imgui.SetWindowFontScale(settings.general.custom_dpi) end
			if imgui.BeginTabBar('TabTags') then
				if imgui.BeginTabItem(fa.BARS..u8' ����������� ���� (ru) ') then 
					local line_started = false
					for i, tag in ipairs(settings.deportament.dep_tags) do
						if tag ~= 'skip' then
							if line_started then
								imgui.SameLine()
							else
								line_started = true
							end
							if imgui.Button(' ' .. u8(tag) .. ' ##' .. i) then
								input_dep_tag2 = imgui.new.char[256](u8(tag))
								settings.deportament.dep_tag2 = u8:decode(ffi.string(input_dep_tag2))
								save_settings()
								imgui.CloseCurrentPopup()
							end
						else
							line_started = false
						end
					end
					imgui.Separator()
					if imgui.Button(fa.CIRCLE_XMARK .. u8' �������', imgui.ImVec2( imgui.GetMiddleButtonX(1), 25 * settings.general.custom_dpi)) then
						imgui.CloseCurrentPopup()
					end
				imgui.EndTabItem() end
				if imgui.BeginTabItem(fa.BARS..u8' ����������� ���� (en) ') then 
					local line_started = false
					for i, tag in ipairs(settings.deportament.dep_tags_en) do
						if tag ~= 'skip' then
							if line_started then
								imgui.SameLine()
							else
								line_started = true
							end
							if imgui.Button(' ' .. u8(tag) .. ' ##' .. i) then
								input_dep_tag2 = imgui.new.char[256](u8(tag))
								settings.deportament.dep_tag2 = u8:decode(ffi.string(input_dep_tag2))
								save_settings()
								imgui.CloseCurrentPopup()
							end
						else
							line_started = false
						end
					end
					imgui.Separator()
					if imgui.Button(fa.CIRCLE_XMARK .. u8' �������', imgui.ImVec2( imgui.GetMiddleButtonX(1), 25 * settings.general.custom_dpi)) then
						imgui.CloseCurrentPopup()
					end
				imgui.EndTabItem() end
				if imgui.BeginTabItem(fa.BARS..u8' ���� ��������� ���� ') then 
					local line_started = false
					for i, tag in ipairs(settings.deportament.dep_tags_custom) do
						if tag ~= 'skip' then
							if line_started then
								imgui.SameLine()
							else
								line_started = true
							end
							if imgui.Button(' ' .. u8(tag) .. ' ##' .. i) then
								input_dep_tag2 = imgui.new.char[256](u8(tag))
								settings.deportament.dep_tag2 = u8:decode(ffi.string(input_dep_tag2))
								save_settings()
								imgui.CloseCurrentPopup()
							end
						else
							line_started = false
						end
					end
					imgui.Separator()
					if imgui.Button(fa.CIRCLE_PLUS .. u8' �������� ���', imgui.ImVec2( imgui.GetMiddleButtonX(2), 25 * settings.general.custom_dpi)) then
						imgui.OpenPopup(fa.TAG .. u8' ���������� ������ ����##2')	
					end
					if imgui.BeginPopupModal(fa.TAG .. u8' ���������� ������ ����##2', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize) then
						
						imgui.PushItemWidth(215 * settings.general.custom_dpi)
						imgui.InputText('##input_dep_new_tag', input_dep_new_tag, 256) 
						imgui.Separator()
						if imgui.Button(fa.CIRCLE_XMARK .. u8' ������', imgui.ImVec2( imgui.GetMiddleButtonX(2), 25 * settings.general.custom_dpi)) then
							imgui.CloseCurrentPopup()
						end
						imgui.SameLine()
						if imgui.Button(fa.FLOPPY_DISK .. u8' ���������', imgui.ImVec2( imgui.GetMiddleButtonX(2), 25 * settings.general.custom_dpi)) then
							table.insert(settings.deportament.dep_tags_custom, u8:decode(ffi.string(input_dep_new_tag)))
							save_settings()
							imgui.CloseCurrentPopup()
						end
						imgui.End()
					end
					imgui.SameLine()
					if imgui.Button(fa.CIRCLE_XMARK .. u8' �������', imgui.ImVec2( imgui.GetMiddleButtonX(2), 25 * settings.general.custom_dpi)) then
						imgui.CloseCurrentPopup()
					end
				imgui.EndTabItem() end
			imgui.EndTabBar() 
			end
			imgui.End()
		end
		imgui.SetColumnWidth(-1, 235 * settings.general.custom_dpi)
		imgui.Columns(1)
		imgui.Separator()
		imgui.CenterText(u8('�����:'))
		imgui.PushItemWidth(490 * settings.general.custom_dpi)
		imgui.InputText(u8'##dep_input_text', input_dep_text, 256)
		imgui.SameLine()
		if imgui.Button(u8' ��������� ') then
			sampSendChat('/d ' .. u8:decode(ffi.string(input_dep_tag1)) .. ' ' .. u8:decode(ffi.string(input_dep_fm)) .. ' ' ..  u8:decode(ffi.string(input_dep_tag2)) .. ': '  .. u8:decode(ffi.string(input_dep_text)))
		end
		imgui.Separator()
		imgui.CenterText(u8'������������: /d ' .. u8(u8:decode(ffi.string(input_dep_tag1))) .. ' ' .. u8(u8:decode(ffi.string(input_dep_fm))) .. ' ' ..  u8(u8:decode(ffi.string(input_dep_tag2))) .. ': '  .. u8(u8:decode(ffi.string(input_dep_text))) )
		imgui.EndChild()
		imgui.End()
    end
)

imgui.OnFrame(
    function() return BinderWindow[0] end,
    function(player)
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(600 * settings.general.custom_dpi, 425	* settings.general.custom_dpi), imgui.Cond.FirstUseEver)
		imgui.Begin(fa.PEN_TO_SQUARE .. u8' �������������� ������� /' .. change_cmd, BinderWindow, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize  )
		if not isMonetLoader() then imgui.SetWindowFontScale(settings.general.custom_dpi) end
		if imgui.BeginChild('##binder_edit', imgui.ImVec2(589 * settings.general.custom_dpi, 361 * settings.general.custom_dpi), true) then
			imgui.CenterText(fa.FILE_LINES .. u8' �������� �������:')
			imgui.PushItemWidth(579 * settings.general.custom_dpi)
			imgui.InputText("##input_description", input_description, 256)
			imgui.Separator()
			imgui.CenterText(fa.TERMINAL .. u8' ������� ��� ������������� � ���� (��� /):')
			imgui.PushItemWidth(579 * settings.general.custom_dpi)
			imgui.InputText("##input_cmd", input_cmd, 256)
			imgui.Separator()
			imgui.CenterText(fa.CODE .. u8' ��������� ������� ��������� �������:')
	    	imgui.Combo(u8'',ComboTags, ImItems, #item_list)
	 	    imgui.Separator()
	        imgui.CenterText(fa.FILE_WORD .. u8' ��������� ���� �������:')
			imgui.InputTextMultiline("##text_multiple", input_text, 8192, imgui.ImVec2(579 * settings.general.custom_dpi, 173 * settings.general.custom_dpi))
		imgui.EndChild() end
		if imgui.Button(fa.CIRCLE_XMARK .. u8' ������', imgui.ImVec2(imgui.GetMiddleButtonX(5), 0)) then
			BinderWindow[0] = false
		end
		imgui.SameLine()
		if imgui.Button(fa.CLOCK .. u8' ��������',imgui.ImVec2(imgui.GetMiddleButtonX(5), 0)) then
			imgui.OpenPopup(fa.CLOCK .. u8' �������� (� ��������) ')
		end
		if imgui.BeginPopupModal(fa.CLOCK .. u8' �������� (� ��������) ', _, imgui.WindowFlags.NoResize ) then
			
			imgui.PushItemWidth(200 * settings.general.custom_dpi)
			imgui.SliderFloat(u8'##waiting', waiting_slider, 0.3, 10)
			imgui.Separator()
			if imgui.Button(fa.CIRCLE_XMARK .. u8' ������', imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
				waiting_slider = imgui.new.float(tonumber(change_waiting))	
				imgui.CloseCurrentPopup()
			end
			imgui.SameLine()
			if imgui.Button(fa.FLOPPY_DISK .. u8' ���������', imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
				imgui.CloseCurrentPopup()
			end
			imgui.End()
		end
		imgui.SameLine()
		if imgui.Button(fa.TAGS .. u8' ����', imgui.ImVec2(imgui.GetMiddleButtonX(5), 0)) then
			imgui.OpenPopup(fa.TAGS .. u8' ���� ��� ������������� � �������')
		end
		if imgui.BeginPopupModal(fa.TAGS .. u8' ���� ��� ������������� � �������', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize  + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.AlwaysAutoResize ) then
			
			imgui.Text(u8(binder_tags_text))
			imgui.Separator()
			if imgui.Button(fa.CIRCLE_XMARK .. u8' �������', imgui.ImVec2(imgui.GetMiddleButtonX(1), 0)) then
				imgui.CloseCurrentPopup()
			end
			imgui.End()
		end
		imgui.SameLine()
		if imgui.Button(fa.KEYBOARD .. u8' ���� (��� ��)', imgui.ImVec2(imgui.GetMiddleButtonX(5), 0)) then
			if isMonetLoader() then
				sampAddChatMessage('[FD Helper] {ffffff}������ ������� ������� ������ �� ��!', message_color)
			else
				if hotkey_no_errors then
					if ComboTags[0] == 0 then
						if settings.general.use_binds then 
							imgui.OpenPopup(fa.KEYBOARD .. u8' ���� ��� ������� /' .. change_cmd)
						else
							sampAddChatMessage('[FD Helper] {ffffff}������� �������� ��������������� ������� � ������� � ��������� - ���. ������', message_color)
						end
					else
						sampAddChatMessage('[FD Helper] {ffffff}������ ������� ������� ������ ���� ������� "��� ����������"', message_color)
					end
				else
					sampAddChatMessage('[FD Helper] {ffffff}������ ������� ���������, ������� ���������� ����� ���������� mimgui_hotkeys!', message_color)
				end
			end
		end
		if imgui.BeginPopupModal(fa.KEYBOARD .. u8' ���� ��� ������� /' .. change_cmd, _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize  + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.AlwaysAutoResize) then
			
			local hotkeyObject = hotkeys[change_cmd .. "HotKey"]
			if hotkeyObject then
				imgui.CenterText(u8('������� ��������� �����:'))
				local calc
				if change_bind == '{}' or change_bind == '[]' then
					calc = imgui.CalcTextSize('< click and select keys >')
				else
					calc = imgui.CalcTextSize(getNameKeysFrom(change_bind))
				end
				
				local width = imgui.GetWindowWidth()
				imgui.SetCursorPosX(width / 2 - calc.x / 2)
				if hotkeyObject:ShowHotKey() then
					change_bind = encodeJson(hotkeyObject:GetHotKey())
					sampAddChatMessage('[FD Helper] {ffffff}������ ������ ��� ������� ' .. message_color_hex .. '/' .. change_cmd .. ' {ffffff}�� ������� '  .. message_color_hex .. getNameKeysFrom(change_bind), message_color)
				end
			else
				local hotkeyName = change_cmd.. "HotKey"
				hotkeys[hotkeyName] = hotkey.RegisterHotKey(hotkeyName, false, decodeJson(change_bind), function()
					sampProcessChatInput('/' .. change_cmd)
				end)
				--sampAddChatMessage('[FD Helper] {ffffff}������ ����� ������, ���������� ����������� ���������. �������� ������ ��� �������', message_color)
				--imgui.CloseCurrentPopup()
			end
			imgui.Separator()
			if imgui.Button(fa.CIRCLE_XMARK .. u8' �������', imgui.ImVec2(300 * settings.general.custom_dpi, 30 * settings.general.custom_dpi)) then
				imgui.CloseCurrentPopup()
			end
			imgui.End()
		end
		imgui.SameLine()
		if imgui.Button(fa.FLOPPY_DISK .. u8' ���������', imgui.ImVec2(imgui.GetMiddleButtonX(5), 0)) then	
			if ffi.string(input_cmd):find('%W') or ffi.string(input_cmd) == '' or ffi.string(input_description) == '' or ffi.string(input_text) == '' then
				imgui.OpenPopup(fa.TRIANGLE_EXCLAMATION .. u8' ������ ���������� �������!')
			else
				local new_arg = ''
				if ComboTags[0] == 0 then
					new_arg = ''
				elseif ComboTags[0] == 1 then
					new_arg = '{arg}'
				elseif ComboTags[0] == 2 then
					new_arg = '{arg_id}'
				elseif ComboTags[0] == 3 then
					new_arg = '{arg_id} {arg2}'
                elseif ComboTags[0] == 4 then
					new_arg = '{arg_id} {arg2} {arg3}'
				end
				local new_waiting = waiting_slider[0]
				local new_bind = change_bind
				local new_description = u8:decode(ffi.string(input_description))
				local new_command = u8:decode(ffi.string(input_cmd))
				local new_text = u8:decode(ffi.string(input_text)):gsub('\n', '&')
				local temp_array = {}
				if binder_create_command_9_10 then
					temp_array = commands.commands_manage
					binder_create_command_9_10 = false
				else
					temp_array = commands.commands
				end
				for _, command in ipairs(temp_array) do
					if command.cmd == change_cmd and command.arg == change_arg and command.text:gsub('&', '\n') == change_text then
						command.cmd = new_command
						command.arg = new_arg
						command.description = new_description
						command.text = new_text
						command.bind = new_bind
						command.waiting = new_waiting
						command.enable = true
						save_commands()
						if command.arg == '' then
							sampAddChatMessage('[FD Helper] {ffffff}������� ' .. message_color_hex .. '/' .. new_command .. ' {ffffff}������� ���������!', message_color)
						elseif command.arg == '{arg}' then
							sampAddChatMessage('[FD Helper] {ffffff}������� ' .. message_color_hex .. '/' .. new_command .. ' [��������] {ffffff}������� ���������!', message_color)
						elseif command.arg == '{arg_id}' then
							sampAddChatMessage('[FD Helper] {ffffff}������� ' .. message_color_hex .. '/' .. new_command .. ' [ID ������] {ffffff}������� ���������!', message_color)
						elseif command.arg == '{arg_id} {arg2}' then
							sampAddChatMessage('[FD Helper] {ffffff}������� ' .. message_color_hex .. '/' .. new_command .. ' [ID ������] [��������] {ffffff}������� ���������!', message_color)
						elseif command.arg == '{arg_id} {arg2} {arg3}' then
							sampAddChatMessage('[FD Helper] {ffffff}������� ' .. message_color_hex .. '/' .. new_command .. ' [ID ������] [��������] [��������] {ffffff}������� ���������!', message_color)
						end
						sampUnregisterChatCommand(change_cmd)
						register_command(command.cmd, command.arg, command.text, tonumber(command.waiting))
						break
					end
				end
				BinderWindow[0] = false
			end
		end
		if imgui.BeginPopupModal(fa.TRIANGLE_EXCLAMATION .. u8' ������ ���������� �������!', _, imgui.WindowFlags.AlwaysAutoResize ) then
			if not isMonetLoader() then imgui.SetWindowFontScale(settings.general.custom_dpi) end
			if ffi.string(input_cmd):find('%W') then
				imgui.BulletText(u8" � ������� ����� ������������ ������ ����. ����� �/��� �����!")
			elseif ffi.string(input_cmd) == '' then
				imgui.BulletText(u8" ������� �� ����� ���� ������!")
			end
			if ffi.string(input_description) == '' then
				imgui.BulletText(u8" �������� ������� �� ����� ���� ������!")
			end
			if ffi.string(input_text) == '' then
				imgui.BulletText(u8" ���� ������� �� ����� ���� ������!")
			end
			imgui.Separator()
			if imgui.Button(fa.CIRCLE_XMARK .. u8' �������', imgui.ImVec2(300 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
				imgui.CloseCurrentPopup()
			end
			imgui.End()
		end	
		imgui.End()
    end
)

imgui.OnFrame(
    function() return MembersWindow[0] end,
    function(player)
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		if tonumber(#members) >= 16 then
			sizeYY = 413
		else
			sizeYY = 24.5 * ( tonumber(#members) + 1 )
		end
		imgui.SetNextWindowSize(imgui.ImVec2(600 * settings.general.custom_dpi, sizeYY * settings.general.custom_dpi), imgui.Cond.FirstUseEver)
		--imgui.SetNextWindowSize(imgui.ImVec2(600 * settings.general.custom_dpi, 413 * settings.general.custom_dpi), imgui.Cond.FirstUseEver)
		imgui.Begin(fa.BUILDING_SHIELD .. " " ..  u8(members_fraction) .. " - " .. #members .. u8' ����������� ������', MembersWindow, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize )
		if not isMonetLoader() then imgui.SetWindowFontScale(settings.general.custom_dpi) end
		for i, v in ipairs(members) do
			imgui.Columns(3)
			if v.working then
				imgui_RGBA = imgui.ImVec4(1, 1, 1, 1) -- white
			else
				imgui_RGBA = imgui.ImVec4(1, 0.231, 0.231, 1) -- red
			end
			if tonumber(v.afk) > 0 and tonumber(v.afk) < 60 then
				imgui.CenterColumnColorText(imgui_RGBA, u8(v.nick) .. ' [' .. v.id .. '] [AFK ' .. v.afk .. 's]')
			elseif tonumber(v.afk) >= 60 then
				imgui.CenterColumnColorText(imgui_RGBA, u8(v.nick) .. ' [' .. v.id .. '] [AFK ' .. math.floor( tonumber(v.afk) / 60 ) .. 'm]')
			else
				imgui.CenterColumnColorText(imgui_RGBA, u8(v.nick) .. ' [' .. v.id .. ']')
			end
			if imgui.IsItemClicked() and tonumber(settings.player_info.fraction_rank_number) >= 9 then 
				show_leader_fast_menu(v.id)
				MembersWindow[0] = false
			end
			imgui.SetColumnWidth(-1, 300 * settings.general.custom_dpi)
			imgui.NextColumn()
			imgui.CenterColumnText(u8(v.rank) .. ' (' .. u8(v.rank_number) .. ')')
			imgui.SetColumnWidth(-1, 230 * settings.general.custom_dpi)
			imgui.NextColumn()
			imgui.CenterColumnText(u8(v.warns .. '/3'))
			imgui.SetColumnWidth(-1, 75 * settings.general.custom_dpi)
			imgui.Columns(1)
			imgui.Separator()
		end
		imgui.End()
    end
)

imgui.OnFrame(
    function() return NoteWindow[0] end,
    function(player)
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.Begin(fa.FILE_PEN .. ' '.. show_note_name, NoteWindow, imgui.WindowFlags.AlwaysAutoResize )
		if not isMonetLoader() then imgui.SetWindowFontScale(settings.general.custom_dpi) end
		imgui.Text(show_note_text:gsub('&','\n'))
		imgui.Separator()
		if imgui.Button(fa.CIRCLE_XMARK .. u8' �������', imgui.ImVec2(imgui.GetMiddleButtonX(1), 25 * settings.general.custom_dpi)) then
			NoteWindow[0] = false
		end
		imgui.End()
    end
)

imgui.OnFrame(
    function() return LeaderFastMenu[0] end,
    function(player)
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.Begin(fa.USER..' '..sampGetPlayerNickname(player_id)..' ['..player_id..']##LeaderFastMenu', LeaderFastMenu, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.AlwaysAutoResize  )
		if not isMonetLoader() then imgui.SetWindowFontScale(settings.general.custom_dpi) end
		for _, command in ipairs(commands.commands_manage) do
			if command.enable and command.arg == '{arg_id}' then
				if imgui.Button(u8(command.description), imgui.ImVec2(290 * settings.general.custom_dpi, 30 * settings.general.custom_dpi)) then
					sampProcessChatInput("/" .. command.cmd .. " " .. player_id)
					LeaderFastMenu[0] = false
				end
			end
		end
		if not isMonetLoader() then
			if imgui.Button(u8"������ �������",imgui.ImVec2(290 * settings.general.custom_dpi, 30 * settings.general.custom_dpi)) then
				sampSetChatInputEnabled(true)
				sampSetChatInputText('/vig '..player_id..' ')
				LeaderFastMenu[0] = false
			end
			if imgui.Button(u8"������� �� �����������",imgui.ImVec2(290 * settings.general.custom_dpi, 30 * settings.general.custom_dpi)) then
				sampSetChatInputEnabled(true)
				sampSetChatInputText('/uval '..player_id..' ')
				LeaderFastMenu[0] = false
			end
		end
		imgui.End()
    end
)

imgui.OnFrame(
    function() return GiveRankMenu[0] end,
    function(player)
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.Begin(fa.FIRE_EXTINGUISHER.." FD Helper##rank", GiveRankMenu, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize  + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.AlwaysAutoResize)
		if not isMonetLoader() then imgui.SetWindowFontScale(settings.general.custom_dpi) end
		imgui.CenterText(u8'�������� ���� ��� '.. sampGetPlayerNickname(player_id) .. ':')
		imgui.PushItemWidth(250 * settings.general.custom_dpi)
		imgui.SliderInt('', giverank, 1, 9)
		imgui.Separator()
		local text
		if isMonetLoader() then
			text = " ������ ����"
		else
			text = " ������ ���� [Enter]"
		end
		if imgui.Button(fa.USER_NURSE .. u8(text) , imgui.ImVec2(imgui.GetMiddleButtonX(1), 0)) then
			give_rank()
			GiveRankMenu[0] = false
		end
		imgui.End()
    end
)

imgui.OnFrame(
    function() return CommandStopWindow[0] end,
    function(player)
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY - 50 * settings.general.custom_dpi), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.Begin(fa.FIRE_EXTINGUISHER .. " FD Helper##CommandStopWindow", _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize  + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.AlwaysAutoResize )
		if not isMonetLoader() then imgui.SetWindowFontScale(settings.general.custom_dpi) end
		if isMonetLoader() and isActiveCommand then
			if imgui.Button(fa.CIRCLE_STOP..u8' ���������� ��������� ') then
				command_stop = true 
				CommandStopWindow[0] = false
			end
		else
			CommandStopWindow[0] = false
		end
		imgui.End()
    end
)

imgui.OnFrame(
    function() return CommandPauseWindow[0] end,
    function(player)
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY - 50 * settings.general.custom_dpi), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.Begin(fa.FIRE_EXTINGUISHER.." FD Helper##CommandPauseWindow", _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize  + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.AlwaysAutoResize )
		if not isMonetLoader() then imgui.SetWindowFontScale(settings.general.custom_dpi) end
		if command_pause then
			if imgui.Button(fa.CIRCLE_ARROW_RIGHT .. u8' ���������� ', imgui.ImVec2(150 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
				command_pause = false
				CommandPauseWindow[0] = false
			end
			imgui.SameLine()
			if imgui.Button(fa.CIRCLE_XMARK .. u8' ������ STOP ', imgui.ImVec2(150 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
				command_stop = true 
				command_pause = false
				CommandPauseWindow[0] = false
			end
		else
			CommandPauseWindow[0] = false
		end
		imgui.End()
    end
)

imgui.OnFrame(
    function() return SobesMenu[0] end,
    function(player)
		if player_id ~= nil and isParamSampID(player_id) then
			imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
			imgui.Begin(fa.PERSON_CIRCLE_CHECK..u8' ���������� ������������� ������ ' .. sampGetPlayerNickname(player_id), SobesMenu, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize)
			if not isMonetLoader() then imgui.SetWindowFontScale(settings.general.custom_dpi) end
			if imgui.BeginChild('sobes1', imgui.ImVec2(240 * settings.general.custom_dpi, 182 * settings.general.custom_dpi), true) then
			imgui.CenterColumnText(fa.BOOKMARK .. u8" ��������")
			imgui.Separator()
			if imgui.Button(fa.PLAY .. u8" ������ �������������", imgui.ImVec2(-1, 25 * settings.general.custom_dpi)) then
				lua_thread.create(function()
					sampSendChat("������������, � " .. settings.player_info.name_surname .. " - " .. settings.player_info.fraction_rank .. ' ' .. settings.player_info.fraction_tag)
					wait(2000)
					sampSendChat("�� ������ � ��� �� �������������?")
				end)
			end
			if imgui.Button(fa.PASSPORT .. u8" ��������� ���������", imgui.ImVec2(-1, 25 * settings.general.custom_dpi)) then
				lua_thread.create(function()
					sampSendChat("������, ������������ ��� ��� ���� ��������� ��� ��������.")
					wait(2000)
					sampSendChat("��� ����� ��� �������, ���.����� � ��������.")
					wait(2000)
					sampSendChat("/n " .. sampGetPlayerNickname(player_id) .. ", ����������� /showpass [ID] , /showmc [ID] , /showlic [ID]")
					wait(2000)
					sampSendChat("/n ����������� � RP �����������!")
				end)
			end
			if imgui.Button(fa.USER .. u8" ���������� � ����", imgui.ImVec2(-1, 25 * settings.general.custom_dpi)) then
				sampSendChat("������� ���������� � ����.")
			end
			
			if imgui.Button(fa.CHECK .. u8" ������������� ��������", imgui.ImVec2(-1, 25 * settings.general.custom_dpi)) then
				sampSendChat("/todo ����������! �� ������� ������ �������������!*��������")
			end
			if imgui.Button(fa.USER_PLUS .. u8" ���������� � �����������", imgui.ImVec2(-1, 25 * settings.general.custom_dpi)) then
				find_and_use_command('/invite {arg_id}', player_id)
				SobesMenu[0] = false
			end
			imgui.EndChild()
			end
			imgui.SameLine()
			if imgui.BeginChild('sobes2', imgui.ImVec2(240 * settings.general.custom_dpi, 182 * settings.general.custom_dpi), true) then
				imgui.CenterColumnText(fa.BOOKMARK..u8" �������������")
				imgui.Separator()
				if imgui.Button(fa.GLOBE .. u8" ������� ����.����� Discord", imgui.ImVec2(-1, 25 * settings.general.custom_dpi)) then
					sampSendChat("������� �� � ��� ����. ����� Discord ������ �����?")
				end
				if imgui.Button(fa.CIRCLE_QUESTION .. u8" ������� ����� ������", imgui.ImVec2(-1, 25 * settings.general.custom_dpi)) then
					sampSendChat("������� �� � ��� ���� ������ � ����� �����?")
				end
				if imgui.Button(fa.CIRCLE_QUESTION .. u8" ������ ������ ��?", imgui.ImVec2(-1, 25 * settings.general.custom_dpi)) then
					sampSendChat("������� ������ �� ������� ������ ���?")
				end
				if imgui.Button(fa.CIRCLE_QUESTION .. u8" ��� ����� ������������?", imgui.ImVec2(-1, 25 * settings.general.custom_dpi)) then
					sampSendChat("������� ��� �� ������ ������ \"������������\"?")
				end
				if imgui.Button(fa.CIRCLE_QUESTION .. u8" ��� ����� ��?", imgui.ImVec2(-1, 25 * settings.general.custom_dpi)) then
					sampSendChat("������� ��� �� �������, ��� ����� \"��\"?")
				end
			imgui.EndChild()
			end
			imgui.SameLine()
			if imgui.BeginChild('sobes3', imgui.ImVec2(150 * settings.general.custom_dpi, -1), true) then
				imgui.CenterColumnText(fa.CIRCLE_XMARK .. u8" ������")
				imgui.Separator()
				if imgui.Selectable(u8"���� ��������") then
					lua_thread.create(function ()
						SobesMenu[0] = false
						sampSendChat("/todo � ���������, �� ��� �� ���������*� �������������� �� ����")
						wait(2000)
						sampSendChat("� ��� ���� ��������.")
						wait(2000)
						sampSendChat("�������� ������� � ���������� ����� �� 1 ����� �����.")
					end)
				end
				if imgui.Selectable(u8"���� ���.�����") then
					lua_thread.create(function ()
						SobesMenu[0] = false
						sampSendChat("/todo � ���������, �� ��� �� ���������*� �������������� �� ����")
						wait(2000)
						sampSendChat("� ��� ���� ���.�����, �������� � � ����� ��������.")
					end)
				end
                if imgui.Selectable(u8"�����������������") then
					lua_thread.create(function ()
						SobesMenu[0] = false
						sampSendChat("/todo � ���������, �� ��� �� ���������*� �������������� �� ����")
						wait(2000)
						sampSendChat("� ��� ������ �����������������.")
						wait(2000)
						sampSendChat("/n ���������� ����� ������� 35 �����������������!")
					end)
				end
				if imgui.Selectable(u8"�����������������") then
					lua_thread.create(function ()
						SobesMenu[0] = false
						sampSendChat("/todo � ���������, �� ��� �� ���������*� �������������� �� ����")
						wait(2000)
						sampSendChat("�� ���������������, ������� ��� ���������� ���������� � ��������!")
					end)
				end	
				if imgui.Selectable(u8"�������� ��������") then
					lua_thread.create(function ()
						SobesMenu[0] = false
						sampSendChat("/todo � ���������, �� ��� �� ���������*� �������������� �� ����")
						wait(2000)
						sampSendChat("� ��� ���� ��������, �� �� ������ ���������� � ���!")
						wait(2000)
						sampSendChat("�� ������ ���������� � ��, ���� � �������� �������� ������������")
					end)
				end
				if imgui.Selectable(u8"����.�������������") then
					lua_thread.create(function ()
						SobesMenu[0] = false
						sampSendChat("/todo � ���������, �� ��� �� ���������*� �������������� �� ����")
						wait(2000)
						sampSendChat("�� �� ��������� ��� ����� ������ �� ���������������� ���������.")
					end)
				end
			end
			imgui.EndChild()
		else
			sampAddChatMessage('[FD Helper] {ffffff}��������� ������, ID ������ ��������������!', message_color)
			SobesMenu[0] = false
		end
    end
)

function imgui.CenterText(text)
    local width = imgui.GetWindowWidth()
    local calc = imgui.CalcTextSize(text)
    imgui.SetCursorPosX( width / 2 - calc.x / 2 )
    imgui.Text(text)
end
function imgui.CenterTextDisabled(text)
    local width = imgui.GetWindowWidth()
    local calc = imgui.CalcTextSize(text)
    imgui.SetCursorPosX( width / 2 - calc.x / 2 )
    imgui.TextDisabled(text)
end
function imgui.CenterColumnText(text)
    imgui.SetCursorPosX((imgui.GetColumnOffset() + (imgui.GetColumnWidth() / 2)) - imgui.CalcTextSize(text).x / 2)
    imgui.Text(text)
end
function imgui.CenterColumnTextDisabled(text)
    imgui.SetCursorPosX((imgui.GetColumnOffset() + (imgui.GetColumnWidth() / 2)) - imgui.CalcTextSize(text).x / 2)
    imgui.TextDisabled(text)
end
function imgui.CenterColumnColorText(imgui_RGBA, text)
    imgui.SetCursorPosX((imgui.GetColumnOffset() + (imgui.GetColumnWidth() / 2)) - imgui.CalcTextSize(text).x / 2)
	imgui.TextColored(imgui_RGBA, text)
end
function imgui.CenterButton(text)
    local width = imgui.GetWindowWidth()
    local calc = imgui.CalcTextSize(text)
    imgui.SetCursorPosX( width / 2 - calc.x / 2 )
	if imgui.Button(text) then
		return true
	else
		return false
	end
end
function imgui.CenterColumnButton(text)
	if text:find('(.+)##(.+)') then
		local text1, text2 = text:match('(.+)##(.+)')
		imgui.SetCursorPosX((imgui.GetColumnOffset() + (imgui.GetColumnWidth() / 2)) - imgui.CalcTextSize(text1).x / 2)
	else
		imgui.SetCursorPosX((imgui.GetColumnOffset() + (imgui.GetColumnWidth() / 2)) - imgui.CalcTextSize(text).x / 2)
	end
    if imgui.Button(text) then
		return true
	else
		return false
	end
end
function imgui.CenterColumnSmallButton(text)
	if text:find('(.+)##(.+)') then
		local text1, text2 = text:match('(.+)##(.+)')
		imgui.SetCursorPosX((imgui.GetColumnOffset() + (imgui.GetColumnWidth() / 2)) - imgui.CalcTextSize(text1).x / 2)
	else
		imgui.SetCursorPosX((imgui.GetColumnOffset() + (imgui.GetColumnWidth() / 2)) - imgui.CalcTextSize(text).x / 2)
	end
    if imgui.SmallButton(text) then
		return true
	else
		return false
	end
end
function imgui.GetMiddleButtonX(count)
    local width = imgui.GetWindowContentRegionWidth() 
    local space = imgui.GetStyle().ItemSpacing.x
    return count == 1 and width or width/count - ((space * (count-1)) / count)
end
function apply_dark_theme()
	imgui.SwitchContext()
    imgui.GetStyle().WindowPadding = imgui.ImVec2(5 * settings.general.custom_dpi, 5 * settings.general.custom_dpi)
    imgui.GetStyle().FramePadding = imgui.ImVec2(5 * settings.general.custom_dpi, 5 * settings.general.custom_dpi)
    imgui.GetStyle().ItemSpacing = imgui.ImVec2(5 * settings.general.custom_dpi, 5 * settings.general.custom_dpi)
    imgui.GetStyle().ItemInnerSpacing = imgui.ImVec2(2 * settings.general.custom_dpi, 2 * settings.general.custom_dpi)
    imgui.GetStyle().TouchExtraPadding = imgui.ImVec2(0, 0)
    imgui.GetStyle().IndentSpacing = 0
    imgui.GetStyle().ScrollbarSize = 10 * settings.general.custom_dpi
    imgui.GetStyle().GrabMinSize = 10 * settings.general.custom_dpi
    imgui.GetStyle().WindowBorderSize = 1 * settings.general.custom_dpi
    imgui.GetStyle().ChildBorderSize = 1 * settings.general.custom_dpi
    imgui.GetStyle().PopupBorderSize = 1 * settings.general.custom_dpi
    imgui.GetStyle().FrameBorderSize = 1 * settings.general.custom_dpi
    imgui.GetStyle().TabBorderSize = 1 * settings.general.custom_dpi
	imgui.GetStyle().WindowRounding = 8 * settings.general.custom_dpi
    imgui.GetStyle().ChildRounding = 8 * settings.general.custom_dpi
    imgui.GetStyle().FrameRounding = 8 * settings.general.custom_dpi
    imgui.GetStyle().PopupRounding = 8 * settings.general.custom_dpi
    imgui.GetStyle().ScrollbarRounding = 8 * settings.general.custom_dpi
    imgui.GetStyle().GrabRounding = 8 * settings.general.custom_dpi
    imgui.GetStyle().TabRounding = 8 * settings.general.custom_dpi
    imgui.GetStyle().WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
    imgui.GetStyle().ButtonTextAlign = imgui.ImVec2(0.5, 0.5)
    imgui.GetStyle().SelectableTextAlign = imgui.ImVec2(0.5, 0.5)
    imgui.GetStyle().Colors[imgui.Col.Text]                   = imgui.ImVec4(1.00, 1.00, 1.00, 1.00)
    imgui.GetStyle().Colors[imgui.Col.TextDisabled]           = imgui.ImVec4(0.50, 0.50, 0.50, 1.00)
    imgui.GetStyle().Colors[imgui.Col.WindowBg]               = imgui.ImVec4(0.07, 0.07, 0.07, 1.00)
    imgui.GetStyle().Colors[imgui.Col.ChildBg]                = imgui.ImVec4(0.07, 0.07, 0.07, 1.00)
    imgui.GetStyle().Colors[imgui.Col.PopupBg]                = imgui.ImVec4(0.07, 0.07, 0.07, 1.00)
    imgui.GetStyle().Colors[imgui.Col.Border]                 = imgui.ImVec4(0.25, 0.25, 0.26, 0.54)
    imgui.GetStyle().Colors[imgui.Col.BorderShadow]           = imgui.ImVec4(0.00, 0.00, 0.00, 0.00)
    imgui.GetStyle().Colors[imgui.Col.FrameBg]                = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.FrameBgHovered]         = imgui.ImVec4(0.25, 0.25, 0.26, 1.00)
    imgui.GetStyle().Colors[imgui.Col.FrameBgActive]          = imgui.ImVec4(0.25, 0.25, 0.26, 1.00)
    imgui.GetStyle().Colors[imgui.Col.TitleBg]                = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.TitleBgActive]          = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.TitleBgCollapsed]       = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.MenuBarBg]              = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.ScrollbarBg]            = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.ScrollbarGrab]          = imgui.ImVec4(0.00, 0.00, 0.00, 1.00)
    imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabHovered]   = imgui.ImVec4(0.41, 0.41, 0.41, 1.00)
    imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabActive]    = imgui.ImVec4(0.51, 0.51, 0.51, 1.00)
    imgui.GetStyle().Colors[imgui.Col.CheckMark]              = imgui.ImVec4(1.00, 1.00, 1.00, 1.00)
    imgui.GetStyle().Colors[imgui.Col.SliderGrab]             = imgui.ImVec4(0.21, 0.20, 0.20, 1.00)
    imgui.GetStyle().Colors[imgui.Col.SliderGrabActive]       = imgui.ImVec4(0.21, 0.20, 0.20, 1.00)
    imgui.GetStyle().Colors[imgui.Col.Button]                 = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.ButtonHovered]          = imgui.ImVec4(0.21, 0.20, 0.20, 1.00)
    imgui.GetStyle().Colors[imgui.Col.ButtonActive]           = imgui.ImVec4(0.41, 0.41, 0.41, 1.00)
    imgui.GetStyle().Colors[imgui.Col.Header]                 = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.HeaderHovered]          = imgui.ImVec4(0.20, 0.20, 0.20, 1.00)
    imgui.GetStyle().Colors[imgui.Col.HeaderActive]           = imgui.ImVec4(0.47, 0.47, 0.47, 1.00)
    imgui.GetStyle().Colors[imgui.Col.Separator]              = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.SeparatorHovered]       = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.SeparatorActive]        = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.ResizeGrip]             = imgui.ImVec4(1.00, 1.00, 1.00, 0.25)
    imgui.GetStyle().Colors[imgui.Col.ResizeGripHovered]      = imgui.ImVec4(1.00, 1.00, 1.00, 0.67)
    imgui.GetStyle().Colors[imgui.Col.ResizeGripActive]       = imgui.ImVec4(1.00, 1.00, 1.00, 0.95)
    imgui.GetStyle().Colors[imgui.Col.Tab]                    = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.TabHovered]             = imgui.ImVec4(0.28, 0.28, 0.28, 1.00)
    imgui.GetStyle().Colors[imgui.Col.TabActive]              = imgui.ImVec4(0.30, 0.30, 0.30, 1.00)
    imgui.GetStyle().Colors[imgui.Col.TabUnfocused]           = imgui.ImVec4(0.07, 0.10, 0.15, 0.97)
    imgui.GetStyle().Colors[imgui.Col.TabUnfocusedActive]     = imgui.ImVec4(0.14, 0.26, 0.42, 1.00)
    imgui.GetStyle().Colors[imgui.Col.PlotLines]              = imgui.ImVec4(0.61, 0.61, 0.61, 1.00)
    imgui.GetStyle().Colors[imgui.Col.PlotLinesHovered]       = imgui.ImVec4(1.00, 0.43, 0.35, 1.00)
    imgui.GetStyle().Colors[imgui.Col.PlotHistogram]          = imgui.ImVec4(0.90, 0.70, 0.00, 1.00)
    imgui.GetStyle().Colors[imgui.Col.PlotHistogramHovered]   = imgui.ImVec4(1.00, 0.60, 0.00, 1.00)
    imgui.GetStyle().Colors[imgui.Col.TextSelectedBg]         = imgui.ImVec4(1.00, 0.00, 0.00, 0.35)
    imgui.GetStyle().Colors[imgui.Col.DragDropTarget]         = imgui.ImVec4(1.00, 1.00, 0.00, 0.90)
    imgui.GetStyle().Colors[imgui.Col.NavHighlight]           = imgui.ImVec4(0.26, 0.59, 0.98, 1.00)
    imgui.GetStyle().Colors[imgui.Col.NavWindowingHighlight]  = imgui.ImVec4(1.00, 1.00, 1.00, 0.70)
    imgui.GetStyle().Colors[imgui.Col.NavWindowingDimBg]      = imgui.ImVec4(0.80, 0.80, 0.80, 0.20)
    imgui.GetStyle().Colors[imgui.Col.ModalWindowDimBg]       = imgui.ImVec4(0.12, 0.12, 0.12, 0.95)
end
function apply_moonmonet_theme()
	local generated_color = moon_monet.buildColors(settings.general.moonmonet_theme_color, 1.0, true)
	imgui.SwitchContext()
	imgui.GetStyle().WindowPadding = imgui.ImVec2(5 * settings.general.custom_dpi, 5 * settings.general.custom_dpi)
    imgui.GetStyle().FramePadding = imgui.ImVec2(5 * settings.general.custom_dpi, 5 * settings.general.custom_dpi)
    imgui.GetStyle().ItemSpacing = imgui.ImVec2(5 * settings.general.custom_dpi, 5 * settings.general.custom_dpi)
    imgui.GetStyle().ItemInnerSpacing = imgui.ImVec2(2 * settings.general.custom_dpi, 2 * settings.general.custom_dpi)
    imgui.GetStyle().TouchExtraPadding = imgui.ImVec2(0, 0)
    imgui.GetStyle().IndentSpacing = 0
    imgui.GetStyle().ScrollbarSize = 10 * settings.general.custom_dpi
    imgui.GetStyle().GrabMinSize = 10 * settings.general.custom_dpi
    imgui.GetStyle().WindowBorderSize = 1 * settings.general.custom_dpi
    imgui.GetStyle().ChildBorderSize = 1 * settings.general.custom_dpi
    imgui.GetStyle().PopupBorderSize = 1 * settings.general.custom_dpi
    imgui.GetStyle().FrameBorderSize = 1 * settings.general.custom_dpi
    imgui.GetStyle().TabBorderSize = 1 * settings.general.custom_dpi
	imgui.GetStyle().WindowRounding = 8 * settings.general.custom_dpi
    imgui.GetStyle().ChildRounding = 8 * settings.general.custom_dpi
    imgui.GetStyle().FrameRounding = 8 * settings.general.custom_dpi
    imgui.GetStyle().PopupRounding = 8 * settings.general.custom_dpi
    imgui.GetStyle().ScrollbarRounding = 8 * settings.general.custom_dpi
    imgui.GetStyle().GrabRounding = 8 * settings.general.custom_dpi
    imgui.GetStyle().TabRounding = 8 * settings.general.custom_dpi
    imgui.GetStyle().WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
    imgui.GetStyle().ButtonTextAlign = imgui.ImVec2(0.5, 0.5)
    imgui.GetStyle().SelectableTextAlign = imgui.ImVec2(0.5, 0.5)
	imgui.GetStyle().Colors[imgui.Col.Text] = ColorAccentsAdapter(generated_color.accent2.color_50):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.TextDisabled] = ColorAccentsAdapter(generated_color.neutral1.color_600):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.WindowBg] = ColorAccentsAdapter(generated_color.accent2.color_900):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.ChildBg] = ColorAccentsAdapter(generated_color.accent2.color_800):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.PopupBg] = ColorAccentsAdapter(generated_color.accent2.color_700):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.Border] = ColorAccentsAdapter(generated_color.accent1.color_200):apply_alpha(0xcc):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.Separator] = ColorAccentsAdapter(generated_color.accent1.color_200):apply_alpha(0xcc):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.BorderShadow] = imgui.ImVec4(0.00, 0.00, 0.00, 0.00)
	imgui.GetStyle().Colors[imgui.Col.FrameBg] = ColorAccentsAdapter(generated_color.accent1.color_600):apply_alpha(0x60):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.FrameBgHovered] = ColorAccentsAdapter(generated_color.accent1.color_600):apply_alpha(0x70):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.FrameBgActive] = ColorAccentsAdapter(generated_color.accent1.color_600):apply_alpha(0x50):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.TitleBg] = ColorAccentsAdapter(generated_color.accent2.color_700):apply_alpha(0xcc):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.TitleBgCollapsed] = ColorAccentsAdapter(generated_color.accent2.color_700):apply_alpha(0x7f):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.TitleBgActive] = ColorAccentsAdapter(generated_color.accent2.color_700):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.MenuBarBg] = ColorAccentsAdapter(generated_color.accent1.color_600):apply_alpha(0x91):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.ScrollbarBg] = imgui.ImVec4(0,0,0,0)
	imgui.GetStyle().Colors[imgui.Col.ScrollbarGrab] = ColorAccentsAdapter(generated_color.accent1.color_600):apply_alpha(0x85):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabHovered] = ColorAccentsAdapter(generated_color.accent1.color_600):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabActive] = ColorAccentsAdapter(generated_color.accent1.color_600):apply_alpha(0xb3):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.CheckMark] = ColorAccentsAdapter(generated_color.accent1.color_600):apply_alpha(0xcc):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.SliderGrab] = ColorAccentsAdapter(generated_color.accent1.color_600):apply_alpha(0xcc):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.SliderGrabActive] = ColorAccentsAdapter(generated_color.accent1.color_600):apply_alpha(0x80):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.Button] = ColorAccentsAdapter(generated_color.accent1.color_600):apply_alpha(0xcc):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.ButtonHovered] = ColorAccentsAdapter(generated_color.accent1.color_200):apply_alpha(0xb3):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.ButtonActive] = ColorAccentsAdapter(generated_color.accent1.color_600):apply_alpha(0xb3):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.Tab] = ColorAccentsAdapter(generated_color.accent1.color_600):apply_alpha(0xcc):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.TabActive] = ColorAccentsAdapter(generated_color.accent1.color_200):apply_alpha(0xb3):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.TabHovered] = ColorAccentsAdapter(generated_color.accent1.color_200):apply_alpha(0xb3):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.Header] = ColorAccentsAdapter(generated_color.accent1.color_600):apply_alpha(0xcc):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.HeaderHovered] = ColorAccentsAdapter(generated_color.accent1.color_600):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.HeaderActive] = ColorAccentsAdapter(generated_color.accent1.color_600):apply_alpha(0xb3):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.ResizeGrip] = ColorAccentsAdapter(generated_color.accent2.color_700):apply_alpha(0xcc):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.ResizeGripHovered] = ColorAccentsAdapter(generated_color.accent2.color_700):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.ResizeGripActive] = ColorAccentsAdapter(generated_color.accent2.color_700):apply_alpha(0xb3):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.PlotLines] = ColorAccentsAdapter(generated_color.accent2.color_600):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.PlotLinesHovered] = ColorAccentsAdapter(generated_color.accent1.color_600):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.PlotHistogram] = ColorAccentsAdapter(generated_color.accent2.color_600):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.PlotHistogramHovered] = ColorAccentsAdapter(generated_color.accent1.color_600):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.TextSelectedBg] = ColorAccentsAdapter(generated_color.accent1.color_600):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.ModalWindowDimBg] = ColorAccentsAdapter(generated_color.accent1.color_200):apply_alpha(0x99):as_vec4()
end
function argbToHexWithoutAlpha(alpha, red, green, blue)
    return string.format("%02X%02X%02X", red, green, blue)
end
function rgba_to_argb(rgba_color)
    -- �������� ���������� �����
    local r = bit32.band(bit32.rshift(rgba_color, 24), 0xFF)
    local g = bit32.band(bit32.rshift(rgba_color, 16), 0xFF)
    local b = bit32.band(bit32.rshift(rgba_color, 8), 0xFF)
    local a = bit32.band(rgba_color, 0xFF)
    
    -- �������� ARGB ����
    local argb_color = bit32.bor(bit32.lshift(a, 24), bit32.lshift(r, 16), bit32.lshift(g, 8), b)
    
    return argb_color
end
function join_argb(a, r, g, b)
    local argb = b 
    argb = bit.bor(argb, bit.lshift(g, 8))
    argb = bit.bor(argb, bit.lshift(r, 16))    
    argb = bit.bor(argb, bit.lshift(a, 24))
    return argb
end
function explode_argb(argb)
    local a = bit.band(bit.rshift(argb, 24), 0xFF)
    local r = bit.band(bit.rshift(argb, 16), 0xFF)
    local g = bit.band(bit.rshift(argb, 8), 0xFF)
    local b = bit.band(argb, 0xFF)
    return a, r, g, b
end
function rgba_to_hex(rgba)
    local r = bit.rshift(rgba, 24) % 256
    local g = bit.rshift(rgba, 16) % 256
    local b = bit.rshift(rgba, 8) % 256
    local a = rgba % 256
    return string.format("%02X%02X%02X", r, g, b)
end
function ARGBtoRGB(color) 
	return bit.band(color, 0xFFFFFF) 
end
function ColorAccentsAdapter(color)
    local a, r, g, b = explode_argb(color)
    local ret = {a = a, r = r, g = g, b = b}
    function ret:apply_alpha(alpha)
        self.a = alpha
        return self
    end
    function ret:as_u32()
        return join_argb(self.a, self.b, self.g, self.r)
    end
    function ret:as_vec4()
        return imgui.ImVec4(self.r / 255, self.g / 255, self.b / 255, self.a / 255)
    end
    function ret:as_argb()
        return join_argb(self.a, self.r, self.g, self.b)
    end
    function ret:as_rgba()
        return join_argb(self.r, self.g, self.b, self.a)
    end
    function ret:as_chat()
        return string.format("%06X", ARGBtoRGB(join_argb(self.a, self.r, self.g, self.b)))
    end  
    return ret
end
if not isMonetLoader() then
	function onWindowMessage(msg, wparam, lparam)
		if(msg == 0x100 or msg == 0x101) then
			if (wparam == 13 and GiveRankMenu[0]) and not isPauseMenuActive() then
				consumeWindowMessage(true, false)
				if (msg == 0x101) then
					GiveRankMenu[0] = false
					give_rank()
				end
			end
		end
	end
end

function main()

	if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(0) end 

	if tostring(settings.general.version) ~= tostring(thisScript().version) then 
		settings.general.version = thisScript().version
		save_settings()
	end

	if not isMonetLoader() then loadHotkeys() end
	welcome_message()
	initialize_commands()

	if settings.player_info.name_surname == '' or settings.player_info.fraction == '����������' then
		sampAddChatMessage('[FD Helper] {ffffff}������� �������� ��� /stats ��������� ���������� ������ ��� ���!', message_color)
		check_stats = true
		sampSendChat('/stats')
	end

	while true do
		wait(1)
		
		if nowGun ~= getCurrentCharWeapon(PLAYER_PED) and settings.general.rp_gun then
			oldGun = nowGun
			nowGun = getCurrentCharWeapon(PLAYER_PED)
			if nowGun == 42 or oldGun == 42 then
				if oldGun == 0 then
					sampSendChat("/me " .. gunOn[nowGun] .. " " .. weapons.get_name(nowGun) .. " " .. gunPartOn[nowGun])
				elseif nowGun == 0 then
					sampSendChat("/me " .. gunOff[oldGun] .. " " .. weapons.get_name(oldGun) .. " " .. gunPartOff[oldGun])
				else
					sampSendChat("/me " .. gunOff[oldGun] .. " " .. weapons.get_name(oldGun) .. " " .. gunPartOff[oldGun] .. ", ����� ���� " .. gunOn[nowGun] .. " " .. weapons.get_name(nowGun) .. " " .. gunPartOn[nowGun])
				end
			end
		end

		if MembersWindow[0] and not update_members_check and settings.general.auto_update_members then -- ���������� �������� � �������
			update_members_check = true
			wait(1500)
			if MembersWindow[0] then
				members_new = {} 
				members_check = true 
				sampSendChat("/members") 
			end
			wait(1500)
			update_members_check = false
		end

		local currentMinute = os.date("%M", os.time())
		local currentSecond = os.date("%S", os.time())
		if ((currentMinute == "55" or currentMinute == "25") and currentSecond == "00") then
			if sampGetPlayerColor(tagReplacements.my_id()) == 368966908 then
				sampAddChatMessage('[FD Helper] {ffffff}����� 5 ����� ����� PAYDAY. �������� ����� ����� �� ���������� ��������!', message_color)
				wait(1000)
			end
		end


		if isFireDialog and dialogid_fires ~= -1 then
			local result, button, list, input = sampHasDialogRespond(999) -- �������� ���������� � �������
			if result and button ~= -1 and list ~= -1 then
				sampSendDialogResponse(dialogid_fires, button, list, item)
				dialogid_fires = -1
				isFireDialog = false
				if button ~= 0 then getFireLocation(tonumber(list)) end
			end
			
		end
			
		

	end
end

function onScriptTerminate(script, game_quit)
    if script == thisScript() and not game_quit and not reload_script then
		sampAddChatMessage('[FD Helper] {ffffff}��������� ����������� ������, ������ ������������ ���� ������!', message_color)
		if not isMonetLoader() then 
			sampAddChatMessage('[FD Helper] {ffffff}����������� ' .. message_color_hex .. 'CTRL {ffffff}+ ' .. message_color_hex .. 'R {ffffff}����� ������������� ������.', message_color)
		end
		play_error_sound()
    end
end