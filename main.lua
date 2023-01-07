if not REPENTANCE then return end

GUARANTEED_START_FOR_GREED_MODE = RegisterMod("Guaranteed Start For Greed Mode", 1)

local mod = GUARANTEED_START_FOR_GREED_MODE

mod.config = require([[.\config]])
mod.state = {
    hasPlayerVisited = {
        silver = false,
        treasure = false
    }
}

local json = require("json")

---@alias Mod table

---@param self Mod
---@param itemPoolType ItemPoolType
---@param _ any
---@param seed integer
---@return CollectibleType|nil
function mod:MC_PRE_GET_COLLECTIBLE(itemPoolType, _, seed)
    if not self.state.hasPlayerVisited.silver and Game():GetRoom():GetType() == RoomType.ROOM_TREASURE and itemPoolType == ItemPoolType.POOL_GREED_BOSS then
        self.state.hasPlayerVisited.silver = true
    elseif not self.state.hasPlayerVisited.treasure and Game():GetRoom():GetType() == RoomType.ROOM_TREASURE and itemPoolType == ItemPoolType.POOL_GREED_TREASURE then
        self.state.hasPlayerVisited.treasure = true
    else
        return
    end

    return self:rollItem(itemPoolType, seed)
end

---@param self Mod
---@param itemPoolType ItemPoolType
---@param seed integer
---@return CollectibleType|nil
function mod:rollItem(itemPoolType, seed)
    local rng = RNG()
    rng:SetSeed(seed, 0)

    if self.config.useItemList then
        return self.config.rollableItems[rng:RandomInt(#self.config.rollableItems) + 1]
    elseif self.config.useTreasureRoomPoolForSilverRoom and itemPoolType == ItemPoolType.POOL_GREED_BOSS then
        itemPoolType = ItemPoolType.POOL_GREED_TREASURE
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
---@param continued boolean
function mod:init(continued)
    if self:HasData() then
        self.state = json.decode(self:LoadData())
    end

    if not continued then
        self.state.hasPlayerVisited = {
            silver = false,
            treasure = false
        }
    end

    if not self.initialized then
        self.initialized = true

        self:AddCallback(ModCallbacks.MC_PRE_GET_COLLECTIBLE, self.MC_PRE_GET_COLLECTIBLE)
    end
end

---@param self Mod
---@param _ any
function mod:save(_)
    self:SaveData(json.encode(self.state))
end

mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.init)
mod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, mod.save)