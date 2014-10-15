class LiarFinder

  def initialize(num_people)
    @people = 1.upto(num_people).map { |index| Person.new(index) }
    @facts = []
  end

  def add_statement(statement)
    unless statement =~ /\A(\d+) said (\d+) was an? (\w+)/
      raise ArgumentError, "'#{statement}'"
    end
    index_stater    = Regexp.last_match(1).to_i
    index_objective = Regexp.last_match(2).to_i
    predicate       = Regexp.last_match(3)

    # If A says B is honest, that means A and B is same in honest/liar-wise.
    # If A says B is a liar, that means A and B is different in honest/liar-wise.
    stater    = find_person_by_index(index_stater)
    objective = find_person_by_index(index_objective)
    @facts << Fact.new(predicate == 'honest', stater, objective)
  end

  def judge
    @facts.uniq!

    facts_same, facts_different = @facts.partition(&:same_kind?)

    return -1 if facts_different.any?(&:self_contradicting?)

    process_chained_different_kind_facts_into_facts_same(facts_different, facts_same)
    facts_same.uniq!

    facts_same.reject!(&:meaningless?)

    facts_same = merge_all_chained_same_kind_facts(facts_same)

    facts_same.each do |fact_same|
      facts_different.each do |fact_different|
        return -1 if fact_same.contradicting?(fact_different)
      end
    end

    remove_meaningless_facts_different(facts_different, facts_same)

    ruducing_factor_from_same      = facts_same     .map(&:combination_reducing_factor).inject(0, &:+)
    ruducing_factor_from_different = facts_different.map(&:combination_reducing_factor).inject(0, &:+)

    (@people.size - ruducing_factor_from_same - ruducing_factor_from_different) + 1
  end

  def to_s
    @facts.map(&:to_s).join("\n")
  end

  private

    def find_person_by_index(index)
      @people[index - 1]
    end

    def process_chained_different_kind_facts_into_facts_same(facts_different, facts_same)
      facts_different.size.times do |i|
        (facts_different.size - 1).downto(i + 1) do |j|
          fact1 = facts_different[i]
          fact2 = facts_different[j]
          if fact1.one_person_common?(fact2)
            facts_same << extract_fact_same_from_chained_different_kind_facts(fact1, fact2)
            facts_different.delete_at(j)
          end
        end
      end
    end

    def extract_fact_same_from_chained_different_kind_facts(fact1, fact2)
      return nil unless fact1.one_person_common?(fact2)

      persons1 = fact1.persons 
      persons2 = fact2.persons 
      Fact.new(true, *(persons1 | persons2) - (persons1 & persons2))
    end

    def merge_all_chained_same_kind_facts(facts_same)
      new_facts_same = []
      until facts_same.empty?
        fact0 = facts_same.shift
        loop do
          is_any_merged = false
          facts_same.size.times do
            fact1 = facts_same.shift
            is_merged = fact0.merge(fact1)
            facts_same << fact1 unless is_merged
            is_any_merged ||= is_merged
          end
          break unless is_any_merged
        end
        new_facts_same << fact0
      end

      new_facts_same
    end

    def remove_meaningless_facts_different(facts_different, facts_same)
      facts_different.size.times do |i|
        break unless facts_different[i]
        person1, person2 = facts_different[i].persons
        fact_same1 = facts_same.find { |fact_same| fact_same.persons.include?(person1) }
        fact_same2 = facts_same.find { |fact_same| fact_same.persons.include?(person2) }
        next if fact_same1.nil? || fact_same2.nil?
        persons_same1 = fact_same1.persons - [person1]
        persons_same2 = fact_same2.persons - [person2]
        meaningless_facts_different = persons_same1.product(persons_same2).map { |persons| Fact.new(false, *persons) }
        (facts_different.size - 1).downto(i + 1) do |j|
          facts_different.delete_at(j) if meaningless_facts_different.include?(facts_different[j])
        end
      end
    end

  class Person
    include Comparable

    attr_reader :index

    def initialize(index)
      @index = index
    end

    def ==(other)
      self.index == other.index
    end

    def <=>(other)
      self.index <=> other.index
    end

    def to_s
      index.to_s
    end
  end

  class Fact
    attr_reader :persons

    def initialize(is_same_kind, *persons)
      @is_same_kind = is_same_kind
      @persons      = persons.sort
    end

    def same_kind?
      @is_same_kind
    end

    def meaningless?
      persons.size == 2 && persons[0] == persons[1] && same_kind?
    end

    def self_contradicting?
      persons.size == 2 && persons[0] == persons[1] && ! same_kind?
    end

    def ==(other)
      self.persons == other.persons && self.same_kind? == other.same_kind?
    end

    def eql?(other)
      self == other
    end

    def hash
      (persons + [same_kind?]).hash
    end

    def contradicting?(other)
      [self.persons, other.persons].include?(self.persons & other.persons) && self.same_kind? != other.same_kind?
    end

    def one_person_common?(other)
      (self.persons & other.persons).size == 1
    end

    def merge(other)
      return false if ! self.same_kind? || ! other.same_kind? || (self.persons & other.persons).empty?

      @persons = (self.persons | other.persons).sort
      true
    end

    def combination_reducing_factor
      persons.size - 1
    end

    def to_s
      "#{persons.join(',')} are #{same_kind? ? 'same' : 'different'}"
    end
  end
end


if __FILE__ == $0
  num_people, num_statements = gets.split.map(&:to_i)
  lf = LiarFinder.new(num_people)

  num_statements.times do
    lf.add_statement(gets.chomp)
  end

  puts lf.judge
end
