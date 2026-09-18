local BaseHUD = baseclass.Get("pure_skin_element")

local ammo_types = {
	["item_ammo_357_ttt"] = true,
	["item_ammo_pistol_ttt"] = true,
	["item_ammo_revolver_ttt"] = true,
	["item_ammo_smg1_ttt"] = true,
	["item_box_buckshot_ttt"] = true
}

-- actual target id hook
hook.Add("TTTRenderEntityInfo", "TTT2_HUDDrawTargetID_AmmoBoxes", function(tData)
	local client = LocalPlayer()
	local ent = tData:GetEntity()
	
	-- shrimple checks
	if not IsValid(client) or not client:IsTerror() or not client:Alive() then return end
	if not IsValid(ent) or tData:GetEntityDistance() > 100 or not ammo_types[ent:GetClass()] then return end

	-- enable targetID rendering
	tData:EnableText()
	tData:EnableOutline()
	tData:SetOutlineColor(client:GetRoleColor())

	local ammoName = LANG.TryTranslation(string.lower("ammo_" .. ent.AmmoType))
	tData:SetTitle(LANG.GetParamTranslation("ttt2_milkwater_tid_ammoName", ammoName))
	
	if ent:GetClass() == client:GetActiveWeapon().AmmoEnt then
		tData:SetSubtitle(
			LANG.TryTranslation("ttt2_milkwater_tid_ammoCompatible"),
			Color(76, 187, 23),
			nil
		)
		tData:AddDescriptionLine(LANG.TryTranslation("ttt2_milkwater_tid_ammoPickup"))
	else
		tData:SetSubtitle(
			LANG.TryTranslation("ttt2_milkwater_tid_ammoNotCompatible"),
			Color(255, 20, 60),
			nil
		)
	end
end)
