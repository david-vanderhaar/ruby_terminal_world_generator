require_relative './Action.rb'

class Engine
    def initialize(prompt, display)
        @running = false
        @prompt = prompt
        @display = display
    end

    def run
        while is_running
            display.draw
            answer = get_answer
            proccess_answer(answer)
        end
    end

    def proccess_answer(answer)
        action = action_map[answer]
        action.call
    end

    def action_map
        {
            'ZOOM_IN' => Action.new(display.world.method(:zoom_in)),
            'ZOOM_OUT' => Action.new(display.world.method(:zoom_out)),
            'QUIT' => Action.new(method(:stop)),
        }
    end

    def default_action
        return true
    end

    def get_answer
        prompt.select('', action_map.keys)
    end

    def prompt
        @prompt
    end

    def display
        @display
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