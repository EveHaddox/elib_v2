local PANEL = {}

eve.CreateFont("button", 22)

function PANEL:Init()

    self.defColor = eve.theme.item
    self.color = self.defColor
    self.hover = true

    self:SetText("")
    self.DoClick = function(pnl)
        surface.PlaySound(eve.sound.click)
        self:Remove()
    end

    self.textbg = self:Add("DLabel")
    self.textbg:SetFont("eve.button")
    self.textbg:SetTextColor(eve.theme.black)

    self.text = self:Add("DLabel")
    self.text:SetFont("eve.button")
    self.text:SetTextColor(eve.theme.secondaryText)

    self.text.color = eve.theme.secondaryText
end

function PANEL:Color(color, txtCl)
    self.color = color
    self.defColor = color
    self.text.color = txtCl
    self.text:SetTextColor(txtCl)
end

function PANEL:SetTxt(txt)
    self.text:SetText(txt)
    self.text:SizeToContents()
    self.textbg:SetText(txt)
    self.textbg:SizeToContents()
end

function PANEL:PerformLayout(w, h)
    self.BaseClass.PerformLayout(self, w, h)
    surface.SetFont("eve.button")
    local tw, th = surface.GetTextSize(self.text:GetText())
    self.text:SetPos((w - tw) / 2, (h - th) / 2)
    self.textbg:SetPos((w - tw) / 2 + 1, (h - th) / 2 + 1)
end

function PANEL:Paint(w, h)

    if self:IsDown() then

        self.color = PIXEL.OffsetColor(self.defColor, -6)
        if self.hover then
            self.hover = false
            --surface.PlaySound(eve.sound.click)
        end

    elseif self:IsHovered() then

        self.color = PIXEL.OffsetColor(self.defColor, -6)
        if self.hover then
            self.hover = false
            surface.PlaySound(eve.sound.hover)
        end

    else
        self.color = self.defColor
        self.hover = true
    end

    draw.RoundedBox(6, 0, 0, w, h, self.color)
end

vgui.Register("eve.simple.button", PANEL, "DButton")