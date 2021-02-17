local state = require("state")
local helpers = require("helpers")
local menu = require("overlay")

while true do
    local inputs = joypad.get()

    if inputs["P1 Start"] == true and inputs["P1 Select"] == true then
        state.timers.main_overlay = state.timers.main_overlay + 1
    end

    helpers.check_timers()

    if state.flags.main_overlay == true then
        menu.overlay()
    end

    emu.frameadvance()
end
