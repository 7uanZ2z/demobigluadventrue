--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"

local Ququpaopao = Class()

function Ququpaopao:Initialize(Initializer)
    self.Velocity = 5
    self.Direction = UE.FVector(0,0,0)
end

--function Ququpaopao:UserConstructionScript()
--end

function Ququpaopao:ReceiveBeginPlay()
    print("Succeed to Create")

    self.TimerHandle = UE.UKismetSystemLibrary.K2_SetTimerDelegate({self, Ququpaopao.LifeEnd}, 5.0, false)
    self.SphereCollision.OnComponentBeginOverlap:Add(self, Ququpaopao.OnComponentHit_Sphere)
    
    local QuquSound = UE.UObject.Load("/Game/Sound/qingwa_cue.qingwa_cue")
    UE.UGameplayStatics.PlaySound2D(self, QuquSound)
end

function Ququpaopao:LifeEnd()
    UE.UKismetSystemLibrary.K2_ClearAndInvalidateTimerHandle(self, self.TimerHandle)
    self.TimerHandle = nil
    self:K2_DestroyActor()
end

local luluClass = UE.UClass.Load("/Game/BluePrint/character/BP_lulu2.BP_lulu2_C")

function Ququpaopao:OnComponentHit_Sphere(HitComponent, OtherActor, OtherComp, NormalImpulse, Hit)
    local Character = OtherActor:Cast(luluClass)
	if Character then
        print("Hit lulu!")
        self:K2_DestroyActor()
        Character:Damaged(1)
	end
end

--function Ququpaopao:ReceiveEndPlay()
--end

-- function Ququpaopao:ReceiveTick(DeltaSeconds)
-- end

--function Ququpaopao:ReceiveAnyDamage(Damage, DamageType, InstigatedBy, DamageCauser)
--end

--function Ququpaopao:ReceiveActorBeginOverlap(OtherActor)
--end

--function Ququpaopao:ReceiveActorEndOverlap(OtherActor)
--end

return Ququpaopao
