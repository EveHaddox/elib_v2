local function load(path)
	AddCSLuaFile(path)
	if CLIENT then
		include(path)
	end
end

if CLIENT and not surface.GetPanelPaintState then
	---@class paint.PanelPaintState
	---@field translate_x integer
	---@field translate_y integer
	---@field scissor_enabled boolean
	---@field scissor_left integer
	---@field scissor_top integer
	---@field scissor_right integer
	---@field scissor_bottom integer
	local panelState = {
		translate_x = 0,
		translate_y = 0,
		scissor_enabled = false,
		scissor_left = 0,
		scissor_bottom = 0,
		scissor_right = 0,
		scissor_top = 0
	}

	---@return paint.PanelPaintState
	---@diagnostic disable-next-line: duplicate-set-field
	function surface.GetPanelPaintState()
		return panelState
	end

	MsgC(Color(255, 20, 20), '[Warning] ', color_white, 'Paint library made a stub for surface.GetPanelPaintState.\n', Color(100, 255, 100), 'It will likely break stuff. Sorry for that.\nWill be removed when surface.GetPanelPaintState will be implemented in gmod\n')
end

load('eve/thirdparty/paint/main_cl.lua')
load('eve/thirdparty/paint/batch_cl.lua')
load('eve/thirdparty/paint/lines_cl.lua')
load('eve/thirdparty/paint/rects_cl.lua')
load('eve/thirdparty/paint/rounded_boxes_cl.lua')
load('eve/thirdparty/paint/outlines_cl.lua')
load('eve/thirdparty/paint/blur_cl.lua')
load('eve/thirdparty/paint/circles_cl.lua')
load('eve/thirdparty/paint/api_cl.lua')
load('eve/thirdparty/paint/svg_cl.lua')
load('eve/thirdparty/paint/masks_cl.lua')
load('eve/thirdparty/paint/downsampling_cl.lua')

--#endregion Load Examples

local VERSION = 1.12

local function coloredMsgC(text)
	local prevRandom
	for i = 1, #text do
		local nowRandom = math.random(0, 360)
		nowRandom = (nowRandom + (prevRandom or nowRandom)) / 2
		prevRandom = nowRandom

		MsgC(HSVToColor(nowRandom, 0.5, 1), string.sub(text, i, i) )
	end
	MsgC('\n')
end

coloredMsgC('paint library has been loaded. Version is: ' .. VERSION)
coloredMsgC('copyright @jaffies, aka @mikhail_svetov')
MsgC(Color(255, 20, 20), '[Warning] ', color_white, 'paint library in recent update (1.1) removed safeguards for radius in outlines/roundedboxes.\n', Color(100, 255, 100), 'It will likely break stuff. Sorry for that.\n')