module Nmax
  class TopNArray
    def initialize(max_items)
      @max_items = max_items
      @array     = [-(1/0.0)]
    end

    def <<(item)
      return if item < @array.last && @array.size == @max_items

      index = @array.bsearch_index { |i| item >= i }

      if index.nil? && @array.empty?
        @array << item
      else
        @array.insert(index, item)
        if @array.size > @max_items
          @array.pop
        end
      end
    end

    def to_a
      @array
    end
  end
end
