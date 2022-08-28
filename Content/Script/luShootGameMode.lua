--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"

local luShootGameMode = Class()

function luShootGameMode:Initialize(Initializer)
    self.Life = 5
    self.Enemeytotol = 2
end

--function luShootGameMode:UserConstructionScript()
--end

function luShootGameMode:ReceiveBeginPlay()
    local widget_class = UE.UClass.Load("/Game/BluePrint/ShootPlayingUI.ShootPlayingUI_C")
    self.MainUI = NewObject(widget_class, self)
    self.MainUI:AddToViewport()

    self.MainUI.PowerText:SetText(self.Life)
    self.MainUI.EnemyText:SetText(self.Enemeytotol)
    
    self:ShowBoss()
end

function luShootGameMode:DecreseEnemy()
    self.Enemeytotol = self.Enemeytotol - 1
    self.MainUI.EnemyText:SetText(self.Enemeytotol)
end

function luShootGameMode:SetBossLife(Life, MaxLife)
    self.MainUI.BossProgress:SetPercent(Life / MaxLife)
    if Life == 0 then 
        self.MainUI:PlayAnimation(self.MainUI.Animation_Hide)
    end
end

function luShootGameMode:ShowBoss()
    self:SetBossLife(1, 1)
    self.MainUI:PlayAnimation(self.MainUI.Animation_Show)
end

--function luShootGameMode:ReceiveEndPlay()
--end

-- function luShootGameMode:ReceiveTick(DeltaSeconds)
-- end

--function luShootGameMode:ReceiveAnyDamage(Damage, DamageType, InstigatedBy, DamageCauser)
--end

--function luShootGameMode:ReceiveActorBeginOverlap(OtherActor)
--end

--function luShootGameMode:ReceiveActorEndOverlap(OtherActor)
--end

return luShootGameMode
