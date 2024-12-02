// Script made by Eve Haddox
// discord evehaddox

// initiating tables
eve = eve or {}
eve.dir = "eve"
eve.tests = {}
eve.config = eve.config or {}

// manual initializing
function eve.IncludeClient(path)
    local str = eve.dir .. "/" .. path .. ".lua"

    MsgC(Color(200, 180, 100), "[eve] ", Color(220, 220, 220), "client loaded ".. str .."\n")

    if (CLIENT) then
        include(str)
    end

    if (SERVER) then
        AddCSLuaFile(str)
    end
end

function eve.IncludeServer(path)
    local str = eve.dir .. "/" .. path .. ".lua"

    MsgC(Color(100, 150, 200), "[eve] ", Color(220, 220, 220), "server loaded ".. str .."\n")

    if (SERVER) then
        include(str)
    end
end

function eve.IncludeShared(path)
    eve.IncludeServer(path)
    eve.IncludeClient(path)
end

hook.Add("PIXEL.UI.FullyLoaded", "elib", function()
	
	// Main
	eve.IncludeClient("settings/theme")
	
	// Thirdparty
	eve.IncludeClient("thirdparty/bshadows")
	eve.IncludeShared("thirdparty/paint/paint_autorun_sh")

	// Misc
	eve.IncludeClient("misc/font")

	// Functions
	eve.IncludeServer("functions/sv_functions")
	eve.IncludeClient("functions/cl_functions")

	// Elements
	eve.IncludeClient("elements/frame")
	eve.IncludeClient("elements/inner_frame")
	eve.IncludeClient("elements/button")
	eve.IncludeClient("elements/simple_button")
	eve.IncludeClient("elements/tech_three")

	// Tests
	eve.IncludeClient("test/frame")
	eve.IncludeClient("test/temp")

	// Save
	eve.IncludeClient("saving/cl_save")
	eve.IncludeServer("saving/sv_save")

	// config
	eve.IncludeClient("config/popups/cl_int")
	eve.IncludeClient("config/popups/cl_float")
	eve.IncludeClient("config/popups/cl_string")
	eve.IncludeClient("config/popups/cl_bool")
	eve.IncludeClient("config/popups/cl_table")
	eve.IncludeClient("config/popups/cl_item")
	eve.IncludeClient("config/popups/cl_advanced_int")
	eve.IncludeClient("config/popups/cl_combo_box")

	eve.IncludeShared("config/sh_config")
	eve.IncludeClient("config/cl_menu")
	eve.IncludeServer("config/sv_config")

	// sending a message for other addons to load
	hook.Run("evelibPostLoaded")
end)


// Other libraries used by elib

// pixelUI - https://github.com/TomDotBat/pixel-ui
// paint - https://github.com/Jaffies/paint/tree/main
// blue's shadow's - https://gist.github.com/MysteryPancake/a31637af9fd531079236a2577145a754