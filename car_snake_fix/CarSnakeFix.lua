function main()
    if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(0) end 
    sampAddChatMessage('[INFO] {ffffff}������ "Car Snake Fix" �������� � �����������! �����: MTG MODS',0xffff0000)
    writeMemory(0x6AC0F0, 2, 0x9090, true)
end