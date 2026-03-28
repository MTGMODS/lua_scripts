---@diagnostic disable: undefined-global, lowercase-global

script_name("Deposite Calсulator")
script_author("MTG MODS")
script_version(5)

require "lib.moonloader"
require 'encoding'.default = 'CP1251'
local u8 = require 'encoding'.UTF8
local ffi = require 'ffi'

local inicfg = require 'inicfg'
local my_ini = "Deposite_Calсulator.ini"
local settings = inicfg.load({
	general = {
		my_deposite = 0,
		my_rank = 0,
		my_houses = 0,
		my_vip = 0,
		my_dep_lvl = 0,
		my_insurance = 0,
		my_lavka = 0,
		my_gramota = 0,
		my_skin_tron = 0,
		my_ring_tron = 0,
		fix = "nil" --5.791
    }
}, my_ini)

local def_bonus = { -- на случай если гитхаб недоступен, чтоб скрипт не умер
	house_max_deposite = 6000000,
	insurance = 15,
	lavka = 12,
	gramota_veterana = 7,
	skin_tron = 12,
	ring_tron = 8,
	vip_profit = {
		1500, -- no vip
		1150, -- titan vip
		800 -- premium vip
	},
	dep_lvl_max_dep = {
		0,
		20000000, -- 1
		30000000, -- 2
		50000000, -- 3
		70000000, -- 4
		100000000 -- 5
	},
	dep_lvl_bonus = {
		0,  -- 0
		5,  -- 1
		10, -- 2
		18, -- 3
		26, -- 4
		35  -- 5
	},
	fraction_rank = {
		15, -- 1 - 3
		25, -- 4 - 7
		30  -- 8 - 10
	}
}
local bonus = {}

function isMonetLoader() return MONET_VERSION ~= nil end
if MONET_DPI_SCALE == nil then MONET_DPI_SCALE = 1.0 end

local fa = require('fAwesome6_solid')
local imgui = require('mimgui')
local new = imgui.new
local MainWindow  = new.bool()
local my_insurance = new.int(settings.general.my_insurance)
local my_lavka = new.int(settings.general.my_lavka)
local my_gramota = new.int(settings.general.my_gramota)
local my_houses = new.int(settings.general.my_houses)
local my_vip = new.int(settings.general.my_vip)
local my_dep_lvl = new.int(settings.general.my_dep_lvl)
local my_rank = new.int(settings.general.my_rank)
local my_skin_tron = new.int(settings.general.my_skin_tron)
local my_ring_tron = new.int(settings.general.my_ring_tron)
local input_fix = new.char[256](u8(settings.general.fix))

local sizeX, sizeY = getScreenResolution()

local check_stats = false

local newdeposite_bool = false
local newdeposite = 0

function main()

	if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(0) end 
	
	sampAddChatMessage('{ff0000}[INFO] {ffffff}Скрипт "Deposite Calculator" загружен и готов к работе! Автор: MTG MODS | Версия: 5 | Используйте {00ccff}/deposite',-1)
	
	sampRegisterChatCommand("deposite", function() 
		check_stats = true 
		sampSendChat('/stats') 
		MainWindow[0] = not MainWindow[0] 
	end)
	
	sampRegisterChatCommand("newdeposite", function(param) 
		if param:find("%d") and not param:find("%D") then 
			newdeposite_bool = true 
			newdeposite = param
		else
			sampAddChatMessage('{ff0000}[INFO] {ffffff}Используйте {00ccff}/deposite [значение]',-1)
		end
	end)

	-- download_dep_bonuse_info()
	bonus = def_bonus
	
end	

require("samp.events").onShowDialog = function(dialogid, style, title, button1, button2, text)
	if check_stats and title:find("Основная статистика") then
		if text:find("{FFFFFF}Деньги на депозите: {B83434}%[(.+)%](.+){FFFFFF}Работа") then
			local deposite_text = text:match("{FFFFFF}Деньги на депозите: {B83434}%[(.+)%](.+){FFFFFF}Работа")
			local deposite = deposite_text:gsub("%D", "")
			settings.general.my_deposite = tonumber(deposite)
			inicfg.save(settings, my_ini)
		end
		if text:find("{FFFFFF}Должность: {B83434}(.+)%((%d+)%)") then
			local rank, rank_number = text:match("{FFFFFF}Должность: {B83434}(.+)%((%d+)%)(.+)Уровень розыска")
			my_rank[0] = tonumber(rank_number)
			settings.general.my_rank = tonumber(rank_number)
			inicfg.save(settings, my_ini)
		end
		if text:find("{FFFFFF}Статус: {B83434}%[(.+)%](.+){FFFFFF}Гражданство") then
			local vip = text:match("{FFFFFF}Статус: {B83434}%[(.+)%](.+){FFFFFF}Гражданство")
			if vip == 'Premium' then
				my_vip[0] = 2
			elseif vip == 'Titan' then
				my_vip[0] = 1
			elseif vip == 'Не имеется' then
				my_vip[0] = 0
			end
			settings.general.my_vip = my_vip[0]
			inicfg.save(settings, my_ini)
		end
		sampSendDialogResponse(dialogid, 0,0,0)
		check_stats = false
		return false
	end
end

function getMyDeposite()
	return newdeposite_bool and tonumber(newdeposite) or settings.general.my_deposite or 0
end
function getMaxDepositeBonusLVL()
	return bonus.dep_lvl_max_dep[settings.general.my_dep_lvl + 1]
end
function getMaxDeposite()
	return 200000000 + (bonus.house_max_deposite * settings.general.my_houses) + getMaxDepositeBonusLVL()
end
function getVipProfit()
	return bonus.vip_profit[my_vip[0] + 1]
end
function getPercentBonus()
	local percent = 0

	if my_insurance[0] == 1 then
	    percent = percent + bonus.insurance
	end

	if my_rank[0] >= 1 and my_rank[0] <= 3 then
		percent = percent + bonus.fraction_rank[1]
	elseif my_rank[0] >= 4 and my_rank[0] <= 7 then
		percent = percent + bonus.fraction_rank[2]
	elseif my_rank[0] >= 8 and my_rank[0] <= 10 then
		percent = percent + bonus.fraction_rank[3]
	end

	if my_lavka[0] == 1 then
		percent = percent + bonus.lavka
	end

	if my_gramota[0] == 1 then
		percent = percent + bonus.gramota_veterana
	end

	if my_dep_lvl[0] ~= 0 then
		percent = percent + bonus.dep_lvl_bonus[tonumber(my_dep_lvl[0]) + 1]
	end

	if my_skin_tron[0] == 1 then
		percent = percent + bonus.skin_tron
	end

	if my_ring_tron[0] == 1 then
		percent = percent + bonus.ring_tron
	end
	
	return tonumber(percent)
end
function getDeposite()
	local deposite = getMyDeposite()
	local max_deposite = getMaxDeposite()
	if deposite > max_deposite then
		deposite = max_deposite
	end
	local my_deposite = deposite / getVipProfit()
	local my_deposite_prefinal = my_deposite + (my_deposite / 100) * getPercentBonus()
	local deposite_fix = 0
	if settings.general.fix and tonumber(settings.general.fix) then
		deposite_fix = ( my_deposite_prefinal / 100 ) * tonumber(settings.general.fix)
	end
	local final_deposite = my_deposite_prefinal - deposite_fix
	return math.floor(final_deposite/2)
end
function gotoFullDeposite()
	local currentDeposit = getMyDeposite()
	local maxDeppsot = getMaxDeposite()
	if currentDeposit >= maxDeppsot or currentDeposit <= 0 then
		return 0
	end
	local vipProfit = getVipProfit()
	local percent_bonus = getPercentBonus()
	local fix_val = (settings.general.fix and tonumber(settings.general.fix)) or 0
	local iterations = 0
	while currentDeposit < maxDeppsot do
		local my_deposite = currentDeposit / vipProfit
		local my_deposite_bonus = my_deposite + (my_deposite / 100) * percent_bonus
		local deposite_fix = (my_deposite_bonus / 100) * fix_val
		local final_deposite = math.floor((my_deposite_bonus - deposite_fix) / 2)
		if final_deposite <= 0 then break end
		currentDeposit = currentDeposit + final_deposite
		iterations = iterations + 1
	end
	return iterations
end
function comma_value(n) -- by Royan_Millans and YarikVL
	local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(.-)$')
	return (left..(num:reverse():gsub('(%d%d%d)','%1,'):reverse())..right) or n
end

-- function download_dep_bonuse_info()
-- 	print('[Deposite Calculator] Использую стандартные данные про бонусы от депозита!')
-- 	bonus = def_bonus
	
-- 	print('[Deposite Calculator] Пытаюсь с облака получить инфу про бонусы от депозита...')

-- 	local path = getWorkingDirectory():gsub('\\','/') .. "/config/Deposite_Bonuse.json"
-- 	os.remove(path)

-- 	local url = 'https://raw.githubusercontent.com/MTGMODS/lua_scripts/main/dep_calculator/Deposite_Bonuse.json'

-- 	if isMonetLoader() then
-- 		local function downloadToFile(url, path, callback, progressInterval)
-- 			callback = callback or function() end
-- 			progressInterval = progressInterval or 0.1
		
-- 			local effil = require("effil")
-- 			local progressChannel = effil.channel(0)
		
-- 			local runner = effil.thread(function(url, path)
-- 			local http = require("socket.http")
-- 			local ltn = require("ltn12")
		
-- 			local r, c, h = http.request({
-- 				method = "HEAD",
-- 				url = url,
-- 			})
		
-- 			if c ~= 200 then
-- 				return false, c
-- 			end
-- 			local total_size = h["content-length"]
		
-- 			local f = io.open(path, "wb")
-- 			if not f then
-- 				return false, "failed to open file"
-- 			end
-- 			local success, res, status_code = pcall(http.request, {
-- 				method = "GET",
-- 				url = url,
-- 				sink = function(chunk, err)
-- 				local clock = os.clock()
-- 				if chunk and not lastProgress or (clock - lastProgress) >= progressInterval then
-- 					progressChannel:push("downloading", f:seek("end"), total_size)
-- 					lastProgress = os.clock()
-- 				elseif err then
-- 					progressChannel:push("error", err)
-- 				end
		
-- 				return ltn.sink.file(f)(chunk, err)
-- 				end,
-- 			})
		
-- 			if not success then
-- 				return false, res
-- 			end
		
-- 			if not res then
-- 				return false, status_code
-- 			end
		
-- 			return true, total_size
-- 			end)
-- 			local thread = runner(url, path)
		
-- 			local function checkStatus()
-- 			local tstatus = thread:status()
-- 			if tstatus == "failed" or tstatus == "completed" then
-- 				local result, value = thread:get()
		
-- 				if result then
-- 				callback("finished", value)
-- 				else
-- 				callback("error", value)
-- 				end
		
-- 				return true
-- 			end
-- 			end
		
-- 			lua_thread.create(function()
-- 			if checkStatus() then
-- 				return
-- 			end
		
-- 			while thread:status() == "running" do
-- 				if progressChannel:size() > 0 then
-- 				local type, pos, total_size = progressChannel:pop()
-- 				callback(type, pos, total_size)
-- 				end
-- 				wait(0)
-- 			end
		
-- 			checkStatus()
-- 			end)
-- 		end
-- 		downloadToFile(url, path, function(type, pos, total_size)
-- 			if type == "finished" then
-- 				local result = readJsonFile(path)
-- 				if result then
-- 					bonus = result
-- 					print('[Deposite Calculator] Информация успешно получена!')
-- 				end
-- 			end
-- 		end)
-- 	else
-- 		downloadUrlToFile(url, path, function(id, status)
-- 			if status == 6 then -- ENDDOWNLOADDATA
-- 				local result = readJsonFile(path)
-- 				if result then
-- 					bonus = result
-- 					print('[Deposite Calculator] Информация успешно получена!')
-- 				end
-- 			end
-- 		end)
-- 	end
-- 	function readJsonFile(filePath)
-- 		if not doesFileExist(filePath) then
-- 			print("[Deposite Calculator] Ошибка: Файл " .. filePath .. " не существует")
-- 			return nil
-- 		end
-- 		local file = io.open(filePath, "r")
-- 		local content = file:read("*a")
-- 		file:close()
-- 		local jsonData = decodeJson(content)
-- 		if not jsonData then
-- 			print("[Deposite Calculator] Ошибка: Неверный формат JSON в файле " .. filePath)
-- 			return nil
-- 		end
-- 		return jsonData
-- 	end
-- end

imgui.OnInitialize(function()
	imgui.GetIO().IniFilename = nil
	fa.Init(14 * MONET_DPI_SCALE)
	dark_theme()
end)
imgui.OnFrame(
    function() return MainWindow[0] end,
    function(main_window)
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(800 * MONET_DPI_SCALE, 580 * MONET_DPI_SCALE), imgui.Cond.FirstUseEver)
		imgui.Begin(fa.LANDMARK.." Deposite Calculator by MTG MODS", MainWindow, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize)
		if imgui.BeginChild('##1', imgui.ImVec2(790 * MONET_DPI_SCALE, 65 * MONET_DPI_SCALE), true) then
			local my_deposite = getMyDeposite()
			local max_deposite = getMaxDeposite()
			imgui.CenterText(fa.MONEY_CHECK_DOLLAR..u8' Денег на вашем депозите: $' .. comma_value(my_deposite) .. ' / $' .. comma_value(max_deposite))
			if my_deposite > max_deposite then 
				imgui.CenterTextDisabled(u8"У вас на депозите $" .. comma_value(my_deposite - max_deposite) .. u8" лишние, с них прибыль не идёт, и их можно снять")
				imgui.SameLine()
				if imgui.SmallButton(fa.COPY .. ' ' .. my_deposite - max_deposite) then
					setClipboardText(tostring(my_deposite - max_deposite))
					sampAddChatMessage('{00ccff}[INFO] {ffffff}Лишняя сумма успешно скопирована в буфер обмена!', -1)
				end
			elseif my_deposite >= 10000 and my_deposite < max_deposite then
				local paydays = gotoFullDeposite()
				imgui.CenterTextDisabled(u8"Чтобы иметь максимальную прибыль с депозита, пополните его ещё на $" .. comma_value(max_deposite - my_deposite) .. u8" либо ожидайте " .. paydays .. " (" .. math.floor(paydays/4) .. u8" если X4) PAYDAY")
			elseif my_deposite == max_deposite then
				imgui.CenterTextDisabled(u8"Ваш депозит полностю заполнением, и теперь вы каждый PAYDAY будете иметь прибыль, которую можно снимать")
			elseif my_deposite == 0 or my_deposite < 10000 then
				imgui.CenterTextDisabled(u8"Депозит не приносит прибыль, у вас нету минимальной суммы $10000!")
			end
			imgui.CenterTextDisabled(u8"Чтобы указать другое кол-во денег на депозите вместо использования данных из /stats, введите /newdeposite [значение]")
			imgui.EndChild()
		end
		if imgui.BeginChild('##2', imgui.ImVec2(790 * MONET_DPI_SCALE, 100 * MONET_DPI_SCALE), true) then
			imgui.CenterText(fa.SACK_DOLLAR..u8' Подсчёт прибыли с депозита учитывая указанные условия:')
			local deposite = getDeposite()
			imgui.Separator()
			imgui.Columns(4)
			imgui.CenterColumnText(u8'Простой PAYDAY')
			imgui.NextColumn()
			imgui.CenterColumnText(u8'Х2 PAYDAY (МП или Х2 дом)')
			imgui.NextColumn()
			imgui.CenterColumnText(u8'Х3 PAYDAY (для новичков)')
			imgui.NextColumn()
			imgui.CenterColumnText('X4 PAYDAY')
			imgui.Columns(1)
			imgui.Separator()
			imgui.Columns(4)
			imgui.CenterColumnText('$' .. comma_value(deposite))
			imgui.NextColumn()
			imgui.CenterColumnText('$' .. comma_value(deposite * 2))
			imgui.NextColumn()
			imgui.CenterColumnText('$' .. comma_value(deposite * 3))
			imgui.NextColumn()
			imgui.CenterColumnText('$' .. comma_value(deposite * 4))
			imgui.Columns(1)
			imgui.Separator()
			imgui.CenterTextDisabled(u8('(реальная прибыль может немного отличаться из-за настроек экономики сервера — определенного фикс-процента от ГА/КА)'))
			imgui.EndChild() 
		end
		if imgui.BeginChild('##3', imgui.ImVec2(790 * MONET_DPI_SCALE, 370 * MONET_DPI_SCALE), true) then
			imgui.CenterText(fa.CIRCLE_INFO .. u8' Укажите ваши условия, которые влияют на прибыль с депозита:')
			imgui.Separator()
			if imgui.CollapsingHeader(fa.CROWN .. u8' Ваш игровой VIP статус') then
				local numButtons = 3
				local buttonWidth = 100 * MONET_DPI_SCALE
				local totalButtonWidth = buttonWidth * numButtons + imgui.GetStyle().ItemSpacing.x * (numButtons - 1)
				local startPosX = (imgui.GetWindowWidth() - totalButtonWidth) / 2
				imgui.SetCursorPosX(startPosX)
				for i = 0, numButtons - 1 do
					if i > 0 then
						imgui.SameLine()
					end
					local label = ""
					if i == 0 then
						label = u8" Без VIP "
					-- elseif i == 1 then
					-- 	label = u8" Bronze VIP "
					-- elseif i == 2 then
					-- 	label = u8" Gold VIP "
					-- elseif i == 3 then
					-- 	label = u8" Platinum VIP "
					-- elseif i == 4 then
					-- 	label = u8" Diamond VIP "
					elseif i == 1 then
						label = u8" Titan VIP "
					elseif i == 2 then
						label = u8" Premium VIP "
					end
					imgui.SetCursorPosX(startPosX + i * (buttonWidth + imgui.GetStyle().ItemSpacing.x))
					if imgui.RadioButtonIntPtr(label, my_vip, i) then
						my_vip[0] = i
						settings.general.my_vip = my_vip[0]
						inicfg.save(settings, my_ini)
					end
				end
			end
			if imgui.IsItemHovered() then
				imgui.SetTooltip(u8'Уровень вашего VIP статуса существенно влияет на прибыль с депозита!\nPremium VIP даёт +50 процентов\nTitan VIP даёт +25 процентов')
			end
			imgui.Separator()
			if imgui.CollapsingHeader(fa.PIGGY_BANK .. u8' Ваш уровень прокачиваемого депозита') then
				local numButtons = 6
				local buttonWidth = 100 * MONET_DPI_SCALE
				local totalButtonWidth = buttonWidth * numButtons + imgui.GetStyle().ItemSpacing.x * (numButtons - 1)
				local startPosX = (imgui.GetWindowWidth() - totalButtonWidth) / 2
				imgui.SetCursorPosX(startPosX)
				for i = 0, numButtons - 1 do
					if i > 0 then
						imgui.SameLine()
					end

					local label = " " .. i .. " ##dep_lvl"
					
					imgui.SetCursorPosX(startPosX + i * (buttonWidth + imgui.GetStyle().ItemSpacing.x))
					if imgui.RadioButtonIntPtr(label, my_dep_lvl, i) then
						my_dep_lvl[0] = i
						settings.general.my_dep_lvl = my_dep_lvl[0]
						inicfg.save(settings, my_ini)
					end
				end
			end
			if imgui.IsItemHovered() then
				imgui.SetTooltip(u8'Уровень вашего депозита можно прокачивать в банке, каждый лвл (от 1 до 5) повышает прибыль')
			end
			imgui.Separator()
			if imgui.CollapsingHeader(fa.HOUSE .. u8' Количество домов с улучшением депозита (ваших + тех в которые вы заселены)') then
				for i = 0, 15 do
					if i > 0 then
						imgui.SameLine()
					end
					local label = " " .. tostring(i) .. "##houses"
					if imgui.RadioButtonIntPtr(label, my_houses, i) then
						my_houses[0] = i
						settings.general.my_houses = my_houses[0]
						inicfg.save(settings, my_ini)
					end
				end
				
			end
			if imgui.IsItemHovered() then
				imgui.SetTooltip(u8'Для каждого дома есть улучшение "Депозитные условия"\nДанное улучшение стоит $60,000,000\nУлучшенный дом повышает максимальный депозит на $6,000,000\nВы можете подселиться в такой дом, или купить его у игроков')
			end
			imgui.Separator()
			if imgui.CollapsingHeader(fa.USER .. u8' Ваша порядковая должность в организации (номер ранга)') then
				local numButtons = 11
				local buttonWidth = 50 * MONET_DPI_SCALE
				local totalButtonWidth = buttonWidth * numButtons + imgui.GetStyle().ItemSpacing.x * (numButtons - 1)
				local startPosX = (imgui.GetWindowWidth() - totalButtonWidth) / 2
				imgui.SetCursorPosX(startPosX)
				for i = 0, numButtons - 1 do
					if i > 0 then
						imgui.SameLine()
					end
					
					local label = u8" " .. tostring(i) .. " "
	
					imgui.SetCursorPosX(startPosX + i * (buttonWidth + imgui.GetStyle().ItemSpacing.x))
					if imgui.RadioButtonIntPtr(label, my_rank, i) then
						my_rank[0] = i
						settings.general.my_rank = my_rank[0]
						inicfg.save(settings, my_ini)
					end
				end
			end
			if imgui.IsItemHovered() then
				imgui.SetTooltip(u8'1 - 3 ранг даёт +15 процентов\n4 - 7 ранг даёт +25 процентов\n8 - 10 ранг даёт +30 процентов')
			end
			imgui.Separator()
			if imgui.CollapsingHeader(fa.FILE_INVOICE_DOLLAR .. u8' Наличие у вас улучшения "Пенсионне Страхование"') then
				local numButtons = 2
				local buttonWidth = 100 * MONET_DPI_SCALE
				local totalButtonWidth = buttonWidth * numButtons + imgui.GetStyle().ItemSpacing.x * (numButtons - 1)
				local startPosX = (imgui.GetWindowWidth() - totalButtonWidth) / 2
				imgui.SetCursorPosX(startPosX)
				for i = 0, numButtons - 1 do
					if i > 0 then
						imgui.SameLine()
					end
					
					local label
					if i == 0 then
						label = u8' Нету '
					elseif i == 1 then
						label = u8' Есть '
					end
	
					imgui.SetCursorPosX(startPosX + i * (buttonWidth + imgui.GetStyle().ItemSpacing.x))
					if imgui.RadioButtonIntPtr(label, my_insurance, i) then
						my_insurance[0] = i
						if my_insurance[0] == 0 then
							settings.general.my_insurance = false
							inicfg.save(settings, my_ini)
						else
							settings.general.my_insurance = true
							inicfg.save(settings, my_ini)
						end
					end
				end
			end
			if imgui.IsItemHovered() then
				imgui.SetTooltip(u8'Улучшение "Пенсионное Страхование" даёт +15 процентов к депозиту\nОно покупается в Страховой Компании за $200,000,000')
			end
			imgui.Separator()
			if imgui.CollapsingHeader(fa.BOX_ARCHIVE .. u8' Наличие у вас аксесуара "Элитная Лавка" / "Магическая Лавка" / "Рыбацкий Рюкзак"') then
				local numButtons = 2
				local buttonWidth = 100 * MONET_DPI_SCALE
				local totalButtonWidth = buttonWidth * numButtons + imgui.GetStyle().ItemSpacing.x * (numButtons - 1)
				local startPosX = (imgui.GetWindowWidth() - totalButtonWidth) / 2
				imgui.SetCursorPosX(startPosX)
				for i = 0, numButtons - 1 do
					if i > 0 then
						imgui.SameLine()
					end
					
					local label
					if i == 0 then
						label = u8' Нету ##lavka' 
					elseif i == 1 then
						label = u8' Есть ##lavka'
					end

					imgui.SetCursorPosX(startPosX + i * (buttonWidth + imgui.GetStyle().ItemSpacing.x))
					if imgui.RadioButtonIntPtr(label, my_lavka, i) then
						my_lavka[0] = i
						if my_lavka[0] == 0 then
							settings.general.my_lavka = false
							inicfg.save(settings, my_ini)
						else
							settings.general.my_lavka = true
							inicfg.save(settings, my_ini)
						end
					end
				end
			end
			if imgui.IsItemHovered() then
				imgui.SetTooltip(u8'Данный кксесуар даёт +12 процентов к депозиту')
			end
			imgui.Separator()
			if imgui.CollapsingHeader(fa.FILE .. u8' Наличие у вас "Грамоты Ветерана"') then
				imgui.PushItemWidth(50 * MONET_DPI_SCALE)
				imgui.SetCursorPosX(imgui.GetWindowWidth() / 2 - 25 * MONET_DPI_SCALE)
				local numButtons = 2
				local buttonWidth = 100 * MONET_DPI_SCALE
				local totalButtonWidth = buttonWidth * numButtons + imgui.GetStyle().ItemSpacing.x * (numButtons - 1)
				local startPosX = (imgui.GetWindowWidth() - totalButtonWidth) / 2
				imgui.SetCursorPosX(startPosX)
				for i = 0, numButtons - 1 do
					if i > 0 then
						imgui.SameLine()
					end
					local label
					if i == 0 then
						label = u8' Нету ##my_gramota' 
					elseif i == 1 then
						label = u8' Есть ##my_gramota'
					end

					imgui.SetCursorPosX(startPosX + i * (buttonWidth + imgui.GetStyle().ItemSpacing.x))
					if imgui.RadioButtonIntPtr(label, my_gramota, i) then
						my_gramota[0] = i
						if my_gramota[0] == 0 then
							settings.general.my_gramota = false
							inicfg.save(settings, my_ini)
						else
							settings.general.my_gramota = true
							inicfg.save(settings, my_ini)
						end
					end
				end
				imgui.Separator()
			end
			if imgui.IsItemHovered() then
				imgui.SetTooltip(u8'Грамота даёт +7 процентов к депозиту')
			end
			imgui.Separator()
			if imgui.CollapsingHeader(fa.FILE .. u8' Наличие у вас "Скин TRON"') then
				imgui.PushItemWidth(50 * MONET_DPI_SCALE)
				imgui.SetCursorPosX(imgui.GetWindowWidth() / 2 - 25 * MONET_DPI_SCALE)
				local numButtons = 2
				local buttonWidth = 100 * MONET_DPI_SCALE
				local totalButtonWidth = buttonWidth * numButtons + imgui.GetStyle().ItemSpacing.x * (numButtons - 1)
				local startPosX = (imgui.GetWindowWidth() - totalButtonWidth) / 2
				imgui.SetCursorPosX(startPosX)
				for i = 0, numButtons - 1 do
					if i > 0 then
						imgui.SameLine()
					end
					local label
					if i == 0 then
						label = u8' Нету ##skin_tron' 
					elseif i == 1 then
						label = u8' Есть ##skin_tron'
					end

					imgui.SetCursorPosX(startPosX + i * (buttonWidth + imgui.GetStyle().ItemSpacing.x))
					if imgui.RadioButtonIntPtr(label, my_skin_tron, i) then
						my_skin_tron[0] = i
						if my_skin_tron[0] == 0 then
							settings.general.my_skin_tron = false
							inicfg.save(settings, my_ini)
						else
							settings.general.my_skin_tron = true
							inicfg.save(settings, my_ini)
						end
					end
				end
				imgui.Separator()
			end
			if imgui.IsItemHovered() then
				imgui.SetTooltip(u8'Скин даёт +12 процентов к депозиту')
			end
			imgui.Separator()
			if imgui.CollapsingHeader(fa.FILE .. u8' Наличие у вас "Кольцо TRON"') then
				imgui.PushItemWidth(50 * MONET_DPI_SCALE)
				imgui.SetCursorPosX(imgui.GetWindowWidth() / 2 - 25 * MONET_DPI_SCALE)
				local numButtons = 2
				local buttonWidth = 100 * MONET_DPI_SCALE
				local totalButtonWidth = buttonWidth * numButtons + imgui.GetStyle().ItemSpacing.x * (numButtons - 1)
				local startPosX = (imgui.GetWindowWidth() - totalButtonWidth) / 2
				imgui.SetCursorPosX(startPosX)
				for i = 0, numButtons - 1 do
					if i > 0 then
						imgui.SameLine()
					end
					local label
					if i == 0 then
						label = u8' Нету ##my_ring_tron' 
					elseif i == 1 then
						label = u8' Есть ##my_ring_tron'
					end

					imgui.SetCursorPosX(startPosX + i * (buttonWidth + imgui.GetStyle().ItemSpacing.x))
					if imgui.RadioButtonIntPtr(label, my_ring_tron, i) then
						my_ring_tron[0] = i
						if my_ring_tron[0] == 0 then
							settings.general.my_ring_tron = false
							inicfg.save(settings, my_ini)
						else
							settings.general.my_ring_tron = true
							inicfg.save(settings, my_ini)
						end
					end
				end
				imgui.Separator()
			end
			if imgui.IsItemHovered() then
				imgui.SetTooltip(u8'Акс даёт +8 процентов к депозиту')
			end
			imgui.Separator()
			if imgui.CollapsingHeader(fa.CIRCLE_DOLLAR_TO_SLOT .. u8' Текущий процент фикса экономики (значение от ГА/КА, может быть от -25 до +25)') then
				imgui.PushItemWidth(50 * MONET_DPI_SCALE)
				imgui.SetCursorPosX(imgui.GetWindowWidth() / 2 - 25 * MONET_DPI_SCALE)
				if imgui.InputText(u8'%##fix', input_fix, 256) then
					settings.general.fix = u8:decode(ffi.string(input_fix))
					inicfg.save(settings, my_ini)
				end
				imgui.Separator()
			end
			imgui.EndChild()
		end
		imgui.End()
    end
)
function imgui.CenterColumnText(text)
    imgui.SetCursorPosX((imgui.GetColumnOffset() + (imgui.GetColumnWidth() / 2)) - imgui.CalcTextSize(text).x / 2)
    imgui.Text(text)
end
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
function dark_theme()

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
    imgui.GetStyle().Colors[imgui.Col.ModalWindowDimBg]       = imgui.ImVec4(0.00, 0.00, 0.00, 0.70)
	
end
