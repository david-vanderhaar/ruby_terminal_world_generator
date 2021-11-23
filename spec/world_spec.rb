require 'world'

describe World do
    describe '.build' do
        context 'generates a 3x3 matrix' do 
            it 'generates an array with three items' do
                expect(World.build.length).to eq(3)
            end
            it 'where each item is an array with length of three' do
                World.build.each do |row|
                    expect(row.length).to eq(3)
                end
            end
        end
    end

    describe '.display' do
        context 'prints the world data to the console as characters' do
            
        end
    end
end