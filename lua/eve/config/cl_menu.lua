local PANEL = {}

//AccessorFunc(PANEL, "", "")

eve.CreateFont("config.item", 24)

function PANEL:Init()

    // making shure all unsaved data is reset
    for k, v in pairs(eve.config.unsaved) do
        for k1, v1 in pairs(v) do
            eve.config.addons[k][k1].value = eve.config.addons[k][k1].default
        end
    end
    eve.config.unsaved = {}

    self.values = {}
    self.panles = {}

    self.allSaved = true

    local function addValue(id, v, addon)

        local even = table.Count(self.values) % 2 == 0

        if even then
            self.panles[table.Count(self.panles) + 1] = self.main:Add("DPanel")
            local layoutPnl = self.panles[table.Count(self.panles)]
            layoutPnl:Dock(TOP)
            layoutPnl:DockMargin(0, 0, 0, 4)
            layoutPnl:SetHeight(40)

            layoutPnl.Paint = function(pnl, w, h)
            end
        end

        self.values[id] = self.panles[table.Count(self.panles)]:Add("eve.button")
        local pnl = self.values[id]
        pnl:SetTxt(v.title)

        if even then
            pnl:Dock(LEFT)
            pnl:DockMargin(0, 0, 4, 0)
            pnl:SetWide(500) // makes the delay for the actuall size less visible
            timer.Simple(0.05, function()
                if not IsValid(pnl) then return end
                pnl:SetWide(self.panles[table.Count(self.panles)]:GetWide() / 2 - 2)
            end)
        else
            pnl:Dock(FILL)
        end

        function self.checkSaved()
            if not self or not self.values then timer.Remove("eve.config.checkSaved") return end
            if not table.IsEmpty(eve.config.unsaved) and eve.config.unsaved[addon] and not eve.config.unsaved[addon] != nil then
                for k, v in pairs(eve.config.unsaved[addon]) do
                    self.values[k]:Color(eve.theme.negative, eve.theme.secondaryText)
                    self.allSaved = false
                    self.updateSaveButton()
                end
                return
            end
        end

        timer.Create("eve.config.checkSaved", 0.05, 0, self.checkSaved)

        if v.type == "int" then

            self.values[id].DoClick = function()
                surface.PlaySound(eve.sound.click)
                local popup = vgui.Create("eve.config.int")
                popup:SetSize(420, 180)
                popup:Center()
                popup:MakePopup()
                popup:SetTitle(v.title)
                popup:SetValue(v, id, addon)
            end
            
        elseif v.type == "float" then
            
            self.values[id].DoClick = function()
                surface.PlaySound(eve.sound.click)
                local popup = vgui.Create("eve.config.float")
                popup:SetSize(420, 180)
                popup:Center()
                popup:MakePopup()
                popup:SetTitle(v.title)
                popup:SetValue(v, id, addon)
            end

        elseif v.type == "string" then

            self.values[id].DoClick = function()
                surface.PlaySound(eve.sound.click)
                local popup = vgui.Create("eve.config.string")
                popup:SetSize(420, 180)
                popup:Center()
                popup:MakePopup()
                popup:SetTitle(v.title)
                popup:SetValue(v, id, addon)
            end
            
        elseif v.type == "table" then

            self.values[id].DoClick = function()
                surface.PlaySound(eve.sound.click)
                local popup = vgui.Create("eve.config.table")
                popup:SetSize(720, 420)
                popup:Center()
                popup:MakePopup()
                popup:SetTitle(v.title)
                popup:SetValue(v, id, addon)
                popup:drawTabs()
            end
            
        elseif v.type == "bool" then

            self.values[id].DoClick = function()
                surface.PlaySound(eve.sound.click)
                local popup = vgui.Create("eve.config.bool")
                popup:SetSize(420, 180)
                popup:Center()
                popup:MakePopup()
                popup:SetTitle(v.title)
                popup:SetValue(v, id, addon)
            end
            
        elseif v.type == "advInt" then

            self.values[id].DoClick = function()
                surface.PlaySound(eve.sound.click)
                local popup = vgui.Create("eve.config.advanced.int")
                popup:SetSize(420, 180)
                popup:Center()
                popup:MakePopup()
                popup:SetTitle(v.title)
                popup:SetValue(v, id, addon)
            end

        elseif v.type == "comboBox" then

            self.values[id].DoClick = function()
                surface.PlaySound(eve.sound.click)
                local popup = vgui.Create("eve.config.comboBox")
                popup:SetSize(420, 180)
                popup:Center()
                popup:MakePopup()
                popup:SetTitle(v.title)
                popup:SetValue(v, id, addon)
            end
            
        elseif v.type == nil then

            if v.pnl == nil then
                error("WARNING custom panel data not found or wrong panel type")
            end

            self.values[id].DoClick = function()
                surface.PlaySound(eve.sound.click)
                local popup = vgui.Create(v.pnl[1])
                popup:SetSize(v.pnl[2], v.pnl[3])
                popup:Center()
                popup:MakePopup()
                popup:SetTitle(v.title)
                popup:SetValue(v, id, addon)
            end

        end

    end

    function self.selectRealm(id)
        if not self.navbar then return end
        eve.config.generateSidebarTabs()
        eve.generatePage()
    end

    self.realmSelect = self:Add("PIXEL.Navbar")
    self.realmSelect:Dock(TOP)
    self.realmSelect:SetHeight(PIXEL.Scale(32))

    self.realmSelect:AddItem("client", "client", self.selectRealm, 1, eve.theme.primary)
    self.realmSelect:AddItem("server", "server", self.selectRealm, 2, eve.theme.primary)
    self.realmSelect:SelectItem("client")

    function self.selectTab(id)
        eve.config.generateSidebarTabs()
        eve.generatePage()
    end

    self.navbar = self:Add("PIXEL.Navbar")
    self.navbar:Dock(TOP)
    self.navbar:SetHeight(PIXEL.Scale(32))

    self.navbar.count = 0

    for k, v in pairs(eve.config.addons) do
        self.navbar.count = self.navbar.count + 1
        self.navbar:AddItem(k, k, self.selectTab, self.navbar.count, eve.theme.primary)
    end

    self.sidebar = self:Add("PIXEL.Sidebar")
    self.sidebar:Dock(LEFT)
    self.sidebar:SetWide(180)

    function self.sidebarChangeTab(item)

        eve.generatePage()

    end

    self.activeSidebarTabs = {}

    function eve.config.generateSidebarTabs()

        if not table.IsEmpty(self.activeSidebarTabs) then
            for k, v in pairs(self.activeSidebarTabs) do
                self.sidebar:RemoveItem(k)
            end
        end
        self.activeSidebarTabs = {}

        if eve.config.categories == nil or eve.config.categories[self.navbar.SelectedItem] == nil or eve.config.categories[self.navbar.SelectedItem][self.realmSelect.SelectedItem] == nil then return end
        local x = true
        
        for k, v in pairs(eve.config.categories[self.navbar.SelectedItem][self.realmSelect.SelectedItem]) do
            self.activeSidebarTabs[k] = true
            self.sidebar:AddItem(k, k, nil, self.sidebarChangeTab)
            if x then
                self.sidebar:SelectItem(k)
                x = false
            end
        end

        self.sidebar:InvalidateLayout()
    end

    //self.sidebar:AddItem(id, name, imageURL, doClick, order)
    //self.sidebar:AddItem("test", "Test Name", nil, self.sidebarChangeTab)


    self.bottomBar = self:Add("DPanel")
    self.bottomBar:Dock(BOTTOM)
    self.bottomBar:SetHeight(45)

    self.bottomBar.Paint = function(pnl, w, h)
        draw.RoundedBoxEx(6, 0, 0, w, h, eve.theme.background2, false, false, true, true)
    end

    self.save = self.bottomBar:Add("eve.button")
    self.save:Dock(FILL)
    self.save:DockMargin(4, 4, 4, 4)
    self.save:SetWide(100)
    self.save:Color(eve.theme.item, eve.theme.secondaryText)
    self.save:SetTxt("Saved")
    
    function self.updateSaveButton()
        if not self.allSaved then
            self.save:Color(eve.theme.negative, eve.theme.primaryText)
            self.save:SetTxt("Save")
        else
            self.save:Color(eve.theme.item, eve.theme.secondaryText)
            self.save:SetTxt("Saved")
        end
    end

    self.save.DoClick = function()
        if self.allSaved then return end
        surface.PlaySound(eve.sound.click)
        for k, v in pairs(eve.config.unsaved) do
            for k1, v1 in pairs(v) do
                self.values[k1]:Color(eve.theme.item, eve.theme.secondaryText)
    
                net.Start("Eve:SaveValue")
                net.WriteString(k)
                net.WriteString(k1)
    
                local value = eve.config.addons[k][k1].value
                local wrappedValue = { type = type(value), value = value }
                net.WriteString(util.TableToJSON(wrappedValue))
                
                net.SendToServer()
            end
        end
        eve.config.unsaved = {}
        self.allSaved = true
        self.updateSaveButton()
        self.checkSaved()
    end   

    self.main = self:Add("DPanel")
    
    self.main:Dock(FILL)
    self.main:DockMargin(8, 8, 8, 8)
    //self.main:SetScrollBarPadding(8)

    self.main:InvalidateLayout()

    self.main.Paint = function(pnl, w, h)
    end

    function eve.generatePage()

        for k, v in pairs(self.panles) do
            v:Remove()
        end
        self.values = {}
        self.panles = {}

        local sorted = {}
        for id, v in pairs(eve.config.addons[self.navbar.SelectedItem]) do
            if v.category != self.sidebar.SelectedItem then continue end
            v.id = id
            table.Add(sorted, {v})
        end

        table.SortByMember(sorted, "order", true)

        for k, v in pairs(sorted) do
            if v.realm == self.realmSelect.SelectedItem then
                // using a function to make this less messy
                addValue(v.id, v, self.navbar.SelectedItem)
            end
        end
    end

    self.navbar:SelectItem("elib")

end

function PANEL:SelectAddon(addon)
    self.navbar:SelectItem(addon)
end

function PANEL:OnRemove()
    // making shure all unsaved data is reset
    for k, v in pairs(eve.config.unsaved) do
        for k1, v1 in pairs(v) do
            eve.config.addons[k][k1].value = eve.config.addons[k][k1].default
        end
    end
    eve.config.unsaved = {}
end

function PANEL:PerformLayout(w, h)
    self.BaseClass.PerformLayout(self, w, h)
end

function PANEL:Paint(pnl, w, h)
end

vgui.Register("eve.inGameConfig", PANEL, "DPanel")

// adding the menu
eve.configmenu = function()

    if LocalPlayer():IsSuperAdmin() then
        local frame = vgui.Create("eve.frame")
        frame:SetSize(1200, 800)
        frame:Center()
        frame:MakePopup()
        frame:SetTitle("Eve's Config")

        local panel = frame:Add("eve.inGameConfig")
        panel:Dock(FILL)
    end
    
end

concommand.Add("eve_config", eve.configmenu)

hook.Add("OnPlayerChat", "openEvesConfig", function(ply, text, team, dead)
    if text == "!config" or text == "/config" then
        if ply != LocalPlayer() or not LocalPlayer():IsSuperAdmin() then return end
        eve.configmenu()
    end
end)

hook.Add("InitPostEntity", "Eve:LoadData", function()
    net.Start("Eve:LoadData")
    net.SendToServer()
end)

net.Start("Eve:LoadData")
net.SendToServer()

net.Receive("eve.config:UpdateValue", function()
    local addon, id = net.ReadString(), net.ReadString()

    local wrappedValue = util.JSONToTable(net.ReadString())

    local value
    if wrappedValue.type == "boolean" then
        value = tobool(wrappedValue.value)
    elseif wrappedValue.type == "number" then
        value = tonumber(wrappedValue.value)
    elseif wrappedValue.type == "string" then
        value = tostring(wrappedValue.value)
    elseif wrappedValue.type == "table" then
        value = wrappedValue.value
    else
        value = wrappedValue.value
    end

    eve.config.addons[addon][id].value = value

    if eve.config.addons[addon][id].onSave != nil then
        eve.config.addons[addon][id].onSave()
    end
end)

net.Receive("eve.config:NetworkAll", function()
    local int = net.ReadUInt(32)
    local data = net.ReadData(int)
    data = util.Decompress(data)
    data = util.JSONToTable(data) or {}

    for addon, data in pairs(data) do
        for id, value in pairs(data) do
            if eve.config.addons[addon][id].type == "int" or eve.config.addons[addon][id].type == "float" then
                eve.config.addons[addon][id].value = tonumber(value)
            else
                eve.config.addons[addon][id].value = value
            end
        end
    end
end)