// Script made by Eve Haddox
// discord evehaddox


util.AddNetworkString("eve:Notification")
function eve:Notify(ply, int, seconds, str)
    net.Start("eve:Notification")
    net.WriteString(str)
    net.WriteUInt(int, 2)
    net.WriteUInt(seconds, 5)
    net.Send(ply)
end