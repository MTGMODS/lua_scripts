---@diagnostic disable: undefined-global, need-check-nil, lowercase-global, cast-local-type, unused-local

script_name("SMI Helper")
script_description('Cross-platform script helper for Media Center (CNN)')
script_author("MTG MODS")
script_version("3.2 Free")

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
		rp_chat = true,
		auto_uval = false,
		auto_lovlya_ads = false,
		moonmonet_theme_enable = true,
		moonmonet_theme_color = 16758272,
		mobile_fastmenu_button = true,
		mobile_stop_button = true,
		use_binds = true,
		use_ads_buttons = true,
		auto_send_old = true,
		ads_history = true,
		ads_copy_button = true,
		bind_mainmenu = '[113]',
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
	note = {
		{ note_name = 'Заметка №1', note_text = 'Вы можете указывать у себя в заметках абсолюто любую информацию!&Ваши заметки будут сохранены и доступны в любое время!', deleted = false  },
		{ note_name = 'Зарплата в организации', note_text = 'Почему ваша зп может быть меньше, чем указано:&- Если у вас нету жилья (дом/отель) то у вас будет -20 процентов зп&- Если у вас есть выговор то у вас будет -20 процентов зп&- Из-за фикса экономики (от разрабов) у вас будет -10 процентов зп&&Как повысить свою зарплату:&- Вступите в фулл семью с флагом чтобы иметь +7 процентов зп &( на 20 сервере это наша семья Martelli )&- Получите \"Военный билет\" чтобы иметь +15 процентов зп&- Купите охранника на \"зп фракции\" чтобы иметь до +25 процентов зп&- Повышайтесь на ранг повыше', deleted = false  },
		
	},
	commands = {
		{ cmd = 'zd' , description = 'Привествие игрока' , text = 'Здраствуйте {get_ru_nick({arg_id})}&Я {my_ru_nick} - {fraction_rank} {fraction_tag}&Чем я могу Вам помочь?', arg = '{arg_id}' , enable = true , waiting = '1.200', deleted = false, bind = "{}" },
		{ cmd = 'go' , description = 'Позвать игрока за собой' , text = 'Хорошо {get_ru_nick({arg_id})}, следуйте за мной.', arg = '{arg_id}' , enable = true, waiting = '1.200', deleted = false , bind = "{}"  },
	    { cmd = 'time' , description = 'Посмотреть время' ,  text = '/me взглянул{sex} на свои часы с гравировкой MTG MODS и посмотрел{sex} время&/time&/do На часах видно время {get_time}.' , arg = '' , enable = true, waiting = '1.200' , deleted = false, bind = "{}" },
		{ cmd = 'expel' , description = 'Выгнать игрока из здания' ,  text = 'Вы больше не можете здесь находиться, я выгоняю вас из здрания!&/me схватив человека ведёт к выходу из здания и закрывает за ним дверь&/expel {arg_id} Н.П.Р.' , arg = '{arg_id}' , enable = true , waiting = '1.200' , deleted = false , bind = "{}"},
	},
	commands_manage = {
		{ cmd = 'inv' , description = 'Принятие игрока в фракцию' , text = '/do В кармане формы есть связка с ключами от раздевалки.&/me достаёт из кармана один ключ из связки ключей от раздевалки&/todo Возьмите, это ключ от нашей раздевалки*передавая ключ человеку напротив&/invite {arg_id}&/r {get_ru_nick({arg_id})} - наш новый сотрудник!' , arg = '{arg_id}', enable = true, waiting = '1.200' , deleted = false , bind = "{}" },
		{ cmd = 'rp' , description = 'Выдача сотруднику /fractionrp' , text = '/fractionrp {arg_id}' , arg = '{arg_id}', enable = true, waiting = '1.200', deleted = false, bind = "{}"  },
		{ cmd = 'gr' , description = 'Повышение/понижение cотрудника' , text = '{show_rank_menu}&/me достаёт из кармана свой телефон и заходит в базу данных {fraction_tag}&/me изменяет информацию о сотруднике {get_ru_nick({arg_id})} в базе данных {fraction_tag}&/me выходит с базы данных и убирает телефон обратно в карман&/giverank {arg_id} {get_rank}&/r Сотрудник {get_ru_nick({arg_id})} получил новую должность!' , arg = '{arg_id}', enable = true, waiting = '1.200' , deleted = false, bind = "{}" },
		{ cmd = 'vize' , description = 'Управление Vice City визой сотрудника' , text = '/me достаёт из кармана свой телефон и заходит в базу данных {fraction_tag}&/me изменяет информацию о сотруднике {get_ru_nick({arg_id})} в базе данных {fraction_tag}&/me выходит с базы данных и убирает телефон обратно в карман&{lmenu_vc_vize}' , arg = '{arg_id}', enable = true, waiting = '1.200'  , deleted = false , bind = "{}"},
		{ cmd = 'cjob' , description = 'Посмотреть успешность сотрудника' , text = '/checkjobprogress {arg_id}' , arg = '{arg_id}', enable = true, waiting = '1.200' , deleted = false , bind = "{}" },	
		{ cmd = 'fmutes' , description = 'Выдать мут сотруднику (10 min)' , text = '/fmutes {arg_id} Н.П.Р.&/r Сотрудник {get_ru_nick({arg_id})} лишился права использовать рацию на 10 минут!' , arg = '{arg_id}', enable = true, waiting = '1.200' , deleted = false , bind = "{}" },
		{ cmd = 'funmute' , description = 'Снять мут сотруднику' , text = '/funmute {arg_id}&/r Сотрудник {get_ru_nick({arg_id})} теперь может пользоваться рацией!' , arg = '{arg_id}', enable = true, waiting = '1.200' , deleted = false , bind = "{}" },
		{ cmd = 'block' , description = 'Забрать доступ к редакции' , text = '/me достаёт из кармана свой телефон и заходит в базу данных {fraction_tag}&/me изменяет информацию о сотруднике {get_ru_nick({arg_id})} в базе данных {fraction_tag}&/me выходит с базы данных и убирает телефон обратно в карман&/blockredak {arg_id} {arg2}&/r Сотрудник {get_ru_nick({arg_id})} лишён права редактирования обьявлений!' , arg = '{arg_id} {arg2}', enable = true, waiting = '1.200'  , deleted = false , bind = "{}"},
        { cmd = 'unblock' , description = 'Вернуть доступ к редакции' , text = '/me достаёт из кармана свой телефон и заходит в базу данных {fraction_tag}&/me изменяет информацию о сотруднике {get_ru_nick({arg_id})} в базе данных {fraction_tag}&/me выходит с базы данных и убирает телефон обратно в карман&/unblockredak {arg_id}&/r Сотрудник {get_ru_nick({arg_id})} теперь может редактировать обяьвления!' , arg = '{arg_id}', enable = true, waiting = '1.200'  , deleted = false, bind = "{}" },
        { cmd = 'vig' , description = 'Выдача выговора cотруднику' , text = '/me достаёт из кармана свой телефон и заходит в базу данных {fraction_tag}&/me изменяет информацию о сотруднике {get_ru_nick({arg_id})} в базе данных {fraction_tag}&/me выходит с базы данных и убирает телефон обратно в карман&/fwarn {arg_id} {arg2}&/r Сотруднику {get_ru_nick({arg_id})} выдан выговор! Причина: {arg2}' , arg = '{arg_id} {arg2}', enable = true, waiting = '1.200'  , deleted = false, bind = "{}" },
		{ cmd = 'unvig' , description = 'Снятие выговора cотруднику' , text = '/me достаёт из кармана свой телефон и заходит в базу данных {fraction_tag}&/me изменяет информацию о сотруднике {get_ru_nick({arg_id})} в базе данных {fraction_tag}&/me выходит с базы данных и убирает телефон обратно в карман&/unfwarn {arg_id}&/r Сотруднику {get_ru_nick({arg_id})} был снят выговор!' , arg = '{arg_id}', enable = true, waiting = '1.200' , deleted = false , bind = "{}" },
		{ cmd = 'unv' , description = 'Увольнение игрока из фракции' , text = '/me достаёт из кармана свой телефон и заходит в базу данных {fraction_tag}&/me изменяет информацию о сотруднике {get_ru_nick({arg_id})} в базе данных {fraction_tag}&/me выходит с базы данных и убирает свой телефон обратно в карман&/uninvite {arg_id} {arg2}&/r Сотрудник {get_ru_nick({arg_id})} был уволен по причине: {arg2}' , arg = '{arg_id} {arg2}', enable = true, waiting = '1.200' , deleted = false , bind = "{}" },
		{ cmd = 'point' , description = 'Установить метку для сотрудников' , text = '/r Срочно выдвигайтесь ко мне, отправляю вам координаты...&/point' , arg = '', enable = true, waiting = '1.200', deleted = false , bind = "{}" },
		{ cmd = 'govka' , description = 'Собеседование по госс.волне' , text = '/d [{fraction_tag}] - [Всем]: Занимаю государственную волну, просьба не перебивать!&/gov [{fraction_tag}]: Доброго времени суток, уважаемые жители нашего штата!&/gov [{fraction_tag}]: Сейчас проходит собеседование в организацию {fraction}}&/gov [{fraction_tag}]: Для вступления вам нужно иметь документы, жилье, и приехать к нам в холл.&/d [{fraction_tag}] - [Всем]: Освобождаю  государственную волну, спасибо что не перебивали.' , arg = '', enable = true, waiting = '1.300', bind = "{}"  },
	},
	lives = {
		{name = 'Собеседование' , text = "/me нажимает на необходимые кнопки в аппаратуре, тем самым включает ее&/do Аппаратура включена и работает исправно.&/me проверяет на исправность аппаратуру и микрофон&/me берет наушники со столика и надевает их на свою голову&/todo Раз, раз, раз*стуча по микрофону.&/do Микрофон исправен и готов к работе.&/d [{fraction_tag}] - [СМИ]: Занимаю новостную волну.&/news •°•°•°•°• Музыкальная заставка радиостанции {fraction_tag} •°•°•°•°•&/news [Собеседование]: Доброго времени суток, уважаемые граждане Штата!&/news [Собеседование]: С Вами - Я, {fraction_rank} - {my_ru_nick}.&/news [Собеседование]: Давно мечтали изменить свою жизнь в лучшую сторону?&/news [Собеседование]: Поставить новые и не запланированные цели?&/news [Собеседование]: Спешу Вас обрадовать! Ведь именно сейчас ...&/news [Собеседование]: ... проходит собеседование в Радиоцентр {fraction_tag}!&/news [Собеседование]: Что нужно иметь для прохождения собеседования?&/news [Собеседование]: Критерии очень просты, при себе необходимо иметь: ...&/news [Собеседование]: ... Паспорт, мед. карту с отметкой Полностью здоров&/news [Собеседование]: Ведь именно у нас: Доброе и отзывчивое начальство ...&/news [Собеседование]: ... достойный карьерный рост и высокие зарплаты!&/news [Собеседование]: Заинтересовавшихся пройти собеседование ожидаем в ...&/news [Собеседование]: ... холле главного офиса {fraction_tag}.&/news [Собеседование]: А на этом наш эфир подходит к концу!&/news [Собеседование]: С Вами был - Я, {my_ru_nick}. До скорых встреч!&/news •°•°•°•°• Музыкальная заставка радиостанции {fraction_tag} •°•°•°•°•&/d [{fraction_tag}] - [СМИ]: Освобождаю новостную волну!&/me нажимает на необходимые клавиши и выходит из эфира, после чего отключает микрофон&/do Эфир окончен и микрофон отключен.&/me снимает с головы наушники и кладет их на место"},
		{name = 'Викторина "Столицы"', text = "/me нажимает на необходимые кнопки в аппаратуре, тем самым включает ее&/do Аппаратура включена и работает исправно.&/me проверяет на исправность аппаратуру и микрофон&/me берет наушники со столика и надевает их на свою голову&/todo Раз, раз, раз*стуча по микрофону.&/do Микрофон исправен и готов к работе.&/d [{fraction_tag}] - [СМИ]: Занимаю эфирную волну! Просьба не перебивать.&/news •°•°•°•° Музыкальная заставка радиостанции {fraction_tag} •°•°•°•°•&/news [Викторина]: Добрый день, уважаемые радиослушатели!&/news [Викторина]: У микрофона - {my_ru_nick}!&/news [Викторина]: Сегодня мы проведём - Столицы.&/news [Викторина]: Суть викторины такова: Я говорю вам страну, А вы мне её столицу.&/news [Викторина]: Ответы присылать на номер студии, его вы можете найти...&/news [Викторина]: ...в своём телефоне, в разделе: Контакты.&/news [Викторина]: Призовой Фонд сегодня составляет целый 1 милион долларов!&/news [Викторина]: Ну что же, давайте начинать.&/news [Викторина]: Открывает сегодняшний марафон стран поистине прекрасное государство.&/news [Викторина]: Страна, которая подарила миру необычную поп культуру. И это...&/news [Викторина]: ...Республика Корея. Или как её называют еще - Южная Корея.&{pause}&/news [Викторина]: Стоп! Наша студия получила правильный ответ.&/news [Викторина]: Правильный ответ - Сеул...&/news [Викторина]: ...густо населённый город с миллионом развлечений на любой вкус.&/news [Викторина]: Первый правильный ответ мы получили от гражданина...&{pause}&/news [Викторина]: Продолжаем. Следующее Государство известно во всём мире как страна футбола...&/news [Викторина]: ...и самбы - Бразилия.&{pause}&/news [Викторина]: Стоп!&/news [Викторина]: Как бы абсурдно это не звучало, столица страны Бразилия - Бразилиа.&/news [Викторина]: Ответов было много... Но самым быстрым оказался гражданин...&{pause}&/news [Викторина]: Большую часть следующего государства занимают трудно проходимые Джунгли...&/news [Викторина]: Я говорю о Вьетнаме.&{pause}&/news [Викторина]: На студию поступил правильный ответ!&/news [Викторина]: Столицей Вьетнама является город Ханой.&/news [Викторина]: Правильный ответ нам дал гражданин...&{pause}&/news [Викторина]: Вы, уважаемый радиослушатель, и правда не прогуливали географию в школе.&/news [Викторина]: Именно в этой стране находится действующий вулкан 'Кракатау'.&/news [Викторина]: ...Индонезия.&{pause}&/news [Викторина]: Стоп!&/news [Викторина]: И... Правильный ответ... Джакарта.&/news [Викторина]: Город контрастов, в котором переплелись разные языки и культуры...&/news [Викторина]: ...богатство и бедность.&/news [Викторина]: Уверен с этим городом знаком наш слушатель под именем...&{pause}&/news [Викторина]: Ведь именно он и дал правильный ответ!&/news [Викторина]: Густые леса, скалистые острова, горнолыжные курорты. Это всё про...&/news [Викторина]: ...страну - Финляндия.&{pause}&/news [Викторина]: Стоп! Наша студия получила правильный ответ.&/news [Викторина]: Правильным ответом является - Хельсинки! И этот ответ дал штата с именем...&{pause}&/news [Викторина]: Больше всего об этой стране знают лыжники и сноубордисты...&/news [Викторина]: ...Австрия.&/news [Викторина]: На студию поступил правильный ответ!&/news [Викторина]: Любой разговор об Австрии всегда сводится к ее столице, и не спроста.&/news [Викторина]: Ведь 'Вена' - крупнейший культурно-исторический центр Европы.&/news [Викторина]: Первым правильный ответ в студию прислал гражданин с именем...&{pause}&/news [Викторина]: И так, сейчас я озвучу победителя нашей викторины, вы готовы?&{pause}&/news [Викторина]: Просим победителя приехать к нам за наградой...&/news [Викторина]: На этом наша викторина окончена, спасибо всем вам за участие!&/news •°•°•°•°• Музыкальная заставка радиостанции {fraction_tag} •°•°•°•°•&/d [{fraction_tag}] - [СМИ]: Освобождаю эфирную волну!&/me нажимает на необходимые клавиши и выходит из эфира, после чего отключает микрофон&/do Эфир окончен и микрофон отключен.&/me снимает с головы наушники и кладет их на место"},
		{name = 'Викторина "Математика"' , text = "/me нажимает на необходимые кнопки в аппаратуре, тем самым включает ее&/do Аппаратура включена и работает исправно.&/me проверяет на исправность аппаратуру и микрофон&/me берет наушники со столика и надевает их на свою голову&/todo Раз, раз, раз*стуча по микрофону.&/do Микрофон исправен и готов к работе.&/d [{fraction_tag}] - [СМИ]: Занимаю эфирную волну.&/news •°•°•°•°• Музыкальная заставка радиостанции {fraction_tag} •°•°•°•°•&/news [Викторина]: Добрый день, уважаемые радиослушатели!&/news [Викторина]: У микрофона - {my_ru_nick}!&/news [Викторина]: Сегодня мы проведём викторину - Математика.&/news [Викторина]: Суть викторины: Я говорю вам примеры, а вы мне ответы на них.&/news [Викторина]: В примерах могут использоваться такие операторы, как...&/news [Викторина]: ...сложение +, умножение *, вычитание -, деление /.&/news [Викторина]: Ответы присылать на номер студии, его вы можете найти...&/news [Викторина]: ...в своём телефоне, в разделе: Контакты.&/news [Викторина]: Призовой Фонд сегодня составляет аж целых 500.000$!&/news [Викторина]: Ну что же, давайте начинать.&/news [Викторина]: Первый пример...&/news [Викторина]: ... '3 + 3 * 3'.&{pause}&/news [Викторина]: Стоп! На студию поступил верный ответ.&/news [Викторина]: Правильный ответ - '12'.&/news [Викторина]: Верный ответ нам дал гражданин с именем ...&{pause}&/news [Викторина]: Мы только начинаем разгоняться...&/news [Викторина]: ... '66 - 44 + 1'.&{pause}&/news [Викторина]: Стоп!&/news [Викторина]: Корректным ответом является - '23'.&/news [Викторина]: Первый правильный ответ мы получили от граждана ...&{pause}&/news [Викторина]: Следующий пример...&/news [Викторина]: ... '35 + 75'.&/news [Викторина]: И... У нас есть корректный ответ!&/news [Викторина]: И так, правильный ответ '110', и мы получили этот ответ от гражданина ...&{pause}&/news [Викторина]: Без лишних слов, следующий пример...&/news [Викторина]: ... '25 - 28 + 1'.&{pause}&/news [Викторина]: Стоп!&/news [Викторина]: Не ожидали отрицательных чисел в ответе? Правильный ответ - '-2'.&/news [Викторина]: Этот ответ нам подарил граждинин с именем ...&{pause}&/news [Викторина]: Давайте добавим разнообразия. Я загадаю пример при помощи...&/news [Викторина]: ...римских чисел. Ответ должен быть в виде римского числа!&/news [Викторина]: ... 'X - IV'.&{pause}&/news [Викторина]: Стоп! На студию поступил правильный ответ!&/news [Викторина]: Корректным ответом является - 'VI'.&/news [Викторина]: Самым быстрым был граждинин ...&{pause}&/news [Викторина]: Опять римские числа.&/news [Викторина]: ... 'XV - VIII'.&{pause}&/news [Викторина]: Стоп!&/news [Викторина]: 'VII' - верный ответ.&/news [Викторина]: Этот ответ нам подарил гражданин штата -&{pause}&/news [Викторина]: И... Последний пример с римскими числами на сегодня.&/news [Викторина]: ... 'XII - III'.&{pause}&/news [Викторина]: Стоп! Наша студия получила правильный ответ.&/news [Викторина]: Верный ответ - 'IX'. А первый ответчик - гражданин ...&{pause}&/news [Викторина]: И так, сейчас я озвучу победителя нашей викторины, вы готовы?&{pause}&/news [Викторина]: Просим победителя приехать к нам за наградой...&/news [Викторина]: На этом наша викторина окончена, спасибо всем вам за участие!/news •°•°•°•°• Музыкальная заставка радиостанции {fraction_tag} •°•°•°•°•&/d [{fraction_tag}] - [СМИ]: Освобождаю эфирную волну!&/me нажимает на необходимые клавиши и выходит из эфира, после чего отключает микрофон&/do Эфир окончен и микрофон отключен.&/me снимает с головы наушники и кладет их на место"},
		{name = 'Интервью (начало)' , text = "/me нажимает на необходимые кнопки в аппаратуре, тем самым включает ее&/do Аппаратура включена и работает исправно.&/me проверяет на исправность аппаратуру и микрофон&/me берет наушники со столика и надевает их на свою голову&/todo Раз, раз, раз*стуча по микрофону.&/do Микрофон исправен и готов к работе.&/d [{fraction_tag}] - [СМИ]: Занимаю эфирную волну.&/news •°•°•°•°• Музыкальная заставка радиостанции {fraction_tag} •°•°•°•°•&/news [Интервью]: Здравствуйте, уважаемые радиослушатели!&/news [Интервью]: У микрофона - {my_ru_nick}!&/news [Интервью]: Сегодня у нас в гостях особый гость на интервью...&/news [Интервью]: Возможно многие из вас даже знают его, и так, наш гость это ..."},
		{name= 'Интервью (конец)', text = '/news [Интервью]: И наш эфир к сожалению подходит к концу.&/news [Префикс]: С вами был Я - {my_ru_nick}.&/news [Интервью]: До свидания, штат! Не переключайтесь!&/news •°•°•°•°• Музыкальная заставка радиостанции {fraction_tag} •°•°•°•°•&/d [{fraction_tag}] - [СМИ]: Освобождаю эфирную волну!&/me нажимает на необходимые клавиши и выходит из эфира, после чего отключает микрофон&/do Эфир окончен и микрофон отключен.&/me снимает с головы наушники и кладет их на место'},
		{name = 'Прогноз погоды (утренний дождь)', text = "/me нажимает на необходимые кнопки в аппаратуре, тем самым включает ее&/do Аппаратура включена и работает исправно.&/me проверяет на исправность аппаратуру и микрофон&/me берет наушники со столика и надевает их на свою голову&/todo Раз, раз, раз*стуча по микрофону.&/do Микрофон исправен и готов к работе.&/d [{fraction_tag}] - [СМИ]: Занимаю новостную волну.&/news •°•°•°•°• Музыкальная заставка радиостанции {fraction_tag} •°•°•°•°•&/news Доброе утро, уважаемые радиослушатели!&/news У микрофона {fraction_rank} - {my_ru_nick}.&/news Сегодняшний день начался с пасмурной погоды и дождя.&/news Синоптики сообщают, что осадки продлятся до полудня, так что не забудьте взять зонт!&/news Ветер северо-западный, умеренный, но может усиливаться порывами до 15 м/c.&/news Температура воздуха +16°C, однако ощущается как +13°C.&/news Внимание водителям: дороги могут быть скользкими, соблюдайте дистанцию!&/news Ближе к обеду тучи начнут рассеиваться, а дождь прекратится.&/news А пока держитесь теплее и не забывайте наслаждаться свежестью после дождя!&/news На этом наш утренний прогноз погоды завершается.&/news С вами был {fraction_rank} - {my_ru_nick}.&/news •°•°•°•°• Музыкальная заставка радиостанции {fraction_tag} •°•°•°•°•&/d [{fraction_tag}] - [СМИ]: Освобождаю новостную волну!&/me нажимает на необходимые клавиши и выходит из эфира, после чего отключает микрофон&/do Эфир окончен и микрофон отключен.&/me снимает с головы наушники и кладет их на место"},
		{name = 'Прогноз погоды (дневной)', text = "/me нажимает на необходимые кнопки в аппаратуре, тем самым включает ее&/do Аппаратура включена и работает исправно.&/me проверяет на исправность аппаратуру и микрофон&/me берет наушники со столика и надевает их на свою голову&/todo Раз, раз, раз*стуча по микрофону.&/do Микрофон исправен и готов к работе.&/d [{fraction_tag}] - [СМИ]: Занимаю новостную волну.&/news •°•°•°•°• Музыкальная заставка радиостанции {fraction_tag} •°•°•°•°•&/news Добрый день, дорогие радиослушатели!&/news У микрофона {fraction_rank} - {my_ru_nick}.&/news Сейчас самое время узнать, какая погода ждёт нас днём.&/news Температура воздуха в данный момент составляет +22°C, солнечно, но возможна переменная облачность.&/news Ветер южный, слабый, около 5 м/с, комфортные условия для прогулок.&/news Осадков не ожидается, но к вечеру возможны лёгкие порывы ветра.&/news Если планировали провести день на свежем воздухе — отличная возможность!&/news На этом наш дневной прогноз завершается.&/news С вами был {fraction_rank} - {my_ru_nick}. До скорых встреч!&/news •°•°•°•°• Музыкальная заставка радиостанции {fraction_tag} •°•°•°•°•&/d [{fraction_tag}] - [СМИ]: Освобождаю новостную волну!&/me нажимает на необходимые клавиши и выходит из эфира, после чего отключает микрофон&/do Эфир окончен и микрофон отключен.&/me снимает с головы наушники и кладет их на место"},
		{name = 'Прогноз погоды (вечерний торнадо)', text = "/me нажимает на необходимые кнопки в аппаратуре, тем самым включает ее&/do Аппаратура включена и работает исправно.&/me проверяет на исправность аппаратуру и микрофон&/me берет наушники со столика и надевает их на свою голову&/todo Раз, раз, раз*стуча по микрофону.&/do Микрофон исправен и готов к работе.&/d [{fraction_tag}] - [СМИ]: Занимаю новостную волну.&/news •°•°•°•°• Музыкальная заставка радиостанции {fraction_tag} •°•°•°•°•&/news Добрый вечер, дорогие радиослушатели!&/news У микрофона {fraction_rank} - {my_ru_nick}.&/news И в нашем вечернем эфире речь пойдёт о прогнозе погоды.&/news Сейчас я вам зачитаю, что говорят нам наши синоптики...&/news В 21:52 предполагается песчаная буря, которая продлится всего несколько минут.&/news В связи с этим просим вас остаться дома и плотно закрыть окна и двери.&/news Также в районе Паломино Крит замечено торнадо.&/news Призываем Вас избегать поездок в этот район Штата.&/news И уже в 22:10 нас ожидает спокойная, ночная погода.&/news Но не стоит так сильно радоваться, ближе к ночи чередование спокойной погоды и песчаной бури продолжится.&/news С чем это связано - неизвестно! Но мы попытаемся уведомить Вас об изменениях как можно скорее.&/news А на этом наш эфир подходит к концу.&/news С вами был {fraction_rank} - {my_ru_nick}.&/news •°•°•°•°• Музыкальная заставка радиостанции {fraction_tag} •°•°•°•°•&/d [{fraction_tag}] - [СМИ]: Освобождаю новостную волну!&/me нажимает на необходимые клавиши и выходит из эфира, после чего отключает микрофон&/do Эфир окончен и микрофон отключен.&/me снимает с головы наушники и кладет их на место"},
	}
}
local configDirectory = getWorkingDirectory() .. "/SMI Helper"
local path = configDirectory .. "/Settings.json"
function load_settings()
    if not doesDirectoryExist(configDirectory) then
        createDirectory(configDirectory)
    end
    if not doesFileExist(path) then
        settings = default_settings
		print('[SMI Helper] Файл с настройками не найден, использую стандартные настройки!')
    else
        local file = io.open(path, 'r')
        if file then
            local contents = file:read('*a')
            file:close()
			if #contents == 0 then
				settings = default_settings
				print('[SMI Helper] Не удалось открыть файл с настройками, использую стандартные настройки!')
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
						print('[SMI Helper] Новая версия, сброс настроек!')
						settings = default_settings
						save_settings()
						reload_script = true
						thisScript():reload()
					else
						print('[SMI Helper] Настройки успешно загружены!')
					end
				else
					print('[SMI Helper] Не удалось открыть файл с настройками, использую стандартные настройки!')
				end
			end
        else
            settings = default_settings
			print('[SMI Helper] Не удалось открыть файл с настройками, использую стандартные настройки!')
        end
    end
end
function save_settings()
    local file, errstr = io.open(path, 'w')
    if file then
        local result, encoded = pcall(encodeJson, settings)
        file:write(result and encoded or "")
        file:close()
		print('[SMI Helper] Настройки сохранены!')
        return result
    else
        print('[SMI Helper] Не удалось сохранить настройки хелпера, ошибка: ', errstr)
        return false
    end
end
load_settings()
-------------------------------------------- ads_history ---------------------------------------------
local ads_history = {}
local path_ads_history = configDirectory .. "/ADS.json"
function load_ads_history()
    if not doesDirectoryExist(configDirectory) then
        createDirectory(configDirectory)
    end
    if not doesFileExist(path) then
		print('[SMI Helper] Файл с историей обьяв не найден, использую стандартные настройки!')
    else
        local file = io.open(path_ads_history, 'r')
        if file then
            local contents = file:read('*a')
            file:close()
			if #contents == 0 then
				print('[SMI Helper] Не удалось открыть файл с историей обьяв! #1')
			else
				local result, loaded = pcall(decodeJson, contents)
				if result then
					ads_history = loaded
					print('[SMI Helper] Настройки успешно загружены!')
				else
					print('[SMI Helper] Не удалось открыть файлс историей обьяв! #2')
				end
			end
        else
			print('[SMI Helper] Не удалось открыть файл с историей обьяв! #3')
        end
    end
end
function save_ads_history()
    local file, errstr = io.open(path_ads_history, 'w')
    if file then
        local result, encoded = pcall(encodeJson, ads_history)
        file:write(result and encoded or "")
        file:close()
        return result
    else
        print('[SMI Helper] Не удалось сохранить историю обьяв, ошибка: ', errstr)
        return false
    end
end
if settings.general.ads_history then load_ads_history() end
------------------------------------------- MonetLoader --------------------------------------------------
function isMonetLoader() return MONET_VERSION ~= nil end
if isMonetLoader() then
	gta = ffi.load('GTASA') 
	ffi.cdef[[ void _Z12AND_OpenLinkPKc(const char* link); ]] -- функция для открытия ссылок
end
if not settings.general.autofind_dpi then
	print('[SMI Helper] Применение авто-размера менюшек...')
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
	print('[SMI Helper] Установлено значение: ' .. settings.general.custom_dpi)
	save_settings()
end
---------------------------------------------- Mimgui -----------------------------------------------------
local imgui = require('mimgui')
local fa = require('fAwesome6_solid')
local sizeX, sizeY = getScreenResolution()

local MainWindow = imgui.new.bool()
local checkbox_accent_enable = imgui.new.bool(settings.general.accent_enable)
local checkbox_use_ads_buttons = imgui.new.bool(settings.general.use_ads_buttons)
local checkbox_ads_history = imgui.new.bool(settings.general.ads_history)
local checkbox_ads_copy_button = imgui.new.bool(settings.general.ads_copy_button)
local input_accent = imgui.new.char[256](u8(settings.player_info.accent))
local input_name_surname = imgui.new.char[256](u8(settings.player_info.name_surname))
local input_fraction_tag = imgui.new.char[256](u8(settings.player_info.fraction_tag))
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

local EditWindow = imgui.new.bool()
local input_edit_text = imgui.new.char[512]()
local input_ads = imgui.new.char[512]()
local ad_message = ''
local ad_from = ''
local ad_dialog_id = ''
local adshistory_orig = ''
local adshistory_input_text = imgui.new.char[512]()
local edit_adshistory_orig = false

local GiveRankMenu = imgui.new.bool()
local giverank = imgui.new.int(5)

local SobesMenu = imgui.new.bool()
local InformationWindow = imgui.new.bool()
local CommandStopWindow = imgui.new.bool()
local CommandPauseWindow = imgui.new.bool()

local LeaderFastMenu = imgui.new.bool()

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
local change_text = nil
local change_arg = nil
local change_bind = nil
local binder_create_command_9_10 = false
local tagReplacements = {
	my_id = function() return select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)) end,
    my_nick = function() return sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))) end,
	my_ru_nick = function() return TranslateNick(settings.player_info.name_surname) end,
	fraction_rank_number = function() return settings.player_info.fraction_rank_number end,
	fraction_rank = function() return settings.player_info.fraction_rank end,
	fraction_tag = function() return settings.player_info.fraction_tag end,
	fraction = function() return settings.player_info.fraction end,
	sex = function() 
		if settings.player_info.sex == 'Женщина' then
			local temp = 'а'
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
}
local binder_tags_text = [[
{my_id} - Ваш ID
{my_nick} - Ваш Никнейм 
{my_ru_nick} - Ваше Имя и Фамилия
{fraction} - Ваша фракция
{fraction_rank} - Ваша фракционная должность
{fraction_tag} - Тэг вашей фракции

{sex} - Добавляет букву "а" если в хелпере указан женский пол

{get_time} - Получить текущее время
{get_nick({arg_id})} - получить Никнейм из аргумента ID игрока
{get_rp_nick({arg_id})} - получить Никнейм без символа _ из аргумента ID игрока
{get_ru_nick({arg_id})} - получить Никнейм на кирилице из аргумента ID игрока 

{lmenu_vc_vize} - Авто-выдача визы Vice City
{show_rank_menu} - Открыть меню выдачи рангов
{get_rank} - Получить выбранный ранг

{pause} - Поставить команду на паузу и ожидать нажатия]]
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
				print('[SMI Helper] Создан хоткей для команды /' .. command.cmd .. ' на клавишу ' .. getNameKeysFrom(command.bind))
				--sampAddChatMessage('[SMI Helper] {ffffff}Создан хоткей для команды ' .. message_color_hex .. '/' .. command.cmd .. ' {ffffff}на клавишу '  .. message_color_hex .. getNameKeysFrom(command.bind), message_color)
			end
		end
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

local message1
local message2
local message3

local isActiveCommand = false

local debug_mode = false

local command_stop = false
local command_pause = false

local skip_dialog = false

local auto_uval_checker = false

local ad_repeat_count = 0
local last_ad_text = ""

------------------------------------------- Main -----------------------------------------------------

function main()

	if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(0) end 

	welcome_message()

	initialize_commands()

	if not isMonetLoader() then loadHotkeys() end

	if settings.player_info.name_surname == '' or  settings.player_info.fraction == 'Неизвестно' then
		sampAddChatMessage('[SMI Helper] {ffffff}Пытаюсь получить ваш /stats поскольку остуствуют данные про вас!', message_color)
		check_stats = true
		sampSendChat('/stats')
	end

	while true do
		wait(0)
		
		if ((os.date("%M", os.time()) == "55" and os.date("%S", os.time()) == "00") or (os.date("%M", os.time()) == "25" and os.date("%S", os.time()) == "00")) then
			if sampGetPlayerColor(tagReplacements.my_id()) == 368966908 then
				sampAddChatMessage('[SMI Helper] {ffffff}Через 5 минут будет PAYDAY. Наденьте форму чтобы не пропустить зарплату!', message_color)
				wait(1000)
			end
		end
	end

end
function welcome_message()
	if not sampIsLocalPlayerSpawned() then 
		sampAddChatMessage('[SMI Helper] {ffffff}Инициализация хелпера прошла успешно!',message_color)
		sampAddChatMessage('[SMI Helper] {ffffff}Для полной загрузки хелпера сначало заспавнитесь (войдите на сервер)',message_color)
		repeat wait(0) until sampIsLocalPlayerSpawned()
	end
	sampAddChatMessage('[SMI Helper] {ffffff}Загрузка хелпера прошла успешно!', message_color)
	show_arz_notify('info', 'SMI Helper', "Загрузка хелпера прошла успешно!", 3000)
	if isMonetLoader() or settings.general.bind_mainmenu == nil or not settings.general.use_binds then	
		sampAddChatMessage('[SMI Helper] {ffffff}Чтоб открыть меню хелпера введите команду ' .. message_color_hex .. '/smi', message_color)
	elseif hotkey_no_errors and settings.general.bind_mainmenu and settings.general.use_binds then
		sampAddChatMessage('[SMI Helper] {ffffff}Чтоб открыть меню хелпера нажмите ' .. message_color_hex .. getNameKeysFrom(settings.general.bind_mainmenu) .. ' {ffffff}или введите команду ' .. message_color_hex .. '/smi', message_color)
	else
		sampAddChatMessage('[SMI Helper] {ffffff}Чтоб открыть меню хелпера введите команду ' .. message_color_hex .. '/smi', message_color)
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
					sampAddChatMessage('[SMI Helper] {ffffff}Используйте ' .. message_color_hex .. '/' .. chat_cmd .. ' [аргумент]', message_color)
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
					sampAddChatMessage('[SMI Helper] {ffffff}Используйте ' .. message_color_hex .. '/' .. chat_cmd .. ' [ID игрока]', message_color)
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
						sampAddChatMessage('[SMI Helper] {ffffff}Используйте ' .. message_color_hex .. '/' .. chat_cmd .. ' [ID игрока] [аргумент]', message_color)
						play_error_sound()
					end
				else
					sampAddChatMessage('[SMI Helper] {ffffff}Используйте ' .. message_color_hex .. '/' .. chat_cmd .. ' [ID игрока] [аргумент]', message_color)
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
						sampAddChatMessage('[SMI Helper] {ffffff}Используйте ' .. message_color_hex .. '/' .. chat_cmd .. ' [ID игрока] [аргумент] [аргумент]', message_color)
						play_error_sound()
					end
				else
					sampAddChatMessage('[SMI Helper] {ffffff}Используйте ' .. message_color_hex .. '/' .. chat_cmd .. ' [ID игрока] [аргумент] [аргумент]', message_color)
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
							sampAddChatMessage('[SMI Helper] {ffffff}Чтобы остановить отыгровку команды используйте ' .. message_color_hex .. '/stop {ffffff}или нажмите кнопку внизу экрана', message_color)
							CommandStopWindow[0] = true
						elseif not isMonetLoader() and hotkey_no_errors and settings.general.bind_command_stop and settings.general.use_binds then
							sampAddChatMessage('[SMI Helper] {ffffff}Чтобы остановить отыгровку команды используйте ' .. message_color_hex .. '/stop {ffffff}или нажмите ' .. message_color_hex .. getNameKeysFrom(settings.general.bind_command_stop), message_color)
						else
							sampAddChatMessage('[SMI Helper] {ffffff}Чтобы остановить отыгровку команды используйте ' .. message_color_hex .. '/stop', message_color)
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
							sampAddChatMessage('[SMI Helper] {ffffff}Отыгровка команды /' .. chat_cmd .. " успешно остановлена!", message_color) 
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
								sampAddChatMessage('[SMI Helper] {ffffff}Команда /' .. chat_cmd .. ' поставлена на паузу!', message_color)
								command_pause = true
								CommandPauseWindow[0] = true
								while command_pause do
									wait(0)
								end
								if not command_stop then
									sampAddChatMessage('[SMI Helper] {ffffff}Продолжаю отыгровку команды /' .. chat_cmd, message_color)	
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
									sampAddChatMessage('[SMI Helper] {ffffff}Отыгровка команды /' .. chat_cmd .. " успешно остановлена!", message_color) 	
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
			sampAddChatMessage('[SMI Helper] {ffffff}Дождитесь завершения отыгровки предыдущей команды!', message_color)
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
		sampAddChatMessage('[SMI Helper] {ffffff}Ошибка, не могу найти бинд для выполнения этой команды!', message_color)
		return
	end
end
function initialize_commands()
	sampRegisterChatCommand("smi", function() MainWindow[0] = not MainWindow[0]  end)
	sampRegisterChatCommand("stop", function() 
		if isActiveCommand then 
			command_stop = true 
		else 
			sampAddChatMessage('[SMI Helper] {ffffff}В данный момент нету никакой активной команды/отыгровки!', message_color) 
		end
	end)
	sampRegisterChatCommand("sob", function(arg)
		if not isActiveCommand then
			if isParamSampID(arg) then
				player_id = tonumber(arg)
				SobesMenu[0] = not SobesMenu[0]
			else
				sampAddChatMessage('[SMI Helper] {ffffff}Используйте ' .. message_color_hex .. '/sob [ID игрока]', message_color)
			end
			
		else
			sampAddChatMessage('[SMI Helper] {ffffff}Дождитесь завершения отыгровки предыдущей команды!', message_color)
		end
	end)
	sampRegisterChatCommand("dep", function()
		DeportamentWindow[0] = not DeportamentWindow[0]
	end)
	sampRegisterChatCommand("mb", function()
		if not isActiveCommand then
			members_new = {} 
			members_check = true 
			sampSendChat("/members")
		else
			sampAddChatMessage('[SMI Helper] {ffffff}Дождитесь завершения отыгровки предыдущей команды!', message_color)
		end
	end)
	-- Ригистрация всeх команд которые есть в json
	registerCommandsFrom(settings.commands)
	if tonumber(settings.player_info.fraction_rank_number) >= 9 then 
		sampRegisterChatCommand("slm", show_leader_fast_menu)
		sampRegisterChatCommand("spcar", function()
			if not isActiveCommand then
				lua_thread.create(function()
					isActiveCommand = true
					if isMonetLoader() and settings.general.mobile_stop_button then
						sampAddChatMessage('[SMI Helper] {ffffff}Чтобы остановить отыгровку команды используйте ' .. message_color_hex .. '/stop {ffffff}или нажмите кнопку внизу экрана', message_color)
						CommandStopWindow[0] = true
					elseif not isMonetLoader() and hotkey_no_errors and settings.general.bind_command_stop and settings.general.use_binds then
						sampAddChatMessage('[SMI Helper] {ffffff}Чтобы остановить отыгровку команды используйте ' .. message_color_hex .. '/stop {ffffff}или нажмите ' .. message_color_hex .. getNameKeysFrom(settings.general.bind_command_stop), message_color)
					else
						sampAddChatMessage('[SMI Helper] {ffffff}Чтобы остановить отыгровку команды используйте ' .. message_color_hex .. '/stop', message_color)
					end
					sampSendChat("/rb Внимание! Через 15 секунд будет спавн транспорта организации.")
					wait(1500)
					if command_stop then 
						command_stop = false 
						isActiveCommand = false
						if isMonetLoader() and settings.general.mobile_stop_button then
							CommandStopWindow[0] = false
						end
						sampAddChatMessage('[SMI Helper] {ffffff}Отыгровка команды /spcar успешно остановлена!', message_color) 
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
						sampAddChatMessage('[SMI Helper] {ffffff}Отыгровка команды /spcar успешно остановлена!', message_color) 
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
				sampAddChatMessage('[SMI Helper] {ffffff}Дождитесь завершения отыгровки предыдущей команды!', message_color)
			end
		end)
		-- Ригистрация всех команд которые есть в json для 9/10
		registerCommandsFrom(settings.commands_manage) 
	end
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
function play_error_sound()
	if not isMonetLoader() and sampIsLocalPlayerSpawned() then
		addOneOffSound(getCharCoordinates(PLAYER_PED), 1149)
	end
end
function show_leader_fast_menu(id)
	if isParamSampID(id) then
		player_id = tonumber(id)
		LeaderFastMenu[0] = true
	else
		if isMonetLoader() or settings.general.bind_leader_fastmenu == nil then
			sampAddChatMessage('[SMI Helper] {ffffff}Используйте ' .. message_color_hex .. '/slm [ID]', message_color)
		elseif settings.general.bind_leader_fastmenu and settings.general.use_binds and hotkey_no_errors then
			sampAddChatMessage('[SMI Helper] {ffffff}Используйте ' .. message_color_hex .. '/slm [ID] {ffffff}или наведитесь на игрока через ' .. message_color_hex .. 'ПКМ + ' .. getNameKeysFrom(settings.general.bind_leader_fastmenu), message_color) 
		else
			sampAddChatMessage('[SMI Helper] {ffffff}Используйте ' .. message_color_hex .. '/slm [ID]', message_color)
		end 
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
		sampAddChatMessage('[SMI Helper] {ffffff}Ошибка: не удалось получить ID игрока!', message_color)
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
function send_ad()
	local text = u8:decode(ffi.string(input_edit_text))
	if text ~= '' then
		local exists = false
		for _, ad in ipairs(ads_history) do
			if ad.text == ad_message then
				exists = true
				break
			end
		end
		if not exists then
			table.insert(ads_history, 1, {text = ad_message, my_text = u8:decode(ffi.string(input_edit_text))})
			save_ads_history()
		end

		if text == last_ad_text then
            ad_repeat_count = ad_repeat_count + 1
        else
            ad_repeat_count = 0
            last_ad_text = text
        end
        if ad_repeat_count >= 5 then
            sampAddChatMessage('[SMI Helper] {ffffff}Не удалось отправить обьяву более 4 раз подряд, возможно слишком много спец.символов!', message_color)
			last_ad_text = ''
			ad_repeat_count = 0
			for index, ad in ipairs(ads_history) do
				if ad.text == ad_message then
					sampAddChatMessage('[SMI Helper] {ffffff}Удаление обяьвления из истории отредаченных обьявлений...', message_color)
					table.remove(ads_history, index)
					save_ads_history()
					break
				end
			end
            return
		else
			sampSendDialogResponse(ad_dialog_id, 1, 0, text)
        end
		
		imgui.StrCopy(input_edit_text, '')
		EditWindow[0] = false
	else
		sampAddChatMessage('[SMI Helper] {ffffff}Нельзя отправить пустую обьяву!', message_color)
	end
end
function sampev.onServerMessage(color,text)
	--sampAddChatMessage('color = ' .. color .. ' , text = '..text,-1)
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
					sampAddChatMessage(text, 0xFF2DB043)
					if message3 == text then
						auto_uval_checker = true
						sampSendChat('/fmute ' .. playerID .. ' 1 [AutoUval] Ожидайте')
					elseif tag == "R" then
						sampSendChat("/rb "..name.." отправьте /rb +++ чтобы уволится ПСЖ!")
					elseif tag == "F" then
						sampSendChat("/fb "..name.." отправьте /fb +++ чтобы уволится ПСЖ!")
					end
				elseif ((message == "(( +++ ))" or message == "(( +++. ))") and (PlayerID == playerID)) then
					sampAddChatMessage(text, 0xFF2DB043)
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
					sampAddChatMessage(text, 0xFF2DB043)
					if message3 == text then
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
					sampAddChatMessage('[SMI Helper] {ffffff}Увольняю игрока ' .. sampGetPlayerNickname(PlayerID) .. '!', message_color)
					auto_uval_checker = false
					temp = PlayerID .. ' ПСЖ'
					find_and_use_command("/uninvite {arg_id} {arg2}", temp)
				else
					sampAddChatMessage('[SMI Helper] {ffffff}Другой заместитель/лидер уже увольняет игрока ' .. sampGetPlayerNickname(PlayerID) .. '!', message_color)
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
		sampAddChatMessage('[SMI Helper] {ffffff}Номера телефонов государственных служб:', message_color)
		sampAddChatMessage('[SMI Helper] {ffffff}111 Баланс | 60 Время | 911 МЮ | 912 МЗ | 913 Такси | 914 Мехи | 8828 Банк | 997 Дома', message_color)
		return false
	end
	if text:find('пришло сообщение от%: (.+)') then
		local nick = text:match('пришло сообщение от%: (.+)')
		if nick == nil then
			nick = ''
		end
		if sampGetPlayerIdByNickname(nick) == '' then
			sampAddChatMessage('[SMI Helper]{ffffff} Поступило новое обьявление от игрока ' .. message_color_hex .. nick, message_color)
		else
			print(nick)
			sampAddChatMessage('[SMI Helper]{ffffff} Поступило новое обьявление от игрока ' .. message_color_hex .. nick .. '[' .. sampGetPlayerIdByNickname(nick) .. ']', message_color)
		end
		return false
	end
	if text:find('пришло VIP сообщение от%: (.+)') then
		local nick = text:match('пришло VIP сообщение от%: (.+)')
		if nick == nil then
			nick = ''
		end
		if sampGetPlayerIdByNickname(nick) == '' then
			sampAddChatMessage('[SMI Helper]{ffffff} Поступило новое VIP обьявление от игрока ' .. message_color_hex .. nick, message_color)
		else
			sampAddChatMessage('[SMI Helper]{ffffff} Поступило новое VIP обьявление от игрока ' .. message_color_hex .. nick .. '[' .. sampGetPlayerIdByNickname(nick) .. ']', message_color)
		end
		return false
	end
	if text:find('пришло сообщение о рекламе бизнеса от%: (.+)') then
		local nick = text:match('пришло сообщение о рекламе бизнеса от%: (.+)')
		if nick == nil then
			nick = ''
		end
		if sampGetPlayerIdByNickname(nick) == '' then
			sampAddChatMessage('[SMI Helper]{ffffff} Поступило новое обьявление от маркетолога ' .. message_color_hex .. nick, message_color)
		else
			sampAddChatMessage('[SMI Helper]{ffffff} Поступило новое обьявление от маркетолога ' .. message_color_hex .. nick .. '[' .. sampGetPlayerIdByNickname(nick) .. ']', message_color)
		end
		
		return false
	end
	if text:find('На обработку объявлений пришло сообщение от руководства страховой компании%: (.+)') then
		local nick = text:match('На обработку объявлений пришло сообщение от руководства страховой компании%: (.+)')
		if nick == nil then
			nick = ''
		end
		if sampGetPlayerIdByNickname(nick) == '' then
			sampAddChatMessage('[SMI Helper]{ffffff} Поступило новое обьявление от руководства СТК, а именно игрок ' .. message_color_hex .. nick, message_color)
		else
			sampAddChatMessage('[SMI Helper]{ffffff} оступило новое обьявление от руководства СТК, а именно игрок ' .. message_color_hex .. nick .. '[' .. sampGetPlayerIdByNickname(nick) .. ']', message_color)
		end
		return false
	end
	if text:find('%[Ошибка%] %{ffffff%}Это объявление уже редактирует (.+).') then
		local nick = text:match('%[Ошибка%] %{ffffff%}Это объявление уже редактирует (.+).')
		sampAddChatMessage('[SMI Helper] {ffffff}Это обьявление уже редактирует игрок ' .. message_color_hex  .. nick, message_color)
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

	if skip_dialog then
		sampSendDialogResponse(dialogid, 0,0,0)
		skip_dialog = false
		sampSendChat('/newsredak')
		return false
	end

	if title:find('Основная статистика') and check_stats then -- получение статистики
		if text:find("{FFFFFF}Имя: {B83434}%[(.-)]") then
			settings.player_info.name_surname = TranslateNick(text:match("{FFFFFF}Имя: {B83434}%[(.-)]"))
			input_name_surname = imgui.new.char[256](u8(settings.player_info.name_surname))
			sampAddChatMessage('[SMI Helper] {ffffff}Ваше Имя и Фамилия обнаружены, вы - ' .. settings.player_info.name_surname, message_color)
		end
		if text:find("{FFFFFF}Пол: {B83434}%[(.-)]") then
			settings.player_info.sex = text:match("{FFFFFF}Пол: {B83434}%[(.-)]")
			sampAddChatMessage('[SMI Helper] {ffffff}Ваш пол обнаружен, вы - ' .. settings.player_info.sex, message_color)
		end
		if text:find("{FFFFFF}Организация: {B83434}%[(.-)]") then
			settings.player_info.fraction = text:match("{FFFFFF}Организация: {B83434}%[(.-)]")
			if settings.player_info.fraction == 'Не имеется' then
				sampAddChatMessage('[SMI Helper] {ffffff}Вы не состоите в организации!',message_color)
				settings.player_info.fraction_tag = "Неизвестно"
			else
				sampAddChatMessage('[SMI Helper] {ffffff}Ваша организация обнаружена, это: '..settings.player_info.fraction, message_color)
				if settings.player_info.fraction:find('ЛС') or settings.player_info.fraction:find('LS') then
                    settings.player_info.fraction_tag = 'СМИ ЛС'
                elseif settings.player_info.fraction:find('ЛВ') or settings.player_info.fraction:find('LV') then
                    settings.player_info.fraction_tag = 'СМИ ЛВ'
                elseif settings.player_info.fraction:find('СФ') or settings.player_info.fraction:find('SF') then
					settings.player_info.fraction_tag = 'СМИ СФ'
				else
					settings.player_info.fraction_tag = 'СМИ'
				end
				settings.deportament.dep_tag1 = '[' .. settings.player_info.fraction_tag .. ']'
				input_dep_tag1 = imgui.new.char[32](u8(settings.deportament.dep_tag1))
				input_fraction_tag = imgui.new.char[256](u8(settings.player_info.fraction_tag))
				sampAddChatMessage('[SMI Helper] {ffffff}Вашей организации присвоен тег '..settings.player_info.fraction_tag .. ". Но вы можете изменить его.", message_color)
			end
		end
		if text:find("{FFFFFF}Должность: {B83434}(.+)%((%d+)%)") then
			settings.player_info.fraction_rank, settings.player_info.fraction_rank_number = text:match("{FFFFFF}Должность: {B83434}(.+)%((%d+)%)(.+)Уровень розыска")
			sampAddChatMessage('[SMI Helper] {ffffff}Ваша должность обнаружена, это: '..settings.player_info.fraction_rank.." ("..settings.player_info.fraction_rank_number..")", message_color)
			if tonumber(settings.player_info.fraction_rank_number) >= 9 then
				settings.general.auto_uval = true
				initialize_commands()
			end
		else
			settings.player_info.fraction_rank = "Неизвестно"
			settings.player_info.fraction_rank_number = 0
			sampAddChatMessage('[SMI Helper] {ffffff}Произошла ошибка, не могу получить ваш ранг!',message_color)
		end
		save_settings()
		sampSendDialogResponse(dialogid, 0,0,0)
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
			sampAddChatMessage('[SMI Helper]{ffffff} Список сотрудников пуст!', message_color)
			members_check = false
        end
        return false
    end

	if title:find('Выберите ранг для (.+)') and text:find('вакансий') then -- invite
		sampSendDialogResponse(dialogid, 1, 0, 0)
		return false
	end

	if title:find('Редактирование') and text:find('Объявление от') and text:find('Сообщение') then
		ad_dialog_id = dialogid
		for line in text:gmatch("[^\n]+") do
			-- {FFFFFF}Объявление от {FFD700}руководства страховой компании Bogdan_Martelli, спустя 71cек.
			-- {FFFFFF}Объявление от {FFD700}маркетолога Bogdan_Martelli (бизнеса №196 'Ларек с уличной едой'), спустя 8c.
			-- {FFFFFF}Объявление от {FFD700}Bogdan_Martelli, спустя 2c.
			if line:find('{FFFFFF}Объявление от {FFD700}маркетолога (.+) %(бизнес') then
				ad_from = line:match('{FFFFFF}Объявление от {FFD700}маркетолога (.+) %(бизнес')
			elseif line:find('{FFFFFF}Объявление от {FFD700}руководства страховой компании (.+),') then
				ad_from = line:match('{FFFFFF}Объявление от {FFD700}руководства страховой компании (.+),')
			elseif line:find('{FFFFFF}Объявление от {FFD700}(.+),') then
				ad_from = line:match('{FFFFFF}Объявление от {FFD700}(.+),')
			end
			if line:find('{FFFFFF}Сообщение:%s+{33AA33}(.+)') then
				ad_message = line:match('{FFFFFF}Сообщение:%s+{33AA33}(.+)')
			end
		end
		EditWindow[0] = true
		return false
	end
	if (title:find('Редактирование') and text:find('обычных') and text:find('автоматических') and tonumber(settings.player_info.fraction_rank_number) < 8) then
		sampSendDialogResponse(dialogid, 1,0,0)
		return false
	end
	if title:find('Редакция') then
		if text:find('На данный момент сообщений нет') then
			sampSendDialogResponse(dialogid, 1,0,0)
			sampAddChatMessage('[SMI Helper] {ffffff}На данный момент нету обьявлений для редактирования!', message_color)
			return false
		end
	end 
end

imgui.OnInitialize(function()
	imgui.GetIO().IniFilename = ni
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
					sampAddChatMessage('[SMI Helper] {ffffff}Чтобы остановить отыгровку команды используйте ' .. message_color_hex .. '/stop {ffffff}или нажмите кнопку внизу экрана', message_color)
					CommandStopWindow[0] = true
				elseif not isMonetLoader() and hotkey_no_errors and settings.general.bind_command_stop and settings.general.use_binds then
					sampAddChatMessage('[SMI Helper] {ffffff}Чтобы остановить отыгровку команды используйте ' .. message_color_hex .. '/stop {ffffff}или нажмите ' .. message_color_hex .. getNameKeysFrom(settings.general.bind_command_stop), message_color)
				else
					sampAddChatMessage('[SMI Helper] {ffffff}Чтобы остановить отыгровку команды используйте ' .. message_color_hex .. '/stop', message_color)
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
						sampAddChatMessage('[SMI Helper] {ffffff}Отыгровка команды /' .. command.cmd .. " успешно остановлена!", message_color) 
						return 
					else
						if wait_tag then
							for tag, replacement in pairs(tagReplacements) do
								local success, result = pcall(string.gsub, line, "{" .. tag .. "}", replacement())
								if success then
									line = result
								end
							end
							if line_index ~= 1 then wait(1500) end
							if not command_stop then
								sampSendChat(line)
							else
								command_stop = false 
								isActiveCommand = false
								if isMonetLoader() and settings.general.mobile_stop_button then
									CommandStopWindow[0] = false
								end
								sampAddChatMessage('[SMI Helper] {ffffff}Отыгровка команды /' .. chat_cmd .. " успешно остановлена!", message_color) 	
								break
							end
						end
						if not wait_tag then
							if line == '{show_rank_menu}' then
								wait_tag = true
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
	end
	if not command_find then
		sampAddChatMessage('[SMI Helper] {ffffff}Бинд для изменения ранга отсутствует либо отключён!', message_color)
		sampAddChatMessage('[SMI Helper] {ffffff}Попробуйте сбросить настройки хелпера!', message_color)
	end
end
imgui.OnFrame(
    function() return MainWindow[0] end,
    function(player)
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(600 * settings.general.custom_dpi, 425	* settings.general.custom_dpi), imgui.Cond.FirstUseEver)
		imgui.Begin(fa.BUILDING_SHIELD.." SMI Helper##main", MainWindow, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize )
		change_dpi()
		if imgui.BeginTabBar('Tabs') then	
			if imgui.BeginTabItem(fa.HOUSE..u8' Главное меню') then
				if imgui.BeginChild('##1', imgui.ImVec2(589 * settings.general.custom_dpi, 168 * settings.general.custom_dpi), true) then
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
					if imgui.CenterColumnSmallButton(u8'Обновить##fraction') then
						check_stats = true
						sampSendChat('/stats')
					end
					imgui.Columns(1)
					imgui.Separator()
					imgui.Columns(3)
					imgui.CenterColumnText(u8"Тeг организации:")
					imgui.NextColumn()
					imgui.CenterColumnText(u8(settings.player_info.fraction_tag))
					imgui.NextColumn()
					if imgui.CenterColumnSmallButton(u8'Изменить##fraction_tag') then
						imgui.OpenPopup(fa.USER .. u8' Тeг организации##fraction_tag')
					end
					if imgui.BeginPopupModal(fa.USER .. u8' Тeг организации##fraction_tag', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize  ) then
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
					if imgui.CenterColumnSmallButton(u8"Обновить##rank") then
						check_stats = true
						sampSendChat('/stats')
					end
					imgui.Columns(1)
				
				imgui.EndChild()
				end
				if imgui.BeginChild('##2', imgui.ImVec2(589 * settings.general.custom_dpi, 53 * settings.general.custom_dpi), true) then
					imgui.CenterText(fa.CIRCLE_INFO .. u8' Редакторование обьяв происходит в удобной, полноценной замене стандартного окна')
					if imgui.CenterButton(u8'Настроить меню редактирования обьявлений под свои предпочтения') then
						sampAddChatMessage('[SMI Helper]{ffffff} Данный функционал недоступен в Free версии скрипта! Купите платную VIP версию у MTG MODS.', message_color)
					end
				imgui.EndChild()
				end
				imgui.EndTabItem()
				if imgui.BeginChild('##3', imgui.ImVec2(589 * settings.general.custom_dpi, 99 * settings.general.custom_dpi), true) then
					imgui.CenterText(fa.SITEMAP .. u8' Дополнительные функции')
					imgui.Separator()
					imgui.Columns(3)
					imgui.CenterColumnText(u8"RP Общение в чатах")
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
					imgui.CenterColumnText(u8"Авто-редакт (из запоминания)")
					imgui.SameLine(nil, 5) imgui.TextDisabled("[?]")
					if imgui.IsItemHovered() then
						imgui.SetTooltip(u8"Скрипт (даже FREE версия) запоминает обьявы игроков, которые вы редачите, так вот:\nДанная функция автоматически отправит сохраненную обьяву от того же игрока\n\nВНИМАНИЕ!\nДАННАЯ ФУНКЦИЯ НЕ ЯВЛЯЕТСЯ ЧИТОМ, НО ОНА МОЖЕТ БЫТЬ ЗАПРЕЩЕНА\nОБЯЗАТЕЛЬНО УТОЧНЯЙТЕ В РЕПОРТ МОЖНО ЛИ ЮЗАТЬ НА ВАШЕМ СЕРВЕРЕ!")
					end
					imgui.NextColumn()
					imgui.CenterColumnText(u8'Отключено')
					imgui.NextColumn()
					if imgui.CenterColumnSmallButton(u8'Включить##auto_send_old') then
						sampAddChatMessage('[SMI Helper]{ffffff} Данный функционал недоступен в Free версии скрипта! Купите платную VIP версию у MTG MODS.', message_color)
					end
					imgui.Columns(1)
					imgui.Separator()
					imgui.Columns(3)
					imgui.CenterColumnText(u8"Авто-ловля обьявлений")
					imgui.SameLine(nil, 5) imgui.TextDisabled("[?]")
					if imgui.IsItemHovered() then
						imgui.SetTooltip(u8"При поступлении нового обьявления прописывает /newsredak вместо вас\n\nВНИМАНИЕ!\nДАННАЯ ФУНКЦИЯ НЕ ЯВЛЯЕТСЯ ЧИТОМ, НО ОНА МОЖЕТ БЫТЬ ЗАПРЕЩЕНА\nОБЯЗАТЕЛЬНО УТОЧНЯЙТЕ В РЕПОРТ МОЖНО ЛИ ЮЗАТЬ НА ВАШЕМ СЕРВЕРЕ!")
					end
					imgui.NextColumn()
					imgui.CenterColumnText(u8'Отключено')
					imgui.NextColumn()
					if imgui.CenterColumnSmallButton(u8'Включить##auto_lovlya_ads') then
						sampAddChatMessage('[SMI Helper]{ffffff} Данный функционал недоступен в Free версии скрипта! Купите платную VIP версию у MTG MODS.', message_color)
					end
					imgui.Columns(1)
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
			end
			if imgui.BeginTabItem(fa.RECTANGLE_LIST..u8' Команды/отыгровки') then 
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
							imgui.CenterColumnText(u8"/smi")
							imgui.NextColumn()
							imgui.CenterColumnText(u8"Открыть главное меню хелпера")
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
							imgui.Columns(3)
							imgui.CenterColumnText(u8"/mb")
							imgui.NextColumn()
							imgui.CenterColumnText(u8"Открыть меню мебмерса")
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
                            imgui.CenterColumnText(u8"/sob")
                            imgui.NextColumn()
                            imgui.CenterColumnText(u8"Открыть меню собеседования")
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
							if #settings.commands >= 15 then
								sampAddChatMessage('[SMI Helper]{ffffff} Лимит Free версии 15 команд! Купите платную VIP версию у MTG MODS.', message_color)
							else
								local new_cmd = {cmd = '', description = 'Новая команда созданная вами', text = '', arg = '', enable = true, waiting = '1.200', deleted = false, bind = "{}"}
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
								imgui.CenterColumnText(u8"Авто Увал")
								imgui.SameLine(nil, 5) imgui.TextDisabled("[?]")
								if imgui.IsItemHovered() then
									imgui.SetTooltip(u8"Автоматическое увольнение сотрудников, которые просят увал ПСЖ в /r /rb")
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
											sampAddChatMessage('[SMI Helper] {ffffff}Эта Функция доступна только лидеру и заместителям!',message_color)
										end
									end
								end
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
								local new_cmd = {cmd = '', description = 'Новая команда созданная вами', text = '', arg = '', enable = true, waiting = '1.200', deleted = false, bind = "{}" }
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
							imgui.CenterText(u8"У вас нет доступа к данным командам!")
							imgui.CenterText(u8"Необходимо иметь 9 или 10 ранг, у вас же "..settings.player_info.fraction_rank_number..u8" ранг!")
							imgui.Separator()
						end
						imgui.EndTabItem() 
					end
					if imgui.BeginTabItem(fa.BARS..u8' Дополнительные функции') then 
						if imgui.BeginChild('##99', imgui.ImVec2(589 * settings.general.custom_dpi, 333 * settings.general.custom_dpi), true) then
							if isMonetLoader() then
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
										imgui.CenterText(u8'Открытие главного меню хелпера (аналог /smi):')
										local width = imgui.GetWindowWidth()
										local calc = imgui.CalcTextSize(getNameKeysFrom(settings.general.bind_mainmenu))
										imgui.SetCursorPosX( width / 2 - calc.x / 2 )
										if MainMenuHotKey:ShowHotKey() then
											settings.general.bind_mainmenu = encodeJson(MainMenuHotKey:GetHotKey())
											save_settings()
										end
										if tonumber(settings.player_info.fraction_rank_number) >= 9 then
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
								imgui.CenterText(fa.CIRCLE_INFO .. ' P.S.')
								imgui.CenterText(u8('Бинды (клавиши) под каждую отдельную команду доступны в общих командах и для 9/10'))
								imgui.Separator()
								
							end
						imgui.EndChild()
					end
					imgui.EndTabItem() 
				end
				imgui.EndTabBar() 
				end
				imgui.EndTabItem()
			end
			if imgui.BeginTabItem(fa.MICROPHONE_LINES ..u8' Эфиры ') then 
				imgui.BeginChild('##12222', imgui.ImVec2(589 * settings.general.custom_dpi, 330 * settings.general.custom_dpi), true)
				imgui.Columns(2)
				imgui.CenterColumnText(u8"Список всех ваших эфиров:")
				imgui.SetColumnWidth(-1, 445 * settings.general.custom_dpi)
				imgui.NextColumn()
				imgui.CenterColumnText(u8"Действие")
				imgui.SetColumnWidth(-1, 200 * settings.general.custom_dpi)
				imgui.Columns(1)
				imgui.Separator()
				for i, live in ipairs(settings.lives) do
					imgui.Columns(2)
					imgui.CenterColumnText(u8(live.name))
					imgui.NextColumn()
					if imgui.SmallButton(fa.CIRCLE_PLAY .. u8' Начать##' .. i) then
						local random_number = tostring((math.random(0,50) + math.random(100,200)))
						local random = 'live' .. random_number
						sampAddChatMessage('[SMI Helper] {ffffff}Запускаю эфир "' .. live.name .. '" через временную команду /' .. random , message_color)
						sampAddChatMessage('[SMI Helper] {ffffff}Задержка между строками 6 секунд (стандарт)', message_color)
						register_command(random, "", live.text, 6.000)
						sampProcessChatInput("/" .. random)
						sampUnregisterChatCommand(random)
					end
					if imgui.IsItemHovered() then
						imgui.SetTooltip(u8'Начать эфир "' .. u8(live.name) .. '"')
					end
					imgui.SameLine()
					if imgui.SmallButton(fa.PEN_TO_SQUARE .. '##' .. i) then
						local live_text = live.text:gsub('&','\n')
						input_text_live = imgui.new.char[16384](u8(live_text))
						input_name_live = imgui.new.char[256](u8(live.name))
						imgui.OpenPopup(fa.PEN_TO_SQUARE .. u8' Изменение текста эфира' .. '##' .. i)	
					end
					if imgui.IsItemHovered() then
						imgui.SetTooltip(u8'Редактирование эфира "' .. u8(live.name) .. '"')
					end
					if imgui.BeginPopupModal(fa.PEN_TO_SQUARE .. u8' Изменение текста эфира' .. '##' .. i, _, imgui.WindowFlags.NoCollapse  + imgui.WindowFlags.NoResize ) then
						change_dpi()
						if imgui.BeginChild('##99992', imgui.ImVec2(589 * settings.general.custom_dpi, 360 * settings.general.custom_dpi), true) then	
							imgui.PushItemWidth(578 * settings.general.custom_dpi)
							imgui.InputText(u8'##live_name', input_name_live, 256)
							imgui.InputTextMultiline("##live_text", input_text_live, 16384, imgui.ImVec2(578 * settings.general.custom_dpi, 320 * settings.general.custom_dpi))
							imgui.EndChild()
						end	
						if imgui.Button(fa.CIRCLE_XMARK .. u8' Отмена', imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
							imgui.CloseCurrentPopup()
						end
						imgui.SameLine()
						if imgui.Button(fa.FLOPPY_DISK .. u8' Сохранить текст эфира', imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
							live.name = u8:decode(ffi.string(input_name_live))
							local temp = u8:decode(ffi.string(input_text_live))
							live.text = temp:gsub('\n', '&')
							save_settings()
							imgui.CloseCurrentPopup()
						end
						imgui.End()
					end
					imgui.SameLine()
					if imgui.SmallButton(fa.TRASH_CAN .. '##' .. i) then
						imgui.OpenPopup(fa.TRIANGLE_EXCLAMATION .. u8' Предупреждение ##' .. i .. live.name)
					end
					if imgui.IsItemHovered() then
						imgui.SetTooltip(u8'Удаление эфира "' .. u8(live.name) .. '"')
					end
					if imgui.BeginPopupModal(fa.TRIANGLE_EXCLAMATION .. u8' Предупреждение ##' .. i .. live.name, _, imgui.WindowFlags.NoResize ) then
						change_dpi()
						imgui.CenterText(u8'Вы действительно хотите удалить эфир "' .. u8(live.name) .. '" ?')
						imgui.Separator()
						if imgui.Button(fa.CIRCLE_XMARK .. u8' Нет, отменить', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
							imgui.CloseCurrentPopup()
						end
						imgui.SameLine()
						if imgui.Button(fa.TRASH_CAN .. u8' Да, удалить', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
							table.remove(settings.lives, i)
							save_settings()
							imgui.CloseCurrentPopup()
						end
						imgui.End()
					end
					imgui.Columns(1)
					imgui.Separator()
				end
				imgui.EndChild()
				if imgui.Button(fa.CIRCLE_PLUS .. u8' Создать новый эфир', imgui.ImVec2(imgui.GetMiddleButtonX(1), 0)) then
					if #settings.lives >= 11 then
						sampAddChatMessage('[SMI Helper]{ffffff} Лимит Free версии 11 эфиров! Купите платную VIP версию у MTG MODS.', message_color)
					else
						input_name_live = imgui.new.char[256](u8("Название"))
						input_text_live = imgui.new.char[16384](u8("Текст вашего эфира\nВы можете использовать те же теги, что и в рп командах"))
						imgui.OpenPopup(fa.PEN_TO_SQUARE .. u8' Создание эфира')	
					end
				end
				if imgui.BeginPopupModal(fa.PEN_TO_SQUARE .. u8' Создание эфира', _, imgui.WindowFlags.NoCollapse  + imgui.WindowFlags.NoResize ) then
					if imgui.BeginChild('##9999999', imgui.ImVec2(589 * settings.general.custom_dpi, 360 * settings.general.custom_dpi), true) then	
						imgui.PushItemWidth(578 * settings.general.custom_dpi)
						imgui.InputText(u8'##live_name', input_name_live, 256)
						imgui.InputTextMultiline("##live_text", input_text_live, 16384, imgui.ImVec2(578 * settings.general.custom_dpi, 320 * settings.general.custom_dpi))
						imgui.EndChild()
					end	
					if imgui.Button(fa.CIRCLE_XMARK .. u8' Отмена', imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
						imgui.CloseCurrentPopup()
					end
					imgui.SameLine()
					if imgui.Button(fa.FLOPPY_DISK .. u8' Сохранить эфир', imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
						local temp = u8:decode(ffi.string(input_text_live))
						local new_live = {name = u8:decode(ffi.string(input_name_live)), text = temp:gsub('\n', '&')}
						table.insert(settings.lives, new_live)
						save_settings()
						imgui.CloseCurrentPopup()
					end
					imgui.End()
				end

				imgui.EndTabItem()
			end
			if imgui.BeginTabItem(fa.FILE_PEN ..u8' Обьявы') then 
				imgui.BeginChild('##111', imgui.ImVec2(589 * settings.general.custom_dpi, 361 * settings.general.custom_dpi), true)
				if selected_adshistory then
					if edit_adshistory_orig then
						imgui.PushItemWidth(579 * settings.general.custom_dpi)
						imgui.InputText('##adshistory_input_text', adshistory_input_text, 512)
						imgui.Separator()
						if imgui.Button(fa.FLOPPY_DISK .. u8' Сохранить это обьявление', imgui.ImVec2(imgui.GetMiddleButtonX(1), 25 * settings.general.custom_dpi)) then
							for index, value in ipairs(ads_history) do
								if value.my_text == adshistory_my_text then
									local adshistory_input_decoded = u8:decode(ffi.string(adshistory_input_text))
									adshistory_my_text = adshistory_input_decoded
									value.my_text = adshistory_my_text
									save_ads_history()
									break
								end
							end
							edit_adshistory_orig = false
							selected_adshistory = false
						end
					else
						imgui.CenterText(u8("Оригинальное обьявление:"))
						imgui.CenterText(u8(adshistory_orig))
						imgui.Separator()
						imgui.CenterText(u8("Ваша отредактированная версия:"))
						imgui.CenterText(u8(adshistory_my_text))
						imgui.Separator()
						if imgui.Button(fa.PEN_TO_SQUARE .. u8' Отредактировать ', imgui.ImVec2(imgui.GetMiddleButtonX(2), 25 * settings.general.custom_dpi)) then
							imgui.StrCopy(adshistory_input_text, u8(adshistory_my_text))
							edit_adshistory_orig = true
						end
						imgui.SameLine()
						if imgui.Button(fa.TRASH_CAN .. u8' Удалить ', imgui.ImVec2(imgui.GetMiddleButtonX(2), 25 * settings.general.custom_dpi)) then
							for index, value in ipairs(ads_history) do
								if value.my_text == adshistory_my_text then
									table.remove(ads_history, index)
									save_ads_history()
								end
							end
							selected_adshistory = false
						end
					end
				else
					imgui.PushItemWidth(580 * settings.general.custom_dpi)
					imgui.InputTextWithHint(u8'##input_ads', u8'Поиск обьявлений по нужной фразе, начинайте вводить её сюда...', input_ads, 128)
					imgui.CenterText(u8('Выберите неправильное ранее отредаченное обьявление чтобы изменить и сохранить его'))
					imgui.Separator()
					local input_ads_decoded = u8:decode(ffi.string(input_ads))
					for id, ad in ipairs(ads_history) do
						if input_ads_decoded == '' or ad.my_text:rupper():find(input_ads_decoded:rupper()) then
							if imgui.Button(u8(ad.my_text .. '##' .. id), imgui.ImVec2(imgui.GetMiddleButtonX(1), 25 * settings.general.custom_dpi)) then
								adshistory_orig = ad.text
								adshistory_my_text = ad.my_text
								edit_adshistory_orig = false
								selected_adshistory = true
								break
							end
						end
					end
				end
				imgui.EndChild()
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
					if #settings.note >= 5 then
						sampAddChatMessage('[SMI Helper]{ffffff} Лимит Free версии 5 заметок! Купите платную VIP версию у MTG MODS.', message_color)
					else
						input_name_note = imgui.new.char[256](u8("Название"))
						input_text_note = imgui.new.char[16384](u8("Текст"))
						imgui.OpenPopup(fa.PEN_TO_SQUARE .. u8' Создание заметки')	
					end
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
				if imgui.SmallButton(u8'https://youtu.be/EPqjwI6JXf0') then
					openLink('https://youtu.be/EPqjwI6JXf0')
				end
				imgui.Separator()
				imgui.Text(fa.HEADSET..u8" Тех.поддержка по хелперу:")
				imgui.SameLine()
				if imgui.SmallButton('https://discord.gg/qBPEYjfNhv') then
					openLink('https://discord.gg/qBPEYjfNhv')
				end
				imgui.Separator()
				imgui.Text(fa.GLOBE..u8" Тема хелпера на форуме BlastHack:")
				imgui.SameLine()
				if imgui.SmallButton(u8'https://www.blast.hk/threads/223090/') then
					openLink('https://www.blast.hk/threads/223090/')
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
				-- imgui.TextWrapped(u8('Нашли баг или есть предложение по улучшению хелпера? Сообщите об этом на нашем Discord сервере или на форуме BlastHack!'))
				-- imgui.TextWrapped(u8('Есть желание  Вы можете закинуть донатик! Реквизиты есть на нашем Discord сервере.'))
				imgui.CenterText(fa.MAXIMIZE .. u8' Размер менюшек скрипта:')
				if settings.general.custom_dpi == slider_dpi[0] then
					
				else
					imgui.SameLine()
					if imgui.SmallButton(fa.CIRCLE_ARROW_RIGHT .. u8' Применить и сохранить') then
						settings.general.custom_dpi = slider_dpi[0]
						save_settings()
						sampAddChatMessage('[SMI Helper] {ffffff}Перезагрузка скрипта для пременения размера окон...', message_color)
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
						sampAddChatMessage('[SMI Helper] {ffffff}Хелпер приостановил свою работу до следущего входа в игру!', message_color)
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
						ads_history = {}
						save_ads_history()
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
					imgui.CenterText(u8'Вы действительно хотите удалить SMI Helper?')
					imgui.Separator()
					if imgui.Button(fa.CIRCLE_XMARK .. u8' Нет, отменить', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
						imgui.CloseCurrentPopup()
					end
					imgui.SameLine()
					if imgui.Button(fa.TRASH_CAN .. u8' Да, я хочу удалить', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
						sampAddChatMessage('[SMI Helper] {ffffff}Хелпер полностю удалён из вашего устройства!', message_color)
						sampShowDialog(999999, message_color_hex .. "SMI Helper", "Мне очень жаль что вы удалили SMI Helper из своего устройства.\nЕсли удаление связано с негативным опытом использования, и вы сталкивались с багами или проблемами, то\nсообщите мне что именно заставило вас удалить хелпер.\n\nDiscord: https://discord.com/invite/qBPEYjfNhv\nBlastHack: https://www.blast.hk/threads/223090/\nTelegram: https://t.me/mtgmods\n\nЕсли что, вы можете заново скачать и установить хелпер в любой момент :)", "Закрыть", '', 0)
						os.remove(getWorkingDirectory() .. "\\SMI_Helper.lua")
						os.remove(getWorkingDirectory() .. "\\SMI Helper\\Settings.json")
						os.remove(getWorkingDirectory() .. "\\SMI Helper\\ADS.json")
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
    function() return EditWindow[0] end,
    function(player)
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		local size_window_y = settings.general.use_ads_buttons and 302 or 140
		imgui.SetNextWindowSize(imgui.ImVec2(600 * settings.general.custom_dpi, size_window_y * settings.general.custom_dpi), imgui.Cond.FirstUseEver)
		imgui.Begin(fa.BUILDING_SHIELD.." SMI Helper##EditWindow", EditWindow, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize  + imgui.WindowFlags.NoScrollbar )
		change_dpi()
		imgui.Text(fa.CIRCLE_INFO .. u8" Объявление подал игрок: " .. u8(ad_from) .. '[' .. (sampGetPlayerIdByNickname(ad_from) and sampGetPlayerIdByNickname(ad_from) or 'OFF') .. ']')
		imgui.Text(fa.CIRCLE_INFO .. u8" Текст: " .. (u8(ad_message)))
		if settings.general.ads_copy_button then
			imgui.SameLine()
			if imgui.SmallButton(fa.CIRCLE_ARROW_RIGHT) then
				imgui.StrCopy(input_edit_text, u8(ad_message))
			end
		end
		imgui.Separator()
		local window_size = imgui.GetWindowSize()
		local size_item_width = settings.general.ads_history and 100 or 70
		imgui.PushItemWidth(window_size.x - size_item_width * settings.general.custom_dpi)
		if imgui.InputTextWithHint('', u8'Отредактируйте объявление либо введите причину для отклонения', input_edit_text, 512) then
			input_edit_text = input_edit_text
		end
		imgui.SameLine()
		if imgui.Button(fa.DELETE_LEFT, imgui.ImVec2(27 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
			local text = u8:decode(ffi.string(input_edit_text))
			if #text > 0 then
				imgui.StrCopy(input_edit_text, u8(text:sub(1, -2)))
			end
		end
		imgui.SameLine()
		if imgui.Button(fa.TRASH_CAN, imgui.ImVec2(25 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
			imgui.StrCopy(input_edit_text, "")
		end
		if settings.general.ads_history then
			imgui.SameLine()
			if imgui.Button(fa.CLOCK_ROTATE_LEFT, imgui.ImVec2(25 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
				imgui.OpenPopup(fa.CLOCK_ROTATE_LEFT .. u8' История обьявлений')	
			end
			if imgui.BeginPopupModal(fa.CLOCK_ROTATE_LEFT .. u8' История обьявлений', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize) then
				imgui.SetWindowSizeVec2(imgui.ImVec2(610 * settings.general.custom_dpi, 350 * settings.general.custom_dpi))
				if imgui.BeginChild('##99999999', imgui.ImVec2(600 * settings.general.custom_dpi, 285 * settings.general.custom_dpi), true) then	
					change_dpi()
					imgui.PushItemWidth(580 * settings.general.custom_dpi)
					imgui.InputTextWithHint(u8'##input_ads', u8'Поиск обьявлений по нужной фразе, начинайте вводить её сюда...', input_ads, 128)
					imgui.Separator()
					local input_ads_decoded = u8:decode(ffi.string(input_ads))
					for id, ad in ipairs(ads_history) do
						if input_ads_decoded == '' or ad.my_text:rupper():find(input_ads_decoded:rupper()) then
							if imgui.Button(u8(ad.my_text .. '##' .. id), imgui.ImVec2(imgui.GetMiddleButtonX(1), 25 * settings.general.custom_dpi)) then
								imgui.StrCopy(input_edit_text, u8(ad.my_text))
								imgui.CloseCurrentPopup()
								break
							end
						end
					end
					imgui.EndChild()
				end		
				if imgui.Button(fa.CIRCLE_XMARK .. u8' Закрыть', imgui.ImVec2(imgui.GetMiddleButtonX(1), 25 * settings.general.custom_dpi)) then
					imgui.CloseCurrentPopup()
				end
				imgui.End()
			end
		end
		imgui.Separator()
		if settings.general.use_ads_buttons then
			if imgui.BeginChild('##1', imgui.ImVec2(125 * settings.general.custom_dpi, 155 * settings.general.custom_dpi), true) then	
				if imgui.Button(u8('Куплю'), imgui.ImVec2(imgui.GetMiddleButtonX(1), 25 * settings.general.custom_dpi)) then
					local text = u8:decode(ffi.string(input_edit_text)) .. 'Куплю '
					imgui.StrCopy(input_edit_text, u8(text))
				end
				if imgui.Button(u8('Продам'), imgui.ImVec2(imgui.GetMiddleButtonX(1), 25 * settings.general.custom_dpi)) then
					local text = u8:decode(ffi.string(input_edit_text)) .. 'Продам '
					imgui.StrCopy(input_edit_text, u8(text))
				end
				if imgui.Button(u8('Обменяю'), imgui.ImVec2(imgui.GetMiddleButtonX(1), 25 * settings.general.custom_dpi)) then
					local text = u8:decode(ffi.string(input_edit_text)) .. 'Обменяю '
					imgui.StrCopy(input_edit_text, u8(text))
				end
				if imgui.Button(u8('Сдам в аренду'), imgui.ImVec2(imgui.GetMiddleButtonX(1), 25 * settings.general.custom_dpi)) then
					local text = u8:decode(ffi.string(input_edit_text)) .. 'Сдам в аренду '
					imgui.StrCopy(input_edit_text, u8(text))
				end
				if imgui.Button(u8('Арендую'), imgui.ImVec2(imgui.GetMiddleButtonX(1), 25 * settings.general.custom_dpi)) then
					local text = u8:decode(ffi.string(input_edit_text)) .. 'Арендую '
					imgui.StrCopy(input_edit_text, u8(text))
				end
				imgui.EndChild()
			end	
			imgui.SameLine()
			if imgui.BeginChild('##2', imgui.ImVec2(200 * settings.general.custom_dpi, 155 * settings.general.custom_dpi), true) then	
				if imgui.Button(u8('а/м'), imgui.ImVec2(imgui.GetMiddleButtonX(4), 25 * settings.general.custom_dpi)) then
					local text = u8:decode(ffi.string(input_edit_text)) .. 'а/м '
					imgui.StrCopy(input_edit_text, u8(text))
				end
				imgui.SameLine()
				if imgui.Button(u8('т/с'), imgui.ImVec2(imgui.GetMiddleButtonX(4), 25 * settings.general.custom_dpi)) then
					local text = u8:decode(ffi.string(input_edit_text)) .. 'т/с '
					imgui.StrCopy(input_edit_text, u8(text))
				end
				imgui.SameLine()
				if imgui.Button(u8('л/д'), imgui.ImVec2(imgui.GetMiddleButtonX(4), 25 * settings.general.custom_dpi)) then
					local text = u8:decode(ffi.string(input_edit_text)) .. 'л/д '
					imgui.StrCopy(input_edit_text, u8(text))
				end
				imgui.SameLine()
				if imgui.Button(u8('г/ф'), imgui.ImVec2(imgui.GetMiddleButtonX(4), 25 * settings.general.custom_dpi)) then
					local text = u8:decode(ffi.string(input_edit_text)) .. 'г/ф '
					imgui.StrCopy(input_edit_text, u8(text))
				end

				if imgui.Button(u8('в/т'), imgui.ImVec2(imgui.GetMiddleButtonX(4), 25 * settings.general.custom_dpi)) then
					local text = u8:decode(ffi.string(input_edit_text)) .. 'в/т '
					imgui.StrCopy(input_edit_text, u8(text))
				end
				imgui.SameLine()
				if imgui.Button(u8('м/т'), imgui.ImVec2(imgui.GetMiddleButtonX(4), 25 * settings.general.custom_dpi)) then
					local text = u8:decode(ffi.string(input_edit_text)) .. 'м/т '
					imgui.StrCopy(input_edit_text, u8(text))
				end
				imgui.SameLine()
				if imgui.Button(u8('с/м'), imgui.ImVec2(imgui.GetMiddleButtonX(4), 25 * settings.general.custom_dpi)) then
					local text = u8:decode(ffi.string(input_edit_text)) .. 'с/м '
					imgui.StrCopy(input_edit_text, u8(text))
				end
				imgui.SameLine()
				if imgui.Button(u8('в/с'), imgui.ImVec2(imgui.GetMiddleButtonX(4), 25 * settings.general.custom_dpi)) then
					local text = u8:decode(ffi.string(input_edit_text)) .. 'в/с '
					imgui.StrCopy(input_edit_text, u8(text))
				end

				if imgui.Button(u8('д/т'), imgui.ImVec2(imgui.GetMiddleButtonX(4), 25 * settings.general.custom_dpi)) then
					local text = u8:decode(ffi.string(input_edit_text)) .. 'д/т '
					imgui.StrCopy(input_edit_text, u8(text))
				end
				imgui.SameLine()
				if imgui.Button(u8('р/с'), imgui.ImVec2(imgui.GetMiddleButtonX(4), 25 * settings.general.custom_dpi)) then
					local text = u8:decode(ffi.string(input_edit_text)) .. 'р/с '
					imgui.StrCopy(input_edit_text, u8(text))
				end
				imgui.SameLine()
				if imgui.Button(u8('о/п'), imgui.ImVec2(imgui.GetMiddleButtonX(4), 25 * settings.general.custom_dpi)) then
					local text = u8:decode(ffi.string(input_edit_text)) .. 'о/п '
					imgui.StrCopy(input_edit_text, u8(text))
				end
				imgui.SameLine()
				if imgui.Button(u8('п/м'), imgui.ImVec2(imgui.GetMiddleButtonX(4), 25 * settings.general.custom_dpi)) then
					local text = u8:decode(ffi.string(input_edit_text)) .. 'п/м '
					imgui.StrCopy(input_edit_text, u8(text))
				end

				if imgui.Button(u8('а/с'), imgui.ImVec2(imgui.GetMiddleButtonX(4), 25 * settings.general.custom_dpi)) then
					local text = u8:decode(ffi.string(input_edit_text)) .. 'а/с '
					imgui.StrCopy(input_edit_text, u8(text))
				end
				imgui.SameLine()
				if imgui.Button(u8('п/т'), imgui.ImVec2(imgui.GetMiddleButtonX(4), 25 * settings.general.custom_dpi)) then
					local text = u8:decode(ffi.string(input_edit_text)) .. 'п/т '
					imgui.StrCopy(input_edit_text, u8(text))
				end
				imgui.SameLine()
				if imgui.Button(u8('б/з'), imgui.ImVec2(imgui.GetMiddleButtonX(4), 25 * settings.general.custom_dpi)) then
					local text = u8:decode(ffi.string(input_edit_text)) .. 'б/з '
					imgui.StrCopy(input_edit_text, u8(text))
				end
				imgui.SameLine()
				if imgui.Button(u8('н/з'), imgui.ImVec2(imgui.GetMiddleButtonX(4), 25 * settings.general.custom_dpi)) then
					local text = u8:decode(ffi.string(input_edit_text)) .. 'н/з '
					imgui.StrCopy(input_edit_text, u8(text))
				end

				if imgui.Button(u8('л/о'), imgui.ImVec2(imgui.GetMiddleButtonX(4), 25 * settings.general.custom_dpi)) then
					local text = u8:decode(ffi.string(input_edit_text)) .. 'л/о '
					imgui.StrCopy(input_edit_text, u8(text))
				end
				imgui.SameLine()
				if imgui.Button(u8('м/ф'), imgui.ImVec2(imgui.GetMiddleButtonX(4), 25 * settings.general.custom_dpi)) then
					local text = u8:decode(ffi.string(input_edit_text)) .. 'м/ф '
					imgui.StrCopy(input_edit_text, u8(text))
				end
				imgui.SameLine()
				if imgui.Button(u8('ч/д'), imgui.ImVec2(imgui.GetMiddleButtonX(4), 25 * settings.general.custom_dpi)) then
					local text = u8:decode(ffi.string(input_edit_text)) .. 'ч/д '
					imgui.StrCopy(input_edit_text, u8(text))
				end
				imgui.SameLine()
				if imgui.Button(u8('в/о'), imgui.ImVec2(imgui.GetMiddleButtonX(4), 25 * settings.general.custom_dpi)) then
					local text = u8:decode(ffi.string(input_edit_text)) .. 'в/о '
					imgui.StrCopy(input_edit_text, u8(text))
				end
				imgui.EndChild()
			end	
			imgui.SameLine()
			if imgui.BeginChild('##3', imgui.ImVec2(100 * settings.general.custom_dpi, 155 * settings.general.custom_dpi), true) then	
				if imgui.Button(u8('Цена:'), imgui.ImVec2(imgui.GetMiddleButtonX(1), 25 * settings.general.custom_dpi)) then
					local text = u8:decode(ffi.string(input_edit_text)) .. ' Цена: '
					imgui.StrCopy(input_edit_text, u8(text))
				end
				if imgui.Button(u8('Цена за шт:'), imgui.ImVec2(imgui.GetMiddleButtonX(1), 25 * settings.general.custom_dpi)) then
					local text = u8:decode(ffi.string(input_edit_text)) .. ' Цена за шт: '
					imgui.StrCopy(input_edit_text, u8(text))
				end
				if imgui.Button(u8('Договорная'), imgui.ImVec2(imgui.GetMiddleButtonX(1), 25 * settings.general.custom_dpi)) then
					local text = u8:decode(ffi.string(input_edit_text)) .. 'Договорная'
					imgui.StrCopy(input_edit_text, u8(text))
				end
				if imgui.Button(u8('Бюджет:'), imgui.ImVec2(imgui.GetMiddleButtonX(1), 25 * settings.general.custom_dpi)) then
					local text = u8:decode(ffi.string(input_edit_text)) .. ' Бюджет: '
					imgui.StrCopy(input_edit_text, u8(text))
				end
				if imgui.Button(u8('Свободный'), imgui.ImVec2(imgui.GetMiddleButtonX(1), 25 * settings.general.custom_dpi)) then
					local text = u8:decode(ffi.string(input_edit_text)) .. 'Свободный'
					imgui.StrCopy(input_edit_text, u8(text))
				end
				imgui.EndChild()
			end	
			imgui.SameLine()
			if imgui.BeginChild('##4', imgui.ImVec2(150 * settings.general.custom_dpi, 155 * settings.general.custom_dpi), true) then
				-- Перший рядок
				if imgui.Button(u8('1'), imgui.ImVec2(imgui.GetMiddleButtonX(3), 25 * settings.general.custom_dpi)) then
					local text = u8:decode(ffi.string(input_edit_text)) .. '1'
					imgui.StrCopy(input_edit_text, u8(text))
				end
				imgui.SameLine()
			
				if imgui.Button(u8('2'), imgui.ImVec2(imgui.GetMiddleButtonX(3), 25 * settings.general.custom_dpi)) then
					local text = u8:decode(ffi.string(input_edit_text)) .. '2'
					imgui.StrCopy(input_edit_text, u8(text))
				end
				imgui.SameLine()
			
				if imgui.Button(u8('3'), imgui.ImVec2(imgui.GetMiddleButtonX(3), 25 * settings.general.custom_dpi)) then
					local text = u8:decode(ffi.string(input_edit_text)) .. '3'
					imgui.StrCopy(input_edit_text, u8(text))
				end
			
				-- Другий рядок
				if imgui.Button(u8('4'), imgui.ImVec2(imgui.GetMiddleButtonX(3), 25 * settings.general.custom_dpi)) then
					local text = u8:decode(ffi.string(input_edit_text)) .. '4'
					imgui.StrCopy(input_edit_text, u8(text))
				end
				imgui.SameLine()
			
				if imgui.Button(u8('5'), imgui.ImVec2(imgui.GetMiddleButtonX(3), 25 * settings.general.custom_dpi)) then
					local text = u8:decode(ffi.string(input_edit_text)) .. '5'
					imgui.StrCopy(input_edit_text, u8(text))
				end
				imgui.SameLine()
			
				if imgui.Button(u8('6'), imgui.ImVec2(imgui.GetMiddleButtonX(3), 25 * settings.general.custom_dpi)) then
					local text = u8:decode(ffi.string(input_edit_text)) .. '6'
					imgui.StrCopy(input_edit_text, u8(text))
				end
			
				-- Третій рядок
				if imgui.Button(u8('7'), imgui.ImVec2(imgui.GetMiddleButtonX(3), 25 * settings.general.custom_dpi)) then
					local text = u8:decode(ffi.string(input_edit_text)) .. '7'
					imgui.StrCopy(input_edit_text, u8(text))
				end
				imgui.SameLine()
			
				if imgui.Button(u8('8'), imgui.ImVec2(imgui.GetMiddleButtonX(3), 25 * settings.general.custom_dpi)) then
					local text = u8:decode(ffi.string(input_edit_text)) .. '8'
					imgui.StrCopy(input_edit_text, u8(text))
				end
				imgui.SameLine()
			
				if imgui.Button(u8('9'), imgui.ImVec2(imgui.GetMiddleButtonX(3), 25 * settings.general.custom_dpi)) then
					local text = u8:decode(ffi.string(input_edit_text)) .. '9'
					imgui.StrCopy(input_edit_text, u8(text))
				end
			
				-- Четвертий рядок
				if imgui.Button(u8('.'), imgui.ImVec2(imgui.GetMiddleButtonX(3), 25 * settings.general.custom_dpi)) then
					local text = u8:decode(ffi.string(input_edit_text)) .. '.'
					imgui.StrCopy(input_edit_text, u8(text))
				end
				imgui.SameLine()
			
				if imgui.Button(u8('0'), imgui.ImVec2(imgui.GetMiddleButtonX(3), 25 * settings.general.custom_dpi)) then
					local text = u8:decode(ffi.string(input_edit_text)) .. '0'
					imgui.StrCopy(input_edit_text, u8(text))
				end
				imgui.SameLine()
			
				if imgui.Button(u8('$'), imgui.ImVec2(imgui.GetMiddleButtonX(3), 25 * settings.general.custom_dpi)) then
					local text = u8:decode(ffi.string(input_edit_text)) .. '$'
					imgui.StrCopy(input_edit_text, u8(text))
				end
			
				if imgui.Button(u8(' с гравировкой +'), imgui.ImVec2(imgui.GetMiddleButtonX(1), 25 * settings.general.custom_dpi)) then
					local text = u8:decode(ffi.string(input_edit_text)) .. ' с гравировкой +'
					imgui.StrCopy(input_edit_text, u8(text))
				end

				imgui.EndChild()
			end
			imgui.Separator()
		end
		if isMonetLoader() then
			if imgui.Button(fa.CIRCLE_ARROW_RIGHT .. u8" Опубликовать", imgui.ImVec2(imgui.GetMiddleButtonX(3), 25 * settings.general.custom_dpi)) then
				send_ad()
			end
		else
			if imgui.Button(fa.CIRCLE_ARROW_RIGHT .. u8" Опубликовать [ENTER]", imgui.ImVec2(imgui.GetMiddleButtonX(3), 25 * settings.general.custom_dpi)) then
				send_ad()
			end
		end
		imgui.SameLine()
		if imgui.Button(fa.CIRCLE_XMARK .. u8' Отклонить', imgui.ImVec2(imgui.GetMiddleButtonX(3), 25 * settings.general.custom_dpi)) then
			if u8:decode(ffi.string(input_edit_text)) == '' then
				reason_cancel = 'Отказ ПРО'
			else
				reason_cancel = u8:decode(ffi.string(input_edit_text))
			end
			sampSendDialogResponse(ad_dialog_id, 0, 0, reason_cancel)
			imgui.StrCopy(input_edit_text, '')
			EditWindow[0] = false
		end
		imgui.SameLine()
		if imgui.Button(fa.CIRCLE_XMARK .. u8' Пропустить', imgui.ImVec2(imgui.GetMiddleButtonX(3), 25 * settings.general.custom_dpi)) then
			skip_dialog = true
			sampSendChat('/mm')
			imgui.StrCopy(input_edit_text, '')
			EditWindow[0] = false
		end
		imgui.End()
    end
)

imgui.OnFrame(
    function() return DeportamentWindow[0] end,
    function(player)
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.Begin(fa.BUILDING_SHIELD .. " SMI Helper - " .. fa.WALKIE_TALKIE .. u8" Рация депортамента", DeportamentWindow, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize)
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
						change_dpi()
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
			change_dpi()
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
				sampAddChatMessage('[SMI Helper] {ffffff}Данная функция доступа только на ПК!', message_color)
			else
				if hotkey_no_errors then
					if ComboTags[0] == 0 then
						if settings.general.use_binds then 
							imgui.OpenPopup(fa.KEYBOARD .. u8' Бинд для команды /' .. change_cmd)
						else
							sampAddChatMessage('[SMI Helper] {ffffff}Сначало включите рабоспособность хоткеев в "Команды и RP отыгровки" - "Доп. функции"', message_color)
						end
					else
						sampAddChatMessage('[SMI Helper] {ffffff}Данная функция доступа только если команда "Без аргументов"', message_color)
					end
				else
					sampAddChatMessage('[SMI Helper] {ffffff}Данная функция недоступа, причина отсуствуют файлы библиотеки mimgui_hotkeys!', message_color)
				end
			end
		end
		if imgui.BeginPopupModal(fa.KEYBOARD .. u8' Бинд для команды /' .. change_cmd, _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize  + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.AlwaysAutoResize) then
			local hotkeyObject = hotkeys[change_cmd .. "HotKey"]
			if hotkeyObject then
				imgui.CenterText(u8('Клавиша активации бинда:'))
				local calc
				--print(change_bind)
				if change_bind == '{}' or change_bind == '[]' then
					calc = imgui.CalcTextSize('< click and select keys >')
				else
					calc = imgui.CalcTextSize(getNameKeysFrom(change_bind))
				end
				
				local width = imgui.GetWindowWidth()
				imgui.SetCursorPosX(width / 2 - calc.x / 2)
				if hotkeyObject:ShowHotKey() then
					change_bind = encodeJson(hotkeyObject:GetHotKey())
					sampAddChatMessage('[SMI Helper] {ffffff}Создан хоткей для команды ' .. message_color_hex .. '/' .. change_cmd .. ' {ffffff}на клавишу '  .. message_color_hex .. getNameKeysFrom(change_bind), message_color)
				end
			else
				local hotkeyName = change_cmd.. "HotKey"
				hotkeys[hotkeyName] = hotkey.RegisterHotKey(hotkeyName, false, decodeJson(change_bind), function()
					sampProcessChatInput('/' .. change_cmd)
				end)
				--sampAddChatMessage('[SMI Helper] {ffffff}Создан новый хоткей, необходимо пересоздать интерфейс. Откройте заново эту менюшку', message_color)
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
				local new_text = u8:decode(ffi.string(input_text)):gsub('\n', '&')
				local new_bind = change_bind
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
						command.bind = new_bind
						command.enable = true
						checker = true
						save_settings()
						if command.arg == '' then
							sampAddChatMessage('[SMI Helper] {ffffff}Команда ' .. message_color_hex .. '/' .. new_command .. ' {ffffff}успешно сохранена!', message_color)
						elseif command.arg == '{arg}' then
							sampAddChatMessage('[SMI Helper] {ffffff}Команда ' .. message_color_hex .. '/' .. new_command .. ' [аргумент] {ffffff}успешно сохранена!', message_color)
						elseif command.arg == '{arg_id}' then
							sampAddChatMessage('[SMI Helper] {ffffff}Команда ' .. message_color_hex .. '/' .. new_command .. ' [ID игрока] {ffffff}успешно сохранена!', message_color)
						elseif command.arg == '{arg_id} {arg2}' then
							sampAddChatMessage('[SMI Helper] {ffffff}Команда ' .. message_color_hex .. '/' .. new_command .. ' [ID игрока] [аргумент] {ffffff}успешно сохранена!', message_color)
						elseif command.arg == '{arg_id} {arg2} {arg3}' then
							sampAddChatMessage('[SMI Helper] {ffffff}Команда ' .. message_color_hex .. '/' .. new_command .. ' [ID игрока] [аргумент] [аргумент] {ffffff}успешно сохранена!', message_color)
						end
						sampUnregisterChatCommand(change_cmd)
						register_command(command.cmd, command.arg, command.text, tonumber(command.waiting))
						break
					end
				end
				if not checker then
					sampAddChatMessage('[SMI Helper] {ffffff}ОШИБКА #787 ПРИ СОХРАНЕНИИ КОМАНДЫ ' .. message_color_hex .. '/' .. new_command .. ' {ffffff}!', message_color)
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
		imgui.Begin(fa.BUILDING_SHIELD.." SMI Helper##rank", GiveRankMenu, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize  + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.AlwaysAutoResize)
		change_dpi()
		imgui.CenterText(u8'Выберите ранг для '.. sampGetPlayerNickname(player_id) .. ':')
		imgui.PushItemWidth(250 * settings.general.custom_dpi)
		imgui.SliderInt('', giverank, 1, 9)
		imgui.Separator()
		local text
		if isMonetLoader() then
			text = " Выдать ранг"
		else
			text = " Выдать ранг [Enter]"
		end
		if imgui.Button(fa.USER .. u8(text) , imgui.ImVec2(imgui.GetMiddleButtonX(1), 0)) then
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
		imgui.Begin(fa.BUILDING_SHIELD.." SMI Helper##CommandStopWindow", _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize  + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.AlwaysAutoResize )
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
		imgui.Begin(fa.BUILDING_SHIELD.." SMI Helper##CommandPauseWindow", _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize  + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.AlwaysAutoResize )
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
    function() return InformationWindow[0] end,
    function(player)
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.Begin(fa.BUILDING_SHIELD .. u8" SMI Helper - Оповещение##info_menu", _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize  + imgui.WindowFlags.AlwaysAutoResize  )
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
			sampAddChatMessage('[SMI Helper] {ffffff}Настройки хелпера успешно сброшены! Перезагрузка...', message_color)
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
			sampAddChatMessage('[SMI Helper] {ffffff}Прозиошла ошибка, ID игрока недействителен!', message_color)
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
	imgui.GetStyle().Colors[imgui.Col.NavWindowingDimBg] = ColorAccentsAdapter(generated_color.accent1.color_200):apply_alpha(0x99):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.ModalWindowDimBg] = ColorAccentsAdapter(generated_color.accent1.color_200):apply_alpha(0x99):as_vec4()
end
function argbToHexWithoutAlpha(alpha, red, green, blue)
    return string.format("%02X%02X%02X", red, green, blue)
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
if not isMonetLoader() then
	function onWindowMessage(msg, wparam, lparam)
		if(msg == 0x100 or msg == 0x101) then
			if (wparam == 13 and EditWindow[0]) and not isPauseMenuActive() then
				consumeWindowMessage(true, false)
				if (msg == 0x101) then
					send_ad()
				end
			elseif (wparam == 13 and GiveRankMenu[0]) and not isPauseMenuActive() then
				consumeWindowMessage(true, false)
				if (msg == 0x101) then
					GiveRankMenu[0] = false
					give_rank()
				end
			end
		end
	end
end
function onScriptTerminate(script, game_quit)
    if script == thisScript() and not game_quit and not reload_script then
		sampAddChatMessage('[SMI Helper] {ffffff}Произошла неизвестная ошибка, хелпер приостановил свою работу!', message_color)
		if not isMonetLoader() then 
			sampAddChatMessage('[SMI Helper] {ffffff}Используйте ' .. message_color_hex .. 'CTRL {ffffff}+ ' .. message_color_hex .. 'R {ffffff}чтобы перезапустить хелпер.', message_color)
		end
		play_error_sound()
    end
end