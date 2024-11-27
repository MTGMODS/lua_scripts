---@diagnostic disable: undefined-global, need-check-nil, lowercase-global, cast-local-type, unused-local

script_name("Government Helper")
script_description('Cross-platform script helper for Government')
script_author("MTG MODS x Introv3rt")
script_version("1.1")

require('lib.moonloader')
require ('encoding').default = 'CP1251'
local u8 = require('encoding').UTF8
local ffi = require('ffi')
local sampev = require('samp.events')

-------------------------------------------- JSON SETTINGS ---------------------------------------------
local settings = {}
local default_settings = {
	general = {
		version = thisScript().version,
		expel_reason = '������������ ���������',
		accent_enable = false,
		rp_chat = false,
		auto_uval = false,
		moonmonet_theme_enable = true,
		moonmonet_theme_color = 167427,
		mobile_fastmenu_button = true,
		mobile_stop_button = true,
		use_binds = true,
		use_info_menu = false,
		bind_mainmenu = '[113]',
		bind_fastmenu = '[69]',
		bind_leader_fastmenu = '[71]',
		bind_command_stop = '[123]'
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
			"[���.�����.]",
			"[����]",
			"[����]",
			"[����]",
			"[����]",
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
			"[Min.Healt]",
			"[LSMC]",
			"[SFMC]",
			"[LVMC]",
			"[JMC]",
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
			'- 101.1 FM - ',
		},
	},
	note = {
		{ note_name = '������� �1', note_text = '�� ������ ��������� � ���� � �������� �������� ����� ����������!&���� ������� ����� ��������� � �������� � ����� �����!', deleted = false  },
	},
	commands = {
		{ cmd = 'mb' , description = '������� ������ ����������� � ����' , text = '{open_mimgui_members}', arg = '' , enable = true , waiting = '1.200', deleted = false },
		{ cmd = 'dep' , description = '������� ���� ����� ������������' , text = '{show_deportament_menu}', arg = '' , enable = true , waiting = '1.200', deleted = false },
		{ cmd = 'zd' , description = '���������� ������' , text = '����������� {get_ru_nick({arg_id})}&� {my_ru_nick} - {fraction_rank} {fraction_tag}&��� � ���� ��� ������?', arg = '{arg_id}' , enable = true , waiting = '1.200', deleted = false },
		{ cmd = 'go' , description = '������� ������ �� �����' , text = '������ {get_ru_nick({arg_id})}, �������� �� ����.', arg = '{arg_id}' , enable = true, waiting = '1.200', deleted = false   },
		{ cmd = 'gvc' , description = '������ ������� ���� ��� VC' ,  text = '/me ������{sex} �� ������ ������� �����, � ����� ����{sex} ����� ��� ���������� ���������� �� �����&/do �� ����� ����� ����� ��� ����������, ����� � �����&/me ��������� �����{sex} ��������� �����, �������� ������ ����������, �������� ������ ���� �� ������������&/me ������ ��������� ���� �������{sex} ���������� ����������� ��������&���, �������, ���� ��������� �� ��������������� � ����� ����-����&/givevisa {arg_id}&/do �������� ������� ����������, ��� ������ ������� �����', arg = '{arg_id}' , enable = true, waiting = '1.200', deleted = false   },
		{ cmd = 'car' , description = '���������� ������ �/c � ����������' , text = '/do �� ����� ����� ����� �� ��������� �����������.&/me ���� ����� �� ������������� ����� ��������� ��������&/me �������� ������� � ������ ����������� � ������ ����&/do �������� ��������.&/todo ���, ��������� ������� ��� � �������� ����� ������ ����������*������� ����� � ������&/todo ��� ��� ����������!*������� ��������&/givepass {agr_id}', arg = '{arg_id}' , enable = true, waiting = '1.200', deleted = false   },
		{ cmd = 'changedata' , description = '��������� ���� �������� � ��������' ,  text = '/do ����� ��� ������ ���������� � �������� ��������� ��� ������.&/me ������� ���� ��� ����, ����{sex} �����, ����� ���� ��������{sex} ��� �������� ��������&/todo ������� ���� ����� ���� � ��������� ������� �����*���������� ���� � ������&/givepass {arg_id}' , arg = '{arg_id}' , enable = true , waiting = '1.500', deleted = false  },		
		{ cmd = 'advisit' , description = '�������� ������� ��������' ,  text = '/me ������{sex} �� ������� �������� � ������{sex} ���&/do � ��������� ��������� �������� ���� �������.&/me ������ �������{sex}&/do � ������� ��������: {my_ru_nick}, ������ ������� � ����� "{my_id}".&/todo �������*��������� �������&/showvisit {arg_id}' , arg = '{arg_id}', enable = true, waiting = '1.200', deleted = false} , 
		{ cmd = 'freechel' , description = '���������� ������ ��������' ,  text = '/do �������� � ����.&/me �������{sex} �������� �� ���� � ������{sex} ���&/me ������{sex} �� ��������� ����� ��� ������������ ��������&/me ������{sex} �� ���������� ������� ����� � ��������{sex} �����&/me �������{sex} ����� ������������ �� �������&/me ������{sex} ����� � �������{sex} ������� � ��������� ������, ����� ���� ������{sex} ����� � ��������{sex} ������&/me �������{sex} ����� � �������� � ������{sex} ���&/free {arg_id} {arg2}' , arg = '{arg_id} {arg2}' , enable = true, waiting = '1.300' , deleted = false },
		{ cmd = 'bodycamon' , description = '��������� ����-������' ,  text = '/do �� ��������� ������� ����������� ����-������.&/me �������{sex} ������ ���������� ��������&/do ������ �������� � �������� ������.' , arg = '' , enable = true, waiting = '1.200' , deleted = false },
		{ cmd = 'bodycamoff' , description = '���������� ����-������' ,  text = '/do �� ��������� ������� ����������� ����-������.&/me ��������{sex} ������ ���������� ��������&/do ������ ��������� � ���������� ������.' , arg = '' , enable = true, waiting = '1.200' , deleted = false },
		{ cmd = 'time' , description = '���������� �����' ,  text = '/me ��������{sex} �� ���� ���� � ����������� MTG MODS � ���������{sex} �����&/time&/do �� ����� ����� ����� {get_time}.' , arg = '' , enable = true, waiting = '1.200' , deleted = false },
		{ cmd = 'exp' , description = '������� ������ �� �������������' ,  text = '��������, �� � ��������{sex} ������� ��� �� ������ �� ������������ ���������.&/me �������{sex} �������� �� ���� � �����{sex} � ������&/me ������ ����� �����, ����� �������� �� �����&/expel {arg_id} {expel_reason}' , arg = '{arg_id}' , enable = true , waiting = '1.200' , deleted = false },
		{ cmd = 'wed' , description = '���������� �����' ,  text = '������ ����, ��������� ����������� � �����!&��������� ������� � �����!&������� - ����� ���������� � ������������ ������� � ����� �����.&�������� ����� � ��� ������ ������� ����� ���� ������� ������.&� ����� ��� �� ������ �� ����� ���� �� ����, ������ ��������� � ������� ���������� ����, � ���������.&�������� �����, �� ����������� ������� �� ���� ������� ���� ���� ����� ������ � ����� ������� ����� �����.&����� ������� ����������� ����� ��� ��� ��� �����������, �������� �� ���� ������� ����� ���������, ������� �����&{pause}&� ������ ��������� ��������, ����������� � ����������� ����������, ��� ���� ��������������.&����� ��� � ���� ����� � ����������� ���� ����� ���������� ������������ ��������.&/wedding {arg_id} {arg2}' , arg = '{arg_id} {arg2}' , enable = true, waiting = '1.200' , deleted = false },
	}, 
	commands_manage = {
		{ cmd = 'book' , description = '������ ������ �������� �����' , text = '����������� � ��� ���� �������� �����, �� �� �����������!&������ � ��� ����� �, ��� �� ����� ������ �����, �������...&/me ������ �� ������ ������� ����� �������� ������ � ������ �� ��� ������ {fraction_tag}&/todo ������*��������� �������� ����� ������ ��������&/givewbook {arg_id} 100&/n {get_nick({arg_id})}, ������� ����������� � /offer ����� �������� �������� �����!' , arg = '{arg_id}', enable = true, waiting = '1.200', deleted = false  },
		{ cmd = 'inv' , description = '�������� ������ � �������' , text = '/do � ����� ������� ���� ������ � ������� �� ����������.&/me ������ �� ������� ������� ���� ���� �� ������ ������ �� ����������&/todo ��������, ��� ���� �� ����� ����������*��������� ���� �������� ��������&/invite {arg_id}&/r {get_ru_nick({arg_id})} - ��� ����� ���������!' , arg = '{arg_id}', enable = true, waiting = '1.200' , deleted = false  },
		{ cmd = 'rp' , description = '������ ���������� /fractionrp' , text = '/fractionrp {arg_id}' , arg = '{arg_id}', enable = true, waiting = '1.200', deleted = false  },
		{ cmd = 'pl' , description = '��������� ����� ����������' , text = '{give_platoon}' , arg = '{arg_id}', enable = true, waiting = '1.200' , deleted = false },	
		{ cmd = 'gr' , description = '���������/��������� c���������' , text = '{show_rank_menu}&/me ������ �� ������� ���� ������� � ������� � ���� ������ {fraction_tag}&/me �������� ���������� � ���������� {get_ru_nick({arg_id})} � ���� ������ {fraction_tag}&/me ������� � ���� ������ � ������� ������� ������� � ������&/giverank {arg_id} {get_rank}&/r ��������� {get_ru_nick({arg_id})} ������� ����� ���������!' , arg = '{arg_id}', enable = true, waiting = '1.200' , deleted = false },
		{ cmd = 'vize' , description = '���������� Vice City ����� ����������' , text = '/me ������ �� ������� ���� ������� � ������� � ���� ������ {fraction_tag}&/me �������� ���������� � ���������� {get_ru_nick({arg_id})} � ���� ������ {fraction_tag}&/me ������� � ���� ������ � ������� ������� ������� � ������&{lmenu_vc_vize}' , arg = '{arg_id}', enable = true, waiting = '1.200'  , deleted = false },
		{ cmd = 'cjob' , description = '���������� ���������� ����������' , text = '/checkjobprogress {arg_id}' , arg = '{arg_id}', enable = true, waiting = '1.200' , deleted = false  },	
		{ cmd = 'fmutes' , description = '������ ��� ���������� (10 min)' , text = '/fmutes {arg_id} {expel_reason}&/r ��������� {get_ru_nick({arg_id})} ������� ����� ������������ ����� �� 10 �����!' , arg = '{arg_id}', enable = true, waiting = '1.200' , deleted = false  },
		{ cmd = 'funmute' , description = '����� ��� ����������' , text = '/funmute {arg_id}&/r ��������� {get_ru_nick({arg_id})} ������ ����� ������������ ������!' , arg = '{arg_id}', enable = true, waiting = '1.200' , deleted = false  },
		{ cmd = 'vig' , description = '������ �������� c���������' , text = '/me ������ �� ������� ���� ������� � ������� � ���� ������ {fraction_tag}&/me �������� ���������� � ���������� {get_ru_nick({arg_id})} � ���� ������ {fraction_tag}&/me ������� � ���� ������ � ������� ������� ������� � ������&/fwarn {arg_id} {arg2}&/r ���������� {get_ru_nick({arg_id})} ����� �������! �������: {arg2}' , arg = '{arg_id} {arg2}', enable = true, waiting = '1.200'  , deleted = false },
		{ cmd = 'unvig' , description = '������ �������� c���������' , text = '/me ������ �� ������� ���� ������� � ������� � ���� ������ {fraction_tag}&/me �������� ���������� � ���������� {get_ru_nick({arg_id})} � ���� ������ {fraction_tag}&/me ������� � ���� ������ � ������� ������� ������� � ������&/unfwarn {arg_id}&/r ���������� {get_ru_nick({arg_id})} ��� ���� �������!' , arg = '{arg_id}', enable = true, waiting = '1.200' , deleted = false  },
		{ cmd = 'unv' , description = '���������� ������ �� �������' , text = '/me ������ �� ������� ���� ������� � ������� � ���� ������ {fraction_tag}&/me �������� ���������� � ���������� {get_ru_nick({arg_id})} � ���� ������ {fraction_tag}&/me ������� � ���� ������ � ������� ���� ������� ������� � ������&/uninvite {arg_id} {arg2}&/r ��������� {get_ru_nick({arg_id})} ��� ������ �� �������: {arg2}' , arg = '{arg_id} {arg2}', enable = true, waiting = '1.200' , deleted = false  },
		{ cmd = 'point' , description = '���������� ����� ��� �����������' , text = '/r ������ ������������ �� ���, ��������� ��� ����������...&/point' , arg = '', enable = true, waiting = '1.200', deleted = false  },
		{ cmd = 'lic' , description = '������ �������� ��������' , text = '/do ����� ��� ������ �������� ��������� ��� ������.&/me ������� ���� ��� ����, ����{sex} �����, ����� ���� ��������{sex} ��� ������ �����������&/todo ������� ���� ���� ������ � ��������� ������� �����*��������� ����� � �����&/givelicadvokat {arg_id}' , arg = '{arg_id}', enable = true, waiting = '1.200', deleted = false  },
		{ cmd = 'uvalgos' , description = '������� ������������', text = '/do � ����� ������� ����� �������.&/me ������{sex} ������� �� �������, ����� ���� ������� � ���� ������ �����������&/me �������{sex} ���������� � ���������� ��������������� ���������&/demoute {arg_id} {arg2}' , arg = '{arg_id} {arg2}', enable = true, waiting = '1.200', deleted = false  },
	}
}
local configDirectory = getWorkingDirectory() .. "/config"
local path = configDirectory .. "/GOV_Helper_Settings.json"
function load_settings()
    if not doesDirectoryExist(configDirectory) then
        createDirectory(configDirectory)
    end
    if not doesFileExist(path) then
        settings = default_settings
		print('[Government Helper] ���� � ����������� �� ������, ��������� ����������� ���������!')
    else
        local file = io.open(path, 'r')
        if file then
            local contents = file:read('*a')
            file:close()
			if #contents == 0 then
				settings = default_settings
				print('[Government Helper] �� ������� ������� ���� � �����������, ��������� ����������� ���������!')
			else
				local result, loaded = pcall(decodeJson, contents)
				if result then
					settings = loaded
					for category, _ in pairs(default_settings) do
						if settings[category] == nil then
							settings[category] = {}
						end
						for key, value in pairs(default_settings[category]) do
							if settings[category][key] == nil then
								settings[category][key] = value
							end
						end
					end
					print('[Government Helper] ��������� ������� ���������!')
				else
					print('[Government Helper] �� ������� ������� ���� � �����������, ��������� ����������� ���������!')
				end
			end
        else
            settings = default_settings
			print('[Government Helper] �� ������� ������� ���� � �����������, ��������� ����������� ���������!')
        end
    end
end
function save_settings()
    local file, errstr = io.open(path, 'w')
    if file then
        local result, encoded = pcall(encodeJson, settings)
        file:write(result and encoded or "")
        file:close()
		print('[Government Helper] ��������� ���������!')
        return result
    else
        print('[Government Helper] �� ������� ��������� ��������� �������, ������: ', errstr)
        return false
    end
end
load_settings()
------------------------------------------- MonetLoader --------------------------------------------------
function isMonetLoader() return MONET_VERSION ~= nil end
if isMonetLoader() then
	gta = ffi.load('GTASA') 
	ffi.cdef[[ void _Z12AND_OpenLinkPKc(const char* link); ]] -- ������� ��� �������� ������
end
if not isMonetLoader() and MONET_DPI_SCALE == nil then MONET_DPI_SCALE = 1.0 end
---------------------------------------------- Mimgui -----------------------------------------------------
local imgui = require('mimgui')
local fa = require('fAwesome6_solid')
local sizeX, sizeY = getScreenResolution()

local MainWindow = imgui.new.bool()
local checkbox_accent_enable = imgui.new.bool(settings.general.accent_enable)
local input_expel_reason = imgui.new.char[256](u8(settings.general.expel_reason))
local input_accent = imgui.new.char[256](u8(settings.player_info.accent))
local input_name_surname = imgui.new.char[256](u8(settings.player_info.name_surname))
local input_fraction_tag = imgui.new.char[256](u8(settings.player_info.fraction_tag))
local theme = imgui.new.int(0)
local fastmenu_type = imgui.new.int(settings.general.mobile_fastmenu_button and 1 or 0)
local stop_type = imgui.new.int(settings.general.mobile_stop_button and 1 or 0)

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
local members_fraction = nil
local update_members_check = false

local GiveRankMenu = imgui.new.bool()
local giverank = imgui.new.int(5)

local SobesMenu = imgui.new.bool()

local InformationWindow = imgui.new.bool()

local CommandStopWindow = imgui.new.bool()
local CommandPauseWindow = imgui.new.bool()

local LeaderFastMenu = imgui.new.bool()
local FastMenu = imgui.new.bool()
local FastMenuButton = imgui.new.bool()
local FastMenuPlayers = imgui.new.bool()

local NoteWindow = imgui.new.bool()
local show_note_name = nil
local show_note_text = nil

local BinderWindow = imgui.new.bool()
local waiting_slider = imgui.new.float(0)
local ComboTags = imgui.new.int()
local item_list = {u8'��� ���������', u8'{arg} - ��������� ����� ��������', u8'{arg_id} - ��������� ������ �������� ID ������', u8'{arg_id} {arg2} - ��������� 2 ���������: ID ������ � ����� ��������', u8'{arg_id} {arg2} {arg3} - ��������� 3 ���������: ID ������, ���� �����, � ����� ��������'}
local ImItems = imgui.new['const char*'][#item_list](item_list)
local change_waiting = nil
local change_cmd_bool = false
local change_cmd = nil
local change_description = nil
local change_text = nil
local change_arg = nil
local binder_create_command_9_10 = false
local tagReplacements = {
	my_id = function() return select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)) end,
    my_nick = function() return sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))) end,
	my_ru_nick = function() return TranslateNick(settings.player_info.name_surname) end,
	my_doklad_nick = function() 
        local nick = sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)))
        if nick:find('(.+)%_(.+)') then
			local name, surname = nick:match('(.+)%_(.+)')
			return name:sub(1, 1)  .. '.' .. surname
		else
			return nick
		end
    end,
	fraction_rank_number = function() return settings.player_info.fraction_rank_number end,
	fraction_rank = function() return settings.player_info.fraction_rank end,
	fraction_tag = function() return settings.player_info.fraction_tag end,
	fraction = function() return settings.player_info.fraction end,
	expel_reason = function() return settings.general.expel_reason end,
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
	get_square = function ()
		return kvadrat()
	end,
	get_area = function ()
		local x,y,z = getCharCoordinates(PLAYER_PED)
		return calculateZoneRu(x,y,z)
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
}
local binder_tags_text = [[
{my_id} - ��� ID
{my_nick} - ��� ������� 
{my_ru_nick} - ���� ��� � �������
{my_doklad_nick} - ������ ����� ������ ����� � �������

{fraction} - ���� �������
{fraction_rank} - ���� ����������� ���������
{fraction_tag} - ��� ����� �������
{expel_reason} - ������� ��� ������ �� �������

{sex} - ��������� ����� "�" ���� � ������� ������ ������� ���

{get_time} - �������� ������� �����
{get_city} - �������� ������� �����
{get_square} - �������� ������� �������
{get_area} - �������� ������� �����
{get_nick({arg_id})} - �������� ������� �� ��������� ID ������
{get_rp_nick({arg_id})} - �������� ������� ��� ������� _ �� ��������� ID ������
{get_ru_nick({arg_id})} - �������� ������� �� �������� �� ��������� ID ������ 
]]
local binder_tags_text2 = [[
{show_deportament_menu} - ������� ���� ����� ������������

{lmenu_vc_vize} - ����-������ ���� Vice City
{give_platoon} - ��������� ����� ������

{open_mimgui_members} - ������� Mimgui Members

{show_rank_menu} - ������� ���� ������ ������
{get_rank} - �������� ��������� ����

{pause} - ��������� ������� �� ����� � ������� �������
]]
-------------------------------------------- MoonMonet ----------------------------------------------------

local monet_no_errors, moon_monet = pcall(require, 'MoonMonet') -- ��������� ���������� ����������

local message_color = 0xFF7E7E
local message_color_hex = '{FF7E7E}'

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
if not isMonetLoader() then
	hotkey_no_errors, hotkey = pcall(require, 'mimgui_hotkeys')
	if hotkey_no_errors then
		hotkey.Text.NoKey = u8'< nil >'
		hotkey.Text.WaitForKey = u8'< wait >'
		MainMenuHotKey = hotkey.RegisterHotKey('Open MainMenu', false, decodeJson(settings.general.bind_mainmenu), function()
			if settings.general.use_binds then 
				if not MainWindow[0] then
					MainWindow[0] = true
				end
			end
		end)
		FastMenuHotKey = hotkey.RegisterHotKey('Open FastMenu', false, decodeJson(settings.general.bind_fastmenu), function() 
			if settings.general.use_binds then 
				local valid, ped = getCharPlayerIsTargeting(PLAYER_HANDLE)
				if valid and doesCharExist(ped) then
					local result, id = sampGetPlayerIdByCharHandle(ped)
					if result and id ~= -1 and not LeaderFastMenu[0] then
						show_fast_menu(id)
					end
				end
			end
		end)
		LeaderFastMenuHotKey = hotkey.RegisterHotKey('Open LeaderFastMenu', false, decodeJson(settings.general.bind_leader_fastmenu), function() 
			if settings.general.use_binds then 
				if tonumber(settings.player_info.fraction_rank_number) >= 9 then 
					local valid, ped = getCharPlayerIsTargeting(PLAYER_HANDLE)
					if valid and doesCharExist(ped) then
						local result, id = sampGetPlayerIdByCharHandle(ped)
						if result and id ~= -1 and not FastMenu[0] then
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

local vc_vize_bool = false
local vc_vize_player_id = nil

local clicked = false

local message1
local message2
local message3

local isActiveCommand = false

local debug_mode = false

local command_stop = false
local command_pause = false

local auto_uval_checker = false

local platoon_check = false

------------------------------------------- Main -----------------------------------------------------

function main()

	if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(0) end 

	welcome_message()

	initialize_commands()

	if tostring(settings.general.version) ~= tostring(thisScript().version) then 
		InformationWindow[0] = true
	end

	if settings.player_info.name_surname == '' or  settings.player_info.fraction == '����������' then
		sampAddChatMessage('[Government Helper] {ffffff}������� �������� ��� /stats ��������� ���������� ������ ��� ���!', message_color)
		check_stats = true
		sampSendChat('/stats')
	end
	
	while true do
		wait(0)

		if MembersWindow[0] and not update_members_check then -- ���������� �������� � �������
			update_members_check = true
			wait(2500)
			if MembersWindow[0] then
				members_new = {} 
				members_check = true 
				sampSendChat("/members") 
			end
			wait(2500)
			update_members_check = false
		end
		
		if isMonetLoader() then
			if settings.general.mobile_fastmenu_button then
				if tonumber(#get_players()) > 0 and not FastMenu[0] and not FastMenuPlayers[0] then
					FastMenuButton[0] = true
				else
					FastMenuButton[0] = false
				end
			end
		end 

		if ((os.date("%M", os.time()) == "55" and os.date("%S", os.time()) == "00") or (os.date("%M", os.time()) == "25" and os.date("%S", os.time()) == "00")) then
			sampAddChatMessage('[Government Helper] {ffffff}����� 5 ����� ����� PAYDAY. �������� ����� ����� �� ���������� ��������!', message_color)
			wait(1000)
		end

		if clicked then
			if isMonetLoader() then
				local bs = raknetNewBitStream()
				raknetBitStreamWriteInt8(bs, 220)
				raknetBitStreamWriteInt8(bs, 63)
				raknetBitStreamWriteInt8(bs, 25)
				raknetBitStreamWriteInt32(bs, 0)
				raknetBitStreamWriteInt8(bs, 255)
				raknetBitStreamWriteInt8(bs, 255)
				raknetBitStreamWriteInt8(bs, 255)
				raknetBitStreamWriteInt8(bs, 255)
				raknetBitStreamWriteInt32(bs, 0)
				raknetSendBitStream(bs)
				raknetDeleteBitStream(bs)
				wait(10)
			else
				local cmd = "clickMinigame"
				local bs = raknetNewBitStream()
				raknetBitStreamWriteInt8(bs, 220)
				raknetBitStreamWriteInt8(bs, 18)
				raknetBitStreamWriteInt8(bs, #cmd)
				raknetBitStreamWriteInt8(bs, 0)
				raknetBitStreamWriteInt8(bs, 0)
				raknetBitStreamWriteInt8(bs, 0)
				raknetBitStreamWriteString(bs, cmd)
				raknetBitStreamWriteInt32(bs, 0)
				raknetBitStreamWriteInt8(bs, 0)
				raknetBitStreamWriteInt8(bs, 0)
				raknetSendBitStreamEx(bs, 1, 7, 1)
				raknetDeleteBitStream(bs)
				setGameKeyState(1, 255)
				wait(10)
				setGameKeyState(1, 0)
			end
		end
		
	end

end
function welcome_message()
	if not sampIsLocalPlayerSpawned() then 
		sampAddChatMessage('[Government Helper] {ffffff}������������� ������� ������ �������!',message_color)
		sampAddChatMessage('[Government Helper] {ffffff}��� ������ �������� ������� ������� ������������ (������� �� ������)',message_color)
		repeat wait(0) until sampIsLocalPlayerSpawned()
	end
	sampAddChatMessage('[Government Helper] {ffffff}�������� ������� ������ �������!', message_color)
	show_arz_notify('info', 'Government Helper', "�������� ������� ������ �������!", 3000)
	if isMonetLoader() or settings.general.bind_mainmenu == nil or not settings.general.use_binds then	
		sampAddChatMessage('[Government Helper] {ffffff}���� ������� ���� ������� ������� ������� ' .. message_color_hex .. '/gh', message_color)
	elseif hotkey_no_errors and settings.general.bind_mainmenu and settings.general.use_binds then
		sampAddChatMessage('[Government Helper] {ffffff}���� ������� ���� ������� ������� ' .. message_color_hex .. getNameKeysFrom(settings.general.bind_mainmenu) .. ' {ffffff}��� ������� ������� ' .. message_color_hex .. '/gh', message_color)
	else
		sampAddChatMessage('[Government Helper] {ffffff}���� ������� ���� ������� ������� ������� ' .. message_color_hex .. '/gh', message_color)
	end
end
function registerCommandsFrom(array)
	for _, command in ipairs(array) do
		if command.enable and not command.deleted then
			register_command(command.cmd, command.arg, command.text, tonumber(command.waiting))
		end
	end
end
function register_command(chat_cmd, cmd_arg, cmd_text, cmd_waiting)
	sampRegisterChatCommand(chat_cmd, function(arg)
		if not isActiveCommand then
			local arg_check = false
			local modifiedText = cmd_text
			if cmd_arg == '{arg}' then
				if arg and arg ~= '' then
					modifiedText = modifiedText:gsub('{arg}', arg or "")
					arg_check = true
				else
					sampAddChatMessage('[Government Helper] {ffffff}����������� ' .. message_color_hex .. '/' .. chat_cmd .. ' [��������]', message_color)
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
					sampAddChatMessage('[Government Helper] {ffffff}����������� ' .. message_color_hex .. '/' .. chat_cmd .. ' [ID ������]', message_color)
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
						sampAddChatMessage('[Government Helper] {ffffff}����������� ' .. message_color_hex .. '/' .. chat_cmd .. ' [ID ������] [��������]', message_color)
						play_error_sound()
					end
				else
					sampAddChatMessage('[Government Helper] {ffffff}����������� ' .. message_color_hex .. '/' .. chat_cmd .. ' [ID ������] [��������]', message_color)
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
						sampAddChatMessage('[Government Helper] {ffffff}����������� ' .. message_color_hex .. '/' .. chat_cmd .. ' [ID ������] [��������] [��������]', message_color)
						play_error_sound()
					end
				else
					sampAddChatMessage('[Government Helper] {ffffff}����������� ' .. message_color_hex .. '/' .. chat_cmd .. ' [ID ������] [��������] [��������]', message_color)
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
							sampAddChatMessage('[Government Helper] {ffffff}����� ���������� ��������� ������� ����������� ' .. message_color_hex .. '/stop {ffffff}��� ������� ������ ����� ������', message_color)
							CommandStopWindow[0] = true
						elseif not isMonetLoader() and hotkey_no_errors and settings.general.bind_command_stop and settings.general.use_binds then
							sampAddChatMessage('[Government Helper] {ffffff}����� ���������� ��������� ������� ����������� ' .. message_color_hex .. '/stop {ffffff}��� ������� ' .. message_color_hex .. getNameKeysFrom(settings.general.bind_command_stop), message_color)
						else
							sampAddChatMessage('[Government Helper] {ffffff}����� ���������� ��������� ������� ����������� ' .. message_color_hex .. '/stop', message_color)
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
							sampAddChatMessage('[Government Helper] {ffffff}��������� ������� /' .. chat_cmd .. " ������� �����������!", message_color) 
							return 
						end
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
						elseif line == '{open_mimgui_members}' then
							members_new = {} 
							members_check = true 
							sampSendChat("/members")
							break
						elseif line == '{show_deportament_menu}' then
							DeportamentWindow[0] = true
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
						elseif line == '{show_rank_menu}' then
						elseif line == "{pause}" then
							sampAddChatMessage('[Government Helper] {ffffff}������� /' .. chat_cmd .. ' ���������� �� �����!', message_color)
							command_pause = true
							CommandPauseWindow[0] = true
							while command_pause do
								wait(0)
							end
							if not command_stop then
								sampAddChatMessage('[Government Helper] {ffffff}��������� ��������� ������� /' .. chat_cmd, message_color)	
							end					
						else
							if line_index ~= 1 then wait(cmd_waiting * 1000) end
							sampSendChat(line)
							if debug_mode then sampAddChatMessage('[Government Helper DEBUG] SEND: ' .. line, message_color) end
						end
					end
					isActiveCommand = false
					if isMonetLoader() and settings.general.mobile_stop_button then
						CommandStopWindow[0] = false
					end
				end)
			end
		else
			sampAddChatMessage('[Government Helper] {ffffff}��������� ���������� ��������� ���������� �������!', message_color)
		end
	end)
end
function find_and_use_command(cmd, cmd_arg)
	local check = false
	for _, command in ipairs(settings.commands) do
		if command.enable and command.text:find(cmd) then
			check = true
			sampProcessChatInput("/" .. command.cmd .. " " .. cmd_arg)
			return
		end
	end
	if not check then
		for _, command in ipairs(settings.commands_manage) do
			if command.enable and command.text:find(cmd) then
				check = true
				sampProcessChatInput("/" .. command.cmd .. " " .. cmd_arg)
				return
			end
		end
	end
	if not check then

		return
	end
end
function initialize_commands()
	sampRegisterChatCommand("gh", function() MainWindow[0] = not MainWindow[0]  end)
	sampRegisterChatCommand("gfm", show_fast_menu)
	sampRegisterChatCommand("stop", function() 
		if isActiveCommand then 
			command_stop = true 
		else 
			sampAddChatMessage('[Government Helper] {ffffff}� ������ ������ ���� ������� �������� �������/���������!', message_color) 
		end
	end)
	sampRegisterChatCommand("sob", function(arg)
		if not isActiveCommand then
			if isParamSampID(arg) then
				player_id = tonumber(arg)
				SobesMenu[0] = not SobesMenu[0]
			else
				sampAddChatMessage('[Government Helper] {ffffff}����������� ' .. message_color_hex .. '/sob [ID ������]', message_color)
			end
			
		else
			sampAddChatMessage('[Government Helper] {ffffff}��������� ���������� ��������� ���������� �������!', message_color)
		end
	end)
	-- ����������� ��e� ������ ������� ���� � json
	registerCommandsFrom(settings.commands)
	if tonumber(settings.player_info.fraction_rank_number) >= 9 then 
		sampRegisterChatCommand("glm", show_leader_fast_menu)
		sampRegisterChatCommand("spcar", function()
			if not isActiveCommand then
				lua_thread.create(function()
					isActiveCommand = true
					if isMonetLoader() and settings.general.mobile_stop_button then
						sampAddChatMessage('[Government Helper] {ffffff}����� ���������� ��������� ������� ����������� ' .. message_color_hex .. '/stop {ffffff}��� ������� ������ ����� ������', message_color)
						CommandStopWindow[0] = true
					elseif not isMonetLoader() and hotkey_no_errors and settings.general.bind_command_stop and settings.general.use_binds then
						sampAddChatMessage('[Government Helper] {ffffff}����� ���������� ��������� ������� ����������� ' .. message_color_hex .. '/stop {ffffff}��� ������� ' .. message_color_hex .. getNameKeysFrom(settings.general.bind_command_stop), message_color)
					else
						sampAddChatMessage('[Government Helper] {ffffff}����� ���������� ��������� ������� ����������� ' .. message_color_hex .. '/stop', message_color)
					end
					sampSendChat("/rb ��������! ����� 15 ������ ����� ����� ���������� �����������.")
					wait(1500)
					if command_stop then 
						command_stop = false 
						isActiveCommand = false
						if isMonetLoader() and settings.general.mobile_stop_button then
							CommandStopWindow[0] = false
						end
						sampAddChatMessage('[Government Helper] {ffffff}��������� ������� /spcar ������� �����������!', message_color) 
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
						sampAddChatMessage('[Government Helper] {ffffff}��������� ������� /spcar ������� �����������!', message_color) 
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
				sampAddChatMessage('[Government Helper] {ffffff}��������� ���������� ��������� ���������� �������!', message_color)
			end
		end)
		-- ����������� ���� ������ ������� ���� � json ��� 9/10
		registerCommandsFrom(settings.commands_manage) 
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
end
function show_fast_menu(id)
	if isParamSampID(id) then 
		player_id = tonumber(id)
		FastMenu[0] = true
	else
		if isMonetLoader() or settings.general.bind_fastmenu == nil then
			if not FastMenuPlayers[0] then
				sampAddChatMessage('[Government Helper] {ffffff}����������� ' .. message_color_hex .. '/gfm [ID]', message_color)
			end
		elseif settings.general.bind_fastmenu and settings.general.use_binds and hotkey_no_errors then
			sampAddChatMessage('[Government Helper] {ffffff}����������� ' .. message_color_hex .. '/gfm [ID] {ffffff}��� ���������� �� ������ ����� ' .. message_color_hex .. '��� + ' .. getNameKeysFrom(settings.general.bind_fastmenu), message_color) 
		else
			sampAddChatMessage('[Government Helper] {ffffff}����������� ' .. message_color_hex .. '/gfm [ID]', message_color)
		end 
	end 
end
function show_leader_fast_menu(id)
	if isParamSampID(id) then
		player_id = tonumber(id)
		LeaderFastMenu[0] = true
	else
		if isMonetLoader() or settings.general.bind_leader_fastmenu == nil then
			sampAddChatMessage('[Government Helper] {ffffff}����������� ' .. message_color_hex .. '/glm [ID]', message_color)
		elseif settings.general.bind_leader_fastmenu and settings.general.use_binds and hotkey_no_errors then
			sampAddChatMessage('[Government Helper] {ffffff}����������� ' .. message_color_hex .. '/glm [ID] {ffffff}��� ���������� �� ������ ����� ' .. message_color_hex .. '��� + ' .. getNameKeysFrom(settings.general.bind_leader_fastmenu), message_color) 
		else
			sampAddChatMessage('[Government Helper] {ffffff}����������� ' .. message_color_hex .. '/glm [ID]', message_color)
		end 
	end
end
function get_players()
	local myPlayerId = sampGetPlayerIdByCharHandle(PLAYER_PED)
	local myX, myY, myZ = getCharCoordinates(PLAYER_PED)
	local playersInRange = {}
	for temp1, h in pairs(getAllChars()) do
		temp2, id = sampGetPlayerIdByCharHandle(h)
		temp3, m = sampGetPlayerIdByCharHandle(PLAYER_PED)
		id = tonumber(id)
		if id ~= -1 and id ~= m and doesCharExist(h) then
			local x, y, z = getCharCoordinates(h)
			local mx, my, mz = getCharCoordinates(PLAYER_PED)
			local dist = getDistanceBetweenCoords3d(mx, my, mz, x, y, z)
			if dist <= 5 then
				table.insert(playersInRange, id)
			end
		end
	end
	return playersInRange
end
function show_arz_notify(type, title, text, time)
	if isMonetLoader() then
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
	if nick == sampGetPlayerNickname(myid) then return myid end
	for i = 0, 999 do
	    if sampIsPlayerConnected(i) and sampGetPlayerNickname(i) == nick then
		   id = i
		   break
	    end
	end
	return id
end

function sampev.onServerMessage(color,text)
	--sampAddChatMessage('color = ' .. color .. ' , text = '..text,-1)
	if (settings.general.auto_uval and tonumber(settings.player_info.fraction_rank_number) >= 9) then
		if text:find("%[(.-)%] (.-) (.-)%[(.-)%]: (.+)") and color == 766526463 then -- /f /fb ��� /r /rb ��� ���� 
			local tag, rank, name, playerID, message = string.match(text, "%[(.-)%] (.+) (.-)%[(.-)%]: (.+)")
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
		elseif text:find("%[(.-)%] %[(.-)%] (.+) (.-)%[(.-)%]: (.+)") and color == 766526463 then -- /r ��� /f � �����
			local tag, tag2, rank, name, playerID, message = string.match(text, "%[(.-)%] %[(.-)%] (.+) (.-)%[(.-)%]: (.+)")
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
		end
		
		if text:find("(.+) ��������%(�%) ������ (.+) �� 1 �����. �������: %[AutoUval%] ��������...") and auto_uval_checker then
			sampAddChatMessage(text, message_color)
			local Name, PlayerName, Time, Reason = text:match("(.+) ��������%(�%) ������ (.+) �� (%d+) �����. �������: (.+)")
			local MyName = sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)))
			if Name == MyName then
				sampAddChatMessage('[Government Helper] {ffffff}�������� ������ ' .. sampGetPlayerNickname(PlayerID) .. '!', message_color)
				auto_uval_checker = false
				temp = PlayerID .. ' ���'
				find_and_use_command("/uninvite {arg_id} {arg2}", temp)
			else
				sampAddChatMessage('[Government Helper] {ffffff}������ �����������/����� ��� ��������� ������ ' .. sampGetPlayerNickname(PlayerID) .. '!', message_color)
				auto_uval_checker = false
			end
		end
	end
	if (text:find("� (.+) ����������� �������� ������. �� ������ ������ ��� ������ � ������� ������� /givewbook") and tonumber(settings.player_info.fraction_rank_number) >= 9) then
		local nick = text:match("� (.+) ����������� �������� ������. �� ������ ������ ��� ������ � ������� ������� /givewbook")
		local cmd = '/givewbook'
		for _, command in ipairs(settings.commands_manage) do
			if command.enable and command.text:find('/givewbook {arg_id}') then
				cmd =  '/' .. command.cmd
			end
		end
		sampAddChatMessage('[Government Helper] {ffffff}� ������ ' .. nick .. ' ���� �������� ������, ������� � ��������� ' .. message_color_hex .. cmd .. ' ' .. sampGetPlayerIdByNickname(nick), message_color)
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
		sampAddChatMessage('[Government Helper] {ffffff}������ ��������� ��������������� �����:', message_color)
		sampAddChatMessage('[Government Helper] {ffffff}111 ������ | 60 ����� | 911 �� | 912 �� | 913 ����� | 914 ���� | 8828 ���� | 997 ����', message_color)
		return false
	end
end
function sampev.onSendChat(text)
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
	if settings.general.rp_chat then
		local chats =  { '/vr', '/fam', '/al', '/s', '/b', '/n', '/r', '/rb', '/f', '/fb', '/j', '/jb', '/m', '/do',   } 
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
function kvadrat()
    local KV = {
        [1] = "�",
        [2] = "�",
        [3] = "�",
        [4] = "�",
        [5] = "�",
        [6] = "�",
        [7] = "�",
        [8] = "�",
        [9] = "�",
        [10] = "�",
        [11] = "�",
        [12] = "�",
        [13] = "�",
        [14] = "�",
        [15] = "�",
        [16] = "�",
        [17] = "�",
        [18] = "�",
        [19] = "�",
        [20] = "�",
        [21] = "�",
        [22] = "�",
        [23] = "�",
        [24] = "�",
    }
    local X, Y, Z = getCharCoordinates(playerPed)
    X = math.ceil((X + 3000) / 250)
    Y = math.ceil((Y * - 1 + 3000) / 250)
    Y = KV[Y]
	if Y ~= nil then
		local KVX = (Y.."-"..X)
		return KVX
	else
		return X
	end
   
end
function calculateZoneRu(x, y, z)
    local streets = {
        {"���� ������", -2667.810, -302.135, -28.831, -2646.400, -262.320, 71.169},
        {"��������", -1315.420, -405.388, 15.406, -1264.400, -209.543, 25.406},
        {"���� ������", -2550.040, -355.493, 0.000, -2470.040, -318.493, 39.700},
        {"��������", -1490.330, -209.543, 15.406, -1264.400, -148.388, 25.406},
        {"������", -2395.140, -222.589, -5.3, -2354.090, -204.792, 200.000},
        {"�����-�����", -1632.830, -2263.440, -3.0, -1601.330, -2231.790, 200.000},
        {"��������� ��", 2381.680, -1494.030, -89.084, 2421.030, -1454.350, 110.916},
        {"�������� ����", 1236.630, 1163.410, -89.084, 1277.050, 1203.280, 110.916},
        {"����������� ��������", 1277.050, 1044.690, -89.084, 1315.350, 1087.630, 110.916},
        {"���� ������", -2470.040, -355.493, 0.000, -2270.040, -318.493, 46.100},
        {"�����", 1252.330, -926.999, -89.084, 1357.000, -910.170, 110.916},
        {"������� �����", 1692.620, -1971.800, -20.492, 1812.620, -1932.800, 79.508},
        {"�������� ���� ��", 1315.350, 1044.690, -89.084, 1375.600, 1087.630, 110.916},
        {"���-������", 2581.730, -1454.350, -89.084, 2632.830, -1393.420, 110.916},
        {"������", 2437.390, 1858.100, -39.084, 2495.090, 1970.850, 60.916},
        {"�������� �����-���", -1132.820, -787.391, 0.000, -956.476, -768.027, 200.000},
        {"������� �����", 1370.850, -1170.870, -89.084, 1463.900, -1130.850, 110.916},
        {"��������� ���������", -1620.300, 1176.520, -4.5, -1580.010, 1274.260, 200.000},
        {"������� ������", 787.461, -1410.930, -34.126, 866.009, -1310.210, 65.874},
        {"������� ������", 2811.250, 1229.590, -39.594, 2861.250, 1407.590, 60.406},
        {"����������� ����������", 1582.440, 347.457, 0.000, 1664.620, 401.750, 200.000},
        {"���� ��������", 2759.250, 296.501, 0.000, 2774.250, 594.757, 200.000},
        {"������� ������-����", 1377.480, 2600.430, -21.926, 1492.450, 2687.360, 78.074},
        {"������� �����", 1507.510, -1385.210, 110.916, 1582.550, -1325.310, 335.916},
        {"����������", 2185.330, -1210.740, -89.084, 2281.450, -1154.590, 110.916},
        {"����������", 1318.130, -910.170, -89.084, 1357.000, -768.027, 110.916},
        {"���� ������", -2361.510, -417.199, 0.000, -2270.040, -355.493, 200.000},
        {"����������", 1996.910, -1449.670, -89.084, 2056.860, -1350.720, 110.916},
        {"��������� �����", 1236.630, 2142.860, -89.084, 1297.470, 2243.230, 110.916},
        {"����������", 2124.660, -1494.030, -89.084, 2266.210, -1449.670, 110.916},
        {"�������� �����", 1848.400, 2478.490, -89.084, 1938.800, 2553.490, 110.916},
        {"�����", 422.680, -1570.200, -89.084, 466.223, -1406.050, 110.916},
        {"������� ���������", -2007.830, 56.306, 0.000, -1922.000, 224.782, 100.000},
        {"������� �����", 1391.050, -1026.330, -89.084, 1463.900, -926.999, 110.916},
        {"�������� ��������", 1704.590, 2243.230, -89.084, 1777.390, 2342.830, 110.916},
        {"��������� �������", 1758.900, -1722.260, -89.084, 1812.620, -1577.590, 110.916},
        {"����������� ��������", 1375.600, 823.228, -89.084, 1457.390, 919.447, 110.916},
        {"��������", 1974.630, -2394.330, -39.084, 2089.000, -2256.590, 60.916},
        {"�����-����", -399.633, -1075.520, -1.489, -319.033, -977.516, 198.511},
        {"�����", 334.503, -1501.950, -89.084, 422.680, -1406.050, 110.916},
        {"������", 225.165, -1369.620, -89.084, 334.503, -1292.070, 110.916},
        {"������� �����", 1724.760, -1250.900, -89.084, 1812.620, -1150.870, 110.916},
        {"�����-����", 2027.400, 1703.230, -89.084, 2137.400, 1783.230, 110.916},
        {"������� �����", 1378.330, -1130.850, -89.084, 1463.900, -1026.330, 110.916},
        {"����������� ��������", 1197.390, 1044.690, -89.084, 1277.050, 1163.390, 110.916},
        {"��������� �����", 1073.220, -1842.270, -89.084, 1323.900, -1804.210, 110.916},
        {"����������", 1451.400, 347.457, -6.1, 1582.440, 420.802, 200.000},
        {"������ ������", -2270.040, -430.276, -1.2, -2178.690, -324.114, 200.000},
        {"������� ��������", 1325.600, 596.349, -89.084, 1375.600, 795.010, 110.916},
        {"��������", 2051.630, -2597.260, -39.084, 2152.450, -2394.330, 60.916},
        {"����������", 1096.470, -910.170, -89.084, 1169.130, -768.027, 110.916},
        {"���� ��� ������", 1457.460, 2723.230, -89.084, 1534.560, 2863.230, 110.916},
        {"�����", 2027.400, 1783.230, -89.084, 2162.390, 1863.230, 110.916},
        {"����������", 2056.860, -1210.740, -89.084, 2185.330, -1126.320, 110.916},
        {"����������", 952.604, -937.184, -89.084, 1096.470, -860.619, 110.916},
        {"������-��������", -1372.140, 2498.520, 0.000, -1277.590, 2615.350, 200.000},
        {"���-�������", 2126.860, -1126.320, -89.084, 2185.330, -934.489, 110.916},
        {"���-�������", 1994.330, -1100.820, -89.084, 2056.860, -920.815, 110.916},
        {"������", 647.557, -954.662, -89.084, 768.694, -860.619, 110.916},
        {"�������� ����", 1277.050, 1087.630, -89.084, 1375.600, 1203.280, 110.916},
        {"�������� �����", 1377.390, 2433.230, -89.084, 1534.560, 2507.230, 110.916},
        {"����������", 2201.820, -2095.000, -89.084, 2324.000, -1989.900, 110.916},
        {"�������� �����", 1704.590, 2342.830, -89.084, 1848.400, 2433.230, 110.916},
        {"�����", 1252.330, -1130.850, -89.084, 1378.330, -1026.330, 110.916},
        {"��������� �������", 1701.900, -1842.270, -89.084, 1812.620, -1722.260, 110.916},
        {"�����", -2411.220, 373.539, 0.000, -2253.540, 458.411, 200.000},
        {"��������", 1515.810, 1586.400, -12.500, 1729.950, 1714.560, 87.500},
        {"������", 225.165, -1292.070, -89.084, 466.223, -1235.070, 110.916},
        {"�����", 1252.330, -1026.330, -89.084, 1391.050, -926.999, 110.916},
        {"��������� ��", 2266.260, -1494.030, -89.084, 2381.680, -1372.040, 110.916},
        {"���������� �����", 2623.180, 943.235, -89.084, 2749.900, 1055.960, 110.916},
        {"����������", 2541.700, -1941.400, -89.084, 2703.580, -1852.870, 110.916},
        {"���-�������", 2056.860, -1126.320, -89.084, 2126.860, -920.815, 110.916},
        {"���������� �����", 2625.160, 2202.760, -89.084, 2685.160, 2442.550, 110.916},
        {"�����", 225.165, -1501.950, -89.084, 334.503, -1369.620, 110.916},
        {"���-������", -365.167, 2123.010, -3.0, -208.570, 2217.680, 200.000},
        {"���������� �����", 2536.430, 2442.550, -89.084, 2685.160, 2542.550, 110.916},
        {"�����", 334.503, -1406.050, -89.084, 466.223, -1292.070, 110.916},
        {"�������", 647.557, -1227.280, -89.084, 787.461, -1118.280, 110.916},
        {"�����", 422.680, -1684.650, -89.084, 558.099, -1570.200, 110.916},
        {"�������� �����", 2498.210, 2542.550, -89.084, 2685.160, 2626.550, 110.916},
        {"������� �����", 1724.760, -1430.870, -89.084, 1812.620, -1250.900, 110.916},
        {"�����", 225.165, -1684.650, -89.084, 312.803, -1501.950, 110.916},
        {"����������", 2056.860, -1449.670, -89.084, 2266.210, -1372.040, 110.916},
        {"�������-�����", 603.035, 264.312, 0.000, 761.994, 366.572, 200.000},
        {"�����", 1096.470, -1130.840, -89.084, 1252.330, -1026.330, 110.916},
        {"���� �������", -1087.930, 855.370, -89.084, -961.950, 986.281, 110.916},
        {"���� ������", 1046.150, -1722.260, -89.084, 1161.520, -1577.590, 110.916},
        {"������������ �����", 1323.900, -1722.260, -89.084, 1440.900, -1577.590, 110.916},
        {"����������", 1357.000, -926.999, -89.084, 1463.900, -768.027, 110.916},
        {"�����", 466.223, -1570.200, -89.084, 558.099, -1385.070, 110.916},
        {"����������", 911.802, -860.619, -89.084, 1096.470, -768.027, 110.916},
        {"����������", 768.694, -954.662, -89.084, 952.604, -860.619, 110.916},
        {"����� �����", 2377.390, 788.894, -89.084, 2537.390, 897.901, 110.916},
        {"�������", 1812.620, -1852.870, -89.084, 1971.660, -1742.310, 110.916},
        {"��������� ����", 2089.000, -2394.330, -89.084, 2201.820, -2235.840, 110.916},
        {"������������ �����", 1370.850, -1577.590, -89.084, 1463.900, -1384.950, 110.916},
        {"�������� �����", 2121.400, 2508.230, -89.084, 2237.400, 2663.170, 110.916},
        {"�����", 1096.470, -1026.330, -89.084, 1252.330, -910.170, 110.916},
        {"���� ����", 1812.620, -1449.670, -89.084, 1996.910, -1350.720, 110.916},
        {"�������� �����-���", -1242.980, -50.096, 0.000, -1213.910, 578.396, 200.000},
        {"���� ������", -222.179, 293.324, 0.000, -122.126, 476.465, 200.000},
        {"�����", 2106.700, 1863.230, -89.084, 2162.390, 2202.760, 110.916},
        {"����������", 2541.700, -2059.230, -89.084, 2703.580, -1941.400, 110.916},
        {"����� ������", 807.922, -1577.590, -89.084, 926.922, -1416.250, 110.916},
        {"��������", 1457.370, 1143.210, -89.084, 1777.400, 1203.280, 110.916},
        {"�������", 1812.620, -1742.310, -89.084, 1951.660, -1602.310, 110.916},
        {"��������� ���������", -1580.010, 1025.980, -6.1, -1499.890, 1274.260, 200.000},
        {"������� �����", 1370.850, -1384.950, -89.084, 1463.900, -1170.870, 110.916},
        {"���� ����", 1664.620, 401.750, 0.000, 1785.140, 567.203, 200.000},
        {"�����", 312.803, -1684.650, -89.084, 422.680, -1501.950, 110.916},
        {"������� �������", 1440.900, -1722.260, -89.084, 1583.500, -1577.590, 110.916},
        {"����������", 687.802, -860.619, -89.084, 911.802, -768.027, 110.916},
        {"���� ����", -2741.070, 1490.470, -6.1, -2616.400, 1659.680, 200.000},
        {"���-�������", 2185.330, -1154.590, -89.084, 2281.450, -934.489, 110.916},
        {"����������", 1169.130, -910.170, -89.084, 1318.130, -768.027, 110.916},
        {"�������� �����", 1938.800, 2508.230, -89.084, 2121.400, 2624.230, 110.916},
        {"������������ �����", 1667.960, -1577.590, -89.084, 1812.620, -1430.870, 110.916},
        {"�����", 72.648, -1544.170, -89.084, 225.165, -1404.970, 110.916},
        {"����-���������", 2536.430, 2202.760, -89.084, 2625.160, 2442.550, 110.916},
        {"�����", 72.648, -1684.650, -89.084, 225.165, -1544.170, 110.916},
        {"����������� �����", 952.663, -1310.210, -89.084, 1072.660, -1130.850, 110.916},
        {"���-�������", 2632.740, -1135.040, -89.084, 2747.740, -945.035, 110.916},
        {"����������", 861.085, -674.885, -89.084, 1156.550, -600.896, 110.916},
        {"�����", -2253.540, 373.539, -9.1, -1993.280, 458.411, 200.000},
        {"��������� ��������", 1848.400, 2342.830, -89.084, 2011.940, 2478.490, 110.916},
        {"������� �����", -1580.010, 744.267, -6.1, -1499.890, 1025.980, 200.000},
        {"��������� �����", 1046.150, -1804.210, -89.084, 1323.900, -1722.260, 110.916},
        {"������", 647.557, -1118.280, -89.084, 787.461, -954.662, 110.916},
        {"�����-�����", -2994.490, 277.411, -9.1, -2867.850, 458.411, 200.000},
        {"������� ���������", 964.391, 930.890, -89.084, 1166.530, 1044.690, 110.916},
        {"���� ����", 1812.620, -1100.820, -89.084, 1994.330, -973.380, 110.916},
        {"�������� ����", 1375.600, 919.447, -89.084, 1457.370, 1203.280, 110.916},
        {"��������-���", -405.770, 1712.860, -3.0, -276.719, 1892.750, 200.000},
        {"���� ������", 1161.520, -1722.260, -89.084, 1323.900, -1577.590, 110.916},
        {"��������� ��", 2281.450, -1372.040, -89.084, 2381.680, -1135.040, 110.916},
        {"������ ��������", 2137.400, 1703.230, -89.084, 2437.390, 1783.230, 110.916},
        {"�������", 1951.660, -1742.310, -89.084, 2124.660, -1602.310, 110.916},
        {"��������", 2624.400, 1383.230, -89.084, 2685.160, 1783.230, 110.916},
        {"�������", 2124.660, -1742.310, -89.084, 2222.560, -1494.030, 110.916},
        {"�����", -2533.040, 458.411, 0.000, -2329.310, 578.396, 200.000},
        {"������� �����", -1871.720, 1176.420, -4.5, -1620.300, 1274.260, 200.000},
        {"������������ �����", 1583.500, -1722.260, -89.084, 1758.900, -1577.590, 110.916},
        {"��������� ��", 2381.680, -1454.350, -89.084, 2462.130, -1135.040, 110.916},
        {"����� ������", 647.712, -1577.590, -89.084, 807.922, -1416.250, 110.916},
        {"������", 72.648, -1404.970, -89.084, 225.165, -1235.070, 110.916},
        {"�������", 647.712, -1416.250, -89.084, 787.461, -1227.280, 110.916},
        {"��������� ��", 2222.560, -1628.530, -89.084, 2421.030, -1494.030, 110.916},
        {"�����", 558.099, -1684.650, -89.084, 647.522, -1384.930, 110.916},
        {"��������� �������", -1709.710, -833.034, -1.5, -1446.010, -730.118, 200.000},
        {"�����", 466.223, -1385.070, -89.084, 647.522, -1235.070, 110.916},
        {"��������� ��������", 1817.390, 2202.760, -89.084, 2011.940, 2342.830, 110.916},
        {"������", 2162.390, 1783.230, -89.084, 2437.390, 1883.230, 110.916},
        {"�������", 1971.660, -1852.870, -89.084, 2222.560, -1742.310, 110.916},
        {"����������� ����������", 1546.650, 208.164, 0.000, 1745.830, 347.457, 200.000},
        {"����������", 2089.000, -2235.840, -89.084, 2201.820, -1989.900, 110.916},
        {"�����", 952.663, -1130.840, -89.084, 1096.470, -937.184, 110.916},
        {"�����-����", 1848.400, 2553.490, -89.084, 1938.800, 2863.230, 110.916},
        {"��������", 1400.970, -2669.260, -39.084, 2189.820, -2597.260, 60.916},
        {"���� ������", -1213.910, 950.022, -89.084, -1087.930, 1178.930, 110.916},
        {"���� ������", -1339.890, 828.129, -89.084, -1213.910, 1057.040, 110.916},
        {"���� �������", -1339.890, 599.218, -89.084, -1213.910, 828.129, 110.916},
        {"���� �������", -1213.910, 721.111, -89.084, -1087.930, 950.022, 110.916},
        {"���� ������", 930.221, -2006.780, -89.084, 1073.220, -1804.210, 110.916},
        {"������������", 1073.220, -2006.780, -89.084, 1249.620, -1842.270, 110.916},
        {"���� �������", 787.461, -1130.840, -89.084, 952.604, -954.662, 110.916},
        {"���� �������", 787.461, -1310.210, -89.084, 952.663, -1130.840, 110.916},
        {"������������ �����", 1463.900, -1577.590, -89.084, 1667.960, -1430.870, 110.916},
        {"����������� �����", 787.461, -1416.250, -89.084, 1072.660, -1310.210, 110.916},
        {"�������� ������", 2377.390, 596.349, -89.084, 2537.390, 788.894, 110.916},
        {"�������� �����", 2237.400, 2542.550, -89.084, 2498.210, 2663.170, 110.916},
        {"��������� ����", 2632.830, -1668.130, -89.084, 2747.740, -1393.420, 110.916},
        {"���� ������", 434.341, 366.572, 0.000, 603.035, 555.680, 200.000},
        {"����������", 2089.000, -1989.900, -89.084, 2324.000, -1852.870, 110.916},
        {"���������", -2274.170, 578.396, -7.6, -2078.670, 744.170, 200.000},
        {"��������� ������", -208.570, 2337.180, 0.000, 8.430, 2487.180, 200.000},
        {"��������� ����", 2324.000, -2145.100, -89.084, 2703.580, -2059.230, 110.916},
        {"�������� �����-���", -1132.820, -768.027, 0.000, -956.476, -578.118, 200.000},
        {"������ �����", 1817.390, 1703.230, -89.084, 2027.400, 1863.230, 110.916},
        {"�����-�����", -2994.490, -430.276, -1.2, -2831.890, -222.589, 200.000},
        {"������", 321.356, -860.619, -89.084, 687.802, -768.027, 110.916},
        {"�������� ��������", 176.581, 1305.450, -3.0, 338.658, 1520.720, 200.000},
        {"������", 321.356, -768.027, -89.084, 700.794, -674.885, 110.916},
        {"������", 2162.390, 1883.230, -89.084, 2437.390, 2012.180, 110.916},
        {"��������� ����", 2747.740, -1668.130, -89.084, 2959.350, -1498.620, 110.916},
        {"����������", 2056.860, -1372.040, -89.084, 2281.450, -1210.740, 110.916},
        {"������� �����", 1463.900, -1290.870, -89.084, 1724.760, -1150.870, 110.916},
        {"������� �����", 1463.900, -1430.870, -89.084, 1724.760, -1290.870, 110.916},
        {"���� ������", -1499.890, 696.442, -179.615, -1339.890, 925.353, 20.385},
        {"����� �����", 1457.390, 823.228, -89.084, 2377.390, 863.229, 110.916},
        {"��������� ��", 2421.030, -1628.530, -89.084, 2632.830, -1454.350, 110.916},
        {"������� ���������", 964.391, 1044.690, -89.084, 1197.390, 1203.220, 110.916},
        {"���-�������", 2747.740, -1120.040, -89.084, 2959.350, -945.035, 110.916},
        {"����������", 737.573, -768.027, -89.084, 1142.290, -674.885, 110.916},
        {"��������� ����", 2201.820, -2730.880, -89.084, 2324.000, -2418.330, 110.916},
        {"��������� ��", 2462.130, -1454.350, -89.084, 2581.730, -1135.040, 110.916},
        {"������", 2222.560, -1722.330, -89.084, 2632.830, -1628.530, 110.916},
        {"���� ������", -2831.890, -430.276, -6.1, -2646.400, -222.589, 200.000},
        {"����������", 1970.620, -2179.250, -89.084, 2089.000, -1852.870, 110.916},
        {"�������� ���������", -1982.320, 1274.260, -4.5, -1524.240, 1358.900, 200.000},
        {"������ ���-������", 1817.390, 1283.230, -89.084, 2027.390, 1469.230, 110.916},
        {"��������� ����", 2201.820, -2418.330, -89.084, 2324.000, -2095.000, 110.916},
        {"������", 1823.080, 596.349, -89.084, 1997.220, 823.228, 110.916},
        {"��������-������", -2353.170, 2275.790, 0.000, -2153.170, 2475.790, 200.000},
        {"�����", -2329.310, 458.411, -7.6, -1993.280, 578.396, 200.000},
        {"���-������", 1692.620, -2179.250, -89.084, 1812.620, -1842.270, 110.916},
        {"������� ��������", 1375.600, 596.349, -89.084, 1558.090, 823.228, 110.916},
        {"������� ������", 1817.390, 1083.230, -89.084, 2027.390, 1283.230, 110.916},
        {"�������� �����", 1197.390, 1163.390, -89.084, 1236.630, 2243.230, 110.916},
        {"���-������", 2581.730, -1393.420, -89.084, 2747.740, -1135.040, 110.916},
        {"������ �����", 1817.390, 1863.230, -89.084, 2106.700, 2011.830, 110.916},
        {"�����-����", 1938.800, 2624.230, -89.084, 2121.400, 2861.550, 110.916},
        {"���� ������", 851.449, -1804.210, -89.084, 1046.150, -1577.590, 110.916},
        {"����������� ������", -1119.010, 1178.930, -89.084, -862.025, 1351.450, 110.916},
        {"������-����", 2749.900, 943.235, -89.084, 2923.390, 1198.990, 110.916},
        {"��������� ����", 2703.580, -2302.330, -89.084, 2959.350, -2126.900, 110.916},
        {"����������", 2324.000, -2059.230, -89.084, 2541.700, -1852.870, 110.916},
        {"�����", -2411.220, 265.243, -9.1, -1993.280, 373.539, 200.000},
        {"������������ �����", 1323.900, -1842.270, -89.084, 1701.900, -1722.260, 110.916},
        {"����������", 1269.130, -768.027, -89.084, 1414.070, -452.425, 110.916},
        {"����� ������", 647.712, -1804.210, -89.084, 851.449, -1577.590, 110.916},
        {"�������-�����", -2741.070, 1268.410, -4.5, -2533.040, 1490.470, 200.000},
        {"������ 4 �������", 1817.390, 863.232, -89.084, 2027.390, 1083.230, 110.916},
        {"��������", 964.391, 1203.220, -89.084, 1197.390, 1403.220, 110.916},
        {"�������� �����", 1534.560, 2433.230, -89.084, 1848.400, 2583.230, 110.916},
        {"���� ��� ������", 1117.400, 2723.230, -89.084, 1457.460, 2863.230, 110.916},
        {"�������", 1812.620, -1602.310, -89.084, 2124.660, -1449.670, 110.916},
        {"�������� ��������", 1297.470, 2142.860, -89.084, 1777.390, 2243.230, 110.916},
        {"������", -2270.040, -324.114, -1.2, -1794.920, -222.589, 200.000},
        {"����� �������", 967.383, -450.390, -3.0, 1176.780, -217.900, 200.000},
        {"���-���������", -926.130, 1398.730, -3.0, -719.234, 1634.690, 200.000},
        {"������ ������", 1817.390, 1469.230, -89.084, 2027.400, 1703.230, 110.916},
        {"���� ����", -2867.850, 277.411, -9.1, -2593.440, 458.411, 200.000},
        {"���� ������", -2646.400, -355.493, 0.000, -2270.040, -222.589, 200.000},
        {"�����", 2027.400, 863.229, -89.084, 2087.390, 1703.230, 110.916},
        {"�������", -2593.440, -222.589, -1.0, -2411.220, 54.722, 200.000},
        {"��������", 1852.000, -2394.330, -89.084, 2089.000, -2179.250, 110.916},
        {"�������-�������", 1098.310, 1726.220, -89.084, 1197.390, 2243.230, 110.916},
        {"�������������", -789.737, 1659.680, -89.084, -599.505, 1929.410, 110.916},
        {"���-������", 1812.620, -2179.250, -89.084, 1970.620, -1852.870, 110.916},
        {"������� �����", -1700.010, 744.267, -6.1, -1580.010, 1176.520, 200.000},
        {"������ ������", -2178.690, -1250.970, 0.000, -1794.920, -1115.580, 200.000},
        {"���-��������", -354.332, 2580.360, 2.0, -133.625, 2816.820, 200.000},
        {"������ ���������", -936.668, 2611.440, 2.0, -715.961, 2847.900, 200.000},
        {"����������� ��������", 1166.530, 795.010, -89.084, 1375.600, 1044.690, 110.916},
        {"������", 2222.560, -1852.870, -89.084, 2632.830, -1722.330, 110.916},
        {"�������� �����-���", -1213.910, -730.118, 0.000, -1132.820, -50.096, 200.000},
        {"��������� ��������", 1817.390, 2011.830, -89.084, 2106.700, 2202.760, 110.916},
        {"��������� ���������", -1499.890, 578.396, -79.615, -1339.890, 1274.260, 20.385},
        {"������ ��������", 2087.390, 1543.230, -89.084, 2437.390, 1703.230, 110.916},
        {"������ �����", 2087.390, 1383.230, -89.084, 2437.390, 1543.230, 110.916},
        {"������", 72.648, -1235.070, -89.084, 321.356, -1008.150, 110.916},
        {"������", 2437.390, 1783.230, -89.084, 2685.160, 2012.180, 110.916},
        {"����������", 1281.130, -452.425, -89.084, 1641.130, -290.913, 110.916},
        {"������� �����", -1982.320, 744.170, -6.1, -1871.720, 1274.260, 200.000},
        {"�����-�����-�����", 2576.920, 62.158, 0.000, 2759.250, 385.503, 200.000},
        {"������� ����� �������", 2498.210, 2626.550, -89.084, 2749.900, 2861.550, 110.916},
        {"����� �����-����", 1777.390, 863.232, -89.084, 1817.390, 2342.830, 110.916},
        {"������� �������", -2290.190, 2548.290, -89.084, -1950.190, 2723.290, 110.916},
        {"��������� ����", 2324.000, -2302.330, -89.084, 2703.580, -2145.100, 110.916},
        {"������", 321.356, -1044.070, -89.084, 647.557, -860.619, 110.916},
        {"��������� ���������", 1558.090, 596.349, -89.084, 1823.080, 823.235, 110.916},
        {"��������� ����", 2632.830, -1852.870, -89.084, 2959.350, -1668.130, 110.916},
        {"�����-�����", -314.426, -753.874, -89.084, -106.339, -463.073, 110.916},
        {"��������", 19.607, -404.136, 3.8, 349.607, -220.137, 200.000},
        {"������� ������", 2749.900, 1198.990, -89.084, 2923.390, 1548.990, 110.916},
        {"���� ����", 1812.620, -1350.720, -89.084, 2056.860, -1100.820, 110.916},
        {"������� �����", -1993.280, 265.243, -9.1, -1794.920, 578.396, 200.000},
        {"�������� ��������", 1377.390, 2243.230, -89.084, 1704.590, 2433.230, 110.916},
        {"������", 321.356, -1235.070, -89.084, 647.522, -1044.070, 110.916},
        {"���� ����", -2741.450, 1659.680, -6.1, -2616.400, 2175.150, 200.000},
        {"��� Probe Inn", -90.218, 1286.850, -3.0, 153.859, 1554.120, 200.000},
        {"����������� �����", -187.700, -1596.760, -89.084, 17.063, -1276.600, 110.916},
        {"���-�������", 2281.450, -1135.040, -89.084, 2632.740, -945.035, 110.916},
        {"������-����-����", 2749.900, 1548.990, -89.084, 2923.390, 1937.250, 110.916},
        {"���������� ������", 2011.940, 2202.760, -89.084, 2237.400, 2508.230, 110.916},
        {"��������� ������", -208.570, 2123.010, -7.6, 114.033, 2337.180, 200.000},
        {"�����-�����", -2741.070, 458.411, -7.6, -2533.040, 793.411, 200.000},
        {"�����-����-������", 2703.580, -2126.900, -89.084, 2959.350, -1852.870, 110.916},
        {"����������� �����", 926.922, -1577.590, -89.084, 1370.850, -1416.250, 110.916},
        {"�����", -2593.440, 54.722, 0.000, -2411.220, 458.411, 200.000},
        {"����������� ������", 1098.390, 2243.230, -89.084, 1377.390, 2507.230, 110.916},
        {"��������", 2121.400, 2663.170, -89.084, 2498.210, 2861.550, 110.916},
        {"��������", 2437.390, 1383.230, -89.084, 2624.400, 1783.230, 110.916},
        {"��������", 964.391, 1403.220, -89.084, 1197.390, 1726.220, 110.916},
        {"������� ���", -410.020, 1403.340, -3.0, -137.969, 1681.230, 200.000},
        {"��������", 580.794, -674.885, -9.5, 861.085, -404.790, 200.000},
        {"���-��������", -1645.230, 2498.520, 0.000, -1372.140, 2777.850, 200.000},
        {"�������� ���������", -2533.040, 1358.900, -4.5, -1996.660, 1501.210, 200.000},
        {"�������� �����-���", -1499.890, -50.096, -1.0, -1242.980, 249.904, 200.000},
        {"�������� ������", 1916.990, -233.323, -100.000, 2131.720, 13.800, 200.000},
        {"����������", 1414.070, -768.027, -89.084, 1667.610, -452.425, 110.916},
        {"��������� ����", 2747.740, -1498.620, -89.084, 2959.350, -1120.040, 110.916},
        {"���-������� �����", 2450.390, 385.503, -100.000, 2759.250, 562.349, 200.000},
        {"�������� �����", -2030.120, -2174.890, -6.1, -1820.640, -1771.660, 200.000},
        {"����������� �����", 1072.660, -1416.250, -89.084, 1370.850, -1130.850, 110.916},
        {"�������� ������", 1997.220, 596.349, -89.084, 2377.390, 823.228, 110.916},
        {"�����-����", 1534.560, 2583.230, -89.084, 1848.400, 2863.230, 110.916},
        {"����� �����", -1794.920, -50.096, -1.04, -1499.890, 249.904, 200.000},
        {"����-������", -1166.970, -1856.030, 0.000, -815.624, -1602.070, 200.000},
        {"�������� ����", 1457.390, 863.229, -89.084, 1777.400, 1143.210, 110.916},
        {"�����-����", 1117.400, 2507.230, -89.084, 1534.560, 2723.230, 110.916},
        {"��������", 104.534, -220.137, 2.3, 349.607, 152.236, 200.000},
        {"��������� ������", -464.515, 2217.680, 0.000, -208.570, 2580.360, 200.000},
        {"������� �����", -2078.670, 578.396, -7.6, -1499.890, 744.267, 200.000},
        {"��������� ������", 2537.390, 676.549, -89.084, 2902.350, 943.235, 110.916},
        {"����� ���-������", -2616.400, 1501.210, -3.0, -1996.660, 1659.680, 200.000},
        {"��������", -2741.070, 793.411, -6.1, -2533.040, 1268.410, 200.000},
        {"������", 2087.390, 1203.230, -89.084, 2640.400, 1383.230, 110.916},
        {"���-��������-�����", 2162.390, 2012.180, -89.084, 2685.160, 2202.760, 110.916},
        {"��������-����", -2533.040, 578.396, -7.6, -2274.170, 968.369, 200.000},
        {"��������-������", -2533.040, 968.369, -6.1, -2274.170, 1358.900, 200.000},
        {"����-���������", 2237.400, 2202.760, -89.084, 2536.430, 2542.550, 110.916},
        {"���������� �����", 2685.160, 1055.960, -89.084, 2749.900, 2626.550, 110.916},
        {"���� ������", 647.712, -2173.290, -89.084, 930.221, -1804.210, 110.916},
        {"������ ������", -2178.690, -599.884, -1.2, -1794.920, -324.114, 200.000},
        {"����-����-�����", -901.129, 2221.860, 0.000, -592.090, 2571.970, 200.000},
        {"������� ������", -792.254, -698.555, -5.3, -452.404, -380.043, 200.000},
        {"�����", -1209.670, -1317.100, 114.981, -908.161, -787.391, 251.981},
        {"����� �������", -968.772, 1929.410, -3.0, -481.126, 2155.260, 200.000},
        {"�������� ���������", -1996.660, 1358.900, -4.5, -1524.240, 1592.510, 200.000},
        {"���������� �����", -1871.720, 744.170, -6.1, -1701.300, 1176.420, 300.000},
        {"������", -2411.220, -222.589, -1.14, -2173.040, 265.243, 200.000},
        {"����������", 1119.510, 119.526, -3.0, 1451.400, 493.323, 200.000},
        {"����", 2749.900, 1937.250, -89.084, 2921.620, 2669.790, 110.916},
        {"��������", 1249.620, -2394.330, -89.084, 1852.000, -2179.250, 110.916},
        {"���� �����-�����", 72.648, -2173.290, -89.084, 342.648, -1684.650, 110.916},
        {"����������� ����������", 1463.900, -1150.870, -89.084, 1812.620, -768.027, 110.916},
        {"�������-����", -2324.940, -2584.290, -6.1, -1964.220, -2212.110, 200.000},
        {"¸�����-������", 37.032, 2337.180, -3.0, 435.988, 2677.900, 200.000},
        {"�����-�������", 338.658, 1228.510, 0.000, 664.308, 1655.050, 200.000},
        {"������ ���-�-���", 2087.390, 943.235, -89.084, 2623.180, 1203.230, 110.916},
        {"�������� ��������", 1236.630, 1883.110, -89.084, 1777.390, 2142.860, 110.916},
        {"���� �����-�����", 342.648, -2173.290, -89.084, 647.712, -1684.650, 110.916},
        {"������������", 1249.620, -2179.250, -89.084, 1692.620, -1842.270, 110.916},
        {"��������", 1236.630, 1203.280, -89.084, 1457.370, 1883.110, 110.916},
        {"����� �����", -594.191, -1648.550, 0.000, -187.700, -1276.600, 200.000},
        {"������������", 930.221, -2488.420, -89.084, 1249.620, -2006.780, 110.916},
        {"�������� ����", 2160.220, -149.004, 0.000, 2576.920, 228.322, 200.000},
        {"��������� ����", 2373.770, -2697.090, -89.084, 2809.220, -2330.460, 110.916},
        {"�������� �����-���", -1213.910, -50.096, -4.5, -947.980, 578.396, 200.000},
        {"�������-�������", 883.308, 1726.220, -89.084, 1098.310, 2507.230, 110.916},
        {"������-�����", -2274.170, 744.170, -6.1, -1982.320, 1358.900, 200.000},
        {"����� �����", -1794.920, 249.904, -9.1, -1242.980, 578.396, 200.000},
        {"����� ��", -321.744, -2224.430, -89.084, 44.615, -1724.430, 110.916},
        {"������", -2173.040, -222.589, -1.0, -1794.920, 265.243, 200.000},
        {"���� ������", -2178.690, -2189.910, -47.917, -2030.120, -1771.660, 576.083},
        {"����-������", -376.233, 826.326, -3.0, 123.717, 1220.440, 200.000},
        {"������ ������", -2178.690, -1115.580, 0.000, -1794.920, -599.884, 200.000},
        {"�����-�����", -2994.490, -222.589, -1.0, -2593.440, 277.411, 200.000},
        {"����-����", 508.189, -139.259, 0.000, 1306.660, 119.526, 200.000},
        {"�������", -2741.070, 2175.150, 0.000, -2353.170, 2722.790, 200.000},
        {"��������", 1457.370, 1203.280, -89.084, 1777.390, 1883.110, 110.916},
        {"�������� ��������", -319.676, -220.137, 0.000, 104.534, 293.324, 200.000},
        {"���������", -2994.490, 458.411, -6.1, -2741.070, 1339.610, 200.000},
        {"����-���", 2285.370, -768.027, 0.000, 2770.590, -269.740, 200.000},
        {"������ ������", 337.244, 710.840, -115.239, 860.554, 1031.710, 203.761},
        {"��������", 1382.730, -2730.880, -89.084, 2201.820, -2394.330, 110.916},
        {"���������-����", -2994.490, -811.276, 0.000, -2178.690, -430.276, 200.000},
        {"����� ��", -2616.400, 1659.680, -3.0, -1996.660, 2175.150, 200.000},
        {"��������� ����", -91.586, 1655.050, -50.000, 421.234, 2123.010, 250.000},
        {"���� ������", -2997.470, -1115.580, -47.917, -2178.690, -971.913, 576.083},
        {"���� ������", -2178.690, -1771.660, -47.917, -1936.120, -1250.970, 576.083},
        {"�������� �����-���", -1794.920, -730.118, -3.0, -1213.910, -50.096, 200.000},
        {"����������", -947.980, -304.320, -1.1, -319.676, 327.071, 200.000},
        {"�������� �����", -1820.640, -2643.680, -8.0, -1226.780, -1771.660, 200.000},
        {"���-�-������", -1166.970, -2641.190, 0.000, -321.744, -1856.030, 200.000},
        {"���� ������", -2994.490, -2189.910, -47.917, -2178.690, -1115.580, 576.083},
        {"������ ������", -1213.910, 596.349, -242.990, -480.539, 1659.680, 900.000},
        {"����� �����", -1213.910, -2892.970, -242.990, 44.615, -768.027, 900.000},
        {"��������", -2997.470, -2892.970, -242.990, -1213.910, -1115.580, 900.000},
        {"��������� �����", -480.539, 596.349, -242.990, 869.461, 2993.870, 900.000},
        {"������ ������", -2997.470, 1659.680, -242.990, -480.539, 2993.870, 900.000},
        {"���������� ��", -2997.470, -1115.580, -242.990, -1213.910, 1659.680, 900.000},
        {"���������� ��", 869.461, 596.349, -242.990, 2997.060, 2993.870, 900.000},
        {"�������� �����", -1213.910, -768.027, -242.990, 2997.060, 596.349, 900.000},
        {"���������� ��", 44.615, -2892.970, -242.990, 2997.060, -768.027, 900.000}
    }
    for i, v in ipairs(streets) do
        if (x >= v[2]) and (y >= v[3]) and (z >= v[4]) and (x <= v[5]) and (y <= v[6]) and (z <= v[7]) then
            return v[1]
        end
    end
    return '����������'
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
function sampev.onShowDialog(dialogid, style, title, button1, button2, text)

	
	
	if title:find('�������� ����������') and check_stats then -- ��������� ����������
		if text:find("{FFFFFF}���: {B83434}%[(.-)]") then
			settings.player_info.name_surname = TranslateNick(text:match("{FFFFFF}���: {B83434}%[(.-)]"))
			input_name_surname = imgui.new.char[256](u8(settings.player_info.name_surname))
			sampAddChatMessage('[Government Helper] {ffffff}���� ��� � ������� ����������, �� - ' .. settings.player_info.name_surname, message_color)
		end
		if text:find("{FFFFFF}���: {B83434}%[(.-)]") then
			settings.player_info.sex = text:match("{FFFFFF}���: {B83434}%[(.-)]")
			sampAddChatMessage('[Government Helper] {ffffff}��� ��� ���������, �� - ' .. settings.player_info.sex, message_color)
		end
		if text:find("{FFFFFF}�����������: {B83434}%[(.-)]") then
			settings.player_info.fraction = text:match("{FFFFFF}�����������: {B83434}%[(.-)]")
			if settings.player_info.fraction == '�� �������' then
				sampAddChatMessage('[Government Helper] {ffffff}�� �� �������� � �����������!',message_color)
				settings.player_info.fraction_tag = "����������"
			else
				sampAddChatMessage('[Government Helper] {ffffff}���� ����������� ����������, ���: '..settings.player_info.fraction, message_color)
				if settings.player_info.fraction == '�������������' or settings.player_info.fraction:find("���(.+)��") then
					settings.player_info.fraction_tag = '���-��'
				else
					settings.player_info.fraction_tag = 'Government'
				end
				settings.deportament.dep_tag1 = '[' .. settings.player_info.fraction_tag .. ']'
				input_dep_tag1 = imgui.new.char[32](u8(settings.deportament.dep_tag1))
				input_fraction_tag = imgui.new.char[256](u8(settings.player_info.fraction_tag))
				sampAddChatMessage('[Government Helper] {ffffff}����� ����������� �������� ��� '..settings.player_info.fraction_tag .. ". �� �� ������ �������� ���.", message_color)
			end
		end
		if text:find("{FFFFFF}���������: {B83434}(.+)%((%d+)%)") then
			settings.player_info.fraction_rank, settings.player_info.fraction_rank_number = text:match("{FFFFFF}���������: {B83434}(.+)%((%d+)%)(.+)������� �������")
			sampAddChatMessage('[Government Helper] {ffffff}���� ��������� ����������, ���: '..settings.player_info.fraction_rank.." ("..settings.player_info.fraction_rank_number..")", message_color)
			if tonumber(settings.player_info.fraction_rank_number) >= 9 then
				settings.general.auto_uval = true
				initialize_commands()
			end
		else
			settings.player_info.fraction_rank = "����������"
			settings.player_info.fraction_rank_number = 0
			sampAddChatMessage('[Government Helper] {ffffff}��������� ������, �� ���� �������� ��� ����!',message_color)
		end
		save_settings()
		sampSendDialogResponse(235, 0,0,0)
		check_stats = false

		return false
	end

	if spawncar_bool and title:find('$') and text:find('����� ����������') then -- ����� ����������
		sampSendDialogResponse(dialogid, 2, 3, 0)
		spawncar_bool = false
		return false 
	end
	
	if vc_vize_bool and text:find('���������� ������������ �� ������������ � Vice City') then -- VS Visa [0]
		sampSendDialogResponse(dialogid, 1, 8, 0)
		return false 
	end
	
	if vc_vize_bool and title:find('������ ���������� �� ������� Vice City') then -- VS Visa [1]
		vc_vize_bool = false
		sampSendChat("/r ���������� "..TranslateNick(sampGetPlayerNickname(tonumber(vc_vize_player_id))).." ������ ���� Vice City!")
		sampSendDialogResponse(dialogid, 1, 0, tostring(vc_vize_player_id))
		return false 
	end
	
	if vc_vize_bool and title:find('������� ���������� �� ������� Vice City') then -- VS Visa [2]
		vc_vize_bool = false
		sampSendChat("/r � ���������� "..TranslateNick(sampGetPlayerNickname(tonumber(vc_vize_player_id))).." ���� ������ ���� Vice City!")
		sampSendDialogResponse(dialogid, 1, 0, tostring(sampGetPlayerNickname(vc_vize_player_id)))
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
				local color, nickname, id, rank, rank_number, color2, warns, afk = string.match(line, "{(%x+)}([^%(]+)%((%d+)%)%s+([^%(]+)%((%d+)%)%s+{(%x+)}(%d+) %((%d)(.+)��")
				if color ~= nil and nickname ~= nil and id ~= nil and rank ~= nil and rank_number ~= nil and warns ~= nil and afk ~= nil then
					local working = false
					if color:find('FF3B3B') then
						working = false
					elseif color:find('FFFFFF') then
						working = true
					end
					table.insert(members_new, { nick = nickname, id = id, rank = rank, rank_number = rank_number, warns = warns, afk = afk, working = working })
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
        else
            sampSendDialogResponse(dialogid, 0, 0, 0)
			members = members_new
			members_check = false
			MembersWindow[0] = true
        end
        return false
    end
	if title:find('�������� ���� ��� (.+)') and text:find('��������') then -- invite
		sampSendDialogResponse(dialogid, 1, 0, 0)
		return false
	end
end

-- function OnShowCEFDialog(dialogid) end
function onReceivePacket(id, bs)  
	if isMonetLoader() then
		if id == 220 then
			local id = raknetBitStreamReadInt8(bs)
			local _1 = raknetBitStreamReadInt8(bs)
			local _2 = raknetBitStreamReadInt16(bs)
			local _3 = raknetBitStreamReadInt32(bs)
			-- �������������� ���� ��� ������ "�������� ��������" � "������ �� ����" (����� �� ���� XRLM)
			if _3 > 2 and _3 <= raknetBitStreamGetNumberOfUnreadBits(bs) then
				local _4 = raknetBitStreamReadString(bs, _3)
				if _4:find('{"progress":%d+,"text":"��� ��������������, ��������� �� ������ ����������"}') then
					clicked = true
				end
			end
		end
	else
		if id == 220 then
			raknetBitStreamIgnoreBits(bs, 8)
			if raknetBitStreamReadInt8(bs) == 17 then
				raknetBitStreamIgnoreBits(bs, 32)
				local cmd2 = raknetBitStreamReadString(bs, raknetBitStreamReadInt32(bs))

				-- �������������� ���� ��� �� "�������� ��������" � "������ �� ����" (����� �� ���� Chapo)
				local view = string.match(cmd2, "^window.executeEvent%('event%.setActiveView', [`']%[[\"%s]?(.-)[\"%s]?%][`']%);$")
				if view ~= nil then
					clicked = (view == "Clicker")
				end

				if cmd2:find('�������� ����������') and check_stats then -- /hme
					sampAddChatMessage('[Government Helper] {ffffff}������, �� ���� �������� ������ �� ������ CEF �������!', message_color)
					sampAddChatMessage('[Government Helper] {ffffff}�������� ������ (������������) ��� �������� � /settings - ������������ ����������', message_color)
					run_code("window.executeEvent('cef.modals.closeModal', `[\"dialog\"]`);")
				end
			
				
			end
		end
	end
end
function onSendPacket(id, bs)
	if id == 220 and isMonetLoader() then
		-- �������������� ���� ��� ������ "�������� ��������" � "������ �� ����" (����� �� ���� XRLM)
		local id = raknetBitStreamReadInt8(bs)
		local _1 = raknetBitStreamReadInt8(bs)
		local _2 = raknetBitStreamReadInt8(bs)
		if _1 == 66 and (_2 == 25 or _2 == 8) then
			clicked = false
		end
	end
end

imgui.OnInitialize(function()
	imgui.GetIO().IniFilename = ni
	fa.Init(14 * MONET_DPI_SCALE)
	if settings.general.moonmonet_theme_enable and monet_no_errors then
		apply_moonmonet_theme()
	else 
		apply_dark_theme()
	end
end)

imgui.OnFrame(
    function() return MainWindow[0] end,
    function(player)
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(600 * MONET_DPI_SCALE, 425	* MONET_DPI_SCALE), imgui.Cond.FirstUseEver)
		imgui.Begin(fa.HOSPITAL.." Government Helper##main", MainWindow, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize )
		if imgui.BeginTabBar('Tabs') then	
			if imgui.BeginTabItem(fa.HOUSE..u8'   ������� ����  ') then
				if imgui.BeginChild('##1', imgui.ImVec2(590 * MONET_DPI_SCALE, 172 * MONET_DPI_SCALE), true) then
					imgui.CenterText(fa.ID_CARD .. u8' ���������� ��� ����������')
					imgui.Separator()
					imgui.Columns(3)
					imgui.CenterColumnText(u8"��� � �������:")
					imgui.SetColumnWidth(-1, 230 * MONET_DPI_SCALE)
					imgui.NextColumn()
					imgui.CenterColumnText(u8(settings.player_info.name_surname))
					imgui.SetColumnWidth(-1, 250 * MONET_DPI_SCALE)
					imgui.NextColumn()
					if imgui.CenterColumnSmallButton(u8'��������##name_surname') then
						settings.player_info.name_surname = TranslateNick(sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))))
						input_name_surname = imgui.new.char[256](u8(settings.player_info.name_surname))
						save_settings()
						imgui.OpenPopup(fa.USER_DOCTOR .. u8' ��� � �������##name_surname')
					end
					if imgui.BeginPopupModal(fa.USER_DOCTOR .. u8' ��� � �������##name_surname', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize  ) then
						imgui.PushItemWidth(405 * MONET_DPI_SCALE)
						imgui.InputText(u8'##name_surname', input_name_surname, 256) 
						imgui.Separator()
						if imgui.Button(fa.CIRCLE_XMARK .. u8' ������', imgui.ImVec2(200 * MONET_DPI_SCALE, 25 * MONET_DPI_SCALE)) then
							imgui.CloseCurrentPopup()
						end
						imgui.SameLine()
						if imgui.Button(fa.FLOPPY_DISK .. u8' ���������', imgui.ImVec2(200 * MONET_DPI_SCALE, 25 * MONET_DPI_SCALE)) then
							settings.player_info.name_surname = u8:decode(ffi.string(input_name_surname))
							save_settings()
							imgui.CloseCurrentPopup()
						end
						imgui.End()
					end
					imgui.SetColumnWidth(-1, 100 * MONET_DPI_SCALE)
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
						imgui.OpenPopup(fa.USER_DOCTOR .. u8' ������ ���������##accent')
					end
					if imgui.BeginPopupModal(fa.USER_DOCTOR .. u8' ������ ���������##accent', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize  ) then
						if imgui.Checkbox('##checkbox_accent_enable', checkbox_accent_enable) then
							settings.general.accent_enable = checkbox_accent_enable[0]
							save_settings()
						end
						imgui.SameLine()
						imgui.PushItemWidth(375 * MONET_DPI_SCALE)
						imgui.InputText(u8'##accent_input', input_accent, 256) 
						imgui.Separator()
						if imgui.Button(fa.CIRCLE_XMARK .. u8' ������', imgui.ImVec2(200 * MONET_DPI_SCALE, 25 * MONET_DPI_SCALE)) then
							imgui.CloseCurrentPopup()
						end
						imgui.SameLine()
						if imgui.Button(fa.FLOPPY_DISK .. u8' ���������', imgui.ImVec2(200 * MONET_DPI_SCALE, 25 * MONET_DPI_SCALE)) then 
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
						imgui.OpenPopup(fa.USER_DOCTOR .. u8' ��� �����������##fraction_tag')
					end
					if imgui.BeginPopupModal(fa.USER_DOCTOR .. u8' ��� �����������##fraction_tag', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize  ) then
						imgui.PushItemWidth(405 * MONET_DPI_SCALE)
						imgui.InputText(u8'##input_fraction_tag', input_fraction_tag, 256)
						imgui.Separator()
						if imgui.Button(fa.CIRCLE_XMARK .. u8' ������', imgui.ImVec2(200 * MONET_DPI_SCALE, 25 * MONET_DPI_SCALE)) then
							imgui.CloseCurrentPopup()
						end
						imgui.SameLine()
						if imgui.Button(fa.FLOPPY_DISK .. u8' ���������', imgui.ImVec2(200 * MONET_DPI_SCALE, 25 * MONET_DPI_SCALE)) then
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
				if imgui.BeginChild('##2', imgui.ImVec2(589 * MONET_DPI_SCALE, 53 * MONET_DPI_SCALE), true) then
					imgui.CenterText(fa.CIRCLE_INFO .. u8' �������������� ����������')
					imgui.Separator()
					imgui.Columns(3)
					imgui.CenterColumnText(u8"������� ������ ��� /expel:")
					imgui.SetColumnWidth(-1, 230 * MONET_DPI_SCALE)
					imgui.NextColumn()
					imgui.CenterColumnText(u8(settings.general.expel_reason))
					imgui.SetColumnWidth(-1, 250 * MONET_DPI_SCALE)
					imgui.NextColumn()
					if imgui.CenterColumnSmallButton(u8'��������##expel_reason') then
						imgui.OpenPopup(fa.DOOR_OPEN .. u8' �������� ������� ��� ������##expel_reason')
					end
					if imgui.BeginPopupModal(fa.DOOR_OPEN .. u8' �������� ������� ��� ������##expel_reason', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize  ) then
						imgui.PushItemWidth(405 * MONET_DPI_SCALE)
						imgui.InputText(u8'##expel_reason', input_expel_reason, 256) 
						imgui.Separator()
						if imgui.Button(fa.CIRCLE_XMARK .. u8' ������', imgui.ImVec2(200 * MONET_DPI_SCALE, 25 * MONET_DPI_SCALE)) then
							imgui.CloseCurrentPopup()
						end
						imgui.SameLine()
						if imgui.Button(fa.FLOPPY_DISK .. u8' ���������', imgui.ImVec2(200 * MONET_DPI_SCALE, 25 * MONET_DPI_SCALE)) then
							settings.general.expel_reason = u8:decode(ffi.string(input_expel_reason))
							save_settings()
							imgui.CloseCurrentPopup()
						end
						imgui.End()
					end
					imgui.SetColumnWidth(-1, 100 * MONET_DPI_SCALE)
					imgui.Columns(1)
				imgui.EndChild()
				end
				if imgui.BeginChild('##3', imgui.ImVec2(589 * MONET_DPI_SCALE, 100 * MONET_DPI_SCALE), true) then
					imgui.CenterText(fa.SITEMAP .. u8' �������������� ������� �������')
					imgui.Separator()
					imgui.Columns(3)
					imgui.CenterColumnText(u8"�������������� ����")
					imgui.SameLine(nil, 5) imgui.TextDisabled("[?]")
					if imgui.IsItemHovered() then
						imgui.SetTooltip(u8"����������� �� ������ ������� � �����������")
					end
					imgui.SetColumnWidth(-1, 230 * MONET_DPI_SCALE)
					imgui.NextColumn()
					if settings.general.use_info_menu then
						imgui.CenterColumnText(u8'��������')
					else
						imgui.CenterColumnText(u8'���������')
					end
					imgui.SetColumnWidth(-1, 250 * MONET_DPI_SCALE)
					imgui.NextColumn()
					if settings.general.use_info_menu then
						if imgui.CenterColumnSmallButton(u8'���������##info_menu') then
							settings.general.use_info_menu = false
							InformationWindow[0] = false
							save_settings()
						end
						else
						if imgui.CenterColumnSmallButton(u8'��������##info_menu') then
							settings.general.use_info_menu = true
							InformationWindow[0] = true
							save_settings()
						end
					end
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
								sampAddChatMessage('[Justice Helper] {ffffff}��� ������� �������� ������ ������ � ������������!',message_color)
							end
						end
					end
					imgui.Columns(1)
					-- imgui.Separator()
				imgui.EndChild()
				end
				imgui.EndTabItem()
			end
			if imgui.BeginTabItem(fa.RECTANGLE_LIST..u8'    ������� � ���������   ') then 
				if imgui.BeginTabBar('Tabs2') then
					if imgui.BeginTabItem(fa.BARS..u8' ����� ������� ��� ���� ������ ') then 
						if imgui.BeginChild('##1', imgui.ImVec2(589 * MONET_DPI_SCALE, 303 * MONET_DPI_SCALE), true) then
							imgui.Columns(3)
							imgui.CenterColumnText(u8"�������")
							imgui.SetColumnWidth(-1, 170 * MONET_DPI_SCALE)
							imgui.NextColumn()
							imgui.CenterColumnText(u8"��������")
							imgui.SetColumnWidth(-1, 300 * MONET_DPI_SCALE)
							imgui.NextColumn()
							imgui.CenterColumnText(u8"��������")
							imgui.SetColumnWidth(-1, 150 * MONET_DPI_SCALE)
							imgui.Columns(1)
							imgui.Separator()
							imgui.Columns(3)
							imgui.CenterColumnText(u8"/gh")
							imgui.NextColumn()
							imgui.CenterColumnText(u8"������� ������� ���� �������")
							imgui.NextColumn()
							imgui.CenterColumnText(u8"����������")
							imgui.Columns(1)
							imgui.Separator()
							imgui.Columns(3)
							imgui.CenterColumnText(u8"/gfm")
							imgui.NextColumn()
							imgui.CenterColumnText(u8"������� ������� ���� ��������������")
							imgui.NextColumn()
							imgui.CenterColumnText(u8"����������")
							imgui.Columns(1)
							imgui.Separator()
							imgui.Columns(3)
							imgui.CenterColumnText(u8"/stop")
							imgui.NextColumn()
							imgui.CenterColumnText(u8"���������� ��������� �������")
							imgui.NextColumn()
							imgui.CenterColumnText(u8"����������")
							imgui.Columns(1)
							imgui.Separator()
							for index, command in ipairs(settings.commands) do
								if not command.deleted then
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
											save_settings()
											sampUnregisterChatCommand(command.cmd)
										end
										if imgui.IsItemHovered() then
											imgui.SetTooltip(u8"���������� ������� /"..command.cmd)
										end
									else
										if imgui.SmallButton(fa.TOGGLE_OFF .. '##'..command.cmd) then
											command.enable = not command.enable
											save_settings()
											register_command(command.cmd, command.arg, command.text, tonumber(command.waiting))
										end
										if imgui.IsItemHovered() then
											imgui.SetTooltip(u8"��������� ������� /"..command.cmd)
										end
									end
									imgui.SameLine()
									if imgui.SmallButton(fa.PEN_TO_SQUARE .. '##'..command.cmd) then
										change_description = command.description
										input_description = imgui.new.char[256](u8(change_description))
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
										imgui.CenterText(u8'�� ������������� ������ ������� ������� /' .. u8(command.cmd) .. '?')
										imgui.Separator()
										if imgui.Button(fa.CIRCLE_XMARK .. u8' ���, ��������', imgui.ImVec2(200 * MONET_DPI_SCALE, 25 * MONET_DPI_SCALE)) then
											imgui.CloseCurrentPopup()
										end
										imgui.SameLine()
										if imgui.Button(fa.TRASH_CAN .. u8' ��, �������', imgui.ImVec2(200 * MONET_DPI_SCALE, 25 * MONET_DPI_SCALE)) then
											command.enable = false
											command.deleted = true
											sampUnregisterChatCommand(command.cmd)
											save_settings()
											imgui.CloseCurrentPopup()
										end
										imgui.End()
									end
									imgui.Columns(1)
									imgui.Separator()
								end
							end
							imgui.EndChild()
						end
						if imgui.Button(fa.CIRCLE_PLUS .. u8' ������� ����� �������##new_cmd',imgui.ImVec2(imgui.GetMiddleButtonX(1), 0)) then
							local new_cmd = {cmd = '', description = '����� ������� ��������� ����', text = '', arg = '', enable = true, waiting = '1.200', deleted = false}
							table.insert(settings.commands, new_cmd)
							change_description = new_cmd.description
							input_description = imgui.new.char[256](u8(change_description))
							change_arg = new_cmd.arg
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
					if imgui.BeginTabItem(fa.BARS..u8' ������� ��� 9-10 ������') then 
						if tonumber(settings.player_info.fraction_rank_number) == 9 or tonumber(settings.player_info.fraction_rank_number) == 10 then
							if imgui.BeginChild('##1', imgui.ImVec2(589 * MONET_DPI_SCALE, 303 * MONET_DPI_SCALE), true) then
								imgui.Columns(3)
								imgui.CenterColumnText(u8"�������")
								imgui.SetColumnWidth(-1, 170 * MONET_DPI_SCALE)
								imgui.NextColumn()
								imgui.CenterColumnText(u8"��������")
								imgui.SetColumnWidth(-1, 300 * MONET_DPI_SCALE)
								imgui.NextColumn()
								imgui.CenterColumnText(u8"��������")
								imgui.SetColumnWidth(-1, 150 * MONET_DPI_SCALE)
								imgui.Columns(1)
								imgui.Separator()
								imgui.Columns(3)
								imgui.CenterColumnText(u8"/glm")
								imgui.NextColumn()
								imgui.CenterColumnText(u8"������� ������� ���� ����������")
								imgui.NextColumn()
								imgui.CenterColumnText(u8"����������")
								imgui.Columns(1)
								imgui.Separator()
								imgui.Columns(3)
								imgui.CenterColumnText(u8"/spcar")
								imgui.NextColumn()
								imgui.CenterColumnText(u8"���������� �/� �����������")
								imgui.NextColumn()
								imgui.CenterColumnText(u8"����������")
								imgui.Columns(1)
								imgui.Separator()		
								imgui.Columns(3)
								imgui.CenterColumnText(u8"/sob")
								imgui.NextColumn()
								imgui.CenterColumnText(u8"������� ���� �������������")
								imgui.NextColumn()
								imgui.CenterColumnText(u8"����������")
								imgui.Columns(1)
								imgui.Separator()		
								for index, command in ipairs(settings.commands_manage) do
									if not command.deleted then
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
												save_settings()
												sampUnregisterChatCommand(command.cmd)
											end
											if imgui.IsItemHovered() then
												imgui.SetTooltip(u8"���������� ������� /"..command.cmd)
											end
										else
											if imgui.SmallButton(fa.TOGGLE_OFF .. '##'..command.cmd) then
												command.enable = not command.enable
												save_settings()
												register_command(command.cmd, command.arg, command.text, tonumber(command.waiting))
											end
											if imgui.IsItemHovered() then
												imgui.SetTooltip(u8"��������� ������� /"..command.cmd)
											end
										end
										imgui.SameLine()
										if imgui.SmallButton(fa.PEN_TO_SQUARE .. '##'..command.cmd) then
											change_description = command.description
											input_description = imgui.new.char[256](u8(change_description))
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
											imgui.CenterText(u8'�� ������������� ������ ������� ������� /' .. u8(command.cmd) .. '?')
											imgui.Separator()
											if imgui.Button(fa.CIRCLE_XMARK .. u8' ���, ��������', imgui.ImVec2(200 * MONET_DPI_SCALE, 25 * MONET_DPI_SCALE)) then
												imgui.CloseCurrentPopup()
											end
											imgui.SameLine()
											if imgui.Button(fa.TRASH_CAN .. u8' ��, �������', imgui.ImVec2(200 * MONET_DPI_SCALE, 25 * MONET_DPI_SCALE)) then
												command.enable = false
												command.deleted = true
												save_settings()
												sampUnregisterChatCommand(command.cmd)
												imgui.CloseCurrentPopup()
											end
											imgui.End()
										end
										imgui.Columns(1)
										imgui.Separator()
									end
								end
								imgui.EndChild()
							end
							if imgui.Button(fa.CIRCLE_PLUS .. u8' ������� ����� �������##new_cmd_9-10', imgui.ImVec2(imgui.GetMiddleButtonX(1), 0)) then
								binder_create_command_9_10 = true
								local new_cmd = {cmd = '', description = '����� ������� ��������� ����', text = '', arg = '', enable = true, waiting = '1.200', deleted = false }
								table.insert(settings.commands_manage, new_cmd)
								change_description = new_cmd.description
								input_description = imgui.new.char[256](u8(change_description))
								change_arg = new_cmd.arg
								ComboTags[0] = 0
								change_cmd = new_cmd.cmd
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
						if imgui.BeginChild('##99', imgui.ImVec2(589 * MONET_DPI_SCALE, 333 * MONET_DPI_SCALE), true) then
							if isMonetLoader() then
								imgui.CenterText(u8'������ �������� �������� ���� �������������� � �������:')
								if imgui.RadioButtonIntPtr(u8" ������ ��������� ������� /gfm [ID ������]", fastmenu_type, 0) then
									fastmenu_type[0] = 0
									settings.general.mobile_fastmenu_button = false
									save_settings()
									FastMenuButton[0] = false
								end
								if imgui.RadioButtonIntPtr(u8' ��������� ������� /gfm [ID ������] ��� ������ "��������������" � ����� ���� ������', fastmenu_type, 1) then
									fastmenu_type[0] = 1
									settings.general.mobile_fastmenu_button = true
									save_settings()
								end
								imgui.Separator()
								imgui.CenterText(u8'������ ������������ ��������� �������:')
								if imgui.RadioButtonIntPtr(u8" ������ ��������� ������� /stop", stop_type, 0) then
									stop_type[0] = 0
									settings.general.mobile_stop_button = false
									CommandStopWindow[0] = true
									save_settings()
								end
								if imgui.RadioButtonIntPtr(u8' ��������� ������� /stop ��� ������ "����������" ����� ������', stop_type, 1) then
									stop_type[0] = 1
									settings.general.mobile_stop_button = true
									save_settings()
								end
								imgui.Separator()
							else
								imgui.CenterText(fa.KEYBOARD .. u8' Hotkeys')
								if hotkey_no_errors then
									imgui.SameLine()
									if settings.general.use_binds then
										if imgui.SmallButton(fa.TOGGLE_ON .. '##enable_binds') then
											settings.general.use_binds = not settings.general.use_binds
											save_settings()
										end
										if imgui.IsItemHovered() then
											imgui.SetTooltip(u8"��������� ������� ������")
										end
										if imgui.CenterButton(fa.KEYBOARD .. u8' ��������� ������') then
											imgui.OpenPopup(fa.KEYBOARD .. u8' ��������� ������')
										end
									else
										if imgui.SmallButton(fa.TOGGLE_OFF .. '##enable_binds') then
											settings.general.use_binds = not settings.general.use_binds
											save_settings()
										end
										if imgui.IsItemHovered() then
											imgui.SetTooltip(u8"�������� ������� ������")
										end
										imgui.CenterButton(u8'������� ������� (������) ���������!')
									end
									
								else
									imgui.SameLine()
									imgui.SmallButton(fa.TOGGLE_OFF .. '##enable_binds')
									imgui.CenterText(fa.TRIANGLE_EXCLAMATION .. u8' ������: ���������� ����� ����������!')
								end
								imgui.Separator()

								if imgui.BeginPopupModal(fa.KEYBOARD .. u8' ��������� ������', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize  ) then
									imgui.SetWindowSizeVec2(imgui.ImVec2(600 * MONET_DPI_SCALE, 325	* MONET_DPI_SCALE))
									if settings.general.use_binds and hotkey_no_errors then
										imgui.Separator()
										imgui.CenterText(u8'�������� �������� ���� ������� (������ /gh):')
										local width = imgui.GetWindowWidth()
										local calc = imgui.CalcTextSize(getNameKeysFrom(settings.general.bind_mainmenu))
										imgui.SetCursorPosX( width / 2 - calc.x / 2 )
										if MainMenuHotKey:ShowHotKey() then
											settings.general.bind_mainmenu = encodeJson(MainMenuHotKey:GetHotKey())
											save_settings()
										end
										imgui.Separator()
										imgui.CenterText(u8'�������� �������� ���� �������������� � ������� (������ /gfm):')
										imgui.CenterText(u8'��������� �� ������ ����� ��� � ������')
										local width = imgui.GetWindowWidth()
										local calc = imgui.CalcTextSize(getNameKeysFrom(settings.general.bind_fastmenu))
										imgui.SetCursorPosX(width / 2 - calc.x / 2)
										if FastMenuHotKey:ShowHotKey() then
											settings.general.bind_fastmenu = encodeJson(FastMenuHotKey:GetHotKey())
											save_settings()
										end
										imgui.Separator()
										imgui.CenterText(u8'�������� �������� ���� ���������� ������� (������ /glm):')
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
										if imgui.Button(fa.CIRCLE_XMARK .. u8' �������', imgui.ImVec2(imgui.GetMiddleButtonX(1), 25 * MONET_DPI_SCALE)) then
											imgui.CloseCurrentPopup()
										end
										imgui.Separator()
									end
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
			if imgui.BeginTabItem(fa.FILE_PEN..u8'     �������/�����     ') then 
			 	imgui.BeginChild('##1', imgui.ImVec2(589 * MONET_DPI_SCALE, 330 * MONET_DPI_SCALE), true)
				imgui.Columns(2)
				imgui.CenterColumnText(u8"������ ���� ����� �������/���������:")
				imgui.SetColumnWidth(-1, 495 * MONET_DPI_SCALE)
				imgui.NextColumn()
				imgui.CenterColumnText(u8"��������")
				imgui.SetColumnWidth(-1, 150 * MONET_DPI_SCALE)
				imgui.Columns(1)
				imgui.Separator()
				for i, note in ipairs(settings.note) do
					if not note.deleted then
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
							if imgui.BeginChild('##9992', imgui.ImVec2(589 * MONET_DPI_SCALE, 360 * MONET_DPI_SCALE), true) then	
								imgui.PushItemWidth(578 * MONET_DPI_SCALE)
								imgui.InputText(u8'##note_name', input_name_note, 256)
								imgui.InputTextMultiline("##note_text", input_text_note, 16384, imgui.ImVec2(578 * MONET_DPI_SCALE, 320 * MONET_DPI_SCALE))
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
								save_settings()
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
							imgui.CenterText(u8'�� ������������� ������ ������� ������� "' .. u8(note.note_name) .. '" ?')
							imgui.Separator()
							if imgui.Button(fa.CIRCLE_XMARK .. u8' ���, ��������', imgui.ImVec2(200 * MONET_DPI_SCALE, 25 * MONET_DPI_SCALE)) then
								imgui.CloseCurrentPopup()
							end
							imgui.SameLine()
							if imgui.Button(fa.TRASH_CAN .. u8' ��, �������', imgui.ImVec2(200 * MONET_DPI_SCALE, 25 * MONET_DPI_SCALE)) then
								note.deleted = true
								save_settings()
								imgui.CloseCurrentPopup()
							end
							imgui.End()
						end
						imgui.Columns(1)
						imgui.Separator()
					end
				end
				imgui.EndChild()
				if imgui.Button(fa.CIRCLE_PLUS .. u8' ������� ����� �������', imgui.ImVec2(imgui.GetMiddleButtonX(1), 0)) then
					input_name_note = imgui.new.char[256](u8("��������"))
					input_text_note = imgui.new.char[16384](u8("�����"))
					imgui.OpenPopup(fa.PEN_TO_SQUARE .. u8' �������� �������')	
				end
				if imgui.BeginPopupModal(fa.PEN_TO_SQUARE .. u8' �������� �������', _, imgui.WindowFlags.NoCollapse  + imgui.WindowFlags.NoResize ) then
					if imgui.BeginChild('##999999', imgui.ImVec2(589 * MONET_DPI_SCALE, 360 * MONET_DPI_SCALE), true) then	
						imgui.PushItemWidth(578 * MONET_DPI_SCALE)
						imgui.InputText(u8'##note_name', input_name_note, 256)
						imgui.InputTextMultiline("##note_text", input_text_note, 16384, imgui.ImVec2(578 * MONET_DPI_SCALE, 320 * MONET_DPI_SCALE))
						imgui.EndChild()
					end	
					if imgui.Button(fa.CIRCLE_XMARK .. u8' ������', imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
						imgui.CloseCurrentPopup()
					end
					imgui.SameLine()
					if imgui.Button(fa.FLOPPY_DISK .. u8' ������� �������', imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
						local temp = u8:decode(ffi.string(input_text_note))
						local new_note = {note_name = u8:decode(ffi.string(input_name_note)), note_text = temp:gsub('\n', '&'), deleted = false }
						table.insert(settings.note, new_note)
						save_settings()
						imgui.CloseCurrentPopup()
					end
					imgui.End()
				end
				imgui.EndTabItem()
			end
			if imgui.BeginTabItem(fa.GEAR..u8'    ���������    ') then 
				imgui.BeginChild('##1', imgui.ImVec2(590 * MONET_DPI_SCALE, 170 * MONET_DPI_SCALE), true)
				imgui.CenterText(fa.CIRCLE_INFO .. u8' �������������� ���������� ��� ������')
				imgui.Separator()
				imgui.Text(fa.CIRCLE_USER..u8" ����������� ������� �������: Introv3rt x MTG MODS")
				imgui.Separator()
				imgui.Text(fa.CIRCLE_INFO..u8" ������ ������� ������� ������ ����������� � ���: " .. u8(thisScript().version))
				imgui.Separator()
				imgui.Text(fa.CODE..u8" ������ ������ ��� ������� �� ����: ")
				imgui.SameLine()
				if imgui.SmallButton('Hospital Helper (Author MTG Mods)') then
					openLink('https://www.blast.hk/threads/195388')
				end
				imgui.Separator()
				imgui.Text(fa.HEADSET..u8" ���.��������� �� �������:")
				imgui.SameLine()
				if imgui.SmallButton('https://discord.com/invite/qBPEYjfNhv') then
					openLink('https://discord.com/invite/qBPEYjfNhv')
				end
				imgui.Separator()
				imgui.Text(fa.GLOBE..u8" ���� ������� �� ������ BlastHack:")
				imgui.SameLine()
				if imgui.SmallButton('Goverment Help�r') then
					openLink('https://www.blast.hk/threads/221403/')
				end
				imgui.Separator()
				imgui.Text(fa.HAND_HOLDING_DOLLAR .. u8" ���������� ������������ �������:")
				imgui.SameLine()
				if imgui.SmallButton(u8'�������� ���������') then
					imgui.OpenPopup(fa.SACK_DOLLAR .. u8' ��������� ������������')
				end
				if imgui.BeginPopupModal(fa.SACK_DOLLAR .. u8' ��������� ������������', _, imgui.WindowFlags.NoCollapse  + imgui.WindowFlags.NoResize ) then
					imgui.CenterText(u8'��������� ������� �� ����� Discord ������� ���.���������')
					imgui.CenterText(u8'���� �� �� �� ������ ����� ����, �� ��������� � MTG MODS:')
					imgui.SetCursorPosX(130*MONET_DPI_SCALE)
					if imgui.Button(u8('Telegram')) then
						openLink('https://t.me/mtg_mods')
					end
					imgui.SameLine()
					if imgui.Button(u8('Discord')) then
						openLink('https://discordapp.com/users/514135796685602827')
					end
					imgui.SameLine()
					if imgui.Button(u8('VK')) then
						openLink('https://vk.com/mtgmods')
					end
					imgui.Separator()
					if imgui.Button(fa.CIRCLE_XMARK .. u8' �������', imgui.ImVec2(400 * MONET_DPI_SCALE, 25 * MONET_DPI_SCALE)) then
						imgui.CloseCurrentPopup()
					end
					imgui.End()
				end
				imgui.EndChild()
				imgui.BeginChild('##3', imgui.ImVec2(589 * MONET_DPI_SCALE, 87 * MONET_DPI_SCALE), true)
				imgui.CenterText(fa.PALETTE .. u8' �������� ���� �������:')
				imgui.Separator()
				if imgui.RadioButtonIntPtr(u8" Dark Theme ", theme, 0) then	
					theme[0] = 0
					settings.general.moonmonet_theme_enable = false
					save_settings()
					message_color = 0xFF7E7E
					message_color_hex = '{FF7E7E}'
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
				imgui.BeginChild("##2",imgui.ImVec2(589 * MONET_DPI_SCALE, 55 * MONET_DPI_SCALE),true)
				-- imgui.TextWrapped(u8('����� ��� ��� ���� ����������� �� ��������� �������? �������� �� ���� �� ����� Discord ������� ��� �� ������ BlastHack!'))
				-- imgui.TextWrapped(u8('���� �������  �� ������ �������� �������! ��������� ���� �� ����� Discord �������.'))
				imgui.CenterText(u8'����� ��� ��� ���� ����������� �� ��������� �������?')
				imgui.Separator()
				imgui.CenterText(u8'�������� �� ���� �� ����� Discord ������� ��� �� ������ BlastHack!')
				imgui.EndChild()
				imgui.BeginChild("##4",imgui.ImVec2(589 * MONET_DPI_SCALE, 35 * MONET_DPI_SCALE),true)
				if imgui.Button(fa.POWER_OFF .. u8" ���������� ", imgui.ImVec2(imgui.GetMiddleButtonX(4), 25 * MONET_DPI_SCALE)) then
					imgui.OpenPopup(fa.TRIANGLE_EXCLAMATION .. u8' �������������� ##off')
				end
				if imgui.BeginPopupModal(fa.TRIANGLE_EXCLAMATION .. u8' �������������� ##off', _, imgui.WindowFlags.NoResize ) then
					imgui.CenterText(u8'�� ������������� ������ ��������� (���������) ������?')
					imgui.Separator()
					if imgui.Button(fa.CIRCLE_XMARK .. u8' ���, ��������', imgui.ImVec2(200 * MONET_DPI_SCALE, 25 * MONET_DPI_SCALE)) then
						imgui.CloseCurrentPopup()
					end
					imgui.SameLine()
					if imgui.Button(fa.POWER_OFF .. u8' ��, ���������', imgui.ImVec2(200 * MONET_DPI_SCALE, 25 * MONET_DPI_SCALE)) then
						reload_script = true
						sampAddChatMessage('[Government Helper] {ffffff}������ ������������ ���� ������ �� ��������� ����� � ����!', message_color)
						thisScript():unload()
					end
					imgui.End()
				end
				imgui.SameLine()
				if imgui.Button(fa.ROTATE_RIGHT .. u8" ������������ ", imgui.ImVec2(imgui.GetMiddleButtonX(4), 25 * MONET_DPI_SCALE)) then
					reload_script = true
					thisScript():reload()
				end
				imgui.SameLine()
				if imgui.Button(fa.CLOCK_ROTATE_LEFT .. u8" ����� �������� ", imgui.ImVec2(imgui.GetMiddleButtonX(4), 25 * MONET_DPI_SCALE)) then
					imgui.OpenPopup(fa.TRIANGLE_EXCLAMATION .. u8' �������������� ##reset')
				end
				if imgui.BeginPopupModal(fa.TRIANGLE_EXCLAMATION .. u8' �������������� ##reset', _, imgui.WindowFlags.NoResize ) then
					imgui.CenterText(u8'�� ������������� ������ �������� ��� ��������� �������?')
					imgui.Separator()
					if imgui.Button(fa.CIRCLE_XMARK .. u8' ���, ��������', imgui.ImVec2(200 * MONET_DPI_SCALE, 25 * MONET_DPI_SCALE)) then
						imgui.CloseCurrentPopup()
					end
					imgui.SameLine()
					if imgui.Button(fa.CLOCK_ROTATE_LEFT .. u8' ��, ��������', imgui.ImVec2(200 * MONET_DPI_SCALE, 25 * MONET_DPI_SCALE)) then
						settings = default_settings
						save_settings()
						imgui.CloseCurrentPopup()
						reload_script = true
						thisScript():reload()
					end
					imgui.End()
				end
				imgui.SameLine()
				if imgui.Button(fa.TRASH_CAN .. u8" �������� ", imgui.ImVec2(imgui.GetMiddleButtonX(4), 25 * MONET_DPI_SCALE)) then
					imgui.OpenPopup(fa.TRIANGLE_EXCLAMATION .. u8' �������������� ##delete')
				end
				if imgui.BeginPopupModal(fa.TRIANGLE_EXCLAMATION .. u8' �������������� ##delete', _, imgui.WindowFlags.NoResize ) then
					imgui.CenterText(u8'�� ������������� ������ ������� Government Helper?')
					imgui.Separator()
					if imgui.Button(fa.CIRCLE_XMARK .. u8' ���, ��������', imgui.ImVec2(200 * MONET_DPI_SCALE, 25 * MONET_DPI_SCALE)) then
						imgui.CloseCurrentPopup()
					end
					imgui.SameLine()
					if imgui.Button(fa.TRASH_CAN .. u8' ��, � ���� �������', imgui.ImVec2(200 * MONET_DPI_SCALE, 25 * MONET_DPI_SCALE)) then
						sampAddChatMessage('[Government Helper] {ffffff}������ �������� ����� �� ������ ����������!', message_color)
						sampShowDialog(999999, message_color_hex .. "Government Helper", "��� ����� ���� ��� �� ������� Government Helper �� ������ ����������.\n���� �������� ������� � ���������� ������ �������������, � �� ������������ � ������ ��� ����������, ��\n�������� ��� ��� ������ ��������� ��� ������� ������.\n\nDiscord: https://discord.com/invite/qBPEYjfNhv\nBlastHack: https://www.blast.hk/threads/195388/\nTelegram: https://t.me/mtgmods\n\n���� ���, �� ������ ������ ������� � ���������� ������ � ����� ������ :)", "�������", '', 0)
						os.remove(getWorkingDirectory() .. "\\Government Helper.lua")
						os.remove(getWorkingDirectory() .. "\\config\\Government Helper_Settings.json")
						reload_script = true
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
		imgui.Begin(fa.HOSPITAL .. " Government Helper - " .. fa.WALKIE_TALKIE .. u8" ����� ������������", DeportamentWindow, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize)
		imgui.BeginChild('##2', imgui.ImVec2(589 * MONET_DPI_SCALE, 160 * MONET_DPI_SCALE), true)
		imgui.Columns(3)
		imgui.CenterColumnText(u8('��� ���:'))
		imgui.PushItemWidth(215 * MONET_DPI_SCALE)
		if imgui.InputText('##input_dep_tag1', input_dep_tag1, 256) then
			settings.deportament.dep_tag1 = u8:decode(ffi.string(input_dep_tag1))
			save_settings()
		end
		if imgui.CenterColumnButton(u8('������� ���##1')) then
			imgui.OpenPopup(fa.TAG .. u8' ���� �����������##1')
		end
		if imgui.BeginPopupModal(fa.TAG .. u8' ���� �����������##1', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize) then
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
					if imgui.Button(fa.CIRCLE_XMARK .. u8' �������', imgui.ImVec2( imgui.GetMiddleButtonX(1), 25 * MONET_DPI_SCALE)) then
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
					if imgui.Button(fa.CIRCLE_XMARK .. u8' �������', imgui.ImVec2( imgui.GetMiddleButtonX(1), 25 * MONET_DPI_SCALE)) then
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
					if imgui.Button(fa.CIRCLE_PLUS .. u8' �������� ���', imgui.ImVec2( imgui.GetMiddleButtonX(2), 25 * MONET_DPI_SCALE)) then
						imgui.OpenPopup(fa.TAG .. u8' ���������� ������ ����##1')	
					end
					if imgui.BeginPopupModal(fa.TAG .. u8' ���������� ������ ����##1', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize) then
						imgui.PushItemWidth(215 * MONET_DPI_SCALE)
						imgui.InputText('##input_dep_new_tag', input_dep_new_tag, 256) 
						imgui.Separator()
						if imgui.Button(fa.CIRCLE_XMARK .. u8' ������', imgui.ImVec2( imgui.GetMiddleButtonX(2), 25 * MONET_DPI_SCALE)) then
							imgui.CloseCurrentPopup()
						end
						imgui.SameLine()
						if imgui.Button(fa.FLOPPY_DISK .. u8' ���������', imgui.ImVec2( imgui.GetMiddleButtonX(2), 25 * MONET_DPI_SCALE)) then
							table.insert(settings.deportament.dep_tags_custom, u8:decode(ffi.string(input_dep_new_tag)))
							save_settings()
							imgui.CloseCurrentPopup()
						end
						imgui.End()
					end
					imgui.SameLine()
					if imgui.Button(fa.CIRCLE_XMARK .. u8' �������', imgui.ImVec2( imgui.GetMiddleButtonX(2), 25 * MONET_DPI_SCALE)) then
						imgui.CloseCurrentPopup()
					end
				imgui.EndTabItem() end
			imgui.EndTabBar() 
			end
			imgui.End()
		end
		imgui.SetColumnWidth(-1, 230 * MONET_DPI_SCALE)
		imgui.NextColumn()
		imgui.CenterColumnText(u8('������� �����:'))
		imgui.PushItemWidth(140 * MONET_DPI_SCALE)
		if imgui.InputText('##input_dep_fm', input_dep_fm, 256) then
			settings.deportament.dep_fm = u8:decode(ffi.string(input_dep_fm))
			save_settings()
		end
		if imgui.CenterColumnButton(u8('������� �������##1')) then
			imgui.OpenPopup(fa.WALKIE_TALKIE .. u8' ������� ����� /d')
		end
		if imgui.BeginPopupModal(fa.WALKIE_TALKIE .. u8' ������� ����� /d', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize) then
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
			if imgui.Button(fa.CIRCLE_XMARK .. u8' �������', imgui.ImVec2( imgui.GetMiddleButtonX(1), 25 * MONET_DPI_SCALE)) then
				imgui.CloseCurrentPopup()
			end
			imgui.End()
		end
		imgui.SetColumnWidth(-1, 150 * MONET_DPI_SCALE)
		imgui.NextColumn()
		imgui.CenterColumnText(u8('���, � ���� �� �����������:'))
		imgui.PushItemWidth(195 * MONET_DPI_SCALE)
		if imgui.InputText('##input_dep_tag2', input_dep_tag2, 256) then
			settings.deportament.dep_tag2 = u8:decode(ffi.string(input_dep_tag2))
			save_settings()
		end
		if imgui.CenterColumnButton(u8('������� ���##2')) then
			imgui.OpenPopup(fa.TAG .. u8' ���� �����������##2')
		end
		if imgui.BeginPopupModal(fa.TAG .. u8' ���� �����������##2', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize) then
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
					if imgui.Button(fa.CIRCLE_XMARK .. u8' �������', imgui.ImVec2( imgui.GetMiddleButtonX(1), 25 * MONET_DPI_SCALE)) then
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
					if imgui.Button(fa.CIRCLE_XMARK .. u8' �������', imgui.ImVec2( imgui.GetMiddleButtonX(1), 25 * MONET_DPI_SCALE)) then
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
					if imgui.Button(fa.CIRCLE_PLUS .. u8' �������� ���', imgui.ImVec2( imgui.GetMiddleButtonX(2), 25 * MONET_DPI_SCALE)) then
						imgui.OpenPopup(fa.TAG .. u8' ���������� ������ ����##2')	
					end
					if imgui.BeginPopupModal(fa.TAG .. u8' ���������� ������ ����##2', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize) then
						imgui.PushItemWidth(215 * MONET_DPI_SCALE)
						imgui.InputText('##input_dep_new_tag', input_dep_new_tag, 256) 
						imgui.Separator()
						if imgui.Button(fa.CIRCLE_XMARK .. u8' ������', imgui.ImVec2( imgui.GetMiddleButtonX(2), 25 * MONET_DPI_SCALE)) then
							imgui.CloseCurrentPopup()
						end
						imgui.SameLine()
						if imgui.Button(fa.FLOPPY_DISK .. u8' ���������', imgui.ImVec2( imgui.GetMiddleButtonX(2), 25 * MONET_DPI_SCALE)) then
							table.insert(settings.deportament.dep_tags_custom, u8:decode(ffi.string(input_dep_new_tag)))
							save_settings()
							imgui.CloseCurrentPopup()
						end
						imgui.End()
					end
					imgui.SameLine()
					if imgui.Button(fa.CIRCLE_XMARK .. u8' �������', imgui.ImVec2( imgui.GetMiddleButtonX(2), 25 * MONET_DPI_SCALE)) then
						imgui.CloseCurrentPopup()
					end
				imgui.EndTabItem() end
			imgui.EndTabBar() 
			end
			imgui.End()
		end
		imgui.SetColumnWidth(-1, 235 * MONET_DPI_SCALE)
		imgui.Columns(1)
		imgui.Separator()
		imgui.CenterText(u8('�����:'))
		imgui.PushItemWidth(490 * MONET_DPI_SCALE)
		imgui.InputText(u8'##dep_input_text', input_dep_text, 256)
		imgui.SameLine()
		if imgui.Button(u8' ��������� ') then
			sampSendChat('/d ' .. u8:decode(ffi.string(input_dep_tag1)) .. ' ' .. u8:decode(ffi.string(input_dep_fm)) .. ' ' ..  u8:decode(ffi.string(input_dep_tag2)) .. ' '  .. u8:decode(ffi.string(input_dep_text)))
		end
		imgui.Separator()
		imgui.CenterText(u8'������������: /d ' .. u8(u8:decode(ffi.string(input_dep_tag1))) .. ' ' .. u8(u8:decode(ffi.string(input_dep_fm))) .. ' ' ..  u8(u8:decode(ffi.string(input_dep_tag2))) .. ' '  .. u8(u8:decode(ffi.string(input_dep_text))) )
		imgui.EndChild()
		imgui.End()
    end
)

imgui.OnFrame(
    function() return BinderWindow[0] end,
    function(player)
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(600 * MONET_DPI_SCALE, 425	* MONET_DPI_SCALE), imgui.Cond.FirstUseEver)
		imgui.Begin(fa.PEN_TO_SQUARE .. u8' �������������� ������� /' .. change_cmd, BinderWindow, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize  )
		if imgui.BeginChild('##binder_edit', imgui.ImVec2(589 * MONET_DPI_SCALE, 361 * MONET_DPI_SCALE), true) then
			imgui.CenterText(fa.FILE_LINES .. u8' �������� �������:')
			imgui.PushItemWidth(579 * MONET_DPI_SCALE)
			imgui.InputText("##input_description", input_description, 256)
			imgui.Separator()
			imgui.CenterText(fa.TERMINAL .. u8' ������� ��� ������������� � ���� (��� /):')
			imgui.PushItemWidth(579 * MONET_DPI_SCALE)
			imgui.InputText("##input_cmd", input_cmd, 256)
			imgui.Separator()
			imgui.CenterText(fa.CODE .. u8' ��������� ������� ��������� �������:')
	    	imgui.Combo(u8'',ComboTags, ImItems, #item_list)
	 	    imgui.Separator()
	        imgui.CenterText(fa.FILE_WORD .. u8' ��������� ���� �������:')
			imgui.InputTextMultiline("##text_multiple", input_text, 8192, imgui.ImVec2(579 * MONET_DPI_SCALE, 173 * MONET_DPI_SCALE))
		imgui.EndChild() end
		if imgui.Button(fa.CIRCLE_XMARK .. u8' ������', imgui.ImVec2(imgui.GetMiddleButtonX(5), 0)) then
			BinderWindow[0] = false
		end
		imgui.SameLine()
		if imgui.Button(fa.CLOCK .. u8' ��������',imgui.ImVec2(imgui.GetMiddleButtonX(5), 0)) then
			imgui.OpenPopup(fa.CLOCK .. u8' �������� (� ��������) ')
		end
		if imgui.BeginPopupModal(fa.CLOCK .. u8' �������� (� ��������) ', _, imgui.WindowFlags.NoResize ) then
			imgui.PushItemWidth(200 * MONET_DPI_SCALE)
			imgui.SliderFloat(u8'##waiting', waiting_slider, 0.3, 5)
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
		if imgui.Button(fa.TAGS .. u8' ���� (1)', imgui.ImVec2(imgui.GetMiddleButtonX(5), 0)) then
			imgui.OpenPopup(fa.TAGS .. u8' �������� ���� ��� ������������� � �������')
		end
		if imgui.BeginPopupModal(fa.TAGS .. u8' �������� ���� ��� ������������� � �������', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize  + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.AlwaysAutoResize ) then
			imgui.Text(u8(binder_tags_text))
			imgui.Separator()
			if imgui.Button(fa.CIRCLE_XMARK .. u8' �������', imgui.ImVec2(imgui.GetMiddleButtonX(1), 0)) then
				imgui.CloseCurrentPopup()
			end
			imgui.End()
		end
		imgui.SameLine()
		if imgui.Button(fa.TAGS .. u8' ���� (2)', imgui.ImVec2(imgui.GetMiddleButtonX(5), 0)) then
			imgui.OpenPopup(fa.TAGS .. u8' �������������� ���� ��� �������������� � �����')
		end
		if imgui.BeginPopupModal(fa.TAGS .. u8' �������������� ���� ��� �������������� � �����', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize  + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.AlwaysAutoResize) then
			imgui.CenterText(u8'������������ ����� ��������, ����� ������ ���-�� �������!')
			imgui.Separator()
			imgui.Text(u8(binder_tags_text2))
			imgui.Separator()
			if imgui.Button(fa.CIRCLE_XMARK .. u8' �������', imgui.ImVec2(imgui.GetMiddleButtonX(1), 0)) then
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
				local new_description = u8:decode(ffi.string(input_description))
				local new_command = u8:decode(ffi.string(input_cmd))
				local new_text = u8:decode(ffi.string(input_text)):gsub('\n', '&')
				local temp_array = {}
				if binder_create_command_9_10 then
					temp_array = settings.commands_manage
					binder_create_command_9_10 = false
				else
					temp_array = settings.commands
				end
				local checker = false
				for _, command in ipairs(temp_array) do
					if command.cmd == change_cmd and command.description == change_description and command.arg == change_arg and command.text:gsub('&', '\n') == change_text then
						command.cmd = new_command
						command.arg = new_arg
						command.description = new_description
						command.text = new_text
						command.waiting = new_waiting
						command.deleted = false
						command.enable = true
						checker = true
						save_settings()
						if command.arg == '' then
							sampAddChatMessage('[Government Helper] {ffffff}������� ' .. message_color_hex .. '/' .. new_command .. ' {ffffff}������� ���������!', message_color)
						elseif command.arg == '{arg}' then
							sampAddChatMessage('[Government Helper] {ffffff}������� ' .. message_color_hex .. '/' .. new_command .. ' [��������] {ffffff}������� ���������!', message_color)
						elseif command.arg == '{arg_id}' then
							sampAddChatMessage('[Government Helper] {ffffff}������� ' .. message_color_hex .. '/' .. new_command .. ' [ID ������] {ffffff}������� ���������!', message_color)
						elseif command.arg == '{arg_id} {arg2}' then
							sampAddChatMessage('[Government Helper] {ffffff}������� ' .. message_color_hex .. '/' .. new_command .. ' [ID ������] [��������] {ffffff}������� ���������!', message_color)
						elseif command.arg == '{arg_id} {arg2} {arg3}' then
							sampAddChatMessage('[Government Helper] {ffffff}������� ' .. message_color_hex .. '/' .. new_command .. ' [ID ������] [��������] [��������] {ffffff}������� ���������!', message_color)
						end
						sampUnregisterChatCommand(change_cmd)
						register_command(command.cmd, command.arg, command.text, tonumber(command.waiting))
						break
					end
				end
				if not checker then
					sampAddChatMessage('[Government Helper] {ffffff}������ #787 ��� ���������� ������� ' .. message_color_hex .. '/' .. new_command .. ' {ffffff}!', message_color)
				end
				BinderWindow[0] = false
			end
		end
		if imgui.BeginPopupModal(fa.TRIANGLE_EXCLAMATION .. u8' ������ ���������� �������!', _, imgui.WindowFlags.AlwaysAutoResize ) then
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
			if imgui.Button(fa.CIRCLE_XMARK .. u8' �������', imgui.ImVec2(300 * MONET_DPI_SCALE, 25 * MONET_DPI_SCALE)) then
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
		imgui.SetNextWindowSize(imgui.ImVec2(600 * MONET_DPI_SCALE, sizeYY * MONET_DPI_SCALE), imgui.Cond.FirstUseEver)
		--imgui.SetNextWindowSize(imgui.ImVec2(600 * MONET_DPI_SCALE, 413 * MONET_DPI_SCALE), imgui.Cond.FirstUseEver)
		imgui.Begin(fa.BUILDING_SHIELD .. " " ..  u8(members_fraction) .. " - " .. #members .. u8' ����������� ������', MembersWindow, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize )
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
			imgui.SetColumnWidth(-1, 300 * MONET_DPI_SCALE)
			imgui.NextColumn()
			imgui.CenterColumnText(u8(v.rank) .. ' (' .. u8(v.rank_number) .. ')')
			imgui.SetColumnWidth(-1, 230 * MONET_DPI_SCALE)
			imgui.NextColumn()
			imgui.CenterColumnText(u8(v.warns .. '/3'))
			imgui.SetColumnWidth(-1, 75 * MONET_DPI_SCALE)
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
		imgui.Text(show_note_text:gsub('&','\n'))
		imgui.Separator()
		if imgui.Button(fa.CIRCLE_XMARK .. u8' �������', imgui.ImVec2(imgui.GetMiddleButtonX(1), 25 * MONET_DPI_SCALE)) then
			NoteWindow[0] = false
		end
		imgui.End()
    end
)

imgui.OnFrame(
    function() return FastMenu[0] end,
    function(player)
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		--imgui.SetNextWindowSize(imgui.ImVec2(290 * MONET_DPI_SCALE, 415 * MONET_DPI_SCALE), imgui.Cond.FirstUseEver)
		imgui.Begin(fa.USER_INJURED..' '..sampGetPlayerNickname(player_id)..' ['..player_id..']##FastMenu', FastMenu, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize )
		for _, command in ipairs(settings.commands) do
			if command.enable and command.arg == '{arg_id}' and not command.text:find('/godeath') and not command.text:find('/unstuff')  then
				if imgui.Button(u8(command.description), imgui.ImVec2(290 * MONET_DPI_SCALE, 30 * MONET_DPI_SCALE)) then
					sampProcessChatInput("/" .. command.cmd .. " " .. player_id)
					FastMenu[0] = false
				end
			end
		end
		imgui.End()
    end
)

imgui.OnFrame(
    function() return LeaderFastMenu[0] end,
    function(player)
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.Begin(fa.USER_INJURED..' '..sampGetPlayerNickname(player_id)..' ['..player_id..']##LeaderFastMenu', LeaderFastMenu, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.AlwaysAutoResize  )
		for _, command in ipairs(settings.commands_manage) do
			if command.enable and command.arg == '{arg_id}' then
				if imgui.Button(u8(command.description), imgui.ImVec2(290 * MONET_DPI_SCALE, 30 * MONET_DPI_SCALE)) then
					sampProcessChatInput("/" .. command.cmd .. " " .. player_id)
					LeaderFastMenu[0] = false
				end
			end
		end
		if not isMonetLoader() then
			if imgui.Button(u8"������ �������",imgui.ImVec2(290 * MONET_DPI_SCALE, 30 * MONET_DPI_SCALE)) then
				sampSetChatInputEnabled(true)
				sampSetChatInputText('/vig '..player_id..' ')
				LeaderFastMenu[0] = false
			end
			if imgui.Button(u8"������� �� �����������",imgui.ImVec2(290 * MONET_DPI_SCALE, 30 * MONET_DPI_SCALE)) then
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
		imgui.Begin(fa.HOSPITAL.." Government Helper##rank", GiveRankMenu, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize  + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.AlwaysAutoResize)
		imgui.CenterText(u8'�������� ���� ��� '.. sampGetPlayerNickname(player_id) .. ':')
		imgui.PushItemWidth(250 * MONET_DPI_SCALE)
		imgui.SliderInt('', giverank, 1, 9)
		imgui.Separator()
		if imgui.Button(fa.USER_DOCTOR..u8" ������ ����" , imgui.ImVec2(imgui.GetMiddleButtonX(1), 0)) then
			local command_find = false
			for _, command in ipairs(settings.commands_manage) do
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
							sampAddChatMessage('[Government Helper] {ffffff}����� ���������� ��������� ������� ����������� ' .. message_color_hex .. '/stop {ffffff}��� ������� ������ ����� ������', message_color)
							CommandStopWindow[0] = true
						elseif not isMonetLoader() and hotkey_no_errors and settings.general.bind_command_stop and settings.general.use_binds then
							sampAddChatMessage('[Government Helper] {ffffff}����� ���������� ��������� ������� ����������� ' .. message_color_hex .. '/stop {ffffff}��� ������� ' .. message_color_hex .. getNameKeysFrom(settings.general.bind_command_stop), message_color)
						else
							sampAddChatMessage('[Government Helper] {ffffff}����� ���������� ��������� ������� ����������� ' .. message_color_hex .. '/stop', message_color)
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
								sampAddChatMessage('[Government Helper] {ffffff}��������� ������� /' .. command.cmd .. " ������� �����������!", message_color) 
								return 
							end
							if wait_tag then
								for tag, replacement in pairs(tagReplacements) do
									local success, result = pcall(string.gsub, line, "{" .. tag .. "}", replacement())
									if success then
										line = result
									end
								end
								sampSendChat(line)
								if debug_mode then sampAddChatMessage('[Government Helper DEBUG] ��������� ���������: ' .. line, message_color) end
								wait(tonumber(command.waiting)*1000)	
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
				sampAddChatMessage('[Government Helper] {ffffff}���� ��� ��������� ����� ����������� ���� ��������!', message_color)
				sampAddChatMessage('[Government Helper] {ffffff}���������� �������� ��������� �������!', message_color)
			end
			GiveRankMenu[0] = false
		end
		imgui.End()
    end
)

imgui.OnFrame(
    function() return FastMenuButton[0] end,
    function(player)
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 8.5, sizeY / 2.3), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.Begin(fa.HOSPITAL.." Government Helper##fast_menu_button", FastMenuButton, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize  + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoTitleBar  )
		if imgui.Button(fa.IMAGE_PORTRAIT..u8' �������������� ') then
			if tonumber(#get_players()) == 1 then
				show_fast_menu(get_players()[1])
				FastMenuButton[0] = false
			elseif tonumber(#get_players()) > 1 then
				FastMenuPlayers[0] = true
				FastMenuButton[0] = false
			end
		end
		imgui.End()
    end
)

imgui.OnFrame(
    function() return InformationWindow[0] end,
    function(player)
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 8, sizeY / 1.7), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(225 * MONET_DPI_SCALE, 113 * MONET_DPI_SCALE), imgui.Cond.FirstUseEver)
		imgui.Begin(fa.BUILDING_SHIELD .. u8" Government Helper##info_menu", _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize )
		if not isMonetLoader() and not sampIsChatInputActive() then player.HideCursor = true else player.HideCursor = false end
		imgui.Text(fa.CITY .. u8(' �����: ') .. u8(tagReplacements.get_city()))
		imgui.Text(fa.MAP_LOCATION_DOT .. u8(' �����: ') .. u8(tagReplacements.get_area()))
		imgui.Text(fa.LOCATION_CROSSHAIRS .. u8(' �������: ') .. u8(tagReplacements.get_square()))
		imgui.Separator()
		imgui.Text(fa.CLOCK .. u8(' ������� �����: ') .. u8(tagReplacements.get_time()))
		imgui.End()
    end
)

imgui.OnFrame(
    function() return CommandStopWindow[0] end,
    function(player)
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY - 50 * MONET_DPI_SCALE), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.Begin(fa.HOSPITAL.." Government Helper##CommandStopWindow", _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize  + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.AlwaysAutoResize )
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
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY - 50 * MONET_DPI_SCALE), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))

		imgui.Begin(fa.HOSPITAL.." Government Helper##CommandPauseWindow", _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize  + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.AlwaysAutoResize )
		if command_pause then
			if imgui.Button(fa.CIRCLE_ARROW_RIGHT .. u8' ���������� ', imgui.ImVec2(150 * MONET_DPI_SCALE, 25 * MONET_DPI_SCALE)) then
				command_pause = false
				CommandPauseWindow[0] = false
			end
			imgui.SameLine()
			if imgui.Button(fa.CIRCLE_XMARK .. u8' ������ STOP ', imgui.ImVec2(150 * MONET_DPI_SCALE, 25 * MONET_DPI_SCALE)) then
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
    function() return FastMenuPlayers[0] end,
    function(player)
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.Begin(fa.HOSPITAL..u8" �������� ������##fast_menu_players", FastMenuPlayers, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize  )
		if tonumber(#get_players()) == 0 then
			show_fast_menu(get_players()[1])
			FastMenuPlayers[0] = false
		elseif tonumber(#get_players()) >= 1 then
			for _, playerId in ipairs(get_players()) do
				local id = tonumber(playerId)
				if imgui.Button(sampGetPlayerNickname(id), imgui.ImVec2(200 * MONET_DPI_SCALE, 25 * MONET_DPI_SCALE)) then
					if tonumber(#get_players()) ~= 0 then show_fast_menu(id) end
					FastMenuPlayers[0] = false
				end
			end
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
			if imgui.BeginChild('sobes1', imgui.ImVec2(240 * MONET_DPI_SCALE, 182 * MONET_DPI_SCALE), true) then
				imgui.CenterColumnText(fa.BOOKMARK .. u8" ��������")
				imgui.Separator()
				if imgui.Button(fa.PLAY .. u8" ������ �������������", imgui.ImVec2(-1, 25 * MONET_DPI_SCALE)) then
					lua_thread.create(function()
						sampSendChat("������������, � " .. settings.player_info.name_surname .. " - " .. settings.player_info.fraction_rank .. ' ' .. settings.player_info.fraction_tag)
						wait(2000)
						sampSendChat("�� ������ � ��� �� �������������?")
					end)
				end
				if imgui.Button(fa.PASSPORT .. u8" ��������� ���������", imgui.ImVec2(-1, 25 * MONET_DPI_SCALE)) then
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
				if imgui.Button(fa.USER .. u8" ���������� � ����", imgui.ImVec2(-1, 25 * MONET_DPI_SCALE)) then
					sampSendChat("������� ���������� � ����.")
				end
				
				if imgui.Button(fa.CHECK .. u8" ������������� ��������", imgui.ImVec2(-1, 25 * MONET_DPI_SCALE)) then
					sampSendChat("/todo ����������! �� ������� ������ �������������!*��������")
				end
				if imgui.Button(fa.USER_PLUS .. u8" ���������� � �����������", imgui.ImVec2(-1, 25 * MONET_DPI_SCALE)) then
					find_and_use_command('/invite {arg_id}', player_id)
					SobesMenu[0] = false
				end
				imgui.EndChild()
			end
			imgui.SameLine()
			if imgui.BeginChild('sobes2', imgui.ImVec2(240 * MONET_DPI_SCALE, 182 * MONET_DPI_SCALE), true) then
				imgui.CenterColumnText(fa.BOOKMARK..u8" �������������")
				imgui.Separator()
				if imgui.Button(fa.GLOBE .. u8" ������� ����.����� Discord", imgui.ImVec2(-1, 25 * MONET_DPI_SCALE)) then
					sampSendChat("������� �� � ��� ����. ����� Discord?")
				end
				if imgui.Button(fa.CIRCLE_QUESTION .. u8" ������� ����� ������", imgui.ImVec2(-1, 25 * MONET_DPI_SCALE)) then
					sampSendChat("������� �� � ��� ���� ������ � ����� �����?")
				end
				if imgui.Button(fa.CIRCLE_QUESTION .. u8" ������ ������ ��?", imgui.ImVec2(-1, 25 * MONET_DPI_SCALE)) then
					sampSendChat("������� ������ �� ������� ������ ���?")
				end
				if imgui.Button(fa.CIRCLE_QUESTION .. u8" ��� ����� ������������?", imgui.ImVec2(-1, 25 * MONET_DPI_SCALE)) then
					sampSendChat("������� ��� �� ������ ������ \"������������\"?")
				end
				if imgui.Button(fa.CIRCLE_QUESTION .. u8" ��� ����� ��?", imgui.ImVec2(-1, 25 * MONET_DPI_SCALE)) then
					sampSendChat("������� ��� �� �������, ��� ����� \"��\"?")
				end
			imgui.EndChild()
			end
			imgui.SameLine()
			if imgui.BeginChild('sobes3', imgui.ImVec2(150 * MONET_DPI_SCALE, -1), true) then
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
				if imgui.Selectable(u8"���� �����") then
					lua_thread.create(function ()
						SobesMenu[0] = false
						sampSendChat("/todo � ���������, �� ��� �� ���������*� �������������� �� ����")
						wait(2000)
						sampSendChat("� ��� ���� �����. ������� ���� ��� ���� �����, ����� ��������� � ���!")
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
				if imgui.Selectable(u8"����������������") then
					lua_thread.create(function ()
						SobesMenu[0] = false
						sampSendChat("/todo � ���������, �� ��� �� ���������*� �������������� �� ����")
						wait(2000)
						sampSendChat("�� ��������������, ������� ��� ���������� ���������� � ��������!")
					end)
				end
				if imgui.Selectable(u8"������� � ��") then
					lua_thread.create(function ()
						SobesMenu[0] = false
						sampSendChat("/todo � ���������, �� ��� �� ���������*� �������������� �� ����")
						wait(2000)
						sampSendChat("�� �������� � ׸���� ������ ����� �����������!")
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
			sampAddChatMessage('[Government Helper] {ffffff}��������� ������, ID ������ ��������������!', message_color)
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
    imgui.GetStyle().WindowPadding = imgui.ImVec2(5 * MONET_DPI_SCALE, 5 * MONET_DPI_SCALE)
    imgui.GetStyle().FramePadding = imgui.ImVec2(5 * MONET_DPI_SCALE, 5 * MONET_DPI_SCALE)
    imgui.GetStyle().ItemSpacing = imgui.ImVec2(5 * MONET_DPI_SCALE, 5 * MONET_DPI_SCALE)
    imgui.GetStyle().ItemInnerSpacing = imgui.ImVec2(2 * MONET_DPI_SCALE, 2 * MONET_DPI_SCALE)
    imgui.GetStyle().TouchExtraPadding = imgui.ImVec2(0, 0)
    imgui.GetStyle().IndentSpacing = 0
    imgui.GetStyle().ScrollbarSize = 10 * MONET_DPI_SCALE
    imgui.GetStyle().GrabMinSize = 10 * MONET_DPI_SCALE
    imgui.GetStyle().WindowBorderSize = 1 * MONET_DPI_SCALE
    imgui.GetStyle().ChildBorderSize = 1 * MONET_DPI_SCALE
    imgui.GetStyle().PopupBorderSize = 1 * MONET_DPI_SCALE
    imgui.GetStyle().FrameBorderSize = 1 * MONET_DPI_SCALE
    imgui.GetStyle().TabBorderSize = 1 * MONET_DPI_SCALE
	imgui.GetStyle().WindowRounding = 8 * MONET_DPI_SCALE
    imgui.GetStyle().ChildRounding = 8 * MONET_DPI_SCALE
    imgui.GetStyle().FrameRounding = 8 * MONET_DPI_SCALE
    imgui.GetStyle().PopupRounding = 8 * MONET_DPI_SCALE
    imgui.GetStyle().ScrollbarRounding = 8 * MONET_DPI_SCALE
    imgui.GetStyle().GrabRounding = 8 * MONET_DPI_SCALE
    imgui.GetStyle().TabRounding = 8 * MONET_DPI_SCALE
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
	imgui.GetStyle().WindowPadding = imgui.ImVec2(5 * MONET_DPI_SCALE, 5 * MONET_DPI_SCALE)
    imgui.GetStyle().FramePadding = imgui.ImVec2(5 * MONET_DPI_SCALE, 5 * MONET_DPI_SCALE)
    imgui.GetStyle().ItemSpacing = imgui.ImVec2(5 * MONET_DPI_SCALE, 5 * MONET_DPI_SCALE)
    imgui.GetStyle().ItemInnerSpacing = imgui.ImVec2(2 * MONET_DPI_SCALE, 2 * MONET_DPI_SCALE)
    imgui.GetStyle().TouchExtraPadding = imgui.ImVec2(0, 0)
    imgui.GetStyle().IndentSpacing = 0
    imgui.GetStyle().ScrollbarSize = 10 * MONET_DPI_SCALE
    imgui.GetStyle().GrabMinSize = 10 * MONET_DPI_SCALE
    imgui.GetStyle().WindowBorderSize = 1 * MONET_DPI_SCALE
    imgui.GetStyle().ChildBorderSize = 1 * MONET_DPI_SCALE
    imgui.GetStyle().PopupBorderSize = 1 * MONET_DPI_SCALE
    imgui.GetStyle().FrameBorderSize = 1 * MONET_DPI_SCALE
    imgui.GetStyle().TabBorderSize = 1 * MONET_DPI_SCALE
	imgui.GetStyle().WindowRounding = 8 * MONET_DPI_SCALE
    imgui.GetStyle().ChildRounding = 8 * MONET_DPI_SCALE
    imgui.GetStyle().FrameRounding = 8 * MONET_DPI_SCALE
    imgui.GetStyle().PopupRounding = 8 * MONET_DPI_SCALE
    imgui.GetStyle().ScrollbarRounding = 8 * MONET_DPI_SCALE
    imgui.GetStyle().GrabRounding = 8 * MONET_DPI_SCALE
    imgui.GetStyle().TabRounding = 8 * MONET_DPI_SCALE
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
function ARGBtoRGB(color) 
	return bit.band(color, 0xFFFFFF) 
end
function rgb2hex(r, g, b)
    local hex = string.format("#%02X%02X%02X", r, g, b)
    return hex
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

function onScriptTerminate(script, game_quit)
    if script == thisScript() and not game_quit and not reload_script then
		sampAddChatMessage('[Government Helper] {ffffff}��������� ����������� ������, ������ ������������ ���� ������!', message_color)
		if not isMonetLoader() then 
			sampAddChatMessage('[Government Helper] {ffffff}����������� ' .. message_color_hex .. 'CTRL {ffffff}+ ' .. message_color_hex .. 'R {ffffff}����� ������������� ������.', message_color)
		end
		play_error_sound()
    end
end