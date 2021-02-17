memory.usememorydomain('WRAM')

local module = {}

module.time = { address = 0x00060C; max = 153 }

module.player_1 = {
    health = { address = 0x001B71; max = 112};
    meter = { address = 0x001B80; max = 300 }
}

module.player_2 = {
    health = { address = 0x001B75; max = 112};
    meter = { address = 0x001B84; max = 300 }
}

module.timers = {
    main_overlay = 0;
    menu_delay = 0;
    sub_menu_delay = 0;
}

module.flags = {
    main_overlay = false;
    menu_state = 1;
}

return module
