local message_color = 0x009EFF
local message_color_hex = '{009EFF}'
    
local path = getWorkingDirectory():gsub('\\','/') .. "/config/RP_Weapon.json"
local config = {
    settings = {
        enable = true
    },
    player_info = {
        sex = '�������' -- ��� �������
    },
	rpgun = {
		name = 'RP Guns',
		path = "/RP Guns.json",
		data = {
            rp_guns = {
                [0] = {name = '������', enable = true, rpTake = 2},
                [1] = {name = '�������', enable = true, rpTake = 2},
                [2] = {name = '������ ��� ������', enable = true, rpTake = 1},
                [3] = {name = '�������', enable = true, rpTake = 3},
                [4] = {name = '������ ���', enable = true, rpTake = 3},
                [5] = {name = '����', enable = true, rpTake = 1},
                [6] = {name = '������', enable = true, rpTake = 1},
                [7] = {name = '���', enable = true, rpTake = 1},
                [8] = {name = '������', enable = true, rpTake = 1},
                [9] = {name = '���������', enable = true, rpTake = 1},
                [10] = {name = '�����', enable = true, rpTake = 2},
                [11] = {name = '�����', enable = true, rpTake = 2},
                [12] = {name = '��������', enable = true, rpTake = 2},
                [13] = {name = '��������', enable = true, rpTake = 2},
                [14] = {name = '����� ������', enable = true, rpTake = 1},
                [15] = {name = '������', enable = true, rpTake = 1},
                [16] = {name = '���������� �������', enable = true, rpTake = 3},
                [17] = {name = '������� �������', enable = true, rpTake = 3},
                [18] = {name = '�������� ��������', enable = true, rpTake = 3},
                [22] = {name = '�������� Colt45', enable = true, rpTake = 4},
                [23] = {name = "������������ Taser-X26P", enable = true, rpTake = 4},
                [24] = {name = '�������� Desert Eagle', enable = true, rpTake = 4},
                [25] = {name = '��������', enable = true, rpTake = 1},
                [26] = {name = '�����', enable = true, rpTake = 1},
                [27] = {name = '���������� �����', enable = true, rpTake = 1},
                [28] = {name = '��������-������ Micro Uzi', enable = true, rpTake = 4},
                [29] = {name = '��������-������ MP5', enable = true, rpTake = 4},
                [30] = {name = '������� AK-47', enable = true, rpTake = 1},
                [31] = {name = '������� M4', enable = true, rpTake = 1},
                [32] = {name = '��������-������ Tec-9', enable = true, rpTake = 4},
                [33] = {name = '�������� Rifle', enable = true, rpTake = 1},
                [34] = {name = '����������� �������� Rifle', enable = true, rpTake = 1},
                [35] = {name = '������ ��������������� ������', enable = true, rpTake = 1},
                [36] = {name = '���������� ��� ������� �����', enable = true, rpTake = 1},
                [37] = {name = '������', enable = true, rpTake = 1},
                [38] = {name = '�������', enable = true, rpTake = 1},
                [39] = {name = '�������', enable = true, rpTake = 3},
                [40] = {name = '���������', enable = true, rpTake = 3},
                [41] = {name = '�������� ��������', enable = true, rpTake = 2},
                [42] = {name = '������������', enable = true, rpTake = 1},
                [43] = {name = '����������', enable = true, rpTake = 2},
                [44] = {name = '������ ������� �������', enable = true, rpTake = 2},
                [45] = {name = '����������', enable = true, rpTake = 2},
                [46] = {name = '������ �������', enable = true, rpTake = 1},
                -- gta sa damage reason
                [49] = {name = '����������', rpTake = 1},
                [50] = {name = '������� ��������', rpTake = 1},
                [51] = {name = '�����', rpTake = 1},
                [54] = {name = '��������', rpTake = 1},
                -- ARZ Custom Guns
                [71] = {name = '�������� Desert Eagle Steel', enable = true, rpTake = 4},
                [72] = {name = '�������� Desert Eagle Gold', enable = true, rpTake = 4},
                [73] = {name = '�������� Glock Gradient', enable = true, rpTake = 4},
                [74] = {name = '�������� Desert Eagle Flame', enable = true, rpTake = 4},
                [75] = {name = '�������� Python Royal', enable = true, rpTake = 4},
                [76] = {name = '�������� Python Silver', enable = true, rpTake = 4},
                [77] = {name = '������� AK-47 Roses', enable = true, rpTake = 1},
                [78] = {name = '������� AK-47 Gold', enable = true, rpTake = 1},
                [79] = {name = '������ M249 Graffiti', enable = true, rpTake = 1},
                [80] = {name = '������� �����', enable = true, rpTake = 1},
                [81] = {name = '��������-������ Standart', enable = true, rpTake = 4},
                [82] = {name = '������ M249', enable = true, rpTake = 1},
                [83] = {name = '��������-������ Skorp', enable = true, rpTake = 4},
                [84] = {name = '������� AKS-74 �����������', enable = true, rpTake = 1},
                [85] = {name = '������� AK-47 �����������', enable = true, rpTake = 1},
                [86] = {name = '�������� Rebecca', enable = true, rpTake = 1},
                [87] = {name = '���������� �����', enable = true, rpTake = 1},
                [88] = {name = '������� ���', enable = true, rpTake = 1},
                [89] = {name = '���������� �����', enable = true, rpTake = 4},
                [90] = {name = '���������� �������', enable = true, rpTake = 3},
                [91] = {name = '����������� �������', enable = true, rpTake = 3},
                [92] = {name = '����������� �������� McMillian TAC-50', enable = true, rpTake = 1},
                [93] = {name = '���������� ��������', enable = true, rpTake = 4}
            },
            rpTakeNames = {
                [1] = {"��-�� �����", "�� �����"},
                [2] = {"�� �������", "� ������"},
                [3] = {"�� �����", "�� ����"},
                [4] = {"�� ������", "� ������"}
            },
            gunActions = {
                on = {},
                off = {},
                partOn = {},
                partOff = {}
            },
            oldGun = nil,
            nowGun = 0
        }
	},

}
function load()
    if doesFileExist(path) then
        local file, errstr = io.open(path, 'r')
        if file then
            local contents = file:read('*a')
            file:close()
            if #contents ~= 0 then
                local result, loaded = pcall(decodeJson, contents)
                if result then
                    config = loaded
                end
            end
        end
    end
end
function save()
    local file, errstr = io.open(path, 'w')
    if file then
        local result, encoded = pcall(encodeJson, settings)
        file:write(result and encoded or "")
        file:close()
    end
end
load()

function init_guns()
    for id, weapon in pairs(config.rpgun.data.rp_guns) do
        local rpTakeType = config.rpgun.data.rpTakeNames[weapon.rpTake]
        config.rpgun.data.gunActions.partOn[id] = rpTakeType[1]
        config.rpgun.data.gunActions.partOff[id] = rpTakeType[2]
        if id == 3 or (id > 15 and id < 19) or (id == 90 or id == 91) then
            config.rpgun.data.gunActions.on[id] = (config.player_info.sex == "�������") and "�����" or "����"
        else
            config.rpgun.data.gunActions.on[id] = (config.player_info.sex == "�������") and "�������" or "������"
        end
        if id == 3 or (id > 15 and id < 19) or (id > 38 and id < 41) or (id == 90 or id == 91) then
            config.rpgun.data.gunActions.off[id] = (config.player_info.sex == "�������") and "��������" or "�������"
        else
            config.rpgun.data.gunActions.off[id] = (config.player_info.sex == "�������") and "������" or "�����"
        end
    end
end
function get_name_weapon(id)
    return config.rpgun.data.rp_guns[id] and config.rpgun.data.rp_guns[id].name or "������"
end
function isExistsWeapon(id)
    return config.rpgun.data.rp_guns[id] ~= nil
end
function isEnableWeapon(id)
    return config.rpgun.data.rp_guns[id] and (config.rpgun.data.rp_guns[id].enable or false)
end
function handleNewWeapon(weaponId)
    sampAddChatMessage('[RP Weapon] {ffffff}���������� ����� ������ � ID ' .. message_color_hex .. weaponId .. '{ffffff}, ��� ��� ��� "������" � ������������ "�����".', message_color)
    sampAddChatMessage('[RP Weapon] {ffffff}�������� ��� ��� ������������ ������ �� ������ � � �����:', message_color)
    sampAddChatMessage(path, message_color)
    config.rpgun.data.rp_guns[weaponId] = {name = "������", enable = true, rpTake = 1}
    save()
    init_guns()
end
function processWeaponChange(oldGun, nowGun)
    if not config.rpgun.data.gunActions.off[oldGun] or not config.rpgun.data.gunActions.on[nowGun] then
        return
    end

    local actions = config.rpgun.data.gunActions
    local weaponNames = config.rpgun.data.rp_guns
    
    if oldGun == 0 and nowGun == 0 then
        return
    elseif oldGun == 0 and not isEnableWeapon(nowGun) then
        return
    elseif nowGun == 0 and not isEnableWeapon(oldGun) then
        return
    elseif not isEnableWeapon(oldGun) and isEnableWeapon(nowGun) then
        sampSendChat(string.format("/me %s %s %s",
            actions.on[nowGun],
            weaponNames[nowGun].name,
            actions.partOn[nowGun]
        ))
    elseif isEnableWeapon(oldGun) and not isEnableWeapon(nowGun) then
        sampSendChat(string.format("/me %s %s %s",
            actions.off[oldGun],
            weaponNames[oldGun].name,
            actions.partOff[oldGun]
        ))
    elseif oldGun == 0 then
        sampSendChat(string.format("/me %s %s %s",
            actions.on[nowGun],
            weaponNames[nowGun].name,
            actions.partOn[nowGun]
        ))
    elseif nowGun == 0 then
        sampSendChat(string.format("/me %s %s %s",
            actions.off[oldGun],
            weaponNames[oldGun].name,
            actions.partOff[oldGun]
        ))
    else
        sampSendChat(string.format("/me %s %s %s, ����� ���� %s %s %s",
            actions.off[oldGun],
            weaponNames[oldGun].name,
            actions.partOff[oldGun],
            actions.on[nowGun],
            weaponNames[nowGun].name,
            actions.partOn[nowGun]
        ))
    end
end

function main()

    if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(0) end

    init_guns()

    sampRegisterChatCommand('sex', function ()
        config.player_info.sex = (config.player_info.sex == "�������") and "�������" or "�������"
        save()
        init_guns()
        sampAddChatMessage('[RP Weapon] {ffffff}' .. config.player_info.sex, message_color)
    end)

    while true do 
        wait(0)
        if config.settings.enable then
            if config.rpgun.data.nowGun ~= getCurrentCharWeapon(PLAYER_PED) then
                config.rpgun.data.oldGun = config.rpgun.data.nowGun
                config.rpgun.data.nowGun = getCurrentCharWeapon(PLAYER_PED)

                if not isExistsWeapon(config.rpgun.data.oldGun) then
                    handleNewWeapon(config.rpgun.data.oldGun)
                elseif not isExistsWeapon(config.rpgun.data.nowGun) then
                    handleNewWeapon(config.rpgun.data.nowGun)
                end

                processWeaponChange(config.rpgun.data.oldGun, config.rpgun.data.nowGun)
            end
        end
    end

end



