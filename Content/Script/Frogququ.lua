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
local Screen = require "Screen"

function Frogququ:Damaged()
    self:K2_DestroyActor()
    local GameMode = UE.UGameplayStatics.GetGameMode(self)
    local ShootMode = GameMode:Cast(ModeClass)
    
    if ShootMode then
        ShootMode:DecreseEnemy()
    end
end

local PaopaoClass = UE.UClass.Load("/Game/BluePrint/Actor/BP_QuquPopo.BP_QuquPopo_C")

function Frogququ:shoot()
    print("Shoot ok")
    local MyLocation = self.PaopaoLocation:K2_GetComponentLocation()
    local PlayerCharacter = UE.UGameplayStatics.GetPlayerCharacter(self, 0)
	local TargetLocation = PlayerCharacter:K2_GetActorLocation()

    local Rotation = UE.UKismetMathLibrary.FindLookAtRotation(MyLocation, TargetLocation)

    local World = self:GetWorld()
    local Transform = UE.FTransform(Rotation:ToQuat(), MyLocation)
    local sp = UE.FActorSpawnParameters()
	sp.SpawnCollisionHandlingOverride = UE.ESpawnActorCollisionHandlingMethod.AlwaysSpawn
	sp.Owner = self
	sp.Instigator = self

    local AlwaysSpawn = UE.ESpawnActorCollisionHandlingMethod.AlwaysSpawn
    if PaopaoClass == nil then
        print("nononono paopao!")
    end
    local paopao = World:SpawnActor(PaopaoClass, Transform, sp)
end


function Frogququ:ReceiveBeginPlay()
	--local BehaviorTree = UObject.Load("/Game/Core/Blueprints/AI/BT_Enemy")
	--self:RunBehaviorTree(self.BehaviorTree)
    --function Frogququ:ReceiveBeginPlay()
    self.ShootPopo:Add(self, self.shoot)
end


--function Frogququ:UserConstructionScript()
--end
--[[
Frogququ.BehaviorTree = LoadObject("/Game/AI/BT_FROG")


]]--

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
