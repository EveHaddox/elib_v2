local PANEL = {}

AccessorFunc(PANEL, "Value", "Value")

eve.CreateFont("config.popup", 26)
eve.CreateFont("config.popup.small", 22)

local matCloseBtn = Material("materials/eve/close.png")

eve.CreateFont("Header", 28)

function PANEL:Init()

    self.header = self:Add("Panel")
    self.header:Dock(TOP)
    self.header.Paint = function(pnl, w, h)
        draw.RoundedBoxEx(6, 0, 0, w, h, eve.theme.header, true, true, false, false)
    end

    self.header.title = self.header:Add("DLabel")
    self.header.title:Dock(LEFT)
    self.header.title:SetFont("eve.Header")
    self.header.title:SetTextColor(eve.theme.primaryText)
    self.header.title:SetTextInset(16, 0)

    self.value = false
    self.default = false

    self.id = nil
    self.addon = nil

    // Buttons
    self.buttons = self:Add("DPanel")
    self.buttons:Dock(BOTTOM)
    self.buttons:SetHeight(40)
    self.buttons:DockMargin(8, 0, 8, 8)

    self.buttons.Paint = function(pnl, w, h)
    end

    self.cancel = self.buttons:Add("eve.button")
    self.cancel:Dock(LEFT)
    self.cancel:DockMargin(0, 0, 4, 0)
    self.cancel:Color(eve.theme.negative, eve.theme.secondaryText)
    self.cancel:SetTxt("Cancel")

    self.cancel:SetWide(200)
    timer.Simple(0.01, function()
        local btnw, btnh = self.buttons:GetSize()
        self.cancel:SetWide(btnw / 2 - 2)
    end)

    self.cancel.DoClick = function()
        surface.PlaySound(eve.sound.click)
        self:Remove()
    end

    self.save = self.buttons:Add("eve.button")
    self.save:Dock(FILL)
    self.save:Color(eve.theme.positive, eve.theme.secondaryText)
    self.save:SetTxt("Save")

    self.save.DoClick = function()
        surface.PlaySound(eve.sound.click)

        // actually save it
        local v1, v2 = self.comboBox:GetSelected()
        if eve.config.addons[self.addon][self.id].value != v1 then
            eve.config.addons[self.addon][self.id].value = v1
            eve.config.unsaved[self.addon] = eve.config.unsaved[self.addon] or {}
            eve.config.unsaved[self.addon][self.id] = true
        end
        self:Remove()
    end

    // text entry
    self.comboBox = self:Add("PIXEL.ComboBox")
    self.comboBox:Dock(BOTTOM)
    self.comboBox:SetSizeToText(false)
    self.comboBox:DockMargin(8, 0, 8, 4)

    // Title and default
    self.textPnl = self:Add("DPanel")
    self.textPnl:Dock(FILL)

    self.textPnl.Paint = function(pnl, w, h)
        draw.SimpleText("Default: ".. tostring(self.default), "eve.config.popup", w / 2, h / 2 - 10, eve.theme.primaryText, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText("Combo Box", "eve.config.popup.small", w / 2, h / 2 + 10, eve.theme.secondaryText, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

end

function PANEL:SetTitle(text)
    self.header.title:SetText(text)
    self.header.title:SizeToContents()
end

function PANEL:SetValue(tbl, id, addon)
    self.comboBox:Clear()
    local i = 0

    for k, v in pairs(eve.config.addons[addon][id].cfg) do
        if v == eve.config.addons[addon][id].value then continue end
        i = i + 1
        self.comboBox:AddChoice(v, k, true)
    end
    self.comboBox:AddChoice(eve.config.addons[addon][id].value, i, true)

    self.default = tbl.default
    self.id = id
    self.addon = addon
end

function PANEL:GetValue(tbl, id, addon)
    local v1, v2 = self.comboBox:GetSelected()
    return v1
end

function PANEL:PerformLayout(w, h)
    self.header:SetTall(35)
end

function PANEL:Paint(w, h)
    draw.RoundedBoxEx(6, 0, 0, w, h, eve.theme.background, true, true, false, false)
    local aX, aY = self:LocalToScreen()

    BSHADOWS.BeginShadow()
    draw.RoundedBox(6, aX, aY, w, h, eve.theme.background)
    BSHADOWS.EndShadow(1, 2, 2)
end

vgui.Register("eve.config.comboBox", PANEL, "EditablePanel")

/*
self.player = self.playerPnl:Add("PIXEL.ComboBox")
self.player:Dock(BOTTOM)
self.player:SetSizeToText(false)

for k, v in pairs(player.GetAll()) do
    if v == LocalPlayer() then continue end
    self.player:AddChoice(v:Nick(), v, true)
end
*/