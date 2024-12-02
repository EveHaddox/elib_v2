// Script made by Eve Haddox
// discord evehaddox

eve.save = {}

net.Receive("ElibSerervSave", function()
    tblname = net.ReadString()
    eve.save[tblname] = net.ReadTable()
    MsgC(Color(200, 180, 100), "[eve] ", Color(220, 220, 220), "Recived ".. tblname .."\n")
    hook.Run("eveDataRecieved", tblname)
end)