local PANEL = {}

function PANEL:Init()
    self.cat = self:Add("PIXEL.Category")
    self.cat:Dock(TOP)
    self.cat:DockMargin(5, 5, 5, 5)
    self.cat:SetTitle("Thesting Category")

    self.pixelT = self.cat:Add("PIXEL.TextButton")
    self.pixelT:Dock(TOP)
    self.pixelT:DockMargin(5, 5, 5, 5)
    self.pixelT:SetText("testing button")

    self.pixelT1 = self.cat:Add("PIXEL.TextButton")
    self.pixelT1:Dock(TOP)
    self.pixelT1:DockMargin(5, 0, 5, 5)
    self.pixelT1:SetText("testing button")
end

function PANEL:PerformLayout(w, h)
    self.BaseClass.PerformLayout(self, w, h)
end

vgui.Register("eve.menu", PANEL, "eve.frame")

eve.tests.frame = function()
    local frame = vgui.Create("eve.menu")
    frame:SetSize(800, 600)
    frame:Center()
    frame:MakePopup()
    frame:SetTitle("Test Frame")
end

concommand.Add("eve_frame", eve.tests.frame)