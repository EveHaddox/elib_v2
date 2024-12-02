// Script made by Eve Haddox
// discord evehaddox


net.Receive("eve:Notification", function()
    notification.AddLegacy(net.ReadString(), net.ReadUInt(2), net.ReadUInt(5))
end)