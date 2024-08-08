
local fireArmor = table.deepcopy(data.raw["armor"]["heavy-armor"]) -- copy the table that defines the heavy armor item into the fireArmor variable

fireArmor.name = "fire-armor"
fireArmor.icons = {
  {
    icon = fireArmor.icon,
    icon_size = fireArmor.icon_size,
    tint = {r=1,g=0,b=0,a=0.3}
  },
}

fireArmor.resistances = {
  {
    type = "physical",
    decrease = 6,
    percent = 10
  },
  {
    type = "explosion",
    decrease = 10,
    percent = 30
  },
  {
    type = "acid",
    decrease = 5,
    percent = 30
  },
  {
    type = "fire",
    decrease = 0,
    percent = 100
  }
}

-- create the recipe prototype from scratch
local recipe = {
  type = "recipe",
  name = "fire-armor",
  enabled = true,
  energy_required = 8, -- time to craft in seconds (at crafting speed 1)
  ingredients = {{"copper-plate", 200}, {"steel-plate", 50}},
  result = "fire-armor"
}

data:extend{fireArmor, recipe}


local inserter_item = table.deepcopy(data.raw.item["stack-inserter"])

inserter_item.name = "janky-bulk-inserter"
inserter_item.place_result = "janky-bulk-inserter"

local inserter_ent = table.deepcopy(data.raw.inserter["stack-inserter"])
inserter_ent.name = "janky-bulk-inserter"
inserter_ent.minable.result = "janky-bulk-inserter"
inserter_ent.allow_custom_vectors = true
inserter_ent.flags = {"placeable-off-grid"}

inserter_ent.collision_box = { { -0.2, -0.2 }, { 0.2, 0.2 } }
inserter_ent.collision_mask = {}

local recipe2 = {
    type = "recipe",
    name = "janky-bulk-inserter",
    enabled = true,
    energy_required = 8, -- time to craft in seconds (at crafting speed 1)
    ingredients = {{"copper-plate", 200}, {"steel-plate", 50}},
    result = "janky-bulk-inserter"
}

data:extend {inserter_item, inserter_ent}
data:extend {recipe2}