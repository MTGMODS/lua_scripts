require("ArizonaAPI")

local u8 = require("u8")
local sex = '�������'
-- ���� ��� ����� ������� ��������� �� ������� �� '�������'

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
	[2]=1, [5]=1, [6]=1, [7]=1, [8]=1, [9]=1, [14]=1, [15]=1, [25]=1, [26]=1, [27]=1, [28]=1, [29]=1, [30]=1, [31]=1, [32]=1, [33]=1, [34]=1, [35]=1, [36]=1, [37]=1, [38]=1, [42]=1, [77]=1, [78]=1, [78]=1, [79]=1, [80]=1, [81]=1, [82]=1, [83]=1, [84]=1, [85]=1, [86]=1, [92]=1, [87]=1, [88]=1, [49]=1, [50]=1, [51]=1, [54]=1,
	[1]=2, [4]=2, [10]=2, [11]=2, [12]=2, [13]=2, [41]=2, [43]=2, [44]=2, [45]=2, [46]=2,
	[16]=3, [17]=3, [18]=3, [39]=3, [40]=3, [90]=3, [91]=3, [3]=3,
	[22]=4, [23]=4, [24]=4, [71]=4, [72]=4, [73]=4, [74]=4, [75]=4, [76]=4, [89]=4,
}
for id, weapon in pairs(weapons.names) do
	if (id == 3 or (id > 15 and id < 19) or (id == 90 or id == 91)) then -- 3 16 17 18 (for gunOn)
		if sex == "�������" then
			gunOn[id] = '����'
		elseif sex == "�������" then
			gunOn[id] = '����a'
		end
	else
		if sex == "�������" then
			gunOn[id] = '������'
		elseif sex == "�������" then
			gunOn[id] = '������a'
		end
	end
	if (id == 3 or (id > 15 and id < 19) or (id > 38 and id < 41) or (id == 90 or id == 91)) then -- 3 16 17 18 39 40 (for gunOff)
		if sex == "�������" then
			gunOff[id] = '�������'
		elseif sex == "�������" then
			gunOff[id] = '�������a'
		end
	else
		if sex == "�������" then
			gunOff[id] = '�����'
		elseif sex == "�������" then
			gunOff[id] = '�����a'
		end
	end
	if id > 0 then
		gunPartOn[id] = rpTakeNames[rpTake[id]][1]
		gunPartOff[id] = rpTakeNames[rpTake[id]][2]
	end
end

function onUpdate()

	if nowGun ~= getCurrentCharWeapon(PLAYER_PED) then
		oldGun = nowGun
		nowGun = getCurrentCharWeapon(PLAYER_PED)
		if oldGun == 0 then
			sampSendCommand("/me " .. gunOn[nowGun] .. " " .. weapons.get_name(nowGun) .. " " .. gunPartOn[nowGun])
		elseif nowGun == 0 then
			sampSendCommand("/me " .. gunOff[oldGun] .. " " .. weapons.get_name(oldGun) .. " " .. gunPartOff[oldGun])
		else
			sampSendCommand("/me " .. gunOff[oldGun] .. " " .. weapons.get_name(oldGun) .. " " .. gunPartOff[oldGun] .. ", ����� ���� " .. gunOn[nowGun] .. " " .. weapons.get_name(nowGun) .. " " .. gunPartOn[nowGun])
		end
	end

end
