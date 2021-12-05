require_relative './Action.rb'

class Engine
    def initialize(prompt, display)
        @running = false
        @prompt = prompt
        @display = display
    end

    def run
        initialize_key_prompt
        while is_running
            display.draw
            show_key_prompts
        end
    end
    
    def run_v1
        while is_running
            display.draw
            answer = get_answer
            proccess_answer(answer)
        end
    end

    def get_answer
        prompt.select('', action_map.keys, cycle: true)
    end

    def proccess_answer(answer)
        action = action_map[answer]
        action.call
    end

    def action_map
        {
            'REGENERATE' => Action.new(display.world.method(:regenerate)),
            'ZOOM_IN' => Action.new(display.world.method(:zoom_in)),
            'ZOOM_OUT' => Action.new(display.world.method(:zoom_out)),
            'SCROLL_UP' => Action.new(method(:default_action)),
            'SCROLL_RIGHT' => Action.new(method(:default_action)),
            'SCROLL_DOWN' => Action.new(method(:default_action)),
            'SCROLL_LEFT' => Action.new(method(:default_action)),
            'QUIT' => Action.new(method(:stop)),
        }
    end

    def key_map
        {
            'q' => Action.new(method(:stop)),
            'r' => Action.new(display.world.method(:regenerate)),
            'z' => Action.new(display.world.method(:zoom_in)),
            'x' => Action.new(display.world.method(:zoom_out)),
            :up => Action.new(method(:default_action)), # scroll up
            :down => Action.new(method(:default_action)), # scroll down
            :right => Action.new(display.world.method(:scroll_right)), # scroll right
            :left => Action.new(method(:default_action)), # scroll left
        }
    end

    def initialize_key_prompt
        prompt.on(:keypress) { |event| 
            event_key = event.value
            event_name = event.key.name
            key_map[event_key].call if key_map.keys.include?(event_key)
            key_map[event_name].call if key_map.keys.include?(event_name)
        }
    end

    def show_key_prompts
        prompt.keypress(
            [
                "r to generate new world",
                "arrow keys to explore",
                "z to zoom in",
                "x to zoom out",
                "q to quit",
            ].join("\n")
        )
    end

    def default_action
        return true
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