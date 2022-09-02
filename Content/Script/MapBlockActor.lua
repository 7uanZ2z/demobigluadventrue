--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"

local MapBlockActor = Class()
local ModeClass = UE.UClass.Load("/Game/BluePrint/BP_bigluluShootGameMode.BP_bigluluShootGameMode_C")


function MapBlockActor:Initialize(Initializer)
    self.bWallIsOpen = false
    self.Up = false
    self.Down = false
    self.Left = false
    self.Right = false
    self.IsBoss = false
end

--function MapBlockActor:UserConstructionScript()
--end

--function MapBlockActor:ReceiveBeginPlay()
--end

function MapBlockActor:ReceiveBeginPlay()
    self.BoxCollision.OnComponentBeginOverlap:Add(self, MapBlockActor.OnComponentOverlap)
    self.EnemyTotal = 0
    self.DrawFunction = nil
    self.bWallIsOpen = false
end

function MapBlockActor:SetConner(PointAndConner)
    self.Up = PointAndConner.Up
    self.Down = PointAndConner.Down
    self.Left = PointAndConner.Left
    self.Right = PointAndConner.Right
end

function MapBlockActor:OpenAllWall(Flag)
    if self.bWallIsOpen then 
        return
    end
    self.bWallIsOpen = true
    print("OpenAllWall ", self.BlockX, self.BlockY, Flag == nil and "nil" or "true")
    if self.Up then 
        print("OpenAllWall Up")
        local nowLocation = self:GetUpWallLocation()
        self:SetUpWallLocation(UE.FVector(nowLocation.X, nowLocation.Y, self.OpenZ))
    end
    if self.Down then 
        print("OpenAllWall Down")
        local nowLocation = self:GetDownWallLocation()
        self:SetDownWallLocation(UE.FVector(nowLocation.X, nowLocation.Y, self.OpenZ))
    end
    if self.Left then 
        print("OpenAllWall Left")
        local nowLocation = self:GetLeftWallLocation()
        self:SetLeftWallLocation(UE.FVector(nowLocation.X, nowLocation.Y, self.OpenZ))
    end
    if self.Right then 
        print("OpenAllWall Right")
        local nowLocation = self:GetRightWallLocation()
        self:SetRightWallLocation(UE.FVector(nowLocation.X, nowLocation.Y, self.OpenZ))
    end

    local ModeClass = UE.UClass.Load("/Game/BluePrint/BP_bigluluShootGameMode.BP_bigluluShootGameMode_C")
    local GameMode = UE.UGameplayStatics.GetGameMode(self)
    local ShootMode = GameMode:Cast(ModeClass)

    if Flag == nil or self.EnemyTotal == 0 then
        if ShootMode.BlockMatrix[self.BlockX][self.BlockY + 1] and self.Right then 
            ShootMode.BlockMatrix[self.BlockX][self.BlockY + 1]:OpenAllWall(true)
        end
        if ShootMode.BlockMatrix[self.BlockX][self.BlockY - 1] and self.Left then 
            ShootMode.BlockMatrix[self.BlockX][self.BlockY - 1]:OpenAllWall(true)
        end

        if ShootMode.BlockMatrix[self.BlockX + 1] then 
            if ShootMode.BlockMatrix[self.BlockX + 1][self.BlockY] and self.Down then 
                ShootMode.BlockMatrix[self.BlockX + 1][self.BlockY]:OpenAllWall(true)
            end
        end
        if ShootMode.BlockMatrix[self.BlockX - 1] then 
            if ShootMode.BlockMatrix[self.BlockX - 1][self.BlockY] and self.Up then 
                ShootMode.BlockMatrix[self.BlockX - 1][self.BlockY]:OpenAllWall(true)
            end
        end 
    end
end

function MapBlockActor:CloseAllWall()
    if not self.bWallIsOpen then 
        return
    end
    print("CloseAllWall ", self.BlockX, self.BlockY)
    self.bWallIsOpen = false
    if self.Up then 
        local nowLocation = self:GetUpWallLocation()
        self:SetUpWallLocation(UE.FVector(nowLocation.X, nowLocation.Y, self.CloseZ))
    end
    if self.Down then 
        local nowLocation = self:GetDownWallLocation()
        self:SetDownWallLocation(UE.FVector(nowLocation.X, nowLocation.Y, self.CloseZ))
    end 
    if self.Left then 
        local nowLocation = self:GetLeftWallLocation()
        self:SetLeftWallLocation(UE.FVector(nowLocation.X, nowLocation.Y, self.CloseZ))
    end
    if self.Right then 
        local nowLocation = self:GetRightWallLocation()
        self:SetRightWallLocation(UE.FVector(nowLocation.X, nowLocation.Y, self.CloseZ))
    end
end

local luluClass = UE.UClass.Load("/Game/BluePrint/character/BP_lulu2.BP_lulu2_C")

function MapBlockActor:OnComponentOverlap(HitComponent, OtherActor, OtherComp, NormalImpulse, Hit)
    local Character = OtherActor:Cast(luluClass)
	if Character then
        Character.BlockX = self.BlockX
        Character.BlockY = self.BlockY
        local GameMode = UE.UGameplayStatics.GetGameMode(self)
        local ShootMode = GameMode:Cast(ModeClass)
        if ShootMode then
            ShootMode:SetNowBlock(self)
            if self.EnemyTotal ~= 0 then 
                self:CloseAllWall()
            else 
                self:OpenAllWall()
            end

            if self.IsBoss then 
                ShootMode:ShowBoss()
            end
        end
        if self.DrawFunction ~= nil then
            self.DrawFunction()
        end
	end
end

-- function MapBlockActor:ReceiveTick(DeltaSeconds)
-- end

--function MapBlockActor:ReceiveAnyDamage(Damage, DamageType, InstigatedBy, DamageCauser)
--end

--function MapBlockActor:ReceiveActorBeginOverlap(OtherActor)
--end

--function MapBlockActor:ReceiveActorEndOverlap(OtherActor)
--end

return MapBlockActor
