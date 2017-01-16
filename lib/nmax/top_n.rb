module Nmax
  class TopN
    def initialize(max_items, &cmp_proc)
      @max_items     = max_items
      @cmp_proc      = cmp_proc
      @tree          = MultiRBTree.new.readjust(cmp_proc)
      @size          = 0
      @last_smallest_item = nil
    end

    def <<(item)
      return if @last_smallest_item &&
                @cmp_proc.call(item, @last_smallest_item) <= 0

      @tree[item] = nil

      if @size < @max_items
        @size += 1
      else
        @last_smallest_item = @tree.shift.first
      end
    end

    def each
      @tree.reverse_each { |k, _| yield k }
    end

    def to_a
      @tree.reverse_each.map { |i, _| i }
    end
  end
end
