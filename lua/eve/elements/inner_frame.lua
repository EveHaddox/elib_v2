local PANEL = {}

AccessorFunc(PANEL, "bg_color", "Color")
AccessorFunc(PANEL, "Scale", "Scale", FORCE_BOOL)

local function Scale(x)
    if ScrW() < 1920 then
        return PIXEL.Scale(x)
    end
    return x
end

eve.CreateFont("Header", Scale(26))

function PANEL:Init()

    self:SetScale(false)

    self.headerText = "Header"

    self.header = self:Add("Panel")
    self.header:Dock(TOP)
    self.header.Paint = function(pnl, w, h)
        draw.RoundedBoxEx(6, 0, 0, w, h, eve.theme.header, true, true, false, false)
        draw.SimpleText(self.headerText, "eve.Header", w / 2, h / 2, eve.theme.primaryText, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
end

function PANEL:SetTitle(text)
    self.headerText = text
end

function PANEL:PerformLayout(w, h)
    self.header:SetTall(self:GetScale() and Scale(30) or 30)
end

function PANEL:Paint(w, h)
    draw.RoundedBox(6, 0, 0, w, h, self:GetColor() or eve.theme.background2)
end

vgui.Register("eve.inner.frame", PANEL, "EditablePanel")