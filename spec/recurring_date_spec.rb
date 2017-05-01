require_relative 'spec_helper'

describe Date do
  describe '#mweek' do
    subject { date.mweek }

    [1, 1, 1, 1, 1, 1, 1,
     2, 2, 2, 2, 2, 2, 2,
     3, 3, 3, 3, 3, 3, 3,
     4, 4, 4, 4, 4, 4, 4,
     5, 5, 5].each_with_index do |element, index|
      context "mday is #{index + 1}" do
        let(:date) { Date.new(2017, 5, index + 1) }

        it { is_expected.to eq(element) }
      end
    end
  end

  describe '#to_enum' do
    before { allow(RecurringDateEnumerator).to receive(:new).and_call_original }
    let(:date) { Date.new(2017, 4, 28) }
    subject { date.to_enum }

    it { is_expected.to be_a(Enumerator) }
    it { is_expected.to be_a(RecurringDateEnumerator) }
    it do
      subject
      expect(RecurringDateEnumerator).to have_received(:new)
    end
  end
end
