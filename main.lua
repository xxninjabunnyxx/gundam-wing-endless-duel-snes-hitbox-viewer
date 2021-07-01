memory.usememorydomain('WRAM')

local state = {
    time = {
        address = 0x00060C,
        max = 153
    },
    
    player_1 = {
        health = {
            address = 0x001B71,
            max = 112
        },
        
        meter = {
            address = 0x001B80,
            max = 300
        }
    },
    
    player_2 = {
        health = {
            address = 0x001B75,
            max = 112
        },
        meter = {
            address = 0x001B84,
            max = 300
        }
    },

    timers = {
        overlay = 0,
        menu_delay = 0,
        sub_menu_delay = 0
    },
    
    flags = {
        overlay = false,
        menu_state = 1
    }
}

function local one_byte_set_to_max(table)
    function local f()
        memory.writebyte(table.address, table.max)
    end
    return f
end



local menu = {
    [1] = { text = "Player 1"; skip = true };
    [2] = { text = "Health"; skip = false; state = 1; max_state = 3; options = {
        [1] = {text = " Normal >";  callback = noop };
        [2] = {text = "< Infinate";  callback = one_byte_set_to_max({address = state.player_1.health.address; max = state.player_2.health.max}) }
    }};
    [3] = { text = "Meter"; skip = false; state = 1; max_state = 3; options = {
        [1] = {text = " Normal >";  callback = noop };
        [2] = {text = "< Infinate";  callback = noop }
    }};
    [4] = { text = "Player 2"; skip = true };
    [5] = { text = "Health"; skip = false; state = 1; max_state = 3; options = {
        [1] = {text = " Normal >";  callback = noop };
        [2] = {text = "< Infinate";  callback = one_byte_set_to_max({address = state.player_2.health.address; max = state.player_2.health.max}) }
    }};
    [6] = { text = "Meter"; skip = false; state = 1; max_state = 3; options = {
        [1] = {text = " Normal >";  callback = noop };
        [2] = {text = "< Infinate";  callback = noop }
    }};
    [7] = { text = "Extras"; skip = true };
    [8] = { text = "Time"; skip = false; state = 1; max_state = 2; options = {
        [1] = { text = " Normal >";  callback = noop };
        [2] = { text = "< Infinate";  callback = one_byte_set_to_max({address = state.time.address; max = state.time.max}) }
    }};
    --[10] = { text = "Hitboxes"; skip = false; state = 1; max_state = 2; options = {
    --    [1] = { text = " Off >";  callback = noop };
    --    [2] = { text = "< On";  callback = noop }
    --}};
}

function local run_menu_callbacks()
    for key, value in ipairs(menu) do
        if value["skip"] == false then
            value["options"][value.state]["callback"]()
        end
    end
end

function local check_timers()
    ref_time = 50
    if state.timers.overlay >= ref_time then
        state.flags.overlay = not state.flags.overlay
        state.timers.overlay = 0
    end
end

function local noop()
    return 0
end

function local table_has_key(table, key)
    if table[key] ~= nil then
        return true
    else
        return false
    end
end

function local overlay()
    ref_time = 5
    inputs = joypad.get()
    line_space_amount = 10
    line_space = 0
    
    for key, value in ipairs(menu) do
            if  table_has_key(value, "options") == true then
                menu_text = value["text"] .. " " .. value["options"][value.state]["text"]
            else
                menu_text = value["text"]
            end
            
            if key == state.flags.menu_state and value["skip"] == false then
                gui.drawText(0, line_space, ">" .. menu_text, "white", "Black")
                
                if  table_has_key(value, "state") == true and  table_has_key(value, "max_state") == true then
                    if inputs["P1 Right"] == true and state.timers.sub_menu_delay >= ref_time then
                        value.state = value.state + 1
                        state.timers.sub_menu_delay = 0
                    end
                    
                    if inputs["P1 Left"] == true and state.timers.sub_menu_delay >= ref_time then
                        value.state = value.state - 1
                        state.timers.sub_menu_delay = 0
                    end
                    
                    if inputs["P1 Left"] == true or inputs["P1 Right"] == true then
                        state.timers.sub_menu_delay = state.timers.sub_menu_delay + 1
                    end
                    
                    if value.state > value.max_state then
                        value.state = value.max_state
                    end
                    
                    if value.state < 1 then
                        value.state = 1
                    end
                end
                
                value["options"][value.state]["callback"]()
                
            elseif key == state.flags.menu_state and value["skip"] == true then
                gui.drawText(0, line_space, "-" .. menu_text, "white", "Black")
            else
                gui.drawText(0, line_space, " " .. menu_text, "white", "Black")
            end
            
            line_space = line_space + line_space_amount
        end
        
        if inputs["P1 Down"] == true or inputs["P1 Up"] == true then
            state.timers.menu_delay = state.timers.menu_delay + 1
        end
        
        if inputs["P1 Down"] == true and state.timers.menu_delay >= ref_time then
            state.flags.menu_state = state.flags.menu_state + 1
            state.timers.menu_delay = 0
        end
        
        if inputs["P1 Up"] == true and state.timers.menu_delay >= ref_time then
            state.flags.menu_state = state.flags.menu_state - 1
            state.timers.menu_delay = 0
        end
        
        if state.flags.menu_state < 1 then
            state.flags.menu_state = 1
        end
        
        if state.flags.menu_state > #menu then
            state.flags.menu_state = #menu
        end
end

while true do
    local inputs = joypad.get()

    if inputs["P1 Start"] == true and inputs["P1 Select"] == true then
        state.timers.overlay = state.timers.overlay + 1
    end

    check_timers()

    if state.flags.overlay == true then
        overlay()
    end

    run_menu_callbacks()
    emu.frameadvance()
    gui.clearGraphics()
end
