class GhostLeg

  def initialize(height, num_verticals)
    @num_verticals = num_verticals
    @verticals = Array.new(@num_verticals) { |index| Vertical.new(index, height) }
  end

  def add_branch(index0, offset0, index1, offset1)
    joint0 = Joint.new(@verticals[index0], offset0)
    joint1 = Joint.new(@verticals[index1], offset1)
    joint0.joint_to = joint1
    joint1.joint_to = joint0
    @verticals[index0].add_joint(joint0)
    @verticals[index1].add_joint(joint1)
  end

  def trace_from_goal(vertical_index)
    vertical = @verticals[vertical_index]
    cursor = Cursor.new(vertical, vertical.height)
    cursor.trace_upward
  end

  class Vertical
    attr_reader :index, :height

    def initialize(index, height)
      @index  = index
      @height = height
      @joints = []
    end

    def add_joint(joint)
      @joints << joint
      @joints.sort!
    end

    def joint_above(current_offset)
      joint_offsets = @joints.map(&:offset)
      offset_above = joint_offsets.reverse.find { |offset| offset < current_offset }
      offset_above && @joints.find { |joint| joint.offset == offset_above }
    end
  end

  class Joint
    include Comparable

    attr_reader :vertical, :offset
    attr_accessor :joint_to

    def initialize(vertical, offset)
      @vertical = vertical
      @offset   = offset
    end

    def <=>(other)
      self.offset <=> other.offset
    end
  end

  class Cursor
    attr_reader :vertical, :offset

    def initialize(vertical, offset)
      @vertical = vertical
      @offset   = offset
    end

    def move_to(joint)
      @vertical = joint.vertical
      @offset   = joint.offset
    end

    def trace_upward
      loop do
        joint = vertical.joint_above(offset)
        break unless joint
        move_to(joint.joint_to)
      end

      vertical.index
    end
  end
end


if __FILE__ == $0
  height, num_verticals, num_horizontals = gets.split.map(&:to_i)
  gl = GhostLeg.new(height, num_verticals)

  num_horizontals.times do
    index_vertical, offset_from, offset_to = gets.split.map(&:to_i)
    index_from = index_vertical - 1
    gl.add_branch(index_from, offset_from, index_from + 1, offset_to)
  end

  index_from = 0
  vertical_start_index = gl.trace_from_goal(index_from)
  puts vertical_start_index + 1
end
