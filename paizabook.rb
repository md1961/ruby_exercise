require 'set'

class Paizabook

  def initialize
    @h_user_and_relation = {}
    @id_index_relation = 0
  end

  def add_relation(user1, user2)
    relation1 = @h_user_and_relation[user1]
    relation2 = @h_user_and_relation[user2]
    if relation1 && relation2
      relation1.relate(relation2)
    elsif relation1
      relate(user2, relation1)
    elsif relation2
      relate(user1, relation2)
    else
      relation = Relation.new(@id_index_relation)
      relate(user1, relation)
      relate(user2, relation)

      @id_index_relation += 1
    end
  end

  def related?(user1, user2)
    relation1 = @h_user_and_relation[user1]
    relation2 = @h_user_and_relation[user2]
    !!relation1 && relation1.related?(relation2)
  end

  def to_s
    @h_user_and_relation.map { |u, r| "#{u}: #{r.index}" }.join("\n") + "\n\n"
  end

  private

    def relate(user, relation)
      @h_user_and_relation[user] = relation
    end

  class Relation
    attr_reader :index, :relations

    def initialize(index)
      @index = index
      @relations = Set.new
    end

    def relate(other)
      return if self.related?(other)

      new_relations = [other]
      new_relations += other.relations.reject { |relation| self.related?(relation) }

      @relations += new_relations

      new_relations.each do |relation|
        relation.relate(self)
      end
    end

    def related?(other)
      self == other || @relations.include?(other)
    end

    def ==(other)
      return false if other.nil?
      self.index == other.index
    end

    def eql?(other)
      self == other
    end

    def hash
      @index.hash
    end
  end
end


if __FILE__ == $0
  num_users, num_queries = gets.split.map(&:to_i)

  pb = Paizabook.new

  queries = Array.new(num_queries)
  num_queries.times do |index|
    queries[index] = gets.split.map(&:to_i)
  end

  queries.each do |command, index1, index2|
    if command == 0
      pb.add_relation(index1, index2)
    else
      puts pb.related?(index1, index2) ? 'yes' : 'no'
    end
  end
end
