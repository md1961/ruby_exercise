class Reversi

  OB    = '*'
  BLANK = '.'
  BLACK = 'B'
  WHITE = 'W'

  NUM_X = 8
  NUM_Y = 8

  INITIAL_PLACEMENTS = [
    [4, 4, WHITE],
    [5, 5, WHITE],
    [4, 5, BLACK],
    [5, 4, BLACK],
  ]

  def initialize
    init_board
  end

  def move(color, x, y)
    put_stone(x, y, color)
  end

  def judge
    num_blacks = count(BLACK)
    num_whites = count(WHITE)

    score = format("%02d-%02d", num_blacks, num_whites)
    if num_blacks == num_whites
      "#{score} Draw!"
    else
      "#{score} The #{num_blacks > num_whites ? 'black' : 'white'} won!"
    end
  end

  private

    def count(color)
      @board.flatten.count { |stone| stone == color }
    end

    def init_board
      @board = Array.new(NUM_Y + 2) do |y|
        if y == 0 || y == NUM_Y + 1
          [OB] * (NUM_X + 2)
        else
          [OB, *([BLANK] * NUM_X), OB]
        end
      end

      INITIAL_PLACEMENTS.each do |x, y, color|
        put_stone(x, y, color)
      end
    end

    def write_board
      @board.each { |row| puts row.join }
    end

    def stone(x, y)
      @board[y][x]
    end

    def put_stone(x, y, color)
      @board[y][x] = color

      [-1, 0, 1].each do |dx|
        [-1, 0, 1].each do |dy|
          next if dx == 0 && dy == 0
          reverse(x, y, color, dx, dy)
        end
      end
    end

    def opponent(color)
      color == BLACK ? WHITE : BLACK
    end

    def same?(x, y, color)
      stone(x, y) == color
    end

    def opponent?(x, y, color)
      stone(x, y) == opponent(color)
    end

    def blank?(x, y)
      stone(x, y) == BLANK
    end

    def ob?(x, y)
      stone(x, y) == OB
    end

    def reverse(x, y, color, dx, dy)
      _x = x + dx
      _y = y + dy
      return unless opponent?(_x, _y, color)

      loop do
        _x += dx
        _y += dy
        break if blank?(_x, _y) || ob?(_x, _y)
        if same?(_x, _y, color)
          __x = x
          __y = y
          loop do
            __x += dx
            __y += dy
            break if __x == _x && __y == _y
            @board[__y][__x] = color
          end
          break
        end
      end
    end
end


if __FILE__ == $0
  num_moves = gets.to_i

  reversi =Reversi.new
  num_moves.times do
    color, x, y = gets.split
    reversi.move(color, x.to_i, y.to_i)
  end
  puts reversi.judge
end
