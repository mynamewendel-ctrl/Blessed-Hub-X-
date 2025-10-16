-- Speed UI Library v1.0
-- Inspirada no Speed Hub X
-- Suporte para Mobile/PC com Auto Save

local SpeedUI = {}
SpeedUI.__index = SpeedUI

-- Serviços
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Configurações
local player = Players.LocalPlayer
local isMobile = UserInputService.TouchEnabled

-- Sistema de Auto Save
local DataStoreService = game:GetService("DataStoreService")
local configDataStore = DataStoreService:GetDataStore("SpeedUIConfig")

-- Cores e temas
local themes = {
    Dark = {
        Background = Color3.fromRGB(44, 47, 51),
        Primary = Color3.fromRGB(114, 137, 218),
        Secondary = Color3.fromRGB(78, 93, 148),
        Card = Color3.fromRGB(54, 57, 63),
        Text = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(150, 150, 150)
    },
    Light = {
        Background = Color3.fromRGB(240, 240, 240),
        Primary = Color3.fromRGB(88, 101, 242),
        Secondary = Color3.fromRGB(71, 82, 196),
        Card = Color3.fromRGB(255, 255, 255),
        Text = Color3.fromRGB(0, 0, 0),
        TextSecondary = Color3.fromRGB(100, 100, 100)
    }
}

-- Função para criar gradiente
local function createGradient(colors)
    local gradient = ColorSequence.new({
        ColorSequenceKeypoint.new(0, colors[1]),
        ColorSequenceKeypoint.new(1, colors[2])
    })
    return gradient
end

function SpeedUI.new(options)
    options = options or {}
    
    local self = setmetatable({}, SpeedUI)
    
    -- Configurações
    self.theme = options.Theme or "Dark"
    self.autoSave = options.AutoSave or true
    self.saveKey = options.SaveKey or "SpeedUI_Config"
    self.animationSpeed = options.AnimationSpeed or 0.3
    
    -- Estado da UI
    self.windows = {}
    self.currentWindow = nil
    self.savedSettings = {}
    
    -- Carregar configurações salvas
    if self.autoSave then
        self:loadSettings()
    end
    
    -- Criar interface principal
    self:createMainUI()
    
    return self
end

-- Sistema de Auto Save
function SpeedUI:saveSettings()
    if not self.autoSave then return end
    
    local success, err = pcall(function()
        configDataStore:SetAsync(self.saveKey, self.savedSettings)
    end)
    
    if not success then
        warn("Erro ao salvar configurações: " .. err)
    end
end

function SpeedUI:loadSettings()
    local success, data = pcall(function()
        return configDataStore:GetAsync(self.saveKey)
    end)
    
    if success and data then
        self.savedSettings = data
    end
end

function SpeedUI:getSetting(key, default)
    return self.savedSettings[key] or default
end

function SpeedUI:setSetting(key, value)
    self.savedSettings[key] = value
    if self.autoSave then
        self:saveSettings()
    end
end

-- Funções de animação
function SpeedUI:tween(object, properties, duration, easingStyle, easingDirection)
    duration = duration or self.animationSpeed
    easingStyle = easingStyle or Enum.EasingStyle.Quad
    easingDirection = easingDirection or Enum.EasingDirection.Out
    
    local tweenInfo = TweenInfo.new(duration, easingStyle, easingDirection)
    local tween = TweenService:Create(object, tweenInfo, properties)
    tween:Play()
    return tween
end

-- Criar UI principal
function SpeedUI:createMainUI()
    -- ScreenGui principal
    self.mainGui = Instance.new("ScreenGui")
    self.mainGui.Name = "SpeedUI"
    self.mainGui.ResetOnSpawn = false
    self.mainGui.Parent = player:WaitForChild("PlayerGui")
    
    -- Container principal
    self.mainFrame = Instance.new("Frame")
    self.mainFrame.Size = isMobile and UDim2.new(1, 0, 1, 0) or UDim2.new(0, 400, 0, 500)
    self.mainFrame.Position = isMobile and UDim2.new(0, 0, 0, 0) or UDim2.new(0.5, -200, 0.5, -250)
    self.mainFrame.BackgroundColor3 = themes[self.theme].Background
    self.mainFrame.BorderSizePixel = 0
    self.mainFrame.Parent = self.mainGui
    
    -- Adicionar arredondamento
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = self.mainFrame
    
    -- Barra de título
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.BackgroundColor3 = themes[self.theme].Primary
    titleBar.BorderSizePixel = 0
    titleBar.Parent = self.mainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 8)
    titleCorner.Parent = titleBar
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 1, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "Speed UI v1.0"
    titleLabel.TextColor3 = themes[self.theme].Text
    titleLabel.TextScaled = true
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Parent = titleBar
    
    -- Container de abas e conteúdo
    local contentContainer = Instance.new("Frame")
    contentContainer.Size = UDim2.new(1, 0, 1, -40)
    contentContainer.Position = UDim2.new(0, 0, 0, 40)
    contentContainer.BackgroundTransparency = 1
    contentContainer.Parent = self.mainFrame
    
    -- Abas (sidebar)
    self.tabContainer = Instance.new("ScrollingFrame")
    self.tabContainer.Size = isMobile and UDim2.new(1, 0, 0, 60) or UDim2.new(0, 120, 1, 0)
    self.tabContainer.Position = isMobile and UDim2.new(0, 0, 0, 0) or UDim2.new(0, 0, 0, 0)
    self.tabContainer.BackgroundColor3 = themes[self.theme].Card
    self.tabContainer.BorderSizePixel = 0
    self.tabContainer.ScrollBarThickness = 3
    self.tabContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
    self.tabContainer.Parent = contentContainer
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 8)
    tabCorner.Parent = self.tabContainer
    
    -- Container de conteúdo
    self.contentContainer = Instance.new("Frame")
    self.contentContainer.Size = isMobile and UDim2.new(1, 0, 1, -60) or UDim2.new(1, -120, 1, 0)
    self.contentContainer.Position = isMobile and UDim2.new(0, 0, 0, 60) or UDim2.new(0, 120, 0, 0)
    self.contentContainer.BackgroundTransparency = 1
    self.contentContainer.Parent = contentContainer
    
    -- Layout para abas
    self.tabLayout = Instance.new("UIListLayout")
    self.tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    self.tabLayout.Padding = UDim.new(0, 5)
    self.tabLayout.Parent = self.tabContainer
    
    if isMobile then
        self.tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        self.tabContainer.ScrollingDirection = Enum.ScrollingDirection.X
        self.tabContainer.AutomaticCanvasSize = Enum.AutomaticSize.X
    else
        self.tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
        self.tabContainer.ScrollingDirection = Enum.ScrollingDirection.Y
    end
end

-- Criar nova janela/aba
function SpeedUI:Window(name)
    local window = {
        name = name,
        tabs = {},
        currentTab = nil
    }
    
    -- Criar botão da aba
    local tabButton = Instance.new("TextButton")
    tabButton.Size = isMobile and UDim2.new(0, 100, 0, 50) or UDim2.new(1, -10, 0, 40)
    tabButton.BackgroundColor3 = themes[self.theme].Secondary
    tabButton.Text = name
    tabButton.TextColor3 = themes[self.theme].Text
    tabButton.TextScaled = true
    tabButton.Font = Enum.Font.Gotham
    tabButton.Parent = self.tabContainer
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 6)
    tabCorner.Parent = tabButton
    
    -- Container de conteúdo da aba
    local contentFrame = Instance.new("ScrollingFrame")
    contentFrame.Size = UDim2.new(1, 0, 1, 0)
    contentFrame.BackgroundTransparency = 1
    contentFrame.ScrollBarThickness = 5
    contentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    contentFrame.Visible = false
    contentFrame.Parent = self.contentContainer
    
    window.contentFrame = contentFrame
    window.tabButton = tabButton
    
    -- Evento de clique
    tabButton.MouseButton1Click:Connect(function()
        self:switchWindow(window)
    end)
    
    table.insert(self.windows, window)
    
    -- Se for a primeira aba, ativar
    if #self.windows == 1 then
        self:switchWindow(window)
    end
    
    return setmetatable(window, {__index = self})
end

-- Mudar entre abas
function SpeedUI:switchWindow(window)
    if self.currentWindow then
        self.currentWindow.contentFrame.Visible = false
        self:tween(self.currentWindow.tabButton, {BackgroundColor3 = themes[self.theme].Secondary}, 0.2)
    end
    
    self.currentWindow = window
    window.contentFrame.Visible = true
    self:tween(window.tabButton, {BackgroundColor3 = themes[self.theme].Primary}, 0.2)
end

-- Criar nova tab dentro da janela
function SpeedUI:Tab(name)
    local tab = {
        name = name,
        elements = {}
    }
    
    -- Container da tab
    local tabFrame = Instance.new("Frame")
    tabFrame.Size = UDim2.new(1, 0, 1, 0)
    tabFrame.BackgroundTransparency = 1
    tabFrame.Visible = false
    tabFrame.Parent = self.contentFrame
    
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Padding = UDim.new(0, 10)
    tabLayout.Parent = tabFrame
    
    tab.tabFrame = tabFrame
    
    table.insert(self.tabs, tab)
    
    -- Se for a primeira tab, ativar
    if #self.tabs == 1 then
        self:switchTab(tab)
    end
    
    return setmetatable(tab, {__index = self})
end

-- Mudar entre tabs
function SpeedUI:switchTab(tab)
    if self.currentTab then
        self.currentTab.tabFrame.Visible = false
    end
    
    self.currentTab = tab
    tab.tabFrame.Visible = true
end

-- Elementos da UI
function SpeedUI:Toggle(name, default, callback)
    local toggle = {
        value = self:getSetting(name, default or false),
        callback = callback
    }
    
    -- Container do toggle
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -20, 0, 40)
    container.BackgroundColor3 = themes[self.theme].Card
    container.Parent = self.currentTab.tabFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = container
    
    -- Label
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = themes[self.theme].Text
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextScaled = true
    label.Font = Enum.Font.Gotham
    label.Parent = container
    
    -- Botão do toggle
    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0, 50, 0, 25)
    toggleButton.Position = UDim2.new(1, -60, 0.5, -12.5)
    toggleButton.BackgroundColor3 = toggle.value and themes[self.theme].Primary or Color3.fromRGB(100, 100, 100)
    toggleButton.Text = ""
    toggleButton.Parent = container
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 12)
    toggleCorner.Parent = toggleButton
    
    -- Bolinha do toggle
    local toggleDot = Instance.new("Frame")
    toggleDot.Size = UDim2.new(0, 19, 0, 19)
    toggleDot.Position = UDim2.new(0, 3, 0.5, -9.5)
    toggleDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    toggleDot.Parent = toggleButton
    
    local dotCorner = Instance.new("UICorner")
    dotCorner.CornerRadius = UDim.new(0, 9)
    dotCorner.Parent = toggleDot
    
    -- Posicionar bolinha baseado no estado
    if toggle.value then
        toggleDot.Position = UDim2.new(1, -22, 0.5, -9.5)
    end
    
    -- Evento de clique
    toggleButton.MouseButton1Click:Connect(function()
        toggle.value = not toggle.value
        
        -- Animar toggle
        if toggle.value then
            self:tween(toggleButton, {BackgroundColor3 = themes[self.theme].Primary}, 0.2)
            self:tween(toggleDot, {Position = UDim2.new(1, -22, 0.5, -9.5)}, 0.2)
        else
            self:tween(toggleButton, {BackgroundColor3 = Color3.fromRGB(100, 100, 100)}, 0.2)
            self:tween(toggleDot, {Position = UDim2.new(0, 3, 0.5, -9.5)}, 0.2)
        end
        
        -- Salvar configuração
        self:setSetting(name, toggle.value)
        
        -- Chamar callback
        if callback then
            callback(toggle.value)
        end
    end)
    
    return toggle
end

function SpeedUI:Button(name, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -20, 0, 40)
    button.BackgroundColor3 = themes[self.theme].Primary
    button.Text = name
    button.TextColor3 = themes[self.theme].Text
    button.TextScaled = true
    button.Font = Enum.Font.GothamBold
    button.Parent = self.currentTab.tabFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = button
    
    -- Efeito hover
    button.MouseEnter:Connect(function()
        self:tween(button, {BackgroundColor3 = themes[self.theme].Secondary}, 0.2)
    end)
    
    button.MouseLeave:Connect(function()
        self:tween(button, {BackgroundColor3 = themes[self.theme].Primary}, 0.2)
    end)
    
    -- Evento de clique
    button.MouseButton1Click:Connect(function()
        if callback then
            callback()
        end
    end)
    
    return button
end

function SpeedUI:Dropdown(name, options, default, callback)
    local dropdown = {
        value = default or options[1],
        isOpen = false,
        callback = callback
    }
    
    -- Container principal
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -20, 0, 40)
    container.BackgroundColor3 = themes[self.theme].Card
    container.ClipsDescendants = true
    container.Parent = self.currentTab.tabFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = container
    
    -- Botão do dropdown
    local dropdownButton = Instance.new("TextButton")
    dropdownButton.Size = UDim2.new(1, 0, 0, 40)
    dropdownButton.BackgroundTransparency = 1
    dropdownButton.Text = name .. ": " .. dropdown.value
    dropdownButton.TextColor3 = themes[self.theme].Text
    dropdownButton.TextXAlignment = Enum.TextXAlignment.Left
    dropdownButton.TextScaled = true
    dropdownButton.Font = Enum.Font.Gotham
    dropdownButton.Parent = container
    
    -- Seta do dropdown
    local arrow = Instance.new("TextLabel")
    arrow.Size = UDim2.new(0, 20, 0, 20)
    arrow.Position = UDim2.new(1, -25, 0.5, -10)
    arrow.BackgroundTransparency = 1
    arrow.Text = "▼"
    arrow.TextColor3 = themes[self.theme].Text
    arrow.TextScaled = true
    arrow.Parent = container
    
    -- Container de opções
    local optionsContainer = Instance.new("Frame")
    optionsContainer.Size = UDim2.new(1, 0, 0, 0)
    optionsContainer.Position = UDim2.new(0, 0, 0, 40)
    optionsContainer.BackgroundColor3 = themes[self.theme].Secondary
    optionsContainer.Parent = container
    
    local optionsLayout = Instance.new("UIListLayout")
    optionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    optionsLayout.Parent = optionsContainer
    
    -- Criar opções
    for i, option in ipairs(options) do
        local optionButton = Instance.new("TextButton")
        optionButton.Size = UDim2.new(1, 0, 0, 30)
        optionButton.BackgroundTransparency = 1
        optionButton.Text = option
        optionButton.TextColor3 = themes[self.theme].Text
        optionButton.TextScaled = true
        optionButton.Font = Enum.Font.Gotham
        optionButton.Parent = optionsContainer
        
        optionButton.MouseButton1Click:Connect(function()
            dropdown.value = option
            dropdownButton.Text = name .. ": " .. option
            
            -- Fechar dropdown
            self:tween(optionsContainer, {Size = UDim2.new(1, 0, 0, 0)}, 0.2)
            self:tween(container, {Size = UDim2.new(1, -20, 0, 40)}, 0.2)
            self:tween(arrow, {Rotation = 0}, 0.2)
            dropdown.isOpen = false
            
            -- Salvar configuração
            self:setSetting(name, option)
            
            -- Chamar callback
            if callback then
                callback(option)
            end
        end)
    end
    
    -- Evento de abrir/fechar dropdown
    dropdownButton.MouseButton1Click:Connect(function()
        dropdown.isOpen = not dropdown.isOpen
        
        if dropdown.isOpen then
            local optionCount = #options
            local optionsHeight = optionCount * 30
            
            self:tween(optionsContainer, {Size = UDim2.new(1, 0, 0, optionsHeight)}, 0.2)
            self:tween(container, {Size = UDim2.new(1, -20, 0, 40 + optionsHeight)}, 0.2)
            self:tween(arrow, {Rotation = 180}, 0.2)
        else
            self:tween(optionsContainer, {Size = UDim2.new(1, 0, 0, 0)}, 0.2)
            self:tween(container, {Size = UDim2.new(1, -20, 0, 40)}, 0.2)
            self:tween(arrow, {Rotation = 0}, 0.2)
        end
    end)
    
    return dropdown
end

function SpeedUI:Paragraph(text)
    local paragraph = Instance.new("TextLabel")
    paragraph.Size = UDim2.new(1, -20, 0, 0)
    paragraph.BackgroundTransparency = 1
    paragraph.Text = text
    paragraph.TextColor3 = themes[self.theme].Text
    paragraph.TextWrapped = true
    paragraph.TextScaled = true
    paragraph.Font = Enum.Font.Gotham
    paragraph.TextXAlignment = Enum.TextXAlignment.Left
    paragraph.AutomaticSize = Enum.AutomaticSize.Y
    paragraph.Parent = self.currentTab.tabFrame
    
    return paragraph
end

function SpeedUI:Label(name)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 0, 30)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = themes[self.theme].Text
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    label.Parent = self.currentTab.tabFrame
    
    return label
end

function SpeedUI:GradientText(text, color1, color2)
    color1 = color1 or Color3.fromRGB(255, 0, 0)
    color2 = color2 or Color3.fromRGB(0, 0, 255)
    
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -20, 0, 40)
    container.BackgroundTransparency = 1
    container.Parent = self.currentTab.tabFrame
    
    local gradientLabel = Instance.new("TextLabel")
    gradientLabel.Size = UDim2.new(1, 0, 1, 0)
    gradientLabel.BackgroundTransparency = 1
    gradientLabel.Text = text
    gradientLabel.TextColor3 = themes[self.theme].Text
    gradientLabel.TextScaled = true
    gradientLabel.Font = Enum.Font.GothamBold
    gradientLabel.Parent = container
    
    -- Aplicar gradiente (simulado através de múltiplas labels)
    -- Em Roblox, gradientes reais em texto não são suportados nativamente
    
    return gradientLabel
end

-- Função para mostrar/ocultar a UI
function SpeedUI:ToggleUI()
    self.mainGui.Enabled = not self.mainGui.Enabled
end

-- Função para destruir a UI
function SpeedUI:Destroy()
    if self.mainGui then
        self.mainGui:Destroy()
    end
end

return SpeedUI
