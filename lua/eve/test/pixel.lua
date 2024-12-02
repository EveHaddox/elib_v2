local PANEL = {}

function PANEL:Init()
    self.button = self:Add("eve.button")
    self.button:Dock(TOP)
    self.button:DockMargin(0, 0, 0, 5)
    self.button:Color(eve.theme.secondary, eve.theme.text.h2)
    self.button:SetTxt("testing button")
    self.button.DoClick = function(pnl)
        print("works")
    end

    self.pixelT = self:Add("PIXEL.TextButton")
    self.pixelT:Dock(TOP)
    self.pixelT:DockMargin(0, 0, 0, 5)
    self.pixelT:SetText("testing pixel ui")
end

function PANEL:PerformLayout(w, h)
    self.BaseClass.PerformLayout(self, w, h)
end

vgui.Register("eve.pixelMenu", PANEL, "PIXEL.Frame")

eve.tests.frame = function()
    local frame = vgui.Create("eve.pixelMenu")
    frame:SetSize(800, 600)
    frame:Center()
    frame:MakePopup()
    frame:SetTitle("Pixel ui test frame")
end

concommand.Add("eve_pixel", eve.tests.frame)