--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"
local FLinearColor = UE.FLinearColor

local M = Class()

local FireProgress = Class()

function FireProgress:SetProgress(NowTime, TotolTime, FireTime)
    self.ProgressBar_0:SetPercent(NowTime / TotolTime)
    self.ProgressBar_0:SetFillColorAndOpacity(NowTime > FireTime and FLinearColor(1.0, 0.0, 0.5) or FLinearColor(0.0, 0.5, 1.0))
end
--function FireProgress:Initialize(Initializer)
--end

--function FireProgress:PreConstruct(IsDesignTime)
--end

-- function FireProgress:Construct()
-- end

--function FireProgress:Tick(MyGeometry, InDeltaTime)
--end

return FireProgress
