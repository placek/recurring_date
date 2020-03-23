# frozen_string_literal: true

RSpec.describe RecurringDate::Enumerator do
  let(:enumerator) { described_class.new(range) }
  let(:start_date) { Date.new(1970) }
  let(:end_date)   { Date.today }
  let(:range)      { start_date..end_date }

  it { expect(enumerator).to be_a(Enumerator) }
  it { expect(enumerator).to be_a(RecurringDate::Enumerator) }

  describe '#year' do
    let(:value) { rand(1970..Date.today.year) }
    subject     { enumerator.year(value).to_a }

    it { expect(subject.map(&:year)).to all(eq(value)) }
  end

  describe '#month' do
    let(:value) { rand(1..12) }
    subject     { enumerator.month(value).to_a }

    it { expect(subject.map(&:month)).to all(eq(value)) }
  end

  describe '#mweek' do
    let(:value) { rand(1..5) }
    subject     { enumerator.mweek(value).to_a }

    it { expect(subject.map(&:mweek)).to all(eq(value)) }
  end

  describe '#wday' do
    let(:value) { rand(0..6) }
    subject     { enumerator.wday(value).to_a }

    it { expect(subject.map(&:wday)).to all(eq(value)) }
  end

  describe '#mday' do
    let(:value) { rand(1..31) }
    subject     { enumerator.mday(value).to_a }

    it { expect(subject.map(&:mday)).to all(eq(value)) }
  end

  describe '#yday' do
    let(:value) { rand(1..366) }
    subject     { enumerator.yday(value).to_a }

    it { expect(subject.map(&:yday)).to all(eq(value)) }
  end

  describe '#not_year' do
    let(:value) { rand(1970..Date.today.year) }
    subject     { enumerator.not_year(value).to_a }

    it { is_expected.to all(satisfy { |date| date.year != value }) }
  end

  describe '#not_month' do
    let(:value) { rand(1..12) }
    subject     { enumerator.not_month(value).to_a }

    it { is_expected.to all(satisfy { |date| date.month != value }) }
  end

  describe '#not_mweek' do
    let(:value) { rand(1..5) }
    subject     { enumerator.not_mweek(value).to_a }

    it { is_expected.to all(satisfy { |date| date.mweek != value }) }
  end

  describe '#not_wday' do
    let(:value) { rand(0..6) }
    subject     { enumerator.not_wday(value).to_a }

    it { is_expected.to all(satisfy { |date| date.wday != value }) }
  end

  describe '#not_mday' do
    let(:value) { rand(1..31) }
    subject     { enumerator.not_mday(value).to_a }

    it { is_expected.to all(satisfy { |date| date.mday != value }) }
  end

  describe '#not_yday' do
    let(:value) { rand(1..31) }
    subject     { enumerator.not_yday(value).to_a }

    it { is_expected.to all(satisfy { |date| date.yday != value }) }
  end

  describe '#take' do
    let(:count) { rand(5..99) }
    subject     { enumerator.take(count).to_a }

    it { expect(subject.count).to eq(count) }
  end

  describe '#take_while' do
    let(:value) { rand(1..12) }
    subject     { enumerator.take_while { |d| d.month < value }.to_a }

    it { is_expected.to all(satisfy { |date| date.month < value }) }
  end

  describe '#select' do
    let(:value) { rand(1..12) }
    subject     { enumerator.select { |d| d.month < value }.to_a }

    it { is_expected.to all(satisfy { |date| date.month < value }) }
  end

  describe '#select_with_index' do
    let(:arg) { rand(1..100) }
    subject   { enumerator.select_with_index { |_d, i| i % arg == 0 }.to_a }

    it { is_expected.to all(satisfy { |date| (date - start_date) % arg == 0 }) }
  end

  describe '#reject' do
    let(:value) { rand(1..12) }
    subject     { enumerator.reject { |d| d.month < value }.to_a }

    it { is_expected.to all(satisfy { |date| date.month >= value }) }
  end

  describe '#until' do
    let(:date) { range.to_a.sample }
    subject    { enumerator.until(date).to_a }

    it { expect(subject).to all(be <= date) }
  end

  describe '#pattern' do
    let(:args) { Array.new(rand(1..10)) { rand(1..100) }.uniq }
    subject    { enumerator.pattern(*args).to_a }

    it { is_expected.to all(satisfy { |date| args.any? { |arg| (date - start_date + 1) % arg == 0 } }) }
  end
end
