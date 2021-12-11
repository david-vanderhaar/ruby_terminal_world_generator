
class Action
    def initialize(callback)
        @callback = callback
    end

    def call
        @callback.call
    end
end
