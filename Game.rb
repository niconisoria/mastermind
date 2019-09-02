require_relative 'Board'
require_relative 'Player'

class Game
    attr_accessor :player, :board, :turn

    def initialize board, player
        @board = board
        @turn = 1
        @player = player
    end

    def rules
        system 'clear'
        puts "--------------"
        puts "Rules: you have 12 turns to guess the 4 secret colors and their correct position." 
        puts "The game will give you a proper feedback where * respresents correct color and correct"
        puts "position and - represents the correct color but wrong position."
        puts "--------------"
    end

    def player_play
        rules
        board.random_secret_colors
        while true
            puts "Turn: #{@turn}"
            puts "--------------"
            player.choose_colors
            board.set_selected_colors player.colors
            puts "Your selection: #{board.selected_colors.join(', ')}"
            player.clear_selection
            if game_over?
                game_over_message
                return
            end
            pass_turn
            puts "Feedback: #{board.give_feedback.join(', ')}"
            puts "Press enter to continue..."
            system 'clear' if gets.chomp
        end
    end

    def computer_play
        rules
        player.choose_colors
        board.set_secret_colors player.colors
        system 'clear'
        while true
            puts "Turn: #{@turn}"
            puts "--------------"
            @turn == 1 ? board.random_selected_colors : board.guess_colors
            puts "Computer selection: #{board.selected_colors.join(', ')}"
            if game_over?
                game_over_message
                return
            end
            pass_turn
            puts "Feedback: #{board.give_feedback.join(', ')}"
            puts "Press enter to continue..."
            system 'clear' if gets.chomp
        end
    end

    def play
        puts "MASTERMIND"
        puts "Do you want to select the colors or guess the colors?"
        puts "1: create the secret colors ; 2: guess the secret colors"
        mode = choose_mode
        computer_play if mode == 1
        player_play if mode == 2
    end

    def choose_mode
        mode = gets.chomp.to_i
        validate_mode mode
        return mode
    end

    def validate_mode mode
        if mode == 1 || mode == 2 
            return true
        else
            puts "Wrong selection. Try again."
            choose_mode
        end
    end

    def pass_turn
        @turn = @turn + 1
    end

    def game_over?
        board.finished? || @turn == 12
    end

    def game_over_message
        if board.finished? && @turn != 12
            puts "WINNER!"
        else
            puts "LOOSER!"
            puts "Secret colors: #{board.secret_colors.join(', ')}"
        end
    end
end

board = Board.new
player = Player.new
game = Game.new(board, player)
game.play