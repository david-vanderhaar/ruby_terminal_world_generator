require 'tty-table'
require 'tty-box'
require_relative './constants/tile_types.rb'
require_relative './constants/themes/black_white.rb'
require_relative './generate_name.rb'
require_relative './generate_matrix.rb'


class Point
    attr_reader :x, :y, :z

    def initialize(x, y, z)
        @x = x
        @y = y
        @z = z
    end

    def to_s
        "#{@x},#{@y},#{@z}"
    end

end

class World
    attr_reader :name

    def initialize(theme)
        @theme = theme
        @pastel = Pastel.new
        @max_x = 4
        @max_y = 4
        @max_z = 4
        regenerate
    end

    def regenerate
        @name = initialize_name
        @matrix = initialize_matrix
        @current_position = Point.new(0, 0, 0)

        @matrix_map = {
            @current_position.to_s => @matrix
        }
    end

    def matrix
        @matrix_map[@current_position.to_s]
    end

    def themed_matrix(theme)
        matrix.map{ |row|
            row.map{ |tile|
                theme.colored_tile(@pastel, tile)
            }
        }
    end
 
    def colored_matrix
        themed_matrix(@theme)
    end

    def initialize_matrix
        GenerateMatrix.new.perlin_matrix(4)
    end

    def initialize_name
        GenerateName.new.world
    end

    def set_name(name)
        @name = name
    end

    def cycle_theme
        available_themes = Constants::THEME.constants.map {|theme| Constants::THEME.const_get(theme)}

        current_theme_index = available_themes.index(@theme)
        next_theme_index = (current_theme_index + 1) % available_themes.length

        set_theme(available_themes[next_theme_index])
    end

    def set_theme(theme)
        @theme = theme
    end

    def draw(tile_size)
        # puts render_framed_map(tile_size)
        # puts render_framed_table_map(tile_size)
        # puts render_map(tile_size)
        puts render_map_with_info(tile_size)
        # puts render_table_map(tile_size)
    end

    def render_map_with_info(tile_size)
        [
            render_map(tile_size),
            world_name_display,
            zoom_level_display,
            coordinates_display,
        ].join("\n")
    end

    def render_matrix(matrix_to_render, theme, tile_size)
        matrix_to_render.map.with_index { |row, y|
            row.map.with_index { |tile, x|
                tile
            }.join(
                theme.colored_tile(
                    @pastel, 
                    Constants::TILE_TYPES[:NONE]
                ) * tile_size
            )
        }.join("\n" * tile_size)
    end

    def render_map_as_text(tile_size)
        theme = Constants::THEME::BLACKWHITE
        new_matrix = themed_matrix(theme)
        
        render_matrix(new_matrix, theme, tile_size)
    end

    def render_map(tile_size)
        render_matrix(colored_matrix, @theme, tile_size)
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
        framed_map = TTY::Box.frame(
            align: :center,
            title: {
                bottom_left: coordinates_display,
                bottom_right: zoom_level_display
            },
            border: :thick
        ) { map }

        framed_map
    end

    def world_name_display
        "You are exploring #{@pastel.italic(@name)}"
    end

    def zoom_level_display
        "Zoom: #{@current_position.z}"
    end

    def coordinates_display
        "x: #{@current_position.x}, y: #{@current_position.y}"
    end

    def current_matrix_width
        matrix.length
    end

    def next_matrix_width
        (current_matrix_width * 2) - 1
    end

    def matrix_exists_in_position(position)
        @matrix_map.keys.include?(position.to_s)
    end

    def zoom_in
        new_position = increment_z_level(@current_position)
        if !matrix_exists_in_position(new_position)
            generate_new_zoomed_in_map(new_position)
        end

        @current_position = new_position
    end

    def zoom_out
        new_position = decrement_z_level(@current_position)
        if !matrix_exists_in_position(new_position)
            generate_new_zoomed_out_map(new_position)
        end

        @current_position = new_position
    end

    def scroll_right
        new_position = increment_x_level(@current_position)
        if !matrix_exists_in_position(new_position)
            generate_new_scrolled_right_map(new_position)
        end

        @current_position = new_position
    end

    def scroll_left
        new_position = decrement_x_level(@current_position)
        if !matrix_exists_in_position(new_position)
            generate_new_scrolled_left_map(new_position)
        end

        @current_position = new_position
    end
    
    def scroll_up
        new_position = increment_y_level(@current_position)
        if !matrix_exists_in_position(new_position)
            generate_new_scrolled_up_map(new_position)
        end

        @current_position = new_position
    end
    
    def scroll_down
        new_position = decrement_y_level(@current_position)
        if !matrix_exists_in_position(new_position)
            generate_new_scrolled_down_map(new_position)
        end

        @current_position = new_position
    end

    def increment_x_level(position)
        add_to_x_level(1, position)
    end

    def decrement_x_level(position)
        add_to_x_level(-1, position)
    end

    def increment_y_level(position)
        add_to_y_level(1, position)
    end

    def decrement_y_level(position)
        add_to_y_level(-1, position)
    end

    def increment_z_level(position)
        add_to_z_level(1, position)
    end

    def decrement_z_level(position)
        add_to_z_level(-1, position)
    end

    def add_to_x_level(amount, position)
        new_x = (position.x + amount).clamp(-@max_x, @max_x)
        
        Point.new(
            new_x,
            position.y,
            position.z,
        )
    end

    def add_to_y_level(amount, position)
        new_y = (position.y + amount).clamp(-@max_y, @max_y)
        
        Point.new(
            position.x,
            new_y,
            position.z,
        )
    end

    def add_to_z_level(amount, position)
        new_z = (position.z + amount).clamp(0, @max_z)
        
        Point.new(
            position.x,
            position.y,
            new_z,
        )
    end

    def generate_new_zoomed_in_map(position)
        zoom_length = next_matrix_width
        unfilled_new_matrix = []
        matrix.each_with_index{ |row, i|
            unfilled_new_matrix << expanded_row(zoom_length, matrix[i])
            if unfilled_new_matrix.length < zoom_length
                unfilled_new_matrix << new_row(zoom_length)
            end
          }
        
        filled_new_matrix = fill_none_tiles(unfilled_new_matrix)

        @matrix_map[position.to_s] = filled_new_matrix
    end
    
    def generate_new_zoomed_out_map(position)
        new_matrix = []
        matrix.each_with_index{ |row, i|
            if i.even?
                new_row = []
                matrix[i].each_with_index{ |tile, j|
                    new_row << tile if j.even?
                }
                new_matrix << new_row
            end
          }
        
        @matrix_map[position.to_s] = new_matrix
    end

    def generate_new_scrolled_right_map(position)
        unfilled_new_matrix = matrix.dup.map.with_index{ |row, y|
            new_row = row.dup
            new_row.shift
            new_row << Constants::TILE_TYPES[:NONE]
            
            new_row
        }

        filled_new_matrix = fill_none_tiles(unfilled_new_matrix)

        @matrix_map[position.to_s] = filled_new_matrix
    end
    
    def generate_new_scrolled_left_map(position)
        unfilled_new_matrix = matrix.dup.map.with_index{ |row, y|
            new_row = row.dup
            new_row.pop
            new_row.unshift(Constants::TILE_TYPES[:NONE])
            
            new_row
        }

        filled_new_matrix = fill_none_tiles(unfilled_new_matrix)

        @matrix_map[position.to_s] = filled_new_matrix
    end

    def generate_new_scrolled_up_map(position)
        unfilled_new_matrix = []
        matrix.dup.map.with_index{ |row, i|
            unfilled_new_matrix << row.dup if i < (current_matrix_width - 1)
        }

        unfilled_new_matrix.unshift(new_row(current_matrix_width))

        filled_new_matrix = fill_none_tiles(unfilled_new_matrix)

        @matrix_map[position.to_s] = filled_new_matrix
    end
    
    def generate_new_scrolled_down_map(position)
        unfilled_new_matrix = []
        matrix.dup.map.with_index{ |row, i|
            unfilled_new_matrix << row.dup if i > 0
        }

        unfilled_new_matrix << new_row(current_matrix_width)

        filled_new_matrix = fill_none_tiles(unfilled_new_matrix)

        @matrix_map[position.to_s] = filled_new_matrix
    end

    def expanded_row(zoom_length, current_row)
        new_row = []
        current_row.each_with_index{ |row, i|
          new_row << current_row[i]
          if new_row.length < zoom_length
            new_row << Constants::TILE_TYPES[:NONE]
          end
        }
        
        new_row
    end

    def new_row(zoom_length)
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