util.AddNetworkString("eve.config:UpdateValue")
function eve.config:SaveValue(addon, id, value)
    local data = file.Read("eve_settings.txt", "DATA") or ""
    data = util.JSONToTable(data) or {}
    data[addon] = data[addon] or {}
    data[addon][id] = value

    net.Start("eve.config:UpdateValue")
    net.WriteString(addon)
    net.WriteString(id)

    local wrappedValue = {
        type = type(value),
        value = value
    }

    net.WriteString(util.TableToJSON(wrappedValue))
    net.Broadcast()
    file.Write("eve_settings.txt", util.TableToJSON(data))

    if eve.config.addons[addon][id].onSave != nil then
        eve.config.addons[addon][id].onSave()
    end
end

function eve:GetValue(addon, id)
    local data = file.Read("eve_settings.txt", "DATA") or ""
    data = util.JSONToTable(data) or {}

    if data[addon] and data[addon][id] then
        return data[addon][id]
    end

    return eve.config.addons[addon][id].value
end

util.AddNetworkString("Eve:SaveValue")
net.Receive("Eve:SaveValue", function(len, ply)
    if not ply:IsSuperAdmin() then return end

    local addon, id = net.ReadString(), net.ReadString()
    local wrappedValue = util.JSONToTable(net.ReadString())

    local value
    if wrappedValue.type == "boolean" then
        value = tobool(wrappedValue.value)
    elseif wrappedValue.type == "number" then
        value = tonumber(wrappedValue.value)
    elseif wrappedValue.type == "string" then
        value = tostring(wrappedValue.value)
    elseif wrappedValue.type == "table" then
        value = wrappedValue.value
    else
        value = wrappedValue.value
    end
    
    eve.config:SaveValue(addon, id, value)
end)

util.AddNetworkString("eve.config:NetworkAll")
hook.Add("Eve:LoadData", "eve.config:Loading", function(ply)
    local data = file.Read("eve_settings.txt", "DATA") or ""
    data = util.JSONToTable(data) or {}
    
    local temp = {}
    for addon, v in pairs(data) do
        if eve.config.addons[addon] then
            temp[addon] = {}

            for str, value in pairs(v) do
                if eve.config.addons[addon][str] != nil then
                    temp[addon][str] = value
                end
            end
        end
    end

    local compressedData = util.Compress(util.TableToJSON(temp))

    net.Start("eve.config:NetworkAll")
    net.WriteUInt(#compressedData, 32)
    net.WriteData(compressedData, #compressedData)
    net.Send(ply)
end)

util.AddNetworkString("Eve:LoadData")
net.Receive("Eve:LoadData", function(len, ply)
    hook.Run("Eve:LoadData", ply)
end)