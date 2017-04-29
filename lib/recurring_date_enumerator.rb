require 'date'

class RecurringDateEnumerator < Enumerator
  def initialize(range)
    super() do |result|
      begin
        range.each { |val| block_given? ? yield(result, val) : result << val }
      rescue StopIteration
        nil
      end
    end
  end

  def yday(*args)
    select { |date| args.include?(date.yday) }
  end

  def mday(*args)
    select { |date| args.include?(date.mday) }
  end

  def wday(*args)
    select { |date| args.include?(date.wday) }
  end

  def mweek(*args)
    select { |date| args.include?(date.mweek) }
  end

  def month(*args)
    select { |date| args.include?(date.month) }
  end

  def year(*args)
    select { |date| args.include?(date.year) }
  end

  def pattern(*args)
    select_with_index do |_, i|
      args.any? do |arg|
        ((i + 1) % arg).zero?
      end
    end
  end

  def until(arg)
    take_while { |date| date <= arg.to_date }
  end

  def select_with_index
    index = 0
    RecurringDateEnumerator.new(self) do |result, value|
      result << value if yield(value, index)
      index += 1
    end
  end

  def select
    RecurringDateEnumerator.new(self) { |result, value| result << value if yield(value) }
  end

  def reject
    RecurringDateEnumerator.new(self) { |result, value| result << value unless yield(value) }
  end

  def take(n)
    taken = n
    RecurringDateEnumerator.new(self) do |result, value|
      raise StopIteration if taken.zero?
      result << value
      taken -= 1
    end
  end

  def take_while
    RecurringDateEnumerator.new(self) do |result, value|
      raise StopIteration unless yield(value)
      result << value
    end
  end

  def inspect
    ['#<RecurringDateEnumerator: 0x', object_id, '>'].join
  end
end
