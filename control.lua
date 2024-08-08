


script.on_event(defines.events.on_built_entity, function(ev) 
    local entity = ev.created_entity
    if entity.name == "janky-bulk-inserter" then
        game.print("On built: " .. entity.type)

        game.print(entity.pickup_position)

        local i = entity;

        local s = entity.surface.create_entity {
            name = "janky-bulk-furnace-fake",
            position = entity.position,
            force = entity.force,
            spill = true,
            create_build_effect_smoke = false
        }

        local o = entity.surface.create_entity {
            name = "janky-bulk-inserter-fake",
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