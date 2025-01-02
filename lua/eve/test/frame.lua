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

function PANEL:OnRemove()
    self:GetParent():Remove()
end

vgui.Register("eve.menuComp", PANEL, "eve.frame")

local PANEL = {}

function PANEL:Init()

    self:Dock(FILL)

    self.cat = self:Add("eve.menuComp")
    self.cat:SetTitle("Test Frame")

    local blurPassesCvar = CreateClientConVar("pixel_ui_blur_passes", "4", true, false, "Amount of passes to draw blur with. 0 to disable blur entirely.", 0, 15)
    local blurPassesNum = blurPassesCvar:SetInt(5)

end

function PANEL:PerformLayout(w, h)
    self.cat:Center()
end

function PANEL:SetSize(w, h)
    self.cat:SetSize(w, h)
end

function PANEL:Paint(w, h)
    PIXEL.DrawBlur(self, 0, 0, w, h)
    surface.SetDrawColor(Color(20, 20, 20, 150))
    surface.DrawRect(0, 0, w, h)
end

vgui.Register("eve.menu", PANEL, "DPanel")

eve.tests.frame = function()
    if IsValid(eve.testFrame) then eve.testFrame:Remove() return end
    eve.testFrame = vgui.Create("eve.menu")
    eve.testFrame:SetSize(800, 600)
    eve.testFrame:Center()
    eve.testFrame:MakePopup()
end

concommand.Add("eve_frame", eve.tests.frame)