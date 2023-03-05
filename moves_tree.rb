class Node
  attr_accessor :parent
  attr_reader :children
  attr_reader :square
  attr_accessor :level

  def initialize( parent: nil, square: , children: nil )
    @parent = parent
    @square = square
    @children = children ? children : []
    @level = parent ? parent.level + 1 : 0
  end

  def add_child( kid )
    if not @children.include? kid
      @children.push( kid )
      kid.parent = self
      kid.level = self.level + 1
      #puts "Added #{kid}( #{kid.level} to #{self}(#{self.level})"
      return true
    else
      #puts "Not adding #{kid.square.to_s} cause it already exists"
      return false
    end
  end

  def remove_child( kid )
    @children.delete kid
  end

  def has_child?( kid )
    @children.include? kid
  end

  def ==( object )
    return false if not object
    self.square == object.square
  end

end

class TreeOfMoves
  def initialize( piece )
    @piece = piece
    @root = Node.new( square: piece.square )
    @nodes_counter = 0
    @visited_squares = []

    build_tree_of_moves( @root )
  end

  def level_traverse( &block )
    queue = [ @root ]

    current = 0
    while current < queue.length
      queue[ current ].children.each do |kid|
        queue.push kid 
      end
      current += 1
    end

    queue.each do | node |
      block.call( node )
    end
  end

  def display
    puts "Possible squares for #{ @piece.describe }"
    level_traverse do |node|
      print "#{node.square.to_s} reachable in #{node.level} moves"
      print " from #{node.parent.square.to_s}" if node.parent 
      puts 
    end
  end

  def all_squares_visited?
    @visited_squares.count == @piece.board.all_squares.count
  end

  def find( square )
    level_traverse do | visited_node |
      return visited_node if square == visited_node.square
    end
    nil
  end

  def descentant?( starting_node, square )
    current = starting_node
    while current
      return true if current.square == square
      current = current.parent
    end
    false
  end

  def moves_to( square_str )
    square = Square.new square_str
    puts "Searching for square #{square.to_s}"

    node = find( square )
    current = node
    path = []
    while current 
      path << current.square
      current = current.parent
    end

    path.reverse
  end

  private

  def build_tree_of_moves( starting_node )
    # puts "at level #{starting_node.level}"
    # puts @visited_squares.count.to_s + ": " + @visited_squares.join(" ")
    # puts @nodes_counter
    return if all_squares_visited? 
    destinations = @piece.one_move_choices( starting_node.square )
    destinations.each do | square |
      existing_node = find( square )
      if !existing_node
        starting_node.add_child( Node.new( square: square ) )
        @nodes_counter += 1
        @visited_squares << square if not @visited_squares.include? square
      elsif existing_node.level > starting_node.level+1
        # puts "Removing longer path"
        starting_node.add_child( Node.new( square: square ) )
        existing_node.parent.remove_child existing_node
        existing_node.parent = nil
      end
    end

    starting_node.children.each do | kid |
      build_tree_of_moves( kid )
    end
  end

end
