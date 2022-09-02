--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"

local FoolHuge = Class()

--function FoolHuge:Initialize(Initializer)
--end

--function FoolHuge:UserConstructionScript()
--end

function FoolHuge:ReceiveBeginPlay()
    self.Life = 5
    self.MaxLife = 5

    self.BoxCollision.OnComponentBeginOverlap:Add(self, FoolHuge.OnComponentOverlap)
end

local ModeClass = UE.UClass.Load("/Game/BluePrint/BP_bigluluShootGameMode.BP_bigluluShootGameMode_C")

function FoolHuge:Damaged(damage)
    damage = damage or 1
    self.Life = self.Life - damage
    
    local GameMode = UE.UGameplayStatics.GetGameMode(self)
    local ShootMode = GameMode:Cast(ModeClass)
    if ShootMode then
        ShootMode:SetBossLife(self.Life, self.MaxLife)
    end
    if self.Life == 0 then
        self:K2_DestroyActor()
        if ShootMode then
            ShootMode:DecreseEnemy()
        end
    end
end

local luluClass = UE.UClass.Load("/Game/BluePrint/character/BP_lulu2.BP_lulu2_C")

function FoolHuge:OnComponentOverlap(HitComponent, OtherActor, OtherComp, NormalImpulse, Hit)
    local Character = OtherActor:Cast(luluClass)
	if Character then
        Character:Damaged(999)
	end
end

--function FoolHuge:ReceiveEndPlay()
--end

-- function FoolHuge:ReceiveTick(DeltaSeconds)
-- end

--function FoolHuge:ReceiveAnyDamage(Damage, DamageType, InstigatedBy, DamageCauser)
--end

--function FoolHuge:ReceiveActorBeginOverlap(OtherActor)
--end

--function FoolHuge:ReceiveActorEndOverlap(OtherActor)
--end

return FoolHuge
