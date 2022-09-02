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
    self.Life = 3
    self.Enemeytotol = 2
    self.NowBlock = nil
    self.BlockMatrix = {}
    if self.MainLength == nil then
        self.MainLength = 3
    end
    if self.BranchSum == nil then
        self.BranchSum = 1
    end
    if self.bIsVisitor == nil then
        self.bIsVisitor = true
    end
    self.HaveEnd = false
end

--function luShootGameMode:UserConstructionScript()
--end

function luShootGameMode:ReceiveBeginPlay()
    local widget_class = UE.UClass.Load("/Game/BluePrint/ShootPlayingUI.ShootPlayingUI_C")
    self.MainUI = NewObject(widget_class, self)
    self.MainUI:AddToViewport()

    self.MainUI.PowerText:SetText(self.Life)
    self.MainUI.EnemyText:SetText(self.Enemeytotol)
    
    widget_class = UE.UClass.Load("/Game/BluePrint/EndWnd.EndWnd_C")
    self.EndUI = NewObject(widget_class, self)

    --self:ShowBoss()
end

function luShootGameMode:DecreseEnemy()
    self.Enemeytotol = self.Enemeytotol - 1
    self.MainUI.EnemyText:SetText(self.Enemeytotol)
    if self.NowBlock and self.Enemeytotol == 0 then
        self.NowBlock:OpenAllWall() 
        self.NowBlock.EnemyTotal = 0
    end
end

function luShootGameMode:Damaged(damage)
    self.Life = self.Life - damage
    self.MainUI.PowerText:SetText(self.Life)
    if self.Life <= 0 then 
        self:Lose()
    end
end

function luShootGameMode:SetNowBlock(BlockActor)
    self.NowBlock = BlockActor
    self.Enemeytotol = self.NowBlock.EnemyTotal
    self.MainUI.EnemyText:SetText(self.Enemeytotol)
end

function luShootGameMode:SetBossLife(Life, MaxLife)
    self.MainUI.BossProgress:SetPercent(Life / MaxLife)
    if Life == 0 then 
        self.MainUI:PlayAnimation(self.MainUI.Animation_Hide)
        self:Win()
    end
end

function luShootGameMode:ShowBoss()
    self:SetBossLife(1, 1)
    self.MainUI:PlayAnimation(self.MainUI.Animation_Show)
end

function luShootGameMode:GetReward(type)
    if type == 1 then 
        self.Life = self.Life + 1
        self.MainUI.PowerText:SetText(self.Life)
    end
end

function luShootGameMode:Win()
    if self.HaveEnd then return end
    self.HaveEnd = true
    self.EndUI:AddToViewport()
    self.EndUI.Win_Switch:SetActiveWidgetIndex(0)
    self.EndUI.Button_Restart.OnClicked:Add(self, self.OnButtonRestart)
    self.EndUI.Button_Exit.OnClicked:Add(self, self.OnButtonExit)

    local PlayerController = UE.UGameplayStatics.GetPlayerController(self, 0)
    PlayerController.bShowMouseCursor = true
    UE.UGameplayStatics.SetGamePaused(self, true)
end

function luShootGameMode:Lose()
    if self.HaveEnd then return end
    self.HaveEnd = true
    self.EndUI:AddToViewport()
    self.EndUI.Win_Switch:SetActiveWidgetIndex(1)
    self.EndUI.Button_Restart.OnClicked:Add(self, self.OnButtonRestart)
    self.EndUI.Button_Exit.OnClicked:Add(self, self.OnButtonExit)

    local PlayerController = UE.UGameplayStatics.GetPlayerController(self, 0)
    PlayerController.bShowMouseCursor = true
    UE.UGameplayStatics.SetGamePaused(self, true)
end
local ModeClass = UE.UClass.Load("/Game/BluePrint/BP_bigluluShootGameMode.BP_bigluluShootGameMode_C")

function luShootGameMode:OnButtonRestart()
    UE.UKismetSystemLibrary.ExecuteConsoleCommand(self, "RestartLevel")
end

function luShootGameMode:OnButtonExit()
    UE.UKismetSystemLibrary.ExecuteConsoleCommand(self, "exit")
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
