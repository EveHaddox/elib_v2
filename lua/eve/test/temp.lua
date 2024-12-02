local PANEL = {}

function PANEL:Init()
    self.button = self:Add("eve.button")
    self.button:Dock(TOP)
    self.button:DockMargin(5, 5, 5, 5)
    //self.button:Color(eve.theme.background, eve.theme.secondaryText)
    self.button:SetTxt("testing button")
    self.button.DoClick = function(pnl)
        print("works")
    end

    self.pixelT = self:Add("PIXEL.TextButton")
    self.pixelT:Dock(TOP)
    self.pixelT:DockMargin(5, 0, 5, 5)
    self.pixelT:SetText("testing pixel ui")

    self.onyxB = self:Add("onyx.Button")
    self.onyxB:Dock(TOP)
    self.onyxB:DockMargin(5, 0, 5, 5)
    self.onyxB:SetText("testing onyx's ui")

    self.onyxB:SetGradientColor(Color(12, 54, 88))
    self.onyxB:SetMasking(true)
    self.onyxB:SetGradientDirection(TOP)
end

function PANEL:PerformLayout(w, h)
    self.BaseClass.PerformLayout(self, w, h)
end

vgui.Register("eve.temp", PANEL, "eve.frame")

eve.tests.frame = function()
    local frame = vgui.Create("eve.temp")
    frame:SetSize(800, 600)
    frame:Center()
    frame:MakePopup()
    frame:SetTitle("Test Frame")
end

concommand.Add("eve_test", eve.tests.frame)