class Task
  attr_reader :name, :days_required, :due_day, :reward

=begin
  DATA = [
    ["T01", 4, 45],
    ["T02", 4, 48],
    ["T03", 5, 25],
    ["T04", 2, 49],
    ["T05", 5, 36],
    ["T06", 2, 31],
    ["T07", 7,  9],
    ["T08", 5, 39],
    ["T09", 4, 13],
    ["T10", 6, 17],
    ["T11", 4, 29],
    ["T12", 1, 19],
  ]
=end

  DATA = [
    ["T01", 3, 19, 17],
    ["T02", 4, 23, 14],
    ["T03", 6, 51, 10],
    ["T04", 3, 30,  7],
    ["T05", 7, 38, 13],
    ["T06", 6, 36, 11],
    ["T07", 7, 45, 18],
    ["T08", 3, 16, 10],
    ["T09", 5, 22, 13],
    ["T10", 2, 13, 16],
    ["T11", 8, 12,  6],
    ["T12", 1, 31, 15],
    ["T13", 5, 17, 13],
    ["T14", 2,  2, 13],
    ["T15", 7, 30, 11],
    ["T16", 5, 11, 18],
    ["T17", 4,  4, 10],
    ["T18", 5, 27, 15],
    ["T19", 4,  6, 15],
  ]

  def self.instances
    DATA.map { |args| new(*args) }
  end

  def initialize(name, days_required, due_day, reward)
    @name = name
    @days_required = days_required
    @due_day = due_day
    @reward = reward
  end

  def reward_per_day
    reward * 1.0 / days_required
  end

  def to_s
    format("\"%2s\" %d days, due on %2dth, %2d reward (%6.3f r/d)",
                  name, days_required, due_day, reward, reward_per_day)
  end
end


class TaskScheduler

  def initialize
    @tasks = Task.instances
  end

  def list
    @tasks.each do |task|
      puts task
    end
    puts format("Total reward = %d", total_reward(@tasks))
  end

  def schedule
    f_to_never_skip_task = ->(task) { false }
    tasks_selected_without_skipping = select_task(@tasks, f_to_never_skip_task)

    tasks_selected_for_max_reward = tasks_selected_without_skipping
    max_reward = total_reward(tasks_selected_for_max_reward)

    h_max_reward_and_count = Hash.new(0)
    h_max_reward_and_count[max_reward] = 1

    start_time = Time.now.to_i
    time_to_anneal_in_sec = 60 * 1
    while Time.now.to_i <= start_time + time_to_anneal_in_sec
      tasks_selected = select_task(@tasks, ->(task) { task.reward_per_day < 5 && rand(4) == 0 })
      total_reward = total_reward(tasks_selected)
      tasks_selected_for_max_reward = tasks_selected if total_reward > max_reward

      h_max_reward_and_count[total_reward] += 1
    end

    h_max_reward_and_count.keys.sort.reverse.each do |max_reward|
      puts format("%3d : %6d", max_reward, h_max_reward_and_count[max_reward])
    end
    puts
    output(tasks_selected_without_skipping)
    puts
    output(tasks_selected_for_max_reward)
  end

  private

    def select_task(tasks, f_skip_task)
      tasks_selected = []
      prev_total_reward = 0
      prev_total_days_required = 0
      tasks.sort_by(&:reward_per_day).reverse.each do |task|
        next if f_skip_task[task]

        tasks_selected << task
        unless due?(tasks_selected)
          tasks_selected.pop
          next
        end

=begin
        total_reward = total_reward(tasks_selected)
        total_days_required = total_days_required(tasks_selected)
        puts format("%2d tasks: Total reward = %3d (+%2d reward, +%2d day, +%6.3f reward/day)",
                      tasks_selected.size, total_reward,
                      total_reward - prev_total_reward, total_days_required - prev_total_days_required,
                      (total_reward - prev_total_reward) * 1.0 / (total_days_required - prev_total_days_required))
        prev_total_reward = total_reward
        prev_total_days_required = total_days_required
=end
      end

      tasks_selected
    end

    def total_reward(tasks)
      tasks.map(&:reward).inject(&:+)
    end

    def total_days_required(tasks)
      tasks.map(&:days_required).inject(&:+)
    end

    def output(tasks)
      days_elapsed = 0
      tasks.sort_by(&:due_day).each do |task|
        days_elapsed += task.days_required
        puts format("%s : %2d days elapsed [%s]", task, days_elapsed, days_elapsed <= task.due_day ? 'OK' : 'NG')
      end
      puts format("Total reward = %d", total_reward(tasks))
    end

    def due?(tasks)
      days_elapsed = 0
      tasks.sort_by(&:due_day).each do |task|
        days_elapsed += task.days_required
        return false if days_elapsed > task.due_day
      end
      true
    end
end


if __FILE__ == $0
  ts = TaskScheduler.new
  ts.schedule
end
