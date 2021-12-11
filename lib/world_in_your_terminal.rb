require 'tty-prompt'
require_relative './world_in_your_terminal/Display.rb'
require_relative './world_in_your_terminal/Engine.rb'

class WorldInYourTerminal
    def explore
        display = Display.new(40)
        prompt = TTY::Prompt.new

        engine = Engine.new(prompt, display)
        engine.start
    end
end