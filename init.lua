-- BlenderMesh: Place Lua/WorldEdit/Minetest schematic files in Minetest

minetest.register_chatcommand("placemodel", {
    params = "<filename>",
    description = "Place a Lua/WorldEdit/Minetest schematic at your position. Usage: /placemodel model.lua",
    func = function(name, param)
        if not param or param == "" then
            return false, "Usage: /placemodel <filename.lua>"
        end
        local player = minetest.get_player_by_name(name)
        if not player then return false, "Player not found" end
        local pos = vector.round(player:get_pos())
        pos.y = pos.y + 1
        local path = minetest.get_modpath("BlenderMesh").."/models/"..param
        local ok, model = pcall(dofile, path)
        if not ok or type(model) ~= "table" then
            return false, "Failed to load model: "..tostring(model)
        end
        local count = 0
        for _, entry in ipairs(model) do
            local x, y, z, nodename = unpack(entry)
            minetest.set_node({x=pos.x+x, y=pos.y+y, z=pos.z+z}, {name=nodename})
            count = count + 1
        end
        return true, "Placed "..count.." nodes from "..param
    end
})
