-- ══════════════════════════════════════════════
--  BlessedHubX  v8  —  Library
-- ══════════════════════════════════════════════

local HttpService = game:GetService("HttpService")

if not isfolder("Blessed Hub X") then makefolder("Blessed Hub X") end
if not isfolder("Blessed Hub X/Config") then makefolder("Blessed Hub X/Config") end

local gameName = tostring(game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name)
gameName = gameName:gsub("[^%w_ ]", ""):gsub("%s+", "_")
local ConfigFile = "Blessed Hub X/Config/Blessed_" .. gameName .. ".json"

ConfigData      = {}
Elements        = {}
CURRENT_VERSION = nil

local function tableFind(tbl, val)
    for i, v in ipairs(tbl) do if v == val then return i end end
end

function SaveConfig()
    if writefile then
        ConfigData._version = CURRENT_VERSION
        writefile(ConfigFile, HttpService:JSONEncode(ConfigData))
    end
end

function LoadConfigFromFile()
    if not CURRENT_VERSION then return end
    if isfile and isfile(ConfigFile) then
        local ok, res = pcall(function() return HttpService:JSONDecode(readfile(ConfigFile)) end)
        if ok and type(res) == "table" then
            ConfigData = (res._version == CURRENT_VERSION) and res or { _version = CURRENT_VERSION }
        else
            ConfigData = { _version = CURRENT_VERSION }
        end
    else
        ConfigData = { _version = CURRENT_VERSION }
    end
end

function LoadConfigElements()
    for key, el in pairs(Elements) do
        if ConfigData[key] ~= nil and el.Set then el:Set(ConfigData[key], true) end
    end
end

-- ── Icons ────────────────────────────────────
local Icons = {
    player="rbxassetid://12120698352", web="rbxassetid://137601480983962",
    bag="rbxassetid://8601111810", shop="rbxassetid://4985385964",
    cart="rbxassetid://128874923961846", plug="rbxassetid://137601480983962",
    settings="rbxassetid://70386228443175", loop="rbxassetid://122032243989747",
    gps="rbxassetid://17824309485", compas="rbxassetid://125300760963399",
    gamepad="rbxassetid://84173963561612", boss="rbxassetid://13132186360",
    scroll="rbxassetid://114127804740858", menu="rbxassetid://6340513838",
    crosshair="rbxassetid://12614416478", user="rbxassetid://108483430622128",
    stat="rbxassetid://12094445329", eyes="rbxassetid://14321059114",
    sword="rbxassetid://82472368671405", discord="rbxassetid://94434236999817",
    star="rbxassetid://107005941750079", skeleton="rbxassetid://17313330026",
    payment="rbxassetid://18747025078", scan="rbxassetid://109869955247116",
    alert="rbxassetid://73186275216515", question="rbxassetid://17510196486",
    idea="rbxassetid://16833255748", strom="rbxassetid://13321880293",
    water="rbxassetid://100076212630732", dcs="rbxassetid://15310731934",
    start="rbxassetid://108886429866687", next="rbxassetid://12662718374",
    rod="rbxassetid://103247953194129", fish="rbxassetid://97167558235554",
    blessed="rbxassetid://137601480983962",
}

-- ── Services ─────────────────────────────────
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local RunService       = game:GetService("RunService")
local LocalPlayer      = game:GetService("Players").LocalPlayer
local Mouse            = LocalPlayer:GetMouse()
local CoreGui          = game:GetService("CoreGui")

local isMobile = UserInputService.TouchEnabled
    and not UserInputService.KeyboardEnabled
    and not UserInputService.MouseEnabled

-- janela maior no mobile para touch targets confortáveis
local CurrentWindowSize = isMobile
    and UDim2.new(0, 500, 0, 320)
    or  UDim2.new(0, 640, 0, 420)

-- ════════════════════════════════════════════
-- Animated Gradient helper  (shared, throttled ~25 fps)
-- ════════════════════════════════════════════
local function MakeAnimatedGradient(stroke, anchorFrame)
    local grad = Instance.new("UIGradient")
    grad.Parent = stroke
    grad.Transparency = NumberSequence.new{
        NumberSequenceKeypoint.new(0,   1),
        NumberSequenceKeypoint.new(0.3, 0),
        NumberSequenceKeypoint.new(0.7, 0),
        NumberSequenceKeypoint.new(1,   1),
    }
    local rot, acc = 0, 0
    local conn
    conn = RunService.Heartbeat:Connect(function(dt)
        if not stroke or not stroke.Parent then conn:Disconnect(); return end
        acc = acc + dt
        if acc < 0.04 then return end
        acc = 0
        rot = (rot + dt * 70) % 360
        local hue = 0.85 + math.sin(tick() * 1.8) * 0.025
        local col = Color3.fromHSV(hue, 1, 1)
        grad.Color    = ColorSequence.new{ ColorSequenceKeypoint.new(0, col), ColorSequenceKeypoint.new(1, col) }
        grad.Rotation = rot
    end)
    if anchorFrame then
        anchorFrame.AncestryChanged:Connect(function()
            if not anchorFrame.Parent then conn:Disconnect() end
        end)
    end
    return grad, conn
end

-- ════════════════════════════════════════════
-- Drag
-- ════════════════════════════════════════════
local function MakeDraggable(handle, object)
    local dragging, dragInput, dragStart, startPos
    local conn

    handle.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            dragging  = true
            dragStart = inp.Position
            startPos  = object.Position
            inp.Changed:Connect(function()
                if inp.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    handle.InputChanged:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
            dragInput = inp
        end
    end)
    conn = UserInputService.InputChanged:Connect(function(inp)
        if inp == dragInput and dragging then
            local d = inp.Position - dragStart
            object.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X,
                                        startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
    object.Destroying:Connect(function() if conn then conn:Disconnect() end end)
end

-- ════════════════════════════════════════════
-- Resize  (disabled on mobile – window is fixed)
-- ════════════════════════════════════════════
local function MakeResizable(object, minW, minH)
    if isMobile then return end
    minW, minH = minW or 420, minH or 300

    local resizing, resizeInput, resizeStart, startSize
    local conn

    local handle = Instance.new("Frame")
    handle.AnchorPoint         = Vector2.new(1, 1)
    handle.BackgroundTransparency = 1
    handle.Size                = UDim2.new(0, 20, 0, 20)
    handle.Position            = UDim2.new(1, 0, 1, 0)
    handle.Name                = "resizeHandle"
    handle.Parent              = object

    handle.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing    = true
            resizeStart = inp.Position
            startSize   = object.Size
            inp.Changed:Connect(function()
                if inp.UserInputState == Enum.UserInputState.End then resizing = false end
            end)
        end
    end)
    handle.InputChanged:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseMovement then resizeInput = inp end
    end)
    conn = UserInputService.InputChanged:Connect(function(inp)
        if inp == resizeInput and resizing then
            local d = inp.Position - resizeStart
            local nw = math.max(startSize.X.Offset + d.X, minW)
            local nh = math.max(startSize.Y.Offset + d.Y, minH)
            object.Size      = UDim2.new(0, nw, 0, nh)
            CurrentWindowSize = object.Size
        end
    end)
    object.Destroying:Connect(function() if conn then conn:Disconnect() end end)
end

-- ════════════════════════════════════════════
-- Ripple
-- ════════════════════════════════════════════
function CircleClick(btn, x, y)
    task.spawn(function()
        btn.ClipsDescendants = true
        local c = Instance.new("ImageLabel")
        c.Image = "rbxassetid://266543268"
        c.ImageColor3 = Color3.fromRGB(210, 210, 210)
        c.ImageTransparency = 0.75
        c.BackgroundTransparency = 1
        c.ZIndex = 10
        c.Size = UDim2.new(0, 0, 0, 0)
        c.Position = UDim2.new(0, x - btn.AbsolutePosition.X, 0, y - btn.AbsolutePosition.Y)
        c.Parent = btn
        local sz = math.max(btn.AbsoluteSize.X, btn.AbsoluteSize.Y) * 1.6
        TweenService:Create(c, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, sz, 0, sz),
            Position = UDim2.new(0.5, -sz/2, 0.5, -sz/2),
            ImageTransparency = 1,
        }):Play()
        task.wait(0.35)
        c:Destroy()
    end)
end

-- ══════════════════════════════════════════════
--  BlessedHubX
-- ══════════════════════════════════════════════
local BlessedHubX = {}

-- ── Notify ───────────────────────────────────
function BlessedHubX:MakeNotify(cfg)
    cfg = cfg or {}
    cfg.Title       = cfg.Title       or "Blessed Hub X"
    cfg.Description = cfg.Description or "Notification"
    cfg.Content     = cfg.Content     or "Content"
    cfg.Color       = cfg.Color       or Color3.fromRGB(255, 105, 180)
    cfg.Time        = cfg.Time        or 0.5
    cfg.Delay       = cfg.Delay       or 5
    local fn = {}

    task.spawn(function()
        if not CoreGui:FindFirstChild("NotifyGui") then
            local ng = Instance.new("ScreenGui")
            ng.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            ng.Name = "NotifyGui"; ng.Parent = CoreGui
        end
        if not CoreGui.NotifyGui:FindFirstChild("NotifyLayout") then
            local nl = Instance.new("Frame")
            nl.AnchorPoint = Vector2.new(1, 1)
            nl.BackgroundTransparency = 1
            nl.Position = UDim2.new(1, -16, 1, -16)
            nl.Size     = UDim2.new(0, 300, 1, 0)
            nl.Name     = "NotifyLayout"
            nl.Parent   = CoreGui.NotifyGui
            local cnt = 0
            nl.ChildRemoved:Connect(function()
                cnt = 0
                for _, v in nl:GetChildren() do
                    TweenService:Create(v, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                        { Position = UDim2.new(0, 0, 1, -((v.Size.Y.Offset + 10) * cnt)) }):Play()
                    cnt += 1
                end
            end)
        end

        local posY = 0
        for _, v in CoreGui.NotifyGui.NotifyLayout:GetChildren() do
            posY = -(v.Position.Y.Offset) + v.Size.Y.Offset + 10
        end

        local nf  = Instance.new("Frame")
        local nfr = Instance.new("Frame")
        nf.BackgroundTransparency = 1
        nf.Size        = UDim2.new(1, 0, 0, 70)
        nf.Name        = "NotifyFrame"
        nf.AnchorPoint = Vector2.new(0, 1)
        nf.Position    = UDim2.new(0, 0, 1, -posY)
        nf.Parent      = CoreGui.NotifyGui.NotifyLayout

        nfr.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
        nfr.BorderSizePixel  = 0
        nfr.Position         = UDim2.new(0, 330, 0, 0)
        nfr.Size             = UDim2.new(1, 0, 1, 0)
        nfr.Name             = "NotifyFrameReal"
        nfr.Parent           = nf
        Instance.new("UICorner", nfr).CornerRadius = UDim.new(0, 8)

        local st = Instance.new("UIStroke", nfr)
        st.Thickness = 1.8
        st.Color     = Color3.fromRGB(255, 255, 255)
        MakeAnimatedGradient(st, nf)

        local top = Instance.new("Frame")
        top.BackgroundTransparency = 1
        top.Size   = UDim2.new(1, 0, 0, 36)
        top.Parent = nfr

        local tl = Instance.new("TextLabel")
        tl.Font = Enum.Font.GothamBold; tl.Text = cfg.Title
        tl.TextColor3 = Color3.fromRGB(255,255,255); tl.TextSize = 13
        tl.TextXAlignment = Enum.TextXAlignment.Left
        tl.BackgroundTransparency = 1
        tl.Size = UDim2.new(1, 0, 1, 0)
        tl.Position = UDim2.new(0, 12, 0, 0)
        tl.Parent = top

        local tl1 = Instance.new("TextLabel")
        tl1.Font = Enum.Font.GothamBold; tl1.Text = cfg.Description
        tl1.TextColor3 = cfg.Color; tl1.TextSize = 13
        tl1.TextXAlignment = Enum.TextXAlignment.Left
        tl1.BackgroundTransparency = 1
        tl1.Size = UDim2.new(1, 0, 1, 0)
        tl1.Position = UDim2.new(0, tl.TextBounds.X + 18, 0, 0)
        tl1.Parent = top

        local tl2 = Instance.new("TextLabel")
        tl2.Font = Enum.Font.Gotham; tl2.Text = cfg.Content
        tl2.TextSize = 12; tl2.TextXAlignment = Enum.TextXAlignment.Left
        tl2.TextYAlignment = Enum.TextYAlignment.Top
        tl2.BackgroundTransparency = 1
        tl2.TextColor3 = Color3.fromRGB(170, 170, 170)
        tl2.Position = UDim2.new(0, 12, 0, 30)
        tl2.Size = UDim2.new(1, -24, 0, 12)
        tl2.TextWrapped = true
        tl2.Parent = nfr
        tl2.Size = UDim2.new(1, -24, 0, 12 + (12 * (tl2.TextBounds.X // math.max(tl2.AbsoluteSize.X, 1))))
        nf.Size = UDim2.new(1, 0, 0, tl2.AbsoluteSize.Y + 42)

        local closed = false
        function fn:Close()
            if closed then return end; closed = true
            TweenService:Create(nfr, TweenInfo.new(cfg.Time, Enum.EasingStyle.Back, Enum.EasingDirection.In),
                { Position = UDim2.new(0, 330, 0, 0) }):Play()
            task.wait(cfg.Time * 0.85)
            nf:Destroy()
        end
        TweenService:Create(nfr, TweenInfo.new(cfg.Time * 1.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
            { Position = UDim2.new(0, 0, 0, 0) }):Play()
        task.wait(cfg.Delay)
        fn:Close()
    end)
    return fn
end

function blessedhubx(msg, delay, color, title, desc)
    return BlessedHubX:MakeNotify({
        Title=title or "Blessed Hub X", Description=desc or "Notification",
        Content=msg or "Content", Color=color or Color3.fromRGB(255,105,180), Delay=delay or 4,
    })
end

-- ══════════════════════════════════════════════
--  Window
-- ══════════════════════════════════════════════
function BlessedHubX:Window(GuiConfig)
    GuiConfig = GuiConfig or {}
    GuiConfig.Title        = GuiConfig.Title        or "Blessed Hub X"
    GuiConfig.Footer       = GuiConfig.Footer       or "Premium Edition"
    GuiConfig.Color        = GuiConfig.Color        or Color3.fromRGB(255, 105, 180)
    GuiConfig["Tab Width"] = GuiConfig["Tab Width"] or 62
    GuiConfig.Version      = GuiConfig.Version      or 1
    GuiConfig.Logo         = GuiConfig.Logo         or Icons.blessed

    CURRENT_VERSION = GuiConfig.Version
    LoadConfigFromFile()

    -- Adjust tab width for mobile
    local TAB_W = isMobile and 54 or GuiConfig["Tab Width"]

    local GuiFunc = {}

    local ScreenGui       = Instance.new("ScreenGui")
    local DropShadowHolder = Instance.new("Frame")
    local DropShadow      = Instance.new("ImageLabel")
    local Main            = Instance.new("Frame")
    local UICorner        = Instance.new("UICorner")
    local Top             = Instance.new("Frame")
    local TitleLabel      = Instance.new("TextLabel")
    local FooterLabel     = Instance.new("TextLabel")
    local Close           = Instance.new("TextButton")
    local Min             = Instance.new("TextButton")
    -- FIX: LayersTab is INSIDE Main but to the LEFT; Layers is to the RIGHT
    -- We use a container frame that holds both side-by-side to avoid any overlap.
    local ContentHolder   = Instance.new("Frame")  -- holds tab bar + content, fills below top bar
    local LayersTab       = Instance.new("Frame")
    local Layers          = Instance.new("Frame")
    local NameTab         = Instance.new("TextLabel")
    local LayersReal      = Instance.new("Frame")
    local LayersFolder    = Instance.new("Folder")
    local LayersPageLayout = Instance.new("UIPageLayout")

    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Name           = "BlessedHubX"
    ScreenGui.ResetOnSpawn   = false
    ScreenGui.Parent         = CoreGui

    DropShadowHolder.BackgroundTransparency = 1
    DropShadowHolder.BorderSizePixel        = 0
    DropShadowHolder.AnchorPoint            = Vector2.new(0.5, 0.5)
    DropShadowHolder.Position               = UDim2.new(0.5, 0, 0.5, 0)
    DropShadowHolder.Size                   = CurrentWindowSize
    DropShadowHolder.Name                   = "DropShadowHolder"
    DropShadowHolder.Parent                 = ScreenGui

    DropShadow.Image             = "rbxassetid://6015897843"
    DropShadow.ImageColor3       = Color3.fromRGB(10, 10, 10)
    DropShadow.ImageTransparency = 0.5
    DropShadow.ScaleType         = Enum.ScaleType.Slice
    DropShadow.SliceCenter       = Rect.new(49, 49, 450, 450)
    DropShadow.AnchorPoint       = Vector2.new(0.5, 0.5)
    DropShadow.BackgroundTransparency = 1
    DropShadow.Position          = UDim2.new(0.5, 0, 0.5, 0)
    DropShadow.Size              = UDim2.new(1, 47, 1, 47)
    DropShadow.ZIndex            = 0
    DropShadow.Name              = "DropShadow"
    DropShadow.Parent            = DropShadowHolder

    Main.BackgroundColor3        = Color3.fromRGB(20, 20, 20)
    Main.BackgroundTransparency  = 0
    Main.AnchorPoint             = Vector2.new(0.5, 0.5)
    Main.BorderSizePixel         = 0
    Main.ClipsDescendants        = true   -- FIX: prevent tab sidebar bleeding
    Main.Position                = UDim2.new(0.5, 0, 0.5, 0)
    Main.Size                    = UDim2.new(1, -47, 1, -47)
    Main.Name                    = "Main"
    Main.Parent                  = DropShadow

    local MainStroke = Instance.new("UIStroke", Main)
    MainStroke.Thickness = 1.8
    MainStroke.Color     = Color3.fromRGB(255, 255, 255)
    MakeAnimatedGradient(MainStroke, ScreenGui)

    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent       = Main

    -- ── Top bar ──────────────────────────────
    local TOP_H = isMobile and 44 or 40
    Top.BackgroundTransparency = 1
    Top.Size   = UDim2.new(1, 0, 0, TOP_H)
    Top.Name   = "Top"
    Top.Parent = Main

    local LogoIcon = Instance.new("ImageLabel")
    LogoIcon.Image              = GuiConfig.Logo
    LogoIcon.Size               = UDim2.new(0, 22, 0, 22)
    LogoIcon.Position           = UDim2.new(0, 12, 0.5, -11)
    LogoIcon.BackgroundTransparency = 1
    LogoIcon.Name               = "LogoIcon"
    LogoIcon.Parent             = Top

    TitleLabel.Font             = Enum.Font.GothamBold
    TitleLabel.Text             = GuiConfig.Title
    TitleLabel.TextColor3       = GuiConfig.Color
    TitleLabel.TextSize         = isMobile and 13 or 14
    TitleLabel.TextXAlignment   = Enum.TextXAlignment.Left
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Size             = UDim2.new(0.5, 0, 1, 0)
    TitleLabel.Position         = UDim2.new(0, 42, 0, 0)
    TitleLabel.Parent           = Top

    FooterLabel.Font            = Enum.Font.Gotham
    FooterLabel.Text            = GuiConfig.Footer
    FooterLabel.TextColor3      = Color3.fromRGB(120, 120, 120)
    FooterLabel.TextSize        = isMobile and 11 or 12
    FooterLabel.TextXAlignment  = Enum.TextXAlignment.Left
    FooterLabel.BackgroundTransparency = 1
    FooterLabel.Size            = UDim2.new(0.35, 0, 1, 0)
    FooterLabel.Position        = UDim2.new(0, TitleLabel.TextBounds.X + 50, 0, 0)
    FooterLabel.Parent          = Top

    -- Close / Min — bigger on mobile for tap targets
    local BTN_SZ = isMobile and 34 or 26
    Close.Font = Enum.Font.SourceSans; Close.Text = ""
    Close.AnchorPoint = Vector2.new(1, 0.5)
    Close.BackgroundTransparency = 1
    Close.Position = UDim2.new(1, -8, 0.5, 0)
    Close.Size     = UDim2.new(0, BTN_SZ, 0, BTN_SZ)
    Close.Name     = "Close"; Close.Parent = Top
    local CloseImg = Instance.new("ImageLabel")
    CloseImg.Image = "rbxassetid://9886659671"
    CloseImg.AnchorPoint = Vector2.new(0.5, 0.5)
    CloseImg.BackgroundTransparency = 1
    CloseImg.Position = UDim2.new(0.5, 0, 0.5, 0)
    CloseImg.Size = UDim2.new(0, 18, 0, 18)
    CloseImg.Parent = Close

    Min.Font = Enum.Font.SourceSans; Min.Text = ""
    Min.AnchorPoint = Vector2.new(1, 0.5)
    Min.BackgroundTransparency = 1
    Min.Position = UDim2.new(1, -(BTN_SZ + 10), 0.5, 0)
    Min.Size     = UDim2.new(0, BTN_SZ, 0, BTN_SZ)
    Min.Name     = "Min"; Min.Parent = Top
    local MinImg = Instance.new("ImageLabel")
    MinImg.Image = "rbxassetid://9886659276"
    MinImg.AnchorPoint = Vector2.new(0.5, 0.5)
    MinImg.BackgroundTransparency = 1
    MinImg.ImageTransparency = 0.25
    MinImg.Position = UDim2.new(0.5, 0, 0.5, 0)
    MinImg.Size = UDim2.new(0, 18, 0, 18)
    MinImg.Parent = Min

    -- hover effects (PC only)
    if not isMobile then
        Close.MouseEnter:Connect(function() TweenService:Create(CloseImg, TweenInfo.new(0.15), {ImageColor3=Color3.fromRGB(255,70,70)}):Play() end)
        Close.MouseLeave:Connect(function() TweenService:Create(CloseImg, TweenInfo.new(0.15), {ImageColor3=Color3.fromRGB(255,255,255)}):Play() end)
        Min.MouseEnter:Connect(function() TweenService:Create(MinImg, TweenInfo.new(0.15), {ImageTransparency=0}):Play() end)
        Min.MouseLeave:Connect(function() TweenService:Create(MinImg, TweenInfo.new(0.15), {ImageTransparency=0.25}):Play() end)
    end

    -- thin divider under top bar
    local Divider = Instance.new("Frame")
    Divider.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
    Divider.BorderSizePixel  = 0
    Divider.Size             = UDim2.new(1, 0, 0, 1)
    Divider.Position         = UDim2.new(0, 0, 0, TOP_H)
    Divider.Parent           = Main

    -- ── Content holder (fills below top bar) ─
    -- FIX: Using a UIListLayout horizontal inside ContentHolder so
    -- LayersTab and Layers are placed side-by-side with NO overlap.
    ContentHolder.BackgroundTransparency = 1
    ContentHolder.Position = UDim2.new(0, 0, 0, TOP_H + 1)
    ContentHolder.Size     = UDim2.new(1, 0, 1, -(TOP_H + 1))
    ContentHolder.Name     = "ContentHolder"
    ContentHolder.ClipsDescendants = true
    ContentHolder.Parent   = Main

    local CHLayout = Instance.new("UIListLayout")
    CHLayout.FillDirection = Enum.FillDirection.Horizontal
    CHLayout.SortOrder     = Enum.SortOrder.LayoutOrder
    CHLayout.Padding       = UDim.new(0, 0)
    CHLayout.Parent        = ContentHolder

    -- Tab sidebar (LEFT column)
    LayersTab.BackgroundColor3  = Color3.fromRGB(25, 25, 25)
    LayersTab.BorderSizePixel   = 0
    LayersTab.LayoutOrder       = 0
    LayersTab.Size              = UDim2.new(0, TAB_W + 10, 1, 0)   -- +10 = left margin inside
    LayersTab.Name              = "LayersTab"
    LayersTab.Parent            = ContentHolder

    local TabStroke = Instance.new("UIStroke", LayersTab)
    TabStroke.Color     = Color3.fromRGB(40, 40, 40)
    TabStroke.Thickness = 1

    local UICorner2 = Instance.new("UICorner")
    UICorner2.CornerRadius = UDim.new(0, 6)
    UICorner2.Parent       = LayersTab

    -- Content area (RIGHT column) — exact remaining width, no overlap possible
    Layers.BackgroundTransparency = 1
    Layers.LayoutOrder            = 1
    Layers.Size                   = UDim2.new(1, -(TAB_W + 10), 1, 0)
    Layers.Name                   = "Layers"
    Layers.ClipsDescendants       = true
    Layers.Parent                 = ContentHolder

    local LayersPad = Instance.new("UIPadding", Layers)
    LayersPad.PaddingLeft   = UDim.new(0, 8)
    LayersPad.PaddingRight  = UDim.new(0, 6)
    LayersPad.PaddingTop    = UDim.new(0, 4)

    NameTab.Font             = Enum.Font.GothamBold
    NameTab.Text             = ""
    NameTab.TextColor3       = GuiConfig.Color
    NameTab.TextSize         = isMobile and 14 or 16
    NameTab.TextXAlignment   = Enum.TextXAlignment.Left
    NameTab.BackgroundTransparency = 1
    NameTab.Size             = UDim2.new(1, 0, 0, 26)
    NameTab.Name             = "NameTab"
    NameTab.Parent           = Layers

    LayersReal.AnchorPoint          = Vector2.new(0, 1)
    LayersReal.BackgroundTransparency = 1
    LayersReal.ClipsDescendants     = true
    LayersReal.Position             = UDim2.new(0, 0, 1, 0)
    LayersReal.Size                 = UDim2.new(1, 0, 1, -30)
    LayersReal.Name                 = "LayersReal"
    LayersReal.Parent               = Layers

    LayersFolder.Name   = "LayersFolder"
    LayersFolder.Parent = LayersReal

    LayersPageLayout.SortOrder       = Enum.SortOrder.LayoutOrder
    LayersPageLayout.Name            = "LayersPageLayout"
    LayersPageLayout.TweenTime       = 0.25
    LayersPageLayout.EasingDirection = Enum.EasingDirection.Out
    LayersPageLayout.EasingStyle     = Enum.EasingStyle.Quint
    LayersPageLayout.Parent          = LayersFolder

    -- Tab scrolling frame
    local ScrollTab    = Instance.new("ScrollingFrame")
    local UIListLayout = Instance.new("UIListLayout")
    ScrollTab.CanvasSize                 = UDim2.new(0, 0, 0, 0)
    ScrollTab.ScrollBarImageColor3       = GuiConfig.Color
    ScrollTab.ScrollBarThickness         = 2
    ScrollTab.ScrollBarImageTransparency = 0.6
    ScrollTab.Active                     = true
    ScrollTab.BackgroundTransparency     = 1
    ScrollTab.Size                       = UDim2.new(1, 0, 1, 0)
    ScrollTab.Name                       = "ScrollTab"
    ScrollTab.Parent                     = LayersTab
    UIListLayout.Padding             = UDim.new(0, 8)
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout.SortOrder           = Enum.SortOrder.LayoutOrder
    UIListLayout.Parent              = ScrollTab
    local function updateTabCanvas()
        ScrollTab.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 16)
    end
    UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateTabCanvas)

    -- ── Minimize ─────────────────────────────
    local IsMinimized = false
    local function ToggleWindow()
        if not IsMinimized then
            IsMinimized = true
            TweenService:Create(DropShadowHolder,
                TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.In),
                { Size = UDim2.new(0, CurrentWindowSize.X.Offset, 0, 0) }):Play()
            task.wait(0.26)
            DropShadowHolder.Visible = false
        else
            IsMinimized = false
            DropShadowHolder.Size    = UDim2.new(0, CurrentWindowSize.X.Offset, 0, 0)
            DropShadowHolder.Visible = true
            TweenService:Create(DropShadowHolder,
                TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
                { Size = CurrentWindowSize }):Play()
        end
    end

    Min.Activated:Connect(ToggleWindow)

    if not isMobile then
        UserInputService.InputBegan:Connect(function(inp, gpe)
            if gpe then return end
            if inp.KeyCode == Enum.KeyCode.X then ToggleWindow() end
        end)
    end

    -- ── Floating toggle button ────────────────
    function GuiFunc:ToggleUI()
        local sg = Instance.new("ScreenGui")
        sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        sg.Name   = "ToggleUIButton"
        sg.Parent = CoreGui

        local btnSz = isMobile and 50 or 42
        local mb = Instance.new("ImageLabel")
        mb.Size  = UDim2.new(0, btnSz, 0, btnSz)
        mb.Position = UDim2.new(0, 16, 0, 90)
        mb.BackgroundTransparency = 1
        mb.Image = "rbxassetid://" .. (GuiConfig.Image or "137601480983962")
        mb.ScaleType = Enum.ScaleType.Fit
        mb.Parent = sg

        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 1, 0)
        btn.BackgroundTransparency = 1
        btn.Text = ""; btn.Parent = mb

        btn.MouseButton1Click:Connect(function() ToggleWindow() end)

        local drag, dragInput, dragStart, startPos, conn
        btn.InputBegan:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                drag = true; dragStart = inp.Position; startPos = mb.Position
                inp.Changed:Connect(function()
                    if inp.UserInputState == Enum.UserInputState.End then drag = false end
                end)
            end
        end)
        btn.InputChanged:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
                dragInput = inp
            end
        end)
        conn = UserInputService.InputChanged:Connect(function(inp)
            if drag and inp == dragInput then
                local d = inp.Position - dragStart
                mb.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset+d.X, startPos.Y.Scale, startPos.Y.Offset+d.Y)
            end
        end)
        mb.Destroying:Connect(function() if conn then conn:Disconnect() end end)
    end
    GuiFunc:ToggleUI()

    MakeDraggable(Top, DropShadowHolder)
    MakeResizable(DropShadowHolder, 420, 300)

    -- ── Close dialog ─────────────────────────
    Close.Activated:Connect(function()
        CircleClick(Close, Mouse.X, Mouse.Y)
        local overlay = Instance.new("Frame")
        overlay.Size = UDim2.new(1, 0, 1, 0)
        overlay.BackgroundColor3 = Color3.fromRGB(0,0,0)
        overlay.BackgroundTransparency = 1
        overlay.ZIndex = 50; overlay.Parent = DropShadowHolder

        local dialog = Instance.new("Frame")
        dialog.BackgroundColor3 = Color3.fromRGB(22,22,22)
        dialog.Size     = UDim2.new(0, 0, 0, 0)
        dialog.Position = UDim2.new(0.5, 0, 0.5, 0)
        dialog.AnchorPoint = Vector2.new(0.5, 0.5)
        dialog.ZIndex   = 51; dialog.Parent = overlay
        Instance.new("UICorner", dialog).CornerRadius = UDim.new(0, 8)
        local ds = Instance.new("UIStroke", dialog)
        ds.Color = GuiConfig.Color; ds.Thickness = 1.4

        local function dlgLabel(txt, bold, sz, col, pos, size, zi)
            local l = Instance.new("TextLabel")
            l.BackgroundTransparency = 1
            l.Font     = bold and Enum.Font.GothamBold or Enum.Font.Gotham
            l.Text     = txt; l.TextSize = sz; l.TextColor3 = col
            l.Position = pos; l.Size = size; l.ZIndex = zi
            l.TextWrapped = true; l.Parent = dialog
        end
        dlgLabel("Close Hub?", true, 17, Color3.fromRGB(255,255,255), UDim2.new(0,0,0,0), UDim2.new(1,0,0,44), 52)
        dlgLabel("You won't be able to open it again without re-executing.", false, 12, Color3.fromRGB(160,160,160),
            UDim2.new(0,12,0,42), UDim2.new(1,-24,0,50), 52)

        local function dlgBtn(txt, bgcol, xpos)
            local b = Instance.new("TextButton")
            b.Size = UDim2.new(0.44, 0, 0, 36)
            b.Position = UDim2.new(xpos, 0, 1, -46)
            b.BackgroundColor3 = bgcol; b.Text = txt
            b.Font = Enum.Font.GothamBold; b.TextSize = 13
            b.TextColor3 = Color3.fromRGB(255,255,255)
            b.ZIndex = 52; b.Parent = dialog
            Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
            return b
        end
        local yes    = dlgBtn("Yes",    GuiConfig.Color,        0.05)
        local cancel = dlgBtn("Cancel", Color3.fromRGB(45,45,45), 0.51)

        TweenService:Create(overlay, TweenInfo.new(0.2), {BackgroundTransparency=0.5}):Play()
        TweenService:Create(dialog, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
            { Size=UDim2.new(0,290,0,145), Position=UDim2.new(0.5,0,0.5,0) }):Play()

        yes.MouseButton1Click:Connect(function()
            TweenService:Create(DropShadowHolder, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.In),
                {Size=UDim2.new(0,0,0,0)}):Play()
            task.wait(0.35)
            ScreenGui:Destroy()
            if CoreGui:FindFirstChild("ToggleUIButton") then CoreGui.ToggleUIButton:Destroy() end
        end)
        cancel.MouseButton1Click:Connect(function()
            TweenService:Create(dialog, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In),
                {Size=UDim2.new(0,0,0,0), Position=UDim2.new(0.5,0,0.5,0)}):Play()
            TweenService:Create(overlay, TweenInfo.new(0.2), {BackgroundTransparency=1}):Play()
            task.wait(0.25); overlay:Destroy()
        end)
    end)

    -- ── Dropdown side panel ───────────────────
    local MoreBlur      = Instance.new("Frame")
    local ConnectButton = Instance.new("TextButton")
    MoreBlur.AnchorPoint          = Vector2.new(1, 1)
    MoreBlur.BackgroundColor3     = Color3.fromRGB(0, 0, 0)   -- FIX: preto em vez de branco padrão
    MoreBlur.BackgroundTransparency = 1
    MoreBlur.Size                 = UDim2.new(1, 0, 1, 0)
    MoreBlur.Position             = UDim2.new(1, 0, 1, 0)
    MoreBlur.Visible              = false
    MoreBlur.Name                 = "MoreBlur"
    MoreBlur.ZIndex               = 15
    MoreBlur.Parent               = Layers
    -- FIX: UICorner no overlay escuro
    Instance.new("UICorner", MoreBlur).CornerRadius = UDim.new(0, 8)

    ConnectButton.BackgroundTransparency = 1
    ConnectButton.Size  = UDim2.new(1, 0, 1, 0)
    ConnectButton.Text  = ""; ConnectButton.Parent = MoreBlur

    local panelW = isMobile and 180 or 200
    local DropdownSelect = Instance.new("Frame")
    DropdownSelect.AnchorPoint      = Vector2.new(1, 0.5)
    DropdownSelect.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    DropdownSelect.Position         = UDim2.new(1, panelW + 20, 0.5, 0)
    DropdownSelect.Size             = UDim2.new(0, panelW, 1, -16)
    DropdownSelect.ZIndex           = 20
    DropdownSelect.Parent           = MoreBlur
    Instance.new("UICorner", DropdownSelect).CornerRadius = UDim.new(0, 8)

    local DropStroke = Instance.new("UIStroke", DropdownSelect)
    DropStroke.Thickness = 1.8; DropStroke.Color = Color3.fromRGB(255,255,255)
    MakeAnimatedGradient(DropStroke, DropdownSelect)

    local DropdownFolder = Instance.new("Frame")
    DropdownFolder.BackgroundTransparency = 1
    DropdownFolder.Size = UDim2.new(1,0,1,0)
    DropdownFolder.ClipsDescendants = true
    DropdownFolder.Parent = DropdownSelect

    local DropPageLayout = Instance.new("UIPageLayout", DropdownFolder)
    DropPageLayout.EasingDirection = Enum.EasingDirection.Out
    DropPageLayout.EasingStyle     = Enum.EasingStyle.Quint
    DropPageLayout.TweenTime       = 0.18
    DropPageLayout.SortOrder       = Enum.SortOrder.LayoutOrder

    ConnectButton.Activated:Connect(function()
        if MoreBlur.Visible then
            TweenService:Create(DropdownSelect, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.In),
                { Position = UDim2.new(1, panelW + 20, 0.5, 0) }):Play()
            task.wait(0.22); MoreBlur.Visible = false
        end
    end)

    -- ══════════════════════════════════════════
    --  Tabs
    -- ══════════════════════════════════════════
    local Tabs     = {}
    local CountTab = 0

    function Tabs:AddTab(TabConfig)
        TabConfig = TabConfig or {}
        TabConfig.Name = TabConfig.Name or "Tab"
        TabConfig.Icon = TabConfig.Icon or ""

        local ScrolLayers   = Instance.new("ScrollingFrame")
        local UIListLayout1 = Instance.new("UIListLayout")
        ScrolLayers.ScrollBarImageColor3       = GuiConfig.Color
        ScrolLayers.ScrollBarThickness         = 2
        ScrolLayers.ScrollBarImageTransparency = 0.5
        ScrolLayers.BackgroundTransparency     = 1
        ScrolLayers.Size                       = UDim2.new(1, 0, 1, 0)
        ScrolLayers.LayoutOrder                = CountTab
        ScrolLayers.Name                       = "ScrolLayers"
        ScrolLayers.Parent                     = LayersFolder
        UIListLayout1.Padding   = UDim.new(0, 8)
        UIListLayout1.SortOrder = Enum.SortOrder.LayoutOrder
        UIListLayout1.Parent    = ScrolLayers
        UIListLayout1:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            ScrolLayers.CanvasSize = UDim2.new(0, 0, 0, UIListLayout1.AbsoluteContentSize.Y + 16)
        end)

        local TAB_BTN_H = isMobile and 48 or 42
        local Tab       = Instance.new("Frame")
        local TabButton = Instance.new("TextButton")
        local FeatureImg = Instance.new("ImageLabel")
        local ChooseBar  = Instance.new("Frame")   -- left accent bar

        Tab.BackgroundColor3     = Color3.fromRGB(40, 40, 40)
        Tab.BackgroundTransparency = (CountTab == 0) and 0.5 or 1
        Tab.LayoutOrder          = CountTab
        Tab.Size                 = UDim2.new(1, -8, 0, TAB_BTN_H)
        Tab.Parent               = ScrollTab
        Instance.new("UICorner", Tab).CornerRadius = UDim.new(0, 6)

        TabButton.BackgroundTransparency = 1
        TabButton.Size = UDim2.new(1, 0, 1, 0); TabButton.Text = ""
        TabButton.Parent = Tab

        FeatureImg.BackgroundTransparency = 1
        FeatureImg.AnchorPoint = Vector2.new(0.5, 0.5)
        FeatureImg.Position    = UDim2.new(0.5, 0, 0.5, 0)
        FeatureImg.Size        = UDim2.new(0, 22, 0, 22)
        FeatureImg.Image       = Icons[TabConfig.Icon] or TabConfig.Icon or ""
        FeatureImg.Parent      = Tab

        ChooseBar.BackgroundColor3     = GuiConfig.Color
        ChooseBar.Position             = UDim2.new(0, 0, 0.5, -10)
        ChooseBar.Size                 = UDim2.new(0, 3, 0, 20)
        ChooseBar.BackgroundTransparency = (CountTab == 0) and 0 or 1
        ChooseBar.Parent               = Tab
        Instance.new("UICorner", ChooseBar).CornerRadius = UDim.new(0, 2)

        if CountTab == 0 then
            LayersPageLayout:JumpToIndex(0)
            NameTab.Text = TabConfig.Name
        end

        TabButton.Activated:Connect(function()
            if Tab.LayoutOrder ~= LayersPageLayout.CurrentPage.LayoutOrder then
                for _, tf in pairs(ScrollTab:GetChildren()) do
                    if tf:IsA("Frame") then
                        TweenService:Create(tf, TweenInfo.new(0.2, Enum.EasingStyle.Quint), {BackgroundTransparency=1}):Play()
                        local bar = tf:FindFirstChild("Frame")
                        if bar then TweenService:Create(bar, TweenInfo.new(0.2, Enum.EasingStyle.Quint), {BackgroundTransparency=1}):Play() end
                    end
                end
                TweenService:Create(Tab,       TweenInfo.new(0.28, Enum.EasingStyle.Quint), {BackgroundTransparency=0.5}):Play()
                TweenService:Create(ChooseBar, TweenInfo.new(0.28, Enum.EasingStyle.Quint), {BackgroundTransparency=0}):Play()
                TweenService:Create(FeatureImg, TweenInfo.new(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
                    {Size=UDim2.new(0,26,0,26)}):Play()
                task.delay(0.1, function()
                    TweenService:Create(FeatureImg, TweenInfo.new(0.1), {Size=UDim2.new(0,22,0,22)}):Play()
                end)
                LayersPageLayout:JumpToIndex(Tab.LayoutOrder)
                NameTab.Text = TabConfig.Name
            end
        end)

        -- ── Card ─────────────────────────────
        local function CreateCard()
            local c = Instance.new("Frame")
            c.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            c.BorderSizePixel  = 0
            c.Size             = UDim2.new(1, -2, 0, 0)
            c.Parent           = ScrolLayers
            c.LayoutOrder      = 1
            Instance.new("UICorner", c).CornerRadius = UDim.new(0, 6)
            local st = Instance.new("UIStroke", c)
            st.Color = Color3.fromRGB(45, 45, 45); st.Thickness = 1
            return c, st
        end

        local TabItems            = {}
        local dropdownPageCounter = 0

        -- ── TextSeparator ─────────────────────
        function TabItems:AddTextSeparator(title)
            title = title or "SECTION"
            local sep = Instance.new("Frame")
            sep.BackgroundTransparency = 1
            sep.Size   = UDim2.new(1, 0, 0, 22)
            sep.Parent = ScrolLayers
            local lbl = Instance.new("TextLabel")
            lbl.BackgroundTransparency = 1
            lbl.Size     = UDim2.new(1, -6, 1, 0)
            lbl.Position = UDim2.new(0, 3, 0, 0)
            lbl.Font     = Enum.Font.GothamBold
            lbl.Text     = string.upper(title)
            lbl.TextColor3 = GuiConfig.Color
            lbl.TextSize = isMobile and 11 or 12
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Parent   = sep
            return sep
        end

        -- ── Toggle ───────────────────────────
        function TabItems:AddToggle(cfg2)
            cfg2 = cfg2 or {}
            cfg2.Title    = cfg2.Title    or "Toggle"
            cfg2.Default  = cfg2.Default  or false
            cfg2.Callback = cfg2.Callback or function() end
            local key = "Toggle_" .. cfg2.Title
            if ConfigData[key] ~= nil then cfg2.Default = ConfigData[key] end

            local tf = { Value = cfg2.Default }
            local H  = isMobile and 52 or 46
            local card, cardStroke = CreateCard()
            card.Size = UDim2.new(1, -2, 0, H)

            local ttl = Instance.new("TextLabel")
            ttl.Font = Enum.Font.GothamBold; ttl.Text = cfg2.Title
            ttl.TextColor3 = Color3.fromRGB(230, 230, 230)
            ttl.TextSize   = isMobile and 14 or 13
            ttl.TextXAlignment = Enum.TextXAlignment.Left
            ttl.BackgroundTransparency = 1
            ttl.Position = UDim2.new(0, 14, 0.5, -8)
            ttl.Size     = UDim2.new(1, -74, 0, 16)
            ttl.Parent   = card

            local tbtn = Instance.new("TextButton")
            tbtn.BackgroundTransparency = 1
            tbtn.Size = UDim2.new(1, 0, 1, 0); tbtn.Text = ""
            tbtn.Parent = card

            -- Track pill
            local track = Instance.new("Frame")
            track.AnchorPoint      = Vector2.new(1, 0.5)
            track.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            track.Position         = UDim2.new(1, -14, 0.5, 0)
            track.Size             = UDim2.new(0, 38, 0, 20)
            track.Parent           = card
            Instance.new("UICorner", track).CornerRadius = UDim.new(0, 10)

            -- Thumb (INSIDE TRACK, positioned absolutely – no tween on parent needed)
            local thumb = Instance.new("Frame")
            thumb.AnchorPoint      = Vector2.new(0, 0.5)
            thumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            thumb.Position         = UDim2.new(0, 2, 0.5, 0)
            thumb.Size             = UDim2.new(0, 16, 0, 16)
            thumb.Parent           = track
            Instance.new("UICorner", thumb).CornerRadius = UDim.new(1, 0)

            tbtn.Activated:Connect(function()
                tf.Value = not tf.Value; tf:Set(tf.Value)
            end)

            -- hover (PC)
            if not isMobile then
                tbtn.MouseEnter:Connect(function()
                    TweenService:Create(cardStroke, TweenInfo.new(0.15), {Color=Color3.fromRGB(65,65,65)}):Play()
                end)
                tbtn.MouseLeave:Connect(function()
                    if not tf.Value then
                        TweenService:Create(cardStroke, TweenInfo.new(0.15), {Color=Color3.fromRGB(45,45,45)}):Play()
                    end
                end)
            end

            function tf:Set(val, skip)
                local ti = TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
                if val then
                    TweenService:Create(ttl,       ti, {TextColor3 = GuiConfig.Color}):Play()
                    TweenService:Create(thumb,     ti, {Position = UDim2.new(1, -18, 0.5, 0)}):Play()
                    TweenService:Create(track,     ti, {BackgroundColor3 = GuiConfig.Color}):Play()
                    TweenService:Create(cardStroke,ti, {Color = GuiConfig.Color}):Play()
                else
                    TweenService:Create(ttl,       ti, {TextColor3 = Color3.fromRGB(230,230,230)}):Play()
                    TweenService:Create(thumb,     ti, {Position = UDim2.new(0, 2, 0.5, 0)}):Play()
                    TweenService:Create(track,     ti, {BackgroundColor3 = Color3.fromRGB(40,40,40)}):Play()
                    TweenService:Create(cardStroke,ti, {Color = Color3.fromRGB(45,45,45)}):Play()
                end
                if not skip then
                    pcall(function() cfg2.Callback(val) end)
                    ConfigData[key] = val; SaveConfig()
                end
            end
            tf:Set(tf.Value, true)
            Elements[key] = tf
            return tf
        end

        -- ── Slider ───────────────────────────
        function TabItems:AddSlider(cfg2)
            cfg2 = cfg2 or {}
            cfg2.Title     = cfg2.Title     or "Slider"
            cfg2.Min       = cfg2.Min       or 0
            cfg2.Max       = cfg2.Max       or 100
            cfg2.Default   = cfg2.Default   or 50
            cfg2.Increment = cfg2.Increment or 1
            cfg2.Callback  = cfg2.Callback  or function() end
            local key = "Slider_" .. cfg2.Title
            if ConfigData[key] ~= nil then cfg2.Default = ConfigData[key] end

            local sf = { Value = cfg2.Default }
            local H  = isMobile and 62 or 56
            local card, cardStroke = CreateCard()
            card.Size = UDim2.new(1, -2, 0, H)

            local stitle = Instance.new("TextLabel")
            stitle.Font = Enum.Font.GothamBold; stitle.Text = cfg2.Title
            stitle.TextColor3 = Color3.fromRGB(230,230,230)
            stitle.TextSize   = isMobile and 14 or 13
            stitle.TextXAlignment = Enum.TextXAlignment.Left
            stitle.BackgroundTransparency = 1
            stitle.Position = UDim2.new(0, 14, 0, isMobile and 12 or 10)
            stitle.Size     = UDim2.new(1, -80, 0, 16)
            stitle.Parent   = card

            local vbox = Instance.new("TextBox")
            vbox.Font     = Enum.Font.GothamBold
            vbox.Text     = tostring(cfg2.Default)
            vbox.TextColor3 = GuiConfig.Color
            vbox.TextSize = isMobile and 14 or 13
            vbox.TextXAlignment = Enum.TextXAlignment.Right
            vbox.BackgroundTransparency = 1
            vbox.AnchorPoint = Vector2.new(1, 0)
            vbox.Position = UDim2.new(1, -14, 0, isMobile and 12 or 10)
            vbox.Size     = UDim2.new(0, 52, 0, 16)
            vbox.Parent   = card

            -- Track bar — sits 16px from bottom
            local track = Instance.new("Frame")
            track.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            track.AnchorPoint      = Vector2.new(0, 1)
            track.Position         = UDim2.new(0, 14, 1, -14)
            track.Size             = UDim2.new(1, -28, 0, 5)
            track.Parent           = card
            Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

            local fill = Instance.new("Frame")
            fill.BackgroundColor3 = GuiConfig.Color
            fill.Size             = UDim2.new(0, 0, 1, 0)   -- starts at 0, set by Set()
            fill.Parent           = track
            Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

            -- FIX: Thumb is a SIBLING of fill inside TRACK (not child of fill!)
            -- Position is updated manually to follow pct × track width.
            local thumb = Instance.new("Frame")
            thumb.AnchorPoint      = Vector2.new(0.5, 0.5)
            thumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            thumb.Size             = UDim2.new(0, 12, 0, 12)
            thumb.Position         = UDim2.new(0, 0, 0.5, 0)  -- updated in Set()
            thumb.ZIndex           = 3
            thumb.Parent           = track
            Instance.new("UICorner", thumb).CornerRadius = UDim.new(1, 0)

            local Dragging = false
            local function Round(n, f) return math.floor(n/f + 0.5) * f end

            function sf:Set(val)
                val = math.clamp(Round(val, cfg2.Increment), cfg2.Min, cfg2.Max)
                sf.Value = val
                vbox.Text = tostring(val)
                local pct = (val - cfg2.Min) / math.max(cfg2.Max - cfg2.Min, 1)
                -- No tween on fill — instant when dragging, smooth on external Set
                local fillTi = Dragging and TweenInfo.new(0) or TweenInfo.new(0.06)
                TweenService:Create(fill,  fillTi, {Size = UDim2.new(pct, 0, 1, 0)}):Play()
                -- FIX: Thumb uses Scale X = pct within the track, so it always stays at the end of the fill
                TweenService:Create(thumb, fillTi, {Position = UDim2.new(pct, 0, 0.5, 0)}):Play()
                pcall(function() cfg2.Callback(val) end)
                ConfigData[key] = val; SaveConfig()
            end

            local function UpdateSlide(inp)
                local rel = math.clamp((inp.Position.X - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1), 0, 1)
                sf:Set(cfg2.Min + (cfg2.Max - cfg2.Min) * rel)
            end

            track.InputBegan:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                    Dragging = true
                    TweenService:Create(thumb, TweenInfo.new(0.1), {Size=UDim2.new(0,15,0,15)}):Play()
                    UpdateSlide(inp)
                end
            end)
            track.InputEnded:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                    Dragging = false
                    TweenService:Create(thumb, TweenInfo.new(0.1), {Size=UDim2.new(0,12,0,12)}):Play()
                end
            end)
            local slConn = UserInputService.InputChanged:Connect(function(inp)
                if Dragging and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
                    UpdateSlide(inp)
                end
            end)
            card.AncestryChanged:Connect(function()
                if not card.Parent then slConn:Disconnect() end
            end)

            vbox.FocusLost:Connect(function()
                sf:Set(tonumber(vbox.Text) or cfg2.Min)
            end)

            sf:Set(cfg2.Default)
            Elements[key] = sf
            return sf
        end

        -- ── Button ───────────────────────────
        function TabItems:AddButton(cfg2)
            local H = isMobile and 52 or 46
            local card, _ = CreateCard()
            card.Size = UDim2.new(1, -2, 0, H)

            local btn = Instance.new("TextButton")
            btn.Font             = Enum.Font.GothamBold
            btn.Text             = cfg2.Title or "Button"
            btn.TextSize         = isMobile and 14 or 13
            btn.TextColor3       = Color3.fromRGB(255, 255, 255)
            btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            btn.Size             = UDim2.new(1, -24, 1, -14)
            btn.Position         = UDim2.new(0, 12, 0, 7)
            btn.Parent           = card
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

            btn.MouseButton1Click:Connect(function()
                CircleClick(btn, Mouse.X, Mouse.Y)
                if cfg2.Callback then pcall(cfg2.Callback) end
            end)
            if not isMobile then
                btn.MouseEnter:Connect(function() TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3=GuiConfig.Color}):Play() end)
                btn.MouseLeave:Connect(function() TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3=Color3.fromRGB(40,40,40)}):Play() end)
            end
            return card
        end

        -- ── Dropdown ─────────────────────────
        function TabItems:AddDropdown(cfg2)
            cfg2 = cfg2 or {}
            cfg2.Title    = cfg2.Title    or "Dropdown"
            cfg2.Content  = cfg2.Content  or ""
            cfg2.Multi    = cfg2.Multi    or false
            cfg2.Options  = cfg2.Options  or {}
            cfg2.Default  = cfg2.Default  or (cfg2.Multi and {} or nil)
            cfg2.Callback = cfg2.Callback or function() end
            local key = "Dropdown_" .. cfg2.Title
            if ConfigData[key] ~= nil then cfg2.Default = ConfigData[key] end

            local df = { Value = cfg2.Default, Options = cfg2.Options }

            local H = isMobile and 52 or 46
            local Dropdown      = Instance.new("Frame")
            local DropdownButton = Instance.new("TextButton")
            local DropdownTitle = Instance.new("TextLabel")
            local DropdownContent = Instance.new("TextLabel")
            local SelectFrame   = Instance.new("Frame")
            local OptionSelecting = Instance.new("TextLabel")
            local OptionImg     = Instance.new("ImageLabel")

            Dropdown.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            Dropdown.BorderSizePixel  = 0
            Dropdown.Size             = UDim2.new(1, -2, 0, H)
            Dropdown.Name             = "Dropdown"
            Dropdown.Parent           = ScrolLayers
            Instance.new("UICorner", Dropdown).CornerRadius = UDim.new(0, 6)

            -- Direct reference to stroke (no FindFirstChild needed)
            local DropCardStroke = Instance.new("UIStroke", Dropdown)
            DropCardStroke.Color = Color3.fromRGB(45,45,45); DropCardStroke.Thickness = 1

            DropdownButton.BackgroundTransparency = 1
            DropdownButton.Size = UDim2.new(1, 0, 1, 0); DropdownButton.Text = ""
            DropdownButton.Name = "ToggleButton"; DropdownButton.Parent = Dropdown

            DropdownTitle.Font = Enum.Font.GothamBold; DropdownTitle.Text = cfg2.Title
            DropdownTitle.TextColor3 = Color3.fromRGB(230,230,230)
            DropdownTitle.TextSize = isMobile and 14 or 13
            DropdownTitle.TextXAlignment = Enum.TextXAlignment.Left
            DropdownTitle.BackgroundTransparency = 1
            DropdownTitle.Position = UDim2.new(0, 14, 0, isMobile and 12 or 10)
            DropdownTitle.Size     = UDim2.new(1, -170, 0, 13)
            DropdownTitle.Name     = "DropdownTitle"; DropdownTitle.Parent = Dropdown

            DropdownContent.Font = Enum.Font.Gotham; DropdownContent.Text = cfg2.Content
            DropdownContent.TextColor3 = Color3.fromRGB(160,160,160)
            DropdownContent.TextSize = isMobile and 12 or 11
            DropdownContent.TextXAlignment = Enum.TextXAlignment.Left
            DropdownContent.BackgroundTransparency = 1
            DropdownContent.TextWrapped = true
            DropdownContent.Position = UDim2.new(0, 14, 0, (isMobile and 12 or 10) + 14)
            DropdownContent.Size     = UDim2.new(1, -170, 0, 12)
            DropdownContent.Name     = "DropdownContent"; DropdownContent.Parent = Dropdown

            SelectFrame.AnchorPoint      = Vector2.new(1, 0.5)
            SelectFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            SelectFrame.Position         = UDim2.new(1, -8, 0.5, 0)
            SelectFrame.Size             = UDim2.new(0, 142, 0, 28)
            SelectFrame.Name             = "SelectOptionsFrame"; SelectFrame.Parent = Dropdown
            Instance.new("UICorner", SelectFrame).CornerRadius = UDim.new(0, 6)

            -- Animated gradient on the selector pill
            local SelStroke = Instance.new("UIStroke", SelectFrame)
            SelStroke.Thickness = 1.4; SelStroke.Color = Color3.fromRGB(255,255,255)
            MakeAnimatedGradient(SelStroke, Dropdown)

            OptionSelecting.Font = Enum.Font.GothamBold
            OptionSelecting.Text = cfg2.Multi and "Select Options" or "Select Option"
            OptionSelecting.TextColor3 = Color3.fromRGB(255,255,255)
            OptionSelecting.TextSize   = 11
            OptionSelecting.TextTransparency = 0.4
            OptionSelecting.TextXAlignment = Enum.TextXAlignment.Left
            OptionSelecting.AnchorPoint    = Vector2.new(0, 0.5)
            OptionSelecting.BackgroundTransparency = 1
            OptionSelecting.Position = UDim2.new(0, 6, 0.5, 0)
            OptionSelecting.Size     = UDim2.new(1, -28, 1, -6)
            OptionSelecting.Name     = "OptionSelecting"; OptionSelecting.Parent = SelectFrame

            OptionImg.Image  = "rbxassetid://16851841101"
            OptionImg.ImageColor3 = Color3.fromRGB(200,200,200)
            OptionImg.AnchorPoint = Vector2.new(1, 0.5)
            OptionImg.BackgroundTransparency = 1
            OptionImg.Position = UDim2.new(1, -2, 0.5, 0)
            OptionImg.Size     = UDim2.new(0, 18, 0, 18)
            OptionImg.Name     = "OptionImg"; OptionImg.Parent = SelectFrame

            -- Container inside panel
            local Container = Instance.new("Frame")
            Container.Size = UDim2.new(1,0,1,0)
            Container.BackgroundTransparency = 1
            Container.LayoutOrder = dropdownPageCounter
            Container.Parent = DropdownFolder

            -- Connect open button AFTER container exists
            DropdownButton.Activated:Connect(function()
                if not MoreBlur.Visible then
                    MoreBlur.Visible = true
                    DropPageLayout:JumpTo(Container)
                    TweenService:Create(MoreBlur, TweenInfo.new(0.2), {BackgroundTransparency=0.35}):Play()
                    TweenService:Create(DropdownSelect,
                        TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
                        {Position = UDim2.new(1, -8, 0.5, 0)}):Play()
                    TweenService:Create(DropCardStroke, TweenInfo.new(0.2), {Color=GuiConfig.Color}):Play()
                end
            end)

            -- Search box
            local SearchBox = Instance.new("TextBox")
            SearchBox.PlaceholderText = "Search…"
            SearchBox.Font = Enum.Font.Gotham; SearchBox.Text = ""
            SearchBox.TextSize = 12; SearchBox.TextColor3 = Color3.fromRGB(240,240,240)
            SearchBox.BackgroundColor3 = Color3.fromRGB(35,35,35)
            SearchBox.BackgroundTransparency = 0; SearchBox.BorderSizePixel = 0
            SearchBox.Size     = UDim2.new(1, -12, 0, 28)
            SearchBox.Position = UDim2.new(0, 6, 0, 5)
            SearchBox.ClearTextOnFocus = false; SearchBox.Name = "SearchBox"
            SearchBox.Parent = Container
            Instance.new("UICorner", SearchBox).CornerRadius = UDim.new(0, 5)

            local ScrollSelect = Instance.new("ScrollingFrame")
            ScrollSelect.Size     = UDim2.new(1, 0, 1, -38)
            ScrollSelect.Position = UDim2.new(0, 0, 0, 38)
            ScrollSelect.ScrollBarImageTransparency = 1
            ScrollSelect.BorderSizePixel = 0
            ScrollSelect.BackgroundTransparency = 1
            ScrollSelect.ScrollBarThickness = 0
            ScrollSelect.CanvasSize = UDim2.new(0,0,0,0)
            ScrollSelect.Name   = "ScrollSelect"; ScrollSelect.Parent = Container

            local UIList4 = Instance.new("UIListLayout")
            UIList4.Padding   = UDim.new(0, 2)
            UIList4.SortOrder = Enum.SortOrder.LayoutOrder
            UIList4.Parent    = ScrollSelect
            UIList4:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                ScrollSelect.CanvasSize = UDim2.new(0,0,0,UIList4.AbsoluteContentSize.Y)
            end)

            SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
                local q = string.lower(SearchBox.Text)
                for _, opt in pairs(ScrollSelect:GetChildren()) do
                    if opt.Name == "Option" and opt:FindFirstChild("OptionText") then
                        opt.Visible = q == "" or string.find(string.lower(opt.OptionText.Text), q, 1, true)
                    end
                end
            end)

            function df:Clear()
                for _, f in ScrollSelect:GetChildren() do
                    if f.Name == "Option" then f:Destroy() end
                end
                df.Value = cfg2.Multi and {} or nil; df.Options = {}
                OptionSelecting.Text = cfg2.Multi and "Select Options" or "Select Option"
                OptionSelecting.TextTransparency = 0.4
                OptionSelecting.TextColor3 = Color3.fromRGB(255,255,255)
                TweenService:Create(DropCardStroke, TweenInfo.new(0.2), {Color=Color3.fromRGB(45,45,45)}):Play()
            end

            function df:AddOption(opt)
                local label, val
                if type(opt) == "table" and opt.Label and opt.Value ~= nil then
                    label = tostring(opt.Label); val = opt.Value
                else
                    label = tostring(opt); val = opt
                end

                local Option      = Instance.new("Frame")
                local OptBtn      = Instance.new("TextButton")
                local OptText     = Instance.new("TextLabel")
                local AccentBar   = Instance.new("Frame")   -- left accent bar
                local AccentStroke = Instance.new("UIStroke")

                Option.BackgroundTransparency = 1
                Option.Size  = UDim2.new(1, 0, 0, isMobile and 34 or 30)
                Option.Name  = "Option"; Option.Parent = ScrollSelect
                Instance.new("UICorner", Option).CornerRadius = UDim.new(0, 4)

                OptBtn.BackgroundTransparency = 1
                OptBtn.Size = UDim2.new(1,0,1,0); OptBtn.Text = ""
                OptBtn.Name = "OptionButton"; OptBtn.Parent = Option

                OptText.Font = Enum.Font.GothamBold; OptText.Text = label
                OptText.TextSize   = isMobile and 13 or 12
                OptText.TextColor3 = Color3.fromRGB(220,220,220)
                OptText.Position   = UDim2.new(0, 10, 0, 0)
                OptText.Size       = UDim2.new(1, -14, 1, 0)
                OptText.BackgroundTransparency = 1
                OptText.TextXAlignment = Enum.TextXAlignment.Left
                OptText.Name       = "OptionText"; OptText.Parent = Option
                Option:SetAttribute("RealValue", val)

                AccentBar.AnchorPoint      = Vector2.new(0, 0.5)
                AccentBar.BackgroundColor3 = GuiConfig.Color
                AccentBar.Position         = UDim2.new(0, 2, 0.5, 0)
                AccentBar.Size             = UDim2.new(0, 0, 0, 0)
                AccentBar.Name             = "ChooseFrame"; AccentBar.Parent = Option
                Instance.new("UICorner", AccentBar).CornerRadius = UDim.new(1, 0)

                AccentStroke.Color = GuiConfig.Color; AccentStroke.Thickness = 1.4
                AccentStroke.Transparency = 0.999; AccentStroke.Parent = AccentBar

                if not isMobile then
                    OptBtn.MouseEnter:Connect(function()
                        if Option.BackgroundTransparency > 0.6 then
                            TweenService:Create(Option, TweenInfo.new(0.1), {BackgroundTransparency=0.82}):Play()
                        end
                    end)
                    OptBtn.MouseLeave:Connect(function()
                        local sel = cfg2.Multi and tableFind(df.Value, val) or df.Value == val
                        if not sel then TweenService:Create(Option, TweenInfo.new(0.1), {BackgroundTransparency=1}):Play() end
                    end)
                end

                OptBtn.Activated:Connect(function()
                    if cfg2.Multi then
                        if not tableFind(df.Value, val) then
                            table.insert(df.Value, val)
                        else
                            for i, v in ipairs(df.Value) do
                                if v == val then table.remove(df.Value, i); break end
                            end
                        end
                    else
                        df.Value = val
                    end
                    df:Set(df.Value)
                end)
            end

            function df:Set(val)
                if cfg2.Multi then
                    df.Value = type(val) == "table" and val or {}
                else
                    df.Value = (type(val) == "table" and val[1]) or val
                end
                ConfigData[key] = df.Value; SaveConfig()

                local texts = {}; local anySelected = false
                local ti2 = TweenInfo.new(0.16, Enum.EasingStyle.Quint)
                local ti1 = TweenInfo.new(0.08)

                for _, drop in ScrollSelect:GetChildren() do
                    if drop.Name == "Option" and drop:FindFirstChild("OptionText") then
                        local v  = drop:GetAttribute("RealValue")
                        local sel = cfg2.Multi and tableFind(df.Value, v) or df.Value == v
                        local bar = drop:FindFirstChild("ChooseFrame")
                        local bst = bar and bar:FindFirstChildWhichIsA("UIStroke")

                        if sel then
                            anySelected = true
                            if bar then TweenService:Create(bar, ti2, {Size=UDim2.new(0,2,0,14)}):Play() end
                            if bst then TweenService:Create(bst, ti2, {Transparency=0}):Play() end
                            TweenService:Create(drop, ti2, {BackgroundTransparency=0.86}):Play()
                            TweenService:Create(drop.OptionText, ti2, {TextColor3=GuiConfig.Color}):Play()
                            table.insert(texts, drop.OptionText.Text)
                        else
                            if bar then TweenService:Create(bar, ti1, {Size=UDim2.new(0,0,0,0)}):Play() end
                            if bst then TweenService:Create(bst, ti1, {Transparency=0.999}):Play() end
                            TweenService:Create(drop, ti1, {BackgroundTransparency=1}):Play()
                            TweenService:Create(drop.OptionText, ti1, {TextColor3=Color3.fromRGB(220,220,220)}):Play()
                        end
                    end
                end

                OptionSelecting.Text             = (#texts == 0) and (cfg2.Multi and "Select Options" or "Select Option") or table.concat(texts, ", ")
                OptionSelecting.TextTransparency = anySelected and 0 or 0.4
                OptionSelecting.TextColor3       = anySelected and GuiConfig.Color or Color3.fromRGB(255,255,255)
                TweenService:Create(DropCardStroke, TweenInfo.new(0.2),
                    {Color = anySelected and GuiConfig.Color or Color3.fromRGB(45,45,45)}):Play()

                if cfg2.Callback then
                    if cfg2.Multi then
                        pcall(function() cfg2.Callback(df.Value) end)
                    else
                        pcall(function() cfg2.Callback(df.Value ~= nil and tostring(df.Value) or "") end)
                    end
                end
            end

            function df:SetValue(v) self:Set(v) end
            function df:GetValue()  return self.Value end
            function df:SetValues(list, sel)
                list = list or {}; sel = sel or (cfg2.Multi and {} or nil)
                df:Clear()
                for _, v in ipairs(list) do df:AddOption(v) end
                df.Options = list; df:Set(sel)
            end

            df:SetValues(df.Options, df.Value)
            dropdownPageCounter += 1
            Elements[key] = df
            return df
        end

        -- ── Discord Card ─────────────────────
        function TabItems:AddDiscord(DiscordConfig)
            DiscordConfig = DiscordConfig or {}
            DiscordConfig.InviteCode = DiscordConfig.InviteCode or ""
            DiscordConfig.Title      = DiscordConfig.Title      or "Discord"

            -- ┌────────────────────────────────────────────────────────────┐
            -- │  Card principal — altura dinâmica                          │
            -- └────────────────────────────────────────────────────────────┘
            local CARD_H = isMobile and 130 or 118
            local card = Instance.new("Frame")
            card.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            card.BorderSizePixel  = 0
            card.Size             = UDim2.new(1, -2, 0, CARD_H)
            card.Name             = "DiscordCard"
            card.Parent           = ScrolLayers
            Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)
            local cardStroke = Instance.new("UIStroke", card)
            cardStroke.Color = Color3.fromRGB(45, 45, 45); cardStroke.Thickness = 1
            -- Gradient animado na borda do card Discord
            MakeAnimatedGradient(cardStroke, card)

            -- Banner de cor no topo (rosa/cor do tema, como o banner roxo/pink do Discord)
            local Banner = Instance.new("Frame")
            Banner.BackgroundColor3 = GuiConfig.Color
            Banner.Size             = UDim2.new(1, 0, 0, 36)
            Banner.BorderSizePixel  = 0
            Banner.Name             = "Banner"
            Banner.Parent           = card
            local BannerCorner = Instance.new("UICorner", Banner)
            BannerCorner.CornerRadius = UDim.new(0, 8)
            -- Cortar cantos inferiores do banner
            local BannerFix = Instance.new("Frame")
            BannerFix.BackgroundColor3 = GuiConfig.Color
            BannerFix.BorderSizePixel  = 0
            BannerFix.Position         = UDim2.new(0, 0, 0.5, 0)
            BannerFix.Size             = UDim2.new(1, 0, 0.5, 0)
            BannerFix.Parent           = Banner

            -- Gradient suave no banner
            local BannerGrad = Instance.new("UIGradient", Banner)
            BannerGrad.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 130, 200)),
                ColorSequenceKeypoint.new(1, GuiConfig.Color),
            }
            BannerGrad.Rotation = 90

            -- Avatar do servidor (ícone quadrado com UICorner, sobrepõe o banner)
            local AvatarHolder = Instance.new("Frame")
            AvatarHolder.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            AvatarHolder.BorderSizePixel  = 0
            AvatarHolder.Size             = UDim2.new(0, 42, 0, 42)
            AvatarHolder.Position         = UDim2.new(0, 12, 0, 16)   -- centro na linha do banner
            AvatarHolder.ZIndex           = 3
            AvatarHolder.Name             = "AvatarHolder"
            AvatarHolder.Parent           = card
            Instance.new("UICorner", AvatarHolder).CornerRadius = UDim.new(0, 10)
            local AvatarStroke = Instance.new("UIStroke", AvatarHolder)
            AvatarStroke.Color = Color3.fromRGB(30, 30, 30); AvatarStroke.Thickness = 3

            local AvatarImg = Instance.new("ImageLabel")
            AvatarImg.Size               = UDim2.new(1, 0, 1, 0)
            AvatarImg.BackgroundTransparency = 1
            AvatarImg.Image              = ""   -- preenchido pela API
            AvatarImg.ScaleType          = Enum.ScaleType.Crop
            AvatarImg.ZIndex             = 4
            AvatarImg.Name               = "AvatarImg"
            AvatarImg.Parent             = AvatarHolder
            Instance.new("UICorner", AvatarImg).CornerRadius = UDim.new(0, 10)

            -- Loading spinner (3 pontinhos animados) dentro do avatar
            local LoadDots = Instance.new("TextLabel")
            LoadDots.Text        = "..."
            LoadDots.Font        = Enum.Font.GothamBold
            LoadDots.TextSize    = 14
            LoadDots.TextColor3  = Color3.fromRGB(160, 160, 160)
            LoadDots.BackgroundTransparency = 1
            LoadDots.Size        = UDim2.new(1, 0, 1, 0)
            LoadDots.ZIndex      = 5
            LoadDots.Parent      = AvatarHolder

            -- Nome do servidor
            local ServerName = Instance.new("TextLabel")
            ServerName.Font          = Enum.Font.GothamBold
            ServerName.Text          = DiscordConfig.Title
            ServerName.TextColor3    = Color3.fromRGB(255, 255, 255)
            ServerName.TextSize      = isMobile and 14 or 13
            ServerName.TextXAlignment = Enum.TextXAlignment.Left
            ServerName.BackgroundTransparency = 1
            ServerName.Position      = UDim2.new(0, 62, 0, 40)
            ServerName.Size          = UDim2.new(1, -70, 0, 16)
            ServerName.ZIndex        = 3
            ServerName.Name          = "ServerName"
            ServerName.Parent        = card

            -- Badge verificado (pequeno ícone ao lado do nome)
            local VerifyBadge = Instance.new("ImageLabel")
            VerifyBadge.Image    = "rbxassetid://15459909338"  -- ícone de check/verified
            VerifyBadge.Size     = UDim2.new(0, 14, 0, 14)
            VerifyBadge.AnchorPoint = Vector2.new(0, 0.5)
            VerifyBadge.Position = UDim2.new(0, ServerName.TextBounds.X + 68, 0, 48)
            VerifyBadge.BackgroundTransparency = 1
            VerifyBadge.ImageColor3 = GuiConfig.Color
            VerifyBadge.ZIndex   = 3
            VerifyBadge.Name     = "VerifyBadge"
            VerifyBadge.Parent   = card

            -- Row de stats (bolinha verde + online / ponto cinza + membros)
            local StatsRow = Instance.new("Frame")
            StatsRow.BackgroundTransparency = 1
            StatsRow.Position = UDim2.new(0, 12, 0, 60)
            StatsRow.Size     = UDim2.new(1, -24, 0, 14)
            StatsRow.ZIndex   = 3
            StatsRow.Name     = "StatsRow"
            StatsRow.Parent   = card

            local function MakeDot(color, xoff)
                local dot = Instance.new("Frame")
                dot.BackgroundColor3 = color
                dot.Size     = UDim2.new(0, 7, 0, 7)
                dot.Position = UDim2.new(0, xoff, 0.5, -3)
                dot.ZIndex   = 4
                dot.Parent   = StatsRow
                Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
                return dot
            end

            MakeDot(Color3.fromRGB(35, 165, 90), 0)    -- verde online

            local OnlineLabel = Instance.new("TextLabel")
            OnlineLabel.Font = Enum.Font.Gotham; OnlineLabel.Text = "..."
            OnlineLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
            OnlineLabel.TextSize   = isMobile and 12 or 11
            OnlineLabel.TextXAlignment = Enum.TextXAlignment.Left
            OnlineLabel.BackgroundTransparency = 1
            OnlineLabel.Position   = UDim2.new(0, 12, 0, 0)
            OnlineLabel.Size       = UDim2.new(0, 90, 1, 0)
            OnlineLabel.ZIndex     = 4
            OnlineLabel.Name       = "OnlineLabel"
            OnlineLabel.Parent     = StatsRow

            MakeDot(Color3.fromRGB(100, 100, 100), 108)  -- cinza membros

            local MemberLabel = Instance.new("TextLabel")
            MemberLabel.Font = Enum.Font.Gotham; MemberLabel.Text = "..."
            MemberLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
            MemberLabel.TextSize   = isMobile and 12 or 11
            MemberLabel.TextXAlignment = Enum.TextXAlignment.Left
            MemberLabel.BackgroundTransparency = 1
            MemberLabel.Position   = UDim2.new(0, 120, 0, 0)
            MemberLabel.Size       = UDim2.new(1, -120, 1, 0)
            MemberLabel.ZIndex     = 4
            MemberLabel.Name       = "MemberLabel"
            MemberLabel.Parent     = StatsRow

            -- "Desde" label
            local SinceLabel = Instance.new("TextLabel")
            SinceLabel.Font = Enum.Font.Gotham; SinceLabel.Text = ""
            SinceLabel.TextColor3 = Color3.fromRGB(110, 110, 110)
            SinceLabel.TextSize   = isMobile and 11 or 10
            SinceLabel.TextXAlignment = Enum.TextXAlignment.Left
            SinceLabel.BackgroundTransparency = 1
            SinceLabel.Position   = UDim2.new(0, 12, 0, 78)
            SinceLabel.Size       = UDim2.new(1, -24, 0, 12)
            SinceLabel.ZIndex     = 3
            SinceLabel.Name       = "SinceLabel"
            SinceLabel.Parent     = card

            -- Botão "Ir para o Servidor" (verde Discord)
            local JoinBtn = Instance.new("TextButton")
            JoinBtn.Text             = "⏳ Carregando..."
            JoinBtn.Font             = Enum.Font.GothamBold
            JoinBtn.TextSize         = isMobile and 13 or 12
            JoinBtn.TextColor3       = Color3.fromRGB(255, 255, 255)
            JoinBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            JoinBtn.BorderSizePixel  = 0
            JoinBtn.Size             = UDim2.new(1, -24, 0, isMobile and 34 or 28)
            JoinBtn.Position         = UDim2.new(0, 12, 1, -(isMobile and 42 or 36))
            JoinBtn.ZIndex           = 3
            JoinBtn.Name             = "JoinBtn"
            JoinBtn.Parent           = card
            Instance.new("UICorner", JoinBtn).CornerRadius = UDim.new(0, 6)

            if not isMobile then
                JoinBtn.MouseEnter:Connect(function()
                    TweenService:Create(JoinBtn, TweenInfo.new(0.15),
                        {BackgroundColor3 = Color3.fromRGB(40, 167, 90)}):Play()
                end)
                JoinBtn.MouseLeave:Connect(function()
                    local isLoaded = JoinBtn:GetAttribute("Loaded")
                    TweenService:Create(JoinBtn, TweenInfo.new(0.15),
                        {BackgroundColor3 = isLoaded and Color3.fromRGB(35, 140, 75) or Color3.fromRGB(45,45,45)}):Play()
                end)
            end

            JoinBtn.Activated:Connect(function()
                if JoinBtn:GetAttribute("Loaded") then
                    local ok = pcall(function() setclipboard("https://discord.gg/" .. DiscordConfig.InviteCode) end)
                    blessedhubx("Invite copiado! discord.gg/" .. DiscordConfig.InviteCode, 4,
                        Color3.fromRGB(88, 101, 242), "Discord", "📋 Copiado")
                end
            end)

            -- ── Fetch da API Discord ──────────────────
            local API_URL = "https://discord.com/api/v10/invites/" .. DiscordConfig.InviteCode
                .. "?with_counts=true&with_expiration=true"

            local function FetchDiscordInfo()
                task.spawn(function()
                    -- animação de loading nos dots
                    local dotFrames = {".", "..", "..."}
                    local dotIdx = 1
                    local dotConn
                    dotConn = RunService.Heartbeat:Connect(function()
                        LoadDots.Text = dotFrames[dotIdx]
                        dotIdx = dotIdx % 3 + 1
                        task.wait(0.4)
                    end)

                    local ok, result = pcall(function()
                        local res = game:GetService("HttpService"):GetAsync(API_URL, true)
                        return game:GetService("HttpService"):JSONDecode(res)
                    end)

                    dotConn:Disconnect()
                    LoadDots.Visible = false

                    if ok and result and result.guild then
                        local guild = result.guild
                        local online  = result.approximate_presence_count or 0
                        local members = result.approximate_member_count   or 0

                        -- Ícone do servidor
                        if guild.icon and guild.icon ~= "" then
                            local iconUrl = "https://cdn.discordapp.com/icons/" .. guild.id .. "/" .. guild.icon .. ".png?size=256"
                            pcall(function()
                                AvatarImg.Image = iconUrl
                            end)
                        end

                        -- Formata números: 4790 → "4.790"
                        local function fmtNum(n)
                            local s = tostring(math.floor(n))
                            return s:reverse():gsub("(%d%d%d)", "%1."):reverse():gsub("^%.", "")
                        end

                        ServerName.Text      = guild.name or DiscordConfig.Title
                        OnlineLabel.Text     = fmtNum(online) .. " online"
                        MemberLabel.Text     = fmtNum(members) .. " membros"

                        -- Data de criação a partir do snowflake ID
                        if guild.id then
                            local snowflake = tonumber(guild.id)
                            if snowflake then
                                local msEpoch = math.floor(snowflake / 4194304) + 1420070400000
                                local year = 1970
                                local ms   = msEpoch
                                -- Aproximação simples de ano
                                year = 1970 + math.floor(ms / 31536000000)
                                local months = {"jan.", "fev.", "mar.", "abr.", "mai.", "jun.",
                                                "jul.", "ago.", "set.", "out.", "nov.", "dez."}
                                local monthIdx = math.floor((ms % 31536000000) / 2628000000) + 1
                                monthIdx = math.clamp(monthIdx, 1, 12)
                                SinceLabel.Text = "Desde " .. months[monthIdx] .. " de " .. tostring(year)
                            end
                        end

                        -- Ativa o botão
                        JoinBtn.Text = "Ir para o Servidor"
                        JoinBtn:SetAttribute("Loaded", true)
                        TweenService:Create(JoinBtn, TweenInfo.new(0.3),
                            {BackgroundColor3 = Color3.fromRGB(35, 140, 75)}):Play()

                        -- Atualiza posição do badge ao lado do nome
                        task.wait(0.05)
                        VerifyBadge.Position = UDim2.new(0, ServerName.TextBounds.X + 68, 0, 48)

                    else
                        -- Erro
                        ServerName.Text   = "Erro ao carregar"
                        OnlineLabel.Text  = "—"
                        MemberLabel.Text  = "—"
                        SinceLabel.Text   = "Verifique sua conexão"
                        JoinBtn.Text      = "❌ Falha ao conectar"
                        cardStroke.Color  = Color3.fromRGB(180, 50, 50)
                    end
                end)
            end

            -- Chama imediatamente
            FetchDiscordInfo()

            -- Retorna handle para refresh externo
            local df = {}
            function df:Refresh()
                LoadDots.Visible  = true
                JoinBtn.Text      = "⏳ Atualizando..."
                JoinBtn:SetAttribute("Loaded", false)
                TweenService:Create(JoinBtn, TweenInfo.new(0.15), {BackgroundColor3=Color3.fromRGB(45,45,45)}):Play()
                FetchDiscordInfo()
            end
            function df:SetInvite(code)
                DiscordConfig.InviteCode = code
                API_URL = "https://discord.com/api/v10/invites/" .. code .. "?with_counts=true&with_expiration=true"
                df:Refresh()
            end

            return df
        end

        -- ── Divider ──────────────────────────
        function TabItems:AddDivider()
            local d = Instance.new("Frame")
            d.Name = "Divider"; d.AnchorPoint = Vector2.new(0.5, 0)
            d.Position = UDim2.new(0.5, 0, 0, 0)
            d.Size     = UDim2.new(1, 0, 0, 2)
            d.BackgroundColor3 = Color3.fromRGB(255,255,255)
            d.BackgroundTransparency = 0; d.BorderSizePixel = 0
            d.Parent = ScrolLayers
            local g = Instance.new("UIGradient", d)
            g.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0,   Color3.fromRGB(20,20,20)),
                ColorSequenceKeypoint.new(0.5, GuiConfig.Color),
                ColorSequenceKeypoint.new(1,   Color3.fromRGB(20,20,20)),
            }
            Instance.new("UICorner", d).CornerRadius = UDim.new(0, 2)
            return d
        end

        CountTab += 1
        _G[TabConfig.Name:gsub("%s+", "_")] = TabItems
        return TabItems
    end

    return Tabs
end

return BlessedHubX
