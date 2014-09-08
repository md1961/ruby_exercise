class SnsDisconnect
  attr_reader :persons

  def initialize(num_persons)
    @persons = (1 .. num_persons).to_a.map { |i| Person.new(i.to_s) }
  end

  def find_by_name(name)
    @persons[name.to_i - 1]
  end

  def connect(name1, name2)
    person1 = find_by_name(name1)
    person2 = find_by_name(name2)

    person1.connect(person2)
    person2.connect(person1)
  end

  def num_friends_to_disconnect(name, name_to_disconnect)
    person = find_by_name(name)
    person_to_disconnect = find_by_name(name_to_disconnect)

    person.friends.count { |friend| friend == person_to_disconnect || connected?(friend, person_to_disconnect, [person]) }
  end

  private

    def connected?(person1, person2, persons_to_ignore)
      puts "called: connected?(#{person1}, #{person2}, [#{persons_to_ignore.join(',')}])"

      person1.friends.each do |friend|
        next if persons_to_ignore.include?(friend)
        return true if friend == person2
        return true if connected?(friend, person2, persons_to_ignore + [person1])
      end

      false
    end

  class Person
    attr_reader :name, :friends

    def initialize(name)
      @name = name
      @friends = []
    end

    def connect(other)
      @friends << other unless friends.include?(other)
    end

    def ==(other)
      self.name == other.name
    end

    def hash
      name.hash
    end

    def to_s
      "[#{name}]"
    end
  end
end


if __FILE__ == $0
  num_persons, num_connects, name_to_disconnect = gets.chomp.split

  num_persons  = num_persons .to_i
  num_connects = num_connects.to_i

  snsd = SnsDisconnect.new(num_persons)

  num_connects.times do
    name1, name2 = gets.chomp.split
    snsd.connect(name1, name2)
  end

  snsd.persons.each do |person|
    puts "#{person}(w/#{person.friends.join(',')})"
  end
  puts

  puts snsd.num_friends_to_disconnect('1', name_to_disconnect)
end
