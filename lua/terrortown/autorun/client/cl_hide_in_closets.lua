local BaseHUD = baseclass.Get("pure_skin_element")

local ADDON_WORKSHOP_ID = "655039219"
local ADDON_INSTALLED = false

local HIDING_SPOTS = {
	["models/props_wasteland/controlroom_storagecloset001b.mdl"] = true,
	["models/props_wasteland/controlroom_storagecloset001a.mdl"] = true,
	["models/props_c17/furnituredresser001a.mdl"] = true,
	["models/props_junk/trashdumpster01a.mdl"] = true,
	["models/props/cs_assault/washer_box.mdl"] = true,
	["models/props/cs_assault/dryer_box2.mdl"] = true,
}

local usekey = Key("+use", "USE")

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
hook.Add("InitPostEntity", "Milkwater_AddonCheck_HideInClosets", function()
    if IsNecessaryAddonInstalled() then
		ADDON_INSTALLED = true
    else
		ADDON_INSTALLED = false
		-- remove the real hook so it never ever fires when addon is not found
		hook.Remove("TTTRenderEntityInfo", "TTT2_HUDDrawTargetID_HideInClosets")
	end
	
	-- all done
    hook.Remove("InitPostEntity", "Milkwater_AddonCheck_HideInClosets")
end)

-- actual target id hook
hook.Add("TTTRenderEntityInfo", "TTT2_HUDDrawTargetID_HideInClosets", function(tData)
	local client = LocalPlayer()
	local ent = tData:GetEntity()
	
	-- if the addon is not installed we just leave
	if not ADDON_INSTALLED then return end
	
	-- only show for living players
	if not IsValid(client) or not client:IsTerror() or not IsValid(ent) then return end
	
	-- mod checks
	local model = ent:GetModel()
	if HIDING_SPOTS[model] == nil then return end
	
	-- final checks
	if tData:GetEntityDistance() > 90 then return end

	-- enable targetID rendering
	tData:EnableText()
	tData:EnableOutline()
	tData:SetOutlineColor(client:GetRoleColor())
	tData:SetKey(input.GetKeyCode(usekey))
    tData:SetTitle(LANG.TryTranslation("ttt2_milkwater_tid_hideinclosets_title"))
	tData:SetSubtitle(LANG.GetParamTranslation("ttt2_milkwater_tid_hideinclosets_subtitle", usekey))
end)
