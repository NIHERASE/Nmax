require 'spec_helper'

RSpec.describe Nmax::StreamDigitScanner do
  describe 'Calls block for each number in stream "_1 2_3.4"' do
    let(:stream) { StringIO.new('_1 2_3.4') }
    subject { described_class.new(stream) }

    it do
      expect { |b| subject.scan(&b) }
        .to yield_successive_args('1', '2', '3', '4')
    end
  end

  describe '#scan' do
    context 'Waits for the end of current number if it`s split '\
            'between chunks (of size 5)' do
      before(:each) do
        stub_const("Nmax::StreamDigitScanner::READ_LIMIT", 5)
      end

      context 'reads chunks "123_5" and "67" as "123" and "567"' do
        let(:stream) { StringIO.new('123_567') }
        subject { described_class.new(stream) }

        it do
          expect { |b| subject.scan(&b) }.to yield_successive_args('123', '567')
        end
      end

      context 'correctly reads numbers larger than chunk size' do
        let(:stream) { StringIO.new('123_567890123456789') }
        subject { described_class.new(stream) }

        it do
          expect { |b| subject.scan(&b) }
            .to yield_successive_args('123', '567890123456789')
        end
      end
    end
  end
end
