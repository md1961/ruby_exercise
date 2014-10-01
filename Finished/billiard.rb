class Billiard

  def initialize(width, depth, ball_radius)
    @width       = width      .to_f
    @depth       = depth      .to_f
    @ball_radius = ball_radius.to_f
  end

  def shoot(x0, y0, theta0, shot_length)
    x0          = x0         .to_f
    y0          = y0         .to_f
    theta0      = theta0     .to_f
    shot_length = shot_length.to_f

    theta0_in_radian = theta0 * Math::PI / 180.0
    cos0 = Math.cos(theta0_in_radian)
    sin0 = Math.sin(theta0_in_radian)

    x_travel = shot_length * cos0
    y_travel = shot_length * sin0

    x_travel_before_first_wall = cos0 > 0 ? @width - @ball_radius - x0 \
                               : cos0 < 0 ? -(x0 - @ball_radius) \
                                          : nil
    y_travel_before_first_wall = sin0 > 0 ? @depth - @ball_radius - y0 \
                               : sin0 < 0 ? -(y0 - @ball_radius) \
                                          : nil

    virtual_width = @width - @ball_radius * 2
    virtual_depth = @depth - @ball_radius * 2

    num_hit_vertical_wall   = x_travel_before_first_wall.nil? || x_travel.abs <= x_travel_before_first_wall.abs ? 0 \
                                : ((x_travel.abs - x_travel_before_first_wall.abs) / virtual_width).to_i + 1
    num_hit_horizontal_wall = y_travel_before_first_wall.nil? || y_travel.abs <= y_travel_before_first_wall.abs ? 0 \
                                : ((y_travel.abs - y_travel_before_first_wall.abs) / virtual_depth).to_i + 1
    is_x_to_be_reversed = cos0 == 0 ? false : cos0 > 0 ? num_hit_vertical_wall  .odd? : num_hit_vertical_wall  .even?
    is_y_to_be_reversed = sin0 == 0 ? false : sin0 > 0 ? num_hit_horizontal_wall.odd? : num_hit_horizontal_wall.even?

    if num_hit_vertical_wall == 0
      x_final = x0 + x_travel
    else
      virtual_x_final = (x_travel - x_travel_before_first_wall).abs % virtual_width
      virtual_x_final = (virtual_width - virtual_x_final) if is_x_to_be_reversed
      x_final = virtual_x_final + @ball_radius
    end
    if num_hit_horizontal_wall == 0
      y_final = y0 + y_travel
    else
      virtual_y_final = (y_travel - y_travel_before_first_wall).abs % virtual_depth
      virtual_y_final = (virtual_depth - virtual_y_final) if is_y_to_be_reversed
      y_final = virtual_y_final + @ball_radius
    end

    [x_final, y_final]
  end
end


if __FILE__ == $0
  width, depth, x0, y0, ball_radius, theta0, shot_length = gets.split.map(&:to_i)
  
  billiard = Billiard.new(width, depth, ball_radius)
  puts billiard.shoot(x0, y0, theta0, shot_length).join(' ')
end
