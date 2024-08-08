

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


script.on_event(defines.events.on_built_entity, function(ev) 
    local entity = ev.created_entity

    local name = name_without_quality(entity.name)

    if name == "janky-bulk-inserter" then
        game.print("On built: " .. entity.type .. " name: " .. name)

        local i = entity;

        local s = entity.surface.create_entity {
            name = "janky-bulk-furnace-fake",
            position = entity.position,
            force = entity.force,
            spill = true,
            create_build_effect_smoke = false
        }

        local o = entity.surface.create_entity {
            name = name_with_quality("janky-bulk-inserter-fake", find_quality(entity.name)),
            position = { x = entity.position.x + 0.001, y = entity.position.y + 0.001 },
            direction = entity.direction,
            force = entity.force,
            fast_replace = "",
            spill = false,
            create_build_effect_smoke = false
        }
        o.inserter_filter_mode = "blacklist"

        o.drop_position = i.drop_position
        i.drop_position = i.position;
        o.pickup_position = o.position;

        o.pickup_target = s
        i.drop_target = s
    end
end)