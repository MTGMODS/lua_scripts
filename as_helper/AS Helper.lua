---@diagnostic disable: undefined-global, need-check-nil, lowercase-global, cast-local-type, unused-local

script_name("AS Helper")
script_description('Cross-platform script helper for AutoSchool')
script_author("MTG MODS")
script_version("4.2 Free")

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
		accent_enable = true,
		anti_trivoga = true,
		auto_clicker = true,
		rp_chat = true,
		rp_gun = true,
		auto_uval = false,
		moonmonet_theme_enable = true,
		moonmonet_theme_color = 15310604,
		mobile_fastmenu_button = true,
		mobile_stop_button = true,
		use_binds = true,
		bind_mainmenu = '[113]',
		bind_fastmenu = '[69]',
		bind_leader_fastmenu = '[71]',
		bind_command_stop = '[123]',
		custom_dpi = 1.0,
		autofind_dpi = false,
	},
	player_info = {
		name_surname = '',
		accent = '[Иностранный акцент]:',
		fraction = 'Неизвестно',
		fraction_tag = 'Неизвестно',
		fraction_rank = 'Неизвестно',
		fraction_rank_number = 0,
		sex = 'Неизвестно',
	},
	deportament = {
		dep_fm = '-',
		dep_tag1 = '',
		dep_tag2 = '[Всем]',
		dep_tags = {
			"[Всем]",
			"[Похитители]",
			"[Терористы]",
			"[Диспетчер]",
			'skip',
			"[МЮ]",
			"[Мин.Юст.]",
			"[ЛСПД]",
			"[СФПД]",
			"[ЛВПД]",
			"[РКШД]",
			"[СВАТ]",
			"[ФБР]",
			'skip',
			"[МО]",
			"[Мин.Обороны]",
			"[ЛСа]",
			"[СФа]",
			"[ТСР]",
			'skip',
			"[МЗ]",
			"[Мин.Здрав.]",
			"[ЛСМЦ]",
			"[СФМЦ]",
			"[ЛВМЦ]",
			"[ДМЦ]",
			"[ФД]",
			'skip',
			"[ЦА]",
			"[ЦЛ]",
			"[СК]",
			"[Пра-во]",
			"[Губернатор]",
			"[Прокурор]",
			'skip',
			"[СМИ]",
			"[СМИ ЛС]",
			"[СМИ СФ]",
			"[СМИ ЛВ]",
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
			'- з.к. -',
			'- 101.1 FM - ',
		},
	},
	price = {
		avto1 = 200000,  
		avto2 = 360000,  
		avto3 = 410000,  
		moto1 = 300000,  
		moto2 = 350000,  
		moto3 = 450000,  
		fish1 = 500000,  
		fish2 = 550000,  
		fish3 = 590000,  
		swim1 = 500000,  
		swim2 = 550000,  
		swim3 = 590000,  
		gun1 = 1000000,  
		gun2 = 1090000,  
		gun3 = 1150000,  
		hunt1 = 1000000,  
		hunt2 = 1100000,  
		hunt3 = 1190000,  
		klad1 = 1100000,  
		klad2 = 1200000,  
		klad3 = 1250000,  
		taxi1 = 800000,  
		taxi2 = 1150000,  
		taxi3 = 1250000,  
		mexa1 = 800000,  
		mexa2 = 1150000,  
		mexa3 = 1250000,  
		fly1 = 1200000,  
		fly2 = 1200000,  
		fly3 = 1200000,  
	},
	note = {
		{ note_name = 'Зарплата в организации', note_text = 'Почему ваша зп может быть меньше, чем указано:&- Если у вас есть выговор то у вас будет -20 процентов зп&- Из-за фикса экономики (от разрабов) у вас будет -10 процентов зп&&Как повысить свою зарплату:&- Вступите в фулл семью с флагом чтобы иметь +7 процентов зп &( на 20 сервере это наша семья Martelli )&- Получите \"Военный билет\" чтобы иметь +15 процентов зп&- Купите охранника на \"зп фракции\" чтобы иметь до +25 процентов зп&- Повышайтесь на ранг повыше', deleted = false  },
	},
	commands = {
		{ cmd = 'zd' , description = 'Привествие игрока' , text = 'Здраствуйте, я {my_ru_nick} - {fraction_rank} {fraction_tag}&Чем я могу Вам помочь? Если нужна лицензия - скажите тип и срок', arg = '{arg_id}' , enable = true , waiting = '1.500', bind = "{}" },
		{ cmd = 'go', description = 'Позвать игрока за собой', text = 'Хорошо {get_ru_nick({arg_id})}, следуйте за мной.', arg = '{arg_id}', enable = true, waiting = '1.500', bind = "{}"},
		{ cmd = 'time' , description = 'Посмотреть время' ,  text = '/me взглянул{sex} на свои часы с гравировкой MTG MODS и посмотрел{sex} время&/time&/do На часах видно время {get_time}.' , arg = '' , enable = true, waiting = '1.500' , bind = "{}" },
		{ cmd = 'gl' , description = 'Выдача лицензии игроку' , text = '/me взял{sex} со стола бланк на получение лицензии и заполнил{sex} его&/do Спустя некоторое время бланк на получение лицензии был заполнен.&/me распечатав лицензию передал{sex} её человеку напротив&/givelicense {arg_id}&Вот ваша лицензия, всего Вам хорошего!&/n {get_nick({arg_id})}, введите команду /offer чтобы получить лицензию!', arg = '{arg_id}' , enable = true, waiting = '1.500', bind = "{}"   },
		{ cmd = 'prices' , description = 'Ознакомить игрока с ценами' , text = '/todo Сейчас я скажу вам цены на лицензии*доставая изпод стойки бланк с ценами&/do Бланк с ценами всех лицензий в руках.&/me подвинул{sex} бланк поближе к себе и начал{sex} читать цены&На автомобиль: 1 месяц - ${price_avto1}, 2 месяца - ${price_avto2}, 3 месяца - ${price_avto3}&На мото: 1 месяц - ${price_moto1}, 2 месяца - ${price_moto2}, 3 месяца - ${price_moto3}&На водный: 1 месяц - ${price_swim1}, 2 месяца - ${price_swim2}, 3 месяца - ${price_swim3}&На полёты: 1 месяц - ${price_fly1}&На оружие: 1 месяц - ${price_gun1}, 2 месяца - ${price_gun2}, 3 месяца - ${price_gun3}&На охоту: 1 месяц - ${price_hunt1}, 2 месяца - ${price_hunt2}, 3 месяца - ${price_hunt3}&На рыбалку: 1 месяц - ${price_fish1}, 2 месяца - ${price_fish2}, 3 месяца - ${price_fish3}&На клады: 1 месяц - ${price_klad1}, 2 месяца - ${price_klad2}, 3 месяца - ${price_klad3}&На такси: 1 месяц - ${price_taxi1}, 2 месяца - ${price_taxi2}, 3 месяца - ${price_taxi3}&На механика: 1 месяц - ${price_mexa1}, 2 месяца - ${price_mexa2}, 3 месяца - ${price_mexa3}&/todo Вот такие у нас цены*убирая бланк с ценами' , arg = '' , enable = true , waiting = '1.500' , bind = "{}"},
		{ cmd = 'medka' , description = 'Запросить медкарту для проверки' , text = 'Чтобы получить эту лицензию, покажите мне вашу мед.карту&/n {get_nick({arg_id})}, введите команду /showmc {my_id} чтобы показать мне медкарту&{pause}&/me берет от человека напротив медкарту и осматривает её&/todo Хорошо, забирайте*отдавая медкарту обратно владельцу' , arg = '{arg_id}' , enable = true , waiting = '1.500' , bind = "{}"},
		{ cmd = 'exp' , description = 'Выгнать игрока из ЦЛ' ,  text = 'Вы больше не можете здесь находиться, я выгоняю вас из ЦЛ!&/me схватив человека ведёт к выходу из ЦЛ и закрывает за ним дверь&/expel {arg_id} Н.П.Ц.Л.' , arg = '{arg_id}' , enable = true , waiting = '1.500' , bind = "{}" },
	},
	commands_manage = {
		{ cmd = 'inv' , description = 'Принятие игрока в фракцию' , text = '/do В кармане жилетки есть связка с ключами от раздевалки.&/me достаёт из жилетки один ключ из связки ключей от раздевалки&/todo Возьмите, это ключ от нашей раздевалки*передавая ключ человеку напротив&/invite {arg_id}&/n {get_ru_nick({arg_id})} , примите предложение в /offer чтобы получить инвайт!' , arg = '{arg_id}', enable = true, waiting = '1.500' , bind = "{}"  },
		{ cmd = 'rp' , description = 'Выдача сотруднику /fractionrp' , text = '/fractionrp {arg_id}' , arg = '{arg_id}', enable = true, waiting = '1.500', bind = "{}"  },
		{ cmd = 'pl' , description = 'Назначить взвод сотруднику' , text = '{give_platoon}' , arg = '{arg_id}', enable = true, waiting = '1.500' , bind = "{}" },	
		{ cmd = 'gr' , description = 'Повышение/понижение cотрудника' , text = '{show_rank_menu}&/me достаёт из кармана свой телефон и заходит в базу данных {fraction_tag}&/me изменяет информацию о сотруднике {get_ru_nick({arg_id})} в базе данных {fraction_tag}&/me выходит с базы данных и убирает телефон обратно в карман&/giverank {arg_id} {get_rank}&/r Сотрудник {get_ru_nick({arg_id})} получил новую должность!' , arg = '{arg_id}', enable = true, waiting = '1.500' , bind = "{}" },
		{ cmd = 'vize' , description = 'Управление Vice City визой сотрудника' , text = '/me достаёт из кармана свой телефон и заходит в базу данных {fraction_tag}&/me изменяет информацию о сотруднике {get_ru_nick({arg_id})} в базе данных {fraction_tag}&/me выходит с базы данных и убирает телефон обратно в карман&{lmenu_vc_vize}' , arg = '{arg_id}', enable = true, waiting = '1.500'  , bind = "{}" },
		{ cmd = 'cjob' , description = 'Посмотреть успешность сотрудника' , text = '/checkjobprogress {arg_id}' , arg = '{arg_id}', enable = true, waiting = '1.500' , bind = "{}"  },	
		{ cmd = 'fmutes' , description = 'Выдать мут сотруднику (10 min)' , text = '/fmutes {arg_id} Н.П.Ц.Л.&/r Сотрудник {get_ru_nick({arg_id})} лишился права использовать рацию на 10 минут!' , arg = '{arg_id}', enable = true, waiting = '1.500' , bind = "{}"  },
		{ cmd = 'funmute' , description = 'Снять мут сотруднику' , text = '/funmute {arg_id}&/r Сотрудник {get_ru_nick({arg_id})} теперь может пользоваться рацией!' , arg = '{arg_id}', enable = true, waiting = '1.500' , bind = "{}"  },
		{ cmd = 'vig' , description = 'Выдача выговора cотруднику' , text = '/me достаёт из кармана свой телефон и заходит в базу данных {fraction_tag}&/me изменяет информацию о сотруднике {get_ru_nick({arg_id})} в базе данных {fraction_tag}&/me выходит с базы данных и убирает телефон обратно в карман&/fwarn {arg_id} {arg2}&/r Сотруднику {get_ru_nick({arg_id})} выдан выговор! Причина: {arg2}' , arg = '{arg_id} {arg2}', enable = true, waiting = '1.500'  , bind = "{}" },
		{ cmd = 'unvig' , description = 'Снятие выговора cотруднику' , text = '/me достаёт из кармана свой телефон и заходит в базу данных {fraction_tag}&/me изменяет информацию о сотруднике {get_ru_nick({arg_id})} в базе данных {fraction_tag}&/me выходит с базы данных и убирает телефон обратно в карман&/unfwarn {arg_id}&/r Сотруднику {get_ru_nick({arg_id})} был снят выговор!' , arg = '{arg_id}', enable = true, waiting = '1.500' , bind = "{}"  },
		{ cmd = 'unv' , description = 'Увольнение игрока из фракции' , text = '/me достаёт из кармана свой телефон и заходит в базу данных {fraction_tag}&/me изменяет информацию о сотруднике {get_ru_nick({arg_id})} в базе данных {fraction_tag}&/me выходит с базы данных и убирает свой телефон обратно в карман&/uninvite {arg_id} {arg2}&/r Сотрудник {get_ru_nick({arg_id})} был уволен по причине: {arg2}' , arg = '{arg_id} {arg2}', enable = true, waiting = '1.500' , bind = "{}"  },
		{ cmd = 'govka' , description = 'Собеседование по госс.волне' , text = '/d [{fraction_tag}] - [Всем]: Занимаю государственную волну, просьба не перебивать!&/gov [{fraction_tag}]: Доброго времени суток, уважаемые жители нашего штата!&/gov [{fraction_tag}]: Сейчас проходит собеседование в организацию {fraction}}&/gov [{fraction_tag}]: Для вступления вам нужно иметь документы, жилье, и приехать к нам в холл.&/d [{fraction_tag}] - [Всем]: Освобождаю  государственную волну, спасибо что не перебивали.' , arg = '', enable = true, waiting = '1.300', bind = "{}"  },
		{ cmd = 'point' , description = 'Установить метку для сотрудников' , text = '/r Срочно выдвигайтесь ко мне, отправляю вам координаты...&/point' , arg = '', enable = true, waiting = '1.500', bind = "{}"  },
	}
}
local configDirectory = getWorkingDirectory():gsub('\\','/') .. "/AS Helper"
local path = configDirectory .. "/Settings.json"
function load_settings()
    if not doesDirectoryExist(configDirectory) then
        createDirectory(configDirectory)
    end
    if not doesFileExist(path) then
        settings = default_settings
		print('[AS Helper] Файл с настройками не найден, использую стандартные настройки!')
    else
        local file = io.open(path, 'r')
        if file then
            local contents = file:read('*a')
            file:close()
			if #contents == 0 then
				settings = default_settings
				print('[AS Helper] Не удалось открыть файл с настройками, использую стандартные настройки!')
			else
				local result, loaded = pcall(decodeJson, contents)
				if result then
					settings = loaded
					if settings.general.version ~= thisScript().version then
						print('[AS Helper] Новая версия, сброс настроек!')
						settings = default_settings
						save_settings()
						reload_script = true
						thisScript():reload()
					else
						print('[AS Helper] Настройки успешно загружены!')
					end
				else
					print('[AS Helper] Не удалось открыть файл с настройками, использую стандартные настройки!')
				end
			end
        else
            settings = default_settings
			print('[AS Helper] Не удалось открыть файл с настройками, использую стандартные настройки!')
        end
    end
end
function save_settings()
    local file, errstr = io.open(path, 'w')
    if file then
        local result, encoded = pcall(encodeJson, settings)
        file:write(result and encoded or "")
        file:close()
		print('[AS Helper] Настройки сохранены!')
        return result
    else
        print('[AS Helper] Не удалось сохранить настройки хелпера, ошибка: ', errstr)
        return false
    end
end
load_settings()
------------------------------------------- MonetLoader --------------------------------------------------
function isMonetLoader() return MONET_VERSION ~= nil end
if isMonetLoader() then
	gta = ffi.load('GTASA') 
	ffi.cdef[[ void _Z12AND_OpenLinkPKc(const char* link); ]] -- функция для открытия ссылок
end
if not settings.general.autofind_dpi then
	print('[AS Helper] Применение авто-размера менюшек...')
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
	print('[AS Helper] Установлено значение: ' .. settings.general.custom_dpi)
	save_settings()
end
---------------------------------------------- Mimgui -----------------------------------------------------
local imgui = require('mimgui')
local fa = require('fAwesome6_solid')
local sizeX, sizeY = getScreenResolution()

local MainWindow = imgui.new.bool()
local checkbox_accent_enable = imgui.new.bool(settings.general.accent_enable)
local input_accent = imgui.new.char[256](u8(settings.player_info.accent))
local input_name_surname = imgui.new.char[256](u8(settings.player_info.name_surname))
local input_fraction_tag = imgui.new.char[256](u8(settings.player_info.fraction_tag))
local input_avto1 = imgui.new.char[256](u8(settings.price.avto1) or 0)
local input_avto2 = imgui.new.char[256](u8(settings.price.avto2) or 0)
local input_avto3 = imgui.new.char[256](u8(settings.price.avto3) or 0)
local input_moto1 = imgui.new.char[256](u8(settings.price.moto1) or 0)
local input_moto2 = imgui.new.char[256](u8(settings.price.moto2) or 0)
local input_moto3 = imgui.new.char[256](u8(settings.price.moto3) or 0)
local input_fish1 = imgui.new.char[256](u8(settings.price.fish1) or 0)
local input_fish2 = imgui.new.char[256](u8(settings.price.fish2) or 0)
local input_fish3 = imgui.new.char[256](u8(settings.price.fish3) or 0)
local input_swim1 = imgui.new.char[256](u8(settings.price.swim1) or 0)
local input_swim2 = imgui.new.char[256](u8(settings.price.swim2) or 0)
local input_swim3 = imgui.new.char[256](u8(settings.price.swim3) or 0)
local input_gun1 = imgui.new.char[256](u8(settings.price.gun1) or 0)
local input_gun2 = imgui.new.char[256](u8(settings.price.gun2) or 0)
local input_gun3 = imgui.new.char[256](u8(settings.price.gun3) or 0)
local input_hunt1 = imgui.new.char[256](u8(settings.price.hunt1) or 0)
local input_hunt2 = imgui.new.char[256](u8(settings.price.hunt2) or 0)
local input_hunt3 = imgui.new.char[256](u8(settings.price.hunt3) or 0)
local input_klad1 = imgui.new.char[256](u8(settings.price.klad1) or 0)
local input_klad2 = imgui.new.char[256](u8(settings.price.klad2) or 0)
local input_klad3 = imgui.new.char[256](u8(settings.price.klad3) or 0)
local input_taxi1 = imgui.new.char[256](u8(settings.price.taxi1) or 0)
local input_taxi2 = imgui.new.char[256](u8(settings.price.taxi2) or 0)
local input_taxi3 = imgui.new.char[256](u8(settings.price.taxi3) or 0)
local input_mexa1 = imgui.new.char[256](u8(settings.price.mexa1) or 0)
local input_mexa2 = imgui.new.char[256](u8(settings.price.mexa2) or 0)
local input_mexa3 = imgui.new.char[256](u8(settings.price.mexa3) or 0)
local input_fly1 = imgui.new.char[256](u8(settings.price.fly1) or 0)
local input_fly2 = imgui.new.char[256](u8(settings.price.fly2) or 0)
local input_fly3 = imgui.new.char[256](u8(settings.price.fly3) or 0)
local theme = imgui.new.int(0)
local fastmenu_type = imgui.new.int(settings.general.mobile_fastmenu_button and 1 or 0)
local stop_type = imgui.new.int(settings.general.mobile_stop_button and 1 or 0)
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
local item_list = {u8'Без аргумента', u8'{arg} - принимает любой аргумент', u8'{arg_id} - принимает только аргумент ID игрока', u8'{arg_id} {arg2} - принимает 2 аругмента: ID игрока и любой аргумент', u8'{arg_id} {arg2} {arg3} - принимает 3 аргумента: ID игрока, одну цифру, и любой аргумент'}
local ImItems = imgui.new['const char*'][#item_list](item_list)
local change_waiting = nil
local change_cmd_bool = false
local change_cmd = nil
local change_description = nil
local change_bind = nil
local change_text = nil
local change_arg = nil
local binder_create_command_9_10 = false
local tagReplacements = {
	my_id = function() return select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)) end,
    my_nick = function() return sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))) end,
	my_ru_nick = function() return TranslateNick(settings.player_info.name_surname) end,
	fraction_rank_number = function() return settings.player_info.fraction_rank_number end,
	fraction_rank = function() return settings.player_info.fraction_rank end,
	fraction_tag = function() return settings.player_info.fraction_tag end,
	fraction = function() return settings.player_info.fraction end,
	price_avto1 = function() return settings.price.avto1 end,
	price_avto2 = function() return settings.price.avto2 end,
	price_avto3 = function() return settings.price.avto3 end,
	price_moto1 = function() return settings.price.moto1 end,
	price_moto2 = function() return settings.price.moto2 end,
	price_moto3 = function() return settings.price.moto3 end,
	price_fish1 = function() return settings.price.fish1 end,
	price_fish2 = function() return settings.price.fish2 end,
	price_fish3 = function() return settings.price.fish3 end,
	price_swim1 = function() return settings.price.swim1 end,
	price_swim2 = function() return settings.price.swim2 end,
	price_swim3 = function() return settings.price.swim3 end,
	price_gun1 = function() return settings.price.gun1 end,
	price_gun2 = function() return settings.price.gun2 end,
	price_gun3 = function() return settings.price.gun3 end,
	price_hunt1 = function() return settings.price.hunt1 end,
	price_hunt2 = function() return settings.price.hunt2 end,
	price_hunt3 = function() return settings.price.hunt3 end,
	price_klad1 = function() return settings.price.klad1 end,
	price_klad2 = function() return settings.price.klad2 end,
	price_klad3 = function() return settings.price.klad3 end,
	price_taxi1 = function() return settings.price.taxi1 end,
	price_taxi2 = function() return settings.price.taxi2 end,
	price_taxi3 = function() return settings.price.taxi3 end,
	price_mexa1 = function() return settings.price.mexa1 end,
	price_mexa2 = function() return settings.price.mexa2 end,
	price_mexa3 = function() return settings.price.mexa3 end,
	price_fly1 = function() return settings.price.fly1 end,
	price_fly2 = function() return settings.price.fly2 end,
	price_fly3 = function() return settings.price.fly3 end,
	sex = function() 
		if settings.player_info.sex == 'Женщина' then
			return 'а'
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
}
local binder_tags_text = [[
{my_id} - Ваш ID
{my_nick} - Ваш Никнейм 
{my_ru_nick} - Ваше Имя и Фамилия
{fraction} - Ваша фракция
{fraction_rank} - Ваша фракционная должность
{fraction_tag} - Тэг вашей фракции

{sex} - Добавляет букву "а" если в хелпере указан женский пол
{pause} - Поставить команду на паузу и ожидать нажатия
{get_time} - Получить текущее время
{get_nick({arg_id})} - получить Никнейм из аргумента ID игрока
{get_rp_nick({arg_id})} - получить Никнейм без символа _ из аргумента ID игрока
{get_ru_nick({arg_id})} - получить Никнейм на кирилице из аргумента ID игрока 
{lmenu_vc_vize} - Авто-выдача визы Vice City (для 9/10)
{show_rank_menu} - Открыть меню выдачи рангов (для 9/10)
{get_rank} - Получить выбранный ранг (для 9/10)
]]
-------------------------------------------- MoonMonet ----------------------------------------------------

local monet_no_errors, moon_monet = pcall(require, 'MoonMonet') -- безопасно подключаем библиотеку

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
		function loadHotkeys()
			for _, command in ipairs(settings.commands) do
				updateHotkeyForCommand(command)
			end
			for _, command in ipairs(settings.commands_manage) do
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
				print('[AS Helper] Создан хоткей для команды /' .. command.cmd .. ' на клавишу ' .. getNameKeysFrom(command.bind))
				--sampAddChatMessage('[AS Helper] {ffffff}Создан хоткей для команды ' .. message_color_hex .. '/' .. command.cmd .. ' {ffffff}на клавишу '  .. message_color_hex .. getNameKeysFrom(command.bind), message_color)
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

local vc_vize_bool = false
local vc_vize_player_id = nil

local message1
local message2
local message3

local isActiveCommand = false

local debug_mode = false

local command_stop = false
local command_pause = false

local license_type = ''
local license_time = 1

local givelic_bool = false

local auto_uval_checker = false
------------------------------------------- Main -----------------------------------------------------
function welcome_message()
	if not sampIsLocalPlayerSpawned() then 
		sampAddChatMessage('[AS Helper] {ffffff}Инициализация хелпера прошла успешно!',message_color)
		sampAddChatMessage('[AS Helper] {ffffff}Для полной загрузки хелпера сначало заспавнитесь (войдите на сервер)',message_color)
		repeat wait(0) until sampIsLocalPlayerSpawned()
	end
	sampAddChatMessage('[AS Helper] {ffffff}Загрузка хелпера прошла успешно!', message_color)
	show_arz_notify('info', 'AS Helper', "Загрузка хелпера прошла успешно!", 3000)
	if isMonetLoader() or settings.general.bind_mainmenu == nil or not settings.general.use_binds then	
		sampAddChatMessage('[AS Helper] {ffffff}Чтоб открыть меню хелпера введите команду ' .. message_color_hex .. '/sh', message_color)
	elseif hotkey_no_errors and settings.general.bind_mainmenu and settings.general.use_binds then
		sampAddChatMessage('[AS Helper] {ffffff}Чтоб открыть меню хелпера нажмите ' .. message_color_hex .. getNameKeysFrom(settings.general.bind_mainmenu) .. ' {ffffff}или введите команду ' .. message_color_hex .. '/sh', message_color)
	else
		sampAddChatMessage('[AS Helper] {ffffff}Чтоб открыть меню хелпера введите команду ' .. message_color_hex .. '/sh', message_color)
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
					sampAddChatMessage('[AS Helper] {ffffff}Используйте ' .. message_color_hex .. '/' .. chat_cmd .. ' [аргумент]', message_color)
					
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
					sampAddChatMessage('[AS Helper] {ffffff}Используйте ' .. message_color_hex .. '/' .. chat_cmd .. ' [ID игрока]', message_color)
					
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
						sampAddChatMessage('[AS Helper] {ffffff}Используйте ' .. message_color_hex .. '/' .. chat_cmd .. ' [ID игрока] [аргумент]', message_color)
						
					end
				else
					sampAddChatMessage('[AS Helper] {ffffff}Используйте ' .. message_color_hex .. '/' .. chat_cmd .. ' [ID игрока] [аргумент]', message_color)
					
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
						sampAddChatMessage('[AS Helper] {ffffff}Используйте ' .. message_color_hex .. '/' .. chat_cmd .. ' [ID игрока] [аргумент] [аргумент]', message_color)
						
					end
				else
					sampAddChatMessage('[AS Helper] {ffffff}Используйте ' .. message_color_hex .. '/' .. chat_cmd .. ' [ID игрока] [аргумент] [аргумент]', message_color)
					
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
							sampAddChatMessage('[AS Helper] {ffffff}Чтобы остановить отыгровку команды используйте ' .. message_color_hex .. '/stop {ffffff}или нажмите кнопку внизу экрана', message_color)
							CommandStopWindow[0] = true
						elseif not isMonetLoader() and hotkey_no_errors and settings.general.bind_command_stop and settings.general.use_binds then
							sampAddChatMessage('[AS Helper] {ffffff}Чтобы остановить отыгровку команды используйте ' .. message_color_hex .. '/stop {ffffff}или нажмите ' .. message_color_hex .. getNameKeysFrom(settings.general.bind_command_stop), message_color)
						else
							sampAddChatMessage('[AS Helper] {ffffff}Чтобы остановить отыгровку команды используйте ' .. message_color_hex .. '/stop', message_color)
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
							sampAddChatMessage('[AS Helper] {ffffff}Отыгровка команды /' .. chat_cmd .. " успешно остановлена!", message_color) 
							return 
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
								sampAddChatMessage('[AS Helper] {ffffff}Команда /' .. chat_cmd .. ' поставлена на паузу!', message_color)
								command_pause = true
								CommandPauseWindow[0] = true
								while command_pause do
									wait(0)
								end
								if not command_stop then
									sampAddChatMessage('[AS Helper] {ffffff}Продолжаю отыгровку команды /' .. chat_cmd, message_color)	
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
									sampAddChatMessage('[AS Helper] {ffffff}Отыгровка команды /' .. chat_cmd .. " успешно остановлена!", message_color) 	
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
			sampAddChatMessage('[AS Helper] {ffffff}Дождитесь завершения отыгровки предыдущей команды!', message_color)
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
		sampAddChatMessage('[AS Helper] {ffffff}Ошибка, не могу найти бинд для выполнения этой команды!', message_color)
		return
	end
end
function initialize_commands()
	sampRegisterChatCommand("sh", function() MainWindow[0] = not MainWindow[0] end)
	sampRegisterChatCommand("sm", show_fast_menu)
	sampRegisterChatCommand("stop", function() 
		if isActiveCommand then 
			command_stop = true 
		else 
			sampAddChatMessage('[AS Helper] {ffffff}В данный момент нету никакой активной команды/отыгровки!', message_color) 
		end
	end)
	sampRegisterChatCommand("sob", function(arg)
		if not isActiveCommand then
			if isParamSampID(arg) then
				player_id = tonumber(arg)
				SobesMenu[0] = not SobesMenu[0]
			else
				sampAddChatMessage('[AS Helper] {ffffff}Используйте ' .. message_color_hex .. '/sob [ID игрока]', message_color)
			end
			
		else
			sampAddChatMessage('[AS Helper] {ffffff}Дождитесь завершения отыгровки предыдущей команды!', message_color)
		end
	end)
	sampRegisterChatCommand("mb", function() 
		if not isActiveCommand then
			members_new = {} 
			members_check = true 
			sampSendChat("/members")
		else
			sampAddChatMessage('[AS Helper] {ffffff}Дождитесь завершения отыгровки предыдущей команды!', message_color)
		end
	end)
	sampRegisterChatCommand("dep", function() DeportamentWindow[0] = not DeportamentWindow[0]  end)
	-- Ригистрация всeх команд которые есть в json
	registerCommandsFrom(settings.commands)
	if tonumber(settings.player_info.fraction_rank_number) >= 9 then 
		sampRegisterChatCommand("slm", show_leader_fast_menu)
		sampRegisterChatCommand("spcar", function()
			if not isActiveCommand then
				lua_thread.create(function()
					isActiveCommand = true
					if isMonetLoader() and settings.general.mobile_stop_button then
						sampAddChatMessage('[AS Helper] {ffffff}Чтобы остановить отыгровку команды используйте ' .. message_color_hex .. '/stop {ffffff}или нажмите кнопку внизу экрана', message_color)
						CommandStopWindow[0] = true
					elseif not isMonetLoader() and hotkey_no_errors and settings.general.bind_command_stop and settings.general.use_binds then
						sampAddChatMessage('[AS Helper] {ffffff}Чтобы остановить отыгровку команды используйте ' .. message_color_hex .. '/stop {ffffff}или нажмите ' .. message_color_hex .. getNameKeysFrom(settings.general.bind_command_stop), message_color)
					else
						sampAddChatMessage('[AS Helper] {ffffff}Чтобы остановить отыгровку команды используйте ' .. message_color_hex .. '/stop', message_color)
					end
					sampSendChat("/rb Внимание! Через 15 секунд будет спавн транспорта организации.")
					wait(1500)
					if command_stop then 
						command_stop = false 
						isActiveCommand = false
						if isMonetLoader() and settings.general.mobile_stop_button then
							CommandStopWindow[0] = false
						end
						sampAddChatMessage('[AS Helper] {ffffff}Отыгровка команды /spcar успешно остановлена!', message_color) 
						return
					end
					sampSendChat("/rb Займите транспорт, иначе он будет заспавнен.")
					wait(13500)	
					if command_stop then 
						command_stop = false 
						isActiveCommand = false
						if isMonetLoader() and settings.general.mobile_stop_button then
							CommandStopWindow[0] = false
						end
						sampAddChatMessage('[AS Helper] {ffffff}Отыгровка команды /spcar успешно остановлена!', message_color) 
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
				sampAddChatMessage('[AS Helper] {ffffff}Дождитесь завершения отыгровки предыдущей команды!', message_color)
			end
		end)
		-- Ригистрация всех команд которые есть в json для 9/10
		registerCommandsFrom(settings.commands_manage) 
	end
	-- Дополнительная неактуальная команда, позже будет удалена
	sampRegisterChatCommand("hlr", function() 
		if not isActiveCommand then
			lua_thread.create(function() 
				isActiveCommand = true
				CommandStopWindow[0] = true
				for _, h in pairs(getAllChars()) do
					_, id = sampGetPlayerIdByCharHandle(h)
					_, m = sampGetPlayerIdByCharHandle(PLAYER_PED)
					id = tonumber(id)
					if id ~= -1 and id ~= m and doesCharExist(h) and sampIsPlayerConnected(id) then
						local x, y, z = getCharCoordinates(h)
						local mx, my, mz = getCharCoordinates(PLAYER_PED)
						local dist = getDistanceBetweenCoords3d(mx, my, mz, x, y, z)
						if dist <= 4 then
							if u8(sampGetCurrentServerName()):find("Vice City") then
								sampSendChat("/heal "..id.." "..settings.price.heal_vc)
							else
								sampSendChat("/heal "..id.." "..settings.price.heal)
							end
							wait(500)
						end
					end
				end
				isActiveCommand = false
				CommandStopWindow[0] = false
			end)
		else
			sampAddChatMessage('[AS Helper] {ffffff}Дождитесь завершения отыгровки предыдущей команды!', message_color)
		end
	end)
end
local russian_characters = {
    [168] = 'Ё', [184] = 'ё', [192] = 'А', [193] = 'Б', [194] = 'В', [195] = 'Г', [196] = 'Д', [197] = 'Е', [198] = 'Ж', [199] = 'З', [200] = 'И', [201] = 'Й', [202] = 'К', [203] = 'Л', [204] = 'М', [205] = 'Н', [206] = 'О', [207] = 'П', [208] = 'Р', [209] = 'С', [210] = 'Т', [211] = 'У', [212] = 'Ф', [213] = 'Х', [214] = 'Ц', [215] = 'Ч', [216] = 'Ш', [217] = 'Щ', [218] = 'Ъ', [219] = 'Ы', [220] = 'Ь', [221] = 'Э', [222] = 'Ю', [223] = 'Я', [224] = 'а', [225] = 'б', [226] = 'в', [227] = 'г', [228] = 'д', [229] = 'е', [230] = 'ж', [231] = 'з', [232] = 'и', [233] = 'й', [234] = 'к', [235] = 'л', [236] = 'м', [237] = 'н', [238] = 'о', [239] = 'п', [240] = 'р', [241] = 'с', [242] = 'т', [243] = 'у', [244] = 'ф', [245] = 'х', [246] = 'ц', [247] = 'ч', [248] = 'ш', [249] = 'щ', [250] = 'ъ', [251] = 'ы', [252] = 'ь', [253] = 'э', [254] = 'ю', [255] = 'я',
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
        elseif ch == 168 then -- Ё
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
        elseif ch == 184 then -- ё
            output = output .. russian_characters[168]
        else
            output = output .. string.char(ch)
        end
    end
    return output
end
function TranslateNick(name)
	if name:match('%a+') then
        for k, v in pairs({['ph'] = 'ф',['Ph'] = 'Ф',['Ch'] = 'Ч',['ch'] = 'ч',['Th'] = 'Т',['th'] = 'т',['Sh'] = 'Ш',['sh'] = 'ш', ['ea'] = 'и',['Ae'] = 'Э',['ae'] = 'э',['size'] = 'сайз',['Jj'] = 'Джейджей',['Whi'] = 'Вай',['lack'] = 'лэк',['whi'] = 'вай',['Ck'] = 'К',['ck'] = 'к',['Kh'] = 'Х',['kh'] = 'х',['hn'] = 'н',['Hen'] = 'Ген',['Zh'] = 'Ж',['zh'] = 'ж',['Yu'] = 'Ю',['yu'] = 'ю',['Yo'] = 'Ё',['yo'] = 'ё',['Cz'] = 'Ц',['cz'] = 'ц', ['ia'] = 'я', ['ea'] = 'и',['Ya'] = 'Я', ['ya'] = 'я', ['ove'] = 'ав',['ay'] = 'эй', ['rise'] = 'райз',['oo'] = 'у', ['Oo'] = 'У', ['Ee'] = 'И', ['ee'] = 'и', ['Un'] = 'Ан', ['un'] = 'ан', ['Ci'] = 'Ци', ['ci'] = 'ци', ['yse'] = 'уз', ['cate'] = 'кейт', ['eow'] = 'яу', ['rown'] = 'раун', ['yev'] = 'уев', ['Babe'] = 'Бэйби', ['Jason'] = 'Джейсон', ['liy'] = 'лий', ['ane'] = 'ейн', ['ame'] = 'ейм'}) do
            name = name:gsub(k, v) 
        end
		for k, v in pairs({['B'] = 'Б',['Z'] = 'З',['T'] = 'Т',['Y'] = 'Й',['P'] = 'П',['J'] = 'Дж',['X'] = 'Кс',['G'] = 'Г',['V'] = 'В',['H'] = 'Х',['N'] = 'Н',['E'] = 'Е',['I'] = 'И',['D'] = 'Д',['O'] = 'О',['K'] = 'К',['F'] = 'Ф',['y`'] = 'ы',['e`'] = 'э',['A'] = 'А',['C'] = 'К',['L'] = 'Л',['M'] = 'М',['W'] = 'В',['Q'] = 'К',['U'] = 'А',['R'] = 'Р',['S'] = 'С',['zm'] = 'зьм',['h'] = 'х',['q'] = 'к',['y'] = 'и',['a'] = 'а',['w'] = 'в',['b'] = 'б',['v'] = 'в',['g'] = 'г',['d'] = 'д',['e'] = 'е',['z'] = 'з',['i'] = 'и',['j'] = 'ж',['k'] = 'к',['l'] = 'л',['m'] = 'м',['n'] = 'н',['o'] = 'о',['p'] = 'п',['r'] = 'р',['s'] = 'с',['t'] = 'т',['u'] = 'у',['f'] = 'ф',['x'] = 'x',['c'] = 'к',['``'] = 'ъ',['`'] = 'ь',['_'] = ' '}) do
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
function show_fast_menu(id)
	if isParamSampID(id) then 
		player_id = tonumber(id)
		FastMenu[0] = true
	else
		if isMonetLoader() or settings.general.bind_fastmenu == nil then
			if not FastMenuPlayers[0] then
				sampAddChatMessage('[AS Helper] {ffffff}Используйте ' .. message_color_hex .. '/sm [ID]', message_color)
			end
		elseif settings.general.bind_fastmenu and settings.general.use_binds and hotkey_no_errors then
			sampAddChatMessage('[AS Helper] {ffffff}Используйте ' .. message_color_hex .. '/sm [ID] {ffffff}или наведитесь на игрока через ' .. message_color_hex .. 'ПКМ + ' .. getNameKeysFrom(settings.general.bind_fastmenu), message_color) 
		else
			sampAddChatMessage('[AS Helper] {ffffff}Используйте ' .. message_color_hex .. '/sm [ID]', message_color)
		end 
	end 
end
function show_leader_fast_menu(id)
	if isParamSampID(id) then
		player_id = tonumber(id)
		LeaderFastMenu[0] = true
	else
		if isMonetLoader() or settings.general.bind_leader_fastmenu == nil then
			sampAddChatMessage('[AS Helper] {ffffff}Используйте ' .. message_color_hex .. '/slm [ID]', message_color)
		elseif settings.general.bind_leader_fastmenu and settings.general.use_binds and hotkey_no_errors then
			sampAddChatMessage('[AS Helper] {ffffff}Используйте ' .. message_color_hex .. '/slm [ID] {ffffff}или наведитесь на игрока через ' .. message_color_hex .. 'ПКМ + ' .. getNameKeysFrom(settings.general.bind_leader_fastmenu), message_color) 
		else
			sampAddChatMessage('[AS Helper] {ffffff}Используйте ' .. message_color_hex .. '/slm [ID]', message_color)
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
	[id.FIST] = 'кулаки',
	[id.BRASSKNUCKLES] = 'кастеты',
	[id.GOLFCLUB] = 'клюшку для гольфа',
	[id.NIGHTSTICK] = 'дубинку',
	[id.KNIFE] = 'острый нож',
	[id.BASEBALLBAT] = 'биту',
	[id.SHOVEL] = 'лопату',
	[id.POOLCUE] = 'кий',
	[id.KATANA] = 'катану',
	[id.CHAINSAW] = 'бензопилу',
	[id.PURPLEDILDO] = 'дидло',
	[id.WHITEDILDO] = 'дидло',
	[id.WHITEVIBRATOR] = 'вибратор',
	[id.SILVERVIBRATOR] = 'вибратор',
	[id.FLOWERS] = 'букет цветов',
	[id.CANE] = 'трость',
	[id.GRENADE] = 'осколочную гранату',
	[id.TEARGAS] = 'дымовую гранату',
	[id.MOLOTOV] = 'коктейль Молотова',
	[id.COLT45] = 'пистолет Colt45',
	[id.SILENCED] = "электрошокер Taser-X26P",
	[id.DESERTEAGLE] = 'пистолет Desert Eagle',
	[id.SHOTGUN] = 'дробовик',
	[id.SAWNOFFSHOTGUN] = 'обрез',
	[id.COMBATSHOTGUN] = 'улучшенный обрез',
	[id.UZI] = 'пистолет-пулемёт Micro Uzi',
	[id.MP5] = 'пистолет-пулемёт MP5',
	[id.AK47] = 'автомат AK-47',
	[id.M4] = 'автомат M4',
	[id.TEC9] = 'пистолет-пулемёт Tec-9',
	[id.RIFLE] = 'винтовку Rifle',
	[id.SNIPERRIFLE] = 'снайперскую винтовку Rifle',
	[id.ROCKETLAUNCHER] = 'ручную противотанковую ракету',
	[id.HEATSEEKER] = 'устройство для запуска ракет',
	[id.FLAMETHROWER] = 'огнемёт',
	[id.MINIGUN] = 'миниган',
	[id.SATCHELCHARGE] = 'динамит',
	[id.DETONATOR] = 'детонатор',
	[id.SPRAYCAN] = 'перцовый баланчик',
	[id.FIREEXTINGUISHER] = 'огнетушитель',
	[id.CAMERA] = 'фотоапарат Canon',
	[id.NIGHTVISION] = 'прибор ночного видения',
	[id.THERMALVISION] = 'тепловизор',
	[id.PARACHUTE] = 'ручной парашут',
	[id.WEAPON_VEHICLE] = 'автомобиль',
	[id.HELI] = 'лопасти вертолёта',
	[id.BOMB] = 'взрыв',
	[id.COLLISION] = 'коллизию',
	-- ARZ LAUNCHER GUNS
	[id.DEAGLE_STEEL] = 'пистолет Desert Eagle Steel',
	[id.DEAGLE_GOLD] = 'пистолет Desert Eagle Gold',
	[id.GLOCK_GRADIENT] = 'пистолет Glock',
	[id.DEAGLE_FLAME] = 'пистолет Desert Eagle Flame',
	[id.PYTHON_ROYAL] = 'пистолет Colt Python',
	[id.PYTHON_SILVER] = 'пистолет Colt Python Silver',
	[id.AK47_ROSES] = 'автомат AK-47 Roses',
	[id.AK47_GOLD] = 'автомат AK-47 Gold',
	[id.M249_GRAFFITI] = 'пулемёт M249 Graffiti',	
	[id.SAIGA_GOLD] = 'золотую Сайгу',
	[id.PPSH_STANDART] = 'пистолет-пулемёт Standart',
	[id.M249_STANDART] = 'пулемёт M249',
	[id.SKORP_STANDART] = 'пистолет-пулемёт Skorp',
	[id.AKS74_CAMOUFLAGE1] = 'автомат AKS-74 камуфляжный',
	[id.AK47_CAMOUFLAGE1] = 'автомат AK-47 камуфляжный',
	[id.REBECCA_SHOTGUN] = 'дробовик Rebecca',
	[id.OBJ58_PORTALGUN] = 'портальную пушку',
	[id.PORTALGUN] = 'портальную пушку',
	[id.ICE_SWORD] = 'ледяной меч',
	[id.SOUND_GRENADE] = 'оглушающую граната',
	[id.EYE_GRENADE] = 'ослепляющую граната',
	[id.MCMILLIAN_TAC50] = 'снайперскую винтовку McMillian TAC-50'
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
local rpTakeNames = {{"из-за спины", "за спину"}, {"из кармана", "в карман"}, {"из пояса", "на пояс"}, {"из кобуры", "в кобуру"}}
local rpTake = {
	[2]=1, [5]=1, [6]=1, [7]=1, [8]=1, [9]=1, [14]=1, [15]=1, [25]=1, [26]=1, [27]=1, [28]=1, [29]=1, [30]=1, [31]=1, [32]=1, [33]=1, [34]=1, [35]=1, [36]=1, [37]=1, [38]=1, [42]=1, [77]=1, [78]=1, [78]=1, [79]=1, [80]=1, [81]=1, [82]=1, [83]=1, [84]=1, [85]=1, [86]=1, [92]=1, [87]=1, [88]=1, [49]=1, [50]=1, [51]=1, [54]=1, -- спина
	[1]=2, [4]=2, [10]=2, [11]=2, [12]=2, [13]=2, [41]=2, [43]=2, [44]=2, [45]=2, [46]=2, -- карман
	[16]=3, [17]=3, [18]=3, [39]=3, [40]=3, [90]=3, [91]=3, [3]=3,  -- пояс
	[22]=4, [23]=4, [24]=4, [71]=4, [72]=4, [73]=4, [74]=4, [75]=4, [76]=4, [89]=4, -- кобура
}
for id, weapon in pairs(weapons.names) do
	if (id == 3 or (id > 15 and id < 19) or (id == 90 or id == 91)) then -- 3 16 17 18 (for gunOn)
		if settings.player_info.sex == "Мужчина" or settings.player_info.sex == "Неизвестно" then
			gunOn[id] = 'снял'
		elseif settings.player_info.sex == "Женщина" then
			gunOn[id] = 'снялa'
		end
	else
		if settings.player_info.sex == "Мужчина" or settings.player_info.sex == "Неизвестно" then
			gunOn[id] = 'достал'
		elseif settings.player_info.sex == "Женщина" then
			gunOn[id] = 'досталa'
		end
	end
	if (id == 3 or (id > 15 and id < 19) or (id > 38 and id < 41) or (id == 90 or id == 91)) then -- 3 16 17 18 39 40 (for gunOff)
		if settings.player_info.sex == "Мужчина" or settings.player_info.sex == "Неизвестно" then
			gunOff[id] = 'повесил'
		elseif settings.player_info.sex == "Женщина" then
			gunOff[id] = 'повесилa'
		end
	else
		if settings.player_info.sex == "Мужчина" or settings.player_info.sex == "Неизвестно" then
			gunOff[id] = 'убрал'
		elseif settings.player_info.sex == "Женщина" then
			gunOff[id] = 'убралa'
		end
	end
	if id > 0 then
		gunPartOn[id] = rpTakeNames[rpTake[id]][1]
		gunPartOff[id] = rpTakeNames[rpTake[id]][2]
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
	if sampGetPlayerNickname(myid):find(nick) then return myid end
	for i = 0, 999 do
	    if sampIsPlayerConnected(i) and sampGetPlayerNickname(i):find(nick) then
		   id = i
		   break
	    end
	end
	if id == nil then
		sampAddChatMessage('[Hospital Helper] {ffffff}Ошибка: не удалось получить ID игрока!', message_color)
		id = ''
	end
	return id
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
	--sampAddChatMessage('color = ' .. color .. ' , text = '..text,-1)
	if text:find('Ошибка(.+)У игрока уже есть такая лицензия сроком более чем (.+)') then
		local one, two = text:match('Ошибка(.+)У игрока уже есть такая лицензия сроком более чем (.+)')
		sampAddChatMessage('[AS Helper] {ffffff}У игрока уже есть такая лицензия сроком более чем ' .. two, message_color)
		sampSendChat('У вас уже такая лицензия сроком более чем ' .. two)
		return false
	end
	if (settings.general.auto_uval and tonumber(settings.player_info.fraction_rank_number) >= 9) then
		if text:find("^%[(.-)%] (.-) (.-)%[(.-)%]: (.+)") and color == 766526463 then -- /f /fb или /r /rb без тэга 
			local tag, rank, name, playerID, message = string.match(text, "%[(.-)%] (.+) (.-)%[(.-)%]: (.+)")
			lua_thread.create(function ()
				wait(50)
				if ((not message:find(" отправьте (.+) +++ чтобы уволится ПСЖ!") and not message:find("Сотрудник (.+) был уволен по причине(.+)")) and (message:rupper():find("ПСЖ") or message:rupper():find("ПСЖ.") or message:rupper():find("УВОЛЬТЕ") or message:find("УВОЛЬТЕ.") or message:rupper():find("УВАЛ") or message:rupper():find("УВАЛ."))) then
					message3 = message2
					message2 = message1
					message1 = text
					PlayerID = playerID
					if message3 == text then
						sampAddChatMessage('[AS Helper]{ffffff} Игрок 3 раза подряд попросил увал, автоподтверждение принято, увольняю...', message_color)
						auto_uval_checker = true
						sampSendChat('/fmute ' .. playerID .. ' 1 [AutoUval] Ожидайте')
					elseif tag == "R" then
						sampSendChat("/rb "..name.." отправьте /rb +++ чтобы уволится ПСЖ!")
					elseif tag == "F" then
						sampSendChat("/fb "..name.." отправьте /fb +++ чтобы уволится ПСЖ!")
					end
				elseif ((message == "(( +++ ))" or message == "(( +++. ))") and (PlayerID == playerID)) then
					auto_uval_checker = true
					sampSendChat('/fmute ' .. PlayerID .. ' 1 [AutoUval] Ожидайте')
				end
			end)
		elseif text:find("^%[(.-)%] %[(.-)%] (.+) (.-)%[(.-)%]: (.+)") and color == 766526463 then -- /r или /f с тэгом
			local tag, tag2, rank, name, playerID, message = string.match(text, "%[(.-)%] %[(.-)%] (.+) (.-)%[(.-)%]: (.+)")
			lua_thread.create(function ()
				wait(50)
				if not message:find(" отправьте (.+) +++ чтобы уволится ПСЖ!") and not message:find("Сотрудник (.+) был уволен по причине(.+)") and message:rupper():find("ПСЖ") or message:rupper():find("ПСЖ.") or message:rupper():find("УВОЛЬТЕ") or message:find("УВОЛЬТЕ.") or message:rupper():find("УВАЛ") or message:rupper():find("УВАЛ.") then
					message3 = message2
					message2 = message1
					message1 = text
					PlayerID = playerID	
					if message3 == text then
						sampAddChatMessage('[AS Helper]{ffffff} Игрок 3 раза подряд попросил увал, автоподтверждение принято, увольняю...', message_color)
						auto_uval_checker = true
						sampSendChat('/fmute ' .. playerID .. ' 1 [AutoUval] Ожидайте')
					elseif tag == "R" then
						sampSendChat("/rb "..name.."["..playerID.."], отправьте /rb +++ чтобы уволится ПСЖ!")
					elseif tag == "F" then
						sampSendChat("/fb "..name.."["..playerID.."], отправьте /fb +++ чтобы уволится ПСЖ!")
					end
				elseif ((message == "(( +++ ))" or  message == "(( +++. ))") and (PlayerID == playerID)) then
					auto_uval_checker = true
					sampSendChat('/fmute ' .. playerID .. ' 1 [AutoUval] Ожидайте')
				end
			end)
		end
		if text:find("(.+) заглушил%(а%) игрока (.+) на 1 минут. Причина: %[AutoUval%] Ожидайте") and auto_uval_checker then
			local text2 = text:gsub('{......}', '')
			local DATA, PlayerName, Time, Reason = text2:match("(.+) заглушил%(а%) игрока (.+) на 1 минут. Причина: (.+)")
			local Name = DATA:match(" ([A-Za-z0-9_]+)%[")
			local MyName = sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)))
			lua_thread.create(function ()
				wait(50)
				if Name == MyName then
					sampAddChatMessage('[AS Helper] {ffffff}Увольняю игрока ' .. sampGetPlayerNickname(PlayerID) .. '!', message_color)
					auto_uval_checker = false
					temp = PlayerID .. ' ПСЖ'
					find_and_use_command("/uninvite {arg_id} {arg2}", temp)
				else
					sampAddChatMessage('[AS Helper] {ffffff}Другой заместитель/лидер уже увольняет игрока ' .. sampGetPlayerNickname(PlayerID) .. '!', message_color)
					auto_uval_checker = false
				end
			end)
		end
	end
	if text:find("1%.{6495ED} 111 %- {FFFFFF}Проверить баланс телефона") or
		text:find("2%.{6495ED} 060 %- {FFFFFF}Служба точного времени") or
		text:find("3%.{6495ED} 911 %- {FFFFFF}Полицейский участок") or
		text:find("4%.{6495ED} 912 %- {FFFFFF}Скорая помощь") or
		text:find("5%.{6495ED} 914 %- {FFFFFF}Такси") or
		text:find("5%.{6495ED} 914 %- {FFFFFF}Механик") or
		text:find("6%.{6495ED} 8828 %- {FFFFFF}Справочная центрального банка") or
		text:find("7%.{6495ED} 997 %- {FFFFFF}Служба по вопросам жилой недвижимости %(узнать владельца дома%)") then
		return false
	end
	if text:find("Номера телефонов государственных служб:") then
		sampAddChatMessage('[AS Helper] {ffffff}Номера телефонов государственных служб:', message_color)
		sampAddChatMessage('[AS Helper] {ffffff}111 Баланс | 60 Время | 911 МЮ | 912 МЗ | 913 Такси | 914 Мехи | 8828 Банк | 997 Дома', message_color)
		return false
	end
	if (text:find('Bogdan_Martelli') and getARZServerNumber():find('20')) or text:find('%[20%]Bogdan_Martelli') then
		local lastColor = text:match("(.+){%x+}$")
   		if not lastColor then
			lastColor = "{" .. rgba_to_hex(color) .. "}"
		end
		if text:find('%[VIP ADV%]') or text:find('%[FOREVER%]') then
			lastColor = "{FFFFFF}"
		end
		if text:find('%[20%]Bogdan_Martelli%[%d+%]') then
			-- Случай 2: [20]Bogdan_Martelli[123]
			local id = text:match('%[20%]Bogdan_Martelli%[(%d+)%]') or ''
			text = string.gsub(text, '%[20%]Bogdan_Martelli%[%d+%]', message_color_hex .. '[20]MTG MODS[' .. id .. ']' .. lastColor)
		
		elseif text:find('%[20%]Bogdan_Martelli') then
			-- Случай 1: [20]Bogdan_Martelli
			text = string.gsub(text, '%[20%]Bogdan_Martelli', message_color_hex .. '[20]MTG MODS' .. lastColor)
		
		elseif text:find('Bogdan_Martelli%[%d+%]') then
			-- Случай 3: Bogdan_Martelli[123]
			local id = text:match('Bogdan_Martelli%[(%d+)%]') or ''
			text = string.gsub(text, 'Bogdan_Martelli%[%d+%]', message_color_hex .. 'MTG MODS[' .. id .. ']' .. lastColor)
		elseif text:find('Bogdan_Martelli') then
			-- Случай 3: Bogdan_Martelli
			text = string.gsub(text, 'Bogdan_Martelli', message_color_hex .. 'MTG MODS' .. lastColor)
		end
		return {color,text}
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
	if text == "/me достаёт из своего мед.кейса лекарство и принимает его" then
		auto_healme = true
	end
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
function sampev.onShowDialog(dialogid, style, title, button1, button2, text)
	--sampAddChatMessage(text, -1)

	if title:find('Продажа лицензии') and givelic_bool then
        if license_type == 'авто' then
            sampSendDialogResponse(dialogid, 1, 0, 0)
        elseif license_type == 'мото' then
            sampSendDialogResponse(dialogid, 1, 1, 0)
        elseif license_type == 'полеты' then
            sampSendDialogResponse(dialogid, 1, 2, 0)
        elseif license_type == 'рыбалка' then
            sampSendDialogResponse(dialogid, 1, 3, 0)
        elseif license_type == 'водный' then
            sampSendDialogResponse(dialogid, 1, 4, 0)
        elseif license_type == 'оружие' then
            sampSendDialogResponse(dialogid, 1, 5, 0)
        elseif license_type == 'охота' then
            sampSendDialogResponse(dialogid, 1, 6, 0)
        elseif license_type == 'раскопки' then
            sampSendDialogResponse(dialogid, 1, 7, 0)
        elseif license_type == 'такси' then
            sampSendDialogResponse(dialogid, 1, 8, 0)
        elseif license_type == 'механик' then
            sampSendDialogResponse(dialogid, 1, 9, 0)       
        end
        return false
    end
    if title:find('Выбор срока лицензий') and givelic_bool then
        sampSendDialogResponse(dialogid, 1, license_time - 1, 0)
        givelic_bool = false
		isActiveCommand = false
        return false
    end

	if text:find('Вы действительно хотите вызвать сотрудников полиции?') and settings.general.anti_trivoga then -- тревожная кнопка
		sampSendDialogResponse(dialogid, 0, 0, 0)
		return false
	end
	
	if title:find('Основная статистика') and check_stats then -- получение статистики
		if text:find("{FFFFFF}Имя: {B83434}%[(.-)]") then
			settings.player_info.name_surname = TranslateNick(text:match("{FFFFFF}Имя: {B83434}%[(.-)]"))
			input_name_surname = imgui.new.char[256](u8(settings.player_info.name_surname))
			sampAddChatMessage('[AS Helper] {ffffff}Ваше Имя и Фамилия обнаружены, вы - ' .. settings.player_info.name_surname, message_color)
		end
		if text:find("{FFFFFF}Пол: {B83434}%[(.-)]") then
			settings.player_info.sex = text:match("{FFFFFF}Пол: {B83434}%[(.-)]")
			sampAddChatMessage('[AS Helper] {ffffff}Ваш пол обнаружен, вы - ' .. settings.player_info.sex, message_color)
		end
		if text:find("{FFFFFF}Организация: {B83434}%[(.-)]") then
			settings.player_info.fraction = text:match("{FFFFFF}Организация: {B83434}%[(.-)]")
			if settings.player_info.fraction == 'Не имеется' then
				sampAddChatMessage('[AS Helper] {ffffff}Вы не состоите в организации!',message_color)
				settings.player_info.fraction_tag = "Неизвестно"
			else
				sampAddChatMessage('[AS Helper] {ffffff}Ваша организация обнаружена, это: '..settings.player_info.fraction, message_color)
				settings.player_info.fraction_tag = 'ГЦЛ'
				settings.deportament.dep_tag1 = '[' .. settings.player_info.fraction_tag .. ']'
				input_dep_tag1 = imgui.new.char[32](u8(settings.deportament.dep_tag1))
				input_fraction_tag = imgui.new.char[256](u8(settings.player_info.fraction_tag))
				sampAddChatMessage('[AS Helper] {ffffff}Вашей организации присвоен тег '..settings.player_info.fraction_tag .. ". Но вы можете изменить его.", message_color)
			end
		end
		if text:find("{FFFFFF}Должность: {B83434}(.+)%((%d+)%)") then
			settings.player_info.fraction_rank, settings.player_info.fraction_rank_number = text:match("{FFFFFF}Должность: {B83434}(.+)%((%d+)%)(.+)Уровень розыска")
			sampAddChatMessage('[AS Helper] {ffffff}Ваша должность обнаружена, это: '..settings.player_info.fraction_rank.." ("..settings.player_info.fraction_rank_number..")", message_color)
			if tonumber(settings.player_info.fraction_rank_number) >= 9 then
				settings.general.auto_uval = true
				initialize_commands()
			end
		else
			settings.player_info.fraction_rank = "Неизвестно"
			settings.player_info.fraction_rank_number = 0
			sampAddChatMessage('[AS Helper] {ffffff}Произошла ошибка, не могу получить ваш ранг!',message_color)
		end
		save_settings()
		sampSendDialogResponse(235, 0,0,0)
		check_stats = false

		return false
	end

	if spawncar_bool and title:find('$') and text:find('Спавн транспорта') then -- спавн транспорта
		sampSendDialogResponse(dialogid, 1, 3, 0)
		spawncar_bool = false
		return false 
	end
	
	if vc_vize_bool and text:find('Управление разрешениями на командировку в Vice City') then -- VS Visa [0]
		sampSendDialogResponse(dialogid, 1, 8, 0)
		return false 
	end
	
	if vc_vize_bool and title:find('Выдача разрешений на поездки Vice City') then -- VS Visa [1]
		vc_vize_bool = false
		sampSendChat("/r Сотруднику "..TranslateNick(sampGetPlayerNickname(tonumber(vc_vize_player_id))).." выдана виза Vice City!")
		sampSendDialogResponse(dialogid, 1, 0, tostring(vc_vize_player_id))
		return false 
	end
	
	if vc_vize_bool and title:find('Забрать разрешение на поездки Vice City') then -- VS Visa [2]
		vc_vize_bool = false
		sampSendChat("/r У сотрудника "..TranslateNick(sampGetPlayerNickname(tonumber(vc_vize_player_id))).." была изьята виза Vice City!")
		sampSendDialogResponse(dialogid, 1, 0, tostring(sampGetPlayerNickname(vc_vize_player_id)))
		return false 
	end

	if title:find('Сущности рядом') then -- arz fastmenu
		sampSendDialogResponse(dialogid, 0, 2, 0)
		return false 
	end

	if members_check and title:find('(.+)%(В сети: (%d+)%)') then -- мемберс 
	
        local count = 0
        local next_page = false
        local next_page_i = 0
		members_fraction = string.match(title, '(.+)%(В сети')
		members_fraction = string.gsub(members_fraction, '{(.+)}', '')
        for line in text:gmatch('[^\r\n]+') do
            count = count + 1
            if not line:find('Ник') and not line:find('страница') then

				line = line:gsub("{FFA500}%(Вы%)", "")
				line = line:gsub(" %/ В деморгане", "")

				--line = line:gsub("  ", "")
				--local color, nickname, id, rank, rank_number, rank_time, warns, afk = string.match(line, "{(......)}(.+)%((%d+)%)(.+)%((%d+)%)(.+){FFFFFF}(%d+) %[%d+%] %/ (%d+) %d+ шт")

				-- if nickname:find('%[%:(.+)%] (.+)') then
				-- 	tag, nick = nickname:match('%[(.+)%] (.+)')
				-- 	nickname = nick
				-- end

				if line:find('{FFA500}%(%d+.+%)') then
					local color, nickname, id, rank, rank_number, color2, rank_time, warns, afk = string.match(line, "{(%x%x%x%x%x%x)}([%w_]+)%((%d+)%)%s*([^%(]+)%((%d+)%)%s*{(%x%x%x%x%x%x)}%(([^%)]+)%)%s*{FFFFFF}(%d+)%s*%[%d+%]%s*/%s*(%d+)%s*%d+ шт")
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
					local color, nickname, id, rank, rank_number, rank_time, warns, afk = string.match(line, "{(%x%x%x%x%x%x)}%s*([^%(]+)%((%d+)%)%s*([^%(]+)%((%d+)%)%s*([^{}]+){FFFFFF}%s*(%d+)%s*%[%d+%]%s*/%s*(%d+)%s*%d+ шт")
					if color ~= nil and nickname ~= nil and id ~= nil and rank ~= nil and rank_number ~= nil and warns ~= nil and afk ~= nil then
						local working = false
						if color:find('90EE90') then
							working = true
						end

						table.insert(members_new, { nick = nickname, id = id, rank = rank, rank_number = rank_number, warns = warns, afk = afk, working = working})
					end
				end
				
				
				
            end
            if line:match('Следующая страница') then
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
			sampAddChatMessage('[AS Helper]{ffffff} Список сотрудников пуст!', message_color)
			members_check = false
        end
        return false
    end

	if title:find('Выберите ранг для (.+)') and text:find('вакансий') then -- invite
		sampSendDialogResponse(dialogid, 1, 0, 0)
		return false
	end
end
function sampev.onCreate3DText(id, color, position, distance, testLOS, attachedPlayerId, attachedVehicleId, text_3d)
   if text_3d and text_3d:find('Тревожная кнопка') and settings.general.anti_trivoga then -- удаление тревожной кнопки
		return false
	end
end
function change_dpi()
	if isMonetLoader() then
		
	else
		imgui.SetWindowFontScale(settings.general.custom_dpi)
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

imgui.OnFrame(
    function() return MainWindow[0] end,
    function()
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(600 * settings.general.custom_dpi, 425	* settings.general.custom_dpi), imgui.Cond.FirstUseEver)
		imgui.Begin(fa.BUILDING.." AS Helper##main", MainWindow, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize )
		change_dpi()
		if imgui.BeginTabBar('Tabs') then	
			if imgui.BeginTabItem(fa.HOUSE..u8' Главное меню') then
				if imgui.BeginChild('##1', imgui.ImVec2(589 * settings.general.custom_dpi, 172 * settings.general.custom_dpi), true) then
					imgui.CenterText(fa.USER .. u8' Информация про сотрудника')
					imgui.Separator()
					imgui.Columns(3)
					imgui.CenterColumnText(u8"Имя и Фамилия:")
					imgui.SetColumnWidth(-1, 230 * settings.general.custom_dpi)
					imgui.NextColumn()
					imgui.CenterColumnText(u8(settings.player_info.name_surname))
					imgui.SetColumnWidth(-1, 250 * settings.general.custom_dpi)
					imgui.NextColumn()
					if imgui.CenterColumnSmallButton(u8'Изменить##name_surname') then
						settings.player_info.name_surname = TranslateNick(sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))))
						input_name_surname = imgui.new.char[256](u8(settings.player_info.name_surname))
						save_settings()
						imgui.OpenPopup(fa.USER .. u8' Имя и Фамилия##name_surname')
					end
					if imgui.BeginPopupModal(fa.USER .. u8' Имя и Фамилия##name_surname', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize  ) then
						change_dpi()
						imgui.PushItemWidth(405 * settings.general.custom_dpi)
						imgui.InputText(u8'##name_surname', input_name_surname, 256) 
						imgui.Separator()
						if imgui.Button(fa.CIRCLE_XMARK .. u8' Отмена', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
							imgui.CloseCurrentPopup()
						end
						imgui.SameLine()
						if imgui.Button(fa.FLOPPY_DISK .. u8' Сохранить', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
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
					imgui.CenterColumnText(u8"Пол:")
					imgui.NextColumn()
					imgui.CenterColumnText(u8(settings.player_info.sex))
					imgui.NextColumn()
					if imgui.CenterColumnSmallButton(u8'Изменить##sex') then
						if settings.player_info.sex == 'Неизвестно' then
							settings.player_info.sex = 'Женщина'
							save_settings()
						elseif settings.player_info.sex == 'Мужчина' then
							settings.player_info.sex = 'Женщина'
							save_settings()
						elseif settings.player_info.sex == 'Женщина' then
							settings.player_info.sex = 'Мужчина'
							save_settings()
						end
					end
					imgui.Columns(1)
					imgui.Separator()
					imgui.Columns(3)
					imgui.CenterColumnText(u8"Акцент:")
					imgui.NextColumn()
					if checkbox_accent_enable[0] then
						imgui.CenterColumnText(u8(settings.player_info.accent))
					else 
						imgui.CenterColumnText(u8'Отключено')
					end
					imgui.NextColumn()
					if imgui.CenterColumnSmallButton(u8'Изменить##accent') then
						imgui.OpenPopup(fa.USER .. u8' Акцент персонажа##accent')
					end
					if imgui.BeginPopupModal(fa.USER .. u8' Акцент персонажа##accent', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize  ) then
						change_dpi()
						if imgui.Checkbox('##checkbox_accent_enable', checkbox_accent_enable) then
							settings.general.accent_enable = checkbox_accent_enable[0]
							save_settings()
						end
						imgui.SameLine()
						imgui.PushItemWidth(375 * settings.general.custom_dpi)
						imgui.InputText(u8'##accent_input', input_accent, 256) 
						imgui.Separator()
						if imgui.Button(fa.CIRCLE_XMARK .. u8' Отмена', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
							imgui.CloseCurrentPopup()
						end
						imgui.SameLine()
						if imgui.Button(fa.FLOPPY_DISK .. u8' Сохранить', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then 
							settings.player_info.accent = u8:decode(ffi.string(input_accent))
							save_settings()
							imgui.CloseCurrentPopup()
						end
						imgui.End()
					end
					imgui.Columns(1)
					imgui.Separator()
					imgui.Columns(3)
					imgui.CenterColumnText(u8"Организация:")
					imgui.NextColumn()
					imgui.CenterColumnText(u8(settings.player_info.fraction))
					imgui.NextColumn()
					if imgui.CenterColumnSmallButton(u8'Изменить##fraction') then
						check_stats = true
						sampSendChat('/stats')
					end
					imgui.Columns(1)
					imgui.Separator()
					imgui.Columns(3)
					imgui.CenterColumnText(u8"Тэг организации:")
					imgui.NextColumn()
					imgui.CenterColumnText(u8(settings.player_info.fraction_tag))
					imgui.NextColumn()
					if imgui.CenterColumnSmallButton(u8'Изменить##fraction_tag') then
						imgui.OpenPopup(fa.USER .. u8' Тэг организации##fraction_tag')
					end
					if imgui.BeginPopupModal(fa.USER .. u8' Тэг организации##fraction_tag', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize  ) then
						change_dpi()
						imgui.PushItemWidth(405 * settings.general.custom_dpi)
						imgui.InputText(u8'##input_fraction_tag', input_fraction_tag, 256)
						imgui.Separator()
						if imgui.Button(fa.CIRCLE_XMARK .. u8' Отмена', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
							imgui.CloseCurrentPopup()
						end
						imgui.SameLine()
						if imgui.Button(fa.FLOPPY_DISK .. u8' Сохранить', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
							settings.player_info.fraction_tag = u8:decode(ffi.string(input_fraction_tag))
							save_settings()
							imgui.CloseCurrentPopup()
						end
						imgui.End()
					end
					imgui.Columns(1)
					
					imgui.Separator()
					
					imgui.Columns(3)
					imgui.CenterColumnText(u8"Должность в организации:")
					imgui.NextColumn()
					imgui.CenterColumnText(u8(settings.player_info.fraction_rank) .. " (" .. settings.player_info.fraction_rank_number .. ")")
					imgui.NextColumn()
					if imgui.CenterColumnSmallButton(u8"Изменить##rank") then
						check_stats = true
						sampSendChat('/stats')
					end
					imgui.Columns(1)
				
				imgui.EndChild()
				end
				if imgui.BeginChild('##2', imgui.ImVec2(589 * settings.general.custom_dpi, 150 * settings.general.custom_dpi), true) then
					imgui.CenterText(fa.SITEMAP .. u8' Дополнительные функции')
					imgui.Separator()
					imgui.Columns(3)
					imgui.CenterColumnText(u8"RP Общение")
					imgui.SameLine(nil, 5) imgui.TextDisabled("[?]")
					if imgui.IsItemHovered() then
						imgui.SetTooltip(u8"Все ваши сообщения в чат автоматически будут с заглавной буквы и с точкой в конце")
					end
					imgui.SetColumnWidth(-1, 230 * settings.general.custom_dpi)
					imgui.NextColumn()
					if settings.general.rp_chat then
						imgui.CenterColumnText(u8'Включено')
					else
						imgui.CenterColumnText(u8'Отключено')
					end
					imgui.SetColumnWidth(-1, 250 * settings.general.custom_dpi)
					imgui.NextColumn()
					if settings.general.rp_chat then
						if imgui.CenterColumnSmallButton(u8'Отключить##rp_chat') then
							settings.general.rp_chat = false
							save_settings()
						end
						else
						if imgui.CenterColumnSmallButton(u8'Включить##rp_chat') then
							settings.general.rp_chat = true
							save_settings()
						end
					end
					imgui.SetColumnWidth(-1, 100 * settings.general.custom_dpi)
					imgui.Columns(1)
					imgui.Separator()
					imgui.Columns(3)
					imgui.CenterColumnText(u8"RP дубинка")
					imgui.SameLine(nil, 5) imgui.TextDisabled("[?]")
					if imgui.IsItemHovered() then
						imgui.SetTooltip(u8"При использовании/скролле дубинки в чате будут RP отыгровки.")
					end
					imgui.NextColumn()
					if settings.general.rp_gun then
						imgui.CenterColumnText(u8'Включено')
					else
						imgui.CenterColumnText(u8'Отключено')
					end
					imgui.NextColumn()
					if settings.general.rp_gun then
						if imgui.CenterColumnSmallButton(u8'Отключить##rp_gun') then
							settings.general.rp_gun = false
							save_settings()
						end
					else
						if imgui.CenterColumnSmallButton(u8'Включить##rp_gun') then
							settings.general.rp_gun = true
							save_settings()
						end
					end
					imgui.Columns(1)
					imgui.Separator()
					imgui.Columns(3)
					imgui.CenterColumnText(u8"Авто-выдача лицензий")
					imgui.SameLine(nil, 5) imgui.TextDisabled("[?]")
					if imgui.IsItemHovered() then
						imgui.SetTooltip(u8'Автоматечески выдаёт лицензии игрокам пока вы стоите за стойкой\nИгроки должны написать в чат тип лицензии (частоиспользуемые фразы) и срок\nЕсли не напишут срок, а просто например "права", то автовыдача на 1 месяц')
					end
					imgui.NextColumn()
					imgui.CenterColumnText(u8'Отключено')
					imgui.NextColumn()
					if imgui.CenterColumnSmallButton(u8'Включить##auto_lic') then
						for i = 1, 10, 1 do
							sampAddChatMessage('[AS Helper] {ffffff}Данная функция доступна только в платной версии хелпера! Покупать у MTG MODS', message_color)
						end
					end
					imgui.Columns(1)
					imgui.Separator()
					imgui.Columns(3)
					imgui.CenterColumnText(u8"Авто-ремонт дорожых знаков")
					imgui.SameLine(nil, 5) imgui.TextDisabled("[?]")
					if imgui.IsItemHovered() then
						imgui.SetTooltip(u8'Автоматически ремонтирует дорожные знаки которым нужен ремонт\nАвто-кликер в менюшке ремонта после взятия инструментов')
					end
					imgui.NextColumn()
					imgui.CenterColumnText(u8'Отключено')
					imgui.NextColumn()
					if imgui.CenterColumnSmallButton(u8'Включить##auto_repair') then
						for i = 1, 10, 1 do
							sampAddChatMessage('[AS Helper] {ffffff}Данная функция доступна только в платной версии хелпера! Покупать у MTG MODS', message_color)
						end
					end
					imgui.Columns(1)
					imgui.Separator()
					imgui.Columns(3)
					imgui.CenterColumnText(u8"Авто Увал [9/10]")
					imgui.SameLine(nil, 5) imgui.TextDisabled("[?]")
					if imgui.IsItemHovered() then
						imgui.SetTooltip(u8"Автоматическое увольнение сотрудников, которые хотят увал ПСЖ\nФункция доступна только если вы 9/10 ранг!")
					end
					imgui.NextColumn()
					if settings.general.auto_uval then
						imgui.CenterColumnText(u8'Включено')
					else
						imgui.CenterColumnText(u8'Отключено')
					end
					imgui.NextColumn()
					if settings.general.auto_uval then
						if imgui.CenterColumnSmallButton(u8'Отключить##auto_uval') then
							settings.general.auto_uval = false
							save_settings()
						end
					else
						if imgui.CenterColumnSmallButton(u8'Включить##auto_uval') then
							if tonumber(settings.player_info.fraction_rank_number) == 9 or tonumber(settings.player_info.fraction_rank_number) == 10 then 
								settings.general.auto_uval = true
								save_settings()
							else
								settings.general.auto_uval = false
								sampAddChatMessage('[AS Helper] {ffffff}Эта Функция доступна только лидеру и заместителям!',message_color)
							end
						end
					end
				imgui.EndChild()
				end
				if imgui.BeginChild('##4', imgui.ImVec2(589 * settings.general.custom_dpi, 28 * settings.general.custom_dpi), true) then
					imgui.Columns(2)
					imgui.Text(fa.HAND_HOLDING_DOLLAR .. u8" Вы можете финансово поддержать автора скрипта (MTG MODS) донатом " .. fa.HAND_HOLDING_DOLLAR)
					imgui.SetColumnWidth(-1, 480 * settings.general.custom_dpi)
					imgui.NextColumn()
					if imgui.CenterColumnSmallButton(u8'Реквизиты') then
						imgui.OpenPopup(fa.SACK_DOLLAR .. u8' Поддержка разработчика')
					end
					if imgui.BeginPopupModal(fa.SACK_DOLLAR .. u8' Поддержка разработчика', _, imgui.WindowFlags.NoCollapse  + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar) then
						change_dpi()
						if not isMonetLoader() then imgui.SetWindowFontScale(settings.general.custom_dpi) end
						imgui.CenterText(u8'Свяжитесь с MTG MODS:')
						--imgui.SetCursorPosX(20*settings.general.custom_dpi)
						if imgui.Button(u8('Telegram'), imgui.ImVec2(imgui.GetMiddleButtonX(2), 25 * settings.general.custom_dpi)) then
							openLink('https://t.me/mtg_mods')
						end
						imgui.SameLine()
						if imgui.Button(u8('Discord'), imgui.ImVec2(imgui.GetMiddleButtonX(2), 25 * settings.general.custom_dpi)) then
							openLink('https://discordapp.com/users/514135796685602827')
						end
						imgui.Separator()
						if imgui.Button(fa.CIRCLE_XMARK .. u8' Закрыть', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
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
			if imgui.BeginTabItem(fa.RECTANGLE_LIST..u8' Команды и отыгровки') then 
				if imgui.BeginTabBar('Tabs2') then
					if imgui.BeginTabItem(fa.BARS..u8' Общие команды для всех рангов ') then 
						if imgui.BeginChild('##1', imgui.ImVec2(589 * settings.general.custom_dpi, 303 * settings.general.custom_dpi), true) then
							imgui.Columns(3)
							imgui.CenterColumnText(u8"Команда")
							imgui.SetColumnWidth(-1, 170 * settings.general.custom_dpi)
							imgui.NextColumn()
							imgui.CenterColumnText(u8"Описание")
							imgui.SetColumnWidth(-1, 300 * settings.general.custom_dpi)
							imgui.NextColumn()
							imgui.CenterColumnText(u8"Действие")
							imgui.SetColumnWidth(-1, 150 * settings.general.custom_dpi)
							imgui.Columns(1)
							imgui.Separator()
							imgui.Columns(3)
							imgui.CenterColumnText(u8"/sm")
							imgui.NextColumn()
							imgui.CenterColumnText(u8"Открыть быстрое меню взаимодействия")
							imgui.NextColumn()
							imgui.CenterColumnText(u8"Недоступно")
							imgui.Columns(1)
							imgui.Separator()
							imgui.Columns(3)
							imgui.CenterColumnText(u8"/mb")
							imgui.NextColumn()
							imgui.CenterColumnText(u8"Открыть меню списка сотрудников")
							imgui.NextColumn()
							imgui.CenterColumnText(u8"Недоступно")
							imgui.Columns(1)
							imgui.Separator()
							imgui.Columns(3)
							imgui.CenterColumnText(u8"/dep")
							imgui.NextColumn()
							imgui.CenterColumnText(u8"Открыть меню рации депортамента")
							imgui.NextColumn()
							imgui.CenterColumnText(u8"Недоступно")
							imgui.Columns(1)
							imgui.Separator()
							imgui.Columns(3)
							imgui.CenterColumnText(u8"/stop")
							imgui.NextColumn()
							imgui.CenterColumnText(u8"Остановить отыгровку команды")
							imgui.NextColumn()
							imgui.CenterColumnText(u8"Недоступно")
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
											imgui.SetTooltip(u8"Отключение команды /"..command.cmd)
										end
									else
										if imgui.SmallButton(fa.TOGGLE_OFF .. '##'..command.cmd) then
											command.enable = not command.enable
											save_settings()
											register_command(command.cmd, command.arg, command.text, tonumber(command.waiting))
										end
										if imgui.IsItemHovered() then
											imgui.SetTooltip(u8"Включение команды /"..command.cmd)
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
										change_bind = command.bind
										input_cmd = imgui.new.char[256](u8(command.cmd))
										change_text = command.text:gsub('&', '\n')		
										input_text = imgui.new.char[8192](u8(change_text))
										change_waiting = command.waiting
										waiting_slider = imgui.new.float(tonumber(command.waiting))	
										BinderWindow[0] = true
									end
									if imgui.IsItemHovered() then
										imgui.SetTooltip(u8"Изменение команды /"..command.cmd)
									end
									imgui.SameLine()
									if imgui.SmallButton(fa.TRASH_CAN .. '##'..command.cmd) then
										imgui.OpenPopup(fa.TRIANGLE_EXCLAMATION .. u8' Предупреждение ##' .. command.cmd)
									end
									if imgui.IsItemHovered() then
										imgui.SetTooltip(u8"Удаление команды /"..command.cmd)
									end
									if imgui.BeginPopupModal(fa.TRIANGLE_EXCLAMATION .. u8' Предупреждение ##' .. command.cmd, _, imgui.WindowFlags.NoResize ) then
										change_dpi()
										imgui.CenterText(u8'Вы действительно хотите удалить команду /' .. u8(command.cmd) .. '?')
										imgui.Separator()
										if imgui.Button(fa.CIRCLE_XMARK .. u8' Нет, отменить', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
											imgui.CloseCurrentPopup()
										end
										imgui.SameLine()
										if imgui.Button(fa.TRASH_CAN .. u8' Да, удалить', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
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
						if imgui.Button(fa.CIRCLE_PLUS .. u8' Создать новую команду##new_cmd',imgui.ImVec2(imgui.GetMiddleButtonX(1), 0)) then
							local new_cmd = {cmd = '', description = 'Новая команда созданная вами', text = '', arg = '', enable = true, waiting = '1.500', bind = "{}"}
							table.insert(settings.commands, new_cmd)
							change_description = new_cmd.description
							input_description = imgui.new.char[256](u8(change_description))
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
					if imgui.BeginTabItem(fa.BARS..u8' Команды для 9-10 рангов') then 
						if tonumber(settings.player_info.fraction_rank_number) == 9 or tonumber(settings.player_info.fraction_rank_number) == 10 then
							if imgui.BeginChild('##1', imgui.ImVec2(589 * settings.general.custom_dpi, 303 * settings.general.custom_dpi), true) then
								imgui.Columns(3)
								imgui.CenterColumnText(u8"Команда")
								imgui.SetColumnWidth(-1, 170 * settings.general.custom_dpi)
								imgui.NextColumn()
								imgui.CenterColumnText(u8"Описание")
								imgui.SetColumnWidth(-1, 300 * settings.general.custom_dpi)
								imgui.NextColumn()
								imgui.CenterColumnText(u8"Действие")
								imgui.SetColumnWidth(-1, 150 * settings.general.custom_dpi)
								imgui.Columns(1)
								imgui.Separator()
								imgui.Columns(3)
								imgui.CenterColumnText(u8"/slm")
								imgui.NextColumn()
								imgui.CenterColumnText(u8"Открыть быстрое меню управления")
								imgui.NextColumn()
								imgui.CenterColumnText(u8"Недоступно")
								imgui.Columns(1)
								imgui.Separator()
								imgui.Columns(3)
								imgui.CenterColumnText(u8"/spcar")
								imgui.NextColumn()
								imgui.CenterColumnText(u8"Заспавнить т/с организации")
								imgui.NextColumn()
								imgui.CenterColumnText(u8"Недоступно")
								imgui.Columns(1)
								imgui.Separator()		
								imgui.Columns(3)
								imgui.CenterColumnText(u8"/sob")
								imgui.NextColumn()
								imgui.CenterColumnText(u8"Открыть меню собеседования")
								imgui.NextColumn()
								imgui.CenterColumnText(u8"Недоступно")
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
												imgui.SetTooltip(u8"Отключение команды /"..command.cmd)
											end
										else
											if imgui.SmallButton(fa.TOGGLE_OFF .. '##'..command.cmd) then
												command.enable = not command.enable
												save_settings()
												register_command(command.cmd, command.arg, command.text, tonumber(command.waiting))
											end
											if imgui.IsItemHovered() then
												imgui.SetTooltip(u8"Включение команды /"..command.cmd)
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
											imgui.SetTooltip(u8"Изменение команды /"..command.cmd)
										end
										imgui.SameLine()
										if imgui.SmallButton(fa.TRASH_CAN .. '##'..command.cmd) then
											imgui.OpenPopup(fa.TRIANGLE_EXCLAMATION .. u8' Предупреждение ##9-10' .. command.cmd)
										end
										if imgui.IsItemHovered() then	
											imgui.SetTooltip(u8"Удаление команды /"..command.cmd)
										end
										if imgui.BeginPopupModal(fa.TRIANGLE_EXCLAMATION .. u8' Предупреждение ##9-10' .. command.cmd, _, imgui.WindowFlags.NoResize ) then
											change_dpi()
											imgui.CenterText(u8'Вы действительно хотите удалить команду /' .. u8(command.cmd) .. '?')
											imgui.Separator()
											if imgui.Button(fa.CIRCLE_XMARK .. u8' Нет, отменить', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
												imgui.CloseCurrentPopup()
											end
											imgui.SameLine()
											if imgui.Button(fa.TRASH_CAN .. u8' Да, удалить', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
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
							if imgui.Button(fa.CIRCLE_PLUS .. u8' Создать новую команду##new_cmd_9-10', imgui.ImVec2(imgui.GetMiddleButtonX(1), 0)) then
								binder_create_command_9_10 = true
								local new_cmd = {cmd = '', description = 'Новая команда созданная вами', text = '', arg = '', enable = true, waiting = '1.500', bind = "{}" }
								table.insert(settings.commands_manage, new_cmd)
								change_description = new_cmd.description
								input_description = imgui.new.char[256](u8(change_description))
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
						else
							imgui.CenterText(fa.TRIANGLE_EXCLAMATION)
							imgui.Separator()
							imgui.CenterText(u8"У вас нет доступа к данным командам!")
							imgui.CenterText(u8"Необходимо иметь 9 или 10 ранг, у вас же "..settings.player_info.fraction_rank_number..u8" ранг!")
							imgui.Separator()
						end
						imgui.EndTabItem() 
					end
					if imgui.BeginTabItem(fa.BARS..u8' Дополнительные функции') then 
						if imgui.BeginChild('##99', imgui.ImVec2(589 * settings.general.custom_dpi, 333 * settings.general.custom_dpi), true) then
							if isMonetLoader() then
								imgui.CenterText(u8'Способ открытия быстрого меню взаимодействия с игроком:')
								if imgui.RadioButtonIntPtr(u8" Только используя команду /sm [ID игрока]", fastmenu_type, 0) then
									fastmenu_type[0] = 0
									settings.general.mobile_fastmenu_button = false
									save_settings()
									FastMenuButton[0] = false
								end
								if imgui.RadioButtonIntPtr(u8' Используя команду /sm [ID игрока] или кнопку "Взаимодействие" в левом углу экрана', fastmenu_type, 1) then
									fastmenu_type[0] = 1
									settings.general.mobile_fastmenu_button = true
									save_settings()
								end
								imgui.Separator()
								imgui.CenterText(u8'Способ приостановки отыгровки команды:')
								if imgui.RadioButtonIntPtr(u8" Только используя команду /stop", stop_type, 0) then
									stop_type[0] = 0
									settings.general.mobile_stop_button = false
									CommandStopWindow[0] = true
									save_settings()
								end
								if imgui.RadioButtonIntPtr(u8' Используя команду /stop или кнопку "Остановить" внизу экрана', stop_type, 1) then
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
											imgui.SetTooltip(u8"Отключить систему биндов")
										end
										imgui.Separator()
										imgui.CenterText(u8'Открытие главного меню хелпера (аналог /sh):')
										local width = imgui.GetWindowWidth()
										local calc = imgui.CalcTextSize(getNameKeysFrom(settings.general.bind_mainmenu))
										imgui.SetCursorPosX( width / 2 - calc.x / 2 )
										if MainMenuHotKey:ShowHotKey() then
											settings.general.bind_mainmenu = encodeJson(MainMenuHotKey:GetHotKey())
											save_settings()
										end
										imgui.Separator()
										imgui.CenterText(u8'Открытие быстрого меню взаимодействия с игроком (аналог /sm):')
										imgui.CenterText(u8'Навестись на игрока через ПКМ и нажать')
										local width = imgui.GetWindowWidth()
										local calc = imgui.CalcTextSize(getNameKeysFrom(settings.general.bind_fastmenu))
										imgui.SetCursorPosX(width / 2 - calc.x / 2)
										if FastMenuHotKey:ShowHotKey() then
											settings.general.bind_fastmenu = encodeJson(FastMenuHotKey:GetHotKey())
											save_settings()
										end
										imgui.Separator()
										imgui.CenterText(u8'Открытие быстрого меню управления игроком (аналог /slm):')
										imgui.CenterText(u8'Навестись на игрока через ПКМ и нажать')
										local width = imgui.GetWindowWidth()
										local calc = imgui.CalcTextSize(getNameKeysFrom(settings.general.bind_leader_fastmenu))
										imgui.SetCursorPosX(width / 2 - calc.x / 2)
										if LeaderFastMenuHotKey:ShowHotKey() then
											settings.general.bind_leader_fastmenu = encodeJson(LeaderFastMenuHotKey:GetHotKey())
											save_settings()
										end
										
										imgui.Separator()
										imgui.CenterText(u8'Приостановить отыгровку команды (аналог /stop):')
										local width = imgui.GetWindowWidth()
										local calc = imgui.CalcTextSize(getNameKeysFrom(settings.general.bind_command_stop))
										imgui.SetCursorPosX(width / 2 - calc.x / 2)
										if CommandStopHotKey:ShowHotKey() then
											settings.general.bind_command_stop = encodeJson(CommandStopHotKey:GetHotKey())
											save_settings()
										end
										imgui.Separator()
										imgui.CenterText(u8'Так-же доступны хоткеи под каждую RP команду в предыдущих вкладках')
									else
										if imgui.SmallButton(fa.TOGGLE_OFF .. '##enable_binds') then
											settings.general.use_binds = not settings.general.use_binds
											save_settings()
										end
										if imgui.IsItemHovered() then
											imgui.SetTooltip(u8"Включить систему биндов")
										end
										imgui.CenterButton(u8'Система Хоткеев (биндов) отключена!')
									end
								else
									imgui.SameLine()
									imgui.SmallButton(fa.TOGGLE_OFF .. '##enable_binds')
									imgui.CenterText(fa.TRIANGLE_EXCLAMATION .. u8' Ошибка: отсуствуют файлы библиотеки!')
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
			if imgui.BeginTabItem(fa.MONEY_CHECK_DOLLAR..u8' Ценовая политика') then 
				local input_prices = {
					avto = { imgui.new.char[256](u8(settings.price.avto1) or 0), imgui.new.char[256](u8(settings.price.avto2) or 0), imgui.new.char[256](u8(settings.price.avto3) or 0) },
					moto = { imgui.new.char[256](u8(settings.price.moto1) or 0), imgui.new.char[256](u8(settings.price.moto2) or 0), imgui.new.char[256](u8(settings.price.moto3) or 0) },
					fish = { imgui.new.char[256](u8(settings.price.fish1) or 0), imgui.new.char[256](u8(settings.price.fish2) or 0), imgui.new.char[256](u8(settings.price.fish3) or 0) },
					swim = { imgui.new.char[256](u8(settings.price.swim1) or 0), imgui.new.char[256](u8(settings.price.swim2) or 0), imgui.new.char[256](u8(settings.price.swim3) or 0) },
					gun = { imgui.new.char[256](u8(settings.price.gun1) or 0), imgui.new.char[256](u8(settings.price.gun2) or 0), imgui.new.char[256](u8(settings.price.gun3) or 0) },
					hunt = { imgui.new.char[256](u8(settings.price.hunt1) or 0), imgui.new.char[256](u8(settings.price.hunt2) or 0), imgui.new.char[256](u8(settings.price.hunt3) or 0) },
					klad = { imgui.new.char[256](u8(settings.price.klad1) or 0), imgui.new.char[256](u8(settings.price.klad2) or 0), imgui.new.char[256](u8(settings.price.klad3) or 0) },
					taxi = { imgui.new.char[256](u8(settings.price.taxi1) or 0), imgui.new.char[256](u8(settings.price.taxi2) or 0), imgui.new.char[256](u8(settings.price.taxi3) or 0) },
					mexa = { imgui.new.char[256](u8(settings.price.mexa1) or 0), imgui.new.char[256](u8(settings.price.mexa2) or 0), imgui.new.char[256](u8(settings.price.mexa3) or 0) },
					fly = { imgui.new.char[256](u8(settings.price.fly1) or 0), imgui.new.char[256](u8(settings.price.fly2) or 0), imgui.new.char[256](u8(settings.price.fly3) or 0) }
				}
				local license_types = {
					{ name = 'Авто', key = 'avto' },
					{ name = 'Мото', key = 'moto' },
					{ name = 'Лодки', key = 'swim' },
					{ name = 'Полеты', key = 'fly' },
					{ name = 'Оружие', key = 'gun' },
					{ name = 'Охота', key = 'hunt' },
					{ name = 'Рыбалка', key = 'fish' },
					{ name = 'Раскопки', key = 'klad' },
					{ name = 'Такси', key = 'taxi' },
					{ name = 'Механик', key = 'mexa' },
				}
				for _, license in ipairs(license_types) do
					for month = 1, 3 do
						imgui.PushItemWidth(65 * settings.general.custom_dpi)
						if imgui.InputText(u8(string.format('  %s (%d месяц%s)', license.name, month, month == 1 and '' or 'а')), input_prices[license.key][month], 9) then
							settings.price[license.key .. month] = u8:decode(ffi.string(input_prices[license.key][month]))
							save_settings()
						end
						if month == 1 then
							imgui.SameLine()
							imgui.SetCursorPosX(200*settings.general.custom_dpi)
						elseif month == 2 then
							imgui.SameLine()
							imgui.SetCursorPosX(400*settings.general.custom_dpi)
						else
							imgui.Separator()
						end
					end
				end
			imgui.EndTabItem()
			end
			if imgui.BeginTabItem(fa.FILE_PEN..u8' Заметки') then 
			 	imgui.BeginChild('##1', imgui.ImVec2(589 * settings.general.custom_dpi, 330 * settings.general.custom_dpi), true)
				imgui.Columns(2)
				imgui.CenterColumnText(u8"Список всех ваших заметок/шпаргалок:")
				imgui.SetColumnWidth(-1, 495 * settings.general.custom_dpi)
				imgui.NextColumn()
				imgui.CenterColumnText(u8"Действие")
				imgui.SetColumnWidth(-1, 150 * settings.general.custom_dpi)
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
							imgui.SetTooltip(u8'Открыть заметку "' .. u8(note.note_name) .. '"')
						end
						imgui.SameLine()
						if imgui.SmallButton(fa.PEN_TO_SQUARE .. '##' .. i) then
							local note_text = note.note_text:gsub('&','\n')
							input_text_note = imgui.new.char[16384](u8(note_text))
							input_name_note = imgui.new.char[256](u8(note.note_name))
							imgui.OpenPopup(fa.PEN_TO_SQUARE .. u8' Изменение заметки' .. '##' .. i)	
						end
						if imgui.IsItemHovered() then
							imgui.SetTooltip(u8'Редактирование заметки "' .. u8(note.note_name) .. '"')
						end
						if imgui.BeginPopupModal(fa.PEN_TO_SQUARE .. u8' Изменение заметки' .. '##' .. i, _, imgui.WindowFlags.NoCollapse  + imgui.WindowFlags.NoResize ) then
							change_dpi()
							if imgui.BeginChild('##9992', imgui.ImVec2(589 * settings.general.custom_dpi, 360 * settings.general.custom_dpi), true) then	
								imgui.PushItemWidth(578 * settings.general.custom_dpi)
								imgui.InputText(u8'##note_name', input_name_note, 256)
								imgui.InputTextMultiline("##note_text", input_text_note, 16384, imgui.ImVec2(578 * settings.general.custom_dpi, 320 * settings.general.custom_dpi))
								imgui.EndChild()
							end	
							if imgui.Button(fa.CIRCLE_XMARK .. u8' Отмена', imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
								imgui.CloseCurrentPopup()
							end
							imgui.SameLine()
							if imgui.Button(fa.FLOPPY_DISK .. u8' Сохранить заметку', imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
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
							imgui.OpenPopup(fa.TRIANGLE_EXCLAMATION .. u8' Предупреждение ##' .. note.note_name)
						end
						if imgui.IsItemHovered() then
							imgui.SetTooltip(u8'Удаление заметки "' .. u8(note.note_name) .. '"')
						end
						if imgui.BeginPopupModal(fa.TRIANGLE_EXCLAMATION .. u8' Предупреждение ##' .. note.note_name, _, imgui.WindowFlags.NoResize ) then
							change_dpi()
							imgui.CenterText(u8'Вы действительно хотите удалить заметку "' .. u8(note.note_name) .. '" ?')
							imgui.Separator()
							if imgui.Button(fa.CIRCLE_XMARK .. u8' Нет, отменить', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
								imgui.CloseCurrentPopup()
							end
							imgui.SameLine()
							if imgui.Button(fa.TRASH_CAN .. u8' Да, удалить', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
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
				if imgui.Button(fa.CIRCLE_PLUS .. u8' Создать новую заметку', imgui.ImVec2(imgui.GetMiddleButtonX(1), 0)) then
					input_name_note = imgui.new.char[256](u8("Название"))
					input_text_note = imgui.new.char[16384](u8("Текст"))
					imgui.OpenPopup(fa.PEN_TO_SQUARE .. u8' Создание заметки')	
				end
				if imgui.BeginPopupModal(fa.PEN_TO_SQUARE .. u8' Создание заметки', _, imgui.WindowFlags.NoCollapse  + imgui.WindowFlags.NoResize ) then
			
					if imgui.BeginChild('##999999', imgui.ImVec2(589 * settings.general.custom_dpi, 360 * settings.general.custom_dpi), true) then	
						imgui.PushItemWidth(578 * settings.general.custom_dpi)
						imgui.InputText(u8'##note_name', input_name_note, 256)
						imgui.InputTextMultiline("##note_text", input_text_note, 16384, imgui.ImVec2(578 * settings.general.custom_dpi, 320 * settings.general.custom_dpi))
						imgui.EndChild()
					end	
					if imgui.Button(fa.CIRCLE_XMARK .. u8' Отмена', imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
						imgui.CloseCurrentPopup()
					end
					imgui.SameLine()
					if imgui.Button(fa.FLOPPY_DISK .. u8' Создать заметку', imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
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
			if imgui.BeginTabItem(fa.GEAR..u8' Настройки') then 
				imgui.BeginChild('##1', imgui.ImVec2(589 * settings.general.custom_dpi, 145 * settings.general.custom_dpi), true)
				imgui.CenterText(fa.CIRCLE_INFO .. u8' Дополнительная информация про хелпер')
				imgui.Separator()
				imgui.Text(fa.CIRCLE_USER..u8" Разработчик данного хелпера: MTG MODS")
				imgui.Separator()
				imgui.Text(fa.CIRCLE_INFO..u8" Версия хелпера которая сейчас установлена у вас: " .. u8(thisScript().version))
				imgui.Separator()
				imgui.Text(fa.BOOK ..u8" Гайд по использованию хелпера:")
				imgui.SameLine()
				if imgui.SmallButton('https://youtu.be/AceAqZLU9Co') then
					openLink('https://youtu.be/AceAqZLU9Co')
				end
				imgui.Separator()
				imgui.Text(fa.HEADSET..u8" Тех.поддержка по хелперу:")
				imgui.SameLine()
				if imgui.SmallButton('https://discord.com/invite/qBPEYjfNhv') then
					openLink('https://discord.com/invite/qBPEYjfNhv')
				end
				imgui.Separator()
				imgui.Text(fa.GLOBE..u8" Тема хелпера на форуме BlastHack:")
				imgui.SameLine()
				if imgui.SmallButton('https://www.blast.hk/threads/195388') then
					openLink('https://www.blast.hk/threads/195388')
				end
				imgui.EndChild()
				imgui.BeginChild('##3', imgui.ImVec2(589 * settings.general.custom_dpi, 87 * settings.general.custom_dpi), true)
				imgui.CenterText(fa.PALETTE .. u8' Цветовая тема хелпера:')
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
					if imgui.RadioButtonIntPtr(u8" MoonMonet Theme | "..fa.TRIANGLE_EXCLAMATION .. u8' Ошибка: отсуствуют файлы библиотеки!', theme, 1) then
						theme[0] = 0
					end
				end
				imgui.EndChild()
				imgui.BeginChild("##2",imgui.ImVec2(589 * settings.general.custom_dpi, 80 * settings.general.custom_dpi),true)
				imgui.CenterText(fa.MAXIMIZE .. u8' Размер менюшек скрипта:')
				if settings.general.custom_dpi == slider_dpi[0] then
					
				else
					imgui.SameLine()
					if imgui.SmallButton(fa.CIRCLE_ARROW_RIGHT .. u8' Применить и сохранить') then
						settings.general.custom_dpi = slider_dpi[0]
						save_settings()
						sampAddChatMessage('[AS Helper] {ffffff}Перезагрузка скрипта для пременения размера окон...', message_color)
						reload_script = true
						thisScript():reload()
					end
				end
				imgui.PushItemWidth(578 * settings.general.custom_dpi)
				imgui.SliderFloat('##2223233333333', slider_dpi, 0.5, 3) 
				imgui.Separator()
				imgui.CenterText(u8('Если менюшки скрипта "плавают" по экрану, изменяйте размер и подберите значение'))
				imgui.EndChild()
				imgui.BeginChild("##4",imgui.ImVec2(589 * settings.general.custom_dpi, 35 * settings.general.custom_dpi),true)
				if imgui.Button(fa.POWER_OFF .. u8" Выключение ", imgui.ImVec2(imgui.GetMiddleButtonX(4), 25 * settings.general.custom_dpi)) then
					imgui.OpenPopup(fa.TRIANGLE_EXCLAMATION .. u8' Предупреждение ##off')
				end
				if imgui.BeginPopupModal(fa.TRIANGLE_EXCLAMATION .. u8' Предупреждение ##off', _, imgui.WindowFlags.NoResize ) then
					change_dpi()
					imgui.CenterText(u8'Вы действительно хотите выгрузить (отключить) хелпер?')
					imgui.Separator()
					if imgui.Button(fa.CIRCLE_XMARK .. u8' Нет, отменить', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
						imgui.CloseCurrentPopup()
					end
					imgui.SameLine()
					if imgui.Button(fa.POWER_OFF .. u8' Да, выгрузить', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
						reload_script = true
						sampAddChatMessage('[AS Helper] {ffffff}Хелпер приостановил свою работу до следущего входа в игру!', message_color)
						thisScript():unload()
					end
					imgui.End()
				end
				imgui.SameLine()
				if imgui.Button(fa.ROTATE_RIGHT .. u8" Перезагрузка ", imgui.ImVec2(imgui.GetMiddleButtonX(4), 25 * settings.general.custom_dpi)) then
					reload_script = true
					thisScript():reload()
				end
				imgui.SameLine()
				if imgui.Button(fa.CLOCK_ROTATE_LEFT .. u8" Сброс настроек ", imgui.ImVec2(imgui.GetMiddleButtonX(4), 25 * settings.general.custom_dpi)) then
					imgui.OpenPopup(fa.TRIANGLE_EXCLAMATION .. u8' Предупреждение ##reset')
				end
				if imgui.BeginPopupModal(fa.TRIANGLE_EXCLAMATION .. u8' Предупреждение ##reset', _, imgui.WindowFlags.NoResize ) then
					change_dpi()
					imgui.CenterText(u8'Вы действительно хотите сбросить все настройки хелпера?')
					imgui.Separator()
					if imgui.Button(fa.CIRCLE_XMARK .. u8' Нет, отменить', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
						imgui.CloseCurrentPopup()
					end
					imgui.SameLine()
					if imgui.Button(fa.CLOCK_ROTATE_LEFT .. u8' Да, сбросить', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
						settings = default_settings
						save_settings()
						imgui.CloseCurrentPopup()
						reload_script = true
						thisScript():reload()
					end
					imgui.End()
				end
				imgui.SameLine()
				if imgui.Button(fa.TRASH_CAN .. u8" Удаление ", imgui.ImVec2(imgui.GetMiddleButtonX(4), 25 * settings.general.custom_dpi)) then
					imgui.OpenPopup(fa.TRIANGLE_EXCLAMATION .. u8' Предупреждение ##delete')
				end
				if imgui.BeginPopupModal(fa.TRIANGLE_EXCLAMATION .. u8' Предупреждение ##delete', _, imgui.WindowFlags.NoResize ) then
					change_dpi()
					imgui.CenterText(u8'Вы действительно хотите удалить AS Helper?')
					imgui.Separator()
					if imgui.Button(fa.CIRCLE_XMARK .. u8' Нет, отменить', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
						imgui.CloseCurrentPopup()
					end
					imgui.SameLine()
					if imgui.Button(fa.TRASH_CAN .. u8' Да, я хочу удалить', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
						sampAddChatMessage('[AS Helper] {ffffff}Хелпер полностю удалён из вашего устройства!', message_color)
						sampShowDialog(999999, message_color_hex .. "AS Helper", "Мне очень жаль что вы удалили AS Helper из своего устройства.\nЕсли удаление связано с негативным опытом использования, и вы сталкивались с багами или проблемами, то\nсообщите мне что именно заставило вас удалить хелпер.\n\nDiscord: https://discord.com/invite/qBPEYjfNhv\nBlastHack: https://www.blast.hk/threads/195388/\nTelegram: https://t.me/mtgmods\n\nЕсли что, вы можете заново скачать и установить хелпер в любой момент :)", "Закрыть", '', 0)
						os.remove(getWorkingDirectory() .. "\\AS Helper.lua")
						os.remove(getWorkingDirectory() .. "\\AS Helper\\Settings.json")
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
		imgui.Begin(fa.BUILDING .. " AS Helper - " .. fa.WALKIE_TALKIE .. u8" Рация депортамента", DeportamentWindow, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize)
		change_dpi()
		imgui.BeginChild('##2', imgui.ImVec2(589 * settings.general.custom_dpi, 160 * settings.general.custom_dpi), true)
		imgui.Columns(3)
		imgui.CenterColumnText(u8('Ваш тег:'))
		imgui.PushItemWidth(215 * settings.general.custom_dpi)
		if imgui.InputText('##input_dep_tag1', input_dep_tag1, 256) then
			settings.deportament.dep_tag1 = u8:decode(ffi.string(input_dep_tag1))
			save_settings()
		end
		if imgui.CenterColumnButton(u8('Выбрать тег##1')) then
			imgui.OpenPopup(fa.TAG .. u8' Теги организаций##1')
		end
		if imgui.BeginPopupModal(fa.TAG .. u8' Теги организаций##1', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize) then
			change_dpi()
			if imgui.BeginTabBar('TabTags') then
				if imgui.BeginTabItem(fa.BARS..u8' Стандартные теги (ru) ') then 
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
					if imgui.Button(fa.CIRCLE_XMARK .. u8' Закрыть', imgui.ImVec2( imgui.GetMiddleButtonX(1), 25 * settings.general.custom_dpi)) then
						imgui.CloseCurrentPopup()
					end
				imgui.EndTabItem() end
				if imgui.BeginTabItem(fa.BARS..u8' Стандартные теги (en) ') then 
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
					if imgui.Button(fa.CIRCLE_XMARK .. u8' Закрыть', imgui.ImVec2( imgui.GetMiddleButtonX(1), 25 * settings.general.custom_dpi)) then
						imgui.CloseCurrentPopup()
					end
				imgui.EndTabItem() end
				if imgui.BeginTabItem(fa.BARS..u8' Ваши кастомные теги ') then 
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
					if imgui.Button(fa.CIRCLE_PLUS .. u8' Добавить тег', imgui.ImVec2( imgui.GetMiddleButtonX(2), 25 * settings.general.custom_dpi)) then
						imgui.OpenPopup(fa.TAG .. u8' Добавление нового тега##1')	
					end
					if imgui.BeginPopupModal(fa.TAG .. u8' Добавление нового тега##1', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize) then
						
						imgui.PushItemWidth(215 * settings.general.custom_dpi)
						imgui.InputText('##input_dep_new_tag', input_dep_new_tag, 256) 
						imgui.Separator()
						if imgui.Button(fa.CIRCLE_XMARK .. u8' Отмена', imgui.ImVec2( imgui.GetMiddleButtonX(2), 25 * settings.general.custom_dpi)) then
							imgui.CloseCurrentPopup()
						end
						imgui.SameLine()
						if imgui.Button(fa.FLOPPY_DISK .. u8' Сохранить', imgui.ImVec2( imgui.GetMiddleButtonX(2), 25 * settings.general.custom_dpi)) then
							table.insert(settings.deportament.dep_tags_custom, u8:decode(ffi.string(input_dep_new_tag)))
							save_settings()
							imgui.CloseCurrentPopup()
						end
						imgui.End()
					end
					imgui.SameLine()
					if imgui.Button(fa.CIRCLE_XMARK .. u8' Закрыть', imgui.ImVec2( imgui.GetMiddleButtonX(2), 25 * settings.general.custom_dpi)) then
						imgui.CloseCurrentPopup()
					end
				imgui.EndTabItem() end
			imgui.EndTabBar() 
			end
			imgui.End()
		end
		imgui.SetColumnWidth(-1, 230 * settings.general.custom_dpi)
		imgui.NextColumn()
		imgui.CenterColumnText(u8('Частота рации:'))
		imgui.PushItemWidth(140 * settings.general.custom_dpi)
		if imgui.InputText('##input_dep_fm', input_dep_fm, 256) then
			settings.deportament.dep_fm = u8:decode(ffi.string(input_dep_fm))
			save_settings()
		end
		if imgui.CenterColumnButton(u8('Выбрать частоту##1')) then
			imgui.OpenPopup(fa.WALKIE_TALKIE .. u8' Частота рации /d')
		end
		if imgui.BeginPopupModal(fa.WALKIE_TALKIE .. u8' Частота рации /d', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize) then
		
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
			if imgui.Button(fa.CIRCLE_XMARK .. u8' Закрыть', imgui.ImVec2( imgui.GetMiddleButtonX(1), 25 * settings.general.custom_dpi)) then
				imgui.CloseCurrentPopup()
			end
			imgui.End()
		end
		imgui.SetColumnWidth(-1, 150 * settings.general.custom_dpi)
		imgui.NextColumn()
		imgui.CenterColumnText(u8('Тег, к кому вы обращаетесь:'))
		imgui.PushItemWidth(195 * settings.general.custom_dpi)
		if imgui.InputText('##input_dep_tag2', input_dep_tag2, 256) then
			settings.deportament.dep_tag2 = u8:decode(ffi.string(input_dep_tag2))
			save_settings()
		end
		if imgui.CenterColumnButton(u8('Выбрать тег##2')) then
			imgui.OpenPopup(fa.TAG .. u8' Теги организаций##2')
		end
		if imgui.BeginPopupModal(fa.TAG .. u8' Теги организаций##2', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize) then
			change_dpi()
			if imgui.BeginTabBar('TabTags') then
				if imgui.BeginTabItem(fa.BARS..u8' Стандартные теги (ru) ') then 
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
					if imgui.Button(fa.CIRCLE_XMARK .. u8' Закрыть', imgui.ImVec2( imgui.GetMiddleButtonX(1), 25 * settings.general.custom_dpi)) then
						imgui.CloseCurrentPopup()
					end
				imgui.EndTabItem() end
				if imgui.BeginTabItem(fa.BARS..u8' Стандартные теги (en) ') then 
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
					if imgui.Button(fa.CIRCLE_XMARK .. u8' Закрыть', imgui.ImVec2( imgui.GetMiddleButtonX(1), 25 * settings.general.custom_dpi)) then
						imgui.CloseCurrentPopup()
					end
				imgui.EndTabItem() end
				if imgui.BeginTabItem(fa.BARS..u8' Ваши кастомные теги ') then 
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
					if imgui.Button(fa.CIRCLE_PLUS .. u8' Добавить тег', imgui.ImVec2( imgui.GetMiddleButtonX(2), 25 * settings.general.custom_dpi)) then
						imgui.OpenPopup(fa.TAG .. u8' Добавление нового тега##2')	
					end
					if imgui.BeginPopupModal(fa.TAG .. u8' Добавление нового тега##2', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize) then
				
						imgui.PushItemWidth(215 * settings.general.custom_dpi)
						imgui.InputText('##input_dep_new_tag', input_dep_new_tag, 256) 
						imgui.Separator()
						if imgui.Button(fa.CIRCLE_XMARK .. u8' Отмена', imgui.ImVec2( imgui.GetMiddleButtonX(2), 25 * settings.general.custom_dpi)) then
							imgui.CloseCurrentPopup()
						end
						imgui.SameLine()
						if imgui.Button(fa.FLOPPY_DISK .. u8' Сохранить', imgui.ImVec2( imgui.GetMiddleButtonX(2), 25 * settings.general.custom_dpi)) then
							table.insert(settings.deportament.dep_tags_custom, u8:decode(ffi.string(input_dep_new_tag)))
							save_settings()
							imgui.CloseCurrentPopup()
						end
						imgui.End()
					end
					imgui.SameLine()
					if imgui.Button(fa.CIRCLE_XMARK .. u8' Закрыть', imgui.ImVec2( imgui.GetMiddleButtonX(2), 25 * settings.general.custom_dpi)) then
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
		imgui.CenterText(u8('Текст:'))
		imgui.PushItemWidth(490 * settings.general.custom_dpi)
		imgui.InputText(u8'##dep_input_text', input_dep_text, 256)
		imgui.SameLine()
		if imgui.Button(u8' Отправить ') then
			sampSendChat('/d ' .. u8:decode(ffi.string(input_dep_tag1)) .. ' ' .. u8:decode(ffi.string(input_dep_fm)) .. ' ' ..  u8:decode(ffi.string(input_dep_tag2)) .. ': '  .. u8:decode(ffi.string(input_dep_text)))
		end
		imgui.Separator()
		imgui.CenterText(u8'Предпросмотр: /d ' .. u8(u8:decode(ffi.string(input_dep_tag1))) .. ' ' .. u8(u8:decode(ffi.string(input_dep_fm))) .. ' ' ..  u8(u8:decode(ffi.string(input_dep_tag2))) .. ': '  .. u8(u8:decode(ffi.string(input_dep_text))) )
		imgui.EndChild()
		imgui.End()
    end
)

imgui.OnFrame(
    function() return BinderWindow[0] end,
    function(player)
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(600 * settings.general.custom_dpi, 425	* settings.general.custom_dpi), imgui.Cond.FirstUseEver)
		imgui.Begin(fa.PEN_TO_SQUARE .. u8' Редактирование команды /' .. change_cmd, BinderWindow, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize  )
		change_dpi()
		if imgui.BeginChild('##binder_edit', imgui.ImVec2(589 * settings.general.custom_dpi, 361 * settings.general.custom_dpi), true) then
			imgui.CenterText(fa.FILE_LINES .. u8' Описание команды:')
			imgui.PushItemWidth(579 * settings.general.custom_dpi)
			imgui.InputText("##input_description", input_description, 256)
			imgui.Separator()
			imgui.CenterText(fa.TERMINAL .. u8' Команда для использования в чате (без /):')
			imgui.PushItemWidth(579 * settings.general.custom_dpi)
			imgui.InputText("##input_cmd", input_cmd, 256)
			imgui.Separator()
			imgui.CenterText(fa.CODE .. u8' Аргументы которые принимает команда:')
	    	imgui.Combo(u8'',ComboTags, ImItems, #item_list)
	 	    imgui.Separator()
	        imgui.CenterText(fa.FILE_WORD .. u8' Текстовый бинд команды:')
			imgui.InputTextMultiline("##text_multiple", input_text, 8192, imgui.ImVec2(579 * settings.general.custom_dpi, 173 * settings.general.custom_dpi))
		imgui.EndChild() end
		if imgui.Button(fa.CIRCLE_XMARK .. u8' Отмена', imgui.ImVec2(imgui.GetMiddleButtonX(5), 0)) then
			BinderWindow[0] = false
		end
		imgui.SameLine()
		if imgui.Button(fa.CLOCK .. u8' Задержка',imgui.ImVec2(imgui.GetMiddleButtonX(5), 0)) then
			imgui.OpenPopup(fa.CLOCK .. u8' Задержка (в секундах) ')
		end
		if imgui.BeginPopupModal(fa.CLOCK .. u8' Задержка (в секундах) ', _, imgui.WindowFlags.NoResize ) then
			imgui.PushItemWidth(200 * settings.general.custom_dpi)
			imgui.SliderFloat(u8'##waiting', waiting_slider, 0.3, 10)
			imgui.Separator()
			if imgui.Button(fa.CIRCLE_XMARK .. u8' Отмена', imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
				waiting_slider = imgui.new.float(tonumber(change_waiting))	
				imgui.CloseCurrentPopup()
			end
			imgui.SameLine()
			if imgui.Button(fa.FLOPPY_DISK .. u8' Сохранить', imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
				imgui.CloseCurrentPopup()
			end
			imgui.End()
		end
		imgui.SameLine()
		if imgui.Button(fa.TAGS .. u8' Теги', imgui.ImVec2(imgui.GetMiddleButtonX(5), 0)) then
			imgui.OpenPopup(fa.TAGS .. u8' Теги для использования в биндере')
		end
		if imgui.BeginPopupModal(fa.TAGS .. u8' Теги для использования в биндере', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize  + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.AlwaysAutoResize ) then
			imgui.Text(u8(binder_tags_text))
			imgui.Separator()
			if imgui.Button(fa.CIRCLE_XMARK .. u8' Закрыть', imgui.ImVec2(imgui.GetMiddleButtonX(1), 0)) then
				imgui.CloseCurrentPopup()
			end
			imgui.End()
		end
		imgui.SameLine()
		if imgui.Button(fa.KEYBOARD .. u8' Бинд (для ПК)', imgui.ImVec2(imgui.GetMiddleButtonX(5), 0)) then
			if isMonetLoader() then
				sampAddChatMessage('[AS Helper] {ffffff}Данная функция доступа только на ПК!', message_color)
			else
				if hotkey_no_errors then
					if ComboTags[0] == 0 then
						if settings.general.use_binds then 
							imgui.OpenPopup(fa.KEYBOARD .. u8' Бинд для команды /' .. change_cmd)
						else
							sampAddChatMessage('[AS Helper] {ffffff}Сначало включите рабоспособность хоткеев в Команды и отыгровки - Доп. функии', message_color)
						end
					else
						sampAddChatMessage('[AS Helper] {ffffff}Данная функция доступа только если команда "Без аргументов"', message_color)
					end
				else
					sampAddChatMessage('[AS Helper] {ffffff}Данная функция недоступа, причина отсуствуют файлы библиотеки mimgui_hotkeys!', message_color)
				end
			end
		end
		if imgui.BeginPopupModal(fa.KEYBOARD .. u8' Бинд для команды /' .. change_cmd, _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize  + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.AlwaysAutoResize) then
			local hotkeyObject = hotkeys[change_cmd .. "HotKey"]
			if hotkeyObject then
				imgui.CenterText(u8('Клавиша активации бинда:'))
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
					sampAddChatMessage('[AS Helper] {ffffff}Создан хоткей для команды ' .. message_color_hex .. '/' .. change_cmd .. ' {ffffff}на клавишу '  .. message_color_hex .. getNameKeysFrom(change_bind), message_color)
				end
			else
				local hotkeyName = change_cmd.. "HotKey"
				hotkeys[hotkeyName] = hotkey.RegisterHotKey(hotkeyName, false, decodeJson(change_bind), function()
					if sampIsChatInputActive() or sampIsDialogActive() or isSampfuncsConsoleActive() then
					
					else
						sampProcessChatInput('/' .. change_cmd)
					end
				end)
				--sampAddChatMessage('[AS Helper] {ffffff}Создан новый хоткей, необходимо пересоздать интерфейс. Откройте заново эту менюшку', message_color)
				--imgui.CloseCurrentPopup()
			end
			imgui.Separator()
			if imgui.Button(fa.CIRCLE_XMARK .. u8' Закрыть', imgui.ImVec2(300 * settings.general.custom_dpi, 30 * settings.general.custom_dpi)) then
				imgui.CloseCurrentPopup()
			end
			imgui.End()
		end
		imgui.SameLine()
		if imgui.Button(fa.FLOPPY_DISK .. u8' Сохранить', imgui.ImVec2(imgui.GetMiddleButtonX(5), 0)) then	
			if ffi.string(input_cmd):find('%W') or ffi.string(input_cmd) == '' or ffi.string(input_description) == '' or ffi.string(input_text) == '' then
				imgui.OpenPopup(fa.TRIANGLE_EXCLAMATION .. u8' Ошибка сохранения команды!')
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
				local new_bind = change_bind
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
						command.bind = new_bind
						command.description = new_description
						command.text = new_text
						command.waiting = new_waiting
						command.deleted = false
						command.enable = true
						checker = true
						save_settings()
						if command.arg == '' then
							sampAddChatMessage('[AS Helper] {ffffff}Команда ' .. message_color_hex .. '/' .. new_command .. ' {ffffff}успешно сохранена!', message_color)
						elseif command.arg == '{arg}' then
							sampAddChatMessage('[AS Helper] {ffffff}Команда ' .. message_color_hex .. '/' .. new_command .. ' [аргумент] {ffffff}успешно сохранена!', message_color)
						elseif command.arg == '{arg_id}' then
							sampAddChatMessage('[AS Helper] {ffffff}Команда ' .. message_color_hex .. '/' .. new_command .. ' [ID игрока] {ffffff}успешно сохранена!', message_color)
						elseif command.arg == '{arg_id} {arg2}' then
							sampAddChatMessage('[AS Helper] {ffffff}Команда ' .. message_color_hex .. '/' .. new_command .. ' [ID игрока] [аргумент] {ffffff}успешно сохранена!', message_color)
						elseif command.arg == '{arg_id} {arg2} {arg3}' then
							sampAddChatMessage('[AS Helper] {ffffff}Команда ' .. message_color_hex .. '/' .. new_command .. ' [ID игрока] [аргумент] [аргумент] {ffffff}успешно сохранена!', message_color)
						end
						sampUnregisterChatCommand(change_cmd)
						register_command(command.cmd, command.arg, command.text, tonumber(command.waiting))
						break
					end
				end
				if not checker then
					sampAddChatMessage('[AS Helper] {ffffff}ОШИБКА #787 ПРИ СОХРАНЕНИИ КОМАНДЫ ' .. message_color_hex .. '/' .. new_command .. ' {ffffff}!', message_color)
				end
				BinderWindow[0] = false
			end
		end
		if imgui.BeginPopupModal(fa.TRIANGLE_EXCLAMATION .. u8' Ошибка сохранения команды!', _, imgui.WindowFlags.AlwaysAutoResize ) then
			if ffi.string(input_cmd):find('%W') then
				imgui.BulletText(u8" В команде можно использовать только англ. буквы и/или цифры!")
			elseif ffi.string(input_cmd) == '' then
				imgui.BulletText(u8" Команда не может быть пустая!")
			end
			if ffi.string(input_description) == '' then
				imgui.BulletText(u8" Описание команды не может быть пустое!")
			end
			if ffi.string(input_text) == '' then
				imgui.BulletText(u8" Бинд команды не может быть пустой!")
			end
			imgui.Separator()
			if imgui.Button(fa.CIRCLE_XMARK .. u8' Закрыть', imgui.ImVec2(300 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
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
		imgui.Begin(fa.BUILDING_SHIELD .. " " ..  u8(members_fraction) .. " - " .. #members .. u8' сотрудников онлайн', MembersWindow, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize )
		change_dpi()
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
		change_dpi()
		imgui.Text(show_note_text:gsub('&','\n'))
		imgui.Separator()
		if imgui.Button(fa.CIRCLE_XMARK .. u8' Закрыть', imgui.ImVec2(imgui.GetMiddleButtonX(1), 25 * settings.general.custom_dpi)) then
			NoteWindow[0] = false
		end
		imgui.End()
    end
)

imgui.OnFrame(
    function() return FastMenu[0] end,
    function(player)
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		--imgui.SetNextWindowSize(imgui.ImVec2(290 * settings.general.custom_dpi, 415 * settings.general.custom_dpi), imgui.Cond.FirstUseEver)
		imgui.Begin(fa.USER_INJURED..' '..sampGetPlayerNickname(player_id)..' ['..player_id..']##FastMenu', FastMenu, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize )
		change_dpi()
		for _, command in ipairs(settings.commands) do
			if command.enable and command.arg == '{arg_id}' and not command.text:find('/godeath') and not command.text:find('/unstuff')  then
				if imgui.Button(u8(command.description), imgui.ImVec2(290 * settings.general.custom_dpi, 30 * settings.general.custom_dpi)) then
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
		change_dpi()
		for _, command in ipairs(settings.commands_manage) do
			if command.enable and command.arg == '{arg_id}' then
				if imgui.Button(u8(command.description), imgui.ImVec2(290 * settings.general.custom_dpi, 30 * settings.general.custom_dpi)) then
					sampProcessChatInput("/" .. command.cmd .. " " .. player_id)
					LeaderFastMenu[0] = false
				end
			end
		end
		if not isMonetLoader() then
			if imgui.Button(u8"Выдать выговор",imgui.ImVec2(290 * settings.general.custom_dpi, 30 * settings.general.custom_dpi)) then
				sampSetChatInputEnabled(true)
				sampSetChatInputText('/vig '..player_id..' ')
				LeaderFastMenu[0] = false
			end
			if imgui.Button(u8"Уволить из организации",imgui.ImVec2(290 * settings.general.custom_dpi, 30 * settings.general.custom_dpi)) then
				sampSetChatInputEnabled(true)
				sampSetChatInputText('/unv '..player_id..' ')
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
		imgui.Begin(fa.BUILDING.." AS Helper##rank", GiveRankMenu, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize  + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.AlwaysAutoResize)
		change_dpi()
		imgui.CenterText(u8'Выберите ранг для '.. sampGetPlayerNickname(player_id) .. ':')
		imgui.PushItemWidth(250 * settings.general.custom_dpi)
		imgui.SliderInt('', giverank, 1, 9)
		imgui.Separator()
		if imgui.Button(fa.USER..u8" Выдать ранг" , imgui.ImVec2(imgui.GetMiddleButtonX(1), 0)) then
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
							sampAddChatMessage('[AS Helper] {ffffff}Чтобы остановить отыгровку команды используйте ' .. message_color_hex .. '/stop {ffffff}или нажмите кнопку внизу экрана', message_color)
							CommandStopWindow[0] = true
						elseif not isMonetLoader() and hotkey_no_errors and settings.general.bind_command_stop and settings.general.use_binds then
							sampAddChatMessage('[AS Helper] {ffffff}Чтобы остановить отыгровку команды используйте ' .. message_color_hex .. '/stop {ffffff}или нажмите ' .. message_color_hex .. getNameKeysFrom(settings.general.bind_command_stop), message_color)
						else
							sampAddChatMessage('[AS Helper] {ffffff}Чтобы остановить отыгровку команды используйте ' .. message_color_hex .. '/stop', message_color)
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
								sampAddChatMessage('[AS Helper] {ffffff}Отыгровка команды /' .. command.cmd .. " успешно остановлена!", message_color) 
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
								if debug_mode then sampAddChatMessage('[AS Helper DEBUG] Отправляю сообщение: ' .. line, message_color) end
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
				sampAddChatMessage('[AS Helper] {ffffff}Бинд для изменения ранга отсутствует либо отключён!', message_color)
				sampAddChatMessage('[AS Helper] {ffffff}Попробуйте сбросить настройки хелпера!', message_color)
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
		imgui.Begin(fa.BUILDING.." AS Helper##fast_menu_button", FastMenuButton, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize  + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoTitleBar  )
		change_dpi()
		if imgui.Button(fa.IMAGE_PORTRAIT..u8' Взаимодействие ') then
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
    function() return CommandStopWindow[0] end,
    function(player)
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY - 50 * settings.general.custom_dpi), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.Begin(fa.BUILDING.." AS Helper##CommandStopWindow", _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize  + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.AlwaysAutoResize )
		change_dpi()
		if isMonetLoader() and isActiveCommand then
			if imgui.Button(fa.CIRCLE_STOP..u8' Остановить отыгровку ') then
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
		imgui.Begin(fa.BUILDING.." AS Helper##CommandPauseWindow", _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize  + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.AlwaysAutoResize )
		change_dpi()
		if command_pause then
			if imgui.Button(fa.CIRCLE_ARROW_RIGHT .. u8' Продолжить ', imgui.ImVec2(150 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
				command_pause = false
				CommandPauseWindow[0] = false
			end
			imgui.SameLine()
			if imgui.Button(fa.CIRCLE_XMARK .. u8' Полный STOP ', imgui.ImVec2(150 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
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
		imgui.Begin(fa.BUILDING..u8" Выберите игрока##fast_menu_players", FastMenuPlayers, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize  )
		change_dpi()
		if tonumber(#get_players()) == 0 then
			show_fast_menu(get_players()[1])
			FastMenuPlayers[0] = false
		elseif tonumber(#get_players()) >= 1 then
			for _, playerId in ipairs(get_players()) do
				local id = tonumber(playerId)
				if imgui.Button(sampGetPlayerNickname(id), imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
					if tonumber(#get_players()) ~= 0 then show_fast_menu(id) end
					FastMenuPlayers[0] = false
				end
			end
		end
		imgui.End()
    end
)

imgui.OnFrame(
    function() return InformationWindow[0] end,
    function(player)
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.Begin(fa.BUILDING .. u8" AS Helper - Оповещение##info_menu", _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize  + imgui.WindowFlags.AlwaysAutoResize  )
		change_dpi()
		imgui.CenterText(u8'Вы установили версию ' .. u8(tostring(thisScript().version)) .. u8' вместо прошлой версии ' .. u8(tostring(settings.general.version)) .. ".")
		imgui.CenterText(u8'Необходимо сбросить все настройки хелпера, дабы иметь весь актуальный функционал!')
		imgui.CenterText(u8'Если не сбросить настройки, у вас могут возникнуть разные непредвиденные ошибки и баги!')
		imgui.Separator()
		imgui.CenterText('P.S.')
		imgui.Text(u8'При сбросе настроек пропадут все команды и отыгровки которые были добавлены лично вами!')
		imgui.Text(u8'Вы можете временно отказаться от сброса, и скопировать все ваши отыгровки в надёжное место.')
		imgui.Separator()
		if imgui.Button(fa.CIRCLE_XMARK .. u8' Не сбрасывать ',  imgui.ImVec2(imgui.GetMiddleButtonX(2), 25 * settings.general.custom_dpi)) then
			InformationWindow[0] = false
		end
		imgui.SameLine()
		if imgui.Button(fa.CIRCLE_RIGHT..u8' Сбросить настройки ',  imgui.ImVec2(imgui.GetMiddleButtonX(2), 25 * settings.general.custom_dpi)) then
			settings = default_settings
			save_settings()
			sampAddChatMessage('[AS Helper] {ffffff}Настройки хелпера успешно сброшены! Перезагрузка...', message_color)
			reload_script = true
			thisScript():reload()
		end
		imgui.End()
    end
)

imgui.OnFrame(
    function() return SobesMenu[0] end,
    function(player)
		if player_id ~= nil and isParamSampID(player_id) then
			imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
			imgui.Begin(fa.PERSON_CIRCLE_CHECK..u8' Проведение собеседования игроку ' .. sampGetPlayerNickname(player_id), SobesMenu, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize)
			change_dpi()
			if imgui.BeginChild('sobes1', imgui.ImVec2(240 * settings.general.custom_dpi, 182 * settings.general.custom_dpi), true) then
				imgui.CenterColumnText(fa.BOOKMARK .. u8" Основное")
				imgui.Separator()
				if imgui.Button(fa.PLAY .. u8" Начать собеседование", imgui.ImVec2(-1, 25 * settings.general.custom_dpi)) then
					lua_thread.create(function()
						sampSendChat("Здравствуйте, я " .. settings.player_info.name_surname .. " - " .. settings.player_info.fraction_rank .. ' ' .. settings.player_info.fraction_tag)
						wait(2000)
						sampSendChat("Вы пришли к нам на собеседование?")
					end)
				end
				if imgui.Button(fa.PASSPORT .. u8" Попросить документы", imgui.ImVec2(-1, 25 * settings.general.custom_dpi)) then
					lua_thread.create(function()
						sampSendChat("Хорошо, предоставьте мне все ваши документы для проверки.")
						wait(2000)
						sampSendChat("Мне нужен ваш Паспорт, Мед.карта и Лицензии.")
						wait(2000)
						sampSendChat("/n " .. sampGetPlayerNickname(player_id) .. ", используйте /showpass [ID] , /showmc [ID] , /showlic [ID]")
						wait(2000)
						sampSendChat("/n Обязательно с RP отыгровками!")
					end)
				end
				if imgui.Button(fa.USER .. u8" Расскажите о себе", imgui.ImVec2(-1, 25 * settings.general.custom_dpi)) then
					sampSendChat("Немного расскажите о себе.")
				end
				
				if imgui.Button(fa.CHECK .. u8" Собеседование пройдено", imgui.ImVec2(-1, 25 * settings.general.custom_dpi)) then
					sampSendChat("/todo Поздравляю! Вы успешно прошли собеседование!*улыбаясь")
				end
				if imgui.Button(fa.USER_PLUS .. u8" Пригласить в организацию", imgui.ImVec2(-1, 25 * settings.general.custom_dpi)) then
					find_and_use_command('/invite {arg_id}', player_id)
					SobesMenu[0] = false
				end
				imgui.EndChild()
			end
			imgui.SameLine()
			if imgui.BeginChild('sobes2', imgui.ImVec2(240 * settings.general.custom_dpi, 182 * settings.general.custom_dpi), true) then
				imgui.CenterColumnText(fa.BOOKMARK..u8" Дополнительно")
				imgui.Separator()
				if imgui.Button(fa.GLOBE .. u8" Наличие спец.рации Discord", imgui.ImVec2(-1, 25 * settings.general.custom_dpi)) then
					sampSendChat("Имеется ли у Вас спец. рация Discord?")
				end
				if imgui.Button(fa.CIRCLE_QUESTION .. u8" Наличие опыта работы", imgui.ImVec2(-1, 25 * settings.general.custom_dpi)) then
					sampSendChat("Имеется ли у Вас опыт работы в нашей сфере?")
				end
				if imgui.Button(fa.CIRCLE_QUESTION .. u8" Почему именно мы?", imgui.ImVec2(-1, 25 * settings.general.custom_dpi)) then
					sampSendChat("Скажите почему Вы выбрали именно нас?")
				end
				if imgui.Button(fa.CIRCLE_QUESTION .. u8" Что такое адекватность?", imgui.ImVec2(-1, 25 * settings.general.custom_dpi)) then
					sampSendChat("Скажите что по вашему значит \"Адекватность\"?")
				end
				if imgui.Button(fa.CIRCLE_QUESTION .. u8" Что такое ДМ?", imgui.ImVec2(-1, 25 * settings.general.custom_dpi)) then
					sampSendChat("Скажите как вы думаете, что такое \"ДМ\"?")
				end
			imgui.EndChild()
			end
			imgui.SameLine()
			if imgui.BeginChild('sobes3', imgui.ImVec2(150 * settings.general.custom_dpi, -1), true) then
				imgui.CenterColumnText(fa.CIRCLE_XMARK .. u8" Отказы")
				imgui.Separator()
				if imgui.Selectable(u8"Нету паспорта") then
					lua_thread.create(function ()
						SobesMenu[0] = false
						sampSendChat("/todo К сожалению, вы нам не подходите*с разочарованием на лице")
						wait(2000)
						sampSendChat("У вас нету паспорта.")
						wait(2000)
						sampSendChat("Получите паспорт в паспортном столе на 1 этаже Мэрии.")
					end)
				end
				if imgui.Selectable(u8"Нету мед.карты") then
					lua_thread.create(function ()
						SobesMenu[0] = false
						sampSendChat("/todo К сожалению, вы нам не подходите*с разочарованием на лице")
						wait(2000)
						sampSendChat("У вас нету мед.карты, получите её в любой больнице.")
					end)
				end
				if imgui.Selectable(u8"Нету жилья") then
					lua_thread.create(function ()
						SobesMenu[0] = false
						sampSendChat("/todo К сожалению, вы нам не подходите*с разочарованием на лице")
						wait(2000)
						sampSendChat("У вас нету жилья. Найдите себе дом либо отель, затем приходите к нам!")
					end)
				end	
				if imgui.Selectable(u8"Законопослушность") then
					lua_thread.create(function ()
						SobesMenu[0] = false
						sampSendChat("/todo К сожалению, вы нам не подходите*с разочарованием на лице")
						wait(2000)
						sampSendChat("У вас плохая законопослушность.")
						wait(2000)
						sampSendChat("/n Необходимо иметь минимум 35 законопослушности!")
					end)
				end
				if imgui.Selectable(u8"Наркозависимость") then
					lua_thread.create(function ()
						SobesMenu[0] = false
						sampSendChat("/todo К сожалению, вы нам не подходите*с разочарованием на лице")
						wait(2000)
						sampSendChat("Вы наркозависимый, сначало вам необходимо вылечиться в больнице!")
					end)
				end
				if imgui.Selectable(u8"Состоит в ЧС") then
					lua_thread.create(function ()
						SobesMenu[0] = false
						sampSendChat("/todo К сожалению, вы нам не подходите*с разочарованием на лице")
						wait(2000)
						sampSendChat("Вы состоите в Чёрном Списке нашей организации!")
					end)
				end
				if imgui.Selectable(u8"Активная повестка") then
					lua_thread.create(function ()
						SobesMenu[0] = false
						sampSendChat("/todo К сожалению, вы нам не подходите*с разочарованием на лице")
						wait(2000)
						sampSendChat("У вас есть повестка, вы не можете устроиться к нам!")
						wait(2000)
						sampSendChat("Вы можете устроиться в МО, либо в больнице пройдите обследование")
					end)
				end
				if imgui.Selectable(u8"Проф.непригодность") then
					lua_thread.create(function ()
						SobesMenu[0] = false
						sampSendChat("/todo К сожалению, вы нам не подходите*с разочарованием на лице")
						wait(2000)
						sampSendChat("Вы не подходите для нашей работы по профессиональным качествам.")
					end)
				end
			end
			imgui.EndChild()
		else
			sampAddChatMessage('[AS Helper] {ffffff}Прозиошла ошибка, ID игрока недействителен!', message_color)
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
function rgba_to_hex(rgba)
    local r = bit.rshift(rgba, 24) % 256
    local g = bit.rshift(rgba, 16) % 256
    local b = bit.rshift(rgba, 8) % 256
    local a = rgba % 256
    return string.format("%02X%02X%02X", r, g, b)
end
function rgba_to_argb(rgba_color)
    -- Получаем компоненты цвета
    local r = bit32.band(bit32.rshift(rgba_color, 24), 0xFF)
    local g = bit32.band(bit32.rshift(rgba_color, 16), 0xFF)
    local b = bit32.band(bit32.rshift(rgba_color, 8), 0xFF)
    local a = bit32.band(rgba_color, 0xFF)
    
    -- Собираем ARGB цвет
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


function main()

	if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(0) end 

	welcome_message()
	if not isMonetLoader() then loadHotkeys() end
	initialize_commands()

	if tostring(settings.general.version) ~= tostring(thisScript().version) then 
		InformationWindow[0] = true
	end

	if settings.player_info.name_surname == '' or  settings.player_info.fraction == 'Неизвестно' then
		sampAddChatMessage('[AS Helper] {ffffff}Пытаюсь получить ваш /stats поскольку остуствуют данные про вас!', message_color)
		check_stats = true
		sampSendChat('/stats')
	end
	
	while true do
		wait(0)

		if nowGun ~= getCurrentCharWeapon(PLAYER_PED) and settings.general.rp_gun then
			oldGun = nowGun
			nowGun = getCurrentCharWeapon(PLAYER_PED)
			if nowGun == 3 or oldGun == 3 then
				if oldGun == 0 then
					sampSendChat("/me " .. gunOn[nowGun] .. " " .. weapons.get_name(nowGun) .. " " .. gunPartOn[nowGun])
				elseif nowGun == 0 then
					sampSendChat("/me " .. gunOff[oldGun] .. " " .. weapons.get_name(oldGun) .. " " .. gunPartOff[oldGun])
				else
					sampSendChat("/me " .. gunOff[oldGun] .. " " .. weapons.get_name(oldGun) .. " " .. gunPartOff[oldGun] .. ", после чего " .. gunOn[nowGun] .. " " .. weapons.get_name(nowGun) .. " " .. gunPartOn[nowGun])
				end
			end
		end

		if MembersWindow[0] and not update_members_check then -- обновление мемберса в менюшке
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
			if sampGetPlayerColor(tagReplacements.my_id()) == 368966908 then
				sampAddChatMessage('[AS Helper] {ffffff}Через 5 минут будет PAYDAY. Наденьте форму чтобы не пропустить зарплату!', message_color)
				wait(1000)
			end
		end

	end

end

function onScriptTerminate(script, game_quit)
    if script == thisScript() and not game_quit and not reload_script then
		sampAddChatMessage('[AS Helper] {ffffff}Произошла неизвестная ошибка, хелпер приостановил свою работу!', message_color)
		if not isMonetLoader() then 
			sampAddChatMessage('[AS Helper] {ffffff}Используйте ' .. message_color_hex .. 'CTRL {ffffff}+ ' .. message_color_hex .. 'R {ffffff}чтобы перезапустить хелпер.', message_color)
		end
		
    end
end