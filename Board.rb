# verde, rojo, amarillo, azul

class Board
    attr_accessor :secret_colors, :feedback, :selected_colors

    def initialize
        @secret_colors = []
        @feedback = ['/', '/', '/', '/']
        @repeated_colors = {}
    end

    def humanize_input color
        case color
        when 1
            return "red"
        when 2
            return "green"
        when 3
            return "blue"
        when 4
            return "yellow"
        end
    end

    def random_colors
        random_colors = []
        4.times do 
            random_colors.push(random_input)
        end
        random_colors
    end

    def random_input
        humanize_input(rand(1..4))
    end

    def random_secret_colors
        @secret_colors = random_colors
    end

    def random_selected_colors
        @selected_colors = random_colors
    end

    def set_selected_colors colors
        @selected_colors = colors.map { |c| humanize_input(c) }
    end

    def set_secret_colors colors
        @secret_colors = colors.map { |c| humanize_input(c) }
    end

    def finished?
        @secret_colors == @selected_colors
    end

    def give_feedback
        clear_feedback
        repeated_colors
        check_assertions
        check_missed_position
        feedback
    end

    def check_assertions
        @secret_colors.each_with_index do |x, i|
            if @secret_colors[i] == @selected_colors[i] 
                feedback[i] = '*'
                discount_repetition @secret_colors[i]
            end
        end
    end

    def check_missed_position
        @secret_colors.each_with_index do |x, i|
            if @secret_colors[i] != @selected_colors[i] && @secret_colors.include?(@selected_colors[i]) && @repeated_colors[@selected_colors[i]] != 0
                feedback[i] = '-'
                discount_repetition @secret_colors[i]
            end
        end
    end

    def clear_feedback
        @feedback = ['/', '/', '/', '/']
    end

    def repeated_colors
        @repeated_colors = @secret_colors.group_by(&:itself).transform_values { |value| value.count}
    end

    def discount_repetition key
        @repeated_colors[key] = @repeated_colors[key] - 1
    end

    def guess_colors
        possible_colors = []
        @selected_colors.each_with_index do |x, i|
            possible_colors.push(@selected_colors[i]) if @feedback[i] == '-'
        end
        @selected_colors.each_with_index do |x, i|
            next if feedback[i] == '*'
            !possible_colors.empty? ? @selected_colors[i] = possible_colors.sample : @selected_colors[i] = random_input
        end
    end
end