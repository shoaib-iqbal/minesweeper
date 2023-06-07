class Board < ApplicationRecord
  validates :email, presence: true
  validates :width, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :height, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :mines, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :name, presence: true

  # Generate the Minesweeper board
   def self.ransackable_attributes(auth_object = nil)
    ["created_at", "email", "height", "id", "mines", "name", "updated_at", "width"]
  end
  def generate_board
    board = Array.new(height) { Array.new(width) { Cell.new } }
    populate_mines(board)
    calculate_numbers(board)
    board
  end

  private

  # Populate random mines on the board
  def populate_mines(board)
    mine_positions = (0...height * width).to_a.sample(mines)
    mine_positions.each do |position|
      row = position / width
      col = position % width
      board[row][col].mine = true
    end
  end

  # Calculate the numbers indicating the adjacent mines for each cell
  def calculate_numbers(board)
    (0...height).each do |row|
      (0...width).each do |col|
        next if board[row][col].mine?

        count = 0
        (-1..1).each do |dx|
          (-1..1).each do |dy|
            x = row + dx
            y = col + dy
            count += 1 if valid_position?(x, y, board) && board[x][y].mine?
          end
        end
        board[row][col].number = count
      end
    end
  end

  # Check if a position is valid on the board
  def valid_position?(x, y, board)
    x >= 0 && x < height && y >= 0 && y < width
  end
end

class Cell
  attr_accessor :mine, :number

  def initialize
    @mine = false
    @number = 0
  end

  def mine?
    @mine
  end
end
