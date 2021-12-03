module Constants
    module THEME
        module DEFAULT
            def DEFAULT.colored_tile(pastel_instance, tile_type)
                character = '#'
                type_color_map = {
                    Constants::TILE_TYPES[:NONE] => pastel_instance.black(character),
                    Constants::TILE_TYPES[:WATER] => pastel_instance.blue(character),
                    Constants::TILE_TYPES[:WATER_BORDER] => pastel_instance.bright_blue(character),
                    Constants::TILE_TYPES[:FOREST] => pastel_instance.green(character),
                    Constants::TILE_TYPES[:MOUNTAIN] => pastel_instance.white(character),
                    Constants::TILE_TYPES[:PLAIN] => pastel_instance.bright_yellow(character),
                }

                type_color_map[tile_type]
            end
        end
    end
end