

function name_without_quality(name)
    return string.match(name, "(.+)-quality%-%d") or name
end

function find_quality(name)
    return tonumber(string.match(name, "-quality%-(%d)")) or 1
end

function name_with_quality(name, quality)
    local level = type(quality) == "table" and quality.level or quality
    return level == 1 and name or name .. "-quality-" .. level
end

function update(input, box, output)
    local delta_x = (input.position.x - input.pickup_position.x)
    local delta_y = (input.position.y - input.pickup_position.y)


    input.drop_position = { x = input.position.x + delta_y * 0.25
                          , y = input.position.y + delta_x * 0.25 }


    output.pickup_position = { x = input.position.x + delta_y * 0.25
                             , y = input.position.y + delta_x * 0.25 }


    output.drop_position = { x = input.position.x + delta_x * 1.2
                           , y = input.position.y +delta_y * 1.2 }
end

function create(input) 
    local i,s,o = find(input)

    local name = name_without_quality(input.name)
    

    if not s then 
            s = input.surface.create_entity {
            name = "janky-bulk-furnace-fake",
            position = input.position,
            force = input.force,
            spill = true,
            create_build_effect_smoke = false
        }
    end

    if not o then
        o = input.surface.create_entity {
            name = name_with_quality("janky-bulk-inserter-fake", find_quality(input.name)),
            position = { x = input.position.x + 0.01, y = input.position.y + 0.01 },
            direction = input.direction,
            force = input.force,
            fast_replace = "",
            spill = false,
            create_build_effect_smoke = false
        }
    end

    o.inserter_filter_mode = "blacklist"
    o.pickup_target = s
    i.drop_target = s

    return i,s,o
end

function find(input)
    local i = input
    local s = nil
    local o = nil

    for _, e in pairs(input.surface.find_entities_filtered{
        area = input.bounding_box
      }) do
        if name_without_quality(e.name) == "janky-bulk-inserter-fake" then
            o = e
        end
        if name_without_quality(e.name) == "janky-bulk-furnace-fake" then
            s = e
        end
    end

    return i,s,o
end


function on_need_create(ev) 
    local entity = ev.created_entity or ev.entity
    if entity then 
        local name = name_without_quality(entity.name)

        if name == "janky-bulk-inserter" then
            local i,s,o = create(entity)
            update(i,s,o)
        end
    end
end

function on_rotate(ev) 
    local entity = ev.created_entity or ev.entity
    if entity then 
        local name = name_without_quality(entity.name)

        if name == "janky-bulk-inserter" then
            local i,s,o = find(entity)
            update(i, s, o)
        end
    end
end

function on_destroy(ev) 
    local entity = ev.created_entity or ev.entity
    if entity then 
        local name = name_without_quality(entity.name)

        if name == "janky-bulk-inserter" then
            local i,s,o = find(entity)
            if s then s.destroy() end
            if o then o.destroy() end
        end
    end
end

script.on_event(defines.events.on_built_entity, on_need_create)
script.on_event(defines.events.on_robot_built_entity, on_need_create)
script.on_event(defines.events.script_raised_built, on_need_create)
script.on_event(defines.events.script_raised_revive, on_need_create)


script.on_event(defines.events.on_player_rotated_entity, on_rotate)




script.on_event(defines.events.on_player_mined_entity, on_destroy)
script.on_event(defines.events.on_robot_mined_entity, on_destroy)
script.on_event(defines.events.on_entity_died, on_destroy)
script.on_event(defines.events.script_raised_destroy, on_destroy)
script.on_event(defines.events.on_player_rotated_entity, on_destroy)