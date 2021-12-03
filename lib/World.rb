require 'tty-table'
require 'tty-box'
require_relative './constants/tile_types.rb'

class World
    def initialize(theme)
        @theme = theme
        @matrix = initialize_matrix
        @pastel = pastel = Pastel.new
        @zoom_history = [@matrix]
        @zoom_level = 0
        @max_zoom_level = 4
    end

    def matrix
        @zoom_history[@zoom_level]
    end

    def colored_matrix
        matrix.map{ |row|
            row.map{ |tile|
                @theme.colored_tile(@pastel, tile)
            }
        }
    end

    def initialize_matrix
        default_matrix
    end

    def default_matrix
        # [
        #     [Constants::TILE_TYPES[:WATER], Constants::TILE_TYPES[:WATER], Constants::TILE_TYPES[:WATER], Constants::TILE_TYPES[:WATER]],
        #     [Constants::TILE_TYPES[:WATER], Constants::TILE_TYPES[:WATER], Constants::TILE_TYPES[:WATER], Constants::TILE_TYPES[:WATER]],
        #     [Constants::TILE_TYPES[:WATER], Constants::TILE_TYPES[:WATER], Constants::TILE_TYPES[:WATER], Constants::TILE_TYPES[:WATER]],
        #     [Constants::TILE_TYPES[:MOUNTAIN], Constants::TILE_TYPES[:WATER], Constants::TILE_TYPES[:WATER], Constants::TILE_TYPES[:WATER]],
        # ]
        [
            [Constants::TILE_TYPES[:WATER], Constants::TILE_TYPES[:WATER], Constants::TILE_TYPES[:WATER], Constants::TILE_TYPES[:PLAIN]],
            [Constants::TILE_TYPES[:PLAIN], Constants::TILE_TYPES[:PLAIN], Constants::TILE_TYPES[:WATER], Constants::TILE_TYPES[:WATER]],
            [Constants::TILE_TYPES[:FOREST], Constants::TILE_TYPES[:PLAIN], Constants::TILE_TYPES[:WATER], Constants::TILE_TYPES[:WATER]],
            [Constants::TILE_TYPES[:MOUNTAIN], Constants::TILE_TYPES[:FOREST], Constants::TILE_TYPES[:PLAIN], Constants::TILE_TYPES[:WATER]],
        ]
    end

    def draw(tile_size)
        puts render_framed_map(tile_size)
        # puts render_framed_table_map(tile_size)
        # puts render_map(tile_size)
        # puts render_table_map(tile_size)
    end

    def render_map(tile_size)
        colored_matrix.map.with_index { |row, y|
            row.map.with_index { |tile, x|
                tile
            }.join(' ' * tile_size)
        }.join("\n" * tile_size)
    end

    def render_table_map(tile_size)
        table = TTY::Table.new({rows: colored_matrix})

        table.render(
            :basic,
            alignments: [:center],
            padding: tile_size - 1
        )
    end

    def render_framed_map(tile_size)
        map = render_map(tile_size)

        render_frame_around_map(map)
    end


    def render_framed_table_map(tile_size)
        map = render_table_map(tile_size)

        render_frame_around_map(map)
    end

    def render_frame_around_map(map)
        zoom_information = " Zoom: #{@zoom_level} "

        framed_map = TTY::Box.frame(
            align: :center,
            title: {bottom_right: zoom_information},
            border: :thick
        ) { map }

        framed_map
    end

    def current_matrix_width
        matrix.length
    end

    def next_matrix_width
        (current_matrix_width * 2) - 1
    end

    def zoom_in
        generate_new_zoom if @zoom_level == @zoom_history.length - 1
        increment_zoom_level
    end

    def generate_new_zoom
        zoom_length = next_matrix_width
        unfilled_new_matrix = []
        matrix.each_with_index{ |row, i|
            unfilled_new_matrix << expand_row(zoom_length, matrix[i])
            if unfilled_new_matrix.length < zoom_length
                unfilled_new_matrix << add_row(zoom_length)
            end
          }
        
        filled_new_matrix = fill_none_tiles(unfilled_new_matrix)
        @matrix = filled_new_matrix

        @zoom_history << filled_new_matrix
    end

    def zoom_out
        decrement_zoom_level
    end

    def increment_zoom_level
        @zoom_level = (@zoom_level + 1).clamp(0, @max_zoom_level)
    end

    def decrement_zoom_level
        @zoom_level = (@zoom_level - 1).clamp(0, @max_zoom_level)
    end

    def expand_row(zoom_length, current_row)
        new_row = []
        current_row.each_with_index{ |row, i|
          new_row << current_row[i]
          if new_row.length < zoom_length
            new_row << Constants::TILE_TYPES[:NONE]
          end
        }
        
        new_row
    end

    def add_row(zoom_length)
        return Array.new(zoom_length, Constants::TILE_TYPES[:NONE])
    end

    def fill_none_tiles(unfilled_matrix)
        new_matrix = []
        unfilled_matrix.each_with_index { |row, y|
            new_row = []
            row.each_with_index { |tile, x|
                new_tile = tile
                if tile == Constants::TILE_TYPES[:NONE]
                    neighboring_tiles = get_tiles_in_neighboring_positions(x, y, unfilled_matrix);
                    random_neighbor_tile = neighboring_tiles.select{|tile| ![Constants::TILE_TYPES[:NONE]].include?(tile) }.sample
                    new_tile = random_neighbor_tile != Constants::TILE_TYPES[:NONE] ? random_neighbor_tile : Constants::TILE_TYPES.sample
                end

                new_row << new_tile
            }
            
            new_matrix << new_row
        }

        new_matrix
    end

    def get_tiles_in_neighboring_positions(x, y, current_matrix)
        relative_neighboring_positions = [
            {x: -1, y: 0},
            {x: 1, y: 0},
            {x: 0, y: -1},
            {x: 0, y: 1},
            {x: -1, y: -1},
            {x: 1, y: 1},
            {x: 1, y: -1},
            {x: -1, y: 1},
        ]
      
        neighboring_tiles = []
        relative_neighboring_positions.map { |pos|
            tile = get_tile_at_position(x + pos[:x], y + pos[:y], current_matrix)
            neighboring_tiles << tile if tile
        }

        neighboring_tiles
    end

    def get_tile_at_position(x, y, current_matrix)
        begin
            return current_matrix[y][x]
        rescue => exception
            return false
        end
    end
end