// Script made by Eve Haddox
// discord evehaddox

util.AddNetworkString("ElibSerervSave")

eve.directory = "eve"

function eve.ElibSendToClient(data, tblname)
    net.Start("ElibSerervSave")
    net.WriteString(tblname)
    net.WriteTable(data, false)
    net.Broadcast()
    net.Abort()
    MsgC(Color(100, 150, 200), "[eve] ", Color(220, 220, 220), "Sent to client ".. tblname .."\n")
end

function eve.ElibCreateDir(dir)
    local directory = eve.directory .. "/".. dir
    if not file.Exists(directory, "DATA") then
        file.CreateDir(directory)
        MsgC(Color(100, 150, 200), "[eve] ", Color(220, 220, 220), "Directory created ".. directory .."\n")
    end
    return directory
end

function eve.ElibLoad(dir, name)
    if not file.Exists(dir, "DATA") then
        ElibCreateDir(dir)
        MsgC(Color(192, 69, 69), "[eve] ", Color(220, 220, 220), "Directory not found ".. dir .."\n")
    end
    local filepath = dir .."/".. name ..".txt"
    if file.Exists(filepath, "DATA") then
        local jsonData = file.Read(filepath, "DATA")
        data = util.JSONToTable(jsonData) or {}
        MsgC(Color(100, 150, 200), "[eve] ", Color(220, 220, 220), "Loaded ".. filepath .."\n")
    else
        data = {}
        file.Write(filepath, util.TableToJSON(data, true))
        MsgC(Color(100, 150, 200), "[eve] ", Color(220, 220, 220), "Created ".. filepath .."\n")
    end
    return data
end

function eve.ElibSave(dir, name, data)
    local filepath = dir .."/".. name ..".txt"
    if not file.Exists(filepath, "DATA") then
        ElibLoad(dir, name)
        MsgC(Color(199, 56, 56), "[eve] ", Color(220, 220, 220), "File not found ".. filepath .."\n")
    end
    file.Write(filepath, util.TableToJSON(data, true))
    MsgC(Color(100, 150, 200), "[eve] ", Color(220, 220, 220), "Saved ".. filepath .."\n")
end

concommand.Add("eve_test_dir", function(ply, cmd, args)
    local data = {
        1,
        2,
        "amogus"
    }
    local dir = eve.ElibCreateDir("test") // folder name
    eve.ElibLoad(dir, "susnis") // directory, file name
    eve.ElibSendToClient(data, "testingSave") // table, table's name
    eve.ElibSave(dir, "susnis", data) // directory, file name, table
end)
