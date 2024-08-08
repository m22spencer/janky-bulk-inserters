

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
    input.drop_position = input.position

    output.pickup_position = output.position
    output.drop_position = { x = input.position.x + (input.position.x - input.pickup_position.x) * 1.20
                           , y = input.position.y + (input.position.y - input.pickup_position.y) * 1.20}
    
end

function create(input) 
    local name = name_without_quality(input.name)

    local i = input;

    local s = input.surface.create_entity {
        name = "janky-bulk-furnace-fake",
        position = input.position,
        force = input.force,
        spill = true,
        create_build_effect_smoke = false
    }

    local o = input.surface.create_entity {
        name = name_with_quality("janky-bulk-inserter-fake", find_quality(input.name)),
        position = { x = input.position.x + 0.001, y = input.position.y + 0.001 },
        direction = input.direction,
        force = input.force,
        fast_replace = "",
        spill = false,
        create_build_effect_smoke = false
    }
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
    local i,s,o = create(ev.created_entity or ev.entity)
    update(i,s,o)
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
    local i,s,o = find(ev.created_entity or ev.entity)
    s.destroy()
    o.destroy()
end

local filter =  {{filter = "name", name = "janky-bulk-inserter"}}

script.on_event(defines.events.on_built_entity, on_need_create, filter)
script.on_event(defines.events.on_robot_built_entity, on_need_create, filter)
script.on_event(defines.events.script_raised_built, on_need_create, filter)
script.on_event(defines.events.script_raised_revive, on_need_create, filter)


script.on_event(defines.events.on_player_rotated_entity, on_rotate)


script.on_event(defines.events.on_player_mined_entity, on_destroy, filter)
script.on_event(defines.events.on_robot_mined_entity, on_destroy, filter)
script.on_event(defines.events.on_entity_died, on_destroy, filter)
script.on_event(defines.events.script_raised_destroy, on_destroy, filter)