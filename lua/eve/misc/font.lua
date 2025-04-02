function eve.CreateFont(name, size, weight)
    eve.scaledFonts = eve.scaledFonts or {}

    surface.CreateFont("eve." .. name, {
        font = "Montserrat SemiBold",
        size = size or 16,
        weight = weight or 500
    })

    eve.scaledFonts[name] = {
        font = "Montserrat SemiBold",
        size = size or 16,
        weight = weight or 500
    }

    hook.Add("OnScreenSizeChanged", "Eve.ReRegisterFonts", function()
        for k,v in pairs(eve.scaledFonts) do
            PIXEL.RegisterFont("eve." .. k, v.font, v.size, v.weight)
        end
    end)

    return ("eve." .. name)
end 