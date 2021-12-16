require 'tty-file'
require 'date'
require_relative './action.rb'
require_relative './alert_system.rb'

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
            alerts.draw
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
            'REGENERATE' => Action.new(world.method(:regenerate)),
            'ZOOM_IN' => Action.new(world.method(:zoom_in)),
            'ZOOM_OUT' => Action.new(world.method(:zoom_out)),
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
            'r' => Action.new(world.method(:regenerate)),
            'z' => Action.new(world.method(:zoom_in)),
            'x' => Action.new(world.method(:zoom_out)),
            'n' => Action.new(method(:name_world)),
            'c' => Action.new(world.method(:cycle_theme)),
            'e' => Action.new(method(:export_to_txt)),
            :up => Action.new(world.method(:scroll_up)), # scroll up
            :down => Action.new(world.method(:scroll_down)), # scroll down
            :right => Action.new(world.method(:scroll_right)), # scroll right
            :left => Action.new(world.method(:scroll_left)), # scroll left
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
                "",
                "-----------------------",
                "r to generate new world",
                "arrow keys to explore",
                "z to zoom in",
                "x to zoom out",
                "n to rename this world",
                "c to switch theme",
                "e to save this world in text",
                "q to quit",
                ""
            ].join("\n")
        )
    end

    def name_world
        new_name = prompt.ask('what do people call this world?')
        world.set_name(new_name)
    end

    def export_to_txt
        content = world.render_map_as_text(display.tile_size)

        directory = "exported_worlds"
        extension = 'txt'
        file_name = "#{DateTime.now.strftime('%Y_%m_%d__%H%M%S')}__#{world.name}.txt".gsub!(" ","_")
        location = "#{directory}/#{file_name}"
        TTY::File.create_file(location, content)

        alerts.add_message("Succesfully saved to #{location}")
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

    def alerts
        @alerts ||= AlertSystem.new
    end

    def world
        @display.world
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