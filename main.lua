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
    main_overlay = 0;
    menu_delay = 0;
    sub_menu_delay = 0;
}

local flags = {
    main_overlay = false;
    menu_state = 1;
}

function check_timers()
    ref_time = 50
    if timers.main_overlay == ref_time then
        flags.main_overlay = not flags.main_overlay
        timers.main_overlay = 0
    end
end

function noop()
end

function table_has_key(table, key)
    if table[key] ~= nil then
        return true
    else
        return false
    end
end

menu = {
    [1] = { text = "Player 1"; skip = true };
    [2] = { text = "Health"; skip = false; state = 1; max_state = 3; options = {
        [1] = {text = " Normal >";  callback=noop};
        [2] = {text = "< Refill >";  callback=noop};
        [3] = {text = "< Infinate";  callback=noop}
    }};
    [3] = { text = "Meter"; skip = false; state = 1; max_state = 3; options = {
        [1] = {text = " Normal >";  callback=noop};
        [2] = {text = "< Refill >";  callback=noop};
        [3] = {text = "< Infinate";  callback=noop}
    }};
    [4] = { text = "State"; skip = false; state = 1; max_state = 3; options = {
        [1] = {text = " Standing >";  callback=noop};
        [2] = {text = "< Crouching >";  callback=noop};
        [3] = {text = "< Jumping";  callback=noop}
    }};
    [5] = { text = "Blocking"; skip = false; state = 1; max_state = 3; options = {
        [1] = {text = " None >";  callback=noop};
        [2] = {text = "< Auto >";  callback=noop};
        [3] = {text = "< Follow Up";  callback=noop}
    }};
    [6] = { text = ""; skip = true};
    [7] = { text = "Player 2"; skip = true };
    [8] = { text = "Health"; skip = false; state = 1; max_state = 3; options = {
        [1] = {text = " Normal >";  callback=noop};
        [2] = {text = "< Refill >";  callback=noop};
        [3] = {text = "< Infinate";  callback=noop}
    }};
    [9] = { text = "Meter"; skip = false; state = 1; max_state = 3; options = {
        [1] = {text = " Normal >";  callback=noop};
        [2] = {text = "< Refill >";  callback=noop};
        [3] = {text = "< Infinate";  callback=noop}
    }};
    [10] = { text = "State"; skip = false; state = 1; max_state = 3; options = {
        [1] = {text = " Standing >";  callback=noop};
        [2] = {text = "< Crouching >";  callback=noop};
        [3] = {text = "< Jumping";  callback=noop}
    }};
    [11] = { text = "Blocking"; skip = false; state = 1; max_state = 3; options = {
        [1] = {text = " None >";  callback=noop};
        [2] = {text = "< Auto >";  callback=noop};
        [3] = {text = "< Follow Up";  callback=noop}
    }};
    [12] = { text = ""; skip = true };
    [13] = { text = "Time"; skip = false; state = 1; max_state = 2; options = {
        [1] = { text = " Normal >";  callback=noop};
        [2] = { text = "< Infinate";  callback=noop}
    }};
}

function main_overlay()
    ref_time = 5
    inputs = joypad.get()
    line_space_amount = 10
    line_space = 0

    for key, value in ipairs(menu) do
        if table_has_key(value, "options") == true then
            menu_text = value["text"] .. " " .. value["options"][value.state]["text"]
        else
            menu_text = value["text"]
        end

        if key == flags.menu_state and value["skip"] == false then
            gui.drawText(0, line_space, ">" .. menu_text, "white", "Black")

            if table_has_key(value, "state") == true and table_has_key(value, "max_state") == true then
                if inputs["P1 Right"] == true and timers.sub_menu_delay >= ref_time then
                    value.state = value.state + 1
                    timers.sub_menu_delay = 0
                end
            
                if inputs["P1 Left"] == true and timers.sub_menu_delay >= ref_time then
                    value.state = value.state - 1
                    timers.sub_menu_delay = 0
                end
    
                if inputs["P1 Left"] == true or inputs["P1 Right"] == true then
                    timers.sub_menu_delay = timers.sub_menu_delay + 1
                end
    
                if value.state > value.max_state then
                    value.state = value.max_state
                end
        
                if value.state < 1 then
                    value.state = 1
                end
            end
        elseif key == flags.menu_state and value["skip"] == true then
            gui.drawText(0, line_space, "-" .. menu_text, "white", "Black")
        else
            gui.drawText(0, line_space, " " .. menu_text, "white", "Black")
        end

        line_space = line_space + line_space_amount
    end

    if inputs["P1 Down"] == true or inputs["P1 Up"] == true then
        timers.menu_delay = timers.menu_delay + 1
    end

    if inputs["P1 Down"] == true and timers.menu_delay >= ref_time then
        flags.menu_state = flags.menu_state + 1
        timers.menu_delay = 0
    end

    if inputs["P1 Up"] == true and timers.menu_delay >= ref_time then
        flags.menu_state = flags.menu_state - 1
        timers.menu_delay = 0
    end

    if flags.menu_state < 1 then
        flags.menu_state = 1
    end

    if flags.menu_state > 13 then
        flags.menu_state = 13
    end
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
