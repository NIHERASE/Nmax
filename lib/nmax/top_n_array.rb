module Nmax
  class TopNArray
    def initialize(max_items)
      @max_items    = max_items
      @array        = []
      @least_number = -Float::INFINITY
    end

    def <<(item)
      return if @array.size == @max_items && item < @least_number

      index = @array.bsearch_index { |i| item >= i }

      if index.nil? && @array.size != @max_items
        @array << item
      else
        @array.insert(index, item)
        if @array.size > @max_items
          @array.pop
        end
      end

      @least_number = @array.last

      self
    end

    def to_a
      @array
    end
  end
end
