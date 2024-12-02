eve.config.addons = eve.config.addons or {}
eve.config.unsaved = eve.config.unsaved or {}
eve.config.categories = eve.config.categories or {}

function eve.config:addAddon(name)
    eve.config.addons[name] = eve.config.addons[name] or {}
end

function eve.config:addCategory(addon, realm, name)
    eve.config.categories[addon] = eve.config.categories[addon] or {}
    eve.config.categories[addon][realm] = eve.config.categories[addon][realm] or {}
    eve.config.categories[addon][realm][name] = true
end

function eve.config:addValue(addon, id, title, default, type, realm, order, category, onSave, cfg, pnl)
    if not eve.config.addons[addon] then error("addon not found") return end

    eve.config.addons[addon][id] = {
        title = title,
        value = default,
        default = default,
        type = type,
        realm = realm,
        order = order,
        category = category,
        onSave = onSave or nil,
        cfg = cfg or nil,
        pnl = pnl or nil
    }

end

function eve.config:GetValue(addon, id)
    if SERVER then
        return eve:GetValue(addon, id)
    end

    return eve.config.addons[addon][id].value

end

eve.config:addAddon("elib")

// eve.config:addValue(addon, id, title, default, type, realm, order, category, onSave, cfg, pnl)

/// Realms
-- client
-- server

/// Types
-- int         | number
-- float       | decimal number
-- string      | text
-- bool        | toggle

-- comboBox    | drop down menu
-- table       | list
-- advInt      | limited number with slider
-- custom      | nil 

// Categories
eve.config:addCategory("elib", "client", "Main")
eve.config:addCategory("elib", "client", "Advanced")

eve.config:addCategory("elib", "server", "Main")

// simple
eve.config:addValue("elib", "int", "Number", 1, "int", "client", 1, "Main")
eve.config:addValue("elib", "float", "Decimal Number", 0.5, "float", "client", 2, "Main")
eve.config:addValue("elib", "string", "Text", "testing", "string", "client", 3, "Main")
eve.config:addValue("elib", "boolsus", "Suspicious Toggle", true, "bool", "client", 4, "Main")

// server
eve.config:addValue("elib", "string2", "Text Server", "testing", "string", "server", 1, "Main")

// advanced
eve.config:addValue("elib", "comboBoxtest", "Combo Box Test", "one", "comboBox", "client", 5, "Advanced", nil, {"one", "two", "three"})

eve.config:addValue("elib", "sustable", "Table Test", {"!open", "/open"}, "table", "client", 6, "Advanced")

eve.config:addValue("elib", "advinttest", "Advanced Number", 100, "advInt", "client", 7, "Advanced", nil, 100)

// custom panel
eve.config:addValue("elib", "susitem", "Item Test", {
    name = "Some Name",
    id = 213
}, nil, "client", 9, "Advanced", nil, nil, {"eve.frame", 420, 180})

// custom panel requires 3 parameters in a table {panel, width, height}
// also type must be nil or the panel won't be detected