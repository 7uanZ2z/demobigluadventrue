--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"

local BP_FrogAI = Class()

--function BP_FrogAI:Initialize(Initializer)
--end

--function BP_FrogAI:UserConstructionScript()
--end

--function BP_FrogAI:ReceiveBeginPlay()
--end

BP_FrogAI.BehaviorTree = LoadObject("/Game/AI/BT_FROG")

function BP_FrogAI:ReceiveBeginPlay()
	--local BehaviorTree = UObject.Load("/Game/Core/Blueprints/AI/BT_Enemy")
    --print("66565656")
	--self:RunBehaviorTree(self.BehaviorTree)
    --function Frogququ:ReceiveBeginPlay()
end

--function BP_FrogAI:ReceiveEndPlay()
--end

-- function BP_FrogAI:ReceiveTick(DeltaSeconds)
-- end

--function BP_FrogAI:ReceiveAnyDamage(Damage, DamageType, InstigatedBy, DamageCauser)
--end

--function BP_FrogAI:ReceiveActorBeginOverlap(OtherActor)
--end

--function BP_FrogAI:ReceiveActorEndOverlap(OtherActor)
--end

return BP_FrogAI
