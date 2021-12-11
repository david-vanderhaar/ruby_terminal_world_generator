module Constants
    module THEME
        module DEFAULT
            def DEFAULT.colored_tile(pastel_instance, tile_type)
                character = DEFAULT.tile_map(pastel_instance)[tile_type][:character]
                color_method = DEFAULT.tile_map(pastel_instance)[tile_type][:color_method]

                color_method.call(character)
            end

            def DEFAULT.tile_map(pastel_instance)
                {
                    Constants::TILE_TYPES[:NONE] => {
                        character: ' ',
                        color_method: pastel_instance.black.method(:on_black),
                    },
                    Constants::TILE_TYPES[:WATER] => {
                        character: '■',
                        color_method: pastel_instance.blue.method(:on_black),
                    },
                    Constants::TILE_TYPES[:FOREST] => {
                        character: '■',
                        color_method: pastel_instance.green.method(:on_black),
                    },
                    Constants::TILE_TYPES[:MOUNTAIN] => {
                        character: '■',
                        color_method: pastel_instance.bright_white.method(:on_black),
                    },
                    Constants::TILE_TYPES[:PLAIN] => {
                        character: '■',
                        color_method: pastel_instance.bright_yellow.method(:on_black),
                    },
                }
            end
        end
    end
end