--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"

local MapBlockActor = Class()

function MapBlockActor:Initialize(Initializer)
    self.bWallIsOpen = false
    self.Up = false
    self.Down = false
    self.Left = false
    self.Right = false
end

--function MapBlockActor:UserConstructionScript()
--end

--function MapBlockActor:ReceiveBeginPlay()
--end

--function MapBlockActor:ReceiveEndPlay()
--end

function MapBlockActor:SetConner(PointAndConner)
    self.Up = PointAndConner.Up
    self.Down = PointAndConner.Down
    self.Left = PointAndConner.Left
    self.Right = PointAndConner.Right
end

function MapBlockActor:OpenAllWall()
    if self.bWallIsOpen then 
        return
    end
   
    if self.Up then 
        local nowLocation = self:GetUpWallLocation()
        self:SetUpWallLocation(UE.FVector(nowLocation.X, nowLocation.Y, self.OpenZ))
    end
    if self.Down then 
        local nowLocation = self:GetDownWallLocation()
        self:SetDownWallLocation(UE.FVector(nowLocation.X, nowLocation.Y, self.OpenZ))
    end
    if self.Left then 
        local nowLocation = self:GetLeftWallLocation()
        self:SetLeftWallLocation(UE.FVector(nowLocation.X, nowLocation.Y, self.OpenZ))
    end
    if self.Right then 
        local nowLocation = self:GetRightWallLocation()
        self:SetRightWallLocation(UE.FVector(nowLocation.X, nowLocation.Y, self.OpenZ))
    end
end

function MapBlockActor:CloseAllWall()
    if self.bWallIsOpen then 
        return
    end
   
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

-- function MapBlockActor:ReceiveTick(DeltaSeconds)
-- end

--function MapBlockActor:ReceiveAnyDamage(Damage, DamageType, InstigatedBy, DamageCauser)
--end

--function MapBlockActor:ReceiveActorBeginOverlap(OtherActor)
--end

--function MapBlockActor:ReceiveActorEndOverlap(OtherActor)
--end

return MapBlockActor
