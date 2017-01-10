require 'spec_helper'

RSpec.describe Nmax::TopNArray do
  let(:nmax) { 3 }

  describe '#<<' do
    subject { described_class.new(nmax) }

    context 'first nmax insetions' do
      let(:insertions) { [3, 2, 1] }

      it 'sorts first nmax insertions' do
        insertions.each { |i| subject << i }
        expect(subject.to_a).to eq(insertions)
      end

      it 'sorts first nmax insertions' do
        insertions.reverse.each { |i| subject << i }
        expect(subject.to_a).to eq(insertions)
      end
    end

    context 'insertion in full array moves out lower element' do
      subject do
        top = described_class.new(nmax)
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

    context 'insertion of smaller number does not affect the full array' do
      subject do
        top = described_class.new(nmax)
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
  end
end
