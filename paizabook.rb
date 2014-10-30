require 'set'

class Paizabook

  def initialize
    @users_with_relations = Set.new
    @relations = []
  end

  def add_relationship(index1, index2)
    @users_with_relations << index1 << index2

    relation1 = @relations.find { |relation| relation.include?(index1) }
    relation2 = @relations.find { |relation| relation.include?(index2) }
    if relation1 && relation2
      @relations.delete(relation1)
      @relations.delete(relation2)
      @relations << (relation1 + relation2)
    elsif relation1
      relation1 << index2
    elsif relation2
      relation2 << index1
    else
      @relations << Set.new([index1, index2])
    end
  end

  def related?(index1, index2)
    return false unless @users_with_relations.include?(index1)
    return false unless @users_with_relations.include?(index2)

    @relations.each do |relation|
      is_1_included = relation.include?(index1)
      is_2_included = relation.include?(index2)
      return true  if is_1_included && is_2_included
      return false if is_1_included || is_2_included
    end

    false
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
      pb.add_relationship(index1, index2)
    else
      puts pb.related?(index1, index2) ? 'yes' : 'no'
    end
  end
end
