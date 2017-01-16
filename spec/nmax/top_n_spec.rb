require 'spec_helper'

RSpec.describe Nmax::TopN do
  let(:nmax) { 3 }

  let(:cmp_proc) { proc { |a, b| a <=> b }  }

  describe '#<<' do
    context do
      subject { described_class.new(nmax, &cmp_proc) }

      context 'sorts numbers if nmax limit is not reached' do
        it 'works with single insert' do
          subject << 1
          expect(subject.to_a).to eq([1])
        end

        it 'works with multiple inserts' do
          subject << 1
          subject << 2
          expect(subject.to_a).to eq([2, 1])
        end
      end

      context 'first nmax insetions' do
        context 'sorts insertions' do
          let(:insertions) { [3, 2, 1] }

          it 'desc insertions' do
            insertions.each { |i| subject << i }
            expect(subject.to_a).to eq(insertions)
          end

          it 'asc insertions' do
            insertions.reverse.each { |i| subject << i }
            expect(subject.to_a).to eq(insertions)
          end
        end
      end
    end

    context 'insertions in fulfilled tree move out lower elements' do
      subject do
        top = described_class.new(nmax, &cmp_proc)
        [0, 2, 3].each { |i| top << i }
        top
      end

      it 'largest value inserts in the front' do
        subject << 4
        expect(subject.to_a).to eq([4, 3, 2])
      end

      it 'middle value inserts in the middle' do
        subject << 2
        expect(subject.to_a).to eq([3, 2, 2])
      end

      it 'second least value inserts in the end' do
        subject << 1
        expect(subject.to_a).to eq([3, 2, 1])
      end
    end

    context 'insertion of smaller numbers does not affect fulfilled tree' do
      subject do
        top = described_class.new(nmax, &cmp_proc)
        [1, 2, 3].each { |i| top << i }
        top
      end

      it '[3, 2, 1] does not change if 0 is inserted' do
        subject << 0
        expect(subject.to_a).to eq([3, 2, 1])
      end

      it '[3, 2, 1] does not change if 1 is inserted' do
        subject << 1
        expect(subject.to_a).to eq([3, 2, 1])
      end
    end

    context 'after max_items is reached elements are not checked against '\
            'the tree if they are <= than the last smallest item' do
      subject do
        top = described_class.new(3, &cmp_proc)
        [1, 2, 3].each { |i| top << i }
        top
      end

      it 'elements are added to tree before first overfilling insertion' do
        subject
        expect_any_instance_of(MultiRBTree).to receive(:[]=).and_call_original
        subject << 0
      end

      it 'optimization kicks in after first overfilling insertion' do
        subject << 0
        expect_any_instance_of(MultiRBTree).not_to receive(:[]=).and_call_original
        subject << 0
      end
    end
  end

  describe '#each' do
    subject do
      top = described_class.new(3, &cmp_proc)
      [1, 2, 3].each { |i| top << i }
      top
    end

    it 'iterates over collected max_items in desc order' do
      expect { |b| subject.each(&b) }
        .to yield_successive_args(3, 2, 1)
    end
  end

  describe '#to_a' do
    subject do
      top = described_class.new(3, &cmp_proc)
      [1, 2, 3].each { |i| top << i }
      top
    end

    it 'return array with collected items in desc order' do
      expect(subject.to_a).to eq([3, 2, 1])
    end
  end
end
