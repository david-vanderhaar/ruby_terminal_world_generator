require_relative './constants/themes/default.rb'
require_relative './World.rb'

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
        return 1
        # screen_size / world.current_matrix_width
    end

    def initialize_world
        World.new(Constants::THEME::DEFAULT)
    end

    def world
        @world
    end
end