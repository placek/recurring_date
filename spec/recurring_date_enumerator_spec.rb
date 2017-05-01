require_relative 'spec_helper'

describe RecurringDateEnumerator do
  let(:enumerator) { RecurringDateEnumerator.new(range) }
  let(:range) { Date.new(2017, 3, 1)..Date.new(2018, 4, 1) }

  it { expect(enumerator).to be_a(Enumerator) }
  it { expect(enumerator).to be_a(RecurringDateEnumerator) }

  describe '#year' do
    subject { enumerator.year(2017).to_a }

    it { expect(subject.map(&:year)).to all(eq(2017)) }
  end

  describe '#month' do
    subject { enumerator.month(4).to_a }

    it { expect(subject.map(&:month)).to all(eq(4)) }
  end

  describe '#mweek' do
    subject { enumerator.mweek(3).to_a }

    it { expect(subject.map(&:mweek)).to all(eq(3)) }
  end

  describe '#wday' do
    subject { enumerator.wday(5).to_a }

    it { expect(subject.map(&:wday)).to all(eq(5)) }
  end

  describe '#mday' do
    subject { enumerator.mday(15).to_a }

    it { expect(subject.map(&:mday)).to all(eq(15)) }
  end

  describe '#yday' do
    subject { enumerator.yday(150).to_a }

    it { expect(subject.map(&:yday)).to all(eq(150)) }
  end

  describe '#not_year' do
    subject { enumerator.not_year(2017).to_a }

    it { expect(subject.map(&:year).uniq).to eq([2018]) }
  end

  describe '#not_month' do
    subject { enumerator.not_month(4).to_a }

    it { expect(subject.map(&:month).uniq).to eq([3, 5, 6, 7, 8, 9, 10, 11, 12, 1, 2]) }
  end

  describe '#not_mweek' do
    subject { enumerator.not_mweek(3).to_a }

    it { expect(subject.map(&:mweek).uniq).to eq([1, 2, 4, 5]) }
  end

  describe '#not_wday' do
    subject { enumerator.not_wday(5).to_a }

    it { expect(subject.map(&:wday).uniq).to eq([3, 4, 6, 0, 1, 2]) }
  end

  describe '#not_mday' do
    subject { enumerator.not_mday(15).to_a }

    it do
      expect(subject.map(&:mday).uniq).to eq([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 16,
                                              17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31])
    end
  end

  describe '#not_yday' do
    subject { enumerator.not_yday(150).to_a }

    it { expect(subject.map(&:yday).uniq.any? { |e| e == 150 }).to eq(false) }
  end

  describe '#take' do
    subject { enumerator.take(10).to_a }

    it { expect(subject.count).to eq(10) }
  end

  describe '#take_while' do
    subject { enumerator.take_while { |d| d.month < 12 }.to_a }

    it { expect(subject.count).to eq(275) }
    it { expect(subject.map(&:year).uniq).to eq([2017]) }
    it { expect(subject.map(&:month).uniq).to eq([3, 4, 5, 6, 7, 8, 9, 10, 11]) }
  end

  describe '#select' do
    subject { enumerator.select { |d| d.month < 12 }.to_a }

    it { expect(subject.count).to eq(366) }
    it { expect(subject.map(&:year).uniq).to eq([2017, 2018]) }
    it { expect(subject.map(&:month).uniq).to eq([3, 4, 5, 6, 7, 8, 9, 10, 11, 1, 2]) }
  end

  describe '#select_with_index' do
    subject { enumerator.select_with_index { |_d, i| i % 3 == 0 }.to_a }

    it { expect(subject.count).to eq(133) }
    it { expect(subject.map(&:year).uniq).to eq([2017, 2018]) }
    it { expect(subject.map(&:month).uniq).to eq([3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 1, 2]) }
  end

  describe '#reject' do
    subject { enumerator.reject { |d| d.month < 12 }.to_a }

    it { expect(subject.count).to eq(31) }
    it { expect(subject.map(&:year).uniq).to eq([2017]) }
    it { expect(subject.map(&:month).uniq).to eq([12]) }
  end

  describe '#until' do
    subject { enumerator.until(Date.new(2018, 5, 1)).to_a }

    it { expect(subject).to all(be <= Date.new(2018, 5, 1)) }
  end

  describe '#pattern' do
    subject { enumerator.pattern(3, 5).to_a }

    it { expect(subject.count).to eq(185) }
    it { expect(subject.map(&:year).uniq).to eq([2017, 2018]) }
    it { expect(subject.map(&:month).uniq).to eq([3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 1, 2]) }
  end
end
