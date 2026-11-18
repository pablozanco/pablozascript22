local function SafeExists(fn) return type(fn) == "function" end
local function SafeHookFunction(fn, wrapper)
    if not SafeExists(fn) then return nil end
    local ok, orig = pcall(hookfunction, fn, wrapper)
    if ok and orig then return orig end
    return nil
end

getgenv().Bypass = {
    Enabled = true,
    BlockGetObjects = true,
    BlockHttp = true,
    BlockRemotes = true,
    SpoofGC = true,
    SpoofConn = true,
    SpoofInfo = true,
    SpoofIdentity = true,
    SpoofDrawing = true,
    BlockLoadstring = true,
    BlockThreads = true,
    RamLimit = 3500,
    Detection = false,
}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")
local ContentProvider = game:GetService("ContentProvider")
local LocalPlayer = Players.LocalPlayer

local function AntiCrash()
    local protegido = false

    local ok = pcall(function()
        hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
            local method = getnamecallmethod()
            local args = {...}

            if getgenv().Bypass.BlockHttp and (method == "HttpGetAsync" or method == "HttpGet") then
                local url = tostring(args[1])
                if url:find("github") or url:find("raw") then
                    return game:HttpGet("https://raw.githubusercontent.com/ActualMasterOogway/Fluent-Renewed/main/Fluent.luau")
                end
                if url:find("games.roblox.com") or url:find("economy.roblox.com")
                   or url:find("anticheat") or url:find("cheat") or url:find("ban")
                   or url:find("whitelist") or url:find("hwid") then
                    return '{"data":[]}'
                end
            end

            if getgenv().Bypass.BlockRemotes and (method == "FireServer" or method == "InvokeServer") then
                local n = tostring(self.Name):lower()
                if n:find("kick") or n:find("ban") or n:find("detect") or n:find("crash")
                   or n:find("exploit") or n:find("cheat") or n:find("anti")
                   or n:find("punish") or n:find("report") then
                    getgenv().Bypass.Detection = true
                    return
                end
            end

            if getgenv().Bypass.BlockGetObjects and method == "GetObjects" and self == ContentProvider then
                return {}
            end

            return oldNamecall(self, ...)
        end))
    end)
    local oldNamecall = ok and hookmetamethod(game, "__namecall", newcclosure(function() end)) or nil

    pcall(function()
        hookmetamethod(game, "__index", newcclosure(function(self, key)
            if key == "HttpGet" or key == "HttpGetAsync" then
                return function(url)
                    if getgenv().Bypass.BlockHttp and (tostring(url):find("anticheat") or tostring(url):find("ban") or tostring(url):find("hwid")) then
                        return '{"data":[]}'
                    end
                    return oldIndex(self, key)(self, url)
                end
            end
            return oldIndex(self, key)
        end))
    end)

    if getgenv().Bypass.SpoofGC and SafeExists(getgc) then
        SafeHookFunction(getgc, newcclosure(function(...)
            local res = {}
            local ok, lista = pcall(getgc, ...)
            if ok and lista then
                for _, v in ipairs(lista) do
                    if type(v) == "function" then
                        local ok2, info = pcall(getinfo, v)
                        if ok2 and info and info.source then
                            if info.source:find("Pabloza") or info.source:find("xit") or info.source:find("Bypass") then
                            else
                                table.insert(res, v)
                            end
                        else
                            table.insert(res, v)
                        end
                    else
                        table.insert(res, v)
                    end
                end
            end
            return res
        end))
    end

    if getgenv().Bypass.SpoofConn and SafeExists(getconnections) then
        SafeHookFunction(getconnections, newcclosure(function(...)
            local ok, lista = pcall(getconnections, ...)
            if ok and lista then
                local res = {}
                for _, c in ipairs(lista) do
                    local ok2, fn = pcall(function() return c.Function end)
                    if ok2 and fn then
                        local ok3, info = pcall(getinfo, fn)
                        if not (ok3 and info and info.source and info.source:find("Pabloza")) then
                            table.insert(res, c)
                        end
                    else
                        table.insert(res, c)
                    end
                end
                return res
            end
            return lista
        end))
    end

    if getgenv().Bypass.SpoofInfo and SafeExists(getinfo) then
        SafeHookFunction(getinfo, newcclosure(function(...)
            local ok, info = pcall(getinfo, ...)
            if ok and info then
                info.source = "print"
                info.short_src = "print"
                info.what = "Lua"
                info.linedefined = 0
                info.lastlinedefined = 0
                info.currentline = -1
                info.nups = 0
                info.nparams = 0
                info.isvararg = false
                info.func = nil
            end
            return info
        end))
    end

    if getgenv().Bypass.SpoofIdentity then
        local fakeUserId = 100000000
        local fakeJobId = "00000000-0000-0000-0000-000000000000"
        local fakePlaceId = 4483381587
        local fakeGameId = 4483381587

        local oldGetUser = SafeHookFunction(identity, function() return 8 end)
        getgenv().SpoofedUserId = fakeUserId
    end

    if getgenv().Bypass.SpoofDrawing and SafeExists(gethui) then
        SafeHookFunction(gethui, newcclosure(function(...) return {} end))
    end
    if getgenv().Bypass.SpoofDrawing and SafeExists(getdrawings) then
        SafeHookFunction(getdrawings, newcclosure(function(...) return {} end))
    end

    local spoofs = {
        {getnilinstances, function() return {} end},
        {getinstances, function() return {} end},
        {getobjects, function() return {} end},
        {getloadedmodules, function() return {} end},
        {getmodules, function() return {} end},
        {getcallingscript, function() return nil end},
        {getthreadcontext, function() return nil end},
        {getupvalue, function() return nil end},
        {setupvalue, function() return false end},
        {getcustomasset, function() return "" end},
        {getasset, function() return "" end},
        {gettexture, function() return "" end},
        {getrenderproperty, function() return nil end},
        {setrenderproperty, function() return false end},
        {getsignals, function() return {} end},
        {getevents, function() return {} end},
        {getconnections, function() return {} end},
    }
    for _, s in ipairs(spoofs) do
        if SafeExists(s[1]) then
            SafeHookFunction(s[1], newcclosure(s[2]))
        end
    end

    if getgenv().Bypass.BlockLoadstring and SafeExists(loadstring) then
        SafeHookFunction(loadstring, newcclosure(function(...)
            local ok, result = pcall(loadstring, ...)
            if not ok then return nil, "Erro protegido" end
            if result then
                return function(...)
                    local ok2, err = pcall(result, ...)
                    if not ok2 then return nil, "Erro protegido" end
                    return ok2, err
                end
            end
            return result
        end))
    end

    if getgenv().Bypass.BlockThreads and SafeExists(task) then
        pcall(function()
            local oldSpawn = task.spawn
            task.spawn = newcclosure(function(...)
                local args = {...}
                if type(args[1]) == "function" then
                    local func = args[1]
                    args[1] = function(...)
                        local ok, err = pcall(func, ...)
                        if not ok then return nil end
                        return ok, err
                    end
                end
                return oldSpawn(unpack(args))
            end)
        end)
    end

    local ultimaLimpeza = 0
    RunService.Heartbeat:Connect(function()
        if not getgenv().Bypass.Enabled then return end
        local t = os.clock()
        if t - ultimaLimpeza < 5 then return end
        ultimaLimpeza = t
        local ok, mem = pcall(function() return collectgarbage("count") end)
        if ok and mem and mem > getgenv().Bypass.RamLimit * 1024 then
            collectgarbage("collect")
            getgenv().Bypass.Detection = true
        end
    end)

    getgenv().Bypass.Active = true
end

local okBypass = pcall(AntiCrash)

if not Drawing then
    getgenv().Drawing = {
        new = function(kind)
            local obj = {}
            obj.Visible = false
            obj.Color = Color3.new(1,1,1)
            obj.Thickness = 1
            obj.Transparency = 0
            obj.Position = Vector2.new(0,0)
            obj.Size = Vector2.new(100,100)
            obj.Radius = 50
            obj.Filled = false
            obj.NumSides = 4
            obj.From = Vector2.new(0,0)
            obj.To = Vector2.new(100,100)
            obj.Text = ""
            obj.TextSize = 13
            obj.Font = Enum.Font.Gotham
            obj.TextColor = Color3.new(1,1,1)
            obj.Remove = function() end
            return obj
        end
    }
end

local Library = loadstring(game:HttpGetAsync("https://github.com/ActualMasterOogway/Fluent-Renewed/releases/latest/download/Fluent.luau"))()

local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

local Char, Hum, Root
local function AtualizarChar(c)
    Char = c
    Hum = c:WaitForChild("Humanoid")
    Root = c:WaitForChild("HumanoidRootPart")
end
if LocalPlayer.Character then AtualizarChar(LocalPlayer.Character) end
LocalPlayer.CharacterAdded:Connect(AtualizarChar)

local CFG = {
    Aimbot = false,
    SilentAim = false,
    MagicBullet = false,
    WallBang = false,
    AutoLock = false,
    HoldAim = false,
    AimKey = Enum.KeyCode.RightMouseButton,
    KillAura = false,
    KillAuraRange = 20,
    AutoClicker = false,
    ClickSpeed = 12,
    AutoShoot = false,
    TargetLine = false,
    AntiRecoil = false,
    Prediction = false,
    PredForca = 0.12,
    Suavidade = 0.2,
    FOV = 140,
    Hitbox = 1.5,
    HitboxExp = false,
    HitboxScale = 2.2,
    Parte = "Head",
    TeamCheck = false,
    MostrarFOV = false,
    Prioridade = "Crosshair",
    WallCheck = false,

    ESP = {
        Highlight = false,
        Caixa = false,
        Skeleton = false,
        Nomes = false,
        Distancia = false,
        Tracer = false,
        Vida = false,
        Chams = false,
        Flags = false,
        Armas = false,
        CorTime = false,
        TargetHL = false,
        Cor = Color3.fromRGB(0, 255, 140),
        TamanhoTexto = 13
    },

    SpeedOn = false,
    SpeedModo = "Suave",
    SpeedVal = 22,
    Noclip = false,
    Fly = false,
    FlyModo = "Colisao",
    FlySpeed = 45,
    InfJump = false,
    NoFall = false,
    Bhop = false,
    JumpBoost = false,
    JumpVal = 50,
    BlinkDist = 18,
    Fullbright = false,
    NoFog = false,
    XRay = false,
    AntiAFK = false,
    CamFOV = 70,
    Radar = false,
    TPClick = false,
}

local HitboxOriginais = {}
local LightingOriginal = {
    Brightness = Lighting.Brightness,
    Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    FogEnd = Lighting.FogEnd,
    FogStart = Lighting.FogStart,
    ClockTime = Lighting.ClockTime
}
local XRayParts = {}
local ESPObjs = {}
local RadarDots = {}
local NoclipConn, FlyConn, FlyBV, FlyBG, SpeedConn, InfJumpConn, NoFallConn, AFKConn, BhopConn, JumpConn
local AlvoAtual = nil
local AlvoAtualChar = nil
local AlvoCor = Color3.fromRGB(255, 80, 80)

local function MesmoTime(p)
    if not CFG.TeamCheck then return false end
    if LocalPlayer.Team and p.Team then return LocalPlayer.Team == p.Team end
    return false
end

local function Visivel(parte)
    if not parte or not Root then return false end
    local origin = Camera.CFrame.Position
    local dir = parte.Position - origin
    local params = RaycastParams.new()
    params.FilterDescendantsInstances = {Char, parte.Parent}
    params.FilterType = Enum.RaycastFilterType.Blacklist
    local r = workspace:Raycast(origin, dir, params)
    return r == nil or (r.Instance and r.Instance:IsDescendantOf(parte.Parent))
end

local function PegarAlvo()
    local melhor, melhorScore = nil, math.huge
    local centro = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local fov = CFG.FOV

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and not MesmoTime(p) then
            local h = p.Character:FindFirstChildOfClass("Humanoid")
            local parte = p.Character:FindFirstChild(CFG.Parte) or p.Character:FindFirstChild("HumanoidRootPart")
            if h and h.Health > 0 and parte then
                if CFG.WallCheck and not Visivel(parte) then continue end
                local sp, on = Camera:WorldToViewportPoint(parte.Position)
                if on and sp.Z > 0 then
                    local distTela = (Vector2.new(sp.X, sp.Y) - centro).Magnitude
                    local dist3D = Root and (Root.Position - parte.Position).Magnitude or 999
                    if distTela <= fov then
                        local score = distTela
                        if CFG.Prioridade == "Distancia" then score = dist3D
                        elseif CFG.Prioridade == "Vida" then score = h.Health
                        elseif CFG.Prioridade == "Visivel" then score = Visivel(parte) and distTela or distTela + 500
                        end
                        if score < melhorScore then
                            melhorScore = score
                            melhor = parte
                        end
                    end
                end
            end
        end
    end
    return melhor
end

local function PosAlvo(parte)
    local pos = parte.Position
    if CFG.Parte == "Head" then pos = pos + Vector3.new(0, 0.1, 0) end
    if CFG.Prediction and parte.Parent then
        local r = parte.Parent:FindFirstChild("HumanoidRootPart")
        if r then pos = pos + r.AssemblyLinearVelocity * CFG.PredForca end
    end
    return pos
end

local function MagicBulletRay(origin, dir)
    local params = RaycastParams.new()
    params.FilterDescendantsInstances = {Char}
    params.FilterType = Enum.RaycastFilterType.Blacklist
    return workspace:Raycast(origin, dir * 1000, params)
end

local function HookMouse()
    local hookado = false
    pcall(function()
        local oldHit = hookmetamethod(Mouse, "__index", newcclosure(function(self, key)
            if key == "Hit" or key == "Target" then
                if CFG.SilentAim and AlvoAtual then
                    local pos = PosAlvo(AlvoAtual)
                    local cf = CFrame.lookAt(Camera.CFrame.Position, pos)
                    if key == "Hit" then return cf end
                    if key == "Target" then return AlvoAtual end
                end
            end
            return oldHit(self, key)
        end))
        hookado = true
    end)
    return hookado
end

local function HookFireServer()
    local hookado = false
    pcall(function()
        local oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
            local method = getnamecallmethod()
            if (method == "FireServer" or method == "InvokeServer") and self:IsA("RemoteEvent") then
                local args = {...}
                if CFG.MagicBullet and AlvoAtual and args[1] then
                    local pos = PosAlvo(AlvoAtual)
                    for i = 1, #args do
                        if typeof(args[i]) == "CFrame" then
                            args[i] = CFrame.lookAt(args[i].Position, pos)
                        elseif typeof(args[i]) == "Vector3" then
                            args[i] = pos
                        end
                    end
                    return oldNamecall(self, unpack(args))
                end
            end
            return oldNamecall(self, ...)
        end))
        hookado = true
    end)
    return hookado
end

local SilentAimHooked = HookMouse()
local MagicBulletHooked = HookFireServer()

local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1
FOVCircle.NumSides = 64
FOVCircle.Filled = false
FOVCircle.Color = Color3.fromRGB(0, 255, 140)
FOVCircle.Visible = false

local TargetLine = Drawing.new("Line")
TargetLine.Thickness = 1.2
TargetLine.Color = Color3.fromRGB(255, 80, 80)
TargetLine.Visible = false

local function AntiRecoilLoop()
    if not CFG.AntiRecoil or not Camera then return end
end

local function KillAuraLoop()
    if not CFG.KillAura or not Root then return end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and not MesmoTime(p) then
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            local h = p.Character:FindFirstChildOfClass("Humanoid")
            if hrp and h and h.Health > 0 then
                local dist = (Root.Position - hrp.Position).Magnitude
                if dist <= CFG.KillAuraRange then
                    pcall(function()
                        for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
                            if tool:IsA("Tool") then
                                local rem = tool:FindFirstChildOfClass("RemoteEvent")
                                if rem then rem:FireServer(p, h) end
                            end
                        end
                    end)
                end
            end
        end
    end
end

local function AutoClickerLoop()
    if not CFG.AutoClicker or not Mouse then return end
    pcall(function()
        Vim:SendMouseButtonEvent(0, 0, 0, true, game, 0)
        task.wait(0.02)
        Vim:SendMouseButtonEvent(0, 0, 0, false, game, 0)
    end)
end

local function AplicarHitbox(p, on)
    local c = p.Character
    if not c then return end
    for _, nome in ipairs({"Head", "HumanoidRootPart"}) do
        local part = c:FindFirstChild(nome)
        if part and part:IsA("BasePart") then
            local key = p.UserId .. nome
            if on then
                if not HitboxOriginais[key] then HitboxOriginais[key] = part.Size end
                part.Size = HitboxOriginais[key] * CFG.HitboxScale
                part.Transparency = math.min(part.Transparency, 0.4)
                part.CanCollide = false
            else
                if HitboxOriginais[key] then
                    part.Size = HitboxOriginais[key]
                    HitboxOriginais[key] = nil
                end
            end
        end
    end
end

local function AtualizarHitboxes()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            AplicarHitbox(p, CFG.HitboxExp and not MesmoTime(p))
        end
    end
end

local function LimparESP(p)
    local o = ESPObjs[p]
    if not o then return end
    for _, v in pairs(o) do
        if typeof(v) == "Instance" then pcall(function() v:Destroy() end)
        elseif typeof(v) == "table" then
            for _, x in pairs(v) do pcall(function() if x.Remove then x:Remove() end end) end
        else pcall(function() if v.Remove then v:Remove() end end) end
    end
    ESPObjs[p] = nil
end

local function Linha()
    local l = Drawing.new("Line")
    l.Thickness = 1.4
    l.Visible = false
    return l
end

local function CriarESP(p)
    if p == LocalPlayer then return end
    LimparESP(p)
    local c = p.Character
    if not c or not c:FindFirstChild("HumanoidRootPart") then return end
    local d = {}
    local hl = Instance.new("Highlight")
    hl.FillTransparency = 0.55
    hl.OutlineTransparency = 0
    hl.Enabled = false
    hl.Parent = c
    d.HL = hl
    local bb = Instance.new("BillboardGui")
    bb.Size = UDim2.new(0, 220, 0, 70)
    bb.StudsOffset = Vector3.new(0, 3.4, 0)
    bb.AlwaysOnTop = true
    bb.Adornee = c.HumanoidRootPart
    bb.Enabled = false
    bb.Parent = c.HumanoidRootPart
    local flag = Instance.new("TextLabel")
    flag.Size = UDim2.new(1, 0, 1, 0)
    flag.BackgroundTransparency = 1
    flag.TextStrokeTransparency = 0.4
    flag.Font = Enum.Font.GothamBold
    flag.TextSize = CFG.ESP.TamanhoTexto
    flag.TextColor3 = CFG.ESP.Cor
    flag.Parent = bb
    d.BB = bb
    d.Flag = flag
    local box = Drawing.new("Square")
    box.Thickness = 1.5
    box.Filled = false
    box.Visible = false
    d.Box = box
    local filled = Drawing.new("Square")
    filled.Thickness = 1
    filled.Filled = true
    filled.Color = CFG.ESP.Cor
    filled.Transparency = 0.85
    filled.Visible = false
    d.Filled = filled
    local tr = Drawing.new("Line")
    tr.Thickness = 1.2
    tr.Visible = false
    d.Tracer = tr
    local vidaBG = Drawing.new("Square")
    vidaBG.Filled = true
    vidaBG.Color = Color3.new(0, 0, 0)
    vidaBG.Transparency = 0.4
    vidaBG.Visible = false
    local vidaFG = Drawing.new("Square")
    vidaFG.Filled = true
    vidaFG.Color = Color3.fromRGB(0, 255, 100)
    vidaFG.Visible = false
    d.VidaBG = vidaBG
    d.VidaFG = vidaFG
    d.Sk = {Linha(), Linha(), Linha(), Linha(), Linha(), Linha(), Linha(), Linha(), Linha()}
    ESPObjs[p] = d
end

local function W2S(pos)
    local v, on = Camera:WorldToViewportPoint(pos)
    return Vector2.new(v.X, v.Y), on and v.Z > 0, v.Z
end

local function SkLine(l, a, b, cor)
    if not a or not b then l.Visible = false return end
    local p1, v1 = W2S(a.Position)
    local p2, v2 = W2S(b.Position)
    if v1 and v2 then
        l.From = p1
        l.To = p2
        l.Color = cor
        l.Visible = true
    else
        l.Visible = false
    end
end

local function OlhandoPraVoce(p)
    local hrp = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
    if not hrp or not Root then return false end
    local look = hrp.CFrame.LookVector
    local dir = (Root.Position - hrp.Position).Unit
    return look:Dot(dir) > 0.75
end

local function CorDoPlayer(p)
    if CFG.ESP.CorTime and p.Team then
        if p.Team == LocalPlayer.Team then
            return Color3.fromRGB(0, 255, 100)
        else
            return Color3.fromRGB(255, 80, 80)
        end
    end
    return CFG.ESP.Cor
end

local function ESPLoop()
    for _, p in pairs(Players:GetPlayers()) do
        if p == LocalPlayer or MesmoTime(p) then
            LimparESP(p)
            continue
        end
        local c = p.Character
        local h = c and c:FindFirstChildOfClass("Humanoid")
        local hrp = c and c:FindFirstChild("HumanoidRootPart")
        if not c or not h or not hrp or h.Health <= 0 then
            LimparESP(p)
            continue
        end
        if not ESPObjs[p] then CriarESP(p) end
        local d = ESPObjs[p]
        if not d then continue end
        local cor = CorDoPlayer(p)

        local isTarget = (AlvoAtual and AlvoAtual.Parent == c)
        if CFG.ESP.TargetHL and isTarget then
            cor = Color3.fromRGB(255, 220, 40)
        end

        if d.HL then
            d.HL.Enabled = CFG.ESP.Highlight or CFG.ESP.Chams
            d.HL.FillColor = cor
            d.HL.OutlineColor = Color3.new(1, 1, 1)
            d.HL.FillTransparency = CFG.ESP.Chams and 0.35 or 0.55
            if d.HL.Parent ~= c then d.HL.Parent = c end
        end
        local pos, on, z = W2S(hrp.Position)
        local dist = Root and (Root.Position - hrp.Position).Magnitude or 0
        if d.BB and d.Flag then
            local show = CFG.ESP.Nomes or CFG.ESP.Distancia or CFG.ESP.Flags
            d.BB.Enabled = show
            d.BB.Adornee = hrp
            d.Flag.TextSize = CFG.ESP.TamanhoTexto
            if CFG.ESP.Flags then
                local mir = OlhandoPraVoce(p) and " | MIRANDO" or ""
                d.Flag.Text = string.format("%s | %d HP | %dm%s", p.Name, math.floor(h.Health), math.floor(dist), mir)
            elseif CFG.ESP.Nomes and CFG.ESP.Distancia then
                d.Flag.Text = p.Name .. " | " .. math.floor(dist) .. "m"
            elseif CFG.ESP.Nomes then
                d.Flag.Text = p.Name
            else
                d.Flag.Text = math.floor(dist) .. "m"
            end
            d.Flag.TextColor3 = cor
        end
        if d.Box and d.Filled then
            if on and (CFG.ESP.Caixa or CFG.ESP.Chams) then
                local t = math.clamp(2000 / z, 16, 85)
                local w, hh = t * 0.7, t * 1.3
                local bp = Vector2.new(pos.X - w / 2, pos.Y - hh / 2)
                d.Box.Size = Vector2.new(w, hh)
                d.Box.Position = bp
                d.Box.Color = cor
                d.Box.Visible = CFG.ESP.Caixa
                d.Filled.Size = Vector2.new(w, hh)
                d.Filled.Position = bp
                d.Filled.Color = cor
                d.Filled.Visible = CFG.ESP.Chams
            else
                d.Box.Visible = false
                d.Filled.Visible = false
            end
        end
        if d.Tracer then
            if on and CFG.ESP.Tracer and Root then
                local de = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                d.Tracer.From = de
                d.Tracer.To = pos
                d.Tracer.Color = cor
                d.Tracer.Visible = true
            else
                d.Tracer.Visible = false
            end
        end
        if d.VidaBG and d.VidaFG then
            if on and CFG.ESP.Vida then
                local t = math.clamp(2000 / z, 16, 85)
                local w, hh = 4, t * 1.3
                local pct = math.clamp(h.Health / math.max(h.MaxHealth, 1), 0, 1)
                local bp = Vector2.new(pos.X - t * 0.45 - 8, pos.Y - hh / 2)
                d.VidaBG.Size = Vector2.new(w, hh)
                d.VidaBG.Position = bp
                d.VidaBG.Visible = true
                d.VidaFG.Size = Vector2.new(w, hh * pct)
                d.VidaFG.Position = Vector2.new(bp.X, bp.Y + hh * (1 - pct))
                d.VidaFG.Color = Color3.fromRGB(255 * (1 - pct), 255 * pct, 40)
                d.VidaFG.Visible = true
            else
                d.VidaBG.Visible = false
                d.VidaFG.Visible = false
            end
        end
        if d.Sk then
            if CFG.ESP.Skeleton then
                local head = c:FindFirstChild("Head")
                local ut = c:FindFirstChild("UpperTorso") or c:FindFirstChild("Torso")
                local lt = c:FindFirstChild("LowerTorso") or ut
                local lua_ = c:FindFirstChild("LeftUpperArm") or c:FindFirstChild("Left Arm")
                local rua = c:FindFirstChild("RightUpperArm") or c:FindFirstChild("Right Arm")
                local lla = c:FindFirstChild("LeftLowerArm") or lua_
                local rla = c:FindFirstChild("RightLowerArm") or rua
                local lul = c:FindFirstChild("LeftUpperLeg") or c:FindFirstChild("Left Leg")
                local rul = c:FindFirstChild("RightUpperLeg") or c:FindFirstChild("Right Leg")
                local lll = c:FindFirstChild("LeftLowerLeg") or lul
                local rll = c:FindFirstChild("RightLowerLeg") or rul
                SkLine(d.Sk[1], head, ut, cor)
                SkLine(d.Sk[2], ut, lua_, cor)
                SkLine(d.Sk[3], ut, rua, cor)
                SkLine(d.Sk[4], lua_, lla, cor)
                SkLine(d.Sk[5], rua, rla, cor)
                SkLine(d.Sk[6], lt, lul, cor)
                SkLine(d.Sk[7], lt, rul, cor)
                SkLine(d.Sk[8], lul, lll, cor)
                SkLine(d.Sk[9], rul, rll, cor)
            else
                for _, l in pairs(d.Sk) do l.Visible = false end
            end
        end
    end
end

local ItemESPLines = {}
local function ESPArmasLoop()
    if not CFG.ESP.Armas or not Root then
        for _, l in pairs(ItemESPLines) do l.Visible = false end
        return
    end
    local items = workspace:FindFirstChild("DroppedItems") or workspace:FindFirstChild("Items")
        or workspace:FindFirstChild("Loot") or workspace
    local i = 0
    for _, part in pairs(items:GetDescendants()) do
        if part:IsA("BasePart") and not part:IsDescendantOf(Char) then
            local nome = part.Name:lower()
            if nome:find("gun") or nome:find("weapon") or nome:find("rifle") or nome:find("pistol")
               or nome:find("ammo") or nome:find("armor") or nome:find("shield") then
                local dist = (Root.Position - part.Position).Magnitude
                if dist < 80 then
                    i += 1
                    if not ItemESPLines[i] then
                        local l = Drawing.new("Line")
                        l.Thickness = 1
                        l.Color = Color3.fromRGB(255, 200, 0)
                        ItemESPLines[i] = l
                    end
                    local sp, on = W2S(part.Position)
                    if on then
                        ItemESPLines[i].From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                        ItemESPLines[i].To = sp
                        ItemESPLines[i].Visible = true
                    else
                        ItemESPLines[i].Visible = false
                    end
                end
            end
        end
    end
    for j = i + 1, #ItemESPLines do
        ItemESPLines[j].Visible = false
    end
end

local RadarBG = Drawing.new("Circle")
RadarBG.Filled = true
RadarBG.Color = Color3.fromRGB(20, 20, 25)
RadarBG.Transparency = 0.35
RadarBG.NumSides = 64
RadarBG.Visible = false
local RadarBorder = Drawing.new("Circle")
RadarBorder.Filled = false
RadarBorder.Color = Color3.fromRGB(0, 255, 140)
RadarBorder.NumSides = 64
RadarBorder.Thickness = 1
RadarBorder.Visible = false
local RadarMe = Drawing.new("Circle")
RadarMe.Filled = true
RadarMe.Color = Color3.fromRGB(255, 255, 255)
RadarMe.NumSides = 12
RadarMe.Radius = 3
RadarMe.Visible = false

local function RadarLoop()
    local cx, cy = 120, Camera.ViewportSize.Y - 120
    local raio = 90
    RadarBG.Position = Vector2.new(cx, cy)
    RadarBG.Radius = raio
    RadarBG.Visible = CFG.Radar
    RadarBorder.Position = Vector2.new(cx, cy)
    RadarBorder.Radius = raio
    RadarBorder.Visible = CFG.Radar
    RadarMe.Position = Vector2.new(cx, cy)
    RadarMe.Visible = CFG.Radar
    for _, d in pairs(RadarDots) do d.Visible = false end
    if not CFG.Radar or not Root then return end
    local i = 0
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and not MesmoTime(p) and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            i += 1
            if not RadarDots[i] then
                local d = Drawing.new("Circle")
                d.Filled = true
                d.NumSides = 8
                d.Radius = 3
                RadarDots[i] = d
            end
            local rel = Root.CFrame:PointToObjectSpace(p.Character.HumanoidRootPart.Position)
            local scale = raio / 120
            local x = cx + math.clamp(rel.X * scale, -raio + 4, raio - 4)
            local y = cy + math.clamp(rel.Z * scale, -raio + 4, raio - 4)
            RadarDots[i].Position = Vector2.new(x, y)
            RadarDots[i].Color = CorDoPlayer(p)
            RadarDots[i].Visible = true
        end
    end
end

local lastAutoClick = 0
local lastKillAura = 0

RunService.RenderStepped:Connect(function()
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    FOVCircle.Radius = CFG.FOV
    FOVCircle.Visible = CFG.MostrarFOV
    ESPLoop()
    ESPArmasLoop()
    RadarLoop()
    AtualizarHitboxes()

    local aimAtivo = CFG.Aimbot or CFG.SilentAim or CFG.AutoLock or CFG.AutoShoot or CFG.MagicBullet
    if aimAtivo then
        local podeMirar = true
        if CFG.HoldAim then
            if CFG.AimKey == Enum.KeyCode.RightMouseButton then
                podeMirar = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
            else
                podeMirar = UserInputService:IsKeyDown(CFG.AimKey)
            end
        end
        if podeMirar then
            AlvoAtual = PegarAlvo()
            AlvoAtualChar = AlvoAtual and AlvoAtual.Parent or nil
        else
            AlvoAtual = nil
            AlvoAtualChar = nil
        end
    else
        AlvoAtual = nil
        AlvoAtualChar = nil
    end

    if AlvoAtual and CFG.Aimbot and not CFG.SilentAim then
        local pos = PosAlvo(AlvoAtual)
        local cf = CFrame.lookAt(Camera.CFrame.Position, pos)
        Camera.CFrame = Camera.CFrame:Lerp(cf, math.clamp(CFG.Suavidade, 0.05, 0.6))
    end

    if AlvoAtual and CFG.TargetLine and Root then
        local sp, on = W2S(AlvoAtual.Position)
        if on then
            TargetLine.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
            TargetLine.To = sp
            TargetLine.Visible = true
        else
            TargetLine.Visible = false
        end
    else
        TargetLine.Visible = false
    end

    if AlvoAtual and CFG.AutoShoot then
        pcall(function()
            Vim:SendMouseButtonEvent(0, 0, 0, true, game, 0)
        end)
    end

    if CFG.AntiRecoil then AntiRecoilLoop() end

    local t = os.clock()
    if t - lastKillAura > 0.5 then
        lastKillAura = t
        KillAuraLoop()
    end

    if CFG.AutoClicker and t - lastAutoClick > (1 / CFG.ClickSpeed) then
        lastAutoClick = t
        AutoClickerLoop()
    end
end)

local function SetSpeed(on)
    CFG.SpeedOn = on
    if SpeedConn then SpeedConn:Disconnect() SpeedConn = nil end
    if not on then
        pcall(function() if Hum then Hum.WalkSpeed = 16 end end)
        return
    end
    SpeedConn = RunService.Heartbeat:Connect(function()
        if not CFG.SpeedOn or not Hum or Hum.Health <= 0 then return end
        local maxV = CFG.SpeedModo == "Suave" and math.clamp(CFG.SpeedVal, 16, 22) or math.clamp(CFG.SpeedVal, 16, 25)
        pcall(function() Hum.WalkSpeed = maxV end)
    end)
end

local function SetNoclip(on)
    CFG.Noclip = on
    if NoclipConn then NoclipConn:Disconnect() NoclipConn = nil end
    if on then
        NoclipConn = RunService.Stepped:Connect(function()
            if not Char then return end
            for _, p in pairs(Char:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = false end
            end
        end)
    elseif Char then
        for _, p in pairs(Char:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = true end
        end
    end
end

local function SetFly(on)
    CFG.Fly = on
    if FlyConn then FlyConn:Disconnect() FlyConn = nil end
    if FlyBV then FlyBV:Destroy() FlyBV = nil end
    if FlyBG then FlyBG:Destroy() FlyBG = nil end
    if not on or not Root then return end
    local force = CFG.FlyModo == "Normal" and 9e9 or (CFG.FlyModo == "Stealth" and 25000 or 45000)
    local spd = CFG.FlyModo == "Stealth" and math.min(CFG.FlySpeed, 25) or math.min(CFG.FlySpeed, 60)
    FlyBV = Instance.new("BodyVelocity")
    FlyBV.MaxForce = Vector3.new(force, force, force)
    FlyBV.Velocity = Vector3.zero
    FlyBV.Parent = Root
    FlyBG = Instance.new("BodyGyro")
    FlyBG.MaxTorque = Vector3.new(8e4, 8e4, 8e4)
    FlyBG.P = 4e3
    FlyBG.Parent = Root
    FlyConn = RunService.RenderStepped:Connect(function()
        if not CFG.Fly or not Root or not FlyBV then return end
        if CFG.FlyModo ~= "Normal" and Char then
            for _, p in pairs(Char:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = true end
            end
        end
        FlyBG.CFrame = Camera.CFrame
        local dir = Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir -= Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir += Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.yAxis end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir -= Vector3.yAxis end
        FlyBV.Velocity = dir.Magnitude > 0 and dir.Unit * spd or Vector3.zero
    end)
end

local function SetInfJump(on)
    CFG.InfJump = on
    if InfJumpConn then InfJumpConn:Disconnect() InfJumpConn = nil end
    if on then
        InfJumpConn = UserInputService.JumpRequest:Connect(function()
            if Hum then Hum:ChangeState(Enum.HumanoidStateType.Jumping) end
        end)
    end
end

local function SetNoFall(on)
    CFG.NoFall = on
    if NoFallConn then NoFallConn:Disconnect() NoFallConn = nil end
    if on and Hum then
        NoFallConn = Hum.StateChanged:Connect(function(_, new)
            if new == Enum.HumanoidStateType.Freefall or new == Enum.HumanoidStateType.FallingDown then
                pcall(function() Hum:ChangeState(Enum.HumanoidStateType.GettingUp) end)
            end
        end)
        pcall(function()
            Hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            Hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        end)
    end
end

local function SetBhop(on)
    CFG.Bhop = on
    if BhopConn then BhopConn:Disconnect() BhopConn = nil end
    if on then
        BhopConn = RunService.Heartbeat:Connect(function()
            if not CFG.Bhop or not Hum or not Root then return end
            if Hum:GetState() == Enum.HumanoidStateType.Running or Hum:GetState() == Enum.HumanoidStateType.Landed then
                Hum:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    end
end

local function SetJumpBoost(on)
    CFG.JumpBoost = on
    if JumpConn then JumpConn:Disconnect() JumpConn = nil end
    if on and Hum then
        pcall(function() Hum.UseJumpPower = true end)
        JumpConn = RunService.Heartbeat:Connect(function()
            if CFG.JumpBoost and Hum then
                pcall(function() Hum.JumpPower = CFG.JumpVal end)
            end
        end)
    elseif Hum then
        pcall(function() Hum.JumpPower = 50 end)
    end
end

local function Blink()
    if not Root then return end
    Root.CFrame = Root.CFrame + Camera.CFrame.LookVector * CFG.BlinkDist
end

local function SetFullbright(on)
    CFG.Fullbright = on
    if on then
        Lighting.Brightness = 2
        Lighting.Ambient = Color3.new(1, 1, 1)
        Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
        Lighting.ClockTime = 14
    else
        Lighting.Brightness = LightingOriginal.Brightness
        Lighting.Ambient = LightingOriginal.Ambient
        Lighting.OutdoorAmbient = LightingOriginal.OutdoorAmbient
        Lighting.ClockTime = LightingOriginal.ClockTime
    end
end

local function SetNoFog(on)
    CFG.NoFog = on
    if on then
        Lighting.FogEnd = 1e6
        Lighting.FogStart = 1e6
    else
        Lighting.FogEnd = LightingOriginal.FogEnd
        Lighting.FogStart = LightingOriginal.FogStart
    end
end

local function SetXRay(on)
    CFG.XRay = on
    if not on then
        for part, t in pairs(XRayParts) do
            pcall(function() part.LocalTransparencyModifier = t end)
        end
        table.clear(XRayParts)
        return
    end
end

RunService.Heartbeat:Connect(function()
    if not CFG.XRay or not Root then return end
    for _, part in pairs(workspace:GetPartBoundsInRadius(Root.Position, 70)) do
        if part:IsA("BasePart") and not part:IsDescendantOf(Char) then
            if not XRayParts[part] then XRayParts[part] = part.LocalTransparencyModifier end
            part.LocalTransparencyModifier = 0.65
        end
    end
end)

local function SetAntiAFK(on)
    CFG.AntiAFK = on
    if AFKConn then AFKConn:Disconnect() AFKConn = nil end
    if on then
        AFKConn = LocalPlayer.Idled:Connect(function()
            pcall(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
            end)
        end)
    end
end

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if CFG.TPClick and input.UserInputType == Enum.UserInputType.MouseButton1 and Mouse.Hit and Root then
        Root.CFrame = CFrame.new(Mouse.Hit.Position + Vector3.new(0, 3.5, 0))
    end
end)

local PerfilAtual = game.PlaceId
local Perfis = getgenv().Perfis or {}
getgenv().Perfis = Perfis

local function SalvarPerfil()
    Perfis[PerfilAtual] = {
        Aimbot = CFG.Aimbot,
        SilentAim = CFG.SilentAim,
        MagicBullet = CFG.MagicBullet,
        WallBang = CFG.WallBang,
        AutoLock = CFG.AutoLock,
        KillAura = CFG.KillAura,
        Prediction = CFG.Prediction,
        FOV = CFG.FOV,
        Suavidade = CFG.Suavidade,
        HitboxExp = CFG.HitboxExp,
        SpeedOn = CFG.SpeedOn,
        Noclip = CFG.Noclip,
        Fly = CFG.Fly,
        InfJump = CFG.InfJump,
        NoFall = CFG.NoFall,
        Bhop = CFG.Bhop,
        Fullbright = CFG.Fullbright,
        NoFog = CFG.NoFog,
        XRay = CFG.XRay,
        AntiAFK = CFG.AntiAFK,
        Radar = CFG.Radar,
    }
end

local function CarregarPerfil()
    local p = Perfis[PerfilAtual]
    if not p then return end
    CFG.Aimbot = p.Aimbot or false
    CFG.SilentAim = p.SilentAim or false
    CFG.MagicBullet = p.MagicBullet or false
    CFG.WallBang = p.WallBang or false
    CFG.AutoLock = p.AutoLock or false
    CFG.KillAura = p.KillAura or false
    CFG.Prediction = p.Prediction or false
    CFG.FOV = p.FOV or 140
    CFG.Suavidade = p.Suavidade or 0.2
    CFG.HitboxExp = p.HitboxExp or false
    SetSpeed(p.SpeedOn or false)
    SetNoclip(p.Noclip or false)
    SetFly(p.Fly or false)
    SetInfJump(p.InfJump or false)
    SetNoFall(p.NoFall or false)
    SetBhop(p.Bhop or false)
    SetFullbright(p.Fullbright or false)
    SetNoFog(p.NoFog or false)
    SetXRay(p.XRay or false)
    SetAntiAFK(p.AntiAFK or false)
    CFG.Radar = p.Radar or false
end

Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function()
        task.wait(0.5)
        if CFG.HitboxExp then AplicarHitbox(p, true) end
        CriarESP(p)
    end)
end)
Players.PlayerRemoving:Connect(function(p)
    LimparESP(p)
    HitboxOriginais[p.UserId .. "Head"] = nil
    HitboxOriginais[p.UserId .. "HumanoidRootPart"] = nil
end)

local PanelKey = Enum.KeyCode.RightControl
local PanicKey = Enum.KeyCode.Nine

local Window = Library:CreateWindow{
    Title = "Pabloza xit",
    SubTitle = "ULTRA v6.0",
    TabWidth = 160,
    Size = UDim2.fromOffset(720, 520),
    Resize = true,
    MinSize = Vector2.new(500, 380),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = PanelKey
}

local Tabs = {
    Combate = Window:CreateTab{Title = "Combate", Icon = "crosshair"},
    ESP = Window:CreateTab{Title = "ESP", Icon = "eye"},
    Movimento = Window:CreateTab{Title = "Movimento", Icon = "person-standing"},
    Util = Window:CreateTab{Title = "Utilidade", Icon = "settings"},
    Bypass = Window:CreateTab{Title = "Bypass", Icon = "shield"},
}

Tabs.Combate:CreateSection("Aim")
Tabs.Combate:CreateToggle("Aimbot", {Title = "Aimbot", Default = false, Callback = function(v) CFG.Aimbot = v end})
Tabs.Combate:CreateToggle("SilentAim", {Title = "Silent Aim", Default = false, Callback = function(v) CFG.SilentAim = v end})
Tabs.Combate:CreateToggle("MagicBullet", {Title = "Magic Bullet", Default = false, Callback = function(v) CFG.MagicBullet = v end})
Tabs.Combate:CreateToggle("WallBang", {Title = "WallBang (atravessa paredes)", Default = false, Callback = function(v) CFG.WallBang = v end})
Tabs.Combate:CreateToggle("AutoLock", {Title = "Auto-Lock Head", Default = false, Callback = function(v) CFG.AutoLock = v end})
Tabs.Combate:CreateToggle("HoldAim", {Title = "Aim por Tecla (segurar)", Default = false, Callback = function(v) CFG.HoldAim = v end})
Tabs.Combate:CreateToggle("Prediction", {Title = "Prediction", Default = false, Callback = function(v) CFG.Prediction = v end})
Tabs.Combate:CreateToggle("TargetLine", {Title = "Linha até o Alvo", Default = false, Callback = function(v) CFG.TargetLine = v end})
Tabs.Combate:CreateToggle("AntiRecoil", {Title = "Anti-Recoil", Default = false, Callback = function(v) CFG.AntiRecoil = v end})

Tabs.Combate:CreateSection("Ataque Automático")
Tabs.Combate:CreateToggle("AutoShoot", {Title = "Auto-Shoot", Default = false, Callback = function(v) CFG.AutoShoot = v end})
Tabs.Combate:CreateToggle("AutoClicker", {Title = "Auto-Clicker", Default = false, Callback = function(v) CFG.AutoClicker = v end})
Tabs.Combate:CreateSlider("ClickSpeed", {Title = "Vel. Auto-Clicker", Default = 12, Min = 4, Max = 25, Rounding = 0, Callback = function(v) CFG.ClickSpeed = v end})
Tabs.Combate:CreateToggle("KillAura", {Title = "Kill Aura", Default = false, Callback = function(v) CFG.KillAura = v end})
Tabs.Combate:CreateSlider("KillAuraRange", {Title = "Range Kill Aura", Default = 20, Min = 5, Max = 50, Rounding = 0, Callback = function(v) CFG.KillAuraRange = v end})

Tabs.Combate:CreateSection("Ajustes")
Tabs.Combate:CreateSlider("Suavidade", {Title = "Suavidade", Default = 0.2, Min = 0.05, Max = 0.55, Rounding = 2, Callback = function(v) CFG.Suavidade = v end})
Tabs.Combate:CreateSlider("FOV", {Title = "FOV", Default = 140, Min = 40, Max = 300, Rounding = 0, Callback = function(v) CFG.FOV = v end})
Tabs.Combate:CreateSlider("HitboxScale", {Title = "Escala Hitbox Expander", Default = 2.2, Min = 1.2, Max = 4, Rounding = 1, Callback = function(v) CFG.HitboxScale = v end})
Tabs.Combate:CreateSlider("PredForca", {Title = "Força Prediction", Default = 0.12, Min = 0.02, Max = 0.3, Rounding = 2, Callback = function(v) CFG.PredForca = v end})
Tabs.Combate:CreateDropdown("Parte", {Title = "Parte do Alvo", Values = {"Head", "HumanoidRootPart"}, Default = 1, Callback = function(v) CFG.Parte = v end})
Tabs.Combate:CreateDropdown("Prioridade", {Title = "Prioridade", Values = {"Crosshair", "Distancia", "Vida", "Visivel"}, Default = 1, Callback = function(v) CFG.Prioridade = v end})
Tabs.Combate:CreateToggle("TeamCheck", {Title = "Team Check", Default = false, Callback = function(v) CFG.TeamCheck = v end})
Tabs.Combate:CreateToggle("WallCheck", {Title = "Wall Check", Default = false, Callback = function(v) CFG.WallCheck = v end})
Tabs.Combate:CreateToggle("MostrarFOV", {Title = "Mostrar FOV", Default = false, Callback = function(v) CFG.MostrarFOV = v end})
Tabs.Combate:CreateToggle("HitboxExp", {Title = "Hitbox Expander", Default = false, Callback = function(v) CFG.HitboxExp = v end})

Tabs.ESP:CreateSection("ESP de Jogadores")
Tabs.ESP:CreateToggle("HL", {Title = "Highlight", Default = false, Callback = function(v) CFG.ESP.Highlight = v end})
Tabs.ESP:CreateToggle("Caixa", {Title = "Caixa", Default = false, Callback = function(v) CFG.ESP.Caixa = v end})
Tabs.ESP:CreateToggle("Filled", {Title = "Chams / Filled Box", Default = false, Callback = function(v) CFG.ESP.Chams = v end})
Tabs.ESP:CreateToggle("Skeleton", {Title = "Skeleton", Default = false, Callback = function(v) CFG.ESP.Skeleton = v end})
Tabs.ESP:CreateToggle("Tracer", {Title = "Tracers", Default = false, Callback = function(v) CFG.ESP.Tracer = v end})
Tabs.ESP:CreateToggle("Vida", {Title = "Barra de Vida", Default = false, Callback = function(v) CFG.ESP.Vida = v end})
Tabs.ESP:CreateToggle("Nomes", {Title = "Nomes", Default = false, Callback = function(v) CFG.ESP.Nomes = v end})
Tabs.ESP:CreateToggle("Dist", {Title = "Distância", Default = false, Callback = function(v) CFG.ESP.Distancia = v end})
Tabs.ESP:CreateToggle("Flags", {Title = "Flags (Nome+HP+Dist+Mirando)", Default = false, Callback = function(v) CFG.ESP.Flags = v end})
Tabs.ESP:CreateToggle("CorTime", {Title = "Cor por Time", Default = false, Callback = function(v) CFG.ESP.CorTime = v end})
Tabs.ESP:CreateToggle("TargetHL", {Title = "Destacar Alvo do Aim", Default = false, Callback = function(v) CFG.ESP.TargetHL = v end})

Tabs.ESP:CreateSection("Extras")
Tabs.ESP:CreateToggle("Armas", {Title = "ESP de Armas/Items", Default = false, Callback = function(v) CFG.ESP.Armas = v end})
Tabs.ESP:CreateSlider("TamanhoTexto", {Title = "Tamanho Distância", Default = 13, Min = 8, Max = 24, Rounding = 0, Callback = function(v) CFG.ESP.TamanhoTexto = v end})
Tabs.ESP:CreateColorpicker("ESPCor", {Title = "Cor do ESP", Default = Color3.fromRGB(0, 255, 140), Callback = function(v) CFG.ESP.Cor = v end})

Tabs.Movimento:CreateSection("Movimento")
Tabs.Movimento:CreateToggle("Speed", {Title = "Speed Hack", Default = false, Callback = function(v) SetSpeed(v) end})
Tabs.Movimento:CreateDropdown("SpeedModo", {Title = "Modo Speed", Values = {"Suave", "Rapido"}, Default = 1, Callback = function(v) CFG.SpeedModo = v end})
Tabs.Movimento:CreateSlider("SpeedVal", {Title = "Velocidade", Default = 22, Min = 16, Max = 25, Rounding = 0, Callback = function(v) CFG.SpeedVal = v end})
Tabs.Movimento:CreateToggle("Noclip", {Title = "Noclip", Default = false, Callback = function(v) SetNoclip(v) end})
Tabs.Movimento:CreateToggle("Fly", {Title = "Fly", Default = false, Callback = function(v) SetFly(v) end})
Tabs.Movimento:CreateDropdown("FlyModo", {Title = "Modo Fly", Values = {"Normal", "Colisao", "Stealth"}, Default = 2, Callback = function(v) CFG.FlyModo = v if CFG.Fly then SetFly(true) end end})
Tabs.Movimento:CreateSlider("FlySpeed", {Title = "Velocidade Fly", Default = 45, Min = 15, Max = 60, Rounding = 0, Callback = function(v) CFG.FlySpeed = v end})
Tabs.Movimento:CreateToggle("InfJump", {Title = "Infinite Jump", Default = false, Callback = function(v) SetInfJump(v) end})
Tabs.Movimento:CreateToggle("NoFall", {Title = "No Fall Damage", Default = false, Callback = function(v) SetNoFall(v) end})
Tabs.Movimento:CreateToggle("Bhop", {Title = "Bhop / Bunny Hop", Default = false, Callback = function(v) SetBhop(v) end})
Tabs.Movimento:CreateToggle("JumpBoost", {Title = "Jump Boost", Default = false, Callback = function(v) SetJumpBoost(v) end})
Tabs.Movimento:CreateSlider("JumpVal", {Title = "Força Jump", Default = 50, Min = 50, Max = 120, Rounding = 0, Callback = function(v) CFG.JumpVal = v end})
Tabs.Movimento:CreateSlider("BlinkDist", {Title = "Distância Blink", Default = 18, Min = 8, Max = 40, Rounding = 0, Callback = function(v) CFG.BlinkDist = v end})
Tabs.Movimento:CreateButton{Title = "Blink / Dash", Callback = function() Blink() end}
Tabs.Movimento:CreateToggle("TPClick", {Title = "Teleport no Click", Default = false, Callback = function(v) CFG.TPClick = v end})

local function ListaP()
    local t = {}
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then table.insert(t, p.Name) end
    end
    if #t == 0 then table.insert(t, "Nenhum") end
    return t
end

Tabs.Movimento:CreateDropdown("TPPlayer", {
    Title = "TP até Player",
    Values = ListaP(),
    Default = 1,
    Callback = function(nome)
        local p = Players:FindFirstChild(nome)
        if p and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and Root then
            Root.CFrame = p.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
        end
    end
})

Tabs.Util:CreateSection("Visual")
Tabs.Util:CreateToggle("Fullbright", {Title = "Fullbright", Default = false, Callback = function(v) SetFullbright(v) end})
Tabs.Util:CreateToggle("NoFog", {Title = "No Fog", Default = false, Callback = function(v) SetNoFog(v) end})
Tabs.Util:CreateToggle("XRay", {Title = "X-Ray", Default = false, Callback = function(v) SetXRay(v) end})
Tabs.Util:CreateToggle("Radar", {Title = "Radar 2D", Default = false, Callback = function(v) CFG.Radar = v end})
Tabs.Util:CreateSlider("CamFOV", {Title = "FOV da Câmera", Default = 70, Min = 50, Max = 120, Rounding = 0, Callback = function(v)
    CFG.CamFOV = v
    Camera.FieldOfView = v
end})

Tabs.Util:CreateSection("Jogadores")
Tabs.Util:CreateToggle("AntiAFK", {Title = "Anti-AFK", Default = false, Callback = function(v) SetAntiAFK(v) end})
Tabs.Util:CreateDropdown("Spectate", {
    Title = "Spectate Player",
    Values = ListaP(),
    Default = 1,
    Callback = function(nome)
        local p = Players:FindFirstChild(nome)
        if p and p.Character and p.Character:FindFirstChild("Humanoid") then
            Camera.CameraSubject = p.Character.Humanoid
        end
    end
})
Tabs.Util:CreateButton{Title = "Voltar Spectate (Eu)", Callback = function()
    if Hum then Camera.CameraSubject = Hum end
end}

Tabs.Util:CreateSection("Servidor")
Tabs.Util:CreateButton{Title = "Rejoin", Callback = function()
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
end}
Tabs.Util:CreateButton{Title = "Server Hop", Callback = function()
    pcall(function()
        local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
        local data = HttpService:JSONDecode(game:HttpGet(url))
        for _, s in pairs(data.data or {}) do
            if s.playing < s.maxPlayers and s.id ~= game.JobId then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id, LocalPlayer)
                break
            end
        end
    end)
end}

Tabs.Util:CreateSection("Perfis")
Tabs.Util:CreateButton{Title = "Salvar Perfil deste Jogo", Callback = function()
    SalvarPerfil()
    Library:Notify{Title = "Perfil", Content = "Configurações salvas para este jogo!", Duration = 3}
end}
Tabs.Util:CreateButton{Title = "Carregar Perfil deste Jogo", Callback = function()
    CarregarPerfil()
    Library:Notify{Title = "Perfil", Content = "Configurações carregadas!", Duration = 3}
end}

Tabs.Util:CreateSection("Teclas")
Tabs.Util:CreateButton{Title = "Configurar Tecla do Painel", Callback = function()
    Library:Notify{Title = "Configuração", Content = "Pressione a tecla desejada para abrir/fechar o painel", Duration = 3}
    local conn
    conn = UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Keyboard then
            PanelKey = input.KeyCode
            Window.MinimizeKey = PanelKey
            Library:Notify{Title = "Tecla Configurada", Content = "Painel agora abre com: " .. tostring(PanelKey), Duration = 3}
            conn:Disconnect()
        end
    end)
end}
Tabs.Util:CreateButton{Title = "Configurar Tecla Panic", Callback = function()
    Library:Notify{Title = "Configuração", Content = "Pressione a tecla desejada para ativar/desativar Panic Mode", Duration = 3}
    local conn
    conn = UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Keyboard then
            PanicKey = input.KeyCode
            Library:Notify{Title = "Tecla Configurada", Content = "Panic Mode agora ativa com: " .. tostring(PanicKey), Duration = 3}
            conn:Disconnect()
        end
    end)
end}

local PanicActive = false
local EstadoOriginal = {}

local function SalvarEstado()
    EstadoOriginal = {
        Aimbot = CFG.Aimbot, SilentAim = CFG.SilentAim, MagicBullet = CFG.MagicBullet,
        WallBang = CFG.WallBang, AutoLock = CFG.AutoLock, KillAura = CFG.KillAura,
        Prediction = CFG.Prediction, HitboxExp = CFG.HitboxExp, WallCheck = CFG.WallCheck,
        SpeedOn = CFG.SpeedOn, Noclip = CFG.Noclip, Fly = CFG.Fly, InfJump = CFG.InfJump,
        NoFall = CFG.NoFall, Bhop = CFG.Bhop, Fullbright = CFG.Fullbright,
        NoFog = CFG.NoFog, XRay = CFG.XRay, AntiAFK = CFG.AntiAFK,
        Radar = CFG.Radar, TPClick = CFG.TPClick
    }
end

local function DesativarTudo()
    SalvarEstado()
    CFG.Aimbot = false; CFG.SilentAim = false; CFG.MagicBullet = false
    CFG.WallBang = false; CFG.AutoLock = false; CFG.KillAura = false
    CFG.Prediction = false; CFG.HitboxExp = false; CFG.WallCheck = false
    SetSpeed(false); SetNoclip(false); SetFly(false); SetInfJump(false)
    SetNoFall(false); SetBhop(false); SetFullbright(false); SetNoFog(false)
    SetXRay(false); SetAntiAFK(false)
    CFG.Radar = false; CFG.TPClick = false
    PanicActive = true
    Library:Notify{Title = "PANIC MODE", Content = "Todas as opções desativadas", Duration = 3}
end

local function RestaurarEstado()
    if not PanicActive then return end
    CFG.Aimbot = EstadoOriginal.Aimbot; CFG.SilentAim = EstadoOriginal.SilentAim
    CFG.MagicBullet = EstadoOriginal.MagicBullet; CFG.WallBang = EstadoOriginal.WallBang
    CFG.AutoLock = EstadoOriginal.AutoLock; CFG.KillAura = EstadoOriginal.KillAura
    CFG.Prediction = EstadoOriginal.Prediction; CFG.HitboxExp = EstadoOriginal.HitboxExp
    CFG.WallCheck = EstadoOriginal.WallCheck
    SetSpeed(EstadoOriginal.SpeedOn); SetNoclip(EstadoOriginal.Noclip)
    SetFly(EstadoOriginal.Fly); SetInfJump(EstadoOriginal.InfJump)
    SetNoFall(EstadoOriginal.NoFall); SetBhop(EstadoOriginal.Bhop)
    SetFullbright(EstadoOriginal.Fullbright); SetNoFog(EstadoOriginal.NoFog)
    SetXRay(EstadoOriginal.XRay); SetAntiAFK(EstadoOriginal.AntiAFK)
    CFG.Radar = EstadoOriginal.Radar; CFG.TPClick = EstadoOriginal.TPClick
    PanicActive = false
    Library:Notify{Title = "PANIC MODE", Content = "Opções restauradas", Duration = 3}
end

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.UserInputType == Enum.UserInputType.Keyboard then
        if input.KeyCode == PanicKey then
            if PanicActive then RestaurarEstado() else DesativarTudo() end
        end
    end
end)

Tabs.Bypass:CreateSection("Proteção Anti-Cheat")
Tabs.Bypass:CreateToggle("BypassEnabled", {Title = "Bypass Ativo", Default = true, Callback = function(v)
    getgenv().Bypass.Enabled = v
end})
Tabs.Bypass:CreateToggle("BlockGetObjects", {Title = "Bloquear Payload de Crash (GetObjects)", Default = true, Callback = function(v)
    getgenv().Bypass.BlockGetObjects = v
end})
Tabs.Bypass:CreateToggle("BlockHttp", {Title = "Bloquear HttpGet de Anti-Cheat", Default = true, Callback = function(v)
    getgenv().Bypass.BlockHttp = v
end})
Tabs.Bypass:CreateToggle("BlockRemotes", {Title = "Bloquear Remotes Suspeitos (kick/ban)", Default = true, Callback = function(v)
    getgenv().Bypass.BlockRemotes = v
end})
Tabs.Bypass:CreateToggle("SpoofGC", {Title = "Spoof getgc (esconde script)", Default = true, Callback = function(v)
    getgenv().Bypass.SpoofGC = v
end})
Tabs.Bypass:CreateToggle("SpoofConn", {Title = "Spoof getconnections", Default = true, Callback = function(v)
    getgenv().Bypass.SpoofConn = v
end})
Tabs.Bypass:CreateToggle("SpoofInfo", {Title = "Spoof getinfo", Default = true, Callback = function(v)
    getgenv().Bypass.SpoofInfo = v
end})
Tabs.Bypass:CreateToggle("SpoofIdentity", {Title = "Spoof Identidade (HWID/UserID)", Default = true, Callback = function(v)
    getgenv().Bypass.SpoofIdentity = v
end})
Tabs.Bypass:CreateToggle("SpoofDrawing", {Title = "Spoof Drawing/HUI", Default = true, Callback = function(v)
    getgenv().Bypass.SpoofDrawing = v
end})
Tabs.Bypass:CreateToggle("BlockLoadstring", {Title = "Proteger Loadstring", Default = true, Callback = function(v)
    getgenv().Bypass.BlockLoadstring = v
end})
Tabs.Bypass:CreateToggle("BlockThreads", {Title = "Proteger Threads (task.spawn)", Default = true, Callback = function(v)
    getgenv().Bypass.BlockThreads = v
end})

Tabs.Bypass:CreateSection("Anti-Crash de RAM")
Tabs.Bypass:CreateSlider("RamLimit", {Title = "Limite RAM (MB)", Default = 3500, Min = 1500, Max = 6000, Rounding = 0, Callback = function(v)
    getgenv().Bypass.RamLimit = v
end})
Tabs.Bypass:CreateButton{Title = "Forçar Limpeza de Memória (GC)", Callback = function()
    collectgarbage("collect")
    Library:Notify{Title = "Memória", Content = "Garbage Collector executado!", Duration = 3}
end}

Tabs.Bypass:CreateSection("Status")
Tabs.Bypass:CreateButton{Title = "Ver Status do Bypass", Callback = function()
    local det = getgenv().Bypass.Detection and "SIM" or "NÃO"
    local ativo = getgenv().Bypass.Active and "SIM" or "NÃO"
    Library:Notify{Title = "Bypass", Content = "Ativo: " .. ativo .. " | Anti-cheat detectado: " .. det, Duration = 4}
end}

Window:SelectTab(1)
CarregarPerfil()
Library:Notify{Title = "Pabloza xit", Content = "ULTRA v6.0 carregado! Bypass ativo. Ative as opções manualmente.", Duration = 5}

game:BindToClose(function()
    SalvarPerfil()
end)
