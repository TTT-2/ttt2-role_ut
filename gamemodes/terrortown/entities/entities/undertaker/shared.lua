if SERVER then
	AddCSLuaFile()

	resource.AddFile("materials/vgui/ttt/icon_ut.vmt")
	resource.AddFile("materials/vgui/ttt/sprite_ut.vmt")
end

-- creates global var "TEAM_UNDERTAKER" and other required things
-- TEAM_[name], data: e.g. icon, color,...
InitCustomTeam("UNDERTAKER", {
		icon = "vgui/ttt/sprite_ut",
		color = Color(128, 128, 128, 255)
})

InitCustomRole("UNDERTAKER", { -- first param is access for ROLES array => ROLES["UNDERTAKER"] or ROLES.UNDERTAKER or UNDERTAKER
		color = Color(128, 128, 128, 255), -- ...
		dkcolor = Color(128, 128, 128, 255), -- ...
		bgcolor = Color(128, 128, 128, 200), -- ...
		name = "undertaker", -- just a unique name for the script to determine
		abbr = "ut", -- abbreviation
		team = "undertakers", -- the team name: roles with same team name are working together
		defaultEquipment = INNO_EQUIPMENT, -- here you can set up your own default equipment
		visibleForTraitors = false, -- other traitors can see this role / sync them with traitors
		surviveBonus = 1, -- bonus multiplier for every survive while another player was killed
		scoreKillsMultiplier = 5, -- multiplier for kill of player of another team
		scoreTeamKillsMultiplier = -16, -- multiplier for teamkill
		preventWin = false, -- set true if role can't win (maybe because of own / special win conditions)
		defaultTeam = TEAM_UNDERTAKER -- set/link default team to register it
	}, {
		pct = 0.17, -- necessary: percentage of getting this role selected (per player)
		maximum = 1, -- maximum amount of roles in a round
		minPlayers = 8, -- minimum amount of players until this role is able to get selected
		togglable = true -- option to toggle a role for a client if possible (F1 menu)
})

if CLIENT then
	-- if sync of roles has finished
	hook.Add("TTT2FinishedLoading", "UndertakerInit", function()

		-- setup here is not necessary but if you want to access the role data, you need to start here
		-- setup basic translation !
		LANG.AddToLanguage("English", UNDERTAKER.name, "Undertaker")
		LANG.AddToLanguage("English", "hilite_win_" .. TEAM_UNDERTAKER, "THE UT WON") -- name of base role of a team -> maybe access with GetBaseRole(ROLE_UNDERTAKER) or UNDERTAKER.baserole
		LANG.AddToLanguage("English", "win_" .. TEAM_UNDERTAKER, "The Undertaker has won!") -- teamname
		LANG.AddToLanguage("English", "info_popup_" .. UNDERTAKER.name, [[You are the UNDERTAKER! Kill everyone!]])
		LANG.AddToLanguage("English", "body_found_" .. UNDERTAKER.abbr, "This was a Undertaker...")
		LANG.AddToLanguage("English", "search_role_" .. UNDERTAKER.abbr, "This person was a Undertaker!")
		LANG.AddToLanguage("English", "ev_win_" .. TEAM_UNDERTAKER, "The hardcore Undertaker won the round!")
		LANG.AddToLanguage("English", "target_" .. UNDERTAKER.name, "Undertaker")
		LANG.AddToLanguage("English", "ttt2_desc_" .. UNDERTAKER.name, [[The Undertaker is on his own, but he can defibrilate someone to become his Sidekick!]])

		---------------------------------

		-- maybe this language as well...
		LANG.AddToLanguage("Deutsch", UNDERTAKER.name, "Bestatter")
		LANG.AddToLanguage("Deutsch", "hilite_win_" .. TEAM_UNDERTAKER, "THE UT WON")
		LANG.AddToLanguage("Deutsch", "win_" .. TEAM_UNDERTAKER, "Der Bestatter hat gewonnen!")
		LANG.AddToLanguage("Deutsch", "info_popup_" .. UNDERTAKER.name, [[Du bist DER BESTATTER! Töte alle!]])
		LANG.AddToLanguage("Deutsch", "body_found_" .. UNDERTAKER.abbr, "Er war ein Bestatter...")
		LANG.AddToLanguage("Deutsch", "search_role_" .. UNDERTAKER.abbr, "Diese Person war ein Bestatter!")
		LANG.AddToLanguage("Deutsch", "ev_win_" .. TEAM_UNDERTAKER, "Der knallharte Bestatter hat die Runde gewonnen!")
		LANG.AddToLanguage("Deutsch", "target_" .. UNDERTAKER.name, "Bestatter")
		LANG.AddToLanguage("Deutsch", "ttt2_desc_" .. UNDERTAKER.name, [[Der Bestatter ist auf sich allein gestellt, kann aber tote Spieler zum Sidekick respawnen!]])
	end)

end

if SERVER then

	UNDERTAKER_MAIN = nil
	UNDERTAKER_LIST = {}

	hook.Add("TTT2UpdateSubrole", "UpdateUtRoleSelect", function(ply, oldSubrole, newSubrole)
		if newSubrole == ROLE_UNDERTAKER and not UNDERTAKER_MAIN then
			UNDERTAKER_MAIN = ply
			UNDERTAKER_LIST[ply] = {}
			ply:Give("weapon_ut_defibrilator")

		elseif newSubrole == ROLE_UNDERTAKER then
			UNDERTAKER_LIST[ply] = {}
		elseif oldSubrole == ROLE_UNDERTAKER and UNDERTAKER_MAIN == ply then
			UNDERTAKER_MAIN = nilaw
			UNDERTAKER_LIST[ply] = nil
			ply:StripWeapon("weapon_ut_defibrilator")
			local keyset = {}
			for k in pairs(UNDERTAKER_LIST) do
				table.insert(keyset, k)
			end
			newMain = keyset[math.random(#keyset)]
			if newMain then
				UNDERTAKER_MAIN = newMain
				newMain:Give("weapon_ut_defibrilator")
			end
		elseif oldSubrole == ROLE_UNDERTAKER and UNDERTAKER then
			UNDERTAKER_LIST[ply] = nil
		end
	end)




end
