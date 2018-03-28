# University of Washington, Programming Languages, Homework 6, hw6runner.rb

# This is the only file you turn in, so do not modify the other files as
# part of your solution.

class MyPiece < Piece
  # The constant All_My_Pieces should be declared here
  
  # class array holding all the pieces and their rotations
  All_My_Pieces = All_Pieces + [
                rotations([[0, 0], [1, 0], [0, 1], [1, 1], [2, 1]]),  # square with dot
                rotations([[0, 0], [0, 1], [1, 1]]), # short L
                [[[0, 0], [-2, 0], [-1, 0], [1, 0], [2, 0]], # very long 5 (only needs two)
                [[0, 0], [0, -2], [0, -1], [0, 1], [0, 2]]]] 
                
  Cheat_Piece = [[[0, 0]]]

  # your enhancements here
  
  # class method to choose the next piece
  def self.next_piece (board, cheat=false)
    if cheat
      MyPiece.new(Cheat_Piece, board)
    else
      MyPiece.new(All_My_Pieces.sample, board)
    end
  end

end

class MyBoard < Board
  # your enhancements here

  def initialize (game)
    @grid = Array.new(num_rows) {Array.new(num_columns)}
    @current_block = MyPiece.next_piece(self)
    @score = 0
    @game = game
    @delay = 500
    # Cheat mode flag ! enhancement
    @cheat_mode = false
  end

  # gets the information from the current piece about where it is and uses this
  # to store the piece on the board itself.  Then calls remove_filled.
  # Changed the hard-coded length of pieces arrays from the provided class
  # as new pieces have variable length, this information is accessed dynamically now.
  def store_current
    locations = @current_block.current_rotation
    displacement = @current_block.position
    locations.each_with_index{|location, index| 
      current = location;
      @grid[current[1]+displacement[1]][current[0]+displacement[0]] = 
      @current_pos[index]
    }
    remove_filled
    @delay = [@delay - 2, 80].max
  end

  # gets the next piece
  def next_piece
    @current_block = MyPiece.next_piece(self, @cheat_mode)
    @current_pos = nil
    @cheat_mode = false
  end

  # rotates the current piece upside_down ! enhancement
  def upside_down
    if !game_over? and @game.is_running?
      @current_block.move(0, 0, 2)
    end
    draw
  end

  # enables the cheat mode ! enhancement
  def start_cheat
    unless @cheat_mode
      if @score >= 100
        @cheat_mode = true
        @score -= 100
      end
    end
  end

end

class MyTetris < Tetris
  # your enhancements here
  def set_board
    @canvas = TetrisCanvas.new
    @board = MyBoard.new(self)
    @canvas.place(@board.block_size * @board.num_rows + 3,
                  @board.block_size * @board.num_columns + 6, 24, 80)
    @board.draw
  end

  def key_bindings
    super
    @root.bind('u', proc {@board.upside_down})
    @root.bind('c', proc {@board.start_cheat})
  end

end