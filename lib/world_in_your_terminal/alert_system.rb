class AlertSystem
    def initialize
        @pastel = Pastel.new
        @alerts = []
    end

    def draw
        puts render
        clear
    end

    def add_message(message)
        @alerts << Alert.new(message, pastel)
    end

    private

    def render
        lines_to_render = []
        alerts.each { |alert| 
            lines_to_render << alert.render
        }

        lines_to_render.join("\n")
    end

    def alerts
        @alerts
    end

    def clear
        @alerts = []
    end

    def pastel
        @pastel
    end
end

class Alert
    def initialize(message, pastel)
        @message = message
        @pastel = pastel
    end

    def render
        @pastel.black.on_green(message)
    end

    def message
        @message
    end
end