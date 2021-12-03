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
        prompt.select("", %w(ZOOM_IN ZOOM_OUT QUIT))
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
