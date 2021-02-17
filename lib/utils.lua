local state = require("lib.state")

local module = {}

function module.infinite(address, max, size)
    if size == 1 then
        function f()
            memory.writebyte(address, max)
        end
    elseif size == 2 then
        function f()
            memory.write_u16_le(address, max)
        end
    else
        function f()
            memory.write_u16_le(address, max)
        end
    end
    return f
end

function module.check_timers()
    ref_time = 50
    if state.timers.main_overlay == ref_time then
        state.flags.main_overlay = not state.flags.main_overlay
        state.timers.main_overlay = 0
    end
end

function module.noop()
end

function module.table_has_key(table, key)
    if table[key] ~= nil then
        return true
    else
        return false
    end
end

return module
