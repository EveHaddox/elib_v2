local PANEL = {}

AccessorFunc(PANEL, "bg_color", "Color")

eve.CreateFont("Header", 26)

function PANEL:Init()
    self.header = self:Add("Panel")
    self.header:Dock(TOP)
    self.header.Paint = function(pnl, w, h)
        draw.RoundedBoxEx(6, 0, 0, w, h, eve.theme.header, true, true, false, false)
    end

    self.header.title = self.header:Add("DLabel")
    self.header.title:SetFont("eve.Header")
    self.header.title:SetTextColor(eve.theme.primaryText)
end

function PANEL:SetTitle(text)
    self.header.title:SetText(text)
    self.header.title:SizeToContents()
end

function PANEL:PerformLayout(w, h)
    self.header:SetTall(30)
    local title_w, title_h = self.header.title:GetSize()
    self.header.title:SetPos((w - title_w) / 2, (self.header:GetTall() - title_h) / 2)
end

function PANEL:Think()

    if not self.lastTitle_w then
        self.lastTitle_w = 0
    end

    // optimalization
    local title_w, title_h = self.header.title:GetSize()
    if self.lastTitle_w == title_w then return end
    self.lastTitle_w = title_w

    self.header.title:SetPos((self:GetWide() - title_w) / 2, (self.header:GetTall() - title_h) / 2)
end

function PANEL:Paint(w, h)
    draw.RoundedBox(6, 0, 0, w, h, self:GetColor() or eve.theme.background2)
end

vgui.Register("eve.inner.frame", PANEL, "EditablePanel")