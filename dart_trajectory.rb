class DartTrajectory

  G = 9.8

  def initialize(target_distance, target_height, target_diameter)
    @target_distance = target_distance
    @target_height   = target_height
    @target_diameter = target_diameter
  end

  def throw(height_from, initial_velocity, initial_elevation_angle)
    @initial_velocity = initial_velocity
    @initial_elevation_angle = initial_elevation_angle

    height_at_target = height_from + f_trajectory(@target_distance)
    offset_from_center = (height_at_target - @target_height).abs

    is_hit = offset_from_center < @target_diameter / 2
    is_hit ? "Hit #{offset_from_center.round(1)}" : 'Miss'
  end

  private

    def f_trajectory(x)
      theta = Math::PI / 180 * @initial_elevation_angle
      x * Math.tan(theta) - G * x ** 2 / (2 * @initial_velocity ** 2 * Math.cos(theta) ** 2)
    end
end


if __FILE__ == $0
  height_from, initial_velocity, initial_elevation_angle = gets.split.map(&:to_i)
  target_distance, target_height, target_diameter        = gets.split.map(&:to_i)

  dt = DartTrajectory.new(target_distance, target_height, target_diameter)
  puts dt.throw(height_from, initial_velocity, initial_elevation_angle)
end
