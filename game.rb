require_relative 'board'
require_relative 'pieces'
require_relative 'moves_tree'

board = Board.new

black_knight = BlackKnight.new

puts "Initial position of black knight? (eg d4)"
board.place( black_knight, gets.strip )
t1 = TreeOfMoves.new( black_knight )

# t1.display
puts "Where would you like to go ? (eg a1)"
path = t1.moves_to( gets.strip )
path.each_with_index { |s,i| 
  board.place( black_knight, s.to_s )
  board.display
  gets
}
