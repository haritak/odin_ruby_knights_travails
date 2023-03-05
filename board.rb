class Square
  attr_reader :col, :row

  def initialize( something )
    case something
    in Square => sq
      @row = sq.row
      @col = sq.col
    in String => s
      @row, @col = Square.to_coordinates( s )
    in row: Integer=>row, col: Integer=>col
      @row = row
      @col = col
    end
  end

  def to_coordinates
    [@row, @col]
  end

  def to_square
    Square.to_square( row: @row, col: @col )
  end

  def to_s
    self.to_square
  end

  def Square.to_coordinates( square )
    col_str = square[0]
    row_str = square[1]
    col = col_str.ord - 'a'.ord
    row = row_str.ord - '1'.ord
    [row, col]
  end

  def Square.to_square( row:, col: )
    "#{'abcdefgh'[col]}#{'12345678'[row]}"
  end

  def ==(object)
    (self.row*8 + self.col) == (object.row*8 + object.col) 
  end
end

class Board
  def initialize
    @rows = Array.new(8) { '........'.split("") }
  end

  def display
    @rows.reverse.each_with_index do | row, i |
      puts "#{8-i} #{row.join}"
    end
    puts "  abcdefgh"
  end

  def place( piece, square )
    s = Square.new( square )
    @rows[ s.row ][ s.col ] = piece
    piece.position( board: self, square: s )
  end

  def square_empty?( square )
    s = Square.new square
    @rows[ s.row ][ s.col ] == '.'
  end

  def coordinates_valid?( col:, row: )
    col >= 0 and row >= 0 and col <= 7 and row <= 7
  end

  def all_squares
    all = []
    'abcdefgh'.split("").each do |col|
      '12345678'.split("").each do |row|
        all << Square.new( "#{col}#{row}" )
      end
    end
    all
  end

end
