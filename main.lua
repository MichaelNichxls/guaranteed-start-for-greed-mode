local mod = RegisterMod("Guaranteed Start For Greed Mode", 1)
local json = require("json")
-- local game = Game()

-- Global state variable

mod.config = {
    -- Config Options Here

    -- Set to 'true' to use an item list instead of filtering by quality
    useItemList = false,

    -- List of items you can find if the feature is on
    -- Meant to be customized, default list is taken from racing+'s starting item options
    rollableItems = {
        CollectibleType.COLLECTIBLE_MOMS_KNIFE,
        CollectibleType.COLLECTIBLE_IPECAC,
        CollectibleType.COLLECTIBLE_TECH_X,
        CollectibleType.COLLECTIBLE_CRICKETS_HEAD,
        CollectibleType.COLLECTIBLE_MAGIC_MUSHROOM,
        CollectibleType.COLLECTIBLE_DR_FETUS,
        CollectibleType.COLLECTIBLE_TECHNOLOGY,
        CollectibleType.COLLECTIBLE_POLYPHEMUS,
        CollectibleType.COLLECTIBLE_TECH_5,
        CollectibleType.COLLECTIBLE_20_20,
        CollectibleType.COLLECTIBLE_PROPTOSIS,
        CollectibleType.COLLECTIBLE_JUDAS_SHADOW,
        CollectibleType.COLLECTIBLE_BRIMSTONE,
        CollectibleType.COLLECTIBLE_MAW_OF_THE_VOID,
        CollectibleType.COLLECTIBLE_INCUBUS,
        CollectibleType.COLLECTIBLE_SACRED_HEART,
        CollectibleType.COLLECTIBLE_GODHEAD,
        CollectibleType.COLLECTIBLE_CROWN_OF_LIGHT,
        CollectibleType.COLLECTIBLE_SAD_ONION,
        CollectibleType.COLLECTIBLE_CRICKETS_BODY,
        CollectibleType.COLLECTIBLE_MONSTROS_LUNG,
        CollectibleType.COLLECTIBLE_DEATHS_TOUCH,
        CollectibleType.COLLECTIBLE_DEAD_EYE,
        CollectibleType.COLLECTIBLE_APPLE,
        CollectibleType.COLLECTIBLE_JACOBS_LADDER,
        -- etc.
    }

    -- Make discount configurable
}

mod.state = {
    hasPlayerVisited = {
        -- shop = false,
        silver = false,
        treasure = false
    }
}

---@alias Mod table

---@param self Mod
---@param itemPoolType integer
---@param seed integer
---@return CollectibleType|nil
function mod:rollItem(itemPoolType, seed)
    local rng = RNG()
    rng:SetSeed(seed, 0)

    if self.config.useItemList then
        return self.config.rollableItems[rng:RandomInt(#self.config.rollableItems) + 1]
    end

    for _ = 1, 100, 1 do
        local nextItem = Game():GetItemPool():GetCollectible(itemPoolType, false, seed)
        local quality = Isaac.GetItemConfig():GetCollectible(nextItem).Quality
        
        if quality >= 3 then
            Isaac.DebugString("Rolled item: " .. nextItem)
            return nextItem
        end

        seed = rng:Next()
    end
end

---@param self Mod
---@param itemPoolType integer
---@param _ any
---@param seed integer
---@return CollectibleType|nil
function mod:onPreGetCollectible(itemPoolType, _, seed)
    --[[ if not self.state.hasPlayerVisited.shop and Game():GetRoom():GetType() == RoomType.ROOM_SHOP and itemPoolType == ItemPoolType.POOL_GREED_SHOP then
        self.state.hasPlayerVisited.shop = true
    elseif ]] if not self.state.hasPlayerVisited.silver and Game():GetRoom():GetType() == RoomType.ROOM_TREASURE and itemPoolType == ItemPoolType.POOL_GREED_BOSS then
        self.state.hasPlayerVisited.silver = true
    elseif not self.state.hasPlayerVisited.treasure and Game():GetRoom():GetType() == RoomType.ROOM_TREASURE and itemPoolType == ItemPoolType.POOL_GREED_TREASURE then
        self.state.hasPlayerVisited.treasure = true
    else
        return
    end

    return self:rollItem(itemPoolType, seed)
end

--[[
function mod:onPostUpdate()
    if Game():GetRoom():GetType() ~= RoomType.ROOM_SHOP then return end

    for _, entity in pairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)) do
        local pickup = entity:ToPickup()

        if pickup.Price > 7 and pickup.Price <= 15 then
            pickup.Price = 10
        end
    end
end
]]

---@param self Mod
---@param continue boolean
function mod:init(continue)
    if self:HasData() then
        self.state = json.decode(self:LoadData())
    end

    if not continue then
        self.state.hasPlayerVisited = {
            -- shop = false,
            silver = false,
            treasure = false
        }
    end

    -- Game():IsGreedMode()
    if not self.active then
        self.active = true

        self:AddCallback(ModCallbacks.MC_PRE_GET_COLLECTIBLE, self.onPreGetCollectible)
        -- self:AddCallback(ModCallbacks.MC_POST_UPDATE, self.onPostUpdate)

        -- self:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, function(pickup)
        --     if pickup:IsShopItem() then
        --         mod.state.hasPlayerShopped = true
        --     end
        -- end)
    end
end

---@param self Mod
---@param _ any
function mod:save(_)
    self:SaveData(json.encode(self.state))
end

mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.init)
mod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, mod.save)