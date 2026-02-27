--[[
    BreezeUI - Roblox UI Library
    Uma biblioteca de UI completa estilo WindUI
    
    Uso:
        local BreezeUI = loadstring(game:HttpService:GetAsync("URL_AQUI"))()
        
        local Window = BreezeUI:CreateWindow({
            Title = "Meu Hub",
            SubTitle = "v1.0",
            Theme = "Dark",
            Size = UDim2.new(0, 550, 0, 400),
            Transparent = false,
        })
        
        local Tab = Window:AddTab({ Title = "Principal", Icon = "rbxassetid://0" })
        
        Tab:AddButton({
            Title = "Clique aqui",
            Callback = function()
                print("Clicou!")
            end,
        })
--]]

-- =============================================
-- SERVICOS
-- =============================================
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

-- =============================================
-- BIBLIOTECA PRINCIPAL
-- =============================================
local BreezeUI = {}
BreezeUI.__index = BreezeUI
BreezeUI._Version = "1.0.0"
BreezeUI._Windows = {}

-- =============================================
-- TEMAS
-- =============================================
local Themes = {
    Dark = {
        Background = Color3.fromRGB(25, 25, 35),
        SecondaryBackground = Color3.fromRGB(30, 30, 42),
        TertiaryBackground = Color3.fromRGB(35, 35, 50),
        Card = Color3.fromRGB(40, 40, 55),
        CardHover = Color3.fromRGB(50, 50, 68),
        Accent = Color3.fromRGB(88, 101, 242),
        AccentHover = Color3.fromRGB(108, 121, 255),
        Text = Color3.fromRGB(235, 235, 245),
        SubText = Color3.fromRGB(160, 160, 180),
        Divider = Color3.fromRGB(55, 55, 75),
        Toggle_On = Color3.fromRGB(88, 201, 120),
        Toggle_Off = Color3.fromRGB(80, 80, 100),
        Slider_Fill = Color3.fromRGB(88, 101, 242),
        Slider_Background = Color3.fromRGB(55, 55, 75),
        Input_Background = Color3.fromRGB(30, 30, 42),
        Input_Border = Color3.fromRGB(60, 60, 80),
        Notification_BG = Color3.fromRGB(35, 35, 50),
        Shadow = Color3.fromRGB(0, 0, 0),
        TabActive = Color3.fromRGB(88, 101, 242),
        TabInactive = Color3.fromRGB(50, 50, 68),
    },
    Light = {
        Background = Color3.fromRGB(240, 240, 248),
        SecondaryBackground = Color3.fromRGB(230, 230, 240),
        TertiaryBackground = Color3.fromRGB(220, 220, 232),
        Card = Color3.fromRGB(255, 255, 255),
        CardHover = Color3.fromRGB(245, 245, 252),
        Accent = Color3.fromRGB(88, 101, 242),
        AccentHover = Color3.fromRGB(70, 83, 220),
        Text = Color3.fromRGB(30, 30, 45),
        SubText = Color3.fromRGB(100, 100, 120),
        Divider = Color3.fromRGB(200, 200, 215),
        Toggle_On = Color3.fromRGB(72, 185, 105),
        Toggle_Off = Color3.fromRGB(180, 180, 195),
        Slider_Fill = Color3.fromRGB(88, 101, 242),
        Slider_Background = Color3.fromRGB(200, 200, 215),
        Input_Background = Color3.fromRGB(245, 245, 252),
        Input_Border = Color3.fromRGB(200, 200, 215),
        Notification_BG = Color3.fromRGB(255, 255, 255),
        Shadow = Color3.fromRGB(150, 150, 165),
        TabActive = Color3.fromRGB(88, 101, 242),
        TabInactive = Color3.fromRGB(210, 210, 225),
    },
    Midnight = {
        Background = Color3.fromRGB(15, 15, 25),
        SecondaryBackground = Color3.fromRGB(20, 20, 32),
        TertiaryBackground = Color3.fromRGB(25, 25, 38),
        Card = Color3.fromRGB(28, 28, 42),
        CardHover = Color3.fromRGB(38, 38, 55),
        Accent = Color3.fromRGB(130, 80, 245),
        AccentHover = Color3.fromRGB(150, 100, 255),
        Text = Color3.fromRGB(230, 230, 245),
        SubText = Color3.fromRGB(140, 140, 165),
        Divider = Color3.fromRGB(45, 45, 65),
        Toggle_On = Color3.fromRGB(130, 80, 245),
        Toggle_Off = Color3.fromRGB(60, 60, 80),
        Slider_Fill = Color3.fromRGB(130, 80, 245),
        Slider_Background = Color3.fromRGB(45, 45, 65),
        Input_Background = Color3.fromRGB(20, 20, 32),
        Input_Border = Color3.fromRGB(50, 50, 70),
        Notification_BG = Color3.fromRGB(25, 25, 38),
        Shadow = Color3.fromRGB(0, 0, 0),
        TabActive = Color3.fromRGB(130, 80, 245),
        TabInactive = Color3.fromRGB(40, 40, 58),
    },
    Ocean = {
        Background = Color3.fromRGB(15, 25, 35),
        SecondaryBackground = Color3.fromRGB(18, 30, 42),
        TertiaryBackground = Color3.fromRGB(22, 35, 48),
        Card = Color3.fromRGB(25, 40, 55),
        CardHover = Color3.fromRGB(30, 50, 68),
        Accent = Color3.fromRGB(0, 180, 216),
        AccentHover = Color3.fromRGB(0, 200, 240),
        Text = Color3.fromRGB(225, 240, 250),
        SubText = Color3.fromRGB(140, 170, 190),
        Divider = Color3.fromRGB(35, 55, 75),
        Toggle_On = Color3.fromRGB(0, 180, 216),
        Toggle_Off = Color3.fromRGB(50, 70, 90),
        Slider_Fill = Color3.fromRGB(0, 180, 216),
        Slider_Background = Color3.fromRGB(35, 55, 75),
        Input_Background = Color3.fromRGB(18, 30, 42),
        Input_Border = Color3.fromRGB(40, 60, 80),
        Notification_BG = Color3.fromRGB(22, 35, 48),
        Shadow = Color3.fromRGB(0, 0, 0),
        TabActive = Color3.fromRGB(0, 180, 216),
        TabInactive = Color3.fromRGB(30, 48, 65),
    },
}

-- =============================================
-- UTILIDADES
-- =============================================
local Utilities = {}

function Utilities:Tween(instance, properties, duration, easingStyle, easingDirection)
    duration = duration or 0.25
    easingStyle = easingStyle or Enum.EasingStyle.Quart
    easingDirection = easingDirection or Enum.EasingDirection.Out
    
    local tweenInfo = TweenInfo.new(duration, easingStyle, easingDirection)
    local tween = TweenService:Create(instance, tweenInfo, properties)
    tween:Play()
    return tween
end

function Utilities:CreateCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = parent
    return corner
end

function Utilities:CreateStroke(parent, color, thickness, transparency)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Color3.fromRGB(60, 60, 80)
    stroke.Thickness = thickness or 1
    stroke.Transparency = transparency or 0.5
    stroke.Parent = parent
    return stroke
end

function Utilities:CreatePadding(parent, top, bottom, left, right)
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, top or 8)
    padding.PaddingBottom = UDim.new(0, bottom or 8)
    padding.PaddingLeft = UDim.new(0, left or 8)
    padding.PaddingRight = UDim.new(0, right or 8)
    padding.Parent = parent
    return padding
end

function Utilities:CreateListLayout(parent, padding, direction, hAlign, vAlign, sortOrder)
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, padding or 6)
    layout.FillDirection = direction or Enum.FillDirection.Vertical
    layout.HorizontalAlignment = hAlign or Enum.HorizontalAlignment.Center
    layout.VerticalAlignment = vAlign or Enum.VerticalAlignment.Top
    layout.SortOrder = sortOrder or Enum.SortOrder.LayoutOrder
    layout.Parent = parent
    return layout
end

function Utilities:CreateShadow(parent, theme)
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    shadow.BackgroundTransparency = 1
    shadow.Position = UDim2.new(0.5, 0, 0.5, 4)
    shadow.Size = UDim2.new(1, 30, 1, 30)
    shadow.ZIndex = parent.ZIndex - 1
    shadow.Image = "rbxassetid://6015897843"
    shadow.ImageColor3 = theme.Shadow
    shadow.ImageTransparency = 0.5
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(49, 49, 450, 450)
    shadow.Parent = parent
    return shadow
end

function Utilities:GenerateId()
    return HttpService:GenerateGUID(false)
end

function Utilities:Ripple(button, theme)
    local ripple = Instance.new("Frame")
    ripple.Name = "Ripple"
    ripple.AnchorPoint = Vector2.new(0.5, 0.5)
    ripple.BackgroundColor3 = theme.Accent
    ripple.BackgroundTransparency = 0.7
    ripple.BorderSizePixel = 0
    ripple.Position = UDim2.new(0.5, 0, 0.5, 0)
    ripple.Size = UDim2.new(0, 0, 0, 0)
    ripple.ZIndex = button.ZIndex + 1
    ripple.ClipsDescendants = true
    ripple.Parent = button
    Utilities:CreateCorner(ripple, 100)
    
    local maxSize = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 2
    Utilities:Tween(ripple, {Size = UDim2.new(0, maxSize, 0, maxSize), BackgroundTransparency = 1}, 0.5)
    
    task.delay(0.5, function()
        if ripple and ripple.Parent then
            ripple:Destroy()
        end
    end)
end

-- =============================================
-- SISTEMA DE NOTIFICACOES
-- =============================================
local NotificationSystem = {}
NotificationSystem.__index = NotificationSystem

function NotificationSystem.new(screenGui, theme)
    local self = setmetatable({}, NotificationSystem)
    self.Theme = theme
    
    self.Container = Instance.new("Frame")
    self.Container.Name = "NotificationContainer"
    self.Container.BackgroundTransparency = 1
    self.Container.Position = UDim2.new(1, -320, 1, -20)
    self.Container.Size = UDim2.new(0, 300, 0, 0)
    self.Container.AnchorPoint = Vector2.new(0, 1)
    self.Container.ZIndex = 100
    self.Container.Parent = screenGui
    
    Utilities:CreateListLayout(self.Container, 8, Enum.FillDirection.Vertical, 
        Enum.HorizontalAlignment.Right, Enum.VerticalAlignment.Bottom)
    
    return self
end

function NotificationSystem:Notify(config)
    config = config or {}
    local title = config.Title or "Notificacao"
    local content = config.Content or ""
    local duration = config.Duration or 4
    local notifType = config.Type or "Info" -- Info, Success, Warning, Error
    
    local typeColors = {
        Info = self.Theme.Accent,
        Success = Color3.fromRGB(72, 199, 116),
        Warning = Color3.fromRGB(255, 183, 77),
        Error = Color3.fromRGB(239, 83, 80),
    }
    
    local accentColor = typeColors[notifType] or self.Theme.Accent
    
    -- Container da notificacao
    local notifFrame = Instance.new("Frame")
    notifFrame.Name = "Notification"
    notifFrame.BackgroundColor3 = self.Theme.Notification_BG
    notifFrame.Size = UDim2.new(1, 0, 0, 0)
    notifFrame.AutomaticSize = Enum.AutomaticSize.Y
    notifFrame.ClipsDescendants = true
    notifFrame.ZIndex = 100
    notifFrame.Parent = self.Container
    Utilities:CreateCorner(notifFrame, 10)
    Utilities:CreateStroke(notifFrame, accentColor, 1, 0.3)
    
    -- Barra de cor lateral
    local accentBar = Instance.new("Frame")
    accentBar.Name = "AccentBar"
    accentBar.BackgroundColor3 = accentColor
    accentBar.Size = UDim2.new(0, 4, 1, 0)
    accentBar.Position = UDim2.new(0, 0, 0, 0)
    accentBar.BorderSizePixel = 0
    accentBar.ZIndex = 101
    accentBar.Parent = notifFrame
    Utilities:CreateCorner(accentBar, 2)
    
    -- Conteudo interno
    local innerFrame = Instance.new("Frame")
    innerFrame.Name = "Inner"
    innerFrame.BackgroundTransparency = 1
    innerFrame.Size = UDim2.new(1, -12, 0, 0)
    innerFrame.Position = UDim2.new(0, 12, 0, 0)
    innerFrame.AutomaticSize = Enum.AutomaticSize.Y
    innerFrame.ZIndex = 101
    innerFrame.Parent = notifFrame
    Utilities:CreatePadding(innerFrame, 10, 10, 4, 8)
    Utilities:CreateListLayout(innerFrame, 4, Enum.FillDirection.Vertical, 
        Enum.HorizontalAlignment.Left, Enum.VerticalAlignment.Top)
    
    -- Titulo
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.BackgroundTransparency = 1
    titleLabel.Size = UDim2.new(1, 0, 0, 0)
    titleLabel.AutomaticSize = Enum.AutomaticSize.Y
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Text = title
    titleLabel.TextColor3 = self.Theme.Text
    titleLabel.TextSize = 14
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.ZIndex = 102
    titleLabel.Parent = innerFrame
    
    -- Conteudo
    if content ~= "" then
        local contentLabel = Instance.new("TextLabel")
        contentLabel.Name = "Content"
        contentLabel.BackgroundTransparency = 1
        contentLabel.Size = UDim2.new(1, 0, 0, 0)
        contentLabel.AutomaticSize = Enum.AutomaticSize.Y
        contentLabel.Font = Enum.Font.Gotham
        contentLabel.Text = content
        contentLabel.TextColor3 = self.Theme.SubText
        contentLabel.TextSize = 12
        contentLabel.TextXAlignment = Enum.TextXAlignment.Left
        contentLabel.TextWrapped = true
        contentLabel.ZIndex = 102
        contentLabel.Parent = innerFrame
    end
    
    -- Barra de progresso
    local progressBG = Instance.new("Frame")
    progressBG.Name = "ProgressBG"
    progressBG.BackgroundColor3 = self.Theme.Divider
    progressBG.Size = UDim2.new(1, 0, 0, 3)
    progressBG.BorderSizePixel = 0
    progressBG.ZIndex = 101
    progressBG.LayoutOrder = 100
    progressBG.Parent = innerFrame
    Utilities:CreateCorner(progressBG, 2)
    
    local progressFill = Instance.new("Frame")
    progressFill.Name = "Fill"
    progressFill.BackgroundColor3 = accentColor
    progressFill.Size = UDim2.new(1, 0, 1, 0)
    progressFill.BorderSizePixel = 0
    progressFill.ZIndex = 102
    progressFill.Parent = progressBG
    Utilities:CreateCorner(progressFill, 2)
    
    -- Animacao de entrada
    notifFrame.BackgroundTransparency = 1
    Utilities:Tween(notifFrame, {BackgroundTransparency = 0}, 0.3)
    
    -- Animacao da barra de progresso
    Utilities:Tween(progressFill, {Size = UDim2.new(0, 0, 1, 0)}, duration, Enum.EasingStyle.Linear)
    
    -- Auto destruir
    task.delay(duration, function()
        Utilities:Tween(notifFrame, {BackgroundTransparency = 1}, 0.3)
        task.wait(0.35)
        if notifFrame and notifFrame.Parent then
            notifFrame:Destroy()
        end
    end)
end

-- =============================================
-- COMPONENTE: SECTION (Secao / Grupo)
-- =============================================
local function CreateSection(parent, config, theme, zIndex)
    config = config or {}
    local title = config.Title or "Secao"
    
    local sectionFrame = Instance.new("Frame")
    sectionFrame.Name = "Section_" .. title
    sectionFrame.BackgroundColor3 = theme.SecondaryBackground
    sectionFrame.Size = UDim2.new(1, -8, 0, 0)
    sectionFrame.AutomaticSize = Enum.AutomaticSize.Y
    sectionFrame.ZIndex = zIndex
    sectionFrame.Parent = parent
    Utilities:CreateCorner(sectionFrame, 8)
    Utilities:CreatePadding(sectionFrame, 10, 10, 10, 10)
    
    -- Titulo da secao
    local sectionTitle = Instance.new("TextLabel")
    sectionTitle.Name = "SectionTitle"
    sectionTitle.BackgroundTransparency = 1
    sectionTitle.Size = UDim2.new(1, 0, 0, 22)
    sectionTitle.Font = Enum.Font.GothamBold
    sectionTitle.Text = title
    sectionTitle.TextColor3 = theme.SubText
    sectionTitle.TextSize = 12
    sectionTitle.TextXAlignment = Enum.TextXAlignment.Left
    sectionTitle.TextTransparency = 0.2
    sectionTitle.ZIndex = zIndex + 1
    sectionTitle.LayoutOrder = 0
    sectionTitle.Parent = sectionFrame
    
    local sectionLayout = Utilities:CreateListLayout(sectionFrame, 6)
    
    local sectionAPI = {}
    sectionAPI._Frame = sectionFrame
    sectionAPI._LayoutOrder = 0
    
    function sectionAPI:_NextOrder()
        self._LayoutOrder = self._LayoutOrder + 1
        return self._LayoutOrder
    end
    
    return sectionAPI, sectionFrame
end

-- =============================================
-- COMPONENTE: BUTTON
-- =============================================
local function CreateButton(parent, config, theme, zIndex, layoutOrder)
    config = config or {}
    local title = config.Title or "Botao"
    local description = config.Description or nil
    local callback = config.Callback or function() end
    
    local hasDescription = description ~= nil and description ~= ""
    local btnHeight = hasDescription and 50 or 36
    
    local button = Instance.new("TextButton")
    button.Name = "Button_" .. title
    button.BackgroundColor3 = theme.Card
    button.Size = UDim2.new(1, 0, 0, btnHeight)
    button.Text = ""
    button.AutoButtonColor = false
    button.ZIndex = zIndex
    button.LayoutOrder = layoutOrder
    button.ClipsDescendants = true
    button.Parent = parent
    Utilities:CreateCorner(button, 8)
    
    local innerPadding = Utilities:CreatePadding(button, 0, 0, 12, 12)
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.BackgroundTransparency = 1
    titleLabel.Position = hasDescription and UDim2.new(0, 0, 0, 8) or UDim2.new(0, 0, 0.5, 0)
    titleLabel.AnchorPoint = hasDescription and Vector2.new(0, 0) or Vector2.new(0, 0.5)
    titleLabel.Size = UDim2.new(1, -40, 0, 18)
    titleLabel.Font = Enum.Font.GothamSemibold
    titleLabel.Text = title
    titleLabel.TextColor3 = theme.Text
    titleLabel.TextSize = 14
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.ZIndex = zIndex + 1
    titleLabel.Parent = button
    
    if hasDescription then
        local descLabel = Instance.new("TextLabel")
        descLabel.Name = "Description"
        descLabel.BackgroundTransparency = 1
        descLabel.Position = UDim2.new(0, 0, 0, 28)
        descLabel.Size = UDim2.new(1, -40, 0, 14)
        descLabel.Font = Enum.Font.Gotham
        descLabel.Text = description
        descLabel.TextColor3 = theme.SubText
        descLabel.TextSize = 11
        descLabel.TextXAlignment = Enum.TextXAlignment.Left
        descLabel.ZIndex = zIndex + 1
        descLabel.Parent = button
    end
    
    -- Icone de seta
    local arrow = Instance.new("TextLabel")
    arrow.Name = "Arrow"
    arrow.BackgroundTransparency = 1
    arrow.Position = UDim2.new(1, -20, 0.5, 0)
    arrow.AnchorPoint = Vector2.new(0.5, 0.5)
    arrow.Size = UDim2.new(0, 20, 0, 20)
    arrow.Font = Enum.Font.GothamBold
    arrow.Text = ">"
    arrow.TextColor3 = theme.SubText
    arrow.TextSize = 14
    arrow.ZIndex = zIndex + 1
    arrow.Parent = button
    
    -- Hover
    button.MouseEnter:Connect(function()
        Utilities:Tween(button, {BackgroundColor3 = theme.CardHover}, 0.2)
        Utilities:Tween(arrow, {TextColor3 = theme.Accent}, 0.2)
    end)
    
    button.MouseLeave:Connect(function()
        Utilities:Tween(button, {BackgroundColor3 = theme.Card}, 0.2)
        Utilities:Tween(arrow, {TextColor3 = theme.SubText}, 0.2)
    end)
    
    button.MouseButton1Click:Connect(function()
        Utilities:Ripple(button, theme)
        callback()
    end)
    
    local buttonAPI = {}
    buttonAPI._Instance = button
    
    function buttonAPI:SetTitle(newTitle)
        titleLabel.Text = newTitle
    end
    
    function buttonAPI:SetCallback(newCallback)
        callback = newCallback
    end
    
    return buttonAPI
end

-- =============================================
-- COMPONENTE: TOGGLE
-- =============================================
local function CreateToggle(parent, config, theme, zIndex, layoutOrder)
    config = config or {}
    local title = config.Title or "Toggle"
    local description = config.Description or nil
    local default = config.Default or false
    local callback = config.Callback or function() end
    
    local toggled = default
    local hasDescription = description ~= nil and description ~= ""
    local frameHeight = hasDescription and 50 or 36
    
    local toggleFrame = Instance.new("TextButton")
    toggleFrame.Name = "Toggle_" .. title
    toggleFrame.BackgroundColor3 = theme.Card
    toggleFrame.Size = UDim2.new(1, 0, 0, frameHeight)
    toggleFrame.Text = ""
    toggleFrame.AutoButtonColor = false
    toggleFrame.ZIndex = zIndex
    toggleFrame.LayoutOrder = layoutOrder
    toggleFrame.Parent = parent
    Utilities:CreateCorner(toggleFrame, 8)
    Utilities:CreatePadding(toggleFrame, 0, 0, 12, 12)
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.BackgroundTransparency = 1
    titleLabel.Position = hasDescription and UDim2.new(0, 0, 0, 8) or UDim2.new(0, 0, 0.5, 0)
    titleLabel.AnchorPoint = hasDescription and Vector2.new(0, 0) or Vector2.new(0, 0.5)
    titleLabel.Size = UDim2.new(1, -60, 0, 18)
    titleLabel.Font = Enum.Font.GothamSemibold
    titleLabel.Text = title
    titleLabel.TextColor3 = theme.Text
    titleLabel.TextSize = 14
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.ZIndex = zIndex + 1
    titleLabel.Parent = toggleFrame
    
    if hasDescription then
        local descLabel = Instance.new("TextLabel")
        descLabel.Name = "Description"
        descLabel.BackgroundTransparency = 1
        descLabel.Position = UDim2.new(0, 0, 0, 28)
        descLabel.Size = UDim2.new(1, -60, 0, 14)
        descLabel.Font = Enum.Font.Gotham
        descLabel.Text = description
        descLabel.TextColor3 = theme.SubText
        descLabel.TextSize = 11
        descLabel.TextXAlignment = Enum.TextXAlignment.Left
        descLabel.ZIndex = zIndex + 1
        descLabel.Parent = toggleFrame
    end
    
    -- Switch visual
    local switchBG = Instance.new("Frame")
    switchBG.Name = "SwitchBG"
    switchBG.BackgroundColor3 = toggled and theme.Toggle_On or theme.Toggle_Off
    switchBG.Position = UDim2.new(1, -36, 0.5, 0)
    switchBG.AnchorPoint = Vector2.new(0, 0.5)
    switchBG.Size = UDim2.new(0, 44, 0, 24)
    switchBG.ZIndex = zIndex + 1
    switchBG.Parent = toggleFrame
    Utilities:CreateCorner(switchBG, 12)
    
    local switchCircle = Instance.new("Frame")
    switchCircle.Name = "Circle"
    switchCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    switchCircle.Position = toggled and UDim2.new(1, -22, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)
    switchCircle.AnchorPoint = Vector2.new(0, 0.5)
    switchCircle.Size = UDim2.new(0, 18, 0, 18)
    switchCircle.ZIndex = zIndex + 2
    switchCircle.Parent = switchBG
    Utilities:CreateCorner(switchCircle, 9)
    
    local function updateVisual()
        if toggled then
            Utilities:Tween(switchBG, {BackgroundColor3 = theme.Toggle_On}, 0.25)
            Utilities:Tween(switchCircle, {Position = UDim2.new(1, -22, 0.5, 0)}, 0.25, Enum.EasingStyle.Back)
        else
            Utilities:Tween(switchBG, {BackgroundColor3 = theme.Toggle_Off}, 0.25)
            Utilities:Tween(switchCircle, {Position = UDim2.new(0, 3, 0.5, 0)}, 0.25, Enum.EasingStyle.Back)
        end
    end
    
    toggleFrame.MouseEnter:Connect(function()
        Utilities:Tween(toggleFrame, {BackgroundColor3 = theme.CardHover}, 0.2)
    end)
    
    toggleFrame.MouseLeave:Connect(function()
        Utilities:Tween(toggleFrame, {BackgroundColor3 = theme.Card}, 0.2)
    end)
    
    toggleFrame.MouseButton1Click:Connect(function()
        toggled = not toggled
        updateVisual()
        callback(toggled)
    end)
    
    local toggleAPI = {}
    toggleAPI._Instance = toggleFrame
    
    function toggleAPI:Set(value)
        toggled = value
        updateVisual()
        callback(toggled)
    end
    
    function toggleAPI:GetState()
        return toggled
    end
    
    return toggleAPI
end

-- =============================================
-- COMPONENTE: SLIDER
-- =============================================
local function CreateSlider(parent, config, theme, zIndex, layoutOrder)
    config = config or {}
    local title = config.Title or "Slider"
    local description = config.Description or nil
    local min = config.Min or 0
    local max = config.Max or 100
    local default = config.Default or min
    local increment = config.Increment or 1
    local suffix = config.Suffix or ""
    local callback = config.Callback or function() end
    
    local currentValue = default
    local hasDescription = description ~= nil and description ~= ""
    local frameHeight = hasDescription and 70 or 56
    
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Name = "Slider_" .. title
    sliderFrame.BackgroundColor3 = theme.Card
    sliderFrame.Size = UDim2.new(1, 0, 0, frameHeight)
    sliderFrame.ZIndex = zIndex
    sliderFrame.LayoutOrder = layoutOrder
    sliderFrame.Parent = parent
    Utilities:CreateCorner(sliderFrame, 8)
    Utilities:CreatePadding(sliderFrame, 8, 10, 12, 12)
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.BackgroundTransparency = 1
    titleLabel.Position = UDim2.new(0, 0, 0, 0)
    titleLabel.Size = UDim2.new(1, -60, 0, 18)
    titleLabel.Font = Enum.Font.GothamSemibold
    titleLabel.Text = title
    titleLabel.TextColor3 = theme.Text
    titleLabel.TextSize = 14
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.ZIndex = zIndex + 1
    titleLabel.Parent = sliderFrame
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Name = "Value"
    valueLabel.BackgroundTransparency = 1
    valueLabel.Position = UDim2.new(1, -50, 0, 0)
    valueLabel.Size = UDim2.new(0, 50, 0, 18)
    valueLabel.Font = Enum.Font.GothamSemibold
    valueLabel.Text = tostring(currentValue) .. suffix
    valueLabel.TextColor3 = theme.Accent
    valueLabel.TextSize = 13
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.ZIndex = zIndex + 1
    valueLabel.Parent = sliderFrame
    
    if hasDescription then
        local descLabel = Instance.new("TextLabel")
        descLabel.Name = "Description"
        descLabel.BackgroundTransparency = 1
        descLabel.Position = UDim2.new(0, 0, 0, 18)
        descLabel.Size = UDim2.new(1, 0, 0, 14)
        descLabel.Font = Enum.Font.Gotham
        descLabel.Text = description
        descLabel.TextColor3 = theme.SubText
        descLabel.TextSize = 11
        descLabel.TextXAlignment = Enum.TextXAlignment.Left
        descLabel.ZIndex = zIndex + 1
        descLabel.Parent = sliderFrame
    end
    
    local sliderBarY = hasDescription and UDim2.new(0, 0, 1, -16) or UDim2.new(0, 0, 1, -14)
    
    -- Barra de fundo do slider
    local sliderBG = Instance.new("Frame")
    sliderBG.Name = "SliderBG"
    sliderBG.BackgroundColor3 = theme.Slider_Background
    sliderBG.Position = sliderBarY
    sliderBG.Size = UDim2.new(1, 0, 0, 6)
    sliderBG.ZIndex = zIndex + 1
    sliderBG.Parent = sliderFrame
    Utilities:CreateCorner(sliderBG, 3)
    
    -- Barra de preenchimento
    local fillPercent = (currentValue - min) / (max - min)
    local sliderFill = Instance.new("Frame")
    sliderFill.Name = "Fill"
    sliderFill.BackgroundColor3 = theme.Slider_Fill
    sliderFill.Size = UDim2.new(fillPercent, 0, 1, 0)
    sliderFill.ZIndex = zIndex + 2
    sliderFill.Parent = sliderBG
    Utilities:CreateCorner(sliderFill, 3)
    
    -- Indicador circular
    local knob = Instance.new("Frame")
    knob.Name = "Knob"
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.AnchorPoint = Vector2.new(0.5, 0.5)
    knob.Position = UDim2.new(fillPercent, 0, 0.5, 0)
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.ZIndex = zIndex + 3
    knob.Parent = sliderBG
    Utilities:CreateCorner(knob, 7)
    Utilities:CreateStroke(knob, theme.Slider_Fill, 2, 0)
    
    local dragging = false
    
    local function updateSlider(input)
        local relativeX = (input.Position.X - sliderBG.AbsolutePosition.X) / sliderBG.AbsoluteSize.X
        relativeX = math.clamp(relativeX, 0, 1)
        
        local rawValue = min + (max - min) * relativeX
        local stepped = math.floor(rawValue / increment + 0.5) * increment
        stepped = math.clamp(stepped, min, max)
        
        -- Arredondar para evitar erros de ponto flutuante
        if increment >= 1 then
            stepped = math.floor(stepped + 0.5)
        else
            local decimals = #tostring(increment):match("%.(%d+)") or 0
            stepped = tonumber(string.format("%." .. decimals .. "f", stepped))
        end
        
        currentValue = stepped
        local percent = (currentValue - min) / (max - min)
        
        Utilities:Tween(sliderFill, {Size = UDim2.new(percent, 0, 1, 0)}, 0.08)
        Utilities:Tween(knob, {Position = UDim2.new(percent, 0, 0.5, 0)}, 0.08)
        valueLabel.Text = tostring(currentValue) .. suffix
        
        callback(currentValue)
    end
    
    sliderBG.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateSlider(input)
        end
    end)
    
    knob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateSlider(input)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    local sliderAPI = {}
    sliderAPI._Instance = sliderFrame
    
    function sliderAPI:Set(value)
        currentValue = math.clamp(value, min, max)
        local percent = (currentValue - min) / (max - min)
        Utilities:Tween(sliderFill, {Size = UDim2.new(percent, 0, 1, 0)}, 0.15)
        Utilities:Tween(knob, {Position = UDim2.new(percent, 0, 0.5, 0)}, 0.15)
        valueLabel.Text = tostring(currentValue) .. suffix
        callback(currentValue)
    end
    
    function sliderAPI:GetValue()
        return currentValue
    end
    
    return sliderAPI
end

-- =============================================
-- COMPONENTE: DROPDOWN
-- =============================================
local function CreateDropdown(parent, config, theme, zIndex, layoutOrder)
    config = config or {}
    local title = config.Title or "Dropdown"
    local description = config.Description or nil
    local items = config.Items or {}
    local default = config.Default or nil
    local multiSelect = config.MultiSelect or false
    local callback = config.Callback or function() end
    
    local isOpen = false
    local selected = multiSelect and {} or default
    local hasDescription = description ~= nil and description ~= ""
    
    if multiSelect and default then
        if typeof(default) == "table" then
            for _, v in ipairs(default) do
                selected[v] = true
            end
        end
    end
    
    local dropdownFrame = Instance.new("Frame")
    dropdownFrame.Name = "Dropdown_" .. title
    dropdownFrame.BackgroundColor3 = theme.Card
    dropdownFrame.Size = UDim2.new(1, 0, 0, hasDescription and 72 or 58)
    dropdownFrame.ClipsDescendants = true
    dropdownFrame.ZIndex = zIndex
    dropdownFrame.LayoutOrder = layoutOrder
    dropdownFrame.Parent = parent
    Utilities:CreateCorner(dropdownFrame, 8)
    Utilities:CreatePadding(dropdownFrame, 8, 8, 12, 12)
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.BackgroundTransparency = 1
    titleLabel.Position = UDim2.new(0, 0, 0, 0)
    titleLabel.Size = UDim2.new(1, 0, 0, 18)
    titleLabel.Font = Enum.Font.GothamSemibold
    titleLabel.Text = title
    titleLabel.TextColor3 = theme.Text
    titleLabel.TextSize = 14
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.ZIndex = zIndex + 1
    titleLabel.Parent = dropdownFrame
    
    if hasDescription then
        local descLabel = Instance.new("TextLabel")
        descLabel.Name = "Description"
        descLabel.BackgroundTransparency = 1
        descLabel.Position = UDim2.new(0, 0, 0, 18)
        descLabel.Size = UDim2.new(1, 0, 0, 14)
        descLabel.Font = Enum.Font.Gotham
        descLabel.Text = description
        descLabel.TextColor3 = theme.SubText
        descLabel.TextSize = 11
        descLabel.TextXAlignment = Enum.TextXAlignment.Left
        descLabel.ZIndex = zIndex + 1
        descLabel.Parent = dropdownFrame
    end
    
    local selectBoxY = hasDescription and 36 or 22
    
    -- Caixa de selecao
    local selectBox = Instance.new("TextButton")
    selectBox.Name = "SelectBox"
    selectBox.BackgroundColor3 = theme.Input_Background
    selectBox.Position = UDim2.new(0, 0, 0, selectBoxY)
    selectBox.Size = UDim2.new(1, 0, 0, 28)
    selectBox.Text = ""
    selectBox.AutoButtonColor = false
    selectBox.ZIndex = zIndex + 1
    selectBox.Parent = dropdownFrame
    Utilities:CreateCorner(selectBox, 6)
    Utilities:CreateStroke(selectBox, theme.Input_Border, 1, 0.5)
    
    local function getDisplayText()
        if multiSelect then
            local selectedItems = {}
            for item, isSelected in pairs(selected) do
                if isSelected then
                    table.insert(selectedItems, item)
                end
            end
            if #selectedItems == 0 then return "Selecione..." end
            return table.concat(selectedItems, ", ")
        else
            return selected or "Selecione..."
        end
    end
    
    local selectedLabel = Instance.new("TextLabel")
    selectedLabel.Name = "SelectedText"
    selectedLabel.BackgroundTransparency = 1
    selectedLabel.Position = UDim2.new(0, 8, 0, 0)
    selectedLabel.Size = UDim2.new(1, -30, 1, 0)
    selectedLabel.Font = Enum.Font.Gotham
    selectedLabel.Text = getDisplayText()
    selectedLabel.TextColor3 = theme.Text
    selectedLabel.TextSize = 12
    selectedLabel.TextXAlignment = Enum.TextXAlignment.Left
    selectedLabel.TextTruncate = Enum.TextTruncate.AtEnd
    selectedLabel.ZIndex = zIndex + 2
    selectedLabel.Parent = selectBox
    
    local arrowLabel = Instance.new("TextLabel")
    arrowLabel.Name = "Arrow"
    arrowLabel.BackgroundTransparency = 1
    arrowLabel.Position = UDim2.new(1, -22, 0, 0)
    arrowLabel.Size = UDim2.new(0, 20, 1, 0)
    arrowLabel.Font = Enum.Font.GothamBold
    arrowLabel.Text = "v"
    arrowLabel.TextColor3 = theme.SubText
    arrowLabel.TextSize = 12
    arrowLabel.ZIndex = zIndex + 2
    arrowLabel.Parent = selectBox
    
    -- Container dos itens
    local itemsContainer = Instance.new("Frame")
    itemsContainer.Name = "Items"
    itemsContainer.BackgroundColor3 = theme.Input_Background
    itemsContainer.Position = UDim2.new(0, 0, 0, selectBoxY + 32)
    itemsContainer.Size = UDim2.new(1, 0, 0, 0)
    itemsContainer.AutomaticSize = Enum.AutomaticSize.Y
    itemsContainer.Visible = false
    itemsContainer.ZIndex = zIndex + 3
    itemsContainer.Parent = dropdownFrame
    Utilities:CreateCorner(itemsContainer, 6)
    Utilities:CreateStroke(itemsContainer, theme.Input_Border, 1, 0.5)
    Utilities:CreateListLayout(itemsContainer, 0)
    Utilities:CreatePadding(itemsContainer, 4, 4, 0, 0)
    
    local itemButtons = {}
    
    local function refreshItems()
        for _, btn in pairs(itemButtons) do
            btn:Destroy()
        end
        itemButtons = {}
        
        for i, item in ipairs(items) do
            local itemBtn = Instance.new("TextButton")
            itemBtn.Name = "Item_" .. item
            itemBtn.BackgroundColor3 = theme.Input_Background
            itemBtn.BackgroundTransparency = 1
            itemBtn.Size = UDim2.new(1, 0, 0, 28)
            itemBtn.Text = ""
            itemBtn.AutoButtonColor = false
            itemBtn.ZIndex = zIndex + 4
            itemBtn.LayoutOrder = i
            itemBtn.Parent = itemsContainer
            
            local itemLabel = Instance.new("TextLabel")
            itemLabel.Name = "Text"
            itemLabel.BackgroundTransparency = 1
            itemLabel.Position = UDim2.new(0, 10, 0, 0)
            itemLabel.Size = UDim2.new(1, -20, 1, 0)
            itemLabel.Font = Enum.Font.Gotham
            itemLabel.Text = item
            itemLabel.TextSize = 12
            itemLabel.TextXAlignment = Enum.TextXAlignment.Left
            itemLabel.ZIndex = zIndex + 5
            itemLabel.Parent = itemBtn
            
            local function updateColor()
                if multiSelect then
                    itemLabel.TextColor3 = selected[item] and theme.Accent or theme.Text
                else
                    itemLabel.TextColor3 = (selected == item) and theme.Accent or theme.Text
                end
            end
            updateColor()
            
            itemBtn.MouseEnter:Connect(function()
                Utilities:Tween(itemBtn, {BackgroundTransparency = 0, BackgroundColor3 = theme.CardHover}, 0.15)
            end)
            
            itemBtn.MouseLeave:Connect(function()
                Utilities:Tween(itemBtn, {BackgroundTransparency = 1}, 0.15)
            end)
            
            itemBtn.MouseButton1Click:Connect(function()
                if multiSelect then
                    selected[item] = not selected[item]
                    updateColor()
                    selectedLabel.Text = getDisplayText()
                    local result = {}
                    for k, v in pairs(selected) do
                        if v then table.insert(result, k) end
                    end
                    callback(result)
                else
                    selected = item
                    selectedLabel.Text = item
                    -- Fechar dropdown
                    isOpen = false
                    arrowLabel.Text = "v"
                    itemsContainer.Visible = false
                    local closedHeight = hasDescription and 72 or 58
                    Utilities:Tween(dropdownFrame, {Size = UDim2.new(1, 0, 0, closedHeight)}, 0.25)
                    -- Atualizar cores
                    for _, btn in pairs(itemsContainer:GetChildren()) do
                        if btn:IsA("TextButton") then
                            local lbl = btn:FindFirstChild("Text")
                            if lbl then
                                lbl.TextColor3 = (lbl.Text == item) and theme.Accent or theme.Text
                            end
                        end
                    end
                    callback(item)
                end
            end)
            
            table.insert(itemButtons, itemBtn)
        end
    end
    
    refreshItems()
    
    selectBox.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        if isOpen then
            arrowLabel.Text = "^"
            itemsContainer.Visible = true
            local itemsHeight = #items * 28 + 8
            local totalHeight = (hasDescription and 72 or 58) + itemsHeight + 4
            Utilities:Tween(dropdownFrame, {Size = UDim2.new(1, 0, 0, totalHeight)}, 0.25)
        else
            arrowLabel.Text = "v"
            local closedHeight = hasDescription and 72 or 58
            Utilities:Tween(dropdownFrame, {Size = UDim2.new(1, 0, 0, closedHeight)}, 0.25)
            task.delay(0.25, function()
                itemsContainer.Visible = false
            end)
        end
    end)
    
    local dropdownAPI = {}
    dropdownAPI._Instance = dropdownFrame
    
    function dropdownAPI:Set(value)
        selected = value
        selectedLabel.Text = getDisplayText()
    end
    
    function dropdownAPI:Refresh(newItems, clearSelection)
        items = newItems
        if clearSelection then
            if multiSelect then
                selected = {}
            else
                selected = nil
            end
            selectedLabel.Text = "Selecione..."
        end
        refreshItems()
    end
    
    function dropdownAPI:GetValue()
        return selected
    end
    
    return dropdownAPI
end

-- =============================================
-- COMPONENTE: TEXT INPUT
-- =============================================
local function CreateInput(parent, config, theme, zIndex, layoutOrder)
    config = config or {}
    local title = config.Title or "Input"
    local description = config.Description or nil
    local placeholder = config.Placeholder or "Digite aqui..."
    local default = config.Default or ""
    local numeric = config.Numeric or false
    local callback = config.Callback or function() end
    local onChanged = config.OnChanged or nil
    
    local hasDescription = description ~= nil and description ~= ""
    local frameHeight = hasDescription and 72 or 58
    
    local inputFrame = Instance.new("Frame")
    inputFrame.Name = "Input_" .. title
    inputFrame.BackgroundColor3 = theme.Card
    inputFrame.Size = UDim2.new(1, 0, 0, frameHeight)
    inputFrame.ZIndex = zIndex
    inputFrame.LayoutOrder = layoutOrder
    inputFrame.Parent = parent
    Utilities:CreateCorner(inputFrame, 8)
    Utilities:CreatePadding(inputFrame, 8, 8, 12, 12)
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.BackgroundTransparency = 1
    titleLabel.Position = UDim2.new(0, 0, 0, 0)
    titleLabel.Size = UDim2.new(1, 0, 0, 18)
    titleLabel.Font = Enum.Font.GothamSemibold
    titleLabel.Text = title
    titleLabel.TextColor3 = theme.Text
    titleLabel.TextSize = 14
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.ZIndex = zIndex + 1
    titleLabel.Parent = inputFrame
    
    if hasDescription then
        local descLabel = Instance.new("TextLabel")
        descLabel.Name = "Description"
        descLabel.BackgroundTransparency = 1
        descLabel.Position = UDim2.new(0, 0, 0, 18)
        descLabel.Size = UDim2.new(1, 0, 0, 14)
        descLabel.Font = Enum.Font.Gotham
        descLabel.Text = description
        descLabel.TextColor3 = theme.SubText
        descLabel.TextSize = 11
        descLabel.TextXAlignment = Enum.TextXAlignment.Left
        descLabel.ZIndex = zIndex + 1
        descLabel.Parent = inputFrame
    end
    
    local inputBoxY = hasDescription and 36 or 22
    
    local textBox = Instance.new("TextBox")
    textBox.Name = "TextBox"
    textBox.BackgroundColor3 = theme.Input_Background
    textBox.Position = UDim2.new(0, 0, 0, inputBoxY)
    textBox.Size = UDim2.new(1, 0, 0, 28)
    textBox.Font = Enum.Font.Gotham
    textBox.PlaceholderText = placeholder
    textBox.PlaceholderColor3 = theme.SubText
    textBox.Text = default
    textBox.TextColor3 = theme.Text
    textBox.TextSize = 12
    textBox.ClearTextOnFocus = false
    textBox.ZIndex = zIndex + 1
    textBox.Parent = inputFrame
    Utilities:CreateCorner(textBox, 6)
    Utilities:CreateStroke(textBox, theme.Input_Border, 1, 0.5)
    Utilities:CreatePadding(textBox, 0, 0, 8, 8)
    
    local stroke = textBox:FindFirstChildOfClass("UIStroke")
    
    textBox.Focused:Connect(function()
        Utilities:Tween(stroke, {Color = theme.Accent, Transparency = 0}, 0.2)
    end)
    
    textBox.FocusLost:Connect(function(enterPressed)
        Utilities:Tween(stroke, {Color = theme.Input_Border, Transparency = 0.5}, 0.2)
        local value = textBox.Text
        if numeric then
            value = tonumber(value) or 0
        end
        if enterPressed then
            callback(value)
        end
    end)
    
    if onChanged then
        textBox:GetPropertyChangedSignal("Text"):Connect(function()
            local value = textBox.Text
            if numeric then
                -- Filtrar caracteres nao numericos
                local filtered = value:gsub("[^%d%.%-]", "")
                if filtered ~= value then
                    textBox.Text = filtered
                end
                value = tonumber(filtered) or 0
            end
            onChanged(value)
        end)
    end
    
    local inputAPI = {}
    inputAPI._Instance = inputFrame
    
    function inputAPI:Set(value)
        textBox.Text = tostring(value)
    end
    
    function inputAPI:GetValue()
        local value = textBox.Text
        if numeric then
            return tonumber(value) or 0
        end
        return value
    end
    
    return inputAPI
end

-- =============================================
-- COMPONENTE: LABEL / PARAGRAPH
-- =============================================
local function CreateLabel(parent, config, theme, zIndex, layoutOrder)
    config = config or {}
    local title = config.Title or "Label"
    local content = config.Content or nil
    
    local hasContent = content ~= nil and content ~= ""
    local frameHeight = hasContent and 0 or 28
    
    local labelFrame = Instance.new("Frame")
    labelFrame.Name = "Label_" .. title
    labelFrame.BackgroundColor3 = theme.Card
    labelFrame.Size = UDim2.new(1, 0, 0, frameHeight)
    labelFrame.AutomaticSize = hasContent and Enum.AutomaticSize.Y or Enum.AutomaticSize.None
    labelFrame.ZIndex = zIndex
    labelFrame.LayoutOrder = layoutOrder
    labelFrame.Parent = parent
    Utilities:CreateCorner(labelFrame, 8)
    Utilities:CreatePadding(labelFrame, 8, 8, 12, 12)
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.BackgroundTransparency = 1
    titleLabel.Size = UDim2.new(1, 0, 0, 18)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Text = title
    titleLabel.TextColor3 = theme.Text
    titleLabel.TextSize = 14
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.ZIndex = zIndex + 1
    titleLabel.LayoutOrder = 1
    titleLabel.Parent = labelFrame
    
    if hasContent then
        Utilities:CreateListLayout(labelFrame, 4)
        
        local contentLabel = Instance.new("TextLabel")
        contentLabel.Name = "Content"
        contentLabel.BackgroundTransparency = 1
        contentLabel.Size = UDim2.new(1, 0, 0, 0)
        contentLabel.AutomaticSize = Enum.AutomaticSize.Y
        contentLabel.Font = Enum.Font.Gotham
        contentLabel.Text = content
        contentLabel.TextColor3 = theme.SubText
        contentLabel.TextSize = 12
        contentLabel.TextXAlignment = Enum.TextXAlignment.Left
        contentLabel.TextWrapped = true
        contentLabel.ZIndex = zIndex + 1
        contentLabel.LayoutOrder = 2
        contentLabel.Parent = labelFrame
    end
    
    local labelAPI = {}
    labelAPI._Instance = labelFrame
    
    function labelAPI:SetTitle(newTitle)
        titleLabel.Text = newTitle
    end
    
    function labelAPI:SetContent(newContent)
        local cl = labelFrame:FindFirstChild("Content")
        if cl then
            cl.Text = newContent
        end
    end
    
    return labelAPI
end

-- =============================================
-- COMPONENTE: COLOR PICKER
-- =============================================
local function CreateColorPicker(parent, config, theme, zIndex, layoutOrder)
    config = config or {}
    local title = config.Title or "Cor"
    local default = config.Default or Color3.fromRGB(255, 0, 0)
    local callback = config.Callback or function() end
    
    local currentColor = default
    local isOpen = false
    local currentHue, currentSat, currentVal = default:ToHSV()
    
    local pickerFrame = Instance.new("Frame")
    pickerFrame.Name = "ColorPicker_" .. title
    pickerFrame.BackgroundColor3 = theme.Card
    pickerFrame.Size = UDim2.new(1, 0, 0, 36)
    pickerFrame.ClipsDescendants = true
    pickerFrame.ZIndex = zIndex
    pickerFrame.LayoutOrder = layoutOrder
    pickerFrame.Parent = parent
    Utilities:CreateCorner(pickerFrame, 8)
    Utilities:CreatePadding(pickerFrame, 0, 0, 12, 12)
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.BackgroundTransparency = 1
    titleLabel.Position = UDim2.new(0, 0, 0, 0)
    titleLabel.Size = UDim2.new(1, -50, 0, 36)
    titleLabel.Font = Enum.Font.GothamSemibold
    titleLabel.Text = title
    titleLabel.TextColor3 = theme.Text
    titleLabel.TextSize = 14
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.ZIndex = zIndex + 1
    titleLabel.Parent = pickerFrame
    
    local previewBtn = Instance.new("TextButton")
    previewBtn.Name = "Preview"
    previewBtn.BackgroundColor3 = currentColor
    previewBtn.Position = UDim2.new(1, -28, 0, 8)
    previewBtn.Size = UDim2.new(0, 28, 0, 20)
    previewBtn.Text = ""
    previewBtn.AutoButtonColor = false
    previewBtn.ZIndex = zIndex + 1
    previewBtn.Parent = pickerFrame
    Utilities:CreateCorner(previewBtn, 5)
    Utilities:CreateStroke(previewBtn, theme.Divider, 1, 0.3)
    
    -- Area do color picker
    local pickerArea = Instance.new("Frame")
    pickerArea.Name = "PickerArea"
    pickerArea.BackgroundTransparency = 1
    pickerArea.Position = UDim2.new(0, 0, 0, 40)
    pickerArea.Size = UDim2.new(1, 0, 0, 120)
    pickerArea.ZIndex = zIndex + 1
    pickerArea.Parent = pickerFrame
    
    -- Gradiente de saturacao/valor
    local svBox = Instance.new("ImageLabel")
    svBox.Name = "SVBox"
    svBox.BackgroundColor3 = Color3.fromHSV(currentHue, 1, 1)
    svBox.Position = UDim2.new(0, 0, 0, 0)
    svBox.Size = UDim2.new(1, -30, 0, 100)
    svBox.ZIndex = zIndex + 2
    svBox.Image = "rbxassetid://4155801252"
    svBox.Parent = pickerArea
    Utilities:CreateCorner(svBox, 6)
    
    local svCursor = Instance.new("Frame")
    svCursor.Name = "Cursor"
    svCursor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    svCursor.AnchorPoint = Vector2.new(0.5, 0.5)
    svCursor.Position = UDim2.new(currentSat, 0, 1 - currentVal, 0)
    svCursor.Size = UDim2.new(0, 12, 0, 12)
    svCursor.ZIndex = zIndex + 4
    svCursor.Parent = svBox
    Utilities:CreateCorner(svCursor, 6)
    Utilities:CreateStroke(svCursor, Color3.fromRGB(0, 0, 0), 2, 0)
    
    -- Barra de hue
    local hueBar = Instance.new("Frame")
    hueBar.Name = "HueBar"
    hueBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    hueBar.Position = UDim2.new(1, -20, 0, 0)
    hueBar.Size = UDim2.new(0, 18, 0, 100)
    hueBar.ZIndex = zIndex + 2
    hueBar.Parent = pickerArea
    Utilities:CreateCorner(hueBar, 4)
    
    -- Gradiente do hue
    local hueGradient = Instance.new("UIGradient")
    hueGradient.Rotation = 90
    hueGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
        ColorSequenceKeypoint.new(0.167, Color3.fromRGB(255, 255, 0)),
        ColorSequenceKeypoint.new(0.333, Color3.fromRGB(0, 255, 0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
        ColorSequenceKeypoint.new(0.667, Color3.fromRGB(0, 0, 255)),
        ColorSequenceKeypoint.new(0.833, Color3.fromRGB(255, 0, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0)),
    })
    hueGradient.Parent = hueBar
    
    local hueCursor = Instance.new("Frame")
    hueCursor.Name = "HueCursor"
    hueCursor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    hueCursor.AnchorPoint = Vector2.new(0.5, 0.5)
    hueCursor.Position = UDim2.new(0.5, 0, currentHue, 0)
    hueCursor.Size = UDim2.new(1, 4, 0, 6)
    hueCursor.ZIndex = zIndex + 4
    hueCursor.Parent = hueBar
    Utilities:CreateCorner(hueCursor, 3)
    Utilities:CreateStroke(hueCursor, Color3.fromRGB(0, 0, 0), 1, 0)
    
    -- Hex display
    local hexLabel = Instance.new("TextLabel")
    hexLabel.Name = "Hex"
    hexLabel.BackgroundTransparency = 1
    hexLabel.Position = UDim2.new(0, 0, 0, 104)
    hexLabel.Size = UDim2.new(1, 0, 0, 16)
    hexLabel.Font = Enum.Font.GothamSemibold
    hexLabel.TextSize = 11
    hexLabel.TextColor3 = theme.SubText
    hexLabel.ZIndex = zIndex + 2
    hexLabel.Parent = pickerArea
    
    local function toHex(color)
        return string.format("#%02X%02X%02X", 
            math.floor(color.R * 255), 
            math.floor(color.G * 255), 
            math.floor(color.B * 255))
    end
    hexLabel.Text = toHex(currentColor)
    
    local function updateColor()
        currentColor = Color3.fromHSV(currentHue, currentSat, currentVal)
        previewBtn.BackgroundColor3 = currentColor
        svBox.BackgroundColor3 = Color3.fromHSV(currentHue, 1, 1)
        svCursor.Position = UDim2.new(currentSat, 0, 1 - currentVal, 0)
        hueCursor.Position = UDim2.new(0.5, 0, currentHue, 0)
        hexLabel.Text = toHex(currentColor)
        callback(currentColor)
    end
    
    -- Interacao SV
    local draggingSV = false
    svBox.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingSV = true
            local relX = math.clamp((input.Position.X - svBox.AbsolutePosition.X) / svBox.AbsoluteSize.X, 0, 1)
            local relY = math.clamp((input.Position.Y - svBox.AbsolutePosition.Y) / svBox.AbsoluteSize.Y, 0, 1)
            currentSat = relX
            currentVal = 1 - relY
            updateColor()
        end
    end)
    
    -- Interacao Hue
    local draggingHue = false
    hueBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingHue = true
            local relY = math.clamp((input.Position.Y - hueBar.AbsolutePosition.Y) / hueBar.AbsoluteSize.Y, 0, 1)
            currentHue = relY
            updateColor()
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            if draggingSV then
                local relX = math.clamp((input.Position.X - svBox.AbsolutePosition.X) / svBox.AbsoluteSize.X, 0, 1)
                local relY = math.clamp((input.Position.Y - svBox.AbsolutePosition.Y) / svBox.AbsoluteSize.Y, 0, 1)
                currentSat = relX
                currentVal = 1 - relY
                updateColor()
            elseif draggingHue then
                local relY = math.clamp((input.Position.Y - hueBar.AbsolutePosition.Y) / hueBar.AbsoluteSize.Y, 0, 1)
                currentHue = relY
                updateColor()
            end
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingSV = false
            draggingHue = false
        end
    end)
    
    -- Toggle abrir/fechar
    previewBtn.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        if isOpen then
            Utilities:Tween(pickerFrame, {Size = UDim2.new(1, 0, 0, 172)}, 0.3)
        else
            Utilities:Tween(pickerFrame, {Size = UDim2.new(1, 0, 0, 36)}, 0.3)
        end
    end)
    
    local colorAPI = {}
    colorAPI._Instance = pickerFrame
    
    function colorAPI:Set(color)
        currentHue, currentSat, currentVal = color:ToHSV()
        updateColor()
    end
    
    function colorAPI:GetColor()
        return currentColor
    end
    
    return colorAPI
end

-- =============================================
-- COMPONENTE: KEYBIND
-- =============================================
local function CreateKeybind(parent, config, theme, zIndex, layoutOrder)
    config = config or {}
    local title = config.Title or "Keybind"
    local description = config.Description or nil
    local default = config.Default or Enum.KeyCode.Unknown
    local callback = config.Callback or function() end
    local onChanged = config.OnChanged or nil
    
    local currentKey = default
    local listening = false
    local hasDescription = description ~= nil and description ~= ""
    local frameHeight = hasDescription and 50 or 36
    
    local keybindFrame = Instance.new("Frame")
    keybindFrame.Name = "Keybind_" .. title
    keybindFrame.BackgroundColor3 = theme.Card
    keybindFrame.Size = UDim2.new(1, 0, 0, frameHeight)
    keybindFrame.ZIndex = zIndex
    keybindFrame.LayoutOrder = layoutOrder
    keybindFrame.Parent = parent
    Utilities:CreateCorner(keybindFrame, 8)
    Utilities:CreatePadding(keybindFrame, 0, 0, 12, 12)
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.BackgroundTransparency = 1
    titleLabel.Position = hasDescription and UDim2.new(0, 0, 0, 8) or UDim2.new(0, 0, 0.5, 0)
    titleLabel.AnchorPoint = hasDescription and Vector2.new(0, 0) or Vector2.new(0, 0.5)
    titleLabel.Size = UDim2.new(1, -80, 0, 18)
    titleLabel.Font = Enum.Font.GothamSemibold
    titleLabel.Text = title
    titleLabel.TextColor3 = theme.Text
    titleLabel.TextSize = 14
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.ZIndex = zIndex + 1
    titleLabel.Parent = keybindFrame
    
    if hasDescription then
        local descLabel = Instance.new("TextLabel")
        descLabel.Name = "Description"
        descLabel.BackgroundTransparency = 1
        descLabel.Position = UDim2.new(0, 0, 0, 28)
        descLabel.Size = UDim2.new(1, -80, 0, 14)
        descLabel.Font = Enum.Font.Gotham
        descLabel.Text = description
        descLabel.TextColor3 = theme.SubText
        descLabel.TextSize = 11
        descLabel.TextXAlignment = Enum.TextXAlignment.Left
        descLabel.ZIndex = zIndex + 1
        descLabel.Parent = keybindFrame
    end
    
    local function getKeyName(keyCode)
        if keyCode == Enum.KeyCode.Unknown then return "Nenhum" end
        local name = keyCode.Name
        return name
    end
    
    local keyBtn = Instance.new("TextButton")
    keyBtn.Name = "KeyButton"
    keyBtn.BackgroundColor3 = theme.Input_Background
    keyBtn.Position = UDim2.new(1, -60, 0.5, 0)
    keyBtn.AnchorPoint = Vector2.new(0, 0.5)
    keyBtn.Size = UDim2.new(0, 60, 0, 26)
    keyBtn.Font = Enum.Font.GothamSemibold
    keyBtn.Text = getKeyName(currentKey)
    keyBtn.TextColor3 = theme.Accent
    keyBtn.TextSize = 11
    keyBtn.AutoButtonColor = false
    keyBtn.ZIndex = zIndex + 1
    keyBtn.Parent = keybindFrame
    Utilities:CreateCorner(keyBtn, 6)
    Utilities:CreateStroke(keyBtn, theme.Input_Border, 1, 0.5)
    
    keyBtn.MouseButton1Click:Connect(function()
        listening = true
        keyBtn.Text = "..."
        Utilities:Tween(keyBtn, {BackgroundColor3 = theme.Accent}, 0.2)
        keyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
    
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if listening then
            if input.UserInputType == Enum.UserInputType.Keyboard then
                if input.KeyCode == Enum.KeyCode.Escape then
                    currentKey = Enum.KeyCode.Unknown
                else
                    currentKey = input.KeyCode
                end
                listening = false
                keyBtn.Text = getKeyName(currentKey)
                Utilities:Tween(keyBtn, {BackgroundColor3 = theme.Input_Background}, 0.2)
                keyBtn.TextColor3 = theme.Accent
                if onChanged then
                    onChanged(currentKey)
                end
            end
        else
            if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == currentKey and not gameProcessed then
                callback(currentKey)
            end
        end
    end)
    
    local keybindAPI = {}
    keybindAPI._Instance = keybindFrame
    
    function keybindAPI:Set(keyCode)
        currentKey = keyCode
        keyBtn.Text = getKeyName(currentKey)
    end
    
    function keybindAPI:GetKey()
        return currentKey
    end
    
    return keybindAPI
end

-- =============================================
-- COMPONENTE: SEPARATOR (Divisor)
-- =============================================
local function CreateDivider(parent, theme, zIndex, layoutOrder)
    local divider = Instance.new("Frame")
    divider.Name = "Divider"
    divider.BackgroundColor3 = theme.Divider
    divider.BackgroundTransparency = 0.5
    divider.Size = UDim2.new(1, -20, 0, 1)
    divider.BorderSizePixel = 0
    divider.ZIndex = zIndex
    divider.LayoutOrder = layoutOrder
    divider.Parent = parent
    
    return divider
end

-- =============================================
-- TAB SYSTEM
-- =============================================
local TabClass = {}
TabClass.__index = TabClass

function TabClass.new(tabData)
    local self = setmetatable({}, TabClass)
    self._Title = tabData.Title
    self._Icon = tabData.Icon
    self._Theme = tabData.Theme
    self._ZIndex = tabData.ZIndex
    self._ContentFrame = tabData.ContentFrame
    self._TabButton = tabData.TabButton
    self._LayoutOrder = 0
    return self
end

function TabClass:_NextOrder()
    self._LayoutOrder = self._LayoutOrder + 1
    return self._LayoutOrder
end

function TabClass:AddButton(config)
    return CreateButton(self._ContentFrame, config, self._Theme, self._ZIndex + 5, self:_NextOrder())
end

function TabClass:AddToggle(config)
    return CreateToggle(self._ContentFrame, config, self._Theme, self._ZIndex + 5, self:_NextOrder())
end

function TabClass:AddSlider(config)
    return CreateSlider(self._ContentFrame, config, self._Theme, self._ZIndex + 5, self:_NextOrder())
end

function TabClass:AddDropdown(config)
    return CreateDropdown(self._ContentFrame, config, self._Theme, self._ZIndex + 5, self:_NextOrder())
end

function TabClass:AddInput(config)
    return CreateInput(self._ContentFrame, config, self._Theme, self._ZIndex + 5, self:_NextOrder())
end

function TabClass:AddLabel(config)
    return CreateLabel(self._ContentFrame, config, self._Theme, self._ZIndex + 5, self:_NextOrder())
end

function TabClass:AddParagraph(config)
    return CreateLabel(self._ContentFrame, config, self._Theme, self._ZIndex + 5, self:_NextOrder())
end

function TabClass:AddColorPicker(config)
    return CreateColorPicker(self._ContentFrame, config, self._Theme, self._ZIndex + 5, self:_NextOrder())
end

function TabClass:AddKeybind(config)
    return CreateKeybind(self._ContentFrame, config, self._Theme, self._ZIndex + 5, self:_NextOrder())
end

function TabClass:AddDivider()
    return CreateDivider(self._ContentFrame, self._Theme, self._ZIndex + 5, self:_NextOrder())
end

function TabClass:AddSection(config)
    local order = self:_NextOrder()
    local sectionAPI, sectionFrame = CreateSection(self._ContentFrame, config, self._Theme, self._ZIndex + 5)
    sectionFrame.LayoutOrder = order
    
    -- Adicionar metodos de componentes a secao
    function sectionAPI:AddButton(cfg)
        return CreateButton(sectionFrame, cfg, self._Theme or sectionAPI._Theme, (self._ZIndex or sectionAPI._ZIndex or 10) + 6, sectionAPI:_NextOrder())
    end
    
    -- Copiar tema para secao
    local sTheme = self._Theme
    local sZIndex = self._ZIndex
    
    function sectionAPI:AddButton(cfg)
        return CreateButton(sectionFrame, cfg, sTheme, sZIndex + 6, sectionAPI:_NextOrder())
    end
    function sectionAPI:AddToggle(cfg)
        return CreateToggle(sectionFrame, cfg, sTheme, sZIndex + 6, sectionAPI:_NextOrder())
    end
    function sectionAPI:AddSlider(cfg)
        return CreateSlider(sectionFrame, cfg, sTheme, sZIndex + 6, sectionAPI:_NextOrder())
    end
    function sectionAPI:AddDropdown(cfg)
        return CreateDropdown(sectionFrame, cfg, sTheme, sZIndex + 6, sectionAPI:_NextOrder())
    end
    function sectionAPI:AddInput(cfg)
        return CreateInput(sectionFrame, cfg, sTheme, sZIndex + 6, sectionAPI:_NextOrder())
    end
    function sectionAPI:AddLabel(cfg)
        return CreateLabel(sectionFrame, cfg, sTheme, sZIndex + 6, sectionAPI:_NextOrder())
    end
    function sectionAPI:AddColorPicker(cfg)
        return CreateColorPicker(sectionFrame, cfg, sTheme, sZIndex + 6, sectionAPI:_NextOrder())
    end
    function sectionAPI:AddKeybind(cfg)
        return CreateKeybind(sectionFrame, cfg, sTheme, sZIndex + 6, sectionAPI:_NextOrder())
    end
    function sectionAPI:AddDivider()
        return CreateDivider(sectionFrame, sTheme, sZIndex + 6, sectionAPI:_NextOrder())
    end
    
    return sectionAPI
end

-- =============================================
-- WINDOW SYSTEM
-- =============================================
local WindowClass = {}
WindowClass.__index = WindowClass

function WindowClass.new(config)
    local self = setmetatable({}, WindowClass)
    config = config or {}
    
    self._Title = config.Title or "BreezeUI Window"
    self._SubTitle = config.SubTitle or ""
    self._ThemeName = config.Theme or "Dark"
    self._Theme = Themes[self._ThemeName] or Themes.Dark
    self._Size = config.Size or UDim2.new(0, 550, 0, 400)
    self._Transparent = config.Transparent or false
    self._Position = config.Position or UDim2.new(0.5, 0, 0.5, 0)
    self._MinimizeKey = config.MinimizeKey or Enum.KeyCode.RightControl
    self._Tabs = {}
    self._ActiveTab = nil
    self._IsMinimized = false
    self._IsVisible = true
    self._ZIndex = 10
    
    self:_Build()
    return self
end

function WindowClass:_Build()
    local theme = self._Theme
    local zIndex = self._ZIndex
    
    -- ScreenGui
    self._ScreenGui = Instance.new("ScreenGui")
    self._ScreenGui.Name = "BreezeUI_" .. self._Title
    self._ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self._ScreenGui.ResetOnSpawn = false
    
    -- Tentar parentear ao CoreGui, senao usar PlayerGui
    local success = pcall(function()
        self._ScreenGui.Parent = CoreGui
    end)
    if not success then
        self._ScreenGui.Parent = Player:WaitForChild("PlayerGui")
    end
    
    -- Notification system
    self._Notifications = NotificationSystem.new(self._ScreenGui, theme)
    
    -- Main Frame
    self._MainFrame = Instance.new("Frame")
    self._MainFrame.Name = "MainFrame"
    self._MainFrame.BackgroundColor3 = theme.Background
    self._MainFrame.BackgroundTransparency = self._Transparent and 0.15 or 0
    self._MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    self._MainFrame.Position = self._Position
    self._MainFrame.Size = self._Size
    self._MainFrame.ZIndex = zIndex
    self._MainFrame.ClipsDescendants = true
    self._MainFrame.Parent = self._ScreenGui
    Utilities:CreateCorner(self._MainFrame, 12)
    Utilities:CreateStroke(self._MainFrame, theme.Divider, 1, 0.3)
    Utilities:CreateShadow(self._MainFrame, theme)
    
    -- Animacao de entrada
    self._MainFrame.Size = UDim2.new(0, 0, 0, 0)
    self._MainFrame.BackgroundTransparency = 1
    Utilities:Tween(self._MainFrame, {
        Size = self._Size,
        BackgroundTransparency = self._Transparent and 0.15 or 0
    }, 0.5, Enum.EasingStyle.Back)
    
    -- Title Bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.BackgroundColor3 = theme.SecondaryBackground
    titleBar.BackgroundTransparency = 0.3
    titleBar.Size = UDim2.new(1, 0, 0, 45)
    titleBar.ZIndex = zIndex + 1
    titleBar.Parent = self._MainFrame
    Utilities:CreateCorner(titleBar, 0)
    
    -- Titulo
    local titleText = Instance.new("TextLabel")
    titleText.Name = "Title"
    titleText.BackgroundTransparency = 1
    titleText.Position = UDim2.new(0, 15, 0, 0)
    titleText.Size = UDim2.new(0.6, 0, 0, self._SubTitle ~= "" and 26 or 45)
    titleText.Font = Enum.Font.GothamBold
    titleText.Text = self._Title
    titleText.TextColor3 = theme.Text
    titleText.TextSize = 16
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.ZIndex = zIndex + 2
    titleText.Parent = titleBar
    
    if self._SubTitle ~= "" then
        local subTitleText = Instance.new("TextLabel")
        subTitleText.Name = "SubTitle"
        subTitleText.BackgroundTransparency = 1
        subTitleText.Position = UDim2.new(0, 15, 0, 24)
        subTitleText.Size = UDim2.new(0.6, 0, 0, 18)
        subTitleText.Font = Enum.Font.Gotham
        subTitleText.Text = self._SubTitle
        subTitleText.TextColor3 = theme.SubText
        subTitleText.TextSize = 11
        subTitleText.TextXAlignment = Enum.TextXAlignment.Left
        subTitleText.ZIndex = zIndex + 2
        subTitleText.Parent = titleBar
    end
    
    -- Botoes da janela (Minimizar, Fechar)
    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "Close"
    closeBtn.BackgroundColor3 = Color3.fromRGB(239, 68, 68)
    closeBtn.BackgroundTransparency = 0.5
    closeBtn.Position = UDim2.new(1, -35, 0.5, 0)
    closeBtn.AnchorPoint = Vector2.new(0, 0.5)
    closeBtn.Size = UDim2.new(0, 22, 0, 22)
    closeBtn.Text = "X"
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextColor3 = Color3.fromRGB(239, 68, 68)
    closeBtn.TextSize = 12
    closeBtn.AutoButtonColor = false
    closeBtn.ZIndex = zIndex + 3
    closeBtn.Parent = titleBar
    Utilities:CreateCorner(closeBtn, 6)
    
    closeBtn.MouseEnter:Connect(function()
        Utilities:Tween(closeBtn, {BackgroundTransparency = 0, TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.2)
    end)
    closeBtn.MouseLeave:Connect(function()
        Utilities:Tween(closeBtn, {BackgroundTransparency = 0.5, TextColor3 = Color3.fromRGB(239, 68, 68)}, 0.2)
    end)
    closeBtn.MouseButton1Click:Connect(function()
        self:Destroy()
    end)
    
    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Name = "Minimize"
    minimizeBtn.BackgroundColor3 = Color3.fromRGB(251, 191, 36)
    minimizeBtn.BackgroundTransparency = 0.5
    minimizeBtn.Position = UDim2.new(1, -62, 0.5, 0)
    minimizeBtn.AnchorPoint = Vector2.new(0, 0.5)
    minimizeBtn.Size = UDim2.new(0, 22, 0, 22)
    minimizeBtn.Text = "-"
    minimizeBtn.Font = Enum.Font.GothamBold
    minimizeBtn.TextColor3 = Color3.fromRGB(251, 191, 36)
    minimizeBtn.TextSize = 16
    minimizeBtn.AutoButtonColor = false
    minimizeBtn.ZIndex = zIndex + 3
    minimizeBtn.Parent = titleBar
    Utilities:CreateCorner(minimizeBtn, 6)
    
    minimizeBtn.MouseEnter:Connect(function()
        Utilities:Tween(minimizeBtn, {BackgroundTransparency = 0, TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.2)
    end)
    minimizeBtn.MouseLeave:Connect(function()
        Utilities:Tween(minimizeBtn, {BackgroundTransparency = 0.5, TextColor3 = Color3.fromRGB(251, 191, 36)}, 0.2)
    end)
    minimizeBtn.MouseButton1Click:Connect(function()
        self:ToggleMinimize()
    end)
    
    -- Keybind para minimizar
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == self._MinimizeKey then
            self:ToggleMinimize()
        end
    end)
    
    -- Dragging (arrastar janela)
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = self._MainFrame.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            self._MainFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    -- Sidebar (barra lateral com tabs)
    self._Sidebar = Instance.new("Frame")
    self._Sidebar.Name = "Sidebar"
    self._Sidebar.BackgroundColor3 = theme.SecondaryBackground
    self._Sidebar.Position = UDim2.new(0, 0, 0, 45)
    self._Sidebar.Size = UDim2.new(0, 150, 1, -45)
    self._Sidebar.ZIndex = zIndex + 1
    self._Sidebar.Parent = self._MainFrame
    
    -- Divider entre sidebar e conteudo
    local sidebarDivider = Instance.new("Frame")
    sidebarDivider.Name = "Divider"
    sidebarDivider.BackgroundColor3 = theme.Divider
    sidebarDivider.BackgroundTransparency = 0.5
    sidebarDivider.Position = UDim2.new(1, 0, 0, 0)
    sidebarDivider.Size = UDim2.new(0, 1, 1, 0)
    sidebarDivider.BorderSizePixel = 0
    sidebarDivider.ZIndex = zIndex + 2
    sidebarDivider.Parent = self._Sidebar
    
    -- Tab buttons container
    self._TabContainer = Instance.new("ScrollingFrame")
    self._TabContainer.Name = "TabList"
    self._TabContainer.BackgroundTransparency = 1
    self._TabContainer.Size = UDim2.new(1, 0, 1, 0)
    self._TabContainer.ScrollBarThickness = 2
    self._TabContainer.ScrollBarImageColor3 = theme.Accent
    self._TabContainer.ScrollBarImageTransparency = 0.5
    self._TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    self._TabContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
    self._TabContainer.ZIndex = zIndex + 2
    self._TabContainer.Parent = self._Sidebar
    Utilities:CreateListLayout(self._TabContainer, 4, Enum.FillDirection.Vertical, 
        Enum.HorizontalAlignment.Center, Enum.VerticalAlignment.Top)
    Utilities:CreatePadding(self._TabContainer, 8, 8, 8, 8)
    
    -- Content area
    self._ContentArea = Instance.new("Frame")
    self._ContentArea.Name = "ContentArea"
    self._ContentArea.BackgroundTransparency = 1
    self._ContentArea.Position = UDim2.new(0, 151, 0, 45)
    self._ContentArea.Size = UDim2.new(1, -151, 1, -45)
    self._ContentArea.ZIndex = zIndex + 1
    self._ContentArea.Parent = self._MainFrame
end

function WindowClass:AddTab(config)
    config = config or {}
    local title = config.Title or "Tab"
    local icon = config.Icon or nil
    local theme = self._Theme
    local zIndex = self._ZIndex
    
    -- Tab button
    local tabBtn = Instance.new("TextButton")
    tabBtn.Name = "Tab_" .. title
    tabBtn.BackgroundColor3 = theme.TabInactive
    tabBtn.BackgroundTransparency = 1
    tabBtn.Size = UDim2.new(1, 0, 0, 34)
    tabBtn.Text = ""
    tabBtn.AutoButtonColor = false
    tabBtn.ZIndex = zIndex + 3
    tabBtn.LayoutOrder = #self._Tabs + 1
    tabBtn.Parent = self._TabContainer
    Utilities:CreateCorner(tabBtn, 8)
    
    -- Indicator bar (barra de indicacao ativa)
    local indicator = Instance.new("Frame")
    indicator.Name = "Indicator"
    indicator.BackgroundColor3 = theme.Accent
    indicator.Position = UDim2.new(0, 0, 0.15, 0)
    indicator.Size = UDim2.new(0, 3, 0.7, 0)
    indicator.BackgroundTransparency = 1
    indicator.ZIndex = zIndex + 4
    indicator.Parent = tabBtn
    Utilities:CreateCorner(indicator, 2)
    
    local tabLabel = Instance.new("TextLabel")
    tabLabel.Name = "Label"
    tabLabel.BackgroundTransparency = 1
    tabLabel.Position = icon and UDim2.new(0, 30, 0, 0) or UDim2.new(0, 12, 0, 0)
    tabLabel.Size = icon and UDim2.new(1, -40, 1, 0) or UDim2.new(1, -20, 1, 0)
    tabLabel.Font = Enum.Font.GothamSemibold
    tabLabel.Text = title
    tabLabel.TextColor3 = theme.SubText
    tabLabel.TextSize = 13
    tabLabel.TextXAlignment = Enum.TextXAlignment.Left
    tabLabel.ZIndex = zIndex + 4
    tabLabel.Parent = tabBtn
    
    if icon then
        local iconImg = Instance.new("ImageLabel")
        iconImg.Name = "Icon"
        iconImg.BackgroundTransparency = 1
        iconImg.Position = UDim2.new(0, 8, 0.5, 0)
        iconImg.AnchorPoint = Vector2.new(0, 0.5)
        iconImg.Size = UDim2.new(0, 18, 0, 18)
        iconImg.Image = icon
        iconImg.ImageColor3 = theme.SubText
        iconImg.ZIndex = zIndex + 4
        iconImg.Parent = tabBtn
    end
    
    -- Content frame para esta tab
    local contentScroll = Instance.new("ScrollingFrame")
    contentScroll.Name = "Content_" .. title
    contentScroll.BackgroundTransparency = 1
    contentScroll.Size = UDim2.new(1, 0, 1, 0)
    contentScroll.ScrollBarThickness = 3
    contentScroll.ScrollBarImageColor3 = theme.Accent
    contentScroll.ScrollBarImageTransparency = 0.5
    contentScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    contentScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    contentScroll.Visible = false
    contentScroll.ZIndex = zIndex + 2
    contentScroll.Parent = self._ContentArea
    Utilities:CreateListLayout(contentScroll, 6, Enum.FillDirection.Vertical,
        Enum.HorizontalAlignment.Center, Enum.VerticalAlignment.Top)
    Utilities:CreatePadding(contentScroll, 10, 10, 10, 10)
    
    local tabObject = TabClass.new({
        Title = title,
        Icon = icon,
        Theme = theme,
        ZIndex = zIndex,
        ContentFrame = contentScroll,
        TabButton = tabBtn,
    })
    
    table.insert(self._Tabs, {
        Object = tabObject,
        Button = tabBtn,
        Content = contentScroll,
        Indicator = indicator,
        Label = tabLabel,
        IconObj = tabBtn:FindFirstChild("Icon"),
    })
    
    -- Click handler
    tabBtn.MouseButton1Click:Connect(function()
        self:_SelectTab(#self._Tabs)
    end)
    
    -- Hover
    tabBtn.MouseEnter:Connect(function()
        if self._ActiveTab ~= #self._Tabs then
            Utilities:Tween(tabBtn, {BackgroundTransparency = 0.5}, 0.2)
        end
    end)
    
    tabBtn.MouseLeave:Connect(function()
        if self._ActiveTab ~= #self._Tabs then
            Utilities:Tween(tabBtn, {BackgroundTransparency = 1}, 0.2)
        end
    end)
    
    -- Auto-selecionar primeira tab
    if #self._Tabs == 1 then
        self:_SelectTab(1)
    end
    
    return tabObject
end

function WindowClass:_SelectTab(index)
    local theme = self._Theme
    
    -- Desativar tab atual
    if self._ActiveTab then
        local oldTab = self._Tabs[self._ActiveTab]
        if oldTab then
            Utilities:Tween(oldTab.Button, {BackgroundTransparency = 1}, 0.2)
            Utilities:Tween(oldTab.Indicator, {BackgroundTransparency = 1}, 0.2)
            Utilities:Tween(oldTab.Label, {TextColor3 = theme.SubText}, 0.2)
            if oldTab.IconObj then
                Utilities:Tween(oldTab.IconObj, {ImageColor3 = theme.SubText}, 0.2)
            end
            oldTab.Content.Visible = false
        end
    end
    
    -- Ativar nova tab
    self._ActiveTab = index
    local newTab = self._Tabs[index]
    if newTab then
        Utilities:Tween(newTab.Button, {BackgroundTransparency = 0.3, BackgroundColor3 = theme.TertiaryBackground}, 0.2)
        Utilities:Tween(newTab.Indicator, {BackgroundTransparency = 0}, 0.2)
        Utilities:Tween(newTab.Label, {TextColor3 = theme.Text}, 0.2)
        if newTab.IconObj then
            Utilities:Tween(newTab.IconObj, {ImageColor3 = theme.Accent}, 0.2)
        end
        newTab.Content.Visible = true
    end
end

function WindowClass:ToggleMinimize()
    self._IsMinimized = not self._IsMinimized
    if self._IsMinimized then
        Utilities:Tween(self._MainFrame, {Size = UDim2.new(0, self._Size.X.Offset, 0, 45)}, 0.35, Enum.EasingStyle.Back, Enum.EasingDirection.In)
    else
        Utilities:Tween(self._MainFrame, {Size = self._Size}, 0.35, Enum.EasingStyle.Back)
    end
end

function WindowClass:Toggle()
    self._IsVisible = not self._IsVisible
    if self._IsVisible then
        self._MainFrame.Visible = true
        Utilities:Tween(self._MainFrame, {
            Size = self._Size,
            BackgroundTransparency = self._Transparent and 0.15 or 0
        }, 0.35, Enum.EasingStyle.Back)
    else
        Utilities:Tween(self._MainFrame, {
            Size = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1
        }, 0.35, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        task.delay(0.35, function()
            if not self._IsVisible then
                self._MainFrame.Visible = false
            end
        end)
    end
end

function WindowClass:Notify(config)
    self._Notifications:Notify(config)
end

function WindowClass:SetTheme(themeName)
    -- Nota: mudar tema em runtime requer rebuild (simplificado aqui)
    if Themes[themeName] then
        self._ThemeName = themeName
        self._Theme = Themes[themeName]
    end
end

function WindowClass:Destroy()
    Utilities:Tween(self._MainFrame, {
        Size = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1
    }, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In)
    
    task.delay(0.45, function()
        if self._ScreenGui and self._ScreenGui.Parent then
            self._ScreenGui:Destroy()
        end
    end)
end

-- =============================================
-- API PUBLICA
-- =============================================

function BreezeUI:CreateWindow(config)
    local window = WindowClass.new(config)
    table.insert(self._Windows, window)
    return window
end

function BreezeUI:GetThemes()
    local themeNames = {}
    for name, _ in pairs(Themes) do
        table.insert(themeNames, name)
    end
    return themeNames
end

function BreezeUI:AddCustomTheme(name, themeData)
    Themes[name] = themeData
end

function BreezeUI:DestroyAll()
    for _, window in ipairs(self._Windows) do
        window:Destroy()
    end
    self._Windows = {}
end

print("[BreezeUI] Biblioteca carregada com sucesso! v" .. BreezeUI._Version)

return BreezeUI
