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

    def perlin_matrix(size)
        noises = Perlin::Noise.new(2)
        contrast = Perlin::Curve.contrast(Perlin::Curve::CUBIC, 2)
        
        bars = [
            Constants::TILE_TYPES[:WATER],
            Constants::TILE_TYPES[:WATER],
            Constants::TILE_TYPES[:PLAIN],
            Constants::TILE_TYPES[:FOREST],
            Constants::TILE_TYPES[:MOUNTAIN],
        ]
        bar = lambda { |n|
          bars[ (bars.length * n).floor ]
        }
        
        perlin_matrix = []

        size.times do |x|
            row = []
            size.times do |y|
                n = noises[x * 0.2, y * 0.2]
                n = contrast.call n
            
                row << bar.call(n)
            end

            perlin_matrix << row
        end

        perlin_matrix
    end
end