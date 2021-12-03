#!/usr/bin/env ruby

require 'tty-box'
require 'tty-screen'
require 'tty-table'
require 'tty-prompt'
require_relative './constants/tile_types.rb'
require_relative './constants/themes/default.rb'

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
        table = TTY::Table.new({rows: colored_matrix})
        puts @zoom_level
        puts table.render(
            :basic, 
            alignments: [:center],
            padding: 0
        )
    end

    def draw_v1(tile_size)
        matrix.each_with_index { |row, y|
            row.each_with_index { |tile, x|
                draw_tile(tile, x * tile_size, y * tile_size, tile_size);
            }
            puts ''
        }
    end

    def draw_tile(value, x, y, size)
        print @pastel.red.on_green(value)
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
        puts 'generating'
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

class Display
    def initialize(screen_size)
        @screen_size = screen_size
        @world = initialize_world
    end

    def draw
        world.draw(tile_size)
    end

    def screen_size
        @screen_size
    end

    def tile_size
        screen_size / world.current_matrix_width
    end

    def initialize_world
        World.new(Constants::THEME::DEFAULT)
    end

    def world
        @world
    end
end

class Engine
    def initialize
        @running = false
    end

    def run
        while is_running
            display.draw
            answer = get_answer
            proccess_answer(answer)
        end
    end

    def proccess_answer(answer)
        case answer
        when 'ZOOM_IN' 
            display.world.zoom_in
        when 'ZOOM_OUT' 
            display.world.zoom_out
        when 'QUIT' 
            stop
        else 
            stop
        end
    end

    def default_action
        return true
    end

    def get_answer
        prompt.select("What next?", %w(ZOOM_IN ZOOM_OUT QUIT))
    end

    def prompt
        @prompt ||= TTY::Prompt.new
    end

    def display
        # @display ||= Display.new(TTY::Screen.width)
        @display ||= Display.new(40)
    end

    def start
        if is_running
            throw "engine already running"
        end

        @running = true
        run
    end

    def stop
        @running = false
    end

    def is_running
        @running
    end

    def is_stopped
        !is_running
    end
end

engine = Engine.new
engine.start
