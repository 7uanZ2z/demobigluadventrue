--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"

local MapSubSystem = require "MapSubSystem"
local Screen = require "Screen"

local WorldMap = Class()

WMWnd = {}
WMWnd.Open = {}

function WorldMap:GetMapHeight()

    local ULConner = self.UpperLeftConner:K2_GetActorLocation()
    local DRConner = self.DownRightConner:K2_GetActorLocation()
    return math.abs(ULConner.X - DRConner.X)
end

function WorldMap:GetMapWidth()
    local ULConner = self.UpperLeftConner:K2_GetActorLocation()
    local DRConner = self.DownRightConner:K2_GetActorLocation()

    return math.abs(ULConner.Y - DRConner.Y)
end

function WorldMap:ConvertLocationToMapLocation(Location)
    local ULConner = self.UpperLeftConner:K2_GetActorLocation()
    local DRConner = self.DownRightConner:K2_GetActorLocation()
    local ret = {}
    ret.X = math.abs(Location.Y - DRConner.Y)
    ret.Y = math.abs(ULConner.X - Location.X)
    return ret
end


function WorldMap:InitiallizeMap(Player)
    local ModeClass = UE.UClass.Load("/Game/BluePrint/BP_bigluluShootGameMode.BP_bigluluShootGameMode_C")
    local GameMode = UE.UGameplayStatics.GetGameMode(self)
    local ShootMode = GameMode:Cast(ModeClass)
    ShootMode.BlockMatrix = {}
    
    self.m_Player = Player
    self.m_MapBlockX = 20
    self.m_MapBlockY = 20
    self.m_LevelLength = ShootMode.MainLength
    self.m_BranchLength = ShootMode.BranchSum
    
    MapSubSystem.SetMapConner(self)
    if not self.UpperLeftConner or not self.DownRightConner then
        return 
    end

    self.bHasScriptImplementedTick = false
    local widget_class = UE.UClass.Load("/Game/WorldMapSystem/W_WorldMap.W_WorldMap_C")
    WMWnd[Player] = NewObject(widget_class, Player)
    WMWnd[Player]:AddToViewport()
    WMWnd.Open[Player] = true
    self.m_Wnd = WMWnd[Player]
    self.bCanEverTick = false
    Player.MapClicked = function()
        if WMWnd.Open[Player] == true then 
            WMWnd.Open[Player] = false
            WMWnd[Player]:RemoveFromParent()
        else 
            WMWnd.Open[Player] = true
            WMWnd[Player]:AddToViewport()
        end
    end
    Player.MapClicked()
    
    self.m_Wnd:ClearMap()
    for i = 1, 10 do
        self.m_Wnd:DrawMapBlock(i, i, self.m_MapBlockX, self.m_MapBlockY)
    end
    self.m_Wnd:ClearMap()

    self.m_Wnd:InitCharacterBlock()
    --local PlayerPosition = self:ConvertLocationToMapLocation(self.m_Player:K2_GetActorLocation())
    --self.m_Wnd:SetCharacterPosition(PlayerPosition.X, PlayerPosition.Y, 
    --        self:GetMapHeight(), self:GetMapWidth())

    local v = MapSubSystem.NewRandomMap(self.m_MapBlockX, self.m_MapBlockY, self.m_LevelLength, self.m_BranchLength)

    local World = self:GetWorld()
    local SpawnClass = UE.UClass.Load("/Game/WorldMapSystem/Actors/MapBlock.MapBlock_C")
    local sp = UE.FActorSpawnParameters()
	sp.SpawnCollisionHandlingOverride = UE.ESpawnActorCollisionHandlingMethod.AlwaysSpawn
	sp.Owner = self
	sp.Instigator = self

    local minX = 99999
    local minY = 99999
    local maxX = -1
    local maxY = -1
    local minRealX = nil
    local minRealY = nil
    local maxRealX = nil
    local maxRealY = nil
    for i = 1, v:Length() do
        local nowpoint = v:Get(i)
        minX = nowpoint.X < minX and nowpoint.X or minX
        minY = nowpoint.Y < minY and nowpoint.Y or minY
        maxX = nowpoint.X > maxX and nowpoint.X or maxX
        maxY = nowpoint.Y > maxY and nowpoint.Y or maxY
    end
    self.m_MapBlockX = maxX - minX + 1
    self.m_MapBlockY = maxY - minY + 1
    local NowActor
    local StartBlock
    local Z = -5000
    for i = 1, v:Length() do
        local nowpoint = v:Get(i)
        --print("Error nowpoint.X nowpoint.Y",nowpoint.X,nowpoint.Y)
        self.m_Wnd:DrawMapBlock(nowpoint.X - minX + 1, nowpoint.Y - minY + 1, self.m_MapBlockX, self.m_MapBlockY)
        if SpawnClass then
            local Quat = UE.FQuat(0, 0, 0, 0)
            
            local Vector = UE.FVector((nowpoint.X - minX) * 1600, -(nowpoint.Y - minY) * 1600, Z)
            local Transform = UE.FTransform(Quat, Vector)
            NowActor = World:SpawnActor(SpawnClass, Transform, sp)
            if NowActor then
                
                NowActor.BlockX = nowpoint.X
                NowActor.BlockY = nowpoint.Y
                if ShootMode.BlockMatrix[nowpoint.X] == nil then 
                    ShootMode.BlockMatrix[nowpoint.X] = {}
                end
                ShootMode.BlockMatrix[nowpoint.X][nowpoint.Y] = NowActor

                NowActor:SetConner(nowpoint)
                if ShootMode.bIsVisitor then
                    NowActor:OpenAllWall()
                else 
                    NowActor:CloseAllWall()
                end
                NowActor.DrawFunction = function()
                    self.m_Wnd:DrawMapBlock(nowpoint.X - minX + 1, nowpoint.Y - minY + 1, self.m_MapBlockX, self.m_MapBlockY, WorldMapWnd.MapType.Lulu)
                end

                local RDlocation = NowActor:GetRightDownLocation()
                local LUlocation = NowActor:GetLeftUpLocation()
                local minnx = LUlocation.X < RDlocation.X and LUlocation.X or RDlocation.X
                local minny = LUlocation.Y < RDlocation.Y and LUlocation.Y or RDlocation.Y
                local maxxx = LUlocation.X > RDlocation.X and LUlocation.X or RDlocation.X
                local maxxy = LUlocation.Y > RDlocation.Y and LUlocation.Y or RDlocation.Y
                
                local Sampling = math.random(-10, 10)
                if not ShootMode.bIsVisitor then
                    if nowpoint.IsStart == true then 
                        StartBlock = NowActor
                    elseif nowpoint.IsEnd == true then
                        self:CreateFool(nowpoint, minX, minY, Z)
                        self:CreateQuqu(nowpoint, minX, minY, Z)
                        self:CreateQuqu(nowpoint, minX, minY, Z)
                        NowActor.EnemyTotal = 3
                        NowActor.IsBoss = true
                        self.BossX = nowpoint.X
                        self.BossY = nowpoint.Y
                    else 
                        if Sampling > 0 then 
                            self:CreateQuqu(nowpoint, minX, minY, Z)
                            self:CreateQuqu(nowpoint, minX, minY, Z)
                            self:CreateQuqu(nowpoint, minX, minY, Z)
                            NowActor.EnemyTotal = 3
                        else 
                            self:CreateReward(nowpoint, minX, minY, Z)
                            NowActor.EnemyTotal = 0
                        end
                    end
                end

                if not minRealX then 
                    minRealX = minnx
                else 
                    minRealX = minRealX > minnx and minnx or minRealX
                end
                if not maxRealX then 
                    maxRealX = maxxx
                else 
                    maxRealX = maxRealX < maxxx and maxxx or maxRealX
                end
                if not minRealY then 
                    minRealY = minny
                else 
                    minRealY = minRealY > minny and minny or minRealY
                end
                if not maxRealY then 
                    maxRealY = maxxy
                else 
                    maxRealY = maxRealY < maxxy and maxxy or maxRealY
                end
            end
        end
    end
    if not ShootMode.bIsVisitor then
        StartBlock:OpenAllWall() 
        local PlayerCharacter = UE.UGameplayStatics.GetPlayerCharacter(self, 0)
        local X = ((StartBlock.BlockX - minX) * 16) * 100
        local Y = ((-(StartBlock.BlockY - minY)) * 16) * 100
        StartBlock.minX = minX
        StartBlock.minY = minY
    
        PlayerCharacter:K2_SetActorLocation(UE.FVector(X, Y, Z + 180), false, nil, false)
        self.m_Wnd:DrawMapBlock(StartBlock.BlockX - minX + 1, StartBlock.BlockY - minY + 1, self.m_MapBlockX, self.m_MapBlockY, WorldMapWnd.MapType.Lulu)

        self.m_Wnd.BossX = self.BossX
        self.m_Wnd.BossY = self.BossY
        self.m_Wnd:DrawMapBlock(self.BossX - minX + 1, self.BossY - minY + 1, self.m_MapBlockX, self.m_MapBlockY, WorldMapWnd.MapType.Boss)
    end

    self.UpperLeftConner:K2_SetActorLocation(UE.FVector(minRealX, minRealY, 0.0),false, nil, false)
    self.DownRightConner:K2_SetActorLocation(UE.FVector(maxRealX, maxRealY, 0.0),false, nil, false)
end

function WorldMap:CreateQuqu(nowpoint, minX, minY, Z)
    --print("Error nowpoint.X nowpoint.Y",nowpoint.X,nowpoint.Y)
    local X = ((nowpoint.X - minX) * 16 + math.random(-7, 7)) * 100
    local Y = ((-(nowpoint.Y - minY)) * 16 + math.random(-7, 7)) * 100

    local ModeClass = UE.UClass.Load("/Game/BluePrint/BP_bigluluShootGameMode.BP_bigluluShootGameMode_C")
    local GameMode = UE.UGameplayStatics.GetGameMode(self)
    local ShootMode = GameMode:Cast(ModeClass)

    local QuquClass = UE.UClass.Load("/Game/BluePrint/character/BP_Enemy.BP_Enemy_C")
    local Rota = UE.FRotator(0, 0, 0)
    local Vector = UE.FVector(X, Y, Z + 180)
    local pawn = ShootMode:CreateAIActor(QuquClass, 0, Vector, Rota)
    local ququ = pawn:Cast(QuquClass)

    ququ.BlockX = nowpoint.X
    ququ.BlockY = nowpoint.Y
    ququ.BlockMinX = (nowpoint.X - minX) * 1600 - 700
    ququ.BlockMaxX = (nowpoint.X - minX) * 1600 + 700
    ququ.BlockMinY = -(nowpoint.Y - minY) * 1600 - 700
    ququ.BlockMaxY = -(nowpoint.Y - minY) * 1600 + 700
end

function WorldMap:CreateFool(nowpoint, minX, minY, Z)
    local X = ((nowpoint.X - minX) * 16 + math.random(-7, 7)) * 100
    local Y = ((-(nowpoint.Y - minY)) * 16 + math.random(-7, 7)) * 100

    local ModeClass = UE.UClass.Load("/Game/BluePrint/BP_bigluluShootGameMode.BP_bigluluShootGameMode_C")
    local GameMode = UE.UGameplayStatics.GetGameMode(self)
    local ShootMode = GameMode:Cast(ModeClass)

    local FoolClass = UE.UClass.Load("/Game/BluePrint/character/BP_Boss.BP_Boss_C")
    local Rota = UE.FRotator(0, 0, 0)
    local Vector = UE.FVector(X, Y, Z + 180)
    local pawn = ShootMode:CreateAIActor(FoolClass, 1, Vector, Rota)
    local fool = pawn:Cast(FoolClass)
    
    fool.BlockX = nowpoint.X
    fool.BlockY = nowpoint.Y
    fool.BlockMinX = (nowpoint.X - minX) * 1600 - 800
    fool.BlockMaxX = (nowpoint.X - minX) * 1600 + 800
    fool.BlockMinY = -(nowpoint.Y - minY) * 1600 - 800
    fool.BlockMaxY = -(nowpoint.Y - minY) * 1600 + 800
end

function WorldMap:CreateReward(nowpoint, minX, minY, Z)
    local X = ((nowpoint.X - minX) * 16 ) * 100
    local Y = ((-(nowpoint.Y - minY)) * 16) * 100

    local RewardClass = UE.UClass.Load("/Game/BluePrint/Actor/BP_Reward.BP_Reward_C")
    local Rotation = UE.FRotator(0.0,0.0,0.0)
    local World = self:GetWorld()
    local MyLocation = UE.FVector(X, Y, Z + 180)
    
    local Transform = UE.FTransform(Rotation:ToQuat(), MyLocation)
    local sp = UE.FActorSpawnParameters()
	sp.SpawnCollisionHandlingOverride = UE.ESpawnActorCollisionHandlingMethod.AlwaysSpawn
	sp.Owner = self
	sp.Instigator = self

    local AlwaysSpawn = UE.ESpawnActorCollisionHandlingMethod.AlwaysSpawn
    if RewardClass == nil then
        print("nononono!")
    end
    local Reward = World:SpawnActor(RewardClass, Transform, sp) 
    
    Reward.BlockX = nowpoint.X
    Reward.BlockY = nowpoint.Y
end

--function WorldMap:Initialize(Initializer)
--end

--function WorldMap:ReceiveBeginPlay()
--end

--function WorldMap:ReceiveEndPlay()
--end

--[[
function WorldMap:ReceiveTick(DeltaSeconds)
    if self.m_Player ~= nil and WMWnd.Open[self.m_Player] == true then
        local Rotation = self.m_Player:K2_GetActorRotation()
        local PlayerPosition = self:ConvertLocationToMapLocation(self.m_Player:K2_GetActorLocation())
        
        self.m_Wnd:SetCharacterPosition(PlayerPosition.X, PlayerPosition.Y, 
                self:GetMapHeight(), self:GetMapWidth())
        self.m_Wnd:SetCharacterRotator(Rotation.Yaw + 90)
    end
end
]]--

return WorldMap
