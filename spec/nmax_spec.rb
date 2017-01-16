require 'spec_helper'

RSpec.describe Nmax do
  it 'has a version number' do
    expect(Nmax::VERSION).not_to be nil
  end

  describe '.in_stream' do
    let(:nmax) { 2 }
    let(:items) { [2, 3, 10] }

    let(:stream) do
      StringIO.new(items.join('_'))
    end

    subject do
      described_class.in_stream(stream, nmax)
    end

    context 'scans for numbers in stream and returns n top of them' do
      it 'returns top numbers' do
        expect(subject.to_a).to eq(['10', '3'])
      end

      it 'returns n numbers' do
        expect(subject.to_a.size).to eq(nmax)
      end
    end
  end

  describe 'StringNumberComparsionProc compares (<=>) 2 strings as '\
           'positive integers' do
    subject { Nmax::StringNumberComparsionProc }

    context 'same sized strings' do
      it '"2" <=> "1" #=> 1' do
        expect(subject.call('2', '1')).to eq(1)
      end

      it '"1" <=> "1" #=> 0' do
        expect(subject.call('1', '1')).to eq(0)
      end

      it '"1" <=> "2" #=> -1' do
        expect(subject.call('1', '2')).to eq(-1)
      end
    end

    context 'strings of different sizes' do
      it '"10" <=> "1" #=> 1' do
        expect(subject.call('10', '1')).to eq(1)
      end

      it '"1" <=> "10" #=> -1' do
        expect(subject.call('1', '10')).to eq(-1)
      end
    end
  end
end
