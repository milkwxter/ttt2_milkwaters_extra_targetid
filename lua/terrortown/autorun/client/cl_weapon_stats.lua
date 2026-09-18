local mat_tid_ammo = Material("vgui/ttt/tid/tid_lg_ammo.png")

local BaseHUD = baseclass.Get("pure_skin_element")

-- actual target id hook
hook.Add("TTTRenderEntityInfo", "TTT2_HUDDrawTargetID_WeaponStatsExtra", function(tData)
	local client = LocalPlayer()
	local ent = tData:GetEntity()
	
	-- shrimple checks
	if not IsValid(client)
		or not client:IsTerror()
		or not client:Alive()
		or not IsValid(ent)
		or tData:GetEntityDistance() > 100
		or not ent:IsWeapon()
		then return
	end
	
	if not istable(ent.Primary) then return end

	-- show ammo type
	local ammo = ent.Primary.Ammo
	local ammoName = LANG.TryTranslation(string.lower("ammo_" .. ammo))
	if ammoName == "ammo_airboatgun" then
		ammoName = "None"
	end
	tData:AddDescriptionLine(
		LANG.GetParamTranslation("ttt2_milkwater_tid_compatibleAmmo", ammoName),
		nil,
		{mat_tid_ammo}
	)
end)
