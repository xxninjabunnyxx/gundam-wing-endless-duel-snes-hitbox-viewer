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
        },

        position = { x = 0x001101, y = 0x001181},

        hitbox = {
            [1] = { x_1 = 0x001800 , x_2 = 0x001802, y_1 = 0x001880, y_2 = 0x001882 }
        },

        active_hitbox = {
            [1] = { x_1 = '', x_2 = '', y_1 = '', y_2 = ''}
        },

        facing = {
            address = 0x001383,
            left = 46,
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
        },

        hitbox = {
            [1] = { x_1 = '', x_2 = '', y_1 = '', y_2 = ''}
        },
        
        active_hitbox = {
            [1] = { x_1 = '', x_2 = '', y_1 = '', y_2 = ''}
        },

        facing = {
            address = 0x001383,
            left = 48,
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
    },

    camera = {
        x = 0x0620,
        y = 0x0622
    },

    color = {
        hitbox = {
            border = 0xFF0000FF,
            fill = 0x400000FF
        }
    }
}

local function noop()
    return 0
end

local function facing(table)
    if (memory.read_s16_le(table.address) == table) then
        return 1
    else
        return -1
    end
end

local function one_byte_set_to_max(table)
    local function f()
        memory.writebyte(table.address, table.max)
    end
    return f
end

local function two_byte_set_to_max(table)
    local function f()
        memory.write_u16_le(table.address, table.max)
    end
    return f
end


local function draw_boxes(table)
    player_facing = facing({ address=table.player.facing.address, left = table.player.facing.left })
    for key, value in ipairs(table.player[table.box_type]) do
    gui.drawBox(
        (memory.read_s16_le(table.player.position.x) - memory.read_s16_le(state.camera.x)) + (memory.read_s16_le(table.player[table.box_type][key].x_1) * player_facing),
        (memory.read_s16_le(table.player.position.y) - memory.read_s16_le(state.camera.y)) + memory.read_s16_le(table.player[table.box_type][key].y_1),
        (memory.read_s16_le(table.player.position.x) - memory.read_s16_le(state.camera.x)) + ((memory.read_s16_le(table.player[table.box_type][key].x_1) + memory.read_s16_le(table.player[table.box_type][key].x_2)) * player_facing),
        (memory.read_s16_le(table.player.position.y) - memory.read_s16_le(state.camera.y)) + (memory.read_s16_le(table.player[table.box_type][key].y_1) + memory.read_s16_le(table.player[table.box_type][key].y_2)),
        table.color.border,
        table.color.fill
    )
    end
end
    
local function draw_hitboxes()
    draw_boxes({player = state.player_1, color = state.color.hitbox, box_type = "hitbox"})
end

local menu = {
    [1] = { text = "Player 1"; skip = true };
    [2] = { text = "Health"; skip = false; state = 1; max_state = 2; options = {
        [1] = {text = " Normal >";  callback = noop };
        [2] = {text = "< Infinate";  callback = one_byte_set_to_max({address = state.player_1.health.address; max = state.player_1.health.max}) }
    }};
    [3] = { text = "Meter"; skip = false; state = 1; max_state = 2; options = {
        [1] = {text = " Normal >";  callback = noop };
        [2] = {text = "< Infinate";  callback = two_byte_set_to_max({address = state.player_1.meter.address; max = state.player_1.meter.max}) }
    }};
    [4] = { text = "Player 2"; skip = true };
    [5] = { text = "Health"; skip = false; state = 1; max_state = 2; options = {
        [1] = {text = " Normal >";  callback = noop };
        [2] = {text = "< Infinate";  callback = one_byte_set_to_max({address = state.player_2.health.address; max = state.player_2.health.max}) }
    }};
    [6] = { text = "Meter"; skip = false; state = 1; max_state = 2; options = {
        [1] = {text = " Normal >";  callback = noop };
        [2] = {text = "< Infinate";  callback = two_byte_set_to_max({address = state.player_2.meter.address; max = state.player_2.meter.max}) }
    }};
    [7] = { text = "Extras"; skip = true };
    [8] = { text = "Time"; skip = false; state = 1; max_state = 2; options = {
        [1] = { text = " Normal >";  callback = noop };
        [2] = { text = "< Infinate";  callback = one_byte_set_to_max({address = state.time.address; max = state.time.max}) }
    }};
    [9] = { text = "Hitboxes"; skip = false; state = 1; max_state = 2; options = {
        [1] = { text = " Off >";  callback = noop };
        [2] = { text = "< On";  callback = draw_hitboxes }
    }};
}

local function run_menu_callbacks()
    for key, value in ipairs(menu) do
        if value["skip"] == false then
            value["options"][value.state]["callback"]()
        end
    end
end

local function check_timers()
    ref_time = 50
    if state.timers.overlay >= ref_time then
        state.flags.overlay = not state.flags.overlay
        state.timers.overlay = 0
    end
end

local function table_has_key(table, key)
    if table[key] ~= nil then
        return true
    else
        return false
    end
end

local function overlay()
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
