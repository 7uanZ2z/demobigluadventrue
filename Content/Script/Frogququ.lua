--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"

local Frogququ = Class()

--function Frogququ:Initialize(Initializer)
--end

local ModeClass = UE.UClass.Load("/Game/BluePrint/BP_bigluluShootGameMode.BP_bigluluShootGameMode_C")

function Frogququ:Damaged()
    self:K2_DestroyActor()
    local GameMode = UE.UGameplayStatics.GetGameMode(self)
    local ShootMode = GameMode:Cast(ModeClass)
    
    if ShootMode then
        ShootMode:DecreseEnemy()
    end
end

--function Frogququ:UserConstructionScript()
--end

--function Frogququ:ReceiveBeginPlay()
--end

--function Frogququ:ReceiveEndPlay()
--end

-- function Frogququ:ReceiveTick(DeltaSeconds)
-- end

--function Frogququ:ReceiveAnyDamage(Damage, DamageType, InstigatedBy, DamageCauser)
--end

--function Frogququ:ReceiveActorBeginOverlap(OtherActor)
--end

--function Frogququ:ReceiveActorEndOverlap(OtherActor)
--end

return Frogququ
