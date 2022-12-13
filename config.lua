---Mod configuration options.
local config = {
    ---Set to 'true' to use an item list instead of filtering by quality.
    useItemList = false,

    ---List of items you can find if 'useItemList' is 'true'.
    ---Meant to be customized; the default list is taken from racing+'s starting item options.
    ---@type CollectibleType[]
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
    },

    ---Set to 'true' to roll for items from the greed treasure room item pool in a silver treasure room instead.
    ---Only works if 'useItemList' is 'false'.
    useTreasureRoomPoolForSilverRoom = true
}

return config