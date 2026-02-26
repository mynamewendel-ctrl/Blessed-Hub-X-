






local function GetGuiParent()
    if typeof(gethui) == "function" then
        local ok, h = pcall(gethui); if ok and h then return h end
    end
    local ok2, cg = pcall(function() return cloneref(game:GetService("CoreGui")) end)
    if ok2 and cg then return cg end
    local ok3, cg2 = pcall(function() return game:GetService("CoreGui") end)
    if ok3 and cg2 then return cg2 end
    return game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
end


local function SafeIsFolder(p)     return isfolder  and isfolder(p)  or false end
local function SafeMakeFolder(p)   if makefolder    then pcall(makefolder, p) end end
local function SafeIsFile(p)       return isfile    and isfile(p)    or false end
local function SafeWriteFile(p, d) if writefile     then pcall(writefile, p, d) end end
local function SafeReadFile(p)
    if readfile then local ok,v=pcall(readfile,p); if ok then return v end end
end
local function SafeSetClipboard(t) if setclipboard then pcall(setclipboard,t) end end

local HttpService = game:GetService("HttpService")

if not SafeIsFolder("Blessed Hub X")        then SafeMakeFolder("Blessed Hub X") end
if not SafeIsFolder("Blessed Hub X/Config") then SafeMakeFolder("Blessed Hub X/Config") end

local gameName = "Unknown"
pcall(function()
    gameName = tostring(game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name)
    gameName = gameName:gsub("[^%w_ ]",""):gsub("%s+","_")
end)
local ConfigFile = "Blessed Hub X/Config/Blessed_"..gameName..".json"

ConfigData      = {}
Elements        = {}
CURRENT_VERSION = nil

local function tableFind(t,v) for i,x in ipairs(t) do if x==v then return i end end end

function SaveConfig()
    ConfigData._version = CURRENT_VERSION
    SafeWriteFile(ConfigFile, HttpService:JSONEncode(ConfigData))
end
function LoadConfigFromFile()
    if not CURRENT_VERSION then return end
    if SafeIsFile(ConfigFile) then
        local raw = SafeReadFile(ConfigFile)
        if raw then
            local ok,res = pcall(function() return HttpService:JSONDecode(raw) end)
            if ok and type(res)=="table" then
                ConfigData = (res._version==CURRENT_VERSION) and res or {_version=CURRENT_VERSION}
                return
            end
        end
    end
    ConfigData = {_version=CURRENT_VERSION}
end
function LoadConfigElements()
    for key,el in pairs(Elements) do
        if ConfigData[key]~=nil and el.Set then el:Set(ConfigData[key],true) end
    end
end


local Icons = {
    player    = "rbxassetid://12120698352",
    web       = "rbxassetid://137601480983962",
    bag       = "rbxassetid://8601111810",
    shop      = "rbxassetid://4985385964",
    cart      = "rbxassetid://128874923961846",
    plug      = "rbxassetid://137601480983962",
    settings  = "rbxassetid://70386228443175",
    loop      = "rbxassetid://122032243989747",
    gps       = "rbxassetid://17824309485",
    compas    = "rbxassetid://125300760963399",
    gamepad   = "rbxassetid://84173963561612",
    boss      = "rbxassetid://13132186360",
    scroll    = "rbxassetid://114127804740858",
    menu      = "rbxassetid://6340513838",
    crosshair = "rbxassetid://12614416478",
    user      = "rbxassetid://108483430622128",
    stat      = "rbxassetid://12094445329",
    eyes      = "rbxassetid://14321059114",
    sword     = "rbxassetid://82472368671405",
    discord   = "rbxassetid://94434236999817",
    star      = "rbxassetid://107005941750079",
    skeleton  = "rbxassetid://17313330026",
    payment   = "rbxassetid://18747025078",
    scan      = "rbxassetid://109869955247116",
    alert     = "rbxassetid://73186275216515",
    question  = "rbxassetid://17510196486",
    idea      = "rbxassetid://16833255748",
    storm     = "rbxassetid://13321880293",
    water     = "rbxassetid://100076212630732",
    dcs       = "rbxassetid://15310731934",
    start     = "rbxassetid://108886429866687",
    next      = "rbxassetid://12662718374",
    rod       = "rbxassetid://103247953194129",
    fish      = "rbxassetid://97167558235554",
    blessed   = "rbxassetid://137601480983962",
}


local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local RunService       = game:GetService("RunService")
local LocalPlayer      = game:GetService("Players").LocalPlayer
local Mouse            = LocalPlayer:GetMouse()
local GuiParent        = GetGuiParent()

local isMobile = UserInputService.TouchEnabled
    and not UserInputService.KeyboardEnabled
    and not UserInputService.MouseEnabled






local function MakeAnimatedGradient(stroke, anchorFrame, colorFunc)
    if not stroke then return end
    local grad = Instance.new("UIGradient")
    grad.Parent = stroke
    grad.Transparency = NumberSequence.new{
        NumberSequenceKeypoint.new(0,   1),
        NumberSequenceKeypoint.new(0.25,0),
        NumberSequenceKeypoint.new(0.75,0),
        NumberSequenceKeypoint.new(1,   1),
    }
    local rot, acc = 0, 0
    local conn
    conn = RunService.Heartbeat:Connect(function(dt)
        if not stroke or not stroke.Parent then conn:Disconnect(); return end
        acc = acc + dt
        if acc < 0.04 then return end
        acc = 0
        rot = (rot + dt * 80) % 360
        local col
        if colorFunc then
            col = colorFunc()
        else
            
            col = Color3.fromRGB(255,255,255)
        end
        grad.Color    = ColorSequence.new{
            ColorSequenceKeypoint.new(0, col),
            ColorSequenceKeypoint.new(1, col),
        }
        grad.Rotation = rot
    end)
    if anchorFrame then
        anchorFrame.AncestryChanged:Connect(function()
            if not anchorFrame.Parent then conn:Disconnect() end
        end)
    end
    return grad, conn
end


local function MakePulseFunc(color)
    return function()
        local h, s, v = Color3.toHSV(color)
        return Color3.fromHSV(h, s, math.clamp(v * (0.65 + math.sin(tick() * 2.5) * 0.35), 0, 1))
    end
end




local function MakeDraggable(handle, object)
    local dragging, dragInput, dragStart, startPos
    handle.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1
        or inp.UserInputType == Enum.UserInputType.Touch then
            dragging  = true; dragStart = inp.Position; startPos = object.Position
            inp.Changed:Connect(function()
                if inp.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    handle.InputChanged:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseMovement
        or inp.UserInputType == Enum.UserInputType.Touch then dragInput = inp end
    end)
    local conn = UserInputService.InputChanged:Connect(function(inp)
        if inp == dragInput and dragging then
            local d = inp.Position - dragStart
            object.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + d.X,
                startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
    object.Destroying:Connect(function() if conn then conn:Disconnect() end end)
end




local function MakeResizable(object, minW, minH)
    if isMobile then return end
    minW, minH = minW or 440, minH or 300
    local resizing, resizeInput, resizeStart, startSize, conn

    local handle = Instance.new("Frame")
    handle.AnchorPoint            = Vector2.new(1,1)
    handle.BackgroundTransparency = 1
    handle.Size                   = UDim2.new(0,20,0,20)
    handle.Position               = UDim2.new(1,0,1,0)
    handle.Name                   = "ResizeHandle"
    handle.Parent                 = object

    local grip = Instance.new("ImageLabel")
    grip.Image                  = "rbxassetid://6031094678"
    grip.ImageColor3            = Color3.fromRGB(80,80,80)
    grip.BackgroundTransparency = 1
    grip.Size                   = UDim2.new(1,0,1,0)
    grip.Parent                 = handle

    handle.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing=true; resizeStart=inp.Position; startSize=object.Size
            inp.Changed:Connect(function()
                if inp.UserInputState==Enum.UserInputState.End then resizing=false end
            end)
        end
    end)
    handle.InputChanged:Connect(function(inp)
        if inp.UserInputType==Enum.UserInputType.MouseMovement then resizeInput=inp end
    end)
    conn = UserInputService.InputChanged:Connect(function(inp)
        if inp==resizeInput and resizing then
            local d=inp.Position-resizeStart
            object.Size = UDim2.new(0,math.max(startSize.X.Offset+d.X,minW),0,math.max(startSize.Y.Offset+d.Y,minH))
        end
    end)
    object.Destroying:Connect(function() if conn then conn:Disconnect() end end)
end




function CircleClick(btn, x, y)
    task.spawn(function()
        btn.ClipsDescendants = true
        local c = Instance.new("ImageLabel")
        c.Image             = "rbxassetid://266543268"
        c.ImageColor3       = Color3.fromRGB(255,255,255)
        c.ImageTransparency = 0.82
        c.BackgroundTransparency = 1
        c.ZIndex            = 10
        c.Size              = UDim2.new(0,0,0,0)
        c.Position          = UDim2.new(0,x-btn.AbsolutePosition.X,0,y-btn.AbsolutePosition.Y)
        c.Parent            = btn
        local sz = math.max(btn.AbsoluteSize.X, btn.AbsoluteSize.Y) * 1.8
        TweenService:Create(c, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{
            Size=UDim2.new(0,sz,0,sz),
            Position=UDim2.new(0.5,-sz/2,0.5,-sz/2),
            ImageTransparency=1,
        }):Play()
        task.wait(0.4); c:Destroy()
    end)
end




local BlessedHubX = {}




function BlessedHubX:MakeNotify(cfg)
    cfg             = cfg             or {}
    cfg.Title       = cfg.Title       or "BlessedHubX"
    cfg.Description = cfg.Description or "Notification"
    cfg.Content     = cfg.Content     or ""
    cfg.Color       = cfg.Color       or Color3.fromRGB(255,105,180)
    cfg.Time        = cfg.Time        or 0.4
    cfg.Delay       = cfg.Delay       or 5
    cfg.AnimColor   = cfg.AnimColor   or nil
    local fn = {}

    task.spawn(function()
        if not GuiParent:FindFirstChild("BHX_NotifyGui") then
            local ng = Instance.new("ScreenGui")
            ng.ZIndexBehavior=Enum.ZIndexBehavior.Sibling; ng.ResetOnSpawn=false
            ng.Name="BHX_NotifyGui"; ng.Parent=GuiParent
        end
        local NotifyGui = GuiParent:FindFirstChild("BHX_NotifyGui")
        if not NotifyGui:FindFirstChild("NotifyLayout") then
            local nl=Instance.new("Frame")
            nl.AnchorPoint=Vector2.new(1,1); nl.BackgroundTransparency=1
            nl.Position=UDim2.new(1,-16,1,-16); nl.Size=UDim2.new(0,310,1,0)
            nl.Name="NotifyLayout"; nl.Parent=NotifyGui
            local cnt=0
            nl.ChildRemoved:Connect(function()
                cnt=0
                for _,v in nl:GetChildren() do
                    if v:IsA("Frame") then
                        TweenService:Create(v,TweenInfo.new(0.3,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),
                            {Position=UDim2.new(0,0,1,-((v.Size.Y.Offset+10)*cnt))}):Play()
                        cnt+=1
                    end
                end
            end)
        end

        local layout=NotifyGui.NotifyLayout
        local posY=0
        for _,v in layout:GetChildren() do
            if v:IsA("Frame") then posY=-(v.Position.Y.Offset)+v.Size.Y.Offset+10 end
        end

        local nf=Instance.new("Frame")
        local nfr=Instance.new("Frame")
        nf.BackgroundTransparency=1; nf.Size=UDim2.new(1,0,0,74)
        nf.Name="NotifyFrame"; nf.AnchorPoint=Vector2.new(0,1)
        nf.Position=UDim2.new(0,0,1,-posY); nf.Parent=layout

        nfr.BackgroundColor3=Color3.fromRGB(18,18,24)
        nfr.BackgroundTransparency=0.05; nfr.BorderSizePixel=0
        nfr.Position=UDim2.new(0,340,0,0); nfr.Size=UDim2.new(1,0,1,0)
        nfr.Name="NotifyFrameReal"; nfr.Parent=nf
        Instance.new("UICorner",nfr).CornerRadius=UDim.new(0,10)

        local st=Instance.new("UIStroke",nfr); st.Thickness=1.5; st.Color=Color3.fromRGB(255,255,255)
        local animColorFunc = cfg.AnimColor and MakePulseFunc(cfg.AnimColor) or nil
        MakeAnimatedGradient(st, nf, animColorFunc or MakePulseFunc(cfg.Color))

        
        local accentBar=Instance.new("Frame")
        accentBar.BackgroundColor3=cfg.Color; accentBar.BorderSizePixel=0
        accentBar.Size=UDim2.new(0,3,1,-16); accentBar.Position=UDim2.new(0,8,0,8)
        accentBar.Parent=nfr; Instance.new("UICorner",accentBar).CornerRadius=UDim.new(0,2)

        local tl=Instance.new("TextLabel")
        tl.Font=Enum.Font.GothamBold; tl.Text=cfg.Title
        tl.TextColor3=Color3.fromRGB(255,255,255); tl.TextSize=13
        tl.TextXAlignment=Enum.TextXAlignment.Left
        tl.BackgroundTransparency=1; tl.Size=UDim2.new(1,0,0,20)
        tl.Position=UDim2.new(0,20,0,10); tl.Parent=nfr

        local tl1=Instance.new("TextLabel")
        tl1.Font=Enum.Font.GothamBold; tl1.Text=cfg.Description
        tl1.TextColor3=cfg.Color; tl1.TextSize=12
        tl1.TextXAlignment=Enum.TextXAlignment.Left
        tl1.BackgroundTransparency=1; tl1.Size=UDim2.new(1,0,0,16)
        tl1.Position=UDim2.new(0,20,0,28); tl1.Parent=nfr

        local tl2=Instance.new("TextLabel")
        tl2.Font=Enum.Font.Gotham; tl2.Text=cfg.Content; tl2.TextSize=11
        tl2.TextXAlignment=Enum.TextXAlignment.Left; tl2.TextYAlignment=Enum.TextYAlignment.Top
        tl2.BackgroundTransparency=1; tl2.TextColor3=Color3.fromRGB(160,160,170)
        tl2.Position=UDim2.new(0,20,0,44); tl2.Size=UDim2.new(1,-28,0,20)
        tl2.TextWrapped=true; tl2.Parent=nfr

        local closed=false
        function fn:Close()
            if closed then return end; closed=true
            TweenService:Create(nfr,TweenInfo.new(cfg.Time,Enum.EasingStyle.Back,Enum.EasingDirection.In),
                {Position=UDim2.new(0,340,0,0)}):Play()
            task.wait(cfg.Time*0.9); nf:Destroy()
        end
        TweenService:Create(nfr,TweenInfo.new(cfg.Time*1.1,Enum.EasingStyle.Back,Enum.EasingDirection.Out),
            {Position=UDim2.new(0,0,0,0)}):Play()
        task.wait(cfg.Delay); fn:Close()
    end)
    return fn
end

function blessedhubx(msg, delay, color, title, desc, animColor)
    return BlessedHubX:MakeNotify({
        Title=title or "BlessedHubX", Description=desc or "Notification",
        Content=msg or "", Color=color or Color3.fromRGB(255,105,180),
        Delay=delay or 4, AnimColor=animColor or nil,
    })
end




function BlessedHubX:Window(GuiConfig)
    GuiConfig            = GuiConfig            or {}
    GuiConfig.Title      = GuiConfig.Title      or "BlessedHubX"
    GuiConfig.Footer     = GuiConfig.Footer     or "Premium Edition"
    GuiConfig.Color      = GuiConfig.Color      or Color3.fromRGB(255,105,180)
    GuiConfig.Background = GuiConfig.Background or Color3.fromRGB(16,16,22)
    GuiConfig.Transparency = (GuiConfig.Transparency ~= nil) and GuiConfig.Transparency or 0
    GuiConfig.Size       = GuiConfig.Size       or (isMobile
        and UDim2.new(0,500,0,340) or UDim2.new(0,640,0,440))
    
    GuiConfig.AnimColor  = GuiConfig.AnimColor  or nil
    GuiConfig["Tab Width"] = GuiConfig["Tab Width"] or 68
    GuiConfig.Version    = GuiConfig.Version    or 1
    GuiConfig.Logo       = GuiConfig.Logo       or Icons.blessed

    CURRENT_VERSION = GuiConfig.Version
    LoadConfigFromFile()

    
    local accentColorFunc = GuiConfig.AnimColor
        and MakePulseFunc(GuiConfig.AnimColor)
        or  MakePulseFunc(GuiConfig.Color)

    local TAB_W = isMobile and 58 or GuiConfig["Tab Width"]
    local BG    = GuiConfig.Background
    local TRANS = GuiConfig.Transparency
    local WSIZE = GuiConfig.Size

    local GuiFunc = {}

    
    local ScreenGui        = Instance.new("ScreenGui")
    local DropShadowHolder = Instance.new("Frame")
    local DropShadow       = Instance.new("ImageLabel")
    local Main             = Instance.new("Frame")
    local Top              = Instance.new("Frame")
    local TitleLabel       = Instance.new("TextLabel")
    local FooterLabel      = Instance.new("TextLabel")
    local Close            = Instance.new("TextButton")
    local Min              = Instance.new("TextButton")
    local ContentHolder    = Instance.new("Frame")
    local LayersTab        = Instance.new("Frame")
    local Layers           = Instance.new("Frame")
    local NameTab          = Instance.new("TextLabel")
    local LayersReal       = Instance.new("Frame")
    local LayersFolder     = Instance.new("Folder")
    local LayersPageLayout = Instance.new("UIPageLayout")

    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Name           = "BlessedHubX"
    ScreenGui.ResetOnSpawn   = false
    ScreenGui.Parent         = GuiParent

    DropShadowHolder.BackgroundTransparency = 1
    DropShadowHolder.BorderSizePixel        = 0
    DropShadowHolder.AnchorPoint            = Vector2.new(0.5,0.5)
    DropShadowHolder.Position               = UDim2.new(0.5,0,0.5,0)
    DropShadowHolder.Size                   = WSIZE
    DropShadowHolder.Name                   = "DropShadowHolder"
    DropShadowHolder.Parent                 = ScreenGui

    
    DropShadow.Image             = "rbxassetid://6015897843"
    DropShadow.ImageColor3       = Color3.fromRGB(0,0,5)
    DropShadow.ImageTransparency = 0.5
    DropShadow.ScaleType         = Enum.ScaleType.Slice
    DropShadow.SliceCenter       = Rect.new(49,49,450,450)
    DropShadow.AnchorPoint       = Vector2.new(0.5,0.5)
    DropShadow.BackgroundTransparency = 1
    DropShadow.Position          = UDim2.new(0.5,0,0.5,0)
    DropShadow.Size              = UDim2.new(1,40,1,40)
    DropShadow.ZIndex            = 0
    DropShadow.Name              = "DropShadow"
    DropShadow.Parent            = DropShadowHolder

    
    Main.BackgroundColor3       = BG
    Main.BackgroundTransparency = TRANS
    Main.AnchorPoint            = Vector2.new(0.5,0.5)
    Main.BorderSizePixel        = 0
    Main.ClipsDescendants       = true
    Main.Position               = UDim2.new(0.5,0,0.5,0)
    Main.Size                   = UDim2.new(1,0,1,0)
    Main.ZIndex                 = 1
    Main.Name                   = "Main"
    Main.Parent                 = DropShadowHolder
    Instance.new("UICorner",Main).CornerRadius = UDim.new(0,10)

    local MainStroke = Instance.new("UIStroke",Main)
    MainStroke.Thickness = 1.6
    MakeAnimatedGradient(MainStroke, ScreenGui, accentColorFunc)

    
    local TOP_H = isMobile and 50 or 46
    Top.BackgroundTransparency = 1
    Top.Size                   = UDim2.new(1,0,0,TOP_H)
    Top.Name                   = "TopBar"
    Top.Parent                 = Main

    
    local TopBg = Instance.new("Frame")
    TopBg.BackgroundColor3       = Color3.fromRGB(10,10,15)
    TopBg.BackgroundTransparency = 0.3
    TopBg.BorderSizePixel        = 0
    TopBg.Size                   = UDim2.new(1,0,1,0)
    TopBg.Parent                 = Top
    Instance.new("UICorner",TopBg).CornerRadius = UDim.new(0,10)
    
    local TopBgCover = Instance.new("Frame")
    TopBgCover.BackgroundColor3=Color3.fromRGB(10,10,15); TopBgCover.BackgroundTransparency=0.3
    TopBgCover.BorderSizePixel=0; TopBgCover.Size=UDim2.new(1,0,0,10); TopBgCover.Position=UDim2.new(0,0,1,-10)
    TopBgCover.Parent=TopBg

    local LogoIcon = Instance.new("ImageLabel")
    LogoIcon.Image                  = GuiConfig.Logo
    LogoIcon.Size                   = UDim2.new(0,24,0,24)
    LogoIcon.Position               = UDim2.new(0,14,0.5,-12)
    LogoIcon.BackgroundTransparency = 1
    LogoIcon.ZIndex                 = 2
    LogoIcon.Name                   = "LogoIcon"
    LogoIcon.Parent                 = Top

    TitleLabel.Font               = Enum.Font.GothamBlack
    TitleLabel.Text               = GuiConfig.Title
    TitleLabel.TextColor3         = Color3.fromRGB(255,255,255)
    TitleLabel.TextSize           = isMobile and 15 or 14
    TitleLabel.TextXAlignment     = Enum.TextXAlignment.Left
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Size               = UDim2.new(0,200,1,0)
    TitleLabel.Position           = UDim2.new(0,46,0,0)
    TitleLabel.ZIndex             = 2
    TitleLabel.Parent             = Top

    FooterLabel.Font              = Enum.Font.Gotham
    FooterLabel.Text              = GuiConfig.Footer
    FooterLabel.TextColor3        = Color3.fromRGB(80,80,100)
    FooterLabel.TextSize          = isMobile and 10 or 11
    FooterLabel.TextXAlignment    = Enum.TextXAlignment.Left
    FooterLabel.BackgroundTransparency = 1
    FooterLabel.Size              = UDim2.new(0,200,1,0)
    FooterLabel.Position          = UDim2.new(0,TitleLabel.TextBounds.X+54,0,0)
    FooterLabel.ZIndex            = 2
    FooterLabel.Parent            = Top

    
    local BTN_SZ = isMobile and 36 or 28
    Close.Font = Enum.Font.SourceSans; Close.Text=""
    Close.AnchorPoint=Vector2.new(1,0.5); Close.BackgroundTransparency=1
    Close.Position=UDim2.new(1,-10,0.5,0); Close.Size=UDim2.new(0,BTN_SZ,0,BTN_SZ)
    Close.Name="Close"; Close.ZIndex=2; Close.Parent=Top
    local CloseImg=Instance.new("ImageLabel")
    CloseImg.Image="rbxassetid://9886659671"; CloseImg.AnchorPoint=Vector2.new(0.5,0.5)
    CloseImg.BackgroundTransparency=1; CloseImg.Position=UDim2.new(0.5,0,0.5,0)
    CloseImg.Size=UDim2.new(0,16,0,16); CloseImg.ZIndex=3; CloseImg.Parent=Close

    Min.Font=Enum.Font.SourceSans; Min.Text=""
    Min.AnchorPoint=Vector2.new(1,0.5); Min.BackgroundTransparency=1
    Min.Position=UDim2.new(1,-(BTN_SZ+10),0.5,0); Min.Size=UDim2.new(0,BTN_SZ,0,BTN_SZ)
    Min.Name="Min"; Min.ZIndex=2; Min.Parent=Top
    local MinImg=Instance.new("ImageLabel")
    MinImg.Image="rbxassetid://9886659276"; MinImg.AnchorPoint=Vector2.new(0.5,0.5)
    MinImg.BackgroundTransparency=1; MinImg.ImageTransparency=0.3
    MinImg.Position=UDim2.new(0.5,0,0.5,0); MinImg.Size=UDim2.new(0,16,0,16)
    MinImg.ZIndex=3; MinImg.Parent=Min

    if not isMobile then
        
        Min.MouseEnter:Connect(function() TweenService:Create(MinImg,TweenInfo.new(0.15),{ImageTransparency=0}):Play() end)
        Min.MouseLeave:Connect(function() TweenService:Create(MinImg,TweenInfo.new(0.15),{ImageTransparency=0.3}):Play() end)
    end

    
    local Divider=Instance.new("Frame")
    Divider.BackgroundColor3=Color3.fromRGB(30,30,42); Divider.BackgroundTransparency=0
    Divider.BorderSizePixel=0; Divider.Size=UDim2.new(1,0,0,1)
    Divider.Position=UDim2.new(0,0,0,TOP_H); Divider.Parent=Main

    
    local AccentLine=Instance.new("Frame")
    AccentLine.BackgroundColor3=GuiConfig.Color; AccentLine.BackgroundTransparency=0.7
    AccentLine.BorderSizePixel=0; AccentLine.Size=UDim2.new(0,80,0,1)
    AccentLine.Position=UDim2.new(0,0,0,TOP_H+1); AccentLine.Parent=Main
    local AccentLineGrad=Instance.new("UIGradient",AccentLine)
    AccentLineGrad.Color=ColorSequence.new{
        ColorSequenceKeypoint.new(0,GuiConfig.Color),
        ColorSequenceKeypoint.new(1,Color3.fromRGB(20,20,30)),
    }

    
    ContentHolder.BackgroundTransparency = 1
    ContentHolder.Position = UDim2.new(0,0,0,TOP_H+2)
    ContentHolder.Size     = UDim2.new(1,0,1,-(TOP_H+2))
    ContentHolder.Name     = "ContentHolder"
    ContentHolder.ClipsDescendants = true
    ContentHolder.Parent   = Main

    local CHLayout=Instance.new("UIListLayout")
    CHLayout.FillDirection=Enum.FillDirection.Horizontal
    CHLayout.SortOrder=Enum.SortOrder.LayoutOrder
    CHLayout.Padding=UDim.new(0,0)
    CHLayout.Parent=ContentHolder

    
    LayersTab.BackgroundColor3       = Color3.fromRGB(10,10,16)
    LayersTab.BackgroundTransparency = 0
    LayersTab.BorderSizePixel        = 0
    LayersTab.LayoutOrder            = 0
    LayersTab.Size                   = UDim2.new(0,TAB_W+4,1,0)
    LayersTab.Name                   = "LayersTab"
    LayersTab.Parent                 = ContentHolder

    
    local SidebarBorder=Instance.new("Frame")
    SidebarBorder.BackgroundColor3=Color3.fromRGB(28,28,40); SidebarBorder.BorderSizePixel=0
    SidebarBorder.Size=UDim2.new(0,1,1,0); SidebarBorder.Position=UDim2.new(1,-1,0,0)
    SidebarBorder.Parent=LayersTab

    
    local SidePad=Instance.new("UIPadding",LayersTab)
    SidePad.PaddingTop=UDim.new(0,10)

    
    Layers.BackgroundTransparency = 1
    Layers.LayoutOrder            = 1
    Layers.Size                   = UDim2.new(1,-(TAB_W+4),1,0)
    Layers.Name                   = "Layers"
    Layers.ClipsDescendants       = true
    Layers.Parent                 = ContentHolder

    local LayersPad=Instance.new("UIPadding",Layers)
    LayersPad.PaddingLeft=UDim.new(0,10)
    LayersPad.PaddingRight=UDim.new(0,8)
    LayersPad.PaddingTop=UDim.new(0,6)

    
    local HEADER_H = isMobile and 38 or 36

    NameTab.Font             = Enum.Font.GothamBlack
    NameTab.Text             = ""
    NameTab.TextColor3       = Color3.fromRGB(240,240,248)
    NameTab.TextSize         = isMobile and 20 or 18
    NameTab.TextXAlignment   = Enum.TextXAlignment.Left
    NameTab.BackgroundTransparency = 1
    NameTab.Size             = UDim2.new(1,0,0,HEADER_H-4)
    NameTab.Position         = UDim2.new(0,0,0,0)
    NameTab.Name             = "NameTab"
    NameTab.ZIndex           = 2
    NameTab.Parent           = Layers

    
    local NameTabLine=Instance.new("Frame")
    NameTabLine.Size=UDim2.new(0,50,0,2); NameTabLine.Position=UDim2.new(0,0,0,HEADER_H-4)
    NameTabLine.BackgroundColor3=GuiConfig.Color; NameTabLine.BackgroundTransparency=0
    NameTabLine.BorderSizePixel=0; NameTabLine.Name="NameTabLine"; NameTabLine.Parent=Layers
    Instance.new("UICorner",NameTabLine).CornerRadius=UDim.new(0,2)
    local NTLGrad=Instance.new("UIGradient",NameTabLine)
    NTLGrad.Color=ColorSequence.new{
        ColorSequenceKeypoint.new(0,GuiConfig.Color),
        ColorSequenceKeypoint.new(1,Color3.fromRGB(16,16,22)),
    }

    
    local HeaderSpacer=Instance.new("Frame")
    HeaderSpacer.BackgroundTransparency=1; HeaderSpacer.Size=UDim2.new(1,0,0,HEADER_H+2)
    HeaderSpacer.LayoutOrder=0; HeaderSpacer.Name="HeaderSpacer"
    

    
    LayersReal.BackgroundTransparency = 1
    LayersReal.ClipsDescendants       = true
    LayersReal.Size                   = UDim2.new(1,0,1,0)
    LayersReal.Name                   = "LayersReal"
    LayersReal.Parent                 = Layers

    LayersFolder.Name="LayersFolder"; LayersFolder.Parent=LayersReal

    LayersPageLayout.SortOrder       = Enum.SortOrder.LayoutOrder
    LayersPageLayout.Name            = "LayersPageLayout"
    LayersPageLayout.TweenTime       = 0.22
    LayersPageLayout.EasingDirection = Enum.EasingDirection.Out
    LayersPageLayout.EasingStyle     = Enum.EasingStyle.Quint
    LayersPageLayout.Parent          = LayersFolder

    
    local ScrollTab   = Instance.new("ScrollingFrame")
    local TabLayout   = Instance.new("UIListLayout")
    ScrollTab.CanvasSize                = UDim2.new(0,0,0,0)
    ScrollTab.ScrollBarImageColor3      = GuiConfig.Color
    ScrollTab.ScrollBarThickness        = 2
    ScrollTab.ScrollBarImageTransparency= 0.7
    ScrollTab.Active                    = true
    ScrollTab.BackgroundTransparency    = 1
    ScrollTab.Size                      = UDim2.new(1,0,1,0)
    ScrollTab.Name                      = "ScrollTab"
    ScrollTab.Parent                    = LayersTab
    TabLayout.Padding             = UDim.new(0,6)
    TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    TabLayout.SortOrder           = Enum.SortOrder.LayoutOrder
    TabLayout.Parent              = ScrollTab
    TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        ScrollTab.CanvasSize=UDim2.new(0,0,0,TabLayout.AbsoluteContentSize.Y+16)
    end)

    
    local IsMinimized=false
    local function ToggleWindow()
        if not IsMinimized then
            IsMinimized=true
            DropShadowHolder.Visible=false
        else
            IsMinimized=false
            DropShadowHolder.Visible=true
        end
    end
    Min.Activated:Connect(ToggleWindow)
    if not isMobile then
        UserInputService.InputBegan:Connect(function(inp,gpe)
            if gpe then return end
            if inp.KeyCode==Enum.KeyCode.X then ToggleWindow() end
        end)
    end

    
    function GuiFunc:ToggleUI()
        if GuiParent:FindFirstChild("BHX_ToggleBtn") then GuiParent.BHX_ToggleBtn:Destroy() end
        local sg=Instance.new("ScreenGui")
        sg.ZIndexBehavior=Enum.ZIndexBehavior.Sibling; sg.ResetOnSpawn=false
        sg.Name="BHX_ToggleBtn"; sg.Parent=GuiParent

        local btnSz=isMobile and 50 or 42
        local mb=Instance.new("ImageLabel")
        mb.Size=UDim2.new(0,btnSz,0,btnSz); mb.Position=UDim2.new(0,16,0,90)
        mb.BackgroundTransparency=1; mb.Image=Icons.blessed
        mb.ScaleType=Enum.ScaleType.Fit; mb.Parent=sg

        local btn=Instance.new("TextButton")
        btn.Size=UDim2.new(1,0,1,0); btn.BackgroundTransparency=1; btn.Text=""; btn.Parent=mb
        btn.Activated:Connect(function() ToggleWindow() end)

        local drag,dragInput,dragStart,startPos,dConn
        btn.InputBegan:Connect(function(inp)
            if inp.UserInputType==Enum.UserInputType.MouseButton1
            or inp.UserInputType==Enum.UserInputType.Touch then
                drag=true; dragStart=inp.Position; startPos=mb.Position
                inp.Changed:Connect(function()
                    if inp.UserInputState==Enum.UserInputState.End then drag=false end
                end)
            end
        end)
        btn.InputChanged:Connect(function(inp)
            if inp.UserInputType==Enum.UserInputType.MouseMovement
            or inp.UserInputType==Enum.UserInputType.Touch then dragInput=inp end
        end)
        dConn=UserInputService.InputChanged:Connect(function(inp)
            if drag and inp==dragInput then
                local d=inp.Position-dragStart
                mb.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y)
            end
        end)
        mb.Destroying:Connect(function() if dConn then dConn:Disconnect() end end)
    end
    GuiFunc:ToggleUI()

    MakeDraggable(Top, DropShadowHolder)
    MakeResizable(DropShadowHolder, 440, 300)

    
    local dialogOpen = false
    Close.Activated:Connect(function()
        if dialogOpen then return end
        dialogOpen = true

        local overlay = Instance.new("Frame")
        overlay.Size                   = UDim2.new(1,0,1,0)
        overlay.BackgroundColor3       = Color3.fromRGB(0,0,0)
        overlay.BackgroundTransparency = 0.55
        overlay.ZIndex                 = 50
        overlay.Name                   = "CloseOverlay"
        overlay.Parent                 = Main

        local dialog = Instance.new("Frame")
        dialog.BackgroundColor3       = Color3.fromRGB(18,18,24)
        dialog.BackgroundTransparency = 0.05
        dialog.Size                   = UDim2.new(0,290,0,148)
        dialog.Position               = UDim2.new(0.5,0,0.5,0)
        dialog.AnchorPoint            = Vector2.new(0.5,0.5)
        dialog.ZIndex                 = 51
        dialog.Parent                 = overlay
        Instance.new("UICorner",dialog).CornerRadius = UDim.new(0,10)
        local ds = Instance.new("UIStroke",dialog); ds.Color = GuiConfig.Color; ds.Thickness = 1.4

        local function dlgLbl(txt,bold,sz,col,pos,size,zi)
            local l = Instance.new("TextLabel"); l.BackgroundTransparency = 1
            l.Font = bold and Enum.Font.GothamBold or Enum.Font.Gotham
            l.Text = txt; l.TextSize = sz; l.TextColor3 = col
            l.Position = pos; l.Size = size; l.ZIndex = zi; l.TextWrapped = true; l.Parent = dialog
        end
        dlgLbl("Close Hub?",true,16,Color3.fromRGB(255,255,255),
            UDim2.new(0,14,0,16),UDim2.new(1,-28,0,22),52)
        dlgLbl("You won't be able to reopen without re-executing.",false,11,Color3.fromRGB(140,140,160),
            UDim2.new(0,14,0,40),UDim2.new(1,-28,0,40),52)

        local function dlgBtn(txt,bgcol,xp)
            local b = Instance.new("TextButton")
            b.Size = UDim2.new(0.44,0,0,34); b.Position = UDim2.new(xp,0,1,-44)
            b.BackgroundColor3 = bgcol; b.Text = txt; b.Font = Enum.Font.GothamBold
            b.TextSize = 12; b.TextColor3 = Color3.fromRGB(255,255,255)
            b.ZIndex = 52; b.Parent = dialog
            Instance.new("UICorner",b).CornerRadius = UDim.new(0,6); return b
        end
        local yes    = dlgBtn("Yes",    GuiConfig.Color,         0.05)
        local cancel = dlgBtn("Cancel", Color3.fromRGB(38,38,50),0.51)

        yes.MouseButton1Click:Connect(function()
            ScreenGui:Destroy()
            if GuiParent:FindFirstChild("BHX_ToggleBtn") then
                GuiParent.BHX_ToggleBtn:Destroy()
            end
        end)
        cancel.MouseButton1Click:Connect(function()
            overlay:Destroy()
            dialogOpen = false
        end)
    end)

    
    local MoreBlur      = Instance.new("Frame")
    local ConnectButton = Instance.new("TextButton")
    MoreBlur.BackgroundColor3       = Color3.fromRGB(0,0,0)
    MoreBlur.BackgroundTransparency = 1
    MoreBlur.Size                   = UDim2.new(1,0,1,0)
    MoreBlur.Position               = UDim2.new(0,0,0,0)
    MoreBlur.Visible                = false
    MoreBlur.Name                   = "MoreBlur"
    MoreBlur.ZIndex                 = 15
    MoreBlur.Parent                 = Main

    ConnectButton.BackgroundTransparency=1; ConnectButton.Size=UDim2.new(1,0,1,0)
    ConnectButton.Text=""; ConnectButton.Parent=MoreBlur

    local panelW = isMobile and 210 or 230
    local DropdownSelect=Instance.new("Frame")
    DropdownSelect.AnchorPoint      = Vector2.new(1,0.5)
    DropdownSelect.BackgroundColor3 = Color3.fromRGB(14,14,20)
    DropdownSelect.BackgroundTransparency = 0.04
    DropdownSelect.Position         = UDim2.new(1,panelW+30,0.5,0)
    DropdownSelect.Size             = UDim2.new(0,panelW,1,-20)
    DropdownSelect.ZIndex           = 20
    DropdownSelect.Parent           = MoreBlur
    Instance.new("UICorner",DropdownSelect).CornerRadius=UDim.new(0,12)

    local DropStroke=Instance.new("UIStroke",DropdownSelect)
    DropStroke.Thickness=1.6
    MakeAnimatedGradient(DropStroke, DropdownSelect, accentColorFunc)

    local DropdownFolder=Instance.new("Frame")
    DropdownFolder.BackgroundTransparency=1; DropdownFolder.Size=UDim2.new(1,0,1,0)
    DropdownFolder.ClipsDescendants=true; DropdownFolder.Parent=DropdownSelect

    local DropPageLayout=Instance.new("UIPageLayout",DropdownFolder)
    DropPageLayout.EasingDirection=Enum.EasingDirection.Out
    DropPageLayout.EasingStyle=Enum.EasingStyle.Quint
    DropPageLayout.TweenTime=0.18
    DropPageLayout.SortOrder=Enum.SortOrder.LayoutOrder

    ConnectButton.Activated:Connect(function()
        if MoreBlur.Visible then
            TweenService:Create(DropdownSelect,TweenInfo.new(0.2,Enum.EasingStyle.Quint,Enum.EasingDirection.In),
                {Position=UDim2.new(1,panelW+30,0.5,0)}):Play()
            TweenService:Create(MoreBlur,TweenInfo.new(0.18),{BackgroundTransparency=1}):Play()
            task.wait(0.22); MoreBlur.Visible=false
        end
    end)

    
    
    
    local Tabs    = {}
    local CountTab = 0

    function Tabs:AddTab(TabConfig)
        TabConfig      = TabConfig or {}
        TabConfig.Name = TabConfig.Name or "Tab"
        TabConfig.Icon = TabConfig.Icon or ""

        
        local ScrolLayers   = Instance.new("ScrollingFrame")
        local TabItemLayout = Instance.new("UIListLayout")
        ScrolLayers.ScrollBarImageColor3        = GuiConfig.Color
        ScrolLayers.ScrollBarThickness          = 3
        ScrolLayers.ScrollBarImageTransparency  = 0.6
        ScrolLayers.BackgroundTransparency      = 1
        ScrolLayers.Size                        = UDim2.new(1,0,1,0)
        ScrolLayers.CanvasSize                  = UDim2.new(0,0,0,0)
        ScrolLayers.LayoutOrder                 = CountTab
        ScrolLayers.Name                        = "ScrolLayers"
        ScrolLayers.Parent                      = LayersFolder

        
        local spacer=Instance.new("Frame")
        spacer.BackgroundTransparency=1; spacer.Size=UDim2.new(1,0,0,HEADER_H+4)
        spacer.LayoutOrder=0; spacer.Name="HeaderSpacer"; spacer.Parent=ScrolLayers

        TabItemLayout.Padding   = UDim.new(0,8)
        TabItemLayout.SortOrder = Enum.SortOrder.LayoutOrder
        TabItemLayout.Parent    = ScrolLayers
        TabItemLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            ScrolLayers.CanvasSize=UDim2.new(0,0,0,TabItemLayout.AbsoluteContentSize.Y+16)
        end)

        
        local elementOrder = 1

        
        local TAB_BTN_H = isMobile and 60 or 56
        local Tab        = Instance.new("Frame")
        local TabButton  = Instance.new("TextButton")
        local FeatureImg = Instance.new("ImageLabel")
        local TabNameLbl = Instance.new("TextLabel")
        local ChooseBar  = Instance.new("Frame")
        local isActive   = CountTab == 0

        Tab.BackgroundColor3       = Color3.fromRGB(30,30,42)
        Tab.BackgroundTransparency = isActive and 0.35 or 1
        Tab.LayoutOrder            = CountTab
        Tab.Size                   = UDim2.new(1,-8,0,TAB_BTN_H)
        Tab.Parent                 = ScrollTab
        Instance.new("UICorner",Tab).CornerRadius=UDim.new(0,10)

        TabButton.BackgroundTransparency=1; TabButton.Size=UDim2.new(1,0,1,0); TabButton.Text=""
        TabButton.Parent=Tab

        FeatureImg.BackgroundTransparency=1; FeatureImg.AnchorPoint=Vector2.new(0.5,0.5)
        FeatureImg.Position=UDim2.new(0.5,0,0.5,-7); FeatureImg.Size=UDim2.new(0,22,0,22)
        FeatureImg.Image=Icons[TabConfig.Icon] or TabConfig.Icon or ""
        FeatureImg.ImageColor3=isActive and GuiConfig.Color or Color3.fromRGB(110,110,130)
        FeatureImg.Parent=Tab

        TabNameLbl.Font=Enum.Font.GothamBold
        TabNameLbl.Text=TabConfig.Name:upper():sub(1,5)
        TabNameLbl.TextColor3=isActive and GuiConfig.Color or Color3.fromRGB(80,80,100)
        TabNameLbl.TextSize=8; TabNameLbl.AnchorPoint=Vector2.new(0.5,1)
        TabNameLbl.BackgroundTransparency=1; TabNameLbl.Position=UDim2.new(0.5,0,1,-6)
        TabNameLbl.Size=UDim2.new(1,-4,0,10); TabNameLbl.TextXAlignment=Enum.TextXAlignment.Center
        TabNameLbl.Parent=Tab

        ChooseBar.BackgroundColor3=GuiConfig.Color
        ChooseBar.Position=UDim2.new(0,0,0.5,-14)
        ChooseBar.Size=UDim2.new(0,3,0,28)
        ChooseBar.BackgroundTransparency=isActive and 0 or 1
        ChooseBar.Parent=Tab
        Instance.new("UICorner",ChooseBar).CornerRadius=UDim.new(0,2)

        if CountTab==0 then
            LayersPageLayout:JumpToIndex(0); NameTab.Text=TabConfig.Name
        end

        TabButton.Activated:Connect(function()
            if Tab.LayoutOrder==LayersPageLayout.CurrentPage.LayoutOrder then return end
            
            for _,tf in pairs(ScrollTab:GetChildren()) do
                if tf:IsA("Frame") then
                    TweenService:Create(tf,TweenInfo.new(0.22,Enum.EasingStyle.Quint),{BackgroundTransparency=1}):Play()
                    local bar=tf:FindFirstChildOfClass("Frame")
                    if bar then TweenService:Create(bar,TweenInfo.new(0.18),{BackgroundTransparency=1}):Play() end
                    local img=tf:FindFirstChildOfClass("ImageLabel")
                    if img then TweenService:Create(img,TweenInfo.new(0.18),{ImageColor3=Color3.fromRGB(110,110,130)}):Play() end
                    for _,c in tf:GetChildren() do
                        if c:IsA("TextLabel") then
                            TweenService:Create(c,TweenInfo.new(0.18),{TextColor3=Color3.fromRGB(80,80,100)}):Play()
                        end
                    end
                end
            end
            
            TweenService:Create(Tab,TweenInfo.new(0.28,Enum.EasingStyle.Quint),{BackgroundTransparency=0.35}):Play()
            TweenService:Create(ChooseBar,TweenInfo.new(0.28,Enum.EasingStyle.Quint),{BackgroundTransparency=0}):Play()
            TweenService:Create(FeatureImg,TweenInfo.new(0.18,Enum.EasingStyle.Back,Enum.EasingDirection.Out),
                {Size=UDim2.new(0,26,0,26),ImageColor3=GuiConfig.Color}):Play()
            TweenService:Create(TabNameLbl,TweenInfo.new(0.18),{TextColor3=GuiConfig.Color}):Play()
            task.delay(0.18,function()
                TweenService:Create(FeatureImg,TweenInfo.new(0.12),{Size=UDim2.new(0,22,0,22)}):Play()
            end)
            LayersPageLayout:JumpToIndex(Tab.LayoutOrder)
            NameTab.Text=TabConfig.Name
        end)

        
        
        local function CreateCard(customBG, customTrans)
            local c=Instance.new("Frame")
            c.BackgroundColor3       = customBG or BG
            c.BackgroundTransparency = customTrans or TRANS
            c.BorderSizePixel        = 0
            c.Size                   = UDim2.new(1,-2,0,0)
            c.Parent                 = ScrolLayers
            c.LayoutOrder            = elementOrder
            elementOrder             += 1
            Instance.new("UICorner",c).CornerRadius=UDim.new(0,8)
            local st=Instance.new("UIStroke",c)
            st.Color=Color3.fromRGB(38,38,52); st.Thickness=1
            return c, st
        end

        local TabItems            = {}
        local dropdownPageCounter = 0

        
        function TabItems:AddTextSeparator(title)
            title = title or "SECTION"
            local sep=Instance.new("Frame")
            sep.BackgroundTransparency=1; sep.Size=UDim2.new(1,0,0,24)
            sep.LayoutOrder=elementOrder; elementOrder+=1
            sep.Parent=ScrolLayers
            
            local tick=Instance.new("Frame")
            tick.BackgroundColor3=GuiConfig.Color; tick.BorderSizePixel=0
            tick.Size=UDim2.new(0,3,0,12); tick.Position=UDim2.new(0,0,0.5,-6)
            tick.Parent=sep; Instance.new("UICorner",tick).CornerRadius=UDim.new(0,2)
            local lbl=Instance.new("TextLabel")
            lbl.BackgroundTransparency=1; lbl.Size=UDim2.new(1,-10,1,0)
            lbl.Position=UDim2.new(0,9,0,0)
            lbl.Font=Enum.Font.GothamBold; lbl.Text=string.upper(title)
            lbl.TextColor3=Color3.fromRGB(180,180,200)
            lbl.TextSize=isMobile and 11 or 10
            lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.Parent=sep
            return sep
        end

        
        
        
        function TabItems:AddParagraph(cfg2)
            cfg2         = cfg2         or {}
            cfg2.Title   = cfg2.Title   or ""
            cfg2.Content = cfg2.Content or ""
            local hasTitle = cfg2.Title ~= ""
            local PADDING  = 14

            local card, _ = CreateCard()
            card.AutomaticSize    = Enum.AutomaticSize.Y
            card.ClipsDescendants = false

            
            local inner=Instance.new("Frame")
            inner.BackgroundTransparency=1; inner.AutomaticSize=Enum.AutomaticSize.Y
            inner.Position=UDim2.new(0,PADDING,0,PADDING); inner.Size=UDim2.new(1,-PADDING*2,0,0)
            inner.Parent=card

            local innerList=Instance.new("UIListLayout")
            innerList.Padding=UDim.new(0,4); innerList.SortOrder=Enum.SortOrder.LayoutOrder
            innerList.Parent=inner

            local titleRef=nil
            if hasTitle then
                local titleLbl=Instance.new("TextLabel")
                titleLbl.Font=Enum.Font.GothamBold; titleLbl.Text=cfg2.Title
                titleLbl.TextColor3=GuiConfig.Color
                titleLbl.TextSize=isMobile and 14 or 13
                titleLbl.TextXAlignment=Enum.TextXAlignment.Left
                titleLbl.BackgroundTransparency=1
                titleLbl.Size=UDim2.new(1,0,0,isMobile and 18 or 16)
                titleLbl.AutomaticSize=Enum.AutomaticSize.Y
                titleLbl.TextWrapped=true; titleLbl.LayoutOrder=0; titleLbl.Parent=inner
                titleRef=titleLbl
            end

            local bodyLbl=Instance.new("TextLabel")
            bodyLbl.Font=Enum.Font.Gotham; bodyLbl.Text=cfg2.Content
            bodyLbl.TextColor3=Color3.fromRGB(170,170,190)
            bodyLbl.TextSize=isMobile and 13 or 12
            bodyLbl.TextXAlignment=Enum.TextXAlignment.Left
            bodyLbl.TextYAlignment=Enum.TextYAlignment.Top
            bodyLbl.BackgroundTransparency=1; bodyLbl.TextWrapped=true
            bodyLbl.AutomaticSize=Enum.AutomaticSize.Y
            bodyLbl.Size=UDim2.new(1,0,0,0); bodyLbl.LayoutOrder=1; bodyLbl.Parent=inner

            
            local bot=Instance.new("Frame"); bot.BackgroundTransparency=1
            bot.Size=UDim2.new(1,0,0,PADDING); bot.LayoutOrder=99; bot.Parent=inner

            
            local acBar=Instance.new("Frame")
            acBar.BackgroundColor3=GuiConfig.Color; acBar.BackgroundTransparency=0.6
            acBar.Size=UDim2.new(0,2,1,-PADDING*2); acBar.Position=UDim2.new(0,0,0,PADDING)
            acBar.BorderSizePixel=0; acBar.Parent=card
            Instance.new("UICorner",acBar).CornerRadius=UDim.new(0,2)

            local pg={}
            function pg:SetTitle(t) if titleRef then titleRef.Text=t end end
            function pg:SetContent(t) bodyLbl.Text=t end
            return pg
        end

        
        function TabItems:AddToggle(cfg2)
            cfg2          = cfg2          or {}
            cfg2.Title    = cfg2.Title    or "Toggle"
            cfg2.Default  = cfg2.Default  or false
            cfg2.Callback = cfg2.Callback or function() end
            local key="Toggle_"..cfg2.Title
            if ConfigData[key]~=nil then cfg2.Default=ConfigData[key] end

            local tf={Value=cfg2.Default}
            local H=isMobile and 54 or 48
            local card, cardStroke = CreateCard()
            card.Size=UDim2.new(1,-2,0,H)

            local ttl=Instance.new("TextLabel")
            ttl.Font=Enum.Font.GothamBold; ttl.Text=cfg2.Title
            ttl.TextColor3=Color3.fromRGB(220,220,230); ttl.TextSize=isMobile and 14 or 13
            ttl.TextXAlignment=Enum.TextXAlignment.Left; ttl.BackgroundTransparency=1
            ttl.Position=UDim2.new(0,16,0,0); ttl.Size=UDim2.new(1,-74,1,0); ttl.Parent=card

            local tbtn=Instance.new("TextButton")
            tbtn.BackgroundTransparency=1; tbtn.Size=UDim2.new(1,0,1,0); tbtn.Text=""; tbtn.Parent=card

            local track=Instance.new("Frame")
            track.AnchorPoint=Vector2.new(1,0.5); track.BackgroundColor3=Color3.fromRGB(35,35,48)
            track.Position=UDim2.new(1,-14,0.5,0); track.Size=UDim2.new(0,40,0,22)
            track.Parent=card; Instance.new("UICorner",track).CornerRadius=UDim.new(0,11)
            local trackStroke=Instance.new("UIStroke",track)
            trackStroke.Color=Color3.fromRGB(50,50,65); trackStroke.Thickness=1

            local thumb=Instance.new("Frame")
            thumb.AnchorPoint=Vector2.new(0,0.5); thumb.BackgroundColor3=Color3.fromRGB(200,200,215)
            thumb.Position=UDim2.new(0,3,0.5,0); thumb.Size=UDim2.new(0,16,0,16)
            thumb.Parent=track; Instance.new("UICorner",thumb).CornerRadius=UDim.new(1,0)

            tbtn.Activated:Connect(function() tf.Value=not tf.Value; tf:Set(tf.Value) end)

            if not isMobile then
                tbtn.MouseEnter:Connect(function()
                    TweenService:Create(cardStroke,TweenInfo.new(0.15),{Color=Color3.fromRGB(55,55,72)}):Play()
                end)
                tbtn.MouseLeave:Connect(function()
                    if not tf.Value then
                        TweenService:Create(cardStroke,TweenInfo.new(0.15),{Color=Color3.fromRGB(38,38,52)}):Play()
                    end
                end)
            end

            
            local strokeAnimConn = nil
            function tf:Set(val, skip)
                local ti=TweenInfo.new(0.22,Enum.EasingStyle.Quint,Enum.EasingDirection.Out)
                if val then
                    TweenService:Create(ttl,ti,{TextColor3=GuiConfig.Color}):Play()
                    TweenService:Create(thumb,ti,{Position=UDim2.new(1,-19,0.5,0),BackgroundColor3=Color3.fromRGB(255,255,255)}):Play()
                    TweenService:Create(track,ti,{BackgroundColor3=GuiConfig.Color}):Play()
                    TweenService:Create(trackStroke,ti,{Color=GuiConfig.Color,Transparency=0.6}):Play()
                    
                    if strokeAnimConn then strokeAnimConn:Disconnect(); strokeAnimConn=nil end
                    MakeAnimatedGradient(cardStroke, card, accentColorFunc)
                    cardStroke.Thickness=1.4
                else
                    TweenService:Create(ttl,ti,{TextColor3=Color3.fromRGB(220,220,230)}):Play()
                    TweenService:Create(thumb,ti,{Position=UDim2.new(0,3,0.5,0),BackgroundColor3=Color3.fromRGB(200,200,215)}):Play()
                    TweenService:Create(track,ti,{BackgroundColor3=Color3.fromRGB(35,35,48)}):Play()
                    TweenService:Create(trackStroke,ti,{Color=Color3.fromRGB(50,50,65),Transparency=0}):Play()
                    cardStroke.Color=Color3.fromRGB(38,38,52); cardStroke.Thickness=1
                end
                if not skip then pcall(function() cfg2.Callback(val) end); ConfigData[key]=val; SaveConfig() end
            end
            tf:Set(tf.Value,true)
            Elements[key]=tf; return tf
        end

        
        function TabItems:AddSlider(cfg2)
            cfg2           = cfg2           or {}
            cfg2.Title     = cfg2.Title     or "Slider"
            cfg2.Min       = cfg2.Min       or 0
            cfg2.Max       = cfg2.Max       or 100
            cfg2.Default   = cfg2.Default   or 50
            cfg2.Increment = cfg2.Increment or 1
            cfg2.Callback  = cfg2.Callback  or function() end
            local key="Slider_"..cfg2.Title
            if ConfigData[key]~=nil then cfg2.Default=ConfigData[key] end

            local sf={Value=cfg2.Default}
            local H=isMobile and 64 or 58
            local card, cardStroke = CreateCard()
            card.Size=UDim2.new(1,-2,0,H)

            local stitle=Instance.new("TextLabel")
            stitle.Font=Enum.Font.GothamBold; stitle.Text=cfg2.Title
            stitle.TextColor3=Color3.fromRGB(220,220,230); stitle.TextSize=isMobile and 14 or 13
            stitle.TextXAlignment=Enum.TextXAlignment.Left; stitle.BackgroundTransparency=1
            stitle.Position=UDim2.new(0,16,0,isMobile and 12 or 10); stitle.Size=UDim2.new(1,-80,0,18); stitle.Parent=card

            local vbox=Instance.new("TextBox")
            vbox.Font=Enum.Font.GothamBold; vbox.Text=tostring(cfg2.Default)
            vbox.TextColor3=GuiConfig.Color; vbox.TextSize=isMobile and 13 or 12
            vbox.TextXAlignment=Enum.TextXAlignment.Right; vbox.BackgroundTransparency=1
            vbox.AnchorPoint=Vector2.new(1,0); vbox.Position=UDim2.new(1,-16,0,isMobile and 12 or 10)
            vbox.Size=UDim2.new(0,56,0,18); vbox.Parent=card

            local track=Instance.new("Frame")
            track.BackgroundColor3=Color3.fromRGB(35,35,50); track.AnchorPoint=Vector2.new(0,1)
            track.Position=UDim2.new(0,16,1,-14); track.Size=UDim2.new(1,-32,0,5); track.Parent=card
            Instance.new("UICorner",track).CornerRadius=UDim.new(1,0)

            local fill=Instance.new("Frame")
            fill.BackgroundColor3=GuiConfig.Color; fill.Size=UDim2.new(0,0,1,0)
            fill.Parent=track; Instance.new("UICorner",fill).CornerRadius=UDim.new(1,0)

            local thumb=Instance.new("Frame")
            thumb.AnchorPoint=Vector2.new(0.5,0.5); thumb.BackgroundColor3=Color3.fromRGB(255,255,255)
            thumb.Size=UDim2.new(0,13,0,13); thumb.Position=UDim2.new(0,0,0.5,0); thumb.ZIndex=3
            thumb.Parent=track; Instance.new("UICorner",thumb).CornerRadius=UDim.new(1,0)

            local Dragging=false
            local function Round(n,f) return math.floor(n/f+0.5)*f end

            function sf:Set(val,skip)
                val=math.clamp(Round(val,cfg2.Increment),cfg2.Min,cfg2.Max)
                sf.Value=val; vbox.Text=tostring(val)
                local pct=(val-cfg2.Min)/math.max(cfg2.Max-cfg2.Min,1)
                local fi=(Dragging or skip) and TweenInfo.new(0) or TweenInfo.new(0.07)
                TweenService:Create(fill,fi,{Size=UDim2.new(pct,0,1,0)}):Play()
                TweenService:Create(thumb,fi,{Position=UDim2.new(pct,0,0.5,0)}):Play()
                if not skip then pcall(function() cfg2.Callback(val) end); ConfigData[key]=val; SaveConfig() end
            end

            local function UpdateSlide(inp)
                local rel=math.clamp((inp.Position.X-track.AbsolutePosition.X)/math.max(track.AbsoluteSize.X,1),0,1)
                sf:Set(cfg2.Min+(cfg2.Max-cfg2.Min)*rel)
            end
            track.InputBegan:Connect(function(inp)
                if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then
                    Dragging=true; TweenService:Create(thumb,TweenInfo.new(0.1),{Size=UDim2.new(0,16,0,16)}):Play()
                    MakeAnimatedGradient(cardStroke,card,accentColorFunc); cardStroke.Thickness=1.4
                    UpdateSlide(inp)
                end
            end)
            track.InputEnded:Connect(function(inp)
                if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then
                    Dragging=false; TweenService:Create(thumb,TweenInfo.new(0.1),{Size=UDim2.new(0,13,0,13)}):Play()
                    cardStroke.Color=Color3.fromRGB(38,38,52); cardStroke.Thickness=1
                end
            end)
            local slConn=UserInputService.InputChanged:Connect(function(inp)
                if Dragging and (inp.UserInputType==Enum.UserInputType.MouseMovement or inp.UserInputType==Enum.UserInputType.Touch) then
                    UpdateSlide(inp)
                end
            end)
            card.AncestryChanged:Connect(function() if not card.Parent then slConn:Disconnect() end end)
            vbox.FocusLost:Connect(function() sf:Set(tonumber(vbox.Text) or cfg2.Min) end)
            sf:Set(cfg2.Default,true); Elements[key]=sf; return sf
        end

        
        function TabItems:AddButton(cfg2)
            cfg2          = cfg2          or {}
            cfg2.Title    = cfg2.Title    or "Button"
            cfg2.Callback = cfg2.Callback or function() end
            local H=isMobile and 50 or 44

            
            local card,_ = CreateCard(Color3.fromRGB(10,10,16), 0)
            card.Size=UDim2.new(1,-2,0,H)
            
            for _,c in card:GetChildren() do if c:IsA("UIStroke") then c.Transparency=1 end end

            local btn=Instance.new("TextButton")
            btn.Font             = Enum.Font.GothamBold
            btn.Text             = cfg2.Title
            btn.TextSize         = isMobile and 14 or 13
            btn.TextColor3       = Color3.fromRGB(240,240,255)
            btn.BackgroundColor3 = Color3.fromRGB(8,8,14)
            btn.BackgroundTransparency = 0
            btn.Size             = UDim2.new(1,-16,1,-12)
            btn.Position         = UDim2.new(0,8,0,6)
            btn.Parent           = card
            Instance.new("UICorner",btn).CornerRadius=UDim.new(0,7)

            local btnStroke=Instance.new("UIStroke",btn)
            btnStroke.Color=Color3.fromRGB(42,42,58); btnStroke.Thickness=1

            if not isMobile then
                btn.MouseEnter:Connect(function()
                    TweenService:Create(btn,TweenInfo.new(0.18),{BackgroundColor3=GuiConfig.Color}):Play()
                    MakeAnimatedGradient(btnStroke,btn,accentColorFunc); btnStroke.Thickness=1.2
                end)
                btn.MouseLeave:Connect(function()
                    TweenService:Create(btn,TweenInfo.new(0.18),{BackgroundColor3=Color3.fromRGB(8,8,14)}):Play()
                    btnStroke.Color=Color3.fromRGB(42,42,58); btnStroke.Thickness=1
                end)
            end
            btn.MouseButton1Click:Connect(function()
                CircleClick(btn,Mouse.X,Mouse.Y); pcall(cfg2.Callback)
            end)
            return card
        end

        
        function TabItems:AddDropdown(cfg2)
            cfg2          = cfg2          or {}
            cfg2.Title    = cfg2.Title    or "Dropdown"
            cfg2.Content  = cfg2.Content  or ""
            cfg2.Multi    = cfg2.Multi    or false
            cfg2.Options  = cfg2.Options  or {}
            cfg2.Default  = cfg2.Default  or (cfg2.Multi and {} or nil)
            cfg2.Callback = cfg2.Callback or function() end
            cfg2.AnimColor = cfg2.AnimColor or nil
            local key="Dropdown_"..cfg2.Title
            if ConfigData[key]~=nil then cfg2.Default=ConfigData[key] end

            local df={Value=cfg2.Default,Options=cfg2.Options}
            local H=isMobile and 52 or 46

            local Dropdown       = Instance.new("Frame")
            local DropdownButton = Instance.new("TextButton")
            local DropdownTitle  = Instance.new("TextLabel")
            local SelectFrame    = Instance.new("Frame")
            local OptionSelecting= Instance.new("TextLabel")
            local OptionImg      = Instance.new("ImageLabel")

            Dropdown.BackgroundColor3=BG; Dropdown.BackgroundTransparency=TRANS
            Dropdown.BorderSizePixel=0; Dropdown.Size=UDim2.new(1,-2,0,H)
            Dropdown.Name="Dropdown"; Dropdown.Parent=ScrolLayers
            Dropdown.LayoutOrder=elementOrder; elementOrder+=1
            Instance.new("UICorner",Dropdown).CornerRadius=UDim.new(0,8)

            local DropCardStroke=Instance.new("UIStroke",Dropdown)
            DropCardStroke.Color=Color3.fromRGB(38,38,52); DropCardStroke.Thickness=1

            DropdownButton.BackgroundTransparency=1; DropdownButton.Size=UDim2.new(1,0,1,0)
            DropdownButton.Text=""; DropdownButton.Name="ToggleButton"; DropdownButton.Parent=Dropdown

            DropdownTitle.Font=Enum.Font.GothamBold; DropdownTitle.Text=cfg2.Title
            DropdownTitle.TextColor3=Color3.fromRGB(220,220,230); DropdownTitle.TextSize=isMobile and 14 or 13
            DropdownTitle.TextXAlignment=Enum.TextXAlignment.Left; DropdownTitle.BackgroundTransparency=1
            DropdownTitle.Position=UDim2.new(0,16,0,isMobile and 14 or 12)
            DropdownTitle.Size=UDim2.new(1,-170,0,14); DropdownTitle.Name="DropdownTitle"; DropdownTitle.Parent=Dropdown

            if cfg2.Content ~= "" then
                local DropdownContent=Instance.new("TextLabel")
                DropdownContent.Font=Enum.Font.Gotham; DropdownContent.Text=cfg2.Content
                DropdownContent.TextColor3=Color3.fromRGB(140,140,165); DropdownContent.TextSize=isMobile and 12 or 11
                DropdownContent.TextXAlignment=Enum.TextXAlignment.Left; DropdownContent.BackgroundTransparency=1
                DropdownContent.TextWrapped=true
                DropdownContent.Position=UDim2.new(0,16,0,(isMobile and 14 or 12)+16)
                DropdownContent.Size=UDim2.new(1,-170,0,13); DropdownContent.Parent=Dropdown
            end

            SelectFrame.AnchorPoint=Vector2.new(1,0.5); SelectFrame.BackgroundColor3=Color3.fromRGB(12,12,20)
            SelectFrame.BackgroundTransparency=0; SelectFrame.Position=UDim2.new(1,-8,0.5,0)
            SelectFrame.Size=UDim2.new(0,148,0,30); SelectFrame.Name="SelectOptionsFrame"; SelectFrame.Parent=Dropdown
            Instance.new("UICorner",SelectFrame).CornerRadius=UDim.new(0,7)

            
            local selColorFunc = cfg2.AnimColor and MakePulseFunc(cfg2.AnimColor) or accentColorFunc
            local SelStroke=Instance.new("UIStroke",SelectFrame)
            SelStroke.Thickness=1.2; SelStroke.Color=Color3.fromRGB(255,255,255)
            MakeAnimatedGradient(SelStroke,Dropdown,selColorFunc)

            OptionSelecting.Font=Enum.Font.GothamBold
            OptionSelecting.Text=cfg2.Multi and "Select Options" or "Select Option"
            OptionSelecting.TextColor3=Color3.fromRGB(255,255,255); OptionSelecting.TextSize=11
            OptionSelecting.TextTransparency=0.5; OptionSelecting.TextXAlignment=Enum.TextXAlignment.Left
            OptionSelecting.AnchorPoint=Vector2.new(0,0.5); OptionSelecting.BackgroundTransparency=1
            OptionSelecting.Position=UDim2.new(0,8,0.5,0); OptionSelecting.Size=UDim2.new(1,-30,1,-6)
            OptionSelecting.Name="OptionSelecting"; OptionSelecting.Parent=SelectFrame

            OptionImg.Image="rbxassetid://16851841101"; OptionImg.ImageColor3=Color3.fromRGB(180,180,200)
            OptionImg.AnchorPoint=Vector2.new(1,0.5); OptionImg.BackgroundTransparency=1
            OptionImg.Position=UDim2.new(1,-4,0.5,0); OptionImg.Size=UDim2.new(0,16,0,16); OptionImg.Parent=SelectFrame

            
            local Container=Instance.new("Frame")
            Container.Size=UDim2.new(1,0,1,0); Container.BackgroundTransparency=1
            Container.LayoutOrder=dropdownPageCounter; Container.Parent=DropdownFolder

            DropdownButton.Activated:Connect(function()
                if not MoreBlur.Visible then
                    MoreBlur.Visible=true
                    DropPageLayout:JumpTo(Container)
                    TweenService:Create(MoreBlur,TweenInfo.new(0.2),{BackgroundTransparency=0.5}):Play()
                    TweenService:Create(DropdownSelect,TweenInfo.new(0.3,Enum.EasingStyle.Back,Enum.EasingDirection.Out),
                        {Position=UDim2.new(1,-12,0.5,0)}):Play()
                    MakeAnimatedGradient(DropCardStroke,Dropdown,selColorFunc); DropCardStroke.Thickness=1.4
                end
            end)

            
            local SearchBox=Instance.new("TextBox")
            SearchBox.PlaceholderText="Search..."; SearchBox.Font=Enum.Font.Gotham; SearchBox.Text=""
            SearchBox.TextSize=12; SearchBox.TextColor3=Color3.fromRGB(240,240,255)
            SearchBox.PlaceholderColor3=Color3.fromRGB(90,90,110)
            SearchBox.BackgroundColor3=Color3.fromRGB(20,20,30); SearchBox.BackgroundTransparency=0
            SearchBox.BorderSizePixel=0; SearchBox.Size=UDim2.new(1,-16,0,30)
            SearchBox.Position=UDim2.new(0,8,0,8); SearchBox.ClearTextOnFocus=false
            SearchBox.Name="SearchBox"; SearchBox.Parent=Container
            Instance.new("UICorner",SearchBox).CornerRadius=UDim.new(0,7)
            local sbStroke=Instance.new("UIStroke",SearchBox)
            sbStroke.Color=Color3.fromRGB(40,40,58); sbStroke.Thickness=1

            local ScrollSelect=Instance.new("ScrollingFrame")
            ScrollSelect.Size=UDim2.new(1,0,1,-46); ScrollSelect.Position=UDim2.new(0,0,0,46)
            ScrollSelect.ScrollBarImageTransparency=1; ScrollSelect.BorderSizePixel=0
            ScrollSelect.BackgroundTransparency=1; ScrollSelect.ScrollBarThickness=0
            ScrollSelect.CanvasSize=UDim2.new(0,0,0,0); ScrollSelect.Name="ScrollSelect"
            ScrollSelect.Parent=Container

            local UIList4=Instance.new("UIListLayout")
            UIList4.Padding=UDim.new(0,2); UIList4.SortOrder=Enum.SortOrder.LayoutOrder; UIList4.Parent=ScrollSelect
            UIList4:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                ScrollSelect.CanvasSize=UDim2.new(0,0,0,UIList4.AbsoluteContentSize.Y)
            end)

            SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
                local q=string.lower(SearchBox.Text)
                for _,opt in pairs(ScrollSelect:GetChildren()) do
                    if opt.Name=="Option" and opt:FindFirstChild("OptionText") then
                        opt.Visible=q=="" or string.find(string.lower(opt.OptionText.Text),q,1,true)
                    end
                end
            end)

            function df:Clear()
                for _,f in ScrollSelect:GetChildren() do if f.Name=="Option" then f:Destroy() end end
                df.Value=cfg2.Multi and {} or nil; df.Options={}
                OptionSelecting.Text=cfg2.Multi and "Select Options" or "Select Option"
                OptionSelecting.TextTransparency=0.5; OptionSelecting.TextColor3=Color3.fromRGB(255,255,255)
                DropCardStroke.Color=Color3.fromRGB(38,38,52); DropCardStroke.Thickness=1
            end

            function df:AddOption(opt)
                local label,val
                if type(opt)=="table" and opt.Label and opt.Value~=nil then
                    label=tostring(opt.Label); val=opt.Value
                else label=tostring(opt); val=opt end

                local Option=Instance.new("Frame")
                local OptBtn=Instance.new("TextButton")
                local OptText=Instance.new("TextLabel")
                local AccentBar=Instance.new("Frame")
                local AccentStroke=Instance.new("UIStroke")

                Option.BackgroundTransparency=1; Option.Size=UDim2.new(1,0,0,isMobile and 36 or 32)
                Option.Name="Option"; Option.Parent=ScrollSelect
                Instance.new("UICorner",Option).CornerRadius=UDim.new(0,5)

                OptBtn.BackgroundTransparency=1; OptBtn.Size=UDim2.new(1,0,1,0)
                OptBtn.Text=""; OptBtn.Name="OptionButton"; OptBtn.Parent=Option

                OptText.Font=Enum.Font.GothamBold; OptText.Text=label
                OptText.TextSize=isMobile and 13 or 12; OptText.TextColor3=Color3.fromRGB(210,210,225)
                OptText.Position=UDim2.new(0,14,0,0); OptText.Size=UDim2.new(1,-18,1,0)
                OptText.BackgroundTransparency=1; OptText.TextXAlignment=Enum.TextXAlignment.Left
                OptText.Name="OptionText"; OptText.Parent=Option
                Option:SetAttribute("RealValue",val)

                AccentBar.AnchorPoint=Vector2.new(0,0.5); AccentBar.BackgroundColor3=GuiConfig.Color
                AccentBar.Position=UDim2.new(0,3,0.5,0); AccentBar.Size=UDim2.new(0,0,0,0)
                AccentBar.Name="ChooseFrame"; AccentBar.Parent=Option
                Instance.new("UICorner",AccentBar).CornerRadius=UDim.new(1,0)
                AccentStroke.Color=GuiConfig.Color; AccentStroke.Thickness=1.2
                AccentStroke.Transparency=0.999; AccentStroke.Parent=AccentBar

                if not isMobile then
                    OptBtn.MouseEnter:Connect(function()
                        if Option.BackgroundTransparency>0.6 then
                            TweenService:Create(Option,TweenInfo.new(0.1),{BackgroundTransparency=0.85}):Play()
                        end
                    end)
                    OptBtn.MouseLeave:Connect(function()
                        local sel=cfg2.Multi and tableFind(df.Value,val) or df.Value==val
                        if not sel then TweenService:Create(Option,TweenInfo.new(0.1),{BackgroundTransparency=1}):Play() end
                    end)
                end
                OptBtn.Activated:Connect(function()
                    if cfg2.Multi then
                        if not tableFind(df.Value,val) then table.insert(df.Value,val)
                        else for i,v in ipairs(df.Value) do if v==val then table.remove(df.Value,i);break end end end
                    else df.Value=val end
                    df:Set(df.Value)
                end)
            end

            function df:Set(val)
                if cfg2.Multi then df.Value=type(val)=="table" and val or {}
                else df.Value=(type(val)=="table" and val[1]) or val end
                ConfigData[key]=df.Value; SaveConfig()

                local texts={}; local anySelected=false
                local ti2=TweenInfo.new(0.18,Enum.EasingStyle.Quint)
                local ti1=TweenInfo.new(0.09)

                for _,drop in ScrollSelect:GetChildren() do
                    if drop.Name=="Option" and drop:FindFirstChild("OptionText") then
                        local v=drop:GetAttribute("RealValue")
                        local sel=cfg2.Multi and tableFind(df.Value,v) or df.Value==v
                        local bar=drop:FindFirstChild("ChooseFrame")
                        local bst=bar and bar:FindFirstChildWhichIsA("UIStroke")

                        if sel then
                            anySelected=true
                            if bar then TweenService:Create(bar,ti2,{Size=UDim2.new(0,2,0,16)}):Play() end
                            if bst then TweenService:Create(bst,ti2,{Transparency=0}):Play() end
                            TweenService:Create(drop,ti2,{BackgroundTransparency=0.88}):Play()
                            TweenService:Create(drop.OptionText,ti2,{TextColor3=GuiConfig.Color}):Play()
                            table.insert(texts,drop.OptionText.Text)
                        else
                            if bar then TweenService:Create(bar,ti1,{Size=UDim2.new(0,0,0,0)}):Play() end
                            if bst then TweenService:Create(bst,ti1,{Transparency=0.999}):Play() end
                            TweenService:Create(drop,ti1,{BackgroundTransparency=1}):Play()
                            TweenService:Create(drop.OptionText,ti1,{TextColor3=Color3.fromRGB(210,210,225)}):Play()
                        end
                    end
                end

                OptionSelecting.Text=(#texts==0) and (cfg2.Multi and "Select Options" or "Select Option") or table.concat(texts,", ")
                OptionSelecting.TextTransparency=anySelected and 0 or 0.5
                OptionSelecting.TextColor3=anySelected and GuiConfig.Color or Color3.fromRGB(255,255,255)

                if anySelected then
                    MakeAnimatedGradient(DropCardStroke,Dropdown,selColorFunc); DropCardStroke.Thickness=1.4
                else
                    DropCardStroke.Color=Color3.fromRGB(38,38,52); DropCardStroke.Thickness=1
                end

                if cfg2.Callback then
                    if cfg2.Multi then pcall(function() cfg2.Callback(df.Value) end)
                    else pcall(function() cfg2.Callback(df.Value~=nil and tostring(df.Value) or "") end) end
                end
            end

            function df:SetValue(v) self:Set(v) end
            function df:GetValue() return self.Value end
            function df:SetValues(list,sel)
                list=list or {}; sel=sel or (cfg2.Multi and {} or nil)
                df:Clear()
                for _,v in ipairs(list) do df:AddOption(v) end
                df.Options=list; df:Set(sel)
            end

            df:SetValues(df.Options,df.Value)
            dropdownPageCounter+=1; Elements[key]=df; return df
        end

        
        function TabItems:AddDiscord(DiscordConfig)
            DiscordConfig            = DiscordConfig            or {}
            DiscordConfig.Title      = DiscordConfig.Title      or "Discord Server"
            DiscordConfig.InviteCode = DiscordConfig.InviteCode or ""
            DiscordConfig.ServerIcon = DiscordConfig.ServerIcon or nil

            local CARD_H=isMobile and 92 or 82
            local card=Instance.new("Frame")
            card.BackgroundColor3=Color3.fromRGB(30,33,62)
            card.BackgroundTransparency=0.1; card.BorderSizePixel=0
            card.Size=UDim2.new(1,-2,0,CARD_H); card.Name="DiscordCard"
            card.LayoutOrder=elementOrder; elementOrder+=1; card.Parent=ScrolLayers
            Instance.new("UICorner",card).CornerRadius=UDim.new(0,10)

            local cardStroke=Instance.new("UIStroke",card)
            cardStroke.Color=Color3.fromRGB(88,101,242); cardStroke.Thickness=1.4
            MakeAnimatedGradient(cardStroke,card,MakePulseFunc(Color3.fromRGB(88,101,242)))

            
            local bgGrad=Instance.new("UIGradient",card)
            bgGrad.Color=ColorSequence.new{
                ColorSequenceKeypoint.new(0,Color3.fromRGB(40,45,85)),
                ColorSequenceKeypoint.new(1,Color3.fromRGB(18,18,30)),
            }; bgGrad.Rotation=135

            
            local iconHolder=Instance.new("Frame")
            iconHolder.BackgroundColor3=Color3.fromRGB(88,101,242)
            iconHolder.BackgroundTransparency=0; iconHolder.Size=UDim2.new(0,52,0,52)
            iconHolder.Position=UDim2.new(0,14,0.5,-26); iconHolder.Name="IconHolder"; iconHolder.Parent=card
            Instance.new("UICorner",iconHolder).CornerRadius=UDim.new(0,12)
            
            local iconShadow=Instance.new("UIStroke",iconHolder)
            iconShadow.Color=Color3.fromRGB(50,60,180); iconShadow.Thickness=1.5

            local serverIcon=Instance.new("ImageLabel")
            serverIcon.Image=DiscordConfig.ServerIcon or Icons.discord
            serverIcon.Size=UDim2.new(0.72,0,0.72,0); serverIcon.AnchorPoint=Vector2.new(0.5,0.5)
            serverIcon.Position=UDim2.new(0.5,0,0.5,0); serverIcon.BackgroundTransparency=1
            serverIcon.Parent=iconHolder

            
            local titleLbl=Instance.new("TextLabel")
            titleLbl.Font=Enum.Font.GothamBlack; titleLbl.Text=DiscordConfig.Title
            titleLbl.TextColor3=Color3.fromRGB(255,255,255)
            titleLbl.TextSize=isMobile and 15 or 14; titleLbl.TextXAlignment=Enum.TextXAlignment.Left
            titleLbl.BackgroundTransparency=1; titleLbl.Position=UDim2.new(0,78,0.5,-20)
            titleLbl.Size=UDim2.new(1,-180,0,18); titleLbl.Parent=card

            local subLbl=Instance.new("TextLabel")
            subLbl.Font=Enum.Font.Gotham
            subLbl.Text="discord.gg/"..DiscordConfig.InviteCode
            subLbl.TextColor3=Color3.fromRGB(160,165,220); subLbl.TextSize=isMobile and 12 or 11
            subLbl.TextXAlignment=Enum.TextXAlignment.Left; subLbl.BackgroundTransparency=1
            subLbl.Position=UDim2.new(0,78,0.5,-2); subLbl.Size=UDim2.new(1,-180,0,14); subLbl.Parent=card

            
            local JoinBtn=Instance.new("TextButton")
            JoinBtn.Font=Enum.Font.GothamBold; JoinBtn.Text="Join"
            JoinBtn.TextSize=isMobile and 13 or 12; JoinBtn.TextColor3=Color3.fromRGB(255,255,255)
            JoinBtn.BackgroundColor3=Color3.fromRGB(88,101,242); JoinBtn.BorderSizePixel=0
            JoinBtn.AnchorPoint=Vector2.new(1,0.5)
            JoinBtn.Size=UDim2.new(0,isMobile and 72 or 64,0,isMobile and 36 or 32)
            JoinBtn.Position=UDim2.new(1,-12,0.5,0); JoinBtn.Parent=card
            Instance.new("UICorner",JoinBtn).CornerRadius=UDim.new(0,8)

            
            local joinIcon=Instance.new("ImageLabel")
            joinIcon.Image=Icons.discord; joinIcon.BackgroundTransparency=1
            joinIcon.Size=UDim2.new(0,14,0,14); joinIcon.Position=UDim2.new(0,6,0.5,-7); joinIcon.Parent=JoinBtn

            
            local joinPad=Instance.new("UIPadding",JoinBtn)
            joinPad.PaddingLeft=UDim.new(0,22)

            local joinStroke=Instance.new("UIStroke",JoinBtn)
            joinStroke.Color=Color3.fromRGB(110,125,255); joinStroke.Thickness=1

            if not isMobile then
                JoinBtn.MouseEnter:Connect(function()
                    TweenService:Create(JoinBtn,TweenInfo.new(0.15),{BackgroundColor3=Color3.fromRGB(114,137,255)}):Play()
                end)
                JoinBtn.MouseLeave:Connect(function()
                    TweenService:Create(JoinBtn,TweenInfo.new(0.15),{BackgroundColor3=Color3.fromRGB(88,101,242)}):Play()
                end)
            end
            JoinBtn.Activated:Connect(function()
                CircleClick(JoinBtn,Mouse.X,Mouse.Y)
                local inv=DiscordConfig.InviteCode
                SafeSetClipboard("https://discord.gg/"..inv)
                blessedhubx("discord.gg/"..inv,4,Color3.fromRGB(88,101,242),"Discord","Invite copied!")
            end)

            local dc={}
            function dc:SetInvite(code) DiscordConfig.InviteCode=code; subLbl.Text="discord.gg/"..code end
            function dc:SetTitle(t) DiscordConfig.Title=t; titleLbl.Text=t end
            function dc:SetIcon(img) serverIcon.Image=img end
            return dc
        end

        
        function TabItems:AddDivider()
            local d=Instance.new("Frame")
            d.Name="Divider"; d.Size=UDim2.new(1,-4,0,1)
            d.AnchorPoint=Vector2.new(0.5,0); d.Position=UDim2.new(0.5,0,0,0)
            d.BackgroundColor3=Color3.fromRGB(255,255,255); d.BackgroundTransparency=0
            d.BorderSizePixel=0; d.LayoutOrder=elementOrder; elementOrder+=1; d.Parent=ScrolLayers
            local g=Instance.new("UIGradient",d)
            g.Color=ColorSequence.new{
                ColorSequenceKeypoint.new(0,Color3.fromRGB(16,16,22)),
                ColorSequenceKeypoint.new(0.5,GuiConfig.Color),
                ColorSequenceKeypoint.new(1,Color3.fromRGB(16,16,22)),
            }
            Instance.new("UICorner",d).CornerRadius=UDim.new(0,2)
            return d
        end

        CountTab+=1
        _G[TabConfig.Name:gsub("%s+","_")]=TabItems
        return TabItems
    end

    return Tabs
end

return BlessedHubX
