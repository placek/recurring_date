require_relative 'spec_helper'

describe RecurringDate do
  describe '#mweek' do
    subject { date.mweek }

    [1, 1, 1, 1, 1, 1, 1,
     2, 2, 2, 2, 2, 2, 2,
     3, 3, 3, 3, 3, 3, 3,
     4, 4, 4, 4, 4, 4, 4,
     5, 5, 5].each_with_index do |element, index|
      context "mday is #{index + 1}" do
        let(:date) { RecurringDate.new(2017, 5, index + 1) }

        it { is_expected.to eq(element) }
      end
    end
  end

  describe '#to_enum' do
    before { allow(RecurringDateEnumerator).to receive(:new).and_call_original }
    let(:date) { RecurringDate.new(2017, 4, 28) }
    subject { date.to_enum }

    it { is_expected.to be_a(Enumerator) }
    it { is_expected.to be_a(RecurringDateEnumerator) }
    it do
      subject
      expect(RecurringDateEnumerator).to have_received(:new).with(date..RecurringDate.new(date.year + 1000))
    end
  end

  describe '.now' do
    before { allow_any_instance_of(Time).to receive(:to_s).and_return('2017-04-28') }
    subject { RecurringDate.now }

    it { is_expected.to be_a(Date) }
    it { is_expected.to be_a(RecurringDate) }
    it { is_expected.to eq(Date.new(2017, 4, 28)) }
  end
end
