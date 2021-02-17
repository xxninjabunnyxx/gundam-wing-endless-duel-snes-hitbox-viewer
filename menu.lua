local module = {}

local state = require("state")
local helpers = require("helpers")

local menu = {
    [1] = { text = "Player 1"; skip = true };
    [2] = { text = "Health"; skip = false; state = 1; max_state = 3; options = {
        [1] = {text = " Normal >";  callback = helpers.noop };
        [2] = {text = "< Refill >";  callback = helpers.noop };
        [3] = {text = "< Infinate";  callback = helpers.infinite(state.player_1.health.address, state.player_1.health.max, state.player_1.health.size) }
    }};
    [3] = { text = "Meter"; skip = false; state = 1; max_state = 3; options = {
        [1] = {text = " Normal >";  callback = helpers.noop };
        [2] = {text = "< Refill >";  callback = helpers.noop };
        [3] = {text = "< Infinate";  callback = helpers.infinite(state.player_1.meter.address, state.player_1.meter.max, state.player_1.meter.size) }
    }};
    [4] = { text = "State"; skip = false; state = 1; max_state = 3; options = {
        [1] = {text = " Standing >";  callback = helpers.noop };
        [2] = {text = "< Crouching >";  callback = helpers.noop };
        [3] = {text = "< Jumping";  callback = helpers.noop }
    }};
    [5] = { text = "Blocking"; skip = false; state = 1; max_state = 3; options = {
        [1] = {text = " None >";  callback = helpers.noop };
        [2] = {text = "< Auto >";  callback = helpers.noop };
        [3] = {text = "< Follow Up";  callback = helpers.noop }
    }};
    [6] = { text = ""; skip = true};
    [7] = { text = "Player 2"; skip = true };
    [8] = { text = "Health"; skip = false; state = 1; max_state = 3; options = {
        [1] = {text = " Normal >";  callback = helpers.noop };
        [2] = {text = "< Refill >";  callback = helpers.noop };
        [3] = {text = "< Infinate";  callback = helpers.infinite(state.player_2.health.address, state.player_2.health.max, state.player_2.health.size) }
    }};
    [9] = { text = "Meter"; skip = false; state = 1; max_state = 3; options = {
        [1] = {text = " Normal >";  callback = helpers.noop };
        [2] = {text = "< Refill >";  callback = helpers.noop };
        [3] = {text = "< Infinate";  callback = helpers.infinite(state.player_2.meter.address, state.player_2.meter.max, state.player_2.meter.size) }
    }};
    [10] = { text = "State"; skip = false; state = 1; max_state = 3; options = {
        [1] = {text = " Standing >";  callback = helpers.noop };
        [2] = {text = "< Crouching >";  callback = helpers.noop };
        [3] = {text = "< Jumping";  callback = helpers.noop }
    }};
    [11] = { text = "Blocking"; skip = false; state = 1; max_state = 3; options = {
        [1] = {text = " None >";  callback = helpers.noop };
        [2] = {text = "< Auto >";  callback = helpers.noop };
        [3] = {text = "< Follow Up";  callback = helpers.noop }
    }};
    [12] = { text = ""; skip = true };
    [13] = { text = "Time"; skip = false; state = 1; max_state = 2; options = {
        [1] = { text = " Normal >";  callback = helpers.noop };
        [2] = { text = "< Infinate";  callback = helpers.infinite(state.time.address, state.time.max, state.time.size) }
    }};
}

function module.run_callbacks()
    for key, value in ipairs(menu) do
        if value["skip"] == false then
            value["options"][value.state]["callback"]()
        end
    end
end

function module.overlay()
    ref_time = 5
    inputs = joypad.get()
    line_space_amount = 10
    line_space = 0

    for key, value in ipairs(menu) do
        if  helpers.table_has_key(value, "options") == true then
            menu_text = value["text"] .. " " .. value["options"][value.state]["text"]
        else
            menu_text = value["text"]
        end

        if key == state.flags.menu_state and value["skip"] == false then
            gui.drawText(0, line_space, ">" .. menu_text, "white", "Black")

            if  helpers.table_has_key(value, "state") == true and  helpers.table_has_key(value, "max_state") == true then
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

    if state.flags.menu_state > 13 then
        state.flags.menu_state = 13
    end
end

return module
