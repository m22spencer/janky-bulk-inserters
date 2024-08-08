
local inserter_item = table.deepcopy(data.raw.item["stack-filter-inserter"])

inserter_item.name = "janky-bulk-inserter"
inserter_item.place_result = "janky-bulk-inserter"

local inserter_ent = table.deepcopy(data.raw.inserter["stack-filter-inserter"])
inserter_ent.name = "janky-bulk-inserter"
inserter_ent.minable.result = "janky-bulk-inserter"
inserter_ent.allow_custom_vectors = true
inserter_ent.color = {1, 1, 1, 1}



local inserter_fake_ent = table.deepcopy(data.raw.inserter["stack-filter-inserter"])
inserter_fake_ent.name = "janky-bulk-inserter-fake"
inserter_fake_ent.allow_custom_vectors = true
inserter_fake_ent.flags = {"placeable-off-grid", "not-on-map", "not-selectable-in-game"}

inserter_fake_ent.collision_mask = {}

-- Fixes the inserter speed to match the current 1.1 "stack" inserters
if mods["buffed-inserters"] then
    inserter_ent.rotation_speed = inserter_ent.rotation_speed * 0.5
else
    inserter_ent.extension_speed = inserter_ent.extension_speed * 1.15
    inserter_fake_ent.extension_speed = inserter_fake_ent.extension_speed * 1.15
end

local inserter_recipe = {
    type = "recipe",
    name = "janky-bulk-inserter",
    enabled = true,
    energy_required = 8, -- time to craft in seconds (at crafting speed 1)
    ingredients = {{"copper-plate", 200}, {"steel-plate", 50}},
    result = "janky-bulk-inserter"
}


local stack_machine = {
    type = "furnace",
    name = "janky-bulk-furnace-fake",
    flags = {"not-on-map", "not-selectable-in-game", "hidden", "hide-alt-info"},
    crafting_speed = 1000000,
    crafting_categories = {"stacking", "unstacking"},
    result_inventory_size = 1,
    source_inventory_size = 1,
    collision_box = {{-0.2, -0.2}, {0.2, 0.2}},
    energy_source = {
        type = "electric",
        emissions_per_minute = 15,
        usage_priority = "secondary-input",
        drain = "15kW",
    },
    energy_usage = string.format("%dkW", 15),
}


local stack_machine_item = table.deepcopy(data.raw.item["stack-inserter"])
stack_machine_item.name = "janky-bulk-furnace-fake"
stack_machine_item.flags = {"hidden"}

data:extend {inserter_item, inserter_ent, inserter_fake_ent, stack_machine, stack_machine_item, inserter_recipe}