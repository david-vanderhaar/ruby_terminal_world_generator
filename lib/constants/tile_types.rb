module Constants
    TILE_TYPES = {
        NONE: 0,
        FOREST: 1,
        MOUNTAIN: 2,
        PLAIN: 3,
        WATER: 4,
        BACKGROUND: 5,
    }

    def TILE_TYPES.sample
        TILE_TYPES[TILE_TYPES.keys.select{|key| ![:NONE, :BACKGROUND].include?(key) }.sample]
    end
end