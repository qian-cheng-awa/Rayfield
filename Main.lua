local DeltaUiLib = {}
DeltaUiLib.GetDeltaUi = function()
	for i,v in ipairs(gethui():GetChildren()) do
		if v:FindFirstChild("MainScript") and v:FindFirstChild("UILibrary") then
			return v
		end
	end
end
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local TweenInfo = TweenInfo.new
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Ui = DeltaUiLib.GetDeltaUi()
local Player = Players.LocalPlayer

local function RunId(id)
	if typeof(id) == "string" then
		id = game:GetService("Players"):GetUserIdFromNameAsync(id)
	end
	local stringa = "12345abcdefg[\'./?"
	local Random = Random.new(id)
	local str = ""
	for i=1,20 do
		str = str..stringa:sub(Random:NextInteger(1,#stringa),Random:NextInteger(1,#stringa))
	end
	return str
end

if not getrenv()[RunId()] then
	getrenv()[RunId()] = {}
end

DeltaUiLib._G = getrenv()[RunId()]

local SideBar = Ui.Sidebar

if not getrenv().DeltaUiLibTableByBixie then
	getrenv().DeltaUiLibTableByBixie = {}
end

if Ui:FindFirstChild("UiLib") then
	Ui:FindFirstChild("UiLib"):Destroy()
end
DeltaUiLib.GetDeltaIcon = function(Name)
	return getcustomasset("DeltaAssets/"..Name)
end
if Ui:FindFirstChild("Notifications") then
	Ui:FindFirstChild("Notifications"):Destroy()
end
local Notifications = game:GetObjects("rbxassetid://99527325983045")[1]
Notifications.Name = "Notifications"
Notifications.Parent = Ui
Notifications.Visible = true
DeltaUiLib.Notify = function(self,data)
	task.spawn(function()

		-- Notification Object Creation
		local newNotification = Notifications.UIListLayout.Template:Clone()
		newNotification.Name = data.Title or 'No Title Provided'
		newNotification.Parent = Notifications
		newNotification.LayoutOrder = #Notifications:GetChildren()
		newNotification.Visible = false

		-- Set Data
		newNotification.Title.Text = data.Title or "Unknown Title"
		newNotification.Description.Text = data.Content or "Unknown Content"

		-- Set initial transparency values
		newNotification.Size = UDim2.new(1,0,0,170)
		newNotification.BackgroundTransparency = 1
		newNotification.Title.TextTransparency = 1
		newNotification.Description.TextTransparency = 1
		newNotification.UIStroke.Transparency = 1
		newNotification.Shadow.ImageTransparency = 1
		newNotification.Size = UDim2.new(1, 0, 0, 800)
		newNotification.Icon.ImageTransparency = 1
		newNotification.Icon.BackgroundTransparency = 1

		task.wait()

		newNotification.Visible = true

		-- Calculate textbounds and set initial values
		local bounds = {newNotification.Title.TextBounds.Y, newNotification.Description.TextBounds.Y}
		newNotification.Size = UDim2.new(1, -60, 0, -Notifications:FindFirstChild("UIListLayout").Padding.Offset)

		newNotification.Icon.Size = UDim2.new(0, 32, 0, 32)
		newNotification.Icon.Position = UDim2.new(0, 20, 0.5, 0)

		TweenService:Create(newNotification, TweenInfo(0.6, Enum.EasingStyle.Exponential), {Size = UDim2.new(1, 0, 0, math.max(bounds[1] + bounds[2] + 31, 60))}):Play()

		task.wait(0.15)
		TweenService:Create(newNotification, TweenInfo(0.4, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.45}):Play()
		TweenService:Create(newNotification.Title, TweenInfo(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()

		task.wait(0.05)

		TweenService:Create(newNotification.Icon, TweenInfo(0.3, Enum.EasingStyle.Exponential), {ImageTransparency = 0}):Play()

		task.wait(0.05)
		TweenService:Create(newNotification.Description, TweenInfo(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 0.35}):Play()
		TweenService:Create(newNotification.UIStroke, TweenInfo(0.4, Enum.EasingStyle.Exponential), {Transparency = 0.95}):Play()
		TweenService:Create(newNotification.Shadow, TweenInfo(0.3, Enum.EasingStyle.Exponential), {ImageTransparency = 0.82}):Play()

		local waitDuration = math.min(math.max((#newNotification.Description.Text * 0.1) + 2.5, 3), 10)
		task.wait(data.Duration or waitDuration)

		newNotification.Icon.Visible = false
		TweenService:Create(newNotification, TweenInfo(0.4, Enum.EasingStyle.Exponential), {BackgroundTransparency = 1}):Play()
		TweenService:Create(newNotification.UIStroke, TweenInfo(0.4, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
		TweenService:Create(newNotification.Shadow, TweenInfo(0.3, Enum.EasingStyle.Exponential), {ImageTransparency = 1}):Play()
		TweenService:Create(newNotification.Title, TweenInfo(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 1}):Play()
		TweenService:Create(newNotification.Description, TweenInfo(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 1}):Play()

		TweenService:Create(newNotification, TweenInfo(1, Enum.EasingStyle.Exponential), {Size = UDim2.new(1, -90, 0, 0)}):Play()

		task.wait(1)

		TweenService:Create(newNotification, TweenInfo(1, Enum.EasingStyle.Exponential), {Size = UDim2.new(1, -90, 0, -Notifications:FindFirstChild("UIListLayout").Padding.Offset)}):Play()

		newNotification.Visible = false
		newNotification:Destroy()
	end)
end

DeltaUiLib.CreateWindow = function(self,Config)
	local MainUi = {}
	Config = {
		Name = Config.Name or "DeltaUiLib",
		Icon = Config.Icon or 80793503367620,
		ShowText = Config.ShowText or "DeltaUiLib",
	}
	if typeof(Config.Icon) == "number" then
		Config.Icon = "rbxassetid://"..tostring(Config.Icon)
	end
	if SideBar:FindFirstChild("UiLib") then
		SideBar.UiLib:Destroy()
	end
	local NewButton = SideBar.Console:Clone()
	MainUi.SideBarButton = NewButton
	NewButton.Parent = SideBar
	NewButton.Name = "UiLib"
	NewButton.BackgroundColor3 = SideBar.InactiveColor.Value
	NewButton:FindFirstChild("ImageLabel").Visible = false
	NewButton.Image = Config.Icon
	local NewbuttonStroke = Instance.new("UIStroke",NewButton)
	NewbuttonStroke.Thickness = 2
	NewbuttonStroke.Color = SideBar.InactiveColor.Value
	local UiLib = game:GetObjects("rbxassetid://127491300153756")[1]
	MainUi.UiLib = UiLib
	UiLib.Parent = Ui
	UiLib.Visible = false
	UiLib.Position = UDim2.fromScale(.4,.5)
	DeltaUiLib:Notify({
		Title = "TDM",
		Content = "UI在忍者里！打开忍者点侧边栏最底下那个就是脚本",
		Duration = 6.5,
	})
	local s = .5
	for i,v in ipairs(SideBar:GetChildren()) do
		if v:IsA("ImageButton") and v ~= NewButton and v.Name ~= "ToggleUI" then
			v.MouseButton1Click:Connect(function()
				UiLib.Visible = false
				TweenService:Create(NewbuttonStroke,TweenInfo(s,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{Color = SideBar.InactiveColor.Value}):Play()
			end)
		end
	end
	NewButton.MouseButton1Click:Connect(function()
		for i,v in ipairs(Ui:GetChildren()) do
			if v:FindFirstChild("Marker") and v.Marker.Value == "Menu" then
				v.Visible = false
			end
		end


		for i,v in ipairs(SideBar:GetChildren()) do
			if v:IsA("ImageButton") and v.Name ~= "ToggleUI" then
				TweenService:Create(v,TweenInfo(s,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{BackgroundColor3 = SideBar.InactiveColor.Value}):Play()
				TweenService:Create(v:FindFirstChild("ImageLabel"),TweenInfo(s,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{ImageColor3 = Color3.fromRGB(137, 144, 163)}):Play()
			end
		end
		TweenService:Create(NewbuttonStroke,TweenInfo(s,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{Color = SideBar.ActiveColor.Value}):Play()
		UiLib.Visible = true
		UiLib.Position = UDim2.fromScale(.4,.5)
		TweenService:Create(UiLib,TweenInfo(.25,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{Position = UDim2.fromScale(.5,.5)}):Play()
	end)

	local firsttab = false
	MainUi.CreateTab = function(self,Title,Icon)
		local Tab = {}

		local NewTabButton = UiLib.Tabs.Tabs.UIListLayout.Button:Clone()
		NewTabButton.Parent = UiLib.Tabs.Tabs
		NewTabButton.Name = Title
		NewTabButton.Text = Title

		Tab.TabButton = NewTabButton

		local NewPage = UiLib.Pages:Clone()
		NewPage.Parent = UiLib
		NewPage.Name = Title
		NewPage.Visible = not firsttab
		firsttab = true
		NewTabButton.MouseButton1Click:Connect(function()
			for i,v in ipairs(UiLib:GetChildren()) do
				if v:FindFirstChild("Marker") and v.Marker.Value == "Page" then
					v.Visible = false
				end
			end

			for i,v in ipairs(UiLib.Tabs.Tabs:GetChildren()) do
				if v:IsA("TextButton") then
					TweenService:Create(v,TweenInfo(s,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{BackgroundTransparency = 1}):Play()
				end
			end

			TweenService:Create(NewTabButton,TweenInfo(s,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{BackgroundTransparency = 0}):Play()
			NewPage.Visible = true
			NewPage.Position = UDim2.fromScale(.4,1)
			TweenService:Create(NewPage,TweenInfo(.25,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{Position = UDim2.fromScale(.5,1)}):Play()
		end)

		local layout = 0

		Tab.CreateInput = function(self,config)
			config = {
				Name = config.Name or "Input",
				CurrentValue = config.CurrentValue or "",
				PlaceholderText = config.PlaceholderText or "Input",
				RemoveTextAfterFocusLost = config.RemoveTextAfterFocusLost or false,
				Callback = config.Callback or function()end,
				Desc = config.Desc or "",
			}

			local NewInput = NewPage.UIListLayout.TextBox:Clone()
			NewInput.LayoutOrder = layout
			layout += 1
			NewInput.Parent = NewPage
			NewInput.Name = config.Name
			NewInput.TextBox.PlaceholderText = config.PlaceholderText
			NewInput.TextBox.Text = config.CurrentValue
			NewInput.TextBox.ClearTextOnFocus = config.RemoveTextAfterFocusLost
			NewInput.Title.Text = config.Name
			NewInput.Desc.Text = config.Desc
			NewInput.TextBox.FocusLost:Connect(function()
				local sus,res = pcall(function()
					config.Callback(NewInput.TextBox.Text)
				end)
				if not sus then
					print(config.Name.." Callback Error " ..tostring(res))
				end
			end)

			config.Set = function(self,Val)
				NewInput.TextBox.Text = Val
				config.CurrentValue = Val

				local sus,res = pcall(function()
					config.Callback(NewInput.TextBox.Text)
				end)

				if not sus then
					print(config.Name.." Callback Error " ..tostring(res))
				end
			end

			return config
		end

		Tab.CreateToggle = function(self,config)
			config = {
				Name = config.Name or "Toggle",
				CurrentValue = config.CurrentValue or false,
				Desc = config.Desc or "",
				Callback = config.Callback or function()end,  
			}

			local NewToggle = NewPage.UIListLayout.Switch:Clone()
			NewToggle.Name = config.Name
			NewToggle.LayoutOrder = layout
			NewToggle.Title.Text = config.Name
			NewToggle.Desc.Text = config.Desc
			layout += 1
			NewToggle.Parent = NewPage
			local function Toggle(Val)
				NewToggle:FindFirstChild("Enabled").Value = Val
				TweenService:Create(NewToggle.Switch.ImageButton,TweenInfo(s,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{
					Position = UDim2.fromScale(Val and 1 or 0,0.5),
					AnchorPoint = Vector2.new(Val and 1 or 0,0.5),
				}):Play()
				TweenService:Create(NewToggle.Switch,TweenInfo(s,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{
					BackgroundColor3 = Val and Color3.fromRGB(34, 160, 255) or Color3.fromRGB(61, 66, 81),
				}):Play()
			end
			Toggle(config.CurrentValue)
			NewToggle.Switch.MouseButton1Click:Connect(function()
				Toggle(not NewToggle:FindFirstChild("Enabled").Value)
				local sus,res = pcall(function()
					config.Callback(NewToggle:FindFirstChild("Enabled").Value)
				end)
				if not sus then
					print(config.Name.." Callback Error " ..tostring(res))
				end
			end)

			config.Set = function(self,Val)
				Toggle(Val)
				local sus,res = pcall(function()
					config.Callback(NewToggle:FindFirstChild("Enabled").Value)
				end)
				if not sus then
					print(config.Name.." Callback Error " ..tostring(res))
				end
			end
			return config
		end

		Tab.CreateSection = function(self,Text)
			local NewSection = NewPage.UIListLayout.SectionTitle:Clone()
			NewSection.LayoutOrder = layout
			layout += 1
			NewSection.Parent = NewPage
			NewSection.Title.Text = Text
			NewSection.Name = Text
		end

		Tab.CreateButton = function(self,config)
			config = {
				Name = config.Name or "Button",
				Desc = config.Desc or "",
				ButtonText = config.ButtonText or "CLICK HERE",
				Callback = config.Callback or function()end,
			}

			local NewButton = NewPage.UIListLayout.Button:Clone()
			NewButton.LayoutOrder = layout
			layout += 1
			NewButton.Parent = NewPage
			NewButton.Name = config.Name
			NewButton.Title.Text = config.Name
			NewButton.Desc.Text = config.Desc
			NewButton.Button.Title.Text = config.ButtonText
			NewButton.Button.MouseButton1Click:Connect(function()
				local sus,res = pcall(function()
					config.Callback()
				end)
				if not sus then
					print(config.Name.." Callback Error " ..tostring(res))
				end
			end)

			config.Set = function(self,Name,Desc)
				NewButton.Title.Text = Name
				NewButton.Desc.Text = Desc
				NewButton.Name = Name
			end

			return config
		end

		Tab.CreateDropdown = function(self,config)
			config = {
				Name = config.Name or "Dropdown",
				Options = config.Options or {},
				Desc = config.Desc or "",
				CurrentOption = config.CurrentOption or {},
				MultipleOptions = config.MultipleOptions or false,
				CanNoneSeleted = config.CanNoneSeleted or false,
				Callback = config.Callback or function()end,
			}

			local NewDropdown = NewPage.UIListLayout.Dropdown:Clone()
			NewDropdown.LayoutOrder = layout
			layout += 1
			NewDropdown.Parent = NewPage
			NewDropdown.Name = config.Name
			NewDropdown.Title.Text = config.Name
			NewDropdown.Desc.Text = config.Desc

			local NewDropdownOptions = NewPage.UIListLayout.DropdownOptions:Clone()
			NewDropdownOptions.Visible = false
			NewDropdownOptions.Parent = NewPage
			NewDropdownOptions.Name = config.Name.."Options"
			NewDropdownOptions.LayoutOrder = layout
			layout += 1

			for i,v in pairs(config.Options) do
				local NewOption = NewDropdownOptions.Dropdown.ScrollingFrame.UIListLayout.Frame:Clone()
				NewOption.LayoutOrder = i
				NewOption.Name = v
				NewOption.Parent = NewDropdownOptions.Dropdown.ScrollingFrame
				NewOption.Button.Title.Text = v
				NewOption.Button.MouseButton1Click:Connect(function()
					if config.MultipleOptions then
						if table.find(config.CurrentOption,v) then
							table.remove(config.CurrentOption,table.find(config.CurrentOption,v))
							NewOption.Button.Checked.Visible = false
						else
							table.insert(config.CurrentOption,v)
							NewOption.Button.Checked.Visible = true
						end
					else
						if config.CurrentOption[1] == v then
							if config.CanNoneSeleted then
								config.CurrentOption = {}
							end
						else
							config.CurrentOption = {v}
						end
					end
					if config.CurrentOption[1] == nil then
						NewDropdown.Button.Title.Text = "None"
					elseif config.CurrentOption[2] == nil then
						NewDropdown.Button.Title.Text = v
					else
						NewDropdown.Button.Title.Text = "..."
					end
					for i,v in ipairs(NewDropdownOptions.Dropdown.ScrollingFrame:GetChildren()) do
						if v:IsA("Frame") then
							if table.find(config.CurrentOption,v.Name) then
								v.Button.Checked.Visible = true
							else
								v.Button.Checked.Visible = false
							end
						end
					end
					local sus,res = pcall(function()
						config.Callback(config.CurrentOption)
					end)
					if not sus then
						print(config.Name.." Callback Error " ..tostring(res))
					end
				end)
			end
			if config.CurrentOption[1] == nil then
				NewDropdown.Button.Title.Text = "None"
			elseif config.CurrentOption[2] == nil then
				NewDropdown.Button.Title.Text = config.CurrentOption[1]
			else
				NewDropdown.Button.Title.Text = "..."
			end
			local Open = false

			local function ToggleOpen(val)
				Open = val
				if val then
					NewDropdownOptions.Visible = true
				else
					task.delay(s,function()
						if Open == false then
							NewDropdownOptions.Visible = false
						end
					end)
				end
				TweenService:Create(NewDropdownOptions,TweenInfo(s,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{
					Size = UDim2.fromScale(1,val and 0.25 or 0)	
				}):Play()
			end

			NewDropdown.Button.MouseButton1Click:Connect(function()
				ToggleOpen(not Open)
			end)

			config.Set = function(self,val)
				config.CurrentOption = val
				if config.CurrentOption[1] == nil then
					NewDropdown.Button.Title.Text = "None"
				elseif config.CurrentOption[2] == nil then
					NewDropdown.Button.Title.Text = "..."
				else
					NewDropdown.Button.Title.Text = val
				end
				for i,v in ipairs(NewDropdownOptions.Dropdown.ScrollingFrame:GetChildren()) do
					if v:IsA("Frame") then
						if table.find(config.CurrentOption,v.Name) then
							v.Button.Checked.Visible = true
						else
							v.Button.Checked.Visible = false
						end
					end
				end
				local sus,res = pcall(function()
					config.Callback(config.CurrentOption)
				end)
				if not sus then
					print(config.Name.." Callback Error " ..tostring(res))
				end
			end
			config.Refresh = function(self,val)
				for i,v in ipairs(NewDropdownOptions.Dropdown.ScrollingFrame:GetChildren()) do
					if v:IsA("Frame") then
						v:Destroy()
					end
				end
				for i,v in pairs(val) do
					local NewOption = NewDropdownOptions.Dropdown.ScrollingFrame.UIListLayout.Frame:Clone()
					NewOption.Name = v
					NewOption.LayoutOrder = i
					NewOption.Parent = NewDropdownOptions.Dropdown.ScrollingFrame
					NewOption.Button.Title.Text = v
					NewOption.Button.MouseButton1Click:Connect(function()
						if config.MultipleOptions then
							if table.find(config.CurrentOption,v) then
								table.remove(config.CurrentOption,table.find(config.CurrentOption,v))
							else
								table.insert(config.CurrentOption,v)
							end
						else
							if config.CurrentOption[1] == v then
								if config.CanNoneSeleted then
									config.CurrentOption = {}
								end
							else
								config.CurrentOption = {v}
							end
						end
						if config.CurrentOption[1] == nil then
							NewDropdown.Button.Title.Text = "None"
						elseif config.CurrentOption[2] == nil then
							NewDropdown.Button.Title.Text = "..."
						else
							NewDropdown.Button.Title.Text = v
						end
						for i,v in ipairs(NewDropdownOptions.Dropdown.ScrollingFrame:GetChildren()) do
							if v:IsA("Frame") then
								if table.find(config.CurrentOption,v.Name) then
									v.Button.Checked.Visible = true
								else
									v.Button.Checked.Visible = false
								end
							end
						end
						local sus,res = pcall(function()
							config.Callback(config.CurrentOption)
						end)
						if not sus then
							print(config.Name.." Callback Error " ..tostring(res))
						end
					end)
				end
			end
			return config
		end

		Tab.CreateSlider = function(self,config)
			config = {
				Name = config.Name or "Slider",
				Range = config.Range or {1,100},
				Desc = config.Desc or "",
				CurrentValue = config.CurrentValue or 1,
				Color = config.Color or Color3.fromRGB(255,255,255),
				Increment = config.Increment or 1,
				Callback = config.Callback or function()end,
			}

			local NewSlider = NewPage.UIListLayout.Slider:Clone()
			NewSlider.Parent = NewPage
			NewSlider.Name = config.Name
			NewSlider.Title.Text = config.Name
			NewSlider.Desc.Text = config.Desc
			NewSlider.LayoutOrder = layout
			layout += 1
			NewSlider.Main.Progress.Size =	UDim2.new(0, NewSlider.Main.AbsoluteSize.X * ((config.CurrentValue + config.Range[1]) / (config.Range[2] - config.Range[1])) > 5 and NewSlider.Main.AbsoluteSize.X * (config.CurrentValue / (config.Range[2] - config.Range[1])) or 5, 1, 0)
			if not config.Suffix then
				NewSlider.Main.Information.Text = tostring(config.CurrentValue)
			else
				NewSlider.Main.Information.Text = tostring(config.CurrentValue) .. " " .. config.Suffix
			end
			local SLDragging = false
			NewSlider.Main.Interact.InputBegan:Connect(function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then 
					TweenService:Create(NewSlider.Main.UIStroke, TweenInfo(0.6, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
					TweenService:Create(NewSlider.Main.Progress.UIStroke, TweenInfo(0.6, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
					SLDragging = true 
				end 
			end)

			NewSlider.Main.Interact.InputEnded:Connect(function(Input) 
				if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then 
					TweenService:Create(NewSlider.Main.UIStroke, TweenInfo(0.6, Enum.EasingStyle.Exponential), {Transparency = 0.4}):Play()
					TweenService:Create(NewSlider.Main.Progress.UIStroke, TweenInfo(0.6, Enum.EasingStyle.Exponential), {Transparency = 0.3}):Play()
					SLDragging = false 
				end 
			end)

			NewSlider.Main.Interact.MouseButton1Down:Connect(function(X)
				local Current = NewSlider.Main.Progress.AbsolutePosition.X + NewSlider.Main.Progress.AbsoluteSize.X
				local Start = Current
				local Location = X
				local Loop; Loop = RunService.Stepped:Connect(function()
					if SLDragging then
						Location = UserInputService:GetMouseLocation().X
						Current = Current + 0.025 * (Location - Start)

						if Location < NewSlider.Main.AbsolutePosition.X then
							Location = NewSlider.Main.AbsolutePosition.X
						elseif Location > NewSlider.Main.AbsolutePosition.X + NewSlider.Main.AbsoluteSize.X then
							Location = NewSlider.Main.AbsolutePosition.X + NewSlider.Main.AbsoluteSize.X
						end

						if Current < NewSlider.Main.AbsolutePosition.X + 5 then
							Current = NewSlider.Main.AbsolutePosition.X + 5
						elseif Current > NewSlider.Main.AbsolutePosition.X + NewSlider.Main.AbsoluteSize.X then
							Current = NewSlider.Main.AbsolutePosition.X + NewSlider.Main.AbsoluteSize.X
						end

						if Current <= Location and (Location - Start) < 0 then
							Start = Location
						elseif Current >= Location and (Location - Start) > 0 then
							Start = Location
						end
						TweenService:Create(NewSlider.Main.Progress, TweenInfo(0.45, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = UDim2.new(0, Current - NewSlider.Main.AbsolutePosition.X, 1, 0)}):Play()
						local NewValue = config.Range[1] + (Location - NewSlider.Main.AbsolutePosition.X) / NewSlider.Main.AbsoluteSize.X * (config.Range[2] - config.Range[1])

						NewValue = math.floor(NewValue / config.Increment + 0.5) * (config.Increment * 10000000) / 10000000
						NewValue = math.clamp(NewValue, config.Range[1], config.Range[2])

						if not config.Suffix then
							NewSlider.Main.Information.Text = tostring(NewValue)
						else
							NewSlider.Main.Information.Text = tostring(NewValue) .. " " .. config.Suffix
						end

						if config.CurrentValue ~= NewValue then
							local Success, Response = pcall(function()
								config.Callback(NewValue)
							end)
							if not Success then
								print(config.Name.." Callback Error " ..tostring(Response))
							end

							config.CurrentValue = NewValue
						end
					else
						pcall(function()
							TweenService:Create(NewSlider.Main.Progress, TweenInfo(0.3, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = UDim2.new(0, Location - NewSlider.Main.AbsolutePosition.X > 5 and Location - NewSlider.Main.AbsolutePosition.X or 5, 1, 0)}):Play()
							Loop:Disconnect()
						end)
					end
				end)
			end)

			config.Set = function(self,NewVal)
				local NewVal = math.clamp(NewVal, config.Range[1], config.Range[2])

				TweenService:Create(NewSlider.Main.Progress, TweenInfo(0.45, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = UDim2.new(0, NewSlider.Main.AbsoluteSize.X * ((NewVal + config.Range[1]) / (config.Range[2] - config.Range[1])) > 5 and NewSlider.Main.AbsoluteSize.X * (NewVal / (config.Range[2] - Config.Range[1])) or 5, 1, 0)}):Play()
				NewSlider.Main.Information.Text = tostring(NewVal) .. " " .. (config.Suffix or "")

				local Success, Response = pcall(function()
					config.Callback(NewVal)
				end)

				if not Success then
					print(config.Name.." Callback Error " ..tostring(Response))
				end

				config.CurrentValue = NewVal
			end

			return config
		end

		Tab.CreateColorPicker = function(config)
			config = {
				Name = config.Name or "ColorPicker",
				Desc = config.Desc or "No description provided",
				Color = config.Color or Color3.new(1, 1, 1),
				Callback = config.Callback or function()end,
			}

			local ColorPicker = NewPage.UIListLayout.ColorPicker:Clone()
			local Background = ColorPicker.CPBackground
			local Display = Background.Display
			local Main = Background.MainCP
			local Slider = ColorPicker.ColorSlider
			ColorPicker.ClipsDescendants = true
			ColorPicker.Name = config.Name
			ColorPicker.Title.Text = config.Name
			ColorPicker.Desc.Text = config.Desc
			ColorPicker.Visible = true
			ColorPicker.Parent = NewPage
			ColorPicker.Size = UDim2.new(1, -10, 0, 45)
			Background.Size = UDim2.new(0, 39, 0, 22)
			Display.BackgroundTransparency = 0
			Main.MainPoint.ImageTransparency = 1
			ColorPicker.Interact.Size = UDim2.new(1, 0, 1, 0)
			ColorPicker.Interact.Position = UDim2.new(0.5, 0, 0.5, 0)
			ColorPicker.RGB.Position = UDim2.new(0, 17, 0, 70)
			ColorPicker.HexInput.Position = UDim2.new(0, 17, 0, 90)
			Main.ImageTransparency = 1
			Background.BackgroundTransparency = 1

			local opened = false 
			local mouse = Players.LocalPlayer:GetMouse()
			Main.Image = "http://www.roblox.com/asset/?id=11415645739"
			local mainDragging = false 
			local sliderDragging = false 
			ColorPicker.Interact.MouseButton1Down:Connect(function()
				task.spawn(function()
					TweenService:Create(ColorPicker.UIStroke, TweenInfo(0.6, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
					task.wait(0.2)
					TweenService:Create(ColorPicker.UIStroke, TweenInfo(0.6, Enum.EasingStyle.Exponential), {Transparency = 0}):Play()
				end)

				if not opened then
					opened = true 
					TweenService:Create(Background, TweenInfo(0.45, Enum.EasingStyle.Exponential), {Size = UDim2.new(0, 18, 0, 15)}):Play()
					task.wait(0.1)
					TweenService:Create(ColorPicker, TweenInfo(0.6, Enum.EasingStyle.Exponential), {Size = UDim2.new(1, -10, 0, 120)}):Play()
					TweenService:Create(Background, TweenInfo(0.6, Enum.EasingStyle.Exponential), {Size = UDim2.new(0, 173, 0, 86)}):Play()
					TweenService:Create(Display, TweenInfo(0.6, Enum.EasingStyle.Exponential), {BackgroundTransparency = 1}):Play()
					TweenService:Create(ColorPicker.Interact, TweenInfo(0.6, Enum.EasingStyle.Exponential), {Position = UDim2.new(0.289, 0, 0.5, 0)}):Play()
					TweenService:Create(ColorPicker.RGB, TweenInfo(0.8, Enum.EasingStyle.Exponential), {Position = UDim2.new(0, 17, 0, 40)}):Play()
					TweenService:Create(ColorPicker.HexInput, TweenInfo(0.5, Enum.EasingStyle.Exponential), {Position = UDim2.new(0, 17, 0, 73)}):Play()
					TweenService:Create(ColorPicker.Interact, TweenInfo(0.6, Enum.EasingStyle.Exponential), {Size = UDim2.new(0.574, 0, 1, 0)}):Play()
					TweenService:Create(Main.MainPoint, TweenInfo(0.2, Enum.EasingStyle.Exponential), {ImageTransparency = 0}):Play()
					TweenService:Create(Background, TweenInfo(0.6, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
				else
					opened = false
					TweenService:Create(ColorPicker, TweenInfo(0.6, Enum.EasingStyle.Exponential), {Size = UDim2.new(1, -10, 0, 45)}):Play()
					TweenService:Create(Background, TweenInfo(0.6, Enum.EasingStyle.Exponential), {Size = UDim2.new(0, 39, 0, 22)}):Play()
					TweenService:Create(ColorPicker.Interact, TweenInfo(0.6, Enum.EasingStyle.Exponential), {Size = UDim2.new(1, 0, 1, 0)}):Play()
					TweenService:Create(ColorPicker.Interact, TweenInfo(0.6, Enum.EasingStyle.Exponential), {Position = UDim2.new(0.5, 0, 0.5, 0)}):Play()
					TweenService:Create(ColorPicker.RGB, TweenInfo(0.6, Enum.EasingStyle.Exponential), {Position = UDim2.new(0, 17, 0, 70)}):Play()
					TweenService:Create(ColorPicker.HexInput, TweenInfo(0.5, Enum.EasingStyle.Exponential), {Position = UDim2.new(0, 17, 0, 90)}):Play()
					TweenService:Create(Display, TweenInfo(0.6, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
					TweenService:Create(Main.MainPoint, TweenInfo(0.2, Enum.EasingStyle.Exponential), {ImageTransparency = 1}):Play()
					TweenService:Create(Main, TweenInfo(0.2, Enum.EasingStyle.Exponential), {ImageTransparency = 1}):Play()
					TweenService:Create(Background, TweenInfo(0.6, Enum.EasingStyle.Exponential), {BackgroundTransparency = 1}):Play()
				end

			end)

			UserInputService.InputEnded:Connect(function(input, gameProcessed) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then 
					mainDragging = false
					sliderDragging = false
				end end)
			Main.MouseButton1Down:Connect(function()
				if opened then
					mainDragging = true 
				end
			end)
			Main.MainPoint.MouseButton1Down:Connect(function()
				if opened then
					mainDragging = true 
				end
			end)
			Slider.MouseButton1Down:Connect(function()
				sliderDragging = true 
			end)
			Slider.SliderPoint.MouseButton1Down:Connect(function()
				sliderDragging = true 
			end)
			local h,s,v = config.Color:ToHSV()
			local color = Color3.fromHSV(h,s,v) 
			local hex = string.format("#%02X%02X%02X",color.R*0xFF,color.G*0xFF,color.B*0xFF)
			ColorPicker.HexInput.InputBox.Text = hex
			local function setDisplay()
				--Main
				Main.MainPoint.Position = UDim2.new(s,-Main.MainPoint.AbsoluteSize.X/2,1-v,-Main.MainPoint.AbsoluteSize.Y/2)
				Main.MainPoint.ImageColor3 = Color3.fromHSV(h,s,v)
				Background.BackgroundColor3 = Color3.fromHSV(h,1,1)
				Display.BackgroundColor3 = Color3.fromHSV(h,s,v)
				--Slider 
				local x = h * Slider.AbsoluteSize.X
				Slider.SliderPoint.Position = UDim2.new(0,x-Slider.SliderPoint.AbsoluteSize.X/2,0.5,0)
				Slider.SliderPoint.ImageColor3 = Color3.fromHSV(h,1,1)
				local color = Color3.fromHSV(h,s,v) 
				local r,g,b = math.floor((color.R*255)+0.5),math.floor((color.G*255)+0.5),math.floor((color.B*255)+0.5)
				ColorPicker.RGB.RInput.InputBox.Text = tostring(r)
				ColorPicker.RGB.GInput.InputBox.Text = tostring(g)
				ColorPicker.RGB.BInput.InputBox.Text = tostring(b)
				hex = string.format("#%02X%02X%02X",color.R*0xFF,color.G*0xFF,color.B*0xFF)
				ColorPicker.HexInput.InputBox.Text = hex
			end
			setDisplay()
			ColorPicker.HexInput.InputBox.FocusLost:Connect(function()
				if not pcall(function()
						local r, g, b = string.match(ColorPicker.HexInput.InputBox.Text, "^#?(%w%w)(%w%w)(%w%w)$")
						local rgbColor = Color3.fromRGB(tonumber(r, 16),tonumber(g, 16), tonumber(b, 16))
						h,s,v = rgbColor:ToHSV()
						hex = ColorPicker.HexInput.InputBox.Text
						setDisplay()
						config.Color = rgbColor
					end) 
				then 
					ColorPicker.HexInput.InputBox.Text = hex 
				end
				pcall(function()config.Callback(Color3.fromHSV(h,s,v))end)
				local r,g,b = math.floor((h*255)+0.5),math.floor((s*255)+0.5),math.floor((v*255)+0.5)
				config.Color = Color3.fromRGB(r,g,b)
			end)
			--RGB
			local function rgbBoxes(box,toChange)
				local value = tonumber(box.Text) 
				local color = Color3.fromHSV(h,s,v) 
				local oldR,oldG,oldB = math.floor((color.R*255)+0.5),math.floor((color.G*255)+0.5),math.floor((color.B*255)+0.5)
				local save 
				if toChange == "R" then save = oldR;oldR = value elseif toChange == "G" then save = oldG;oldG = value else save = oldB;oldB = value end
				if value then 
					value = math.clamp(value,0,255)
					h,s,v = Color3.fromRGB(oldR,oldG,oldB):ToHSV()

					setDisplay()
				else 
					box.Text = tostring(save)
				end
				local r,g,b = math.floor((h*255)+0.5),math.floor((s*255)+0.5),math.floor((v*255)+0.5)
				config.Color = Color3.fromRGB(r,g,b)
			end
			ColorPicker.RGB.RInput.InputBox.FocusLost:connect(function()
				rgbBoxes(ColorPicker.RGB.RInput.InputBox,"R")
				pcall(function()config.Callback(Color3.fromHSV(h,s,v))end)
			end)
			ColorPicker.RGB.GInput.InputBox.FocusLost:connect(function()
				rgbBoxes(ColorPicker.RGB.GInput.InputBox,"G")
				pcall(function()config.Callback(Color3.fromHSV(h,s,v))end)
			end)
			ColorPicker.RGB.BInput.InputBox.FocusLost:connect(function()
				rgbBoxes(ColorPicker.RGB.BInput.InputBox,"B")
				pcall(function()config.Callback(Color3.fromHSV(h,s,v))end)
			end)

			RunService.RenderStepped:connect(function()
				if mainDragging then 
					local localX = math.clamp(mouse.X-Main.AbsolutePosition.X,0,Main.AbsoluteSize.X)
					local localY = math.clamp(mouse.Y-Main.AbsolutePosition.Y,0,Main.AbsoluteSize.Y)
					Main.MainPoint.Position = UDim2.new(0,localX-Main.MainPoint.AbsoluteSize.X/2,0,localY-Main.MainPoint.AbsoluteSize.Y/2)
					s = localX / Main.AbsoluteSize.X
					v = 1 - (localY / Main.AbsoluteSize.Y)
					Display.BackgroundColor3 = Color3.fromHSV(h,s,v)
					Main.MainPoint.ImageColor3 = Color3.fromHSV(h,s,v)
					Background.BackgroundColor3 = Color3.fromHSV(h,1,1)
					local color = Color3.fromHSV(h,s,v) 
					local r,g,b = math.floor((color.R*255)+0.5),math.floor((color.G*255)+0.5),math.floor((color.B*255)+0.5)
					ColorPicker.RGB.RInput.InputBox.Text = tostring(r)
					ColorPicker.RGB.GInput.InputBox.Text = tostring(g)
					ColorPicker.RGB.BInput.InputBox.Text = tostring(b)
					ColorPicker.HexInput.InputBox.Text = string.format("#%02X%02X%02X",color.R*0xFF,color.G*0xFF,color.B*0xFF)
					pcall(function()config.Callback(Color3.fromHSV(h,s,v))end)
					config.Color = Color3.fromRGB(r,g,b)
				end
				if sliderDragging then 
					local localX = math.clamp(mouse.X-Slider.AbsolutePosition.X,0,Slider.AbsoluteSize.X)
					h = localX / Slider.AbsoluteSize.X
					Display.BackgroundColor3 = Color3.fromHSV(h,s,v)
					Slider.SliderPoint.Position = UDim2.new(0,localX-Slider.SliderPoint.AbsoluteSize.X/2,0.5,0)
					Slider.SliderPoint.ImageColor3 = Color3.fromHSV(h,1,1)
					Background.BackgroundColor3 = Color3.fromHSV(h,1,1)
					Main.MainPoint.ImageColor3 = Color3.fromHSV(h,s,v)
					local color = Color3.fromHSV(h,s,v) 
					local r,g,b = math.floor((color.R*255)+0.5),math.floor((color.G*255)+0.5),math.floor((color.B*255)+0.5)
					ColorPicker.RGB.RInput.InputBox.Text = tostring(r)
					ColorPicker.RGB.GInput.InputBox.Text = tostring(g)
					ColorPicker.RGB.BInput.InputBox.Text = tostring(b)
					ColorPicker.HexInput.InputBox.Text = string.format("#%02X%02X%02X",color.R*0xFF,color.G*0xFF,color.B*0xFF)
					pcall(function()config.Callback(Color3.fromHSV(h,s,v))end)
					config.Color = Color3.fromRGB(r,g,b)
				end
			end)

			function config:Set(RGBColor)
				config.Color = RGBColor
				h,s,v = config.Color:ToHSV()
				color = Color3.fromHSV(h,s,v)
				setDisplay()
			end

			return config
		end

		function Tab:CreateLabel(LabelText : string, Desc : string)
			local LabelValue = {}

			local Label = NewPage.UIListLayout.Label:Clone()
			Label.Title.Text = LabelText
			Label.Name = LabelText
			Label.Parent = NewPage
			Label.Desc.Text = Desc or ''

			function LabelValue:Set(NewLabel, Desc)
				Label.Title.Text = NewLabel
				Label.Desc.Text = Desc or ''
			end

			return LabelValue
		end

		function Tab:CreateDivider()
			local DividerValue = {}

			local Divider = NewPage.UIListLayout.Divider:Clone()
			Divider.Parent = NewPage

			Divider.LayoutOrder = layout
			layout += 1
			function DividerValue:Set(Value)
				Divider.Visible = Value
			end

			return DividerValue
		end
		return Tab
	end
	UiLib.Searchbar.Visible = true
	UiLib.Searchbar.Input.FocusLost:Connect(function()
		local InputText = UiLib.Searchbar.Input.Text
		for i,v in ipairs(UiLib:GetChildren()) do
			if v:FindFirstChild("Marker") and v.Marker.Value == "Page" then
				if InputText == "" then
					for i,v in ipairs(v:GetChildren()) do
						if v:IsA("Frame") then
							v.Visible = true
						end
					end
				else

					for i,v in ipairs(v:GetChildren()) do
						if v:IsA("Frame") then
							if string.find(v.Name:lower(),InputText:lower()) then
								v.Visible = true
							else
								v.Visible = false
							end
						end
					end
				end
			end
		end
	end)
	return MainUi
end


return DeltaUiLib
