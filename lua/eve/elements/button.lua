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


// click effect
local function mask(drawMask, draw)
	render.ClearStencil()
	render.SetStencilEnable(true)

	render.SetStencilWriteMask(1)
	render.SetStencilTestMask(1)

	render.SetStencilFailOperation(STENCIL_REPLACE)
	render.SetStencilPassOperation(STENCIL_REPLACE)
	render.SetStencilZFailOperation(STENCIL_KEEP)
	render.SetStencilCompareFunction(STENCIL_ALWAYS)
	render.SetStencilReferenceValue(1)

	drawMask()

	render.SetStencilFailOperation(STENCIL_KEEP)
	render.SetStencilPassOperation(STENCIL_REPLACE)
	render.SetStencilZFailOperation(STENCIL_KEEP)
	render.SetStencilCompareFunction(STENCIL_EQUAL)
	render.SetStencilReferenceValue(1)

	draw()

	render.SetStencilEnable(false)
	render.ClearStencil()
end

local colorRed = Color(255, 0, 0)

local RIPPLE_DIE_TIME = 0.5
local RIPPLE_START_ALPHA = 50

function PANEL:Paint(w, h)

    if self:IsDown() then

        local posX, posY = self:LocalCursorPos()
	    self.rippleEffect = {posX, posY, RealTime()}
        
        //self.color = PIXEL.OffsetColor(self.defColor, 6)

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
    
    eve.paint.startPanel(self)
		mask(function()
			eve.paint.roundedBoxes.roundedBox(6, 0, 0, w, h, self.color)
		end,
		function()
			local ripple = self.rippleEffect

			if ripple == nil then return end

			local rippleX, rippleY, rippleStartTime = ripple[1], ripple[2], ripple[3]

			local percent = (RealTime() - rippleStartTime) / RIPPLE_DIE_TIME

			if percent >= 1 then
				self.rippleEffect = nil
			else
				local alpha = RIPPLE_START_ALPHA * (1 - percent)
				local radius = math.max(w, h) * percent * math.sqrt(2)

				eve.paint.roundedBoxes.roundedBox(radius, rippleX - radius, rippleY - radius, radius * 2, radius * 2, ColorAlpha(PIXEL.OffsetColor(self.defColor, 22), alpha))
			end
		end)
        eve.paint.endPanel()
end

vgui.Register("eve.button", PANEL, "DButton")