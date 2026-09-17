local mat_tid_stealthdoor = Material("vgui/ttt/tid/tid_quiet")

local BaseHUD = baseclass.Get("pure_skin_element")

local ADDON_WORKSHOP_ID = "2151694266"
local ADDON_INSTALLED = false

-- helper to see if the addon this is for is installed
local function IsNecessaryAddonInstalled()
	for _, addon in ipairs(engine.GetAddons()) do
		if addon.wsid == ADDON_WORKSHOP_ID and addon.mounted then
			return true
		end
	end
	return false
end

-- when client loads into the server, check if they are using the addon
hook.Add("InitPostEntity", "Milkwater_AddonCheck_StealthyDoorOpening", function()
    if IsNecessaryAddonInstalled() then
		ADDON_INSTALLED = true
    else
		ADDON_INSTALLED = false
		-- remove the real hook so it never ever fires when addon is not found
		hook.Remove("TTTRenderEntityInfo", "TTT2_HUDDrawTargetID_StealthyDoors")
	end
	
	-- all done
    hook.Remove("InitPostEntity", "Milkwater_AddonCheck_StealthyDoorOpening")
end)

-- actual target id hook
hook.Add("TTTRenderEntityInfo", "TTT2_HUDDrawTargetID_StealthyDoors", function(tData)
	local client = LocalPlayer()
	local ent = tData:GetEntity()
	
	-- if the addon is not installed we just leave
	if not ADDON_INSTALLED then return end
	
	-- only show for living players
	if not IsValid(client) or not client:IsTerror() or not IsValid(ent) then return end
	
	-- skip invisible entities
	if ent:GetNoDraw() or ent:GetRenderMode() == RENDERMODE_NONE then return end
	
	-- check if entity has a parent door and focus on him if possible
	if not ent:IsDoor() then
		ent = ent:GetMoveParent()
		
		-- still no door
		if not IsValid(ent) or not ent:IsDoor() then return end
	end
	
	-- only rotating doors are supported
	local class = ent:GetClass()
	if class ~= "prop_door_rotating" and class ~= "func_door_rotating" then return end
	
	-- final checks
	if not ent:PlayerCanOpenDoor() or tData:GetEntityDistance() > 90 then return end

	-- add an empty line if there's already data in the description area
	if tData:GetAmountDescriptionLines() > 0 then
		tData:AddDescriptionLine()
	end
	
	-- finally show the stealth door line
	tData:AddDescriptionLine(LANG.TryTranslation("ttt2_milkwater_tid_stealthydoor"), COLOR_LGRAY, {mat_tid_stealthdoor})
end)
