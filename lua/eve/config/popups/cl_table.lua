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

    self.value = {}
    self.default = {}

    self.id = nil
    self.addon = nil

    self.tabs = {}

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

        print(self.addon, self.id)
        // actually save it
        if eve.config.addons[self.addon][self.id].value != self.value then
            eve.config.addons[self.addon][self.id].value = self.value
            eve.config.unsaved[self.addon] = eve.config.unsaved[self.addon] or {}
            eve.config.unsaved[self.addon][self.id] = true
            PrintTable(eve.config.unsaved)
        end
        self:Remove()
    end

    // text entry
    self.addBg = self:Add("DPanel")
    self.addBg:Dock(BOTTOM)
    self.addBg:DockMargin(8, 4, 8, 8)
    self.addBg:SetHeight(30)

    self.addBg.Paint = function(pnl, w, h)
    end

    self.addB = self.addBg:Add("eve.button")
    self.addB:Dock(RIGHT)
    self.addB:DockMargin(4, 0, 0, 0)
    self.addB:SetWide(60)
    self.addB:SetTxt("Add")
    self.addB:Color(Color(39, 132, 185), eve.theme.primaryText)

    self.entry = self.addBg:Add("PIXEL.TextEntry")
    self.entry:Dock(FILL)

    self.entry:SetNumeric(false)
    self.entry:SetValue("text")

    self.display = self:Add("DPanel")
    self.display:Dock(FILL)
    self.display:DockMargin(8, 8, 8, 4)
    self.display:DockPadding(4, 4, 4, 4)

    self.display.Paint = function(pnl, w, h)
        draw.RoundedBox(6, 0, 0, w, h, eve.theme.background2)
    end

    self.scroll = self.display:Add("PIXEL.ScrollPanel")
    self.scroll:Dock(FILL)
    self.scroll:DockMargin(0, 0, 0, PIXEL.Scale(4))

    self.addB.DoClick = function()
        surface.PlaySound(eve.sound.click)
        table.insert(self.value, self.entry:GetValue())
        for k, v in pairs(self.tabs) do
            v:Remove()
        end
        for k, v in ipairs(self.value) do
            self.tabs[k] = self.scroll:Add("eve.button")
            local tab = self.tabs[k]
    
            tab:Dock(TOP)
            tab:DockMargin(0, 4, 0, 0)
            tab:SetHeight(30)
            tab:SetTxt(v)
    
            tab.DoClick = function()
                surface.PlaySound(eve.sound.click)
                table.remove(self.value, k)
                tab:Remove()
            end
        end
    end
end

function PANEL:drawTabs()
    for k, v in ipairs(self.value) do
        self.tabs[k] = self.scroll:Add("eve.button")
        local tab = self.tabs[k]

        tab:Dock(TOP)
        tab:DockMargin(0, 4, 0, 0)
        tab:SetHeight(30)
        tab:SetTxt(v)

        tab.DoClick = function()
            surface.PlaySound(eve.sound.click)
            table.remove(self.value, k)
            tab:Remove()
        end
    end
end

function PANEL:SetTitle(text)
    self.header.title:SetText(text)
    self.header.title:SizeToContents()
end

function PANEL:SetValue(tbl, id, addon)
    self.entry:SetValue(tbl.value[1])
    self.default = table.Copy(tbl.default)
    self.value = table.Copy(tbl.value)
    self.id = id
    self.addon = addon
end

function PANEL:GetValue(tbl, id, addon)
    return self.value
end

function PANEL:PerformLayout(w, h)
    self.header:SetTall(35)

    local scrollPad = PIXEL.Scale(8)
    self.scroll:DockMargin(8, 8, scrollPad, 8)

    local spacing = PIXEL.Scale(4)
    local barSpacing = self.scroll:GetVBar().Enabled and PIXEL.Scale(20) or 0
    for k,v in pairs(self.tabs) do
        v:DockMargin(0, 0, barSpacing, spacing)
    end
end

function PANEL:Paint(w, h)
    draw.RoundedBoxEx(6, 0, 0, w, h, eve.theme.background, true, true, false, false)
    local aX, aY = self:LocalToScreen()

    BSHADOWS.BeginShadow()
    draw.RoundedBox(6, aX, aY, w, h, eve.theme.background)
    BSHADOWS.EndShadow(1, 2, 2)
end

vgui.Register("eve.config.table", PANEL, "EditablePanel")