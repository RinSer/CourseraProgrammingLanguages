# University of Washington, Programming Languages, Homework 6, hw6runner.rb

# This is the only file you turn in, so do not modify the other files as
# part of your solution.

class MyPiece < Piece
  # The constant All_My_Pieces should be declared here
  
  # class array holding all the pieces and their rotations
  All_My_Pieces = [rotations([[0, 0], [1, 0], [0, 1], [1, 1], [2, 1]]),  # square with dot
               rotations([[0, 0], [0, 1], [1, 0]]), # short L
               [[[0, 0], [-2, 0], [-1, 0], [1, 0], [2, 0]], # very long 5 (only needs two)
               [[0, 0], [0, -2], [0, -1], [0, 1], [0, 2]]]]
  # your enhancements here
  # class method to choose the next piece
  def self.next_piece (board)
    MyPiece.new((All_Pieces + All_My_Pieces).sample, board)
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
  end

  # gets the next piece
  def next_piece
    @current_block = MyPiece.next_piece(self)
    @current_pos = nil
  end

  # rotates the current piece upside_down
  def upside_down
    if !game_over? and @game.is_running?
      @current_block.move(0, 0, 2)
    end
    draw
  end

  # removes all filled rows and replaces them with empty ones, dropping all rows
  # above them down each time a row is removed and increasing the score.  
  def remove_filled
    (2..(@grid.size-1)).each{|num| row = @grid.slice(num);
      # see if this row is full (has no nil)
      if @grid[num].all?
        # remove from canvas blocks in full row
        (0..(num_columns-1)).each{|index|
          @grid[num][index].remove;
          @grid[num][index] = nil
        }
        # move down all rows above and move their blocks on the canvas
        ((@grid.size - num + 1)..(@grid.size)).each{|num2|
          @grid[@grid.size - num2].each{|rect| rect && rect.move(0, block_size)};
          @grid[@grid.size-num2+1] = Array.new(@grid[@grid.size - num2])
        }
        # insert new blank row at top
        @grid[0] = Array.new(num_columns);
        # adjust score for full flow
        @score += 10;
      end}
    self
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
    @root.bind('c', proc {self.cheat})

  end

end


