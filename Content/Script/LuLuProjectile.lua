--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"

local LuLuProjectile = Class()

local FVector = UE.FVector
local FLinearColor = UE.FLinearColor

--function LuLuProjectile:Initialize(Initializer)
--end

--function LuLuProjectile:UserConstructionScript()
--end

function LuLuProjectile:ReceiveBeginPlay()
    local x = math.random(-10000, 10000)
    local y = math.random(-10000, 10000)
    local z = math.random(30000, 40000)

    local s = 0.3

    self.Sphere:SetWorldScale3D(FVector(s, s, s))
    self.TimerHandle = UE.UKismetSystemLibrary.K2_SetTimerDelegate({self, LuLuProjectile.LifeEnd}, 5.0, false)
    self.SphereCollision.OnComponentBeginOverlap:Add(self, LuLuProjectile.OnComponentHit_Sphere)
    local EatSound = UE.UObject.Load("/Game/Sound/lu_cue.lu_cue")
    UE.UGameplayStatics.PlaySound2D(self, EatSound) 
end

function LuLuProjectile:LifeEnd()
    UE.UKismetSystemLibrary.K2_ClearAndInvalidateTimerHandle(self, self.TimerHandle)
    self.TimerHandle = nil
    self:K2_DestroyActor()
end

function LuLuProjectile:Shoot(Direction, Time)
    self.Sphere:AddImpulse(Direction * 40000 * Time)
end

local QuquClass = UE.UClass.Load("/Game/BluePrint/character/BP_Enemy.BP_Enemy_C")
local BossClass = UE.UClass.Load("/Game/BluePrint/character/BP_Boss.BP_Boss_C")

function LuLuProjectile:OnComponentHit_Sphere(HitComponent, OtherActor, OtherComp, NormalImpulse, Hit)
    local Character = OtherActor:Cast(BossClass)
	if Character then
        print("Hit Boss!")
        self:K2_DestroyActor()
        local PlayerCharacter = UE.UGameplayStatics.GetPlayerCharacter(self, 0)
        if PlayerCharacter.BlockX ~= Character.BlockX or PlayerCharacter.BlockY ~= Character.BlockY then 
            return 
        end
        Character:Damaged()
	end

	local Character = OtherActor:Cast(QuquClass)
	if Character then
        print("Hit ququ!")
        self:K2_DestroyActor()
        local PlayerCharacter = UE.UGameplayStatics.GetPlayerCharacter(self, 0)
        if PlayerCharacter.BlockX ~= Character.BlockX or PlayerCharacter.BlockY ~= Character.BlockY then 
            return 
        end
        Character:Damaged()
	end
end

--function LuLuProjectile:ReceiveEndPlay()
--end

-- function LuLuProjectile:ReceiveTick(DeltaSeconds)
-- end

--function LuLuProjectile:ReceiveAnyDamage(Damage, DamageType, InstigatedBy, DamageCauser)
--end

--function LuLuProjectile:ReceiveActorBeginOverlap(OtherActor)
--end

--function LuLuProjectile:ReceiveActorEndOverlap(OtherActor)
--end

return LuLuProjectile
