--LOCALIZATION STRINGS
Hooks:Add("LocalizationManagerPostInit", "RandomHeist_loc", function(loc)
	LocalizationManager:add_localized_strings({
    ["menu_random_heist"] = "Random heist",
    ["menu_random_heist_name"] = "Random heist",
    ["menu_random_heist_desc"] = "For when your team cant decide",
    
    ["menu_random_heist_any_ovk"] = "Random heist (Overkill)",
    ["menu_random_heist_any_ovk_name"] = "Random heist (Overkill)",
    ["menu_random_heist_any_ovk_desc"] = "Random heist on the overkill difficulty",
                
    ["menu_random_heist_any_mayhem"] = "Random heist (Mayhem)",
    ["menu_random_heist_any_mayhem_name"] = "Random heist (Mayhem)",
    ["menu_random_heist_any_mayhem_desc"] = "Random heist on the mayhem difficulty",
                
    ["menu_random_heist_any_dw"] = "Random heist (Death Wish)",
    ["menu_random_heist_any_dw_name"] = "Random heist (Death Wish)",
    ["menu_random_heist_any_dw_desc"] = "Random heist on the death wish difficulty",
                
    ["menu_random_heist_any_ds"] = "Random heist (Death Sentence)",
    ["menu_random_heist_any_ds_name"] = "Random heist (Death Sentence)",
    ["menu_random_heist_any_ds_desc"] = "Random heist on the death sentence difficulty",
                
    ["menu_random_heist_loud_ovk"] = "Random loud heist (Overkill)",
    ["menu_random_heist_loud_ovk_name"] = "Random loud heist (Overkill)",
    ["menu_random_heist_loud_ovk_desc"] = "Random loud heist on the overkill difficulty",
                
    ["menu_random_heist_loud_mayhem"] = "Random loud heist (Mayhem)",
    ["menu_random_heist_loud_mayhem_name"] = "Random loud heist (Mayhem)",
    ["menu_random_heist_loud_mayhem_desc"] = "Random loud heist on the mayhem difficulty",
                
    ["menu_random_heist_loud_dw"] = "Random loud heist (Death Wish)",
    ["menu_random_heist_loud_dw_name"] = "Random loud heist (Death Wish)",
    ["menu_random_heist_loud_dw_desc"] = "Random loud heist on the death wish difficulty",
                
    ["menu_random_heist_loud_ds"] = "Random loud heist (Death Sentence)",
    ["menu_random_heist_loud_ds_name"] = "Random loud heist (Death Sentence)",
    ["menu_random_heist_loud_ds_desc"] = "Random loud heist on the death sentence difficulty",
                
    ["menu_random_heist_stealth_ds"] = "Random stealth heist (Death Sentence)",
    ["menu_random_heist_stealth_ds_name"] = "Random stealth heist (Death Sentence)",
    ["menu_random_heist_stealth_ds_desc"] = "Random stealth heist on the death sentence difficulty",
  })
end)

--CREATE MENU
Hooks:Add("MenuManagerSetupCustomMenus", "MenuManagerSetupCustomMenus_RandomHeist", function(menu_manager, nodes)
	if nodes["lobby"] then
		MenuHelper:NewMenu( "menu_random_heist" )
	end
end)

--ADD MENU TO THE LOBBY SCREEN
Hooks:Add("MenuManagerBuildCustomMenus", "MenuManagerBuildCustomMenus_RandomHeist", function(menu_manager, nodes)
	if nodes["lobby"] and ( not LuaNetworking:IsMultiplayer() or ( LuaNetworking:IsMultiplayer() and LuaNetworking:IsHost() ) ) then
		nodes["menu_random_heist"] = MenuHelper:BuildMenu( "menu_random_heist" )
		MenuHelper:AddMenuItem(nodes["lobby"], "menu_random_heist", "menu_random_heist_name", "menu_random_heist_desc", 1 )
	end
end)

--SUBMENU BUTTONS
Hooks:Add("MenuManagerPopulateCustomMenus", "MenuManagerPopulateCustomMenus_RandomHeist", function(menu_manager, nodes)
    if nodes.lobby then
        MenuCallbackHandler.Random_Heist = function(self, item)
			local create_job =  function(data)
				local difficulty_id = tweak_data:difficulty_to_index(data.difficulty)
				managers.money:on_buy_premium_contract(data.job_id, difficulty_id)
				managers.job:on_buy_job(data.job_id, difficulty_id)
				MenuCallbackHandler:start_job({job_id = data.job_id, difficulty = data.difficulty})
				MenuCallbackHandler:save_progress()
			end
			local job_id_list = tweak_data.narrative:get_jobs_index()
			local rnd_job_id_list = {}
			local job_tweak_data, is_not_dlc_or_got, choose_job, can_afford, retries
			local retry_limit = 10
			local _res = tostring(item._priority)
            local _difficult
            
            --SETS DIFFICULTY
            if _res:find("11") then
				_difficult = "overkill_145"
            elseif _res:find("10") then
				_difficult = "easy_wish"
            elseif _res:find("5") then
				_difficult = "easy_wish"
            elseif _res:find("9") then
				_difficult = "overkill_290"        
			elseif _res:find("4") then
				_difficult = "overkill_290"
            elseif _res:find("8") then
				_difficult = "sm_wish"
			elseif _res:find("3") then
				_difficult = "sm_wish"
            elseif _res:find("1") then
				_difficult = "sm_wish" 
            else
                _difficult = "overkill_145"
            end

            --FILTER HEIST BY LOUD OR STEALTH    
			if _res:find("6") then
				for k, job in pairs(job_id_list) do
					for k2, day in pairs(tweak_data.narrative.jobs[job].chain) do
						if day and day.level_id and tweak_data.levels[day.level_id] then
							if not tweak_data.levels[day.level_id].ghost_bonus then
								table.insert(rnd_job_id_list, job)
							end
						end
					end
				end    
            elseif _res:find("5") then
				for k, job in pairs(job_id_list) do
					for k2, day in pairs(tweak_data.narrative.jobs[job].chain) do
						if day and day.level_id and tweak_data.levels[day.level_id] then
							if not tweak_data.levels[day.level_id].ghost_bonus then
								table.insert(rnd_job_id_list, job)
							end
						end
					end
				end        
            elseif _res:find("4") then
				for k, job in pairs(job_id_list) do
					for k2, day in pairs(tweak_data.narrative.jobs[job].chain) do
						if day and day.level_id and tweak_data.levels[day.level_id] then
							if not tweak_data.levels[day.level_id].ghost_bonus then
								table.insert(rnd_job_id_list, job)
							end
						end
					end
				end            
            elseif _res:find("3") then
				for k, job in pairs(job_id_list) do
					for k2, day in pairs(tweak_data.narrative.jobs[job].chain) do
						if day and day.level_id and tweak_data.levels[day.level_id] then
							if not tweak_data.levels[day.level_id].ghost_bonus then
								table.insert(rnd_job_id_list, job)
							end
						end
					end
				end                        
			elseif _res:find("1") then
				for k, job in pairs(job_id_list) do
					for k2, day in pairs(tweak_data.narrative.jobs[job].chain) do
						log(tostring(day))
						if day and day.level_id and tweak_data.levels[day.level_id] then
							if tweak_data.levels[day.level_id].ghost_bonus then
								table.insert(rnd_job_id_list, job)
							end
						end
					end
				end
			else
				rnd_job_id_list = job_id_list
			end
                
			if not rnd_job_id_list or #rnd_job_id_list < 1 then
				return				
			end
            
            --SETS THE HEIST    
			while (not is_not_dlc_or_got or not can_afford) and ((retries or 0) < retry_limit) do
				choose_job = rnd_job_id_list[math.random( #rnd_job_id_list )]
				job_tweak_data = tweak_data.narrative.jobs[choose_job]
				is_not_dlc_or_got = not job_tweak_data.dlc or managers.dlc:is_dlc_unlocked(job_tweak_data.dlc)
				can_afford = managers.money:can_afford_buy_premium_contract(choose_job, tweak_data:difficulty_to_index(_difficult))
				retries = (retries or 0) + 1
			end
                
            --MAKES SET HEIST CURRENT HEIST    
			if retries < retry_limit then
				create_job({ difficulty = _difficult, job_id = choose_job })
			else
				QuickMenu:new(
					"Error",
					"You cant afford to select a heist!",
					{
						{"Ok", is_cancel_button = true}
					},
					true
				)
			end
		end
            
        --ADDS THE BUTTONS TO SUBMENU
        MenuHelper:AddButton({
            id = "menu_random_heist_any_ovk", 
            title = "menu_random_heist_any_ovk_name", 
            desc = "menu_random_heist_any_ovk_desc",
            callback = "Random_Heist", 
            menu_id = "menu_random_heist",
            priority = 11,
        })
        MenuHelper:AddButton({
            id = "menu_random_heist_any_mayhem", 
            title = "menu_random_heist_any_mayhem_name", 
            desc = "menu_random_heist_any_mayhem_desc",
            callback = "Random_Heist", 
            menu_id = "menu_random_heist",
            priority = 10,
        })
        MenuHelper:AddButton({
            id = "menu_random_heist_any_dw", 
            title = "menu_random_heist_any_dw_name", 
            desc = "menu_random_heist_any_dw_desc",
            callback = "Random_Heist", 
            menu_id = "menu_random_heist",
            priority = 9,
        })
        MenuHelper:AddButton({
            id = "menu_random_heist_any_ds", 
            title = "menu_random_heist_any_ds_name", 
            desc = "menu_random_heist_any_ds_desc",
            callback = "Random_Heist", 
            menu_id = "menu_random_heist",
            priority = 8,
        })
        MenuHelper:AddDivider({
            id = "divider",
            size = 32,
            menu_id = "menu_random_heist",
            priority = 7,
        })
        MenuHelper:AddButton({
            id = "menu_random_heist_loud_ovk", 
            title = "menu_random_heist_loud_ovk_name", 
            desc = "menu_random_heist_loud_ovk_desc",
            callback = "Random_Heist", 
            menu_id = "menu_random_heist",
            priority = 6,
        })
        MenuHelper:AddButton({
            id = "menu_random_heist_loud_mayhem", 
            title = "menu_random_heist_loud_mayhem_name", 
            desc = "menu_random_heist_loud_mayhem_desc",
            callback = "Random_Heist", 
            menu_id = "menu_random_heist",
            priority = 5,
        })
        MenuHelper:AddButton({
            id = "menu_random_heist_loud_dw", 
            title = "menu_random_heist_loud_dw_name", 
            desc = "menu_random_heist_loud_dw_desc",
            callback = "Random_Heist", 
            menu_id = "menu_random_heist",
            priority = 4,
        })
        MenuHelper:AddButton({
            id = "menu_random_heist_loud_ds", 
            title = "menu_random_heist_loud_ds_name", 
            desc = "menu_random_heist_loud_ds_desc",
            callback = "Random_Heist", 
            menu_id = "menu_random_heist",
            priority = 3,
        })
        MenuHelper:AddDivider({
            id = "divider2",
            size = 32,
            menu_id = "menu_random_heist",
            priority = 2,
        })
        MenuHelper:AddButton({
            id = "menu_random_heist_stealth_ds", 
            title = "menu_random_heist_stealth_ds_name", 
            desc = "menu_random_heist_stealth_ds_desc",
            callback = "Random_Heist", 
            menu_id = "menu_random_heist",
            priority = 1,
        })
    end
end)