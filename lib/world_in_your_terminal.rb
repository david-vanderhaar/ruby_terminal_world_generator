require 'tty-prompt'
require_relative './Display.rb'
require_relative './Engine.rb'

class WorldInYourTerminal
    def explore
        display = Display.new(40)
        prompt = TTY::Prompt.new

        engine = Engine.new(prompt, display)
        engine.start
    end
end