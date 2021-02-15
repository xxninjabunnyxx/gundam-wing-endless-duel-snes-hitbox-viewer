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

local timers = {
    main_overlay = 0
}

local flags = {
    main_overlay = false
}

function check_timers()
    if timers.main_overlay == 50 then
        flags.main_overlay = not flags.main_overlay
        timers.main_overlay = 0
    end
end

function main_overlay()
    gui.drawText(0,0, 'main_overlay')
end

while true do
    local inputs = joypad.get()

    if inputs["P1 Start"] == true and inputs["P1 Select"] == true then
        timers.main_overlay = timers.main_overlay + 1
    end

    check_timers()

    if flags.main_overlay == true then
        main_overlay()
    end

    memory.writebyte(time.address, time.max)
    emu.frameadvance()
end
