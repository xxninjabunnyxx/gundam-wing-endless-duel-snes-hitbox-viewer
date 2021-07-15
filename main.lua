memory.usememorydomain('WRAM')

local state = {
    timers = {
        overlay = 0,
        menu_delay = 0,
        sub_menu_delay = 0,
        reference_time = 25
    },
    flags = {overlay = false, menu_state = 1}
}

local overlay_settings = {line_space_amount = 10, line_space = 0, menu_time = 5}

local time = {address = 0x00060C, max = 153}

local player_1 = {
    health = {address = 0x001B71, max = 112},

    meter = {address = 0x001B80, max = 300},

    position = {x = 0x001101, y = 0x001181},

    hitbox = {
        [1] = {x_1 = 0x001800, x_2 = 0x001802, y_1 = 0x001880, y_2 = 0x001882},
        [2] = {x_1 = 0x001BC0, x_2 = 0x001782, y_1 = 0x001BC2, y_2 = 0x001BC8}
    },

    active_hitbox = {
        [1] = {x_1 = 0x001900, x_2 = 0x001902, y_1 = 0x001980, y_2 = 0x001982}
    },

    projectile_hitbox = {
        [1] = {
            box = {
                x_1 = 0x001940,
                x_2 = 0x001942,
                y_1 = 0x0019C0,
                y_2 = 0x0019C2
            },
            position = {x = 0x001141, y = 0x0011C1},
            state_address = 0x001040
        },
        [2] = {
            box = {
                x_1 = 0x001948,
                x_2 = 0x00194A,
                y_1 = 0x0019C8,
                y_2 = 0x0019CA
            },
            position = {x = 0x001149, y = 0x0011C9},
            state_address = 0x001048
        },
        [3] = {
            box = {
                x_1 = 0x001950,
                x_2 = 0x001952,
                y_1 = 0x0019D0,
                y_2 = 0x0019D2
            },
            position = {x = 0x001151, y = 0x0011D1},
            state_address = 0x001050
        },
        [4] = {
            box = {
                x_1 = 0x001958,
                x_2 = 0x00195A,
                y_1 = 0x0019D8,
                y_2 = 0x0019DA
            },
            position = {x = 0x001159, y = 0x0011D9},
            state_address = 0x001058
        }
    },

    facing = {address = 0x001387, bitwise_and = 0x74},

    address = {attack = 0x001600},
    vulcan_hitbox = {
        [1] = {
            box = {
                x_1 = 0x001920,
                x_2 = 0x001922,
                y_1 = 0x0019A0,
                y_2 = 0x0019A2
            },
            position = {x = 0x001121, y = 0x0011A1},
            state_address = 0x001020
        },
        [2] = {
            box = {
                x_1 = 0x001928,
                x_2 = 0x00192A,
                y_1 = 0x0019A8,
                y_2 = 0x0019AA
            },
            position = {x = 0x001129, y = 0x0011A9},
            state_address = 0x001028
        },
        [3] = {
            box = {
                x_1 = 0x001930,
                x_2 = 0x001932,
                y_1 = 0x0019B0,
                y_2 = 0x0019B2
            },
            position = {x = 0x001131, y = 0x0011B1},
            state_address = 0x001030
        },
        [4] = {
            box = {
                x_1 = 0x001938,
                x_2 = 0x00193A,
                y_1 = 0x0019B8,
                y_2 = 0x0019BA
            },
            position = {x = 0x001139, y = 0x0011B9},
            state_address = 0x001038
        }
    }
}

local player_2 = {
    health = {address = 0x001B75, max = 112},

    meter = {address = 0x001B84, max = 300},

    position = {x = 0x001105, y = 0x001185},

    hitbox = {
        [1] = {x_1 = 0x001804, x_2 = 0x001806, y_1 = 0x001884, y_2 = 0x001886},
        [2] = {x_1 = 0x001BC4, x_2 = 0x001786, y_1 = 0x001BC6, y_2 = 0x001BCC}
    },

    active_hitbox = {
        [1] = {x_1 = 0x001904, x_2 = 0x001906, y_1 = 0x001984, y_2 = 0x001986}
    },

    projectile_hitbox = {
        [1] = {
            box = {
                x_1 = 0x001944,
                x_2 = 0x001946,
                y_1 = 0x0019C4,
                y_2 = 0x0019C6
            },
            position = {x = 0x001145, y = 0x0011C5},
            state_address = 0x001044
        },
        [2] = {
            box = {
                x_1 = 0x00194C,
                x_2 = 0x00194E,
                y_1 = 0x0019CC,
                y_2 = 0x0019CE
            },
            position = {x = 0x00114D, y = 0x0011CD},
            state_address = 0x00104C
        },
        [3] = {
            box = {
                x_1 = 0x001954,
                x_2 = 0x001956,
                y_1 = 0x0019D4,
                y_2 = 0x0019D6
            },
            position = {x = 0x001155, y = 0x0011D5},
            state_address = 0x001054
        },
        [4] = {
            box = {
                x_1 = 0x00195C,
                x_2 = 0x00195E,
                y_1 = 0x0019DC,
                y_2 = 0x0019DE
            },
            position = {x = 0x00115D, y = 0x0011DD},
            state_address = 0x00105C
        }
    },

    facing = {address = 0x001383, bitwise_and = 0x74},

    address = {attack = 0x001604},

    vulcan_hitbox = {
        [1] = {
            box = {
                x_1 = 0x001924,
                x_2 = 0x001926,
                y_1 = 0x0019A4,
                y_2 = 0x0019A6
            },
            position = {x = 0x001125, y = 0x0011A5},
            state_address = 0x001024
        },
        [2] = {
            box = {
                x_1 = 0x00192C,
                x_2 = 0x00192E,
                y_1 = 0x0019AC,
                y_2 = 0x0019AE
            },
            position = {x = 0x00112D, y = 0x0011AD},
            state_address = 0x00102C
        },
        [3] = {
            box = {
                x_1 = 0x001934,
                x_2 = 0x001936,
                y_1 = 0x0019B4,
                y_2 = 0x0019B6
            },
            position = {x = 0x001135, y = 0x0011B5},
            state_address = 0x001034
        },
        [4] = {
            box = {
                x_1 = 0x00193C,
                x_2 = 0x00193E,
                y_1 = 0x0019BC,
                y_2 = 0x0019BE
            },
            position = {x = 0x00113D, y = 0x0011BD},
            state_address = 0x00103C
        }
    }
}

local camera = {x = 0x0620, y = 0x0622}

local color = {
    hitbox = {border = 0xFF0000FF, fill = 0x400000FF},
    active_hitbox = {border = 0xFFFF0000, fill = 0x40FF0000},
    invisible = {border = 0x00000000, fill = 0x00000000}
}

local function noop() return 0 end

local function facing(table)
    if bit.band(memory.read_u8(table.player.facing.address),
                table.player.facing.bitwise_and) ==
        table.player.facing.bitwise_and then
        return 1
    else
        return -1
    end
end

local function one_byte_set_to_max(table)
    local function f() memory.writebyte(table.address, table.max) end
    return f
end

local function two_byte_set_to_max(table)
    local function f() memory.write_u16_le(table.address, table.max) end
    return f
end

local function draw_box(table)
    gui.drawBox((memory.read_s16_le(table.player.position.x) -
                    memory.read_s16_le(camera.x)) +
                    (memory.read_s16_le(
                        table.player[table.boxtype][table.key].x_1) *
                        table.player_facing),
                (memory.read_s16_le(table.player.position.y) -
                    memory.read_s16_le(camera.y)) +
                    memory.read_s16_le(
                        table.player[table.boxtype][table.key].y_1),
                (memory.read_s16_le(table.player.position.x) -
                    memory.read_s16_le(camera.x)) +
                    ((memory.read_s16_le(
                        table.player[table.boxtype][table.key].x_1) +
                        memory.read_s16_le(
                            table.player[table.boxtype][table.key].x_2)) *
                        table.player_facing),
                (memory.read_s16_le(table.player.position.y) -
                    memory.read_s16_le(camera.y)) +
                    (memory.read_s16_le(
                        table.player[table.boxtype][table.key].y_1) +
                        memory.read_s16_le(
                            table.player[table.boxtype][table.key].y_2)),
                table.border, table.fill)
end

local function draw_moving_box(table)
    gui.drawBox((memory.read_s16_le(table.player[table.boxtype][table.key]
                                        .position.x) -
                    memory.read_s16_le(camera.x)) +
                    (memory.read_s16_le(
                        table.player[table.boxtype][table.key].box.x_1) *
                        table.player_facing),
                (memory.read_s16_le(
                    table.player[table.boxtype][table.key].position.y) -
                    memory.read_s16_le(camera.y)) +
                    memory.read_s16_le(
                        table.player[table.boxtype][table.key].box.y_1),
                (memory.read_s16_le(
                    table.player[table.boxtype][table.key].position.x) -
                    memory.read_s16_le(camera.x)) +
                    ((memory.read_s16_le(
                        table.player[table.boxtype][table.key].box.x_1) +
                        memory.read_s16_le(
                            table.player[table.boxtype][table.key].box.x_2)) *
                        table.player_facing),
                (memory.read_s16_le(
                    table.player[table.boxtype][table.key].position.y) -
                    memory.read_s16_le(camera.y)) +
                    (memory.read_s16_le(
                        table.player[table.boxtype][table.key].box.y_1) +
                        memory.read_s16_le(
                            table.player[table.boxtype][table.key].box.y_2)),
                table.border, table.fill)
end

local function draw_hitboxes(table)
    for key, value in ipairs(table.player.hitbox) do
        local player_facing = facing({player = table.player})

        local border = color.hitbox.border
        local fill = color.hitbox.fill

        if memory.read_s16_le(table.player.hitbox[key].x_2) == -1 then
            border = color.invisible.border
            fill = color.invisible.fill
        end

        draw_box({
            player = table.player,
            player_facing = player_facing,
            boxtype = 'hitbox',
            key = key,
            border = border,
            fill = fill
        })
    end
end

local function draw_active_hitboxes(table)
    for key, value in ipairs(table.player.active_hitbox) do

        local player_facing = facing({player = table.player})

        local player_attack_state = memory.read_u8(table.player.address.attack)

        local border = color.invisible.border
        local fill = color.invisible.fill

        if player_attack_state > 0 then
            border = color.active_hitbox.border
            fill = color.active_hitbox.fill
        end

        draw_box({
            player = table.player,
            player_facing = player_facing,
            boxtype = 'active_hitbox',
            key = key,
            border = border,
            fill = fill
        })
    end
end

local function draw_projectile_hitboxes(table)
    for key, value in ipairs(table.player.projectile_hitbox) do

        local player_facing = facing({player = table.player})

        local player_projectile_state = memory.read_u8(table.player
                                                           .projectile_hitbox[key]
                                                           .state_address)

        local border = color.invisible.border
        local fill = color.invisible.fill

        if player_projectile_state > 0 then
            border = color.active_hitbox.border
            fill = color.active_hitbox.fill
        end

        draw_moving_box({
            player = table.player,
            player_facing = player_facing,
            boxtype = 'projectile_hitbox',
            key = key,
            border = border,
            fill = fill
        })
    end
end

local function draw_vulcan_hitboxes(table)
    for key, value in ipairs(table.player.vulcan_hitbox) do

        local player_facing = facing({player = table.player})
        local player_vulcan_state = memory.read_u8(
                                        table.player.vulcan_hitbox[key]
                                            .state_address)

        local border = color.invisible.border
        local fill = color.invisible.fill

        if player_vulcan_state > 0 then
            border = color.active_hitbox.border
            fill = color.active_hitbox.fill
        end

        draw_moving_box({
            player = table.player,
            player_facing = player_facing,
            boxtype = 'vulcan_hitbox',
            key = key,
            border = border,
            fill = fill
        })
    end
end

local function draw_boxes()
    draw_hitboxes({player = player_1})
    draw_hitboxes({player = player_2})
    draw_active_hitboxes({player = player_1})
    draw_active_hitboxes({player = player_2})
    draw_projectile_hitboxes({player = player_1})
    draw_projectile_hitboxes({player = player_2})
    draw_vulcan_hitboxes({player = player_1})
    draw_vulcan_hitboxes({player = player_2})
end

local menu = {
    [1] = {text = "Player 1", skip = true},
    [2] = {
        text = "Health",
        skip = false,
        state = 1,
        max_state = 2,
        options = {
            [1] = {text = " Normal >", callback = noop},
            [2] = {
                text = "< Infinate",
                callback = one_byte_set_to_max({
                    address = player_1.health.address,
                    max = player_1.health.max
                })
            }
        }
    },
    [3] = {
        text = "Meter",
        skip = false,
        state = 1,
        max_state = 2,
        options = {
            [1] = {text = " Normal >", callback = noop},
            [2] = {
                text = "< Infinate",
                callback = two_byte_set_to_max({
                    address = player_1.meter.address,
                    max = player_1.meter.max
                })
            }
        }
    },
    [4] = {text = "Player 2", skip = true},
    [5] = {
        text = "Health",
        skip = false,
        state = 1,
        max_state = 2,
        options = {
            [1] = {text = " Normal >", callback = noop},
            [2] = {
                text = "< Infinate",
                callback = one_byte_set_to_max({
                    address = player_2.health.address,
                    max = player_2.health.max
                })
            }
        }
    },
    [6] = {
        text = "Meter",
        skip = false,
        state = 1,
        max_state = 2,
        options = {
            [1] = {text = " Normal >", callback = noop},
            [2] = {
                text = "< Infinate",
                callback = two_byte_set_to_max({
                    address = player_2.meter.address,
                    max = player_2.meter.max
                })
            }
        }
    },
    [7] = {text = "Extras", skip = true},
    [8] = {
        text = "Time",
        skip = false,
        state = 1,
        max_state = 2,
        options = {
            [1] = {text = " Normal >", callback = noop},
            [2] = {
                text = "< Infinate",
                callback = one_byte_set_to_max({
                    address = time.address,
                    max = time.max
                })
            }
        }
    },
    [9] = {
        text = "Hitboxes",
        skip = false,
        state = 1,
        max_state = 2,
        options = {
            [1] = {text = " Off >", callback = noop},
            [2] = {text = "< On", callback = draw_boxes}
        }
    }
}

local function run_menu_callbacks()
    for key, value in ipairs(menu) do
        if value.skip == false then value.options[value.state].callback() end
    end
end

local function check_timers()
    if state.timers.overlay >= state.timers.reference_time then
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
    local inputs = joypad.get()
    local line_space_amount = overlay_settings.line_space_amount
    local line_space = overlay_settings.line_space

    for key, value in ipairs(menu) do
        if table_has_key(value, "options") == true then
            menu_text = value["text"] .. " " .. value.options[value.state].text
        else
            menu_text = value.text
        end

        if key == state.flags.menu_state and value.skip == false then
            gui.drawText(0, line_space, ">" .. menu_text, "white", "Black")

            if table_has_key(value, "state") == true and
                table_has_key(value, "max_state") == true then
                if inputs["P1 Right"] == true and state.timers.sub_menu_delay >=
                    overlay_settings.menu_time then
                    value.state = value.state + 1
                    state.timers.sub_menu_delay = 0
                end

                if inputs["P1 Left"] == true and state.timers.sub_menu_delay >=
                    overlay_settings.menu_time then
                    value.state = value.state - 1
                    state.timers.sub_menu_delay = 0
                end

                if inputs["P1 Left"] == true or inputs["P1 Right"] == true then
                    state.timers.sub_menu_delay =
                        state.timers.sub_menu_delay + 1
                end

                if value.state > value.max_state then
                    value.state = value.max_state
                end

                if value.state < 1 then value.state = 1 end
            end

            value.options[value.state].callback()

        elseif key == state.flags.menu_state and value.skip == true then
            gui.drawText(0, line_space, "-" .. menu_text, "white", "Black")
        else
            gui.drawText(0, line_space, " " .. menu_text, "white", "Black")
        end

        line_space = line_space + line_space_amount
    end

    if inputs["P1 Down"] == true or inputs["P1 Up"] == true then
        state.timers.menu_delay = state.timers.menu_delay + 1
    end

    if inputs["P1 Down"] == true and state.timers.menu_delay >=
        overlay_settings.menu_time then
        state.flags.menu_state = state.flags.menu_state + 1
        state.timers.menu_delay = 0
    end

    if inputs["P1 Up"] == true and state.timers.menu_delay >=
        overlay_settings.menu_time then
        state.flags.menu_state = state.flags.menu_state - 1
        state.timers.menu_delay = 0
    end

    if state.flags.menu_state < 1 then state.flags.menu_state = 1 end

    if state.flags.menu_state > #menu then state.flags.menu_state = #menu end
end

while true do
    local inputs = joypad.get()

    if inputs["P1 Start"] == true and inputs["P1 Select"] == true then
        state.timers.overlay = state.timers.overlay + 1
    end

    check_timers()

    if state.flags.overlay == true then overlay() end

    run_menu_callbacks()

    emu.frameadvance()
    gui.clearGraphics()
end
