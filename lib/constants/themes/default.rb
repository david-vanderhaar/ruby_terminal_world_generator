module Constants
    module THEME
        module DEFAULT
            def DEFAULT.colored_tile(pastel_instance, tile_type)
                character = DEFAULT.character_map[tile_type]

                type_color_map = {
                    Constants::TILE_TYPES[:BACKGROUND] => pastel_instance.black.on_black(character),
                    Constants::TILE_TYPES[:NONE] => pastel_instance.black.on_black(character),
                    Constants::TILE_TYPES[:WATER] => pastel_instance.blue.on_black(character),
                    Constants::TILE_TYPES[:FOREST] => pastel_instance.green.on_black(character),
                    Constants::TILE_TYPES[:MOUNTAIN] => pastel_instance.bright_white.on_black(character),
                    Constants::TILE_TYPES[:PLAIN] => pastel_instance.bright_yellow.on_black(character),
                }

                type_color_map[tile_type]
            end

            def DEFAULT.character_map
                {
                    Constants::TILE_TYPES[:BACKGROUND] => ' ',
                    Constants::TILE_TYPES[:NONE] => ' ',
                    Constants::TILE_TYPES[:WATER] => '■',
                    Constants::TILE_TYPES[:FOREST] => '■',
                    Constants::TILE_TYPES[:MOUNTAIN] => '■',
                    Constants::TILE_TYPES[:PLAIN] => '■',
                }
            end
        end
    end
end