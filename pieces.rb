class Piece
  BLACK = "black"
  WHITE = "white"

  attr_reader :board
  attr_reader :square

  def initialize( mark:, color:, valid_move_directions: )
    @mark = mark
    @color = color
    @valid_move_directions = valid_move_directions
  end

  def position( board:, square: )
    @square = Square.new square
    @board = board
  end

  def one_move_choices( square=nil )
    square = @square if not square
    row = square.row
    col = square.col
    destinations = []
    @valid_move_directions.each do | dir |
      new_row, new_col = move(row, col, dir)
      if @board.coordinates_valid?( row: new_row, col: new_col )
        new_square = Square.new( row: new_row, col: new_col )
        # puts "Adding for #{dir} square #{new_square.to_s}"
        destinations << new_square
      end
    end
    destinations
  end

  def to_s
    @mark
  end

  def describe
    self.to_s + " at " + @square.to_s
  end

  private

  def move( r, c, directions )
    new_row = r
    new_col = c
    directions.split("").each do |d|
      case d
      when 'u' then new_row += 1
      when 'd' then new_row -= 1
      when 'l' then new_col -= 1
      when 'r' then new_col += 1
      end
    end
    [new_row, new_col]
  end
end

class BlackKnight < Piece
  def initialize
    super(
      mark: "♞", 
      color: BLACK,
      valid_move_directions: %w( uul uur rru rrd ddr ddl lld llu ) #u/d : up/down, l/r: left/right
    )
  end
end
