function eve.CreateFont(name, size, weight)
    surface.CreateFont("eve." .. name, {
        font = "Montserrat SemiBold",
        size = size or 16,
        weight = weight or 500
    })
    return ("eve." .. name)
end