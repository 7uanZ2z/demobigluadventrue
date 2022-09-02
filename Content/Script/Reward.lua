--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"

local Reward = Class()

function Reward:Initialize(Initializer)
    self.RewardType = 1
end

--function Reward:UserConstructionScript()
--end

function Reward:ReceiveBeginPlay()
    self.SphereCollision.OnComponentBeginOverlap:Add(self, Reward.OnComponentOverlap_Sphere)
    self.SphereCollision.OnComponentEndOverlap:Add(self, Reward.OnComponentOverlapEnd_Sphere)
end


local luluClass = UE.UClass.Load("/Game/BluePrint/character/BP_lulu2.BP_lulu2_C")

function Reward:OnComponentOverlap_Sphere(HitComponent, OtherActor, OtherComp, NormalImpulse, Hit)
    local Character = OtherActor:Cast(luluClass)

	if Character then
        Character:SetRewardTouch(self)
	end
end

function Reward:OnComponentOverlapEnd_Sphere(HitComponent, OtherActor, OtherComp, NormalImpulse, Hit)
    local Character = OtherActor:Cast(luluClass)
	if Character then
        if Character.RewardTouch == self then
            Character:SetRewardTouch(nil)
        end
	end
end

--function Reward:ReceiveEndPlay()
--end

-- function Reward:ReceiveTick(DeltaSeconds)
-- end

--function Reward:ReceiveAnyDamage(Damage, DamageType, InstigatedBy, DamageCauser)
--end

--function Reward:ReceiveActorBeginOverlap(OtherActor)
--end

--function Reward:ReceiveActorEndOverlap(OtherActor)
--end

return Reward
