local ERDNLib = {}
ERDNLib.Flags = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

function ERDNLib:CreateWindow(hubTitle)
    hubTitle = hubTitle or "ERDN Paid | Muscle Legends"

    if CoreGui:FindFirstChild("ERDNGuiLibrary") then
        CoreGui:FindFirstChild("ERDNGuiLibrary"):Destroy()
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ERDNGuiLibrary"
    ScreenGui.ResetOnSpawn = false
    
    pcall(function() ScreenGui.Parent = CoreGui end)
    if not ScreenGui.Parent then
        ScreenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    end

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 520, 0, 320)
    MainFrame.Position = UDim2.new(0.5, -260, 0.5, -160)
    MainFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 26)
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = false
    MainFrame.Parent = ScreenGui

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 14)
    MainCorner.Parent = MainFrame

    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 45)
    Header.BackgroundTransparency = 1
    Header.Parent = MainFrame

    local CrownIcon = Instance.new("ImageLabel")
    CrownIcon.Name = "CrownIcon"
    CrownIcon.Size = UDim2.new(0, 22, 0, 22)
    CrownIcon.Position = UDim2.new(0, 16, 0.5, -11)
    CrownIcon.BackgroundTransparency = 1
    CrownIcon.Image = "rbxassetid://6031075931"
    CrownIcon.ImageColor3 = Color3.fromRGB(220, 220, 225)
    CrownIcon.Parent = Header

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "TitleLabel"
    TitleLabel.Size = UDim2.new(1, -100, 1, 0)
    TitleLabel.Position = UDim2.new(0, 48, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = hubTitle
    TitleLabel.TextColor3 = Color3.fromRGB(235, 235, 240)
    TitleLabel.TextSize = 16
    TitleLabel.Font = Enum.Font.SourceSansBold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = Header

    -- Botón Minimizar Interfaz
    local MinimizeBtn = Instance.new("TextButton")
    MinimizeBtn.Name = "MinimizeBtn"
    MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
    MinimizeBtn.Position = UDim2.new(1, -40, 0.5, -15)
    MinimizeBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    MinimizeBtn.Text = "-"
    MinimizeBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    MinimizeBtn.TextSize = 22
    MinimizeBtn.Font = Enum.Font.SourceSansBold
    MinimizeBtn.Parent = Header

    local MinCorner = Instance.new("UICorner")
    MinCorner.CornerRadius = UDim.new(0, 8)
    MinCorner.Parent = MinimizeBtn

    -- Botón Flotante Maximizar
    local OpenToggleBtn = Instance.new("ImageButton")
    OpenToggleBtn.Name = "OpenToggleBtn"
    OpenToggleBtn.Size = UDim2.new(0, 45, 0, 45)
    OpenToggleBtn.Position = UDim2.new(0, 20, 0.5, -22)
    OpenToggleBtn.BackgroundColor3 = Color3.fromRGB(24, 24, 26)
    OpenToggleBtn.Image = "rbxassetid://6031075931"
    OpenToggleBtn.ImageColor3 = Color3.fromRGB(255, 255, 255)
    OpenToggleBtn.Visible = false
    OpenToggleBtn.Parent = ScreenGui

    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 12)
    ToggleCorner.Parent = OpenToggleBtn

    local function ToggleGUI()
        local isMainVisible = MainFrame.Visible
        MainFrame.Visible = not isMainVisible
        OpenToggleBtn.Visible = isMainVisible
    end

    MinimizeBtn.MouseButton1Click:Connect(ToggleGUI)
    OpenToggleBtn.MouseButton1Click:Connect(ToggleGUI)

    -- Barra de Pestañas (Horizontal Scrolling)
    local TabBar = Instance.new("ScrollingFrame")
    TabBar.Name = "TabBar"
    TabBar.Size = UDim2.new(1, -24, 0, 38)
    TabBar.Position = UDim2.new(0, 12, 0, 45)
    TabBar.BackgroundTransparency = 1
    TabBar.BorderSizePixel = 0
    TabBar.ScrollBarThickness = 2
    TabBar.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 65)
    TabBar.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabBar.Parent = MainFrame

    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.Parent = TabBar
    TabListLayout.FillDirection = Enum.FillDirection.Horizontal
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabListLayout.Padding = UDim.new(0, 8)

    local PagesFolder = Instance.new("Frame")
    PagesFolder.Name = "PagesFolder"
    PagesFolder.Size = UDim2.new(1, -24, 1, -95)
    PagesFolder.Position = UDim2.new(0, 12, 0, 90)
    PagesFolder.BackgroundTransparency = 1
    PagesFolder.Parent = MainFrame

    -- Arrastrar Ventana (Drag)
    local dragging, dragInput, dragStart, startPos
    local function update(input)
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)

    Header.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then update(input) end
    end)

    local Window = {}
    local tabs = {}

    function Window:CreateTab(tabName, iconAssetId)
        iconAssetId = iconAssetId or "rbxassetid://6031075931"
        
        local TabBtn = Instance.new("TextButton")
        TabBtn.Name = tabName .. "Tab"
        TabBtn.Size = UDim2.new(0, 100, 1, 0)
        TabBtn.BackgroundColor3 = Color3.fromRGB(38, 38, 42)
        TabBtn.Text = ""
        TabBtn.AutoButtonColor = false
        TabBtn.Parent = TabBar

        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 18)
        TabCorner.Parent = TabBtn

        local TabIcon = Instance.new("ImageLabel")
        TabIcon.Name = "Icon"
        TabIcon.Size = UDim2.new(0, 18, 0, 18)
        TabIcon.Position = UDim2.new(0, 12, 0.5, -9)
        TabIcon.BackgroundTransparency = 1
        TabIcon.Image = iconAssetId
        TabIcon.ImageColor3 = Color3.fromRGB(160, 160, 165)
        TabIcon.Parent = TabBtn

        local TabLabel = Instance.new("TextLabel")
        TabLabel.Name = "Title"
        TabLabel.Size = UDim2.new(1, -38, 1, 0)
        TabLabel.Position = UDim2.new(0, 34, 0, 0)
        TabLabel.BackgroundTransparency = 1
        TabLabel.Text = tabName
        TabLabel.TextColor3 = Color3.fromRGB(160, 160, 165)
        TabLabel.TextSize = 13
        TabLabel.Font = Enum.Font.SourceSansBold
        TabLabel.TextXAlignment = Enum.TextXAlignment.Left
        TabLabel.Parent = TabBtn

        local Page = Instance.new("ScrollingFrame")
        Page.Name = tabName .. "Page"
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.BorderSizePixel = 0
        Page.ScrollBarThickness = 3
        Page.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 85)
        Page.Visible = false
        Page.Parent = PagesFolder

        local PageLayout = Instance.new("UIListLayout")
        PageLayout.Parent = Page
        PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        PageLayout.Padding = UDim.new(0, 8)

        local textBounds = game:GetService("TextService"):GetTextSize(tabName, 13, Enum.Font.SourceSansBold, Vector2.new(1000, 38))
        TabBtn.Size = UDim2.new(0, textBounds.X + 46, 1, -2)
        TabBar.CanvasSize = UDim2.new(0, TabListLayout.AbsoluteContentSize.X + 10, 0, 0)

        local function Select()
            for _, t in pairs(tabs) do
                TweenService:Create(t.Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(38, 38, 42)}):Play()
                TweenService:Create(t.Label, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(160, 160, 165)}):Play()
                TweenService:Create(t.Icon, TweenInfo.new(0.2), {ImageColor3 = Color3.fromRGB(160, 160, 165)}):Play()
                t.Page.Visible = false
            end
            TweenService:Create(TabBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(225, 225, 230)}):Play()
            TweenService:Create(TabLabel, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(20, 20, 22)}):Play()
            TweenService:Create(TabIcon, TweenInfo.new(0.2), {ImageColor3 = Color3.fromRGB(20, 20, 22)}):Play()
            Page.Visible = true
        end

        TabBtn.MouseButton1Click:Connect(Select)
        table.insert(tabs, {Button = TabBtn, Page = Page, Label = TabLabel, Icon = TabIcon})
        if #tabs == 1 then Select() end

        local function UpdateCanvas()
            Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 10)
        end

        local TabElements = {}

        -- 1. BOTÓN (Button)
        function TabElements:AddButton(btnText, callback)
            callback = callback or function() end
            local Button = Instance.new("TextButton")
            Button.Size = UDim2.new(1, -6, 0, 36)
            Button.BackgroundColor3 = Color3.fromRGB(32, 32, 36)
            Button.Text = "   " .. btnText
            Button.TextColor3 = Color3.fromRGB(220, 220, 225)
            Button.TextSize = 14
            Button.Font = Enum.Font.SourceSansSemiBold
            Button.TextXAlignment = Enum.TextXAlignment.Left
            Button.Parent = Page

            local BtnCorner = Instance.new("UICorner")
            BtnCorner.CornerRadius = UDim.new(0, 8)
            BtnCorner.Parent = Button

            Button.MouseButton1Click:Connect(callback)
            UpdateCanvas()
        end

        -- 2. TOGGLE / INTERRUPTOR (Encendido/Apagado)
        function TabElements:AddToggle(toggleText, default, callback)
            callback = callback or function() end
            local toggled = default or false

            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Size = UDim2.new(1, -6, 0, 36)
            ToggleFrame.BackgroundColor3 = Color3.fromRGB(32, 32, 36)
            ToggleFrame.Parent = Page

            local TCorner = Instance.new("UICorner")
            TCorner.CornerRadius = UDim.new(0, 8)
            TCorner.Parent = ToggleFrame

            local TLabel = Instance.new("TextLabel")
            TLabel.Size = UDim2.new(1, -60, 1, 0)
            TLabel.Position = UDim2.new(0, 12, 0, 0)
            TLabel.BackgroundTransparency = 1
            TLabel.Text = toggleText
            TLabel.TextColor3 = Color3.fromRGB(220, 220, 225)
            TLabel.TextSize = 14
            TLabel.Font = Enum.Font.SourceSansSemiBold
            TLabel.TextXAlignment = Enum.TextXAlignment.Left
            TLabel.Parent = ToggleFrame

            local Indicator = Instance.new("Frame")
            Indicator.Size = UDim2.new(0, 38, 0, 20)
            Indicator.Position = UDim2.new(1, -48, 0.5, -10)
            Indicator.BackgroundColor3 = toggled and Color3.fromRGB(0, 180, 120) or Color3.fromRGB(50, 50, 55)
            Indicator.Parent = ToggleFrame

            local IndCorner = Instance.new("UICorner")
            IndCorner.CornerRadius = UDim.new(1, 0)
            IndCorner.Parent = Indicator

            local Circle = Instance.new("Frame")
            Circle.Size = UDim2.new(0, 16, 0, 16)
            Circle.Position = toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
            Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Circle.Parent = Indicator

            local CircCorner = Instance.new("UICorner")
            CircCorner.CornerRadius = UDim.new(1, 0)
            CircCorner.Parent = Circle

            local HitBtn = Instance.new("TextButton")
            HitBtn.Size = UDim2.new(1, 0, 1, 0)
            HitBtn.BackgroundTransparency = 1
            HitBtn.Text = ""
            HitBtn.Parent = ToggleFrame

            HitBtn.MouseButton1Click:Connect(function()
                toggled = not toggled
                TweenService:Create(Indicator, TweenInfo.new(0.2), {BackgroundColor3 = toggled and Color3.fromRGB(0, 180, 120) or Color3.fromRGB(50, 50, 55)}):Play()
                TweenService:Create(Circle, TweenInfo.new(0.2), {Position = toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}):Play()
                callback(toggled)
            end)

            UpdateCanvas()
        end

        -- 3. TEXTBOX (Escribir Números o Texto)
        function TabElements:AddTextBox(boxText, placeholder, callback)
            callback = callback or function() end

            local BoxFrame = Instance.new("Frame")
            BoxFrame.Size = UDim2.new(1, -6, 0, 36)
            BoxFrame.BackgroundColor3 = Color3.fromRGB(32, 32, 36)
            BoxFrame.Parent = Page

            local BCorner = Instance.new("UICorner")
            BCorner.CornerRadius = UDim.new(0, 8)
            BCorner.Parent = BoxFrame

            local BLabel = Instance.new("TextLabel")
            BLabel.Size = UDim2.new(0.6, 0, 1, 0)
            BLabel.Position = UDim2.new(0, 12, 0, 0)
            BLabel.BackgroundTransparency = 1
            BLabel.Text = boxText
            BLabel.TextColor3 = Color3.fromRGB(220, 220, 225)
            BLabel.TextSize = 14
            BLabel.Font = Enum.Font.SourceSansSemiBold
            BLabel.TextXAlignment = Enum.TextXAlignment.Left
            BLabel.Parent = BoxFrame

            local Input = Instance.new("TextBox")
            Input.Size = UDim2.new(0.35, -10, 0, 24)
            Input.Position = UDim2.new(0.65, 0, 0.5, -12)
            Input.BackgroundColor3 = Color3.fromRGB(22, 22, 25)
            Input.Text = ""
            Input.PlaceholderText = placeholder or "Escribe..."
            Input.TextColor3 = Color3.fromRGB(255, 255, 255)
            Input.PlaceholderColor3 = Color3.fromRGB(120, 120, 125)
            Input.TextSize = 13
            Input.Font = Enum.Font.SourceSans
            Input.Parent = BoxFrame

            local ICorner = Instance.new("UICorner")
            ICorner.CornerRadius = UDim.new(0, 6)
            ICorner.Parent = Input

            Input.FocusLost:Connect(function(enterPressed)
                callback(Input.Text)
            end)

            UpdateCanvas()
        end

        -- 4. DROPDOWN (Lista Desplegable de Opciones)
        function TabElements:AddDropdown(dropText, listOptions, callback)
            callback = callback or function() end
            local expanded = false

            local DropFrame = Instance.new("Frame")
            DropFrame.Size = UDim2.new(1, -6, 0, 36)
            DropFrame.BackgroundColor3 = Color3.fromRGB(32, 32, 36)
            DropFrame.ClipsDescendants = true
            DropFrame.Parent = Page

            local DCorner = Instance.new("UICorner")
            DCorner.CornerRadius = UDim.new(0, 8)
            DCorner.Parent = DropFrame

            local DLabel = Instance.new("TextLabel")
            DLabel.Size = UDim2.new(1, -30, 0, 36)
            DLabel.Position = UDim2.new(0, 12, 0, 0)
            DLabel.BackgroundTransparency = 1
            DLabel.Text = dropText .. ": Seleccionar..."
            DLabel.TextColor3 = Color3.fromRGB(220, 220, 225)
            DLabel.TextSize = 14
            DLabel.Font = Enum.Font.SourceSansSemiBold
            DLabel.TextXAlignment = Enum.TextXAlignment.Left
            DLabel.Parent = DropFrame

            local Arrow = Instance.new("TextLabel")
            Arrow.Size = UDim2.new(0, 30, 0, 36)
            Arrow.Position = UDim2.new(1, -30, 0, 0)
            Arrow.BackgroundTransparency = 1
            Arrow.Text = "▼"
            Arrow.TextColor3 = Color3.fromRGB(150, 150, 155)
            Arrow.TextSize = 12
            Arrow.Parent = DropFrame

            local OptionContainer = Instance.new("Frame")
            OptionContainer.Size = UDim2.new(1, -24, 0, #listOptions * 28)
            OptionContainer.Position = UDim2.new(0, 12, 0, 36)
            OptionContainer.BackgroundTransparency = 1
            OptionContainer.Parent = DropFrame

            local OLayout = Instance.new("UIListLayout")
            OLayout.Parent = OptionContainer
            OLayout.Padding = UDim.new(0, 4)

            local DropBtn = Instance.new("TextButton")
            DropBtn.Size = UDim2.new(1, 0, 0, 36)
            DropBtn.BackgroundTransparency = 1
            DropBtn.Text = ""
            DropBtn.Parent = DropFrame

            local function ToggleDrop()
                expanded = not expanded
                local targetSize = expanded and (36 + (#listOptions * 30) + 6) or 36
                DropFrame.Size = UDim2.new(1, -6, 0, targetSize)
                Arrow.Text = expanded and "▲" or "▼"
                UpdateCanvas()
            end

            DropBtn.MouseButton1Click:Connect(ToggleDrop)

            for _, opt in ipairs(listOptions) do
                local OptBtn = Instance.new("TextButton")
                OptBtn.Size = UDim2.new(1, 0, 0, 26)
                OptBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 28)
                OptBtn.Text = "  " .. tostring(opt)
                OptBtn.TextColor3 = Color3.fromRGB(180, 180, 185)
                OptBtn.TextSize = 13
                OptBtn.Font = Enum.Font.SourceSans
                OptBtn.TextXAlignment = Enum.TextXAlignment.Left
                OptBtn.Parent = OptionContainer

                local OCorner = Instance.new("UICorner")
                OCorner.CornerRadius = UDim.new(0, 6)
                OCorner.Parent = OptBtn

                OptBtn.MouseButton1Click:Connect(function()
                    DLabel.Text = dropText .. ": " .. tostring(opt)
                    ToggleDrop()
                    callback(opt)
                end)
            end

            UpdateCanvas()
        end

        -- 5. SECTION COLLAPSIBLE (Minimizar / Maximizar Bloques de Contenido)
        function TabElements:AddSection(sectionTitle)
            local SectionFrame = Instance.new("Frame")
            SectionFrame.Size = UDim2.new(1, -6, 0, 28)
            SectionFrame.BackgroundTransparency = 1
            SectionFrame.Parent = Page

            local SLabel = Instance.new("TextLabel")
            SLabel.Size = UDim2.new(1, 0, 1, 0)
            SLabel.BackgroundTransparency = 1
            SLabel.Text = "--- " .. string.upper(sectionTitle) .. " ---"
            SLabel.TextColor3 = Color3.fromRGB(130, 130, 135)
            SLabel.TextSize = 12
            SLabel.Font = Enum.Font.SourceSansBold
            SLabel.Parent = SectionFrame

            UpdateCanvas()
        end

        return TabElements
    end

    return Window
end

return ERDNLib
