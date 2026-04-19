--[[
    MENU LONG XIẾC VIP V159 (FIXED)
    - Link tạo bởi: Long Xiếc
    - Tính năng: Ghim đầu, Chạy nhanh, ESP Xanh/Đỏ chuẩn 100%.
]]

local LP = game:GetService("Players").LocalPlayer
local Cam = workspace.CurrentCamera
local UI_NAME = "LX_VIP_V159"

if LP.PlayerGui:FindFirstChild(UI_NAME) then LP.PlayerGui[UI_NAME]:Destroy() end

local Sets = { 
    AimPlr = false, AimNPC = false, ESP = false, 
    Wall = false, Speed = false, Fov = 150 
}

-- --- GIAO DIỆN LX VIP ---
local sg = Instance.new("ScreenGui", LP.PlayerGui); sg.Name = UI_NAME; sg.ResetOnSpawn = false
local Main = Instance.new("Frame", sg); Main.Size = UDim2.new(0, 240, 0, 460); Main.Position = UDim2.new(0.5, -120, 0.2, 0); Main.BackgroundColor3 = Color3.new(0,0,0); Main.Visible = false; Main.Active = true; Main.Draggable = true; Instance.new("UIStroke", Main).Color = Color3.new(1,0,0)

local Title = Instance.new("TextLabel", Main); Title.Size = UDim2.new(1,0,0,35); Title.Text = "MENU LONG XIẾC VIP V159"; Title.TextColor3 = Color3.new(1,1,1); Title.BackgroundColor3 = Color3.new(0.3, 0, 0); Title.Font = Enum.Font.SourceSansBold

local Toggle = Instance.new("TextButton", sg); Toggle.Size = UDim2.new(0, 50, 0, 50); Toggle.Position = UDim2.new(0, 15, 0.4, 0); Toggle.Text = "LX"; Toggle.BackgroundColor3 = Color3.new(0.8, 0, 0); Toggle.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", Toggle).CornerRadius = UDim.new(1,0)
Toggle.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

local function AddBtn(txt, var, pos, clr)
    local b = Instance.new("TextButton", Main); b.Size = UDim2.new(0.9, 0, 0, 42); b.Position = pos; b.Text = txt .. ": OFF"; b.BackgroundColor3 = Color3.fromRGB(35,35,35); b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.SourceSansBold; Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function()
        Sets[var] = not Sets[var]
        b.Text = txt .. (Sets[var] and ": ON" or ": OFF")
        b.BackgroundColor3 = Sets[var] and clr or Color3.fromRGB(35,35,35)
    end)
end

AddBtn("HIỆN TÊN & FOV", "ESP", UDim2.new(0.05,0,0.1,0), Color3.new(0,1,0))
AddBtn("SIÊU GHIM NGƯỜI (BLUE)", "AimPlr", UDim2.new(0.05,0,0.23,0), Color3.new(0,0.5,1))
AddBtn("SIÊU GHIM NPC (RED)", "AimNPC", UDim2.new(0.05,0,0.36,0), Color3.new(1,0,0))
AddBtn("CHECK TƯỜNG (FIXED)", "Wall", UDim2.new(0.05,0,0.49,0), Color3.new(1,1,0))
AddBtn("CHẠY NHANH (FORCE)", "Speed", UDim2.new(0.05,0,0.62,0), Color3.new(1,0.5,0))

-- --- VÒNG FOV ---
local fov_gui = Instance.new("Frame", sg); fov_gui.Size = UDim2.new(0, Sets.Fov*2, 0, Sets.Fov*2); fov_gui.AnchorPoint = Vector2.new(0.5,0.5); fov_gui.Position = UDim2.new(0.5,0,0.5,0); fov_gui.BackgroundTransparency = 1; fov_gui.Visible = false; Instance.new("UIStroke", fov_gui).Color = Color3.new(1,1,1); Instance.new("UICorner", fov_gui).CornerRadius = UDim.new(1,0)

-- --- CORE LOGIC ---
game:GetService("RunService").RenderStepped:Connect(function()
    fov_gui.Visible = Sets.ESP
    if Sets.Speed and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
        LP.Character.HumanoidRootPart.CFrame = LP.Character.HumanoidRootPart.CFrame + (LP.Character.Humanoid.MoveDirection * 2.8)
    end
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") and v:FindFirstChild("Head") and v ~= LP.Character then
            local hum = v:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                local p = game.Players:GetPlayerFromCharacter(v)
                local color = p and Color3.new(0,0.5,1) or Color3.new(1,0,0)
                if Sets.ESP then
                    local hl = v:FindFirstChild("LX_HL") or Instance.new("Highlight", v); hl.Name = "LX_HL"; hl.FillColor = color; hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    local head = v:FindFirstChild("Head")
                    local bg = head:FindFirstChild("LX_Tag") or Instance.new("BillboardGui", head); bg.Name = "LX_Tag"; bg.AlwaysOnTop = true; bg.Size = UDim2.new(0,120,0,35); bg.ExtentsOffset = Vector3.new(0,2.5,0)
                    local txt = bg:FindFirstChild("T") or Instance.new("TextLabel", bg); txt.Name = "T"; txt.BackgroundTransparency = 1; txt.Size = UDim2.new(1,0,1,0); txt.TextColor3 = color; txt.TextSize = 13; txt.Font = Enum.Font.SourceSansBold
                    txt.Text = (p and p.Name or v.Name) .. " [" .. math.floor((head.Position - Cam.CFrame.Position).Magnitude) .. "m]"
                end
                if (Sets.AimPlr and p) or (Sets.AimNPC and not p) then
                    local sPos, vis = Cam:WorldToViewportPoint(v.Head.Position)
                    if vis and (Vector2.new(sPos.X, sPos.Y) - Vector2.new(Cam.ViewportSize.X/2, Cam.ViewportSize.Y/2)).Magnitude < Sets.Fov then
                        if not Sets.Wall or #Cam:GetPartsObscuringTarget({v.Head.Position}, {LP.Character, v, Cam}) == 0 then
                            Cam.CFrame = CFrame.lookAt(Cam.CFrame.Position, v.Head.Position)
                        end
                    end
                end
            end
        end
    end
end)
