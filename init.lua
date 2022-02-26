minetest.register_tool("electric_screwdriver:electric_screwdriver", {
    description = "Electric Screwdriver",
    inventory_image = "elescrew.png",
    tool_capabilities = {
        full_punch_interval = 1.5,
        max_drop_level = 1,
        groupcaps = {
            crumbly = {
                maxlevel = 2,
                uses = 20,
                times = { [1]=1.60, [2]=1.20, [3]=0.80 }
            },
        },
        damage_groups = {},
    },

    on_place = function(itemstack, placer, pointed_thing)
        local pos = pointed_thing.under
        if pos == nil then
            return
        end
        local node = minetest.get_node(pos)

        local ndef = minetest.registered_nodes[node.name]
 	      if not ndef or not ndef.paramtype2 == "facedir" or
 			(ndef.drawtype == "nodebox" and
 			not ndef.node_box.type == "fixed") or
 			node.param2 == nil then
 		  return
 	    end

        local imeta = itemstack:get_meta()
        imeta:set_int("param2", node.param2)
        imeta:set_string("description", "Electric Screwdriver\nparam2: ".. node.param2)
        return itemstack
    end,

    on_use = function(itemstack, user, pointed_thing)
        local pos = pointed_thing.under
        if pos == nil then
            return
        end
        local node = minetest.get_node(pos)

        if minetest.is_protected(pos, user:get_player_name()) then
		          minetest.record_protection_violation(pos, user:get_player_name())
		      return
	   end

       local ndef = minetest.registered_nodes[node.name]
	      if not ndef or not ndef.paramtype2 == "facedir" or
			(ndef.drawtype == "nodebox" and
			not ndef.node_box.type == "fixed") or
			node.param2 == nil then
		  return
	    end

        local imeta = itemstack:get_meta()
        tmp = imeta:get_int("param2")
        minetest.chat_send_player(user:get_player_name(), "p2: " .. tmp)
        if tmp == nil then
            tmp = 0
        end
        node.param2 = tmp

        minetest.swap_node(pointed_thing.under, node)

    end
})


if minetest.get_modpath("default") then
	minetest.register_craft({
        type = "shaped",
        output = "electric_screwdriver:electric_screwdriver",
		recipe = {
			{"default:steel_ingot"},
			{"default:mese_crystal"},
		},
	})
end
