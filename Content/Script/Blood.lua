require "UnLua"

local FVector = UE.FVector
local FLinearColor = UE.FLinearColor

local M = Class()

function M:ReceiveBeginPlay()
    local x = math.random(-10000, 10000)
    local y = math.random(-10000, 10000)
    local z = math.random(30000, 40000)

    local s = 0.1

    self.Sphere:CreateDynamicMaterialInstance():SetVectorParameterValue("Color", FLinearColor(1.0, 0.0, 0.0))
    self.Sphere:SetWorldScale3D(FVector(s, s, s))
    self.Sphere:AddImpulse(FVector(x, y, z))

    self.TimerHandle = UE.UKismetSystemLibrary.K2_SetTimerDelegate({self, M.LifeEnd}, 1.0, false)
end

function M:LifeEnd()
    UE.UKismetSystemLibrary.K2_ClearAndInvalidateTimerHandle(self, self.TimerHandle)
    self.TimerHandle = nil
    self:K2_DestroyActor()
end

return M