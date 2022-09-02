--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"
local Screen = require "Screen"
local WndMgr = require "WndMgr"

local BP_PlayerCharacter = Class()
local ModeClass = UE.UClass.Load("/Game/BluePrint/BP_bigluluShootGameMode.BP_bigluluShootGameMode_C")

--function BP_PlayerCharacter:Initialize(Initializer)
--end

--function BP_PlayerCharacter:UserConstructionScript()
--end

function BP_PlayerCharacter:ReceiveBeginPlay()
    self.PlayerMap:InitiallizeMap(self)

    local widget_class = UE.UClass.Load("/Game/BluePrint/FireProgress.FireProgress_C")
    self.Progress = NewObject(widget_class, self)
    self.Progress:AddToViewport()
    self.TotolTime = 0
    self.MaxTime = 3
    self.FireTime = 1
    self.IsFiring = false
    self.RewardTouch = nil
    self.HavePressedMouseLeft = false
    

    --local widget_class = UE.UClass.Load("/Game/UI/PlayingWnd.PlayingWnd_C")
    --local MiniMap = NewObject(widget_class, self)
    --WndMgr.ShowMainWidget("MiniMap", MiniMap)
end 

function BP_PlayerCharacter:M_Pressed()
    if self.MapClicked then
        self.MapClicked()
    end
end

function BP_PlayerCharacter:B_Pressed()
    self:Damaged()
end

function BP_PlayerCharacter:P_Pressed()
    local GameMode = UE.UGameplayStatics.GetGameMode(self)
    local ShootMode = GameMode:Cast(ModeClass)
    if ShootMode then
        ShootMode:Lose()
    end
end

function BP_PlayerCharacter:LeftMouseButton_Pressed()
    if self.RewardTouch ~= nil then
        local GameMode = UE.UGameplayStatics.GetGameMode(self)
        local ShootMode = GameMode:Cast(ModeClass)
        if ShootMode then
            ShootMode:GetReward(self.RewardTouch.RewardType)
            self.RewardTouch:K2_DestroyActor()
            self.RewardTouch = nil
            local EatSound = UE.UObject.Load("/Game/Sound/eat_cue.eat_cue") 
            UE.UGameplayStatics.PlaySound2D(self, EatSound) 
        end
        return 
    end
    self.Progress:PlayAnimation(self.Progress.Animation_Show)
    self.TotolTime = 0
    self.IsFiring = true
    self.HavePressedMouseLeft = true
end

function BP_PlayerCharacter:LeftMouseButton_Released()
    if self.HavePressedMouseLeft == false then return end
    self.HavePressedMouseLeft = false
    self.Progress:PlayAnimation(self.Progress.Animation_Hide)

    if self.TotolTime > self.FireTime then
        self:Fire(self.TotolTime > self.MaxTime and self.MaxTime or self.TotolTime)
    end

    self.TotolTime = 0
    self.IsFiring = false
end

function BP_PlayerCharacter:Damaged(damage)
    if damage ~= nil then
        local GameMode = UE.UGameplayStatics.GetGameMode(self)
        local ShootMode = GameMode:Cast(ModeClass)
        if ShootMode then
            ShootMode:Damaged(damage)
        end
    end
    print("GetDamage!!!")
    self.BloodTotal = 5
    self:FlyBlood()
    self:FlyBlood()
    self:FlyBlood()
    self.FlyBloodTimer = UE.UKismetSystemLibrary.K2_SetTimerDelegate({self, self.FlyBlood}, 0.15, true)
    
end

function BP_PlayerCharacter:FlyBlood()
    if not self.FlyBloodTimer then
        return 
    end

    local World = self:GetWorld()
    local BloodClass = self.BloodClass
    local Transform = self:GetTransform()

    local AlwaysSpawn = UE.ESpawnActorCollisionHandlingMethod.AlwaysSpawn
    World:SpawnActor(BloodClass, Transform, AlwaysSpawn, self, self, "Blood")
    
    self.BloodTotal = self.BloodTotal - 1
    if self.BloodTotal == 0 then
        UE.UKismetSystemLibrary.K2_ClearTimerHandle(self, self.FlyBloodTimer)
        self.FlyBloodTimer = nil
    end
end


function BP_PlayerCharacter:Fire(Time)
    local Direction = self.ProjectileDirection:GetForwardVector()
    local Rotation = UE.UKismetMathLibrary.FindLookAtRotation(UE.FVector(0.0,0.0,0.0), Direction)
    local World = self:GetWorld()
    local ProjectileClass = self.ProjectileClass
    local MyLocation = self.ProjectileDirection:K2_GetComponentLocation()
    
    local Transform = UE.FTransform(Rotation:ToQuat(), MyLocation)
    local sp = UE.FActorSpawnParameters()
	sp.SpawnCollisionHandlingOverride = UE.ESpawnActorCollisionHandlingMethod.AlwaysSpawn
	sp.Owner = self
	sp.Instigator = self

    local AlwaysSpawn = UE.ESpawnActorCollisionHandlingMethod.AlwaysSpawn
    if ProjectileClass == nil then
        print("nononono!")
    end
    local Projectile = World:SpawnActor(ProjectileClass, Transform, sp) 
    Projectile:Shoot(Direction, Time)
end

--function BP_PlayerCharacter:ReceiveEndPlay()
--end

function BP_PlayerCharacter:SetRewardTouch(actor)
    self.RewardTouch = actor
end


function BP_PlayerCharacter:ReceiveTick(DeltaSeconds)
    if self.IsFiring then
        self.TotolTime = self.TotolTime + DeltaSeconds
        self.Progress:SetProgress(self.TotolTime, self.MaxTime, self.FireTime)
    end
end

--function BP_PlayerCharacter:ReceiveAnyDamage(Damage, DamageType, InstigatedBy, DamageCauser)
--end

--function BP_PlayerCharacter:ReceiveActorBeginOverlap(OtherActor)
--end

--function BP_PlayerCharacter:ReceiveActorEndOverlap(OtherActor)
--end

return BP_PlayerCharacter
