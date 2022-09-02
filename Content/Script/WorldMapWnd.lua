--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"
local Screen = require "Screen"
WorldMapWnd = Class()

WorldMapWnd.MapType = {
    ["NoVis"] = 1,
    ["Vis"] = 2,
    ["Lulu"] = 3,
    ["Boss"] = 4,
}
function WorldMapWnd:DrawMapBlock(x, y, divX, divY, type)
    if self.divX == nil and divX ~= nil then self.divX = divX end
    if self.divY == nil and divY ~= nil then self.divY = divY end
    if divX == nil then divX = self.divX end
    if divY == nil then divY = self.divY end

    if self.BlockWnd == nil then self.BlockWnd = {} end
    if self.BlockWnd[x] == nil then self.BlockWnd[x] = {} end

    local widget_class
    if type == nil or type == WorldMapWnd.MapType.NoVis then
        widget_class = UE.UClass.Load("/Game/WorldMapSystem/W_NoVisBlock.W_NoVisBlock_C")
    elseif type == WorldMapWnd.MapType.Vis then
        widget_class = UE.UClass.Load("/Game/WorldMapSystem/W_VisBlock.W_VisBlock_C")
    elseif type == WorldMapWnd.MapType.Lulu then
        widget_class = UE.UClass.Load("/Game/WorldMapSystem/W_luluBlock.W_luluBlock_C")
    elseif type == WorldMapWnd.MapType.Boss then
        widget_class = UE.UClass.Load("/Game/WorldMapSystem/W_BearBlock.W_BearBlock_C")
    end
    
    local flag = nil
    
    if self.BlockWnd[self.LuluX][self.LuluY] ~= nil and type == WorldMapWnd.MapType.Lulu then 
        local vis_class = UE.UClass.Load("/Game/WorldMapSystem/W_VisBlock.W_VisBlock_C")
        self.BlockWnd[self.LuluX][self.LuluY]:RemoveFromParent()
        self.BlockWnd[self.LuluX][self.LuluY] = self:DrawBlock(self.LuluX, self.LuluY, divX, divY, vis_class)
        self.LuluX = x
        self.LuluY = y
    end
    if type == WorldMapWnd.MapType.Lulu then 
        self.LuluX = x
        self.LuluY = y
    end
    
    if x == self.BossX and y == self.BossY  then 
        return
    end

    if self.BlockWnd[x][y] ~= nil then 
        self.BlockWnd[x][y]:RemoveFromParent()
    end
    local image = self:DrawBlock(x, y, divX, divY, widget_class)
    self.BlockWnd[x][y] = image

    return image
end

function WorldMapWnd:DrawBlock(x, y, divX, divY, widget_class)
    if self.divX == nil and divX ~= nil then self.divX = divX end
    if self.divY == nil and divY ~= nil then self.divY = divY end
    if divX == nil then divX = self.divX end
    if divY == nil then divY = self.divY end

    local parent = self.MapCanvas
    local image = NewObject(widget_class)
    local parentsize = parent.Slot:GetSize()
    local Xsize = parentsize.X / divX
    local Ysize = parentsize.Y / divY
    local anchors = UE.FAnchors(0.0)
    anchors.Minimum = UE.FVector2D(0.0, 1.0)
    anchors.Maximum = UE.FVector2D(0.0, 1.0)

    parent:AddChild(image)
    image.Slot:SetZOrder(1)
    image.Slot:SetAnchors(anchors)
    image.Slot:SetSize(UE.FVector2D(Xsize, Ysize))
    image.Slot:SetAlignment(UE.FVector2D(0.0, 1.0))
    image.Slot:SetPosition(UE.FVector2D(Xsize * (x - 1), - Ysize * (y - 1)))

    return image
end

function WorldMapWnd:InitCharacterBlock(divX, divY)
    if self.divX == nil and divX ~= nil then self.divX = divX end
    if self.divY == nil and divY ~= nil then self.divY = divY end

    local widget_class = UE.UClass.Load("/Game/WorldMapSystem/W_WorldMapCharacter.W_WorldMapCharacter_C")
    local CharacterBlock = NewObject(widget_class)
    self.m_CharacterBlock = CharacterBlock
    local parent = self.MapCanvas
    local parentsize = parent.Slot:GetSize()
    
    local Xsize = CharacterBlock.SizeRate * parentsize.X / self.divX
    local Ysize = CharacterBlock.SizeRate * parentsize.Y / self.divY
    local anchors = UE.FAnchors(0.0)
    anchors.Minimum = UE.FVector2D(0.0, 1.0)
    anchors.Maximum = UE.FVector2D(0.0, 1.0)

    parent:AddChild(CharacterBlock)
    CharacterBlock.Slot:SetZOrder(10)
    CharacterBlock.Slot:SetAnchors(anchors)
    CharacterBlock.Slot:SetSize(UE.FVector2D(Xsize, Ysize))
    CharacterBlock.Slot:SetAlignment(UE.FVector2D(0.5, 0.5))
    CharacterBlock.Slot:SetPosition(UE.FVector2D(0.0, 0.0))
end

function WorldMapWnd:SetCharacterPosition(PlayerX, PlayerY, MapX, MapY)
    if self.m_CharacterBlock == nil then return end 
    local parent = self.MapCanvas
    local parentsize = parent.Slot:GetSize()
    self.m_CharacterBlock.Slot:SetPosition(UE.FVector2D(parentsize.Y * PlayerY / MapY, -parentsize.X * PlayerX / MapX))
end

function WorldMapWnd:SetCharacterRotator(Yaw)
    if self.m_CharacterBlock == nil then return end 
    self.m_CharacterBlock:SetRenderTransformAngle(Yaw)
end

function WorldMapWnd:ClearMap()
    self.MapCanvas:ClearChildren()
end


function WorldMapWnd:Initialize(Initializer)
    self.BlockWnd = { [-1] = {},}
    self.LuluX = -1
    self.LuluY = -1
    self.BossX = -1
    self.BossY = -1
end

--function WorldMapWnd:PreConstruct(IsDesignTime)
--end

-- function WorldMapWnd:Construct()
-- end

-- function WorldMapWnd:Tick(MyGeometry, InDeltaTime)  
-- end

return WorldMapWnd
