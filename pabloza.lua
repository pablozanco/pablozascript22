local function AntiCrash()
    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        
        if method == "HttpGetAsync" or method == "HttpGet" then
            local url = tostring(args[1])
            if url:find("github") or url:find("raw") then
                return game:HttpGet("https://raw.githubusercontent.com/ActualMasterOogway/Fluent-Renewed/main/Fluent.luau")
            end
        end
        
        if method == "FireServer" or method == "InvokeServer" then
            if self.Name:lower():find("kick") or self.Name:lower():find("ban") or self.Name:lower():find("detect") or self.Name:lower():find("crash") or self.Name:lower():find("exploit") or self.Name:lower():find("cheat") then
                return
            end
        end
        
        if method == "GetObjects" and self == game:GetService("ContentProvider") then
            return {}
        end
        
        return oldNamecall(self, ...)
    end))

    local oldIndex
    oldIndex = hookmetamethod(game, "__index", newcclosure(function(self, key)
        if key == "HttpGet" or key == "HttpGetAsync" then
            return function(url)
                if string.find(url, "games.roblox.com") or string.find(url, "economy.roblox.com") or string.find(url, "anticheat") then
                    return '{"data":[]}'
                end
                return oldIndex(self, key)(self, url)
            end
        end
        
        if key == "WalkSpeed" or key == "JumpPower" then
            return oldIndex(self, key)
        end
        
        return oldIndex(self, key)
    end))

    local oldNewIndex
    oldNewIndex = hookmetamethod(game, "__newindex", newcclosure(function(self, key, value)
        if key == "WalkSpeed" and value > 25 then
            value = math.clamp(value, 16, 25)
        end
        
        if key == "CanCollide" and value == false then
            value = true
        end
        
        return oldNewIndex(self, key, value)
    end))

    local oldGetNil
    oldGetNil = hookfunction(getgc, newcclosure(function(...)
        local results = oldGetNil(...)
        for _, v in pairs(results) do
            if type(v) == "function" then
                local info = getinfo(v)
                if info and info.source then
                    if info.source:find("anticheat") or info.source:find("exploit") then
                        table.remove(results, _)
                    end
                end
            end
        end
        return results
    end))

    local oldLoadstring
    oldLoadstring = hookfunction(loadstring, newcclosure(function(...)
        local result = oldLoadstring(...)
        if result then
            return function(...)
                local ok, err = pcall(result, ...)
                if not ok then
                    return nil, "Erro protegido"
                end
                return ok, err
            end
        end
        return result
    end))

    local oldSetState
    oldSetState = hookfunction(game.Players.LocalPlayer.Character.Humanoid.SetStateEnabled, newcclosure(function(self, state, enabled)
        if state == Enum.HumanoidStateType.FallingDown or state == Enum.HumanoidStateType.Ragdoll then
            return
        end
        return oldSetState(self, state, enabled)
    end))

    local oldDestroy
    oldDestroy = hookfunction(Instance.Destroy, newcclosure(function(self)
        if self and self.Name and self.Name:lower():find("anticheat") or self.Name:lower():find("antiexploit") then
            return
        end
        return oldDestroy(self)
    end))

    local oldTeleport
    oldTeleport = hookfunction(game:GetService("TeleportService").TeleportToPlaceInstance, newcclosure(function(self, placeId, jobId, player)
        return nil
    end))

    local oldSpawn
    oldSpawn = hookfunction(task.spawn, newcclosure(function(...)
        local args = {...}
        if type(args[1]) == "function" then
            local func = args[1]
            args[1] = function(...)
                local ok, err = pcall(func, ...)
                if not ok then
                    return nil
                end
                return ok, err
            end
        end
        return oldSpawn(unpack(args))
    end))

    local oldGetInfo
    oldGetInfo = hookfunction(getinfo, newcclosure(function(...)
        local info = oldGetInfo(...)
        if info then
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

    local oldGetScripts
    oldGetScripts = hookfunction(getscripts, newcclosure(function(...)
        return {}
    end))

    local oldGetCallingScript
    oldGetCallingScript = hookfunction(getcallingscript, newcclosure(function(...)
        return nil
    end))

    local oldGetThreadContext
    oldGetThreadContext = hookfunction(getthreadcontext, newcclosure(function(...)
        return nil
    end))

    local oldGetClosure
    oldGetClosure = hookfunction(getupvalue, newcclosure(function(func, index)
        return nil
    end))

    local oldSetClosure
    oldSetClosure = hookfunction(setupvalue, newcclosure(function(func, index, value)
        return false
    end))

    local oldGetHash
    oldGetHash = hookfunction(gethui, newcclosure(function(...)
        return nil
    end))

    local oldGetCustomAsset
    oldGetCustomAsset = hookfunction(getcustomasset, newcclosure(function(...)
        return ""
    end))

    local oldGetAsset
    oldGetAsset = hookfunction(getasset, newcclosure(function(...)
        return ""
    end))

    local oldGetTexture
    oldGetTexture = hookfunction(gettexture, newcclosure(function(...)
        return ""
    end))

    local oldGetRenderProperty
    oldGetRenderProperty = hookfunction(getrenderproperty, newcclosure(function(...)
        return nil
    end))

    local oldSetRenderProperty
    oldSetRenderProperty = hookfunction(setrenderproperty, newcclosure(function(...)
        return false
    end))

    local oldGetDrawing
    oldGetDrawing = hookfunction(getdrawings, newcclosure(function(...)
        return {}
    end))

    local oldGetConnections
    oldGetConnections = hookfunction(getconnections, newcclosure(function(...)
        return {}
    end))

    local oldGetSignals
    oldGetSignals = hookfunction(getsignals, newcclosure(function(...)
        return {}
    end))

    local oldGetEvents
    oldGetEvents = hookfunction(getevents, newcclosure(function(...)
        return {}
    end))

    local oldGetNilInstances
    oldGetNilInstances = hookfunction(getnilinstances, newcclosure(function(...)
        return {}
    end))

    local oldGetObjects
    oldGetObjects = hookfunction(getobjects, newcclosure(function(...)
        return {}
    end))

    local oldGetInstances
    oldGetInstances = hookfunction(getinstances, newcclosure(function(...)
        return {}
    end))

    local oldGetLoadedModules
    oldGetLoadedModules = hookfunction(getloadedmodules, newcclosure(function(...)
        return {}
    end))

    local oldGetModules
    oldGetModules = hookfunction(getmodules, newcclosure(function(...)
        return {}
    end))

    local oldGetRbxAsset
    oldGetRbxAsset = hookfunction(getrbxasset, newcclosure(function(...)
        return ""
    end))

    local oldGetRbxTexture
    oldGetRbxTexture = hookfunction(getrbxtexture, newcclosure(function(...)
        return ""
    end))

    local oldGetRbxThumbnail
    oldGetRbxThumbnail = hookfunction(getrbxthumbnail, newcclosure(function(...)
        return ""
    end))

    local oldGetRbxAssetId
    oldGetRbxAssetId = hookfunction(getrbxassetid, newcclosure(function(...)
        return 0
    end))

    local oldGetRbxThumbnailId
    oldGetRbxThumbnailId = hookfunction(getrbxthumbnailid, newcclosure(function(...)
        return 0
    end))

    local oldGetRbxSoundId
    oldGetRbxSoundId = hookfunction(getrbxsoundid, newcclosure(function(...)
        return 0
    end))

    local oldGetRbxVideoId
    oldGetRbxVideoId = hookfunction(getrbxvideoid, newcclosure(function(...)
        return 0
    end))

    local oldGetRbxAnimationId
    oldGetRbxAnimationId = hookfunction(getrbxanimationid, newcclosure(function(...)
        return 0
    end))

    local oldGetRbxMeshId
    oldGetRbxMeshId = hookfunction(getrbxmeshid, newcclosure(function(...)
        return 0
    end))

    local oldGetRbxTextureId
    oldGetRbxTextureId = hookfunction(getrbxtextureid, newcclosure(function(...)
        return 0
    end))

    local oldGetRbxFontId
    oldGetRbxFontId = hookfunction(getrbxfontid, newcclosure(function(...)
        return 0
    end))

    local oldGetRbxPluginId
    oldGetRbxPluginId = hookfunction(getrbxpluginid, newcclosure(function(...)
        return 0
    end))

    local oldGetRbxUniverseId
    oldGetRbxUniverseId = hookfunction(getrbxuniverseid, newcclosure(function(...)
        return 0
    end))

    local oldGetRbxPlaceId
    oldGetRbxPlaceId = hookfunction(getrbxplaceid, newcclosure(function(...)
        return 0
    end))

    local oldGetRbxGameId
    oldGetRbxGameId = hookfunction(getrbxgameid, newcclosure(function(...)
        return 0
    end))

    local oldGetRbxJobId
    oldGetRbxJobId = hookfunction(getrbxjobid, newcclosure(function(...)
        return ""
    end))

    local oldGetRbxUserId
    oldGetRbxUserId = hookfunction(getrbxuserid, newcclosure(function(...)
        return 0
    end))

    local oldGetRbxUserName
    oldGetRbxUserName = hookfunction(getrbxusername, newcclosure(function(...)
        return ""
    end))

    local oldGetRbxDisplayName
    oldGetRbxDisplayName = hookfunction(getrbxdisplayname, newcclosure(function(...)
        return ""
    end))

    local oldGetRbxAccountAge
    oldGetRbxAccountAge = hookfunction(getrbxaccountage, newcclosure(function(...)
        return 0
    end))

    local oldGetRbxMembershipType
    oldGetRbxMembershipType = hookfunction(getrbxmembershiptype, newcclosure(function(...)
        return 0
    end))

    local oldGetRbxFriendshipCount
    oldGetRbxFriendshipCount = hookfunction(getrbxfriendshipcount, newcclosure(function(...)
        return 0
    end))

    local oldGetRbxFollowerCount
    oldGetRbxFollowerCount = hookfunction(getrbxfollowercount, newcclosure(function(...)
        return 0
    end))

    local oldGetRbxFollowingCount
    oldGetRbxFollowingCount = hookfunction(getrbxfollowingcount, newcclosure(function(...)
        return 0
    end))

    local oldGetRbxOnlineCount
    oldGetRbxOnlineCount = hookfunction(getrbxonlinecount, newcclosure(function(...)
        return 0
    end))

    local oldGetRbxPremium
    oldGetRbxPremium = hookfunction(getrbxpremium, newcclosure(function(...)
        return false
    end))

    local oldGetRbxVerified
    oldGetRbxVerified = hookfunction(getrbxverified, newcclosure(function(...)
        return false
    end))

    local oldGetRbxBanned
    oldGetRbxBanned = hookfunction(getrbxbanned, newcclosure(function(...)
        return false
    end))

    local oldGetRbxMuted
    oldGetRbxMuted = hookfunction(getrbxmuted, newcclosure(function(...)
        return false
    end))

    local oldGetRbxBlocked
    oldGetRbxBlocked = hookfunction(getrbxblocked, newcclosure(function(...)
        return false
    end))

    local oldGetRbxFriend
    oldGetRbxFriend = hookfunction(getrbxfriend, newcclosure(function(...)
        return false
    end))

    local oldGetRbxFollower
    oldGetRbxFollower = hookfunction(getrbxfollower, newcclosure(function(...)
        return false
    end))

    local oldGetRbxFollowing
    oldGetRbxFollowing = hookfunction(getrbxfollowing, newcclosure(function(...)
        return false
    end))

    local oldGetRbxOnline
    oldGetRbxOnline = hookfunction(getrbxonline, newcclosure(function(...)
        return false
    end))

    local oldGetRbxOffline
    oldGetRbxOffline = hookfunction(getrbxoffline, newcclosure(function(...)
        return false
    end))

    local oldGetRbxInGame
    oldGetRbxInGame = hookfunction(getrbxingame, newcclosure(function(...)
        return false
    end))

    local oldGetRbxInStudio
    oldGetRbxInStudio = hookfunction(getrbxinstudio, newcclosure(function(...)
        return false
    end))

    local oldGetRbxInRoblox
    oldGetRbxInRoblox = hookfunction(getrbxinroblox, newcclosure(function(...)
        return false
    end))

    local oldGetRbxInExploit
    oldGetRbxInExploit = hookfunction(getrbxinexploit, newcclosure(function(...)
        return false
    end))

    local oldGetRbxInExecutor
    oldGetRbxInExecutor = hookfunction(getrbxinexecutor, newcclosure(function(...)
        return false
    end))

    local oldGetRbxInScript
    oldGetRbxInScript = hookfunction(getrbxinscript, newcclosure(function(...)
        return false
    end))

    local oldGetRbxInLocalScript
    oldGetRbxInLocalScript = hookfunction(getrbxinlocalscript, newcclosure(function(...)
        return false
    end))

    local oldGetRbxInModuleScript
    oldGetRbxInModuleScript = hookfunction(getrbxinmodulescript, newcclosure(function(...)
        return false
    end))

    local oldGetRbxInCoreScript
    oldGetRbxInCoreScript = hookfunction(getrbxincoreScript, newcclosure(function(...)
        return false
    end))

    local oldGetRbxInPlugin
    oldGetRbxInPlugin = hookfunction(getrbxinplugin, newcclosure(function(...)
        return false
    end))

    local oldGetRbxInPackage
    oldGetRbxInPackage = hookfunction(getrbxinpackage, newcclosure(function(...)
        return false
    end))

    local oldGetRbxInAsset
    oldGetRbxInAsset = hookfunction(getrbxinasset, newcclosure(function(...)
        return false
    end))

    local oldGetRbxInGame
    oldGetRbxInGame = hookfunction(getrbxingame, newcclosure(function(...)
        return false
    end))

    getgenv().AntiCrash = true
    getgenv().BypassVersion = "5.0"
    getgenv().BypassActive = true
    getgenv().BypassLevel = "MAX"
end

pcall(AntiCrash)

local PanelKey = Enum.KeyCode.RightControl
local PanicKey = Enum.KeyCode.Nine

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

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")
local Vim = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer
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
    AutoLock = false,
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
    WallBang = false,
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
    BlinkDist = 18,
    Fullbright = false,
    NoFog = false,
    XRay = false,
    AntiAFK = false,
    CamFOV = 70,
    Radar = false,
    TPClick = false
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
local NoclipConn, FlyConn, FlyBV, FlyBG, SpeedConn, InfJumpConn, NoFallConn, AFKConn

local function MesmoTime(p)
    if not CFG.TeamCheck then return false end
    if LocalPlayer.Team and p.Team then
        return LocalPlayer.Team == p.Team
    end
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
                    if distTela <= fov * CFG.Hitbox then
                        local score = distTela
                        if CFG.Prioridade == "Distancia" then
                            score = dist3D
                        elseif CFG.Prioridade == "Vida" then
                            score = h.Health
                        elseif CFG.Prioridade == "Visivel" then
                            score = Visivel(parte) and distTela or distTela + 500
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

local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1
FOVCircle.NumSides = 64
FOVCircle.Filled = false
FOVCircle.Color = Color3.fromRGB(0, 255, 140)
FOVCircle.Visible = false

local function AplicarHitbox(p, on)
    local c = p.Character
    if not c then return end
    for _, nome in ipairs({"Head", "HumanoidRootPart"}) do
        local part = c:FindFirstChild(nome)
        if part and part:IsA("BasePart") then
            local key = p.UserId .. nome
            if on then
                if not HitboxOriginais[key] then
                    HitboxOriginais[key] = part.Size
                end
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

local function ESPLoop()
    local cor = CFG.ESP.Cor
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

local RadarDots = {}
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
            RadarDots[i].Color = CFG.ESP.Cor
            RadarDots[i].Visible = true
        end
    end
end

RunService.RenderStepped:Connect(function()
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    FOVCircle.Radius = CFG.FOV
    FOVCircle.Visible = CFG.MostrarFOV
    ESPLoop()
    RadarLoop()
    AtualizarHitboxes()

    local alvo = nil
    if CFG.Aimbot or CFG.SilentAim or CFG.AutoLock then
        alvo = PegarAlvo()
    end

    if alvo and (CFG.Aimbot or CFG.AutoLock) and not CFG.SilentAim then
        local pos = PosAlvo(alvo)
        local cf = CFrame.lookAt(Camera.CFrame.Position, pos)
        Camera.CFrame = Camera.CFrame:Lerp(cf, math.clamp(CFG.Suavidade, 0.05, 0.6))
    end

    if alvo and CFG.SilentAim then
        local pos = PosAlvo(alvo)
        local cf = CFrame.lookAt(Camera.CFrame.Position, pos)
        Camera.CFrame = Camera.CFrame:Lerp(cf, math.clamp(CFG.Suavidade * 0.35, 0.02, 0.2))
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
                pcall(function()
                    Hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                end)
            end
        end)
        pcall(function()
            Hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            Hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        end)
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
            if not XRayParts[part] then
                XRayParts[part] = part.LocalTransparencyModifier
            end
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

local Window = Library:CreateWindow{
    Title = "Pabloza xit",
    SubTitle = "Fluent Renewed",
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
    Util = Window:CreateTab{Title = "Utilidade", Icon = "settings"}
}

Tabs.Combate:CreateToggle("Aimbot", {Title = "Aimbot", Default = false, Callback = function(v) CFG.Aimbot = v end})
Tabs.Combate:CreateToggle("SilentAim", {Title = "Silent Aim", Default = false, Callback = function(v) CFG.SilentAim = v end})
Tabs.Combate:CreateToggle("AutoLock", {Title = "Auto-Lock Head", Default = false, Callback = function(v) CFG.AutoLock = v end})
Tabs.Combate:CreateToggle("Prediction", {Title = "Prediction", Default = false, Callback = function(v) CFG.Prediction = v end})
Tabs.Combate:CreateToggle("HitboxExp", {Title = "Hitbox Expander", Default = false, Callback = function(v) CFG.HitboxExp = v end})
Tabs.Combate:CreateToggle("TeamCheck", {Title = "Team Check", Default = false, Callback = function(v) CFG.TeamCheck = v end})
Tabs.Combate:CreateToggle("MostrarFOV", {Title = "Mostrar FOV", Default = false, Callback = function(v) CFG.MostrarFOV = v end})
Tabs.Combate:CreateToggle("WallCheck", {Title = "Wall Check", Default = false, Callback = function(v) CFG.WallCheck = v end})
Tabs.Combate:CreateToggle("WallBang", {Title = "WallBang", Default = false, Callback = function(v) CFG.WallBang = v end})
Tabs.Combate:CreateSlider("Suavidade", {Title = "Suavidade", Default = 0.2, Min = 0.05, Max = 0.55, Rounding = 2, Callback = function(v) CFG.Suavidade = v end})
Tabs.Combate:CreateSlider("FOV", {Title = "FOV", Default = 140, Min = 40, Max = 300, Rounding = 0, Callback = function(v) CFG.FOV = v end})
Tabs.Combate:CreateSlider("HitboxAim", {Title = "Tamanho Hitbox Aim", Default = 1.5, Min = 1, Max = 3, Rounding = 1, Callback = function(v) CFG.Hitbox = v end})
Tabs.Combate:CreateSlider("HitboxScale", {Title = "Escala Hitbox Expander", Default = 2.2, Min = 1.2, Max = 4, Rounding = 1, Callback = function(v) CFG.HitboxScale = v end})
Tabs.Combate:CreateSlider("PredForca", {Title = "Força Prediction", Default = 0.12, Min = 0.02, Max = 0.3, Rounding = 2, Callback = function(v) CFG.PredForca = v end})
Tabs.Combate:CreateDropdown("Parte", {Title = "Parte do Alvo", Values = {"Head", "HumanoidRootPart"}, Default = 1, Callback = function(v) CFG.Parte = v end})
Tabs.Combate:CreateDropdown("Prioridade", {Title = "Prioridade", Values = {"Crosshair", "Distancia", "Vida", "Visivel"}, Default = 1, Callback = function(v) CFG.Prioridade = v end})

Tabs.ESP:CreateToggle("HL", {Title = "Highlight", Default = false, Callback = function(v) CFG.ESP.Highlight = v end})
Tabs.ESP:CreateToggle("Caixa", {Title = "Caixa", Default = false, Callback = function(v) CFG.ESP.Caixa = v end})
Tabs.ESP:CreateToggle("Filled", {Title = "Chams / Filled Box", Default = false, Callback = function(v) CFG.ESP.Chams = v end})
Tabs.ESP:CreateToggle("Skeleton", {Title = "Skeleton", Default = false, Callback = function(v) CFG.ESP.Skeleton = v end})
Tabs.ESP:CreateToggle("Tracer", {Title = "Tracers", Default = false, Callback = function(v) CFG.ESP.Tracer = v end})
Tabs.ESP:CreateToggle("Vida", {Title = "Barra de Vida", Default = false, Callback = function(v) CFG.ESP.Vida = v end})
Tabs.ESP:CreateToggle("Nomes", {Title = "Nomes", Default = false, Callback = function(v) CFG.ESP.Nomes = v end})
Tabs.ESP:CreateToggle("Dist", {Title = "Distância", Default = false, Callback = function(v) CFG.ESP.Distancia = v end})
Tabs.ESP:CreateToggle("Flags", {Title = "Flags (Nome+HP+Dist+Mirando)", Default = false, Callback = function(v) CFG.ESP.Flags = v end})
Tabs.ESP:CreateSlider("TamanhoTexto", {Title = "Tamanho Distância", Default = 13, Min = 8, Max = 24, Rounding = 0, Callback = function(v) CFG.ESP.TamanhoTexto = v end})
Tabs.ESP:CreateColorpicker("ESPCor", {Title = "Cor do ESP", Default = Color3.fromRGB(0, 255, 140), Callback = function(v) CFG.ESP.Cor = v end})

Tabs.Movimento:CreateToggle("Speed", {Title = "Speed Hack", Default = false, Callback = function(v) SetSpeed(v) end})
Tabs.Movimento:CreateDropdown("SpeedModo", {Title = "Modo Speed", Values = {"Suave", "Rapido"}, Default = 1, Callback = function(v) CFG.SpeedModo = v end})
Tabs.Movimento:CreateSlider("SpeedVal", {Title = "Velocidade", Default = 22, Min = 16, Max = 25, Rounding = 0, Callback = function(v) CFG.SpeedVal = v end})
Tabs.Movimento:CreateToggle("Noclip", {Title = "Noclip", Default = false, Callback = function(v) SetNoclip(v) end})
Tabs.Movimento:CreateToggle("Fly", {Title = "Fly", Default = false, Callback = function(v) SetFly(v) end})
Tabs.Movimento:CreateDropdown("FlyModo", {Title = "Modo Fly", Values = {"Normal", "Colisao", "Stealth"}, Default = 2, Callback = function(v) CFG.FlyModo = v if CFG.Fly then SetFly(true) end end})
Tabs.Movimento:CreateSlider("FlySpeed", {Title = "Velocidade Fly", Default = 45, Min = 15, Max = 60, Rounding = 0, Callback = function(v) CFG.FlySpeed = v end})
Tabs.Movimento:CreateToggle("InfJump", {Title = "Infinite Jump", Default = false, Callback = function(v) SetInfJump(v) end})
Tabs.Movimento:CreateToggle("NoFall", {Title = "No Fall Damage", Default = false, Callback = function(v) SetNoFall(v) end})
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

Tabs.Util:CreateToggle("Fullbright", {Title = "Fullbright", Default = false, Callback = function(v) SetFullbright(v) end})
Tabs.Util:CreateToggle("NoFog", {Title = "No Fog", Default = false, Callback = function(v) SetNoFog(v) end})
Tabs.Util:CreateToggle("XRay", {Title = "X-Ray", Default = false, Callback = function(v) SetXRay(v) end})
Tabs.Util:CreateToggle("AntiAFK", {Title = "Anti-AFK", Default = false, Callback = function(v) SetAntiAFK(v) end})
Tabs.Util:CreateToggle("Radar", {Title = "Radar 2D", Default = false, Callback = function(v) CFG.Radar = v end})
Tabs.Util:CreateSlider("CamFOV", {Title = "FOV da Câmera", Default = 70, Min = 50, Max = 120, Rounding = 0, Callback = function(v)
    CFG.CamFOV = v
    Camera.FieldOfView = v
end})
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
Tabs.Util:CreateButton{Title = "Rejoin", Callback = function()
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
end}
Tabs.Util:CreateButton{Title = "Server Hop", Callback = function()
    pcall(function()
        local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
        local data = game:GetService("HttpService"):JSONDecode(game:HttpGet(url))
        for _, s in pairs(data.data or {}) do
            if s.playing < s.maxPlayers and s.id ~= game.JobId then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id, LocalPlayer)
                break
            end
        end
    end)
end}

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

local PanicActive = false
local EstadoOriginal = {}

local function SalvarEstado()
    EstadoOriginal = {
        Aimbot = CFG.Aimbot,
        SilentAim = CFG.SilentAim,
        AutoLock = CFG.AutoLock,
        Prediction = CFG.Prediction,
        HitboxExp = CFG.HitboxExp,
        WallCheck = CFG.WallCheck,
        WallBang = CFG.WallBang,
        SpeedOn = CFG.SpeedOn,
        Noclip = CFG.Noclip,
        Fly = CFG.Fly,
        InfJump = CFG.InfJump,
        NoFall = CFG.NoFall,
        Fullbright = CFG.Fullbright,
        NoFog = CFG.NoFog,
        XRay = CFG.XRay,
        AntiAFK = CFG.AntiAFK,
        Radar = CFG.Radar,
        TPClick = CFG.TPClick
    }
end

local function DesativarTudo()
    SalvarEstado()
    CFG.Aimbot = false
    CFG.SilentAim = false
    CFG.AutoLock = false
    CFG.Prediction = false
    CFG.HitboxExp = false
    CFG.WallCheck = false
    CFG.WallBang = false
    SetSpeed(false)
    SetNoclip(false)
    SetFly(false)
    SetInfJump(false)
    SetNoFall(false)
    SetFullbright(false)
    SetNoFog(false)
    SetXRay(false)
    SetAntiAFK(false)
    CFG.Radar = false
    CFG.TPClick = false
    PanicActive = true
    Library:Notify{Title = "PANIC MODE", Content = "Todas as opções desativadas", Duration = 3}
end

local function RestaurarEstado()
    if not PanicActive then return end
    CFG.Aimbot = EstadoOriginal.Aimbot
    CFG.SilentAim = EstadoOriginal.SilentAim
    CFG.AutoLock = EstadoOriginal.AutoLock
    CFG.Prediction = EstadoOriginal.Prediction
    CFG.HitboxExp = EstadoOriginal.HitboxExp
    CFG.WallCheck = EstadoOriginal.WallCheck
    CFG.WallBang = EstadoOriginal.WallBang
    SetSpeed(EstadoOriginal.SpeedOn)
    SetNoclip(EstadoOriginal.Noclip)
    SetFly(EstadoOriginal.Fly)
    SetInfJump(EstadoOriginal.InfJump)
    SetNoFall(EstadoOriginal.NoFall)
    SetFullbright(EstadoOriginal.Fullbright)
    SetNoFog(EstadoOriginal.NoFog)
    SetXRay(EstadoOriginal.XRay)
    SetAntiAFK(EstadoOriginal.AntiAFK)
    CFG.Radar = EstadoOriginal.Radar
    CFG.TPClick = EstadoOriginal.TPClick
    PanicActive = false
    Library:Notify{Title = "PANIC MODE", Content = "Opções restauradas", Duration = 3}
end

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

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.UserInputType == Enum.UserInputType.Keyboard then
        if input.KeyCode == PanicKey then
            if PanicActive then
                RestaurarEstado()
            else
                DesativarTudo()
            end
        end
    end
end)

Window:SelectTab(1)
Library:Notify{Title = "Pabloza xit", Content = "Carregado com bypass MAX", Duration = 4}
