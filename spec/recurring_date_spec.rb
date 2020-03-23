# frozen_string_literal: true

RSpec.describe Date do
  describe '#mweek' do
    subject { date.mweek }

    [1, 1, 1, 1, 1, 1, 1,
     2, 2, 2, 2, 2, 2, 2,
     3, 3, 3, 3, 3, 3, 3,
     4, 4, 4, 4, 4, 4, 4,
     5, 5, 5].each_with_index do |element, index|
      context "mday is #{index + 1}" do
        let(:date) { Date.new(rand(1970..2020), [1,3,5,7,8,10,12].sample, index + 1) }

        it { is_expected.to eq(element) }
      end
    end
  end

  describe '#to_enum' do
    before     { allow(RecurringDate::Enumerator).to receive(:new).and_call_original }
    let(:date) { Date.today }
    subject    { date.to_enum }

    it { is_expected.to be_a(Enumerator) }
    it { is_expected.to be_a(RecurringDate::Enumerator) }
    it { subject; expect(RecurringDate::Enumerator).to have_received(:new) }
  end
end
