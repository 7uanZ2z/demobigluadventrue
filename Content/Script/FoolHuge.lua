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
    self.Life = 10
    self.MaxLife = 10
end

local ModeClass = UE.UClass.Load("/Game/BluePrint/BP_bigluluShootGameMode.BP_bigluluShootGameMode_C")

function FoolHuge:Damaged()
    self.Life = self.Life - 1
    
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
