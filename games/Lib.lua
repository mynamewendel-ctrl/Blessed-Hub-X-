local Library = {}

function Library:CreateWindow(title)
	local ScreenGui = Instance.new("ScreenGui")
	local MainFrame = Instance.new("Frame")
	local UICorner = Instance.new("UICorner")
	local UIGradient = Instance.new("UIGradient")
	local Title = Instance.new("TextLabel")
	local MinimizeBtn = Instance.new("ImageButton")
	local ReopenBtn = Instance.new("ImageButton")
	local ReopenCorner = Instance.new("UICorner")
	local TabBar = Instance.new("Frame")
	local PagesFrame = Instance.new("Frame")
	local ResizeGrip = Instance.new("ImageButton") -- Para redimensionar
	
	local UserInputService = game:GetService("UserInputService")
	local TweenService = game:GetService("TweenService")
	
	-- Configuração da GUI
	local success, err = pcall(function()
		ScreenGui.Parent = game:GetService("CoreGui")
	end)
	if not success then
		ScreenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
	end
    
	ScreenGui.Name = "BlessedHubX - Panel"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	-- Botão Reabrir (Floating)
	ReopenBtn.Name = "Reopen"
	ReopenBtn.Parent = ScreenGui
	ReopenBtn.BackgroundColor3 = Color3.fromRGB(255, 20, 147)
	ReopenBtn.BackgroundTransparency = 0
	ReopenBtn.Position = UDim2.new(0, 15, 0.35, 0)
	ReopenBtn.Size = UDim2.new(0, 55, 0, 55)
	ReopenBtn.Image = "rbxassetid://108092552939283"
	ReopenBtn.Visible = false
	ReopenBtn.ZIndex = 10
	ReopenCorner.CornerRadius = UDim.new(1, 0)
	ReopenCorner.Parent = ReopenBtn

	-- Frame Principal
	MainFrame.Name = "MainFrame"
	MainFrame.Parent = ScreenGui
	MainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	MainFrame.BackgroundTransparency = 0
	MainFrame.Position = UDim2.new(0.5, -200, 0.5, -200) -- Tamanho inicial maior
	MainFrame.Size = UDim2.new(0, 400, 0, 450)
	MainFrame.BorderSizePixel = 0
	MainFrame.ZIndex = 1
	MainFrame.ClipsDescendants = true -- Importante para o redimensionamento
	
	UICorner.CornerRadius = UDim.new(0, 15)
	UICorner.Parent = MainFrame

	UIGradient.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(136, 19, 75)),
		ColorSequenceKeypoint.new(0.4, Color3.fromRGB(190, 24, 93)),
		ColorSequenceKeypoint.new(0.7, Color3.fromRGB(219, 39, 119)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(112, 16, 60))
	}
	UIGradient.Rotation = 115
	UIGradient.Parent = MainFrame

	-- Título
	Title.Name = "Title"
	Title.Parent = MainFrame
	Title.BackgroundTransparency = 1
	Title.Position = UDim2.new(0, 15, 0, 0)
	Title.Size = UDim2.new(1, -50, 0, 50)
	Title.Font = Enum.Font.GothamBold
	Title.Text = title
	Title.TextColor3 = Color3.fromRGB(255, 255, 255)
	Title.TextSize = 18
	Title.TextXAlignment = Enum.TextXAlignment.Left
	Title.ZIndex = 2

	local Gradient = Instance.new("UIGradient")
	Gradient.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 150, 210)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 50, 170))
	}
	Gradient.Rotation = 90
	Gradient.Parent = Title

	-- Botão Minimizar
	MinimizeBtn.Name = "Minimize"
	MinimizeBtn.Parent = MainFrame
	MinimizeBtn.BackgroundTransparency = 1
	MinimizeBtn.Position = UDim2.new(1, -35, 0, 12)
	MinimizeBtn.Size = UDim2.new(0, 22, 0, 22)
	MinimizeBtn.Image = "rbxassetid://9886659671"
	MinimizeBtn.ImageColor3 = Color3.fromRGB(255, 255, 255)
	MinimizeBtn.ZIndex = 5

	-- Barra de Abas
	TabBar.Name = "TabBar"
	TabBar.Parent = MainFrame
	TabBar.BackgroundTransparency = 1
	TabBar.Position = UDim2.new(0, 10, 0, 50)
	TabBar.Size = UDim2.new(1, -20, 0, 40)
	TabBar.ZIndex = 6

	-- Frame que conterá as páginas (cada aba tem uma página)
	PagesFrame.Name = "PagesFrame"
	PagesFrame.Parent = MainFrame
	PagesFrame.BackgroundTransparency = 1
	PagesFrame.Position = UDim2.new(0, 10, 0, 95)
	PagesFrame.Size = UDim2.new(1, -20, 1, -105)
	PagesFrame.ZIndex = 2

	-- Grip para redimensionar (canto inferior direito)
	ResizeGrip.Name = "ResizeGrip"
	ResizeGrip.Parent = MainFrame
	ResizeGrip.BackgroundTransparency = 1
	ResizeGrip.Position = UDim2.new(1, -20, 1, -20)
	ResizeGrip.Size = UDim2.new(0, 20, 0, 20)
	ResizeGrip.Image = "rbxassetid://6031090990" -- ícone de seta diagonal
	ResizeGrip.ImageColor3 = Color3.fromRGB(255, 255, 255)
	ResizeGrip.ZIndex = 10
	ResizeGrip.Visible = true

	-- Sistema de Arrastar (janela)
	local function EnableDrag(frame)
		local dragging, dragInput, dragStart, startPos
		frame.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				dragging = true
				dragStart = input.Position
				startPos = frame.Position
				input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then
						dragging = false
					end
				end)
			end
		end)
		frame.InputChanged:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
				dragInput = input
			end
		end)
		UserInputService.InputChanged:Connect(function(input)
			if input == dragInput and dragging then
				local delta = input.Position - dragStart
				frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
			end
		end)
	end
	EnableDrag(MainFrame)
	EnableDrag(ReopenBtn)

	-- Sistema de Redimensionamento ao vivo
	local resizing = false
	local resizeStart, startSize, startPosMouse

	ResizeGrip.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			resizing = true
			resizeStart = input.Position
			startSize = MainFrame.Size
			startPosMouse = input.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					resizing = false
				end
			end)
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - resizeStart
			local newWidth = math.max(300, startSize.X.Offset + delta.X)
			local newHeight = math.max(250, startSize.Y.Offset + delta.Y)
			MainFrame.Size = UDim2.new(0, newWidth, 0, newHeight)
		end
	end)

	-- Comportamento Minimizar
	MinimizeBtn.MouseButton1Click:Connect(function()
		MainFrame.Visible = false
		ReopenBtn.Visible = true
	end)
	ReopenBtn.MouseButton1Click:Connect(function()
		MainFrame.Visible = true
		ReopenBtn.Visible = false
	end)

	-- Tabela para armazenar abas e suas páginas
	local Tabs = {}
	local ActiveTab = nil
	local DefaultTab = nil

	-- Função para criar uma nova aba
	local function CreateTab(tabName, iconAssetId)
		iconAssetId = iconAssetId or "108092552939283" -- ícone padrão

		-- Botão da aba (somente ícone)
		local TabButton = Instance.new("ImageButton")
		TabButton.Name = "TabButton_" .. tabName
		TabButton.Parent = TabBar
		TabButton.BackgroundTransparency = 1
		TabButton.Size = UDim2.new(0, 40, 0, 40)
		TabButton.Position = UDim2.new(0, (#Tabs * 45), 0, 0) -- espaçamento
		TabButton.Image = "rbxassetid://" .. iconAssetId
		TabButton.ImageColor3 = Color3.fromRGB(255, 255, 255)
		TabButton.ZIndex = 7

		-- Tooltip com o nome da aba (aparece ao pairar)
		local Tooltip = Instance.new("TextLabel")
		Tooltip.Name = "Tooltip"
		Tooltip.Parent = TabButton
		Tooltip.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
		Tooltip.BackgroundTransparency = 0.2
		Tooltip.Position = UDim2.new(0.5, 0, 1, 5)
		Tooltip.Size = UDim2.new(0, 0, 0, 20)
		Tooltip.Font = Enum.Font.Gotham
		Tooltip.Text = tabName
		Tooltip.TextColor3 = Color3.fromRGB(255, 255, 255)
		Tooltip.TextSize = 12
		Tooltip.Visible = false
		Tooltip.ZIndex = 8
		local tooltipCorner = Instance.new("UICorner")
		tooltipCorner.CornerRadius = UDim.new(0, 4)
		tooltipCorner.Parent = Tooltip
		-- Ajustar tamanho ao texto
		Tooltip.Size = UDim2.new(0, Tooltip.TextBounds.X + 10, 0, 20)

		TabButton.MouseEnter:Connect(function()
			Tooltip.Visible = true
		end)
		TabButton.MouseLeave:Connect(function()
			Tooltip.Visible = false
		end)

		-- Página da aba (ScrollingFrame)
		local Page = Instance.new("ScrollingFrame")
		Page.Name = "Page_" .. tabName
		Page.Parent = PagesFrame
		Page.BackgroundTransparency = 1
		Page.Size = UDim2.new(1, 0, 1, 0)
		Page.CanvasSize = UDim2.new(0, 0, 0, 0)
		Page.ScrollBarThickness = 0
		Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
		Page.Visible = (#Tabs == 0) -- primeira aba visível
		Page.ZIndex = 3

		local UIListLayout = Instance.new("UIListLayout")
		UIListLayout.Parent = Page
		UIListLayout.Padding = UDim.new(0, 6)
		UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

		-- Atualizar canvas size dinamicamente
		UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			Page.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 10)
		end)

		-- Objeto da aba que será retornado
		local TabObj = {
			Name = tabName,
			Button = TabButton,
			Page = Page,
			Layout = UIListLayout,
			OrderCounter = 0,
		}

		-- Métodos para adicionar elementos à página
		function TabObj:CreateParagraph(text)
			self.OrderCounter = self.OrderCounter + 1
			local ParagraphFrame = Instance.new("Frame")
			local ParagraphLabel = Instance.new("TextLabel")
			local UICornerP = Instance.new("UICorner")
			local UIPaddingP = Instance.new("UIPadding")

			ParagraphFrame.Name = "Paragraph_" .. self.OrderCounter
			ParagraphFrame.Parent = self.Page
			ParagraphFrame.LayoutOrder = self.OrderCounter
			ParagraphFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			ParagraphFrame.BackgroundTransparency = 0.85
			ParagraphFrame.Size = UDim2.new(1, -5, 0, 0)
			ParagraphFrame.AutomaticSize = Enum.AutomaticSize.Y
			ParagraphFrame.ZIndex = 3

			UICornerP.CornerRadius = UDim.new(0, 8)
			UICornerP.Parent = ParagraphFrame

			UIPaddingP.Parent = ParagraphFrame
			UIPaddingP.PaddingBottom = UDim.new(0, 8)
			UIPaddingP.PaddingLeft = UDim.new(0, 10)
			UIPaddingP.PaddingRight = UDim.new(0, 10)
			UIPaddingP.PaddingTop = UDim.new(0, 8)

			ParagraphLabel.Name = "Text"
			ParagraphLabel.Parent = ParagraphFrame
			ParagraphLabel.BackgroundTransparency = 1
			ParagraphLabel.Size = UDim2.new(1, 0, 0, 0)
			ParagraphLabel.AutomaticSize = Enum.AutomaticSize.Y
			ParagraphLabel.Font = Enum.Font.GothamBold
			ParagraphLabel.Text = text
			ParagraphLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			ParagraphLabel.TextSize = 13
			ParagraphLabel.TextWrapped = true
			ParagraphLabel.TextXAlignment = Enum.TextXAlignment.Left
			ParagraphLabel.ZIndex = 4
			ParagraphLabel.RichText = true

			local ParaMethods = {}
			function ParaMethods:SetText(newText)
				ParagraphLabel.Text = newText
			end
			return ParaMethods
		end

		function TabObj:CreateButton(text, iconID, callback)
			self.OrderCounter = self.OrderCounter + 1
			local Button = Instance.new("TextButton")
			local BtnCorner = Instance.new("UICorner")
			local Icon = Instance.new("ImageLabel")
			local Padding = Instance.new("UIPadding")

			Button.Name = "Button_" .. self.OrderCounter
			Button.Parent = self.Page
			Button.LayoutOrder = self.OrderCounter
			Button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Button.BackgroundTransparency = 0.85
			Button.Size = UDim2.new(1, -5, 0, 40)
			Button.Font = Enum.Font.GothamSemibold
			Button.Text = text
			Button.TextColor3 = Color3.fromRGB(255, 255, 255)
			Button.TextSize = 14
			Button.TextXAlignment = Enum.TextXAlignment.Left
			Button.ZIndex = 3

			Padding.Parent = Button
			Padding.PaddingLeft = UDim.new(0, 15)

			BtnCorner.CornerRadius = UDim.new(0, 8)
			BtnCorner.Parent = Button

			Icon.Name = "Icon"
			Icon.Parent = Button
			Icon.BackgroundTransparency = 1
			Icon.Position = UDim2.new(1, -35, 0.5, -11)
			Icon.Size = UDim2.new(0, 22, 0, 22)
			Icon.Image = "rbxassetid://" .. (iconID or "108092552939283")
			Icon.ZIndex = 4

			Button.MouseButton1Click:Connect(callback)
		end

		function TabObj:CreateToggle(text, callback)
			self.OrderCounter = self.OrderCounter + 1
			local Toggled = false
			local ToggleBtn = Instance.new("TextButton")
			local Indicator = Instance.new("Frame")
			local Dot = Instance.new("Frame")

			ToggleBtn.Name = "Toggle_" .. self.OrderCounter
			ToggleBtn.Parent = self.Page
			ToggleBtn.LayoutOrder = self.OrderCounter
			ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			ToggleBtn.BackgroundTransparency = 0.85
			ToggleBtn.Size = UDim2.new(1, -5, 0, 40)
			ToggleBtn.Text = "  " .. text
			ToggleBtn.Font = Enum.Font.GothamSemibold
			ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
			ToggleBtn.TextSize = 14
			ToggleBtn.TextXAlignment = Enum.TextXAlignment.Left
			Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 8)

			Indicator.Parent = ToggleBtn
			Indicator.Position = UDim2.new(1, -50, 0.5, -10)
			Indicator.Size = UDim2.new(0, 35, 0, 20)
			Indicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Indicator.BackgroundTransparency = 0.5
			Instance.new("UICorner", Indicator).CornerRadius = UDim.new(1, 0)

			Dot.Parent = Indicator
			Dot.Size = UDim2.new(0, 14, 0, 14)
			Dot.Position = UDim2.new(0, 3, 0.5, -7)
			Dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)

			ToggleBtn.MouseButton1Click:Connect(function()
				Toggled = not Toggled
				local goalPos = Toggled and UDim2.new(0, 18, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
				local goalColor = Toggled and Color3.fromRGB(255, 20, 147) or Color3.fromRGB(255, 255, 255)
				TweenService:Create(Dot, TweenInfo.new(0.2), {Position = goalPos}):Play()
				TweenService:Create(Dot, TweenInfo.new(0.2), {BackgroundColor3 = goalColor}):Play()
				callback(Toggled)
			end)
		end

		-- Seção
		function TabObj:CreateSection(sectionTitle, alwaysOpen)
			sectionTitle = sectionTitle or "Section"
			local sectionOrder = self.OrderCounter + 1
			self.OrderCounter = sectionOrder

			local Section = Instance.new("Frame")
			Section.Name = "Section_" .. sectionOrder
			Section.Parent = self.Page
			Section.LayoutOrder = sectionOrder
			Section.BackgroundTransparency = 1
			Section.Size = UDim2.new(1, -5, 0, 30)
			Section.ClipsDescendants = true

			-- Cabeçalho da seção
			local Header = Instance.new("Frame")
			Header.Name = "Header"
			Header.Parent = Section
			Header.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Header.BackgroundTransparency = 0.935
			Header.Size = UDim2.new(1, 0, 0, 30)
			local headerCorner = Instance.new("UICorner")
			headerCorner.CornerRadius = UDim.new(0, 4)
			headerCorner.Parent = Header

			local TitleLabel = Instance.new("TextLabel")
			TitleLabel.Parent = Header
			TitleLabel.BackgroundTransparency = 1
			TitleLabel.Position = UDim2.new(0, 10, 0, 0)
			TitleLabel.Size = UDim2.new(1, -50, 1, 0)
			TitleLabel.Font = Enum.Font.GothamBold
			TitleLabel.Text = sectionTitle
			TitleLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
			TitleLabel.TextSize = 13
			TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

			local ToggleIcon = Instance.new("ImageLabel")
			ToggleIcon.Parent = Header
			ToggleIcon.BackgroundTransparency = 1
			ToggleIcon.Position = UDim2.new(1, -30, 0.5, -10)
			ToggleIcon.Size = UDim2.new(0, 20, 0, 20)
			ToggleIcon.Image = "rbxassetid://16851841101"
			ToggleIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
			ToggleIcon.Rotation = alwaysOpen and 90 or 0

			-- Botão invisível para clique
			local HeaderButton = Instance.new("TextButton")
			HeaderButton.Parent = Header
			HeaderButton.BackgroundTransparency = 1
			HeaderButton.Size = UDim2.new(1, 0, 1, 0)
			HeaderButton.Text = ""

			-- Container interno (onde os elementos serão inseridos)
			local Container = Instance.new("Frame")
			Container.Name = "Container"
			Container.Parent = Section
			Container.BackgroundTransparency = 1
			Container.Position = UDim2.new(0, 0, 0, 33)
			Container.Size = UDim2.new(1, 0, 0, 0)
			Container.ClipsDescendants = true

			local ContainerList = Instance.new("UIListLayout")
			ContainerList.Parent = Container
			ContainerList.Padding = UDim.new(0, 3)
			ContainerList.SortOrder = Enum.SortOrder.LayoutOrder
			ContainerList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
				Container.Size = UDim2.new(1, 0, 0, ContainerList.AbsoluteContentSize.Y)
			end)

			local open = alwaysOpen == nil and false or alwaysOpen
			if open then
				Section.Size = UDim2.new(1, -5, 0, 33 + ContainerList.AbsoluteContentSize.Y)
				Container.Size = UDim2.new(1, 0, 0, ContainerList.AbsoluteContentSize.Y)
				ToggleIcon.Rotation = 90
			else
				Section.Size = UDim2.new(1, -5, 0, 30)
				Container.Size = UDim2.new(1, 0, 0, 0)
			end

			if not alwaysOpen then
				HeaderButton.MouseButton1Click:Connect(function()
					open = not open
					local targetSize = open and UDim2.new(1, -5, 0, 33 + ContainerList.AbsoluteContentSize.Y) or UDim2.new(1, -5, 0, 30)
					TweenService:Create(Section, TweenInfo.new(0.3), {Size = targetSize}):Play()
					TweenService:Create(ToggleIcon, TweenInfo.new(0.3), {Rotation = open and 90 or 0}):Play()
				end)
			end

			-- Objeto da seção para adicionar elementos
			local SectionObj = {
				Container = Container,
				ListLayout = ContainerList,
				OrderCounter = 0,
			}

			function SectionObj:CreateButton(text, iconID, callback)
				self.OrderCounter = self.OrderCounter + 1
				local Button = Instance.new("TextButton")
				local BtnCorner = Instance.new("UICorner")
				local Icon = Instance.new("ImageLabel")
				local Padding = Instance.new("UIPadding")

				Button.Name = "SectionButton_" .. self.OrderCounter
				Button.Parent = self.Container
				Button.LayoutOrder = self.OrderCounter
				Button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Button.BackgroundTransparency = 0.85
				Button.Size = UDim2.new(1, -5, 0, 40)
				Button.Font = Enum.Font.GothamSemibold
				Button.Text = text
				Button.TextColor3 = Color3.fromRGB(255, 255, 255)
				Button.TextSize = 14
				Button.TextXAlignment = Enum.TextXAlignment.Left
				Button.ZIndex = 3

				Padding.Parent = Button
				Padding.PaddingLeft = UDim.new(0, 15)

				BtnCorner.CornerRadius = UDim.new(0, 8)
				BtnCorner.Parent = Button

				Icon.Name = "Icon"
				Icon.Parent = Button
				Icon.BackgroundTransparency = 1
				Icon.Position = UDim2.new(1, -35, 0.5, -11)
				Icon.Size = UDim2.new(0, 22, 0, 22)
				Icon.Image = "rbxassetid://" .. (iconID or "108092552939283")
				Icon.ZIndex = 4

				Button.MouseButton1Click:Connect(callback)
			end

			function SectionObj:CreateToggle(text, callback)
				self.OrderCounter = self.OrderCounter + 1
				local Toggled = false
				local ToggleBtn = Instance.new("TextButton")
				local Indicator = Instance.new("Frame")
				local Dot = Instance.new("Frame")

				ToggleBtn.Name = "SectionToggle_" .. self.OrderCounter
				ToggleBtn.Parent = self.Container
				ToggleBtn.LayoutOrder = self.OrderCounter
				ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				ToggleBtn.BackgroundTransparency = 0.85
				ToggleBtn.Size = UDim2.new(1, -5, 0, 40)
				ToggleBtn.Text = "  " .. text
				ToggleBtn.Font = Enum.Font.GothamSemibold
				ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
				ToggleBtn.TextSize = 14
				ToggleBtn.TextXAlignment = Enum.TextXAlignment.Left
				Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 8)

				Indicator.Parent = ToggleBtn
				Indicator.Position = UDim2.new(1, -50, 0.5, -10)
				Indicator.Size = UDim2.new(0, 35, 0, 20)
				Indicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Indicator.BackgroundTransparency = 0.5
				Instance.new("UICorner", Indicator).CornerRadius = UDim.new(1, 0)

				Dot.Parent = Indicator
				Dot.Size = UDim2.new(0, 14, 0, 14)
				Dot.Position = UDim2.new(0, 3, 0.5, -7)
				Dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)

				ToggleBtn.MouseButton1Click:Connect(function()
					Toggled = not Toggled
					local goalPos = Toggled and UDim2.new(0, 18, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
					local goalColor = Toggled and Color3.fromRGB(255, 20, 147) or Color3.fromRGB(255, 255, 255)
					TweenService:Create(Dot, TweenInfo.new(0.2), {Position = goalPos}):Play()
					TweenService:Create(Dot, TweenInfo.new(0.2), {BackgroundColor3 = goalColor}):Play()
					callback(Toggled)
				end)
			end

			function SectionObj:CreateSlider(config)
				config = config or {}
				config.Title = config.Title or "Slider"
				config.Description = config.Description or ""
				config.Min = config.Min or 0
				config.Max = config.Max or 100
				config.Default = config.Default or 50
				config.Increment = config.Increment or 1
				config.Callback = config.Callback or function() end

				self.OrderCounter = self.OrderCounter + 1
				local SliderFrame = Instance.new("Frame")
				local UICorner = Instance.new("UICorner")
				local Title = Instance.new("TextLabel")
				local Desc = Instance.new("TextLabel")
				local InputFrame = Instance.new("Frame")
				local TextBox = Instance.new("TextBox")
				local Bar = Instance.new("Frame")
				local BarCorner = Instance.new("UICorner")
				local Fill = Instance.new("Frame")
				local FillCorner = Instance.new("UICorner")
				local Circle = Instance.new("Frame")
				local CircleCorner = Instance.new("UICorner")

				SliderFrame.Name = "Slider_" .. self.OrderCounter
				SliderFrame.Parent = self.Container
				SliderFrame.LayoutOrder = self.OrderCounter
				SliderFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				SliderFrame.BackgroundTransparency = 0.935
				SliderFrame.Size = UDim2.new(1, -5, 0, 60)
				SliderFrame.BorderSizePixel = 0

				UICorner.CornerRadius = UDim.new(0, 4)
				UICorner.Parent = SliderFrame

				Title.Font = Enum.Font.GothamBold
				Title.Text = config.Title
				Title.TextColor3 = Color3.fromRGB(230, 230, 230)
				Title.TextSize = 13
				Title.TextXAlignment = Enum.TextXAlignment.Left
				Title.BackgroundTransparency = 1
				Title.Position = UDim2.new(0, 10, 0, 8)
				Title.Size = UDim2.new(1, -120, 0, 16)
				Title.Parent = SliderFrame

				Desc.Font = Enum.Font.Gotham
				Desc.Text = config.Description
				Desc.TextColor3 = Color3.fromRGB(200, 200, 200)
				Desc.TextSize = 11
				Desc.TextXAlignment = Enum.TextXAlignment.Left
				Desc.BackgroundTransparency = 1
				Desc.Position = UDim2.new(0, 10, 0, 26)
				Desc.Size = UDim2.new(1, -120, 0, 14)
				Desc.Parent = SliderFrame

				InputFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				InputFrame.BackgroundTransparency = 0.8
				InputFrame.Position = UDim2.new(1, -80, 0, 10)
				InputFrame.Size = UDim2.new(0, 60, 0, 22)
				InputFrame.Parent = SliderFrame
				Instance.new("UICorner", InputFrame).CornerRadius = UDim.new(0, 4)

				TextBox.Font = Enum.Font.Gotham
				TextBox.Text = tostring(config.Default)
				TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
				TextBox.TextSize = 12
				TextBox.BackgroundTransparency = 1
				TextBox.Size = UDim2.new(1, 0, 1, 0)
				TextBox.Parent = InputFrame

				Bar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Bar.BackgroundTransparency = 0.8
				Bar.Position = UDim2.new(0, 10, 0, 44)
				Bar.Size = UDim2.new(1, -90, 0, 4)
				Bar.Parent = SliderFrame
				BarCorner.CornerRadius = UDim.new(1, 0)
				BarCorner.Parent = Bar

				Fill.BackgroundColor3 = Color3.fromRGB(255, 20, 147)
				Fill.Size = UDim2.new((config.Default - config.Min) / (config.Max - config.Min), 0, 1, 0)
				Fill.Parent = Bar
				FillCorner.CornerRadius = UDim.new(1, 0)
				FillCorner.Parent = Fill

				Circle.BackgroundColor3 = Color3.fromRGB(255, 20, 147)
				Circle.Position = UDim2.new(1, -4, 0.5, -6)
				Circle.Size = UDim2.new(0, 12, 0, 12)
				Circle.Parent = Fill
				CircleCorner.CornerRadius = UDim.new(1, 0)
				CircleCorner.Parent = Circle

				local sliderValue = config.Default
				local dragging = false

				local function updateSliderFromValue(val)
					val = math.clamp(val, config.Min, config.Max)
					val = math.floor(val / config.Increment + 0.5) * config.Increment
					sliderValue = val
					TextBox.Text = tostring(val)
					local percent = (val - config.Min) / (config.Max - config.Min)
					Fill.Size = UDim2.new(percent, 0, 1, 0)
					config.Callback(val)
				end

				local function updateSliderFromMouse(input)
					local pos = input.Position.X
					local barPos = Bar.AbsolutePosition.X
					local barSize = Bar.AbsoluteSize.X
					local percent = math.clamp((pos - barPos) / barSize, 0, 1)
					local val = config.Min + percent * (config.Max - config.Min)
					updateSliderFromValue(val)
				end

				Bar.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						dragging = true
						updateSliderFromMouse(input)
					end
				end)

				Bar.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						dragging = false
					end
				end)

				UserInputService.InputChanged:Connect(function(input)
					if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
						updateSliderFromMouse(input)
					end
				end)

				TextBox.FocusLost:Connect(function()
					local val = tonumber(TextBox.Text) or config.Default
					updateSliderFromValue(val)
				end)

				updateSliderFromValue(config.Default)

				return {
					Set = updateSliderFromValue,
					Get = function() return sliderValue end
				}
			end

			function SectionObj:CreateDropdown(config)
				config = config or {}
				config.Title = config.Title or "Dropdown"
				config.Description = config.Description or ""
				config.Options = config.Options or {}
				config.Multi = config.Multi or false
				config.Default = config.Default or (config.Multi and {} or nil)
				config.Callback = config.Callback or function() end

				self.OrderCounter = self.OrderCounter + 1
				local DropdownFrame = Instance.new("Frame")
				local UICorner = Instance.new("UICorner")
				local Title = Instance.new("TextLabel")
				local Desc = Instance.new("TextLabel")
				local SelectFrame = Instance.new("Frame")
				local SelectLabel = Instance.new("TextLabel")
				local Arrow = Instance.new("ImageLabel")
				local DropdownList = Instance.new("Frame")
				local ListLayout = Instance.new("UIListLayout")
				local SearchBox = Instance.new("TextBox")

				DropdownFrame.Name = "Dropdown_" .. self.OrderCounter
				DropdownFrame.Parent = self.Container
				DropdownFrame.LayoutOrder = self.OrderCounter
				DropdownFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				DropdownFrame.BackgroundTransparency = 0.935
				DropdownFrame.Size = UDim2.new(1, -5, 0, 60)
				DropdownFrame.BorderSizePixel = 0
				DropdownFrame.ClipsDescendants = true

				UICorner.CornerRadius = UDim.new(0, 4)
				UICorner.Parent = DropdownFrame

				Title.Font = Enum.Font.GothamBold
				Title.Text = config.Title
				Title.TextColor3 = Color3.fromRGB(230, 230, 230)
				Title.TextSize = 13
				Title.TextXAlignment = Enum.TextXAlignment.Left
				Title.BackgroundTransparency = 1
				Title.Position = UDim2.new(0, 10, 0, 8)
				Title.Size = UDim2.new(1, -120, 0, 16)
				Title.Parent = DropdownFrame

				Desc.Font = Enum.Font.Gotham
				Desc.Text = config.Description
				Desc.TextColor3 = Color3.fromRGB(200, 200, 200)
				Desc.TextSize = 11
				Desc.TextXAlignment = Enum.TextXAlignment.Left
				Desc.BackgroundTransparency = 1
				Desc.Position = UDim2.new(0, 10, 0, 26)
				Desc.Size = UDim2.new(1, -120, 0, 14)
				Desc.Parent = DropdownFrame

				SelectFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				SelectFrame.BackgroundTransparency = 0.9
				SelectFrame.Position = UDim2.new(0, 10, 0, 44)
				SelectFrame.Size = UDim2.new(1, -20, 0, 24)
				SelectFrame.Parent = DropdownFrame
				Instance.new("UICorner", SelectFrame).CornerRadius = UDim.new(0, 4)

				SelectLabel.Font = Enum.Font.Gotham
				SelectLabel.Text = config.Multi and "Selecione..." or "Selecione..."
				SelectLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
				SelectLabel.TextSize = 12
				SelectLabel.TextXAlignment = Enum.TextXAlignment.Left
				SelectLabel.BackgroundTransparency = 1
				SelectLabel.Position = UDim2.new(0, 8, 0, 0)
				SelectLabel.Size = UDim2.new(1, -40, 1, 0)
				SelectLabel.Parent = SelectFrame

				Arrow.Image = "rbxassetid://16851841101"
				Arrow.ImageColor3 = Color3.fromRGB(255, 255, 255)
				Arrow.BackgroundTransparency = 1
				Arrow.Position = UDim2.new(1, -22, 0.5, -10)
				Arrow.Size = UDim2.new(0, 16, 0, 16)
				Arrow.Rotation = 0
				Arrow.Parent = SelectFrame

				DropdownList.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
				DropdownList.BackgroundTransparency = 0.1
				DropdownList.Position = UDim2.new(0, 10, 0, 70)
				DropdownList.Size = UDim2.new(1, -20, 0, 0)
				DropdownList.Visible = false
				DropdownList.Parent = DropdownFrame
				Instance.new("UICorner", DropdownList).CornerRadius = UDim.new(0, 4)

				ListLayout.Parent = DropdownList
				ListLayout.Padding = UDim.new(0, 2)
				ListLayout.SortOrder = Enum.SortOrder.LayoutOrder

				SearchBox.PlaceholderText = "Buscar..."
				SearchBox.Font = Enum.Font.Gotham
				SearchBox.Text = ""
				SearchBox.TextSize = 12
				SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
				SearchBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
				SearchBox.BackgroundTransparency = 0.3
				SearchBox.Size = UDim2.new(1, -10, 0, 24)
				SearchBox.Position = UDim2.new(0, 5, 0, 5)
				SearchBox.ClearTextOnFocus = false
				SearchBox.Parent = DropdownList

				local options = {}
				local selected = config.Default or (config.Multi and {} or nil)

				local function updateSelectionText()
					if config.Multi then
						local count = #selected
						SelectLabel.Text = count == 0 and "Selecione..." or (count .. " selecionado(s)")
					else
						SelectLabel.Text = selected or "Selecione..."
					end
				end

				local function createOption(opt)
					local label = type(opt) == "table" and opt.Label or tostring(opt)
					local value = type(opt) == "table" and opt.Value or opt

					local Option = Instance.new("Frame")
					Option.Name = "Option"
					Option.BackgroundTransparency = 1
					Option.Size = UDim2.new(1, -10, 0, 28)
					Option.Parent = DropdownList

					local OptionLabel = Instance.new("TextLabel")
					OptionLabel.Font = Enum.Font.Gotham
					OptionLabel.Text = label
					OptionLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
					OptionLabel.TextSize = 12
					OptionLabel.TextXAlignment = Enum.TextXAlignment.Left
					OptionLabel.BackgroundTransparency = 1
					OptionLabel.Position = UDim2.new(0, 30, 0, 0)
					OptionLabel.Size = UDim2.new(1, -40, 1, 0)
					OptionLabel.Parent = Option

					local Check = Instance.new("Frame")
					Check.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					Check.BackgroundTransparency = 0.7
					Check.Position = UDim2.new(0, 6, 0.5, -8)
					Check.Size = UDim2.new(0, 16, 0, 16)
					Instance.new("UICorner", Check).CornerRadius = UDim.new(0, 4)
					Check.Parent = Option

					local CheckMark = Instance.new("Frame")
					CheckMark.BackgroundColor3 = Color3.fromRGB(255, 20, 147)
					CheckMark.Size = UDim2.new(0, 0, 0, 0)
					CheckMark.Position = UDim2.new(0.5, -4, 0.5, -4)
					CheckMark.Size = UDim2.new(0, 8, 0, 8)
					CheckMark.Visible = false
					Instance.new("UICorner", CheckMark).CornerRadius = UDim.new(0, 2)
					CheckMark.Parent = Check

					local Button = Instance.new("TextButton")
					Button.BackgroundTransparency = 1
					Button.Size = UDim2.new(1, 0, 1, 0)
					Button.Text = ""
					Button.Parent = Option

					local isSelected = false
					if config.Multi then
						isSelected = table.find(selected, value) ~= nil
					else
						isSelected = selected == value
					end
					if isSelected then
						CheckMark.Visible = true
						CheckMark.Size = UDim2.new(0, 8, 0, 8)
					end

					Button.MouseButton1Click:Connect(function()
						if config.Multi then
							if table.find(selected, value) then
								for i, v in ipairs(selected) do
									if v == value then
										table.remove(selected, i)
										break
									end
								end
								CheckMark.Visible = false
							else
								table.insert(selected, value)
								CheckMark.Visible = true
							end
							config.Callback(selected)
						else
							selected = value
							for _, optFrame in ipairs(DropdownList:GetChildren()) do
								if optFrame:IsA("Frame") and optFrame.Name == "Option" then
									local mark = optFrame:FindFirstChild("Check"):FindFirstChild("CheckMark")
									if mark then
										mark.Visible = false
									end
								end
							end
							CheckMark.Visible = true
							config.Callback(value)
							toggleDropdown(false)
						end
						updateSelectionText()
					end)

					return Option
				end

				for _, opt in ipairs(config.Options) do
					table.insert(options, createOption(opt))
				end

				-- Atualizar lista ao buscar
				SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
					local query = SearchBox.Text:lower()
					for _, opt in ipairs(options) do
						local lbl = opt:FindFirstChild("TextLabel")
						if lbl then
							opt.Visible = query == "" or lbl.Text:lower():find(query, 1, true)
						end
					end
					-- Ajustar altura da lista
					local visibleCount = 0
					for _, opt in ipairs(options) do
						if opt.Visible then visibleCount = visibleCount + 1 end
					end
					DropdownList.Size = UDim2.new(1, -20, 0, math.min(visibleCount * 30 + 40, 200))
				end)

				local function toggleDropdown(show)
					if show then
						DropdownList.Visible = true
						DropdownList.Size = UDim2.new(1, -20, 0, math.min(#options * 30 + 40, 200))
						Arrow.Rotation = 180
					else
						DropdownList.Visible = false
						Arrow.Rotation = 0
					end
				end

				SelectFrame.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						toggleDropdown(not DropdownList.Visible)
					end
				end)

				updateSelectionText()

				return {
					Set = function(newSelected)
						selected = newSelected
						updateSelectionText()
					end,
					Get = function() return selected end
				}
			end

			function SectionObj:CreateInput(config)
				config = config or {}
				config.Title = config.Title or "Input"
				config.Description = config.Description or ""
				config.Placeholder = config.Placeholder or ""
				config.Default = config.Default or ""
				config.Callback = config.Callback or function() end

				self.OrderCounter = self.OrderCounter + 1
				local InputFrame = Instance.new("Frame")
				local UICorner = Instance.new("UICorner")
				local Title = Instance.new("TextLabel")
				local Desc = Instance.new("TextLabel")
				local TextBox = Instance.new("TextBox")

				InputFrame.Name = "Input_" .. self.OrderCounter
				InputFrame.Parent = self.Container
				InputFrame.LayoutOrder = self.OrderCounter
				InputFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				InputFrame.BackgroundTransparency = 0.935
				InputFrame.Size = UDim2.new(1, -5, 0, 70)
				InputFrame.BorderSizePixel = 0

				UICorner.CornerRadius = UDim.new(0, 4)
				UICorner.Parent = InputFrame

				Title.Font = Enum.Font.GothamBold
				Title.Text = config.Title
				Title.TextColor3 = Color3.fromRGB(230, 230, 230)
				Title.TextSize = 13
				Title.TextXAlignment = Enum.TextXAlignment.Left
				Title.BackgroundTransparency = 1
				Title.Position = UDim2.new(0, 10, 0, 8)
				Title.Size = UDim2.new(1, -20, 0, 16)
				Title.Parent = InputFrame

				Desc.Font = Enum.Font.Gotham
				Desc.Text = config.Description
				Desc.TextColor3 = Color3.fromRGB(200, 200, 200)
				Desc.TextSize = 11
				Desc.TextXAlignment = Enum.TextXAlignment.Left
				Desc.BackgroundTransparency = 1
				Desc.Position = UDim2.new(0, 10, 0, 26)
				Desc.Size = UDim2.new(1, -20, 0, 14)
				Desc.Parent = InputFrame

				TextBox.Font = Enum.Font.Gotham
				TextBox.PlaceholderText = config.Placeholder
				TextBox.Text = config.Default
				TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
				TextBox.TextSize = 12
				TextBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				TextBox.BackgroundTransparency = 0.9
				TextBox.Position = UDim2.new(0, 10, 0, 44)
				TextBox.Size = UDim2.new(1, -20, 0, 24)
				TextBox.Parent = InputFrame
				Instance.new("UICorner", TextBox).CornerRadius = UDim.new(0, 4)

				TextBox.FocusLost:Connect(function()
					config.Callback(TextBox.Text)
				end)

				return {
					Set = function(newText) TextBox.Text = newText end,
					Get = function() return TextBox.Text end
				}
			end

			function SectionObj:CreateDivider()
				self.OrderCounter = self.OrderCounter + 1
				local Divider = Instance.new("Frame")
				Divider.Name = "Divider_" .. self.OrderCounter
				Divider.Parent = self.Container
				Divider.LayoutOrder = self.OrderCounter
				Divider.Size = UDim2.new(1, -10, 0, 2)
				Divider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Divider.BackgroundTransparency = 0
				Divider.BorderSizePixel = 0

				local Gradient = Instance.new("UIGradient")
				Gradient.Color = ColorSequence.new{
					ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 20)),
					ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 20, 147)),
					ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 20))
				}
				Gradient.Parent = Divider
				Instance.new("UICorner", Divider).CornerRadius = UDim.new(0, 2)
				return Divider
			end

			return SectionObj
		end

		-- Função para alternar aba
		TabButton.MouseButton1Click:Connect(function()
			for _, tab in ipairs(Tabs) do
				tab.Page.Visible = false
				tab.Button.ImageColor3 = Color3.fromRGB(255, 255, 255)
			end
			TabObj.Page.Visible = true
			TabObj.Button.ImageColor3 = Color3.fromRGB(255, 20, 147) -- destaque
			ActiveTab = TabObj
		end)

		table.insert(Tabs, TabObj)
		return TabObj
	end

	-- Criar aba padrão (para compatibilidade com código antigo)
	DefaultTab = CreateTab("Main", "108092552939283") -- ícone padrão

	-- Adaptar os métodos antigos para usar a aba padrão
	local Elements = {}
	function Elements:CreateParagraph(text)
		return DefaultTab:CreateParagraph(text)
	end
	function Elements:CreateButton(text, iconID, callback)
		DefaultTab:CreateButton(text, iconID, callback)
	end
	function Elements:CreateToggle(text, callback)
		DefaultTab:CreateToggle(text, callback)
	end

	-- Retornar também a função de criar novas abas
	Elements.CreateTab = CreateTab

	return Elements
end

return Library