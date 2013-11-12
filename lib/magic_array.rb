class MagicArray

  attr_accessor :elements, :count

  def initialize *attrs
    @elements = []
    self
  end

  def method_missing m, *args, &block
    @elements.public_send m, args
  end

  def [] index
    case index
      when Range then
        elements[index].blank? || elements[index].include?(nil) ? load_elements(index) : elements[index]
      else
          elements[index] || load_element(index)
    end
  end

  def load_element index
    elements[index] = element_source index
  end

  def load_elements range
    iterative_range = if range.end < count
                        iterative_range = range.dup
                      else
                        Range.new range.begin, count-1
                      end
    while iterative_range.count > 0
      limited_range = iterative_range.first(@@load_limit)
      iterative_range = Range.new(
          (
          limited_range.count < @@load_limit ?
              iterative_range.end+1 :
              iterative_range.begin+@@load_limit
          ),
          iterative_range.end
      )
      array = elements_source limited_range.first, limited_range.count
      limited_range.each_with_index do |element, index|
        elements[element] = array[index]
      end
    end
    elements[range]
  end

  class << self

    def load_limit attr=nil
      @@load_limit = attr || 100
    end

  end

end