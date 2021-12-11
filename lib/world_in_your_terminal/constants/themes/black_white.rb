module Constants
    module THEME
        module BLACKWHITE
            def BLACKWHITE.colored_tile(pastel_instance, tile_type)
                BLACKWHITE.tile_map(pastel_instance)[tile_type][:character]
            end

            def BLACKWHITE.tile_map(pastel_instance)
                {
                    Constants::TILE_TYPES[:NONE] => {
                        character: ' ',
                    },
                    Constants::TILE_TYPES[:WATER] => {
                        character: ' ',
                    },
                    Constants::TILE_TYPES[:FOREST] => {
                        character: 't',
                    },
                    Constants::TILE_TYPES[:MOUNTAIN] => {
                        character: 'M',
                    },
                    Constants::TILE_TYPES[:PLAIN] => {
                        character: '_',
                    },
                }
            end
        end
    end
end