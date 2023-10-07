# family_tree_node
class FamilyTreeNode
  attr_accessor :name, :parents, :spouse, :children, :gender

  def initialize(name, gender)
    @gender = gender
    @name = name
    @parents = []
    @spouse = nil
    @children = []
  end

  def add_spouse(spouse)
    @spouse = spouse
    spouse.spouse = self
  end

  def add_parent(parent)
    @parents << parent
    parent.children << self
  end
end

# family_tree
class FamilyTree
  def initialize
    @people = {}
  end

  def add_person(name, gender)
    @people[name] = FamilyTreeNode.new(name, gender)
  end

  def connect(name1, relationship, name2)
    person1 = @people[name1] || add_person(name1)
    person2 = @people[name2] || add_person(name2)

    case relationship
    when 'father'
      person2.add_parent(person1)
    when 'mother'
      person2.add_parent(person1)
    when 'son'
      person1.add_parent(person2)
    when 'daughter'
      person1.add_parent(person2)
    when 'spouse'
      person2.add_spouse(person1)
    end
  end

  def count_relationship(name, relationship)
    person = @people[name]
    return 0 unless person

    case relationship
    when 'sons'
      person.children.count { |child| child.gender == 'male' }
    when 'daughters'
      person.children.count { |child| child.gender == 'female' }
    when 'wives'
      person.spouse ? 1 : 0
    end
  end

  def parent_of(name, gender)
    person = @people[name]
    return nil unless person

    parent = person.parents.find { |parent| parent.gender == gender }
    parent&.name
  end

  def run
    while true
      print '> '

      input = gets.chomp.split

      case input[0]
      when 'add'
        case input[1]
        when 'person'
          add_person(input[2], input[3])
        when 'relationship'
          add_relationship(input[2], input[3])
        end
      when 'connect'
        connect(input[1], input[3], input[5])
      when 'count'
        puts count_relationship(input[3], input[1])
      when 'father'
        puts parent_of(input[2], 'male')
      when 'mother'
        puts parent_of(input[2], 'female')
      end
    end
  end
end

family_tree = FamilyTree.new
family_tree.run
