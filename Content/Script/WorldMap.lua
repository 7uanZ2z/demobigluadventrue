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
    
    self.m_Player = Player
    self.m_MapBlockX = 20
    self.m_MapBlockY = 20
    self.m_LevelLength = 15
    
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
    print("123!!!!!!!!!!!!!!!!!")
    Player.MapClicked()
    
    self.m_Wnd:ClearMap()
    for i = 1, 10 do
        self.m_Wnd:DrawMapBlock(i, i, self.m_MapBlockX, self.m_MapBlockY)
    end
    self.m_Wnd:ClearMap()

    self.m_Wnd:InitCharacterBlock()
    local PlayerPosition = self:ConvertLocationToMapLocation(self.m_Player:K2_GetActorLocation())
    self.m_Wnd:SetCharacterPosition(PlayerPosition.X, PlayerPosition.Y, 
            self:GetMapHeight(), self:GetMapWidth())

    local v = MapSubSystem.NewRandomMap(self.m_MapBlockX, self.m_MapBlockY, self.m_LevelLength)

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
    for i = 1, v:Length() do
        local nowpoint = v:Get(i)
        self.m_Wnd:DrawMapBlock(nowpoint.X - minX + 1, nowpoint.Y - minY + 1, self.m_MapBlockX, self.m_MapBlockY)
        if SpawnClass then
            Quat = UE.FQuat(0, 0, 0, 0)
            Vector = UE.FVector((nowpoint.X - minX) * 1600, -(nowpoint.Y - minY) * 1600, -5000)
            local Transform = UE.FTransform(Quat, Vector)
            NowActor = World:SpawnActor(SpawnClass, Transform, sp)
            if NowActor then
                NowActor:SetConner(nowpoint)
                NowActor:OpenAllWall()
                local RDlocation = NowActor:GetRightDownLocation()
                local LUlocation = NowActor:GetLeftUpLocation()
                local minnx = LUlocation.X < RDlocation.X and LUlocation.X or RDlocation.X
                local minny = LUlocation.Y < RDlocation.Y and LUlocation.Y or RDlocation.Y
                local maxxx = LUlocation.X > RDlocation.X and LUlocation.X or RDlocation.X
                local maxxy = LUlocation.Y > RDlocation.Y and LUlocation.Y or RDlocation.Y
                print("RDlocation.X", RDlocation.X)
                print("RDlocation.Y", RDlocation.Y)
                print("LUlocation.X", LUlocation.X)
                print("LUlocation.Y", LUlocation.Y)
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

    print(self.DownRightConner:K2_GetActorLocation().X)
    print(self.DownRightConner:K2_GetActorLocation().Y)
    self.UpperLeftConner:K2_SetActorLocation(UE.FVector(minRealX, minRealY, 0.0),false, nil, false)
    self.DownRightConner:K2_SetActorLocation(UE.FVector(maxRealX, maxRealY, 0.0),false, nil, false)
    print(self.DownRightConner:K2_GetActorLocation().X)
    print(self.DownRightConner:K2_GetActorLocation().Y)
    
    --print( and "true" or "false")
end


--function WorldMap:Initialize(Initializer)
--end

--function WorldMap:ReceiveBeginPlay()
--end

--function WorldMap:ReceiveEndPlay()
--end

function WorldMap:ReceiveTick(DeltaSeconds)
    if self.m_Player ~= nil and WMWnd.Open[self.m_Player] == true then
        local Rotation = self.m_Player:K2_GetActorRotation()
        local PlayerPosition = self:ConvertLocationToMapLocation(self.m_Player:K2_GetActorLocation())
        
        self.m_Wnd:SetCharacterPosition(PlayerPosition.X, PlayerPosition.Y, 
                self:GetMapHeight(), self:GetMapWidth())
        self.m_Wnd:SetCharacterRotator(Rotation.Yaw)
    end
end

return WorldMap
