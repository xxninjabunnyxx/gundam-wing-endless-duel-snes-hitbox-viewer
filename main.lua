memory.usememorydomain('WRAM')

local time = { address = 0x00060C; max = 153 }

local player_1 = {
    health = { address = 0x001B71; max = 112};
    meter = { address = 0x001B80; max = 300 }
}

local player_2 = {
    health = { address = 0x001B75; max = 112};
    meter = { address = 0x001B84; max = 300 }
}


while true do
    memory.writebyte(time.address, time.max)
    emu.frameadvance()
end