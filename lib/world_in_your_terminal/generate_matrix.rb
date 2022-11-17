require 'perlin_noise'
require_relative './constants/tile_types.rb'

class GenerateMatrix
    def two_lands_matrix
        [
            [Constants::TILE_TYPES[:WATER], Constants::TILE_TYPES[:WATER], Constants::TILE_TYPES[:WATER], Constants::TILE_TYPES[:PLAIN]],
            [Constants::TILE_TYPES[:PLAIN], Constants::TILE_TYPES[:PLAIN], Constants::TILE_TYPES[:WATER], Constants::TILE_TYPES[:WATER]],
            [Constants::TILE_TYPES[:FOREST], Constants::TILE_TYPES[:PLAIN], Constants::TILE_TYPES[:WATER], Constants::TILE_TYPES[:WATER]],
            [Constants::TILE_TYPES[:MOUNTAIN], Constants::TILE_TYPES[:FOREST], Constants::TILE_TYPES[:PLAIN], Constants::TILE_TYPES[:WATER]],
        ]
    end

    def water_world_matrix
        [
            [Constants::TILE_TYPES[:WATER], Constants::TILE_TYPES[:WATER], Constants::TILE_TYPES[:WATER], Constants::TILE_TYPES[:WATER]],
            [Constants::TILE_TYPES[:WATER], Constants::TILE_TYPES[:WATER], Constants::TILE_TYPES[:WATER], Constants::TILE_TYPES[:WATER]],
            [Constants::TILE_TYPES[:WATER], Constants::TILE_TYPES[:WATER], Constants::TILE_TYPES[:WATER], Constants::TILE_TYPES[:WATER]],
            [Constants::TILE_TYPES[:MOUNTAIN], Constants::TILE_TYPES[:WATER], Constants::TILE_TYPES[:WATER], Constants::TILE_TYPES[:WATER]],
        ]
    end

    def perlin_matrix(size, offset: {x: 0, y: 0})
        perlin_matrix = []
        offset_x = offset[:x]
        offset_y = offset[:y]

        size.times do |x|
            row = []
            size.times do |y|
                n = noises[(offset_x + x) * step, (offset_y + y) * step]
                n = contrast.call(n)
            
                row << bar(n)
            end

            perlin_matrix << row
        end

        perlin_matrix
    end

    def step
        0.2
    end

    def noises
        @noises ||= Perlin::Noise.new(2)
    end

    def contrast
        @contrast ||= Perlin::Curve.contrast(Perlin::Curve::CUBIC, 2)
    end
    
    def bars
        @bars ||= [
            Constants::TILE_TYPES[:WATER],
            Constants::TILE_TYPES[:WATER],
            Constants::TILE_TYPES[:PLAIN],
            Constants::TILE_TYPES[:FOREST],
            Constants::TILE_TYPES[:MOUNTAIN],
        ]
    end

    def bar(chance)
      bars[ (bars.length * chance).floor ]
    end
end