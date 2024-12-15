// Script made by Eve Haddox
// discord evehaddox


// Scaling
function eve.ScaleW(value)
    return math.max(value * (ScrW() / 1920), 1)
end

function eve.ScaleH(value)
    return math.max(value * (ScrH() / 1080), 1)
end

// notiffications
net.Receive("eve:Notification", function()
    notification.AddLegacy(net.ReadString(), net.ReadUInt(2), net.ReadUInt(5))
end)