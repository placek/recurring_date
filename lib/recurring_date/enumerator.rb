require 'date'

module RecurringDate
  class Enumerator < ::Enumerator
    def initialize(range)
      super() do |result|
        begin
          range.each { |val| block_given? ? yield(result, val) : result << val }
        rescue ::StopIteration
          nil
        end
      end
    end

    def self.eternity
      from(Date.new(1970))
    end

    def self.from(date)
      RecurringDate::Enumerator.new(infinity(date))
    end

    def yday(*args)
      matching(*args, &:yday)
    end

    def mday(*args)
      matching(*args, &:mday)
    end

    def wday(*args)
      matching(*args, &:wday)
    end

    def mweek(*args)
      matching(*args, &:mweek)
    end

    def month(*args)
      matching(*args, &:month)
    end

    def year(*args)
      matching(*args, &:year)
    end

    def not_yday(*args)
      not_matching(*args, &:yday)
    end

    def not_mday(*args)
      not_matching(*args, &:mday)
    end

    def not_wday(*args)
      not_matching(*args, &:wday)
    end

    def not_mweek(*args)
      not_matching(*args, &:mweek)
    end

    def not_month(*args)
      not_matching(*args, &:month)
    end

    def not_year(*args)
      not_matching(*args, &:year)
    end

    def matching(*args)
      select { |date| args.include?(yield(date)) }
    end

    def not_matching(*args)
      reject { |date| args.include?(yield(date)) }
    end

    def pattern(*args)
      select_with_index do |_, i|
        args.any? { |arg| ((i + 1) % arg).zero? }
      end
    end

    def until(arg)
      take_while { |date| date <= arg.to_date }
    end

    def select_with_index
      index = 0
      RecurringDate::Enumerator.new(self) do |result, value|
        result << value if yield(value, index)
        index += 1
      end
    end

    def select
      RecurringDate::Enumerator.new(self) { |result, value| result << value if yield(value) }
    end

    def reject
      RecurringDate::Enumerator.new(self) { |result, value| result << value unless yield(value) }
    end

    def take(n)
      taken = n
      RecurringDate::Enumerator.new(self) do |result, value|
        raise ::StopIteration if taken.zero?
        result << value
        taken -= 1
      end
    end

    def take_while
      RecurringDate::Enumerator.new(self) do |result, value|
        raise ::StopIteration unless yield(value)
        result << value
      end
    end

    def inspect
      ['#<RecurringDate::Enumerator:0x', object_id, '>'].join
    end

    def self.infinity(date)
      ::Enumerator.new do |y|
        i = date.prev_day
        loop { y << (i = i.next) }
      end
    end
  end
end
