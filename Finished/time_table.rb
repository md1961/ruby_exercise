class TimeTable
  YEAR = 1
  MONTH = 1
  DAY = 1

  def self.parse_time(str)
    Time.local(YEAR, MONTH, DAY, *(str.split(':')))
  end
  
  START_TIME      = parse_time('10:00')
  NOON_BREAK_TIME = parse_time('12:00')
  
  SEC_BREAK       = 10 * 60
  SEC_LUNCH_BREAK = 60 * 60
  
  def initialize(names_and_minutes)
    @names_and_minutes = names_and_minutes.map do |name_and_minute|
      name, minute = name_and_minute.chomp.split
      [name, minute.to_i]
    end
  end
  
  def create
    t = START_TIME
    is_lunch_break_yet_to_take = true
    @names_and_minutes.each_with_index do |name_and_minute, index|
      name, minute = name_and_minute
      
      next_minute = 0
      next_minute = @names_and_minutes[index + 1][1] if index < @names_and_minutes.size - 1
      
      start_time = t
      end_time = t + minute * 60
      min_break = \
        if end_time + SEC_BREAK + next_minute * 60 > NOON_BREAK_TIME && is_lunch_break_yet_to_take
          is_lunch_break_yet_to_take = false
          SEC_LUNCH_BREAK
        else
          SEC_BREAK
        end
      
      puts "#{format_time(start_time)} - #{format_time(end_time)} #{name}"
      
      t = end_time + min_break
    end
    
  end
  
  private
    
    def format_time(time)
      time.strftime('%H:%M')
    end
end

if __FILE__ == $0
  num_entries = gets.to_i
  
  names_and_minutes = Array.new(num_entries)
  num_entries.times do |i|
    names_and_minutes[i] = gets.chomp
  end
  
  tt = TimeTable.new(names_and_minutes)
  tt.create
end
