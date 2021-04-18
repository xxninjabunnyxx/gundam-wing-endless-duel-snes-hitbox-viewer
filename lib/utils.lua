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



return module
