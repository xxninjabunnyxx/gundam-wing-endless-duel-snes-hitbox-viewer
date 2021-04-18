local state = require("lib.state")
local utils = require("lib.utils")
local menu = require("lib.menu")

while true do
    local inputs = joypad.get()

    if inputs["P1 Start"] == true and inputs["P1 Select"] == true then
        state.timers.main_overlay = state.timers.main_overlay + 1
    end

    utils.check_timers()

    if state.flags.main_overlay == true then
        menu.overlay()
    end
    
    menu.run_callbacks()
    emu.frameadvance()
end
