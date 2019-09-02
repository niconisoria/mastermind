class Player
    attr_accessor :colors

    def initialize
        @colors = []
        @valid_inputs = [1,2,3,4]
    end

    def choose_colors
        puts "Choose the colors |1: red - 2: green - 3: blue - 4: yellow|"
        4.times do
            set_color
        end
    end

    def set_color
        color = gets.chomp.to_i
        return unless valid_color? color
        @colors.push(color)
    end

    def valid_color? color
        if !@valid_inputs.include?(color)
            puts "Wrong selection. Try again"
            set_color
            return false
        end
        true
    end

    def clear_selection
        @colors = []
    end

end