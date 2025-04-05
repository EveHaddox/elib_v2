local PANEL = {}

local matCloseBtn = Material("materials/eve/close.png")

local function Scale(x)
    if ScrW() < 1920 then
        return PIXEL.Scale(x)
    end
    return x
end

eve.CreateFont("Header", Scale(26))

function PANEL:Init()
    self.header = self:Add("Panel")
    self.header:Dock(TOP)
    self.header.Paint = function(pnl, w, h)
        draw.RoundedBoxEx(6, 0, 0, w, h, eve.theme.header, true, true, false, false)
        draw.RoundedBox(0, 0, h - 1, w, 1, PIXEL.OffsetColor(eve.theme.header, 10))
    end

    self.header.closeBtn = self.header:Add("DButton")
    self.header.closeBtn:Dock(RIGHT)
    self.header.closeBtn:SetText("")
    self.header.closeBtn.DoClick = function(pnl)
        self:Remove()
        surface.PlaySound(eve.sound.click)
    end
    self.header.closeBtn.margin = Scale(16)
    self.header.closeBtn.Paint = function(pnl, w, h)
        local margin = pnl.margin

        local color = eve.theme.primaryText
        if self.header.closeBtn:IsHovered() then
            color = eve.theme.negative
        end

        surface.SetDrawColor(color)
        surface.SetMaterial(matCloseBtn)
        surface.DrawTexturedRect(margin, margin, w - (margin * 2), h - (margin * 2))
    end

    self.header.title = self.header:Add("DLabel")
    self.header.title:Dock(LEFT)
    self.header.title:SetFont("eve.Header")
    self.header.title:SetTextColor(eve.theme.primaryText)
    self.header.title:SetTextInset(16, 0)
end

function PANEL:SetTitle(text)
    self.header.title:SetText(text)
    self.header.title:SizeToContents()
end

function PANEL:PerformLayout(w, h)
    self.header:SetTall(Scale(eve.UISizes.header.height))
    self.header.closeBtn:SetWide(self.header:GetTall())
end

function PANEL:Paint(w, h)
    local aX, aY = self:LocalToScreen()

    BSHADOWS.BeginShadow()
        draw.RoundedBox(6, aX, aY, w, h, eve.theme.background)
    BSHADOWS.EndShadow(1, 2, 2)
end

vgui.Register("eve.frame", PANEL, "EditablePanel")