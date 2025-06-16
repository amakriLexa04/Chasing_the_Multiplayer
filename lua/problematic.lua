----
--#1
----
if (selecting) then
	-- default to whatever skill we had selected last time
	for j,skill in pairs(skills_copy[i]) do
	    for _, equipped_skill in ipairs(skills_equipped) do
	        if (equipped_skill == skill.id) then
			    button.selected_index=j
				break
			end
		end
	end
	
	-- whenever we refresh the menu, update the image and label
	refresh = function(button)
		if (not skills_copy[i][1]) then return end
		dialog["image"..i].label = skills_copy[i][button.selected_index].image
		dialog["label"..i].label = skills_copy[i][button.selected_index].description
		
		-- also update variables
		for j, skill in pairs(skills_copy[i]) do
            result_table[skill.id] = (j == button.selected_index) and "yes" or "no"
            if skill.id == "skill_locked" then 
                result_table[skill.id] = "no"
            end
        end
	end
	
	-- refresh immediately, and after any change
	refresh(button)
	button.on_modified = refresh
end --насправді там else 

----
--#2
----
if (selecting) then
	dialog_result = wesnoth.sync.evaluate_single(function()
        retval = gui.show_dialog( dialog, preshow )
        wml.variables["caster_" .. caster.id .. ".wait_to_select_spells"] = retval==2 and 'yes' or 'no' --not nil, or else the key appears blank
		wesnoth.sync.invoke_command("sync_magic_system_vars", {})
        return result_table
    end)
	
	skills_equipped = {}
	for skill_id,skill_value in pairs(dialog_result) do
	    if skill_value == true then
		    table.insert(skills_equipped, skill_id)
		end
	end
	wml.variables["caster_" .. caster.id .. ".spell_equipped"] = table.concat(skills_equipped, ",")
	wesnoth.sync.invoke_command("sync_magic_system_vars", {})

-- cast spells, synced
else
--якийсь код
end