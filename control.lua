


script.on_event(defines.events.on_built_entity, function(ev) 
    local entity = ev.created_entity
    if entity.name == "express-transport-belt-beltbox" then
        game.print("On built: " .. entity.type)

        local i = entity.surface.create_entity {
            name = "janky-bulk-inserter",
            position = {x = entity.position.x, y = entity.position.y},
            direction = entity.direction,
            force = entity.force,
            fast_replace = "",
            spill = false,
            create_build_effect_smoke = false
        }
        i.last_user = entity.last_user
        i.inserter_filter_mode = "blacklist"

        i.drop_target = entity
        i.pickup_position = { x = i.position.x, y = i.position.y - 1 }
        i.drop_position =   { x = i.position.x, y = i.position.y}

        local o = entity.surface.create_entity {
            name = "janky-bulk-inserter",
            position = {x = entity.position.x, y = entity.position.y},
            direction = entity.direction,
            force = entity.force,
            fast_replace = "",
            spill = false,
            create_build_effect_smoke = false
        }
        o.last_user = entity.last_user
        o.inserter_filter_mode = "blacklist"

        o.pickup_target = entity
        o.pickup_position = { x = o.position.x, y = o.position.y }
        o.drop_position =   { x = o.position.x, y = o.position.y + 1}


    end
end)