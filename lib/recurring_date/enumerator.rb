# frozen_string_literal: true

require 'date'

module RecurringDate
  # The enumerator over the dates.
  class Enumerator < ::Enumerator
    # Initiate the enumerator.
    def initialize(range)
      super() do |result|
        range.each { |val| block_given? ? yield(result, val) : result << val }
      rescue ::StopIteration
        nil
      end
    end

    # Returns a lazy, perpetual enumerator over dates, day by day, from 1st January 1970.
    def self.eternity
      from(Date.new(1970))
    end

    # Returns a lazy, perpetual enumerator over dates, day by day, from +date+.
    # @param date [Date]
    def self.from(date)
      raise ::ArgumentError, 'not a date' unless date.is_a?(::Date)

      RecurringDate::Enumerator.new(infinity(date))
    end

    # Filter dates by a +yday+ of a date.
    # @param args [Array] +yday+s
    def yday(*args)
      raise ::ArgumentError, 'not an integer' unless args.all? { |arg| arg.is_a?(::Integer) }

      matching(*args, &:yday)
    end

    # Filter dates by a +mday+ of a date.
    # @param args [Array] +mday+s
    def mday(*args)
      raise ::ArgumentError, 'not an integer' unless args.all? { |arg| arg.is_a?(::Integer) }

      matching(*args, &:mday)
    end

    # Filter dates by a +wday+ of a date.
    # @param args [Array] +wday+s
    def wday(*args)
      raise ::ArgumentError, 'not an integer' unless args.all? { |arg| arg.is_a?(::Integer) }

      matching(*args, &:wday)
    end

    # Filter dates by a +mweek+ of a date.
    # @param args [Array] +mweek+s
    def mweek(*args)
      raise ::ArgumentError, 'not an integer' unless args.all? { |arg| arg.is_a?(::Integer) }

      matching(*args, &:mweek)
    end

    # Filter dates by a +month+ of a date.
    # @param args [Array] +month+s
    def month(*args)
      raise ::ArgumentError, 'not an integer' unless args.all? { |arg| arg.is_a?(::Integer) }

      matching(*args, &:month)
    end

    # Filter dates by a +year+ of a date.
    # @param args [Array] +year+s
    def year(*args)
      raise ::ArgumentError, 'not an integer' unless args.all? { |arg| arg.is_a?(::Integer) }

      matching(*args, &:year)
    end

    # Filter dates not maching +yday+.
    # @param args [Array] +yday+s
    def not_yday(*args)
      raise ::ArgumentError, 'not an integer' unless args.all? { |arg| arg.is_a?(::Integer) }

      not_matching(*args, &:yday)
    end

    # Filter dates not maching +mday+.
    # @param args [Array] +mday+s
    def not_mday(*args)
      raise ::ArgumentError, 'not an integer' unless args.all? { |arg| arg.is_a?(::Integer) }

      not_matching(*args, &:mday)
    end

    # Filter dates not maching +wday+.
    # @param args [Array] +wday+s
    def not_wday(*args)
      raise ::ArgumentError, 'not an integer' unless args.all? { |arg| arg.is_a?(::Integer) }

      not_matching(*args, &:wday)
    end

    # Filter dates not maching +mweek+.
    # @param args [Array] +mweek+s
    def not_mweek(*args)
      raise ::ArgumentError, 'not an integer' unless args.all? { |arg| arg.is_a?(::Integer) }

      not_matching(*args, &:mweek)
    end

    # Filter dates not maching +month+.
    # @param args [Array] +month+s
    def not_month(*args)
      raise ::ArgumentError, 'not an integer' unless args.all? { |arg| arg.is_a?(::Integer) }

      not_matching(*args, &:month)
    end

    # Filter dates not maching +year+.
    # @param args [Array] +year+s
    def not_year(*args)
      raise ::ArgumentError, 'not an integer' unless args.all? { |arg| arg.is_a?(::Integer) }

      not_matching(*args, &:year)
    end

    # Filter dates that matches +args+ with yielded block.
    # @param args [Array] arguments that are compared to the expession in given block.
    def matching(*args)
      select { |date| args.include?(yield(date)) }
    end

    # Filter dates that do not match +args+ with yielded block.
    # @param args [Array] arguments that are compared to the expession in given block.
    def not_matching(*args)
      reject { |date| args.include?(yield(date)) }
    end

    # Filter dates by the sequence of occurences.
    # @param args [Array] occurence schema
    def pattern(*args)
      select_with_index do |_, i|
        args.any? { |arg| ((i + 1) % arg).zero? }
      end
    end

    # Set upper bound of the date range (make the enumerator finite).
    # @param date [Date]
    def until(date)
      raise ::ArgumentError, 'not a date' unless date.is_a?(::Date)

      take_while { |obj| obj <= date }
    end

    # Filter dates by condition in given block. Yields a date and its index.
    def select_with_index
      index = 0
      RecurringDate::Enumerator.new(self) do |result, value|
        result << value if yield(value, index)
        index += 1
      end
    end

    # Filter dates by condition in given block.
    def select
      RecurringDate::Enumerator.new(self) { |result, value| result << value if yield(value) }
    end

    # Filter dates by condition in given block. Opposite to +select+.
    def reject
      RecurringDate::Enumerator.new(self) { |result, value| result << value unless yield(value) }
    end

    # Take only +number+ of dates.
    # @param number [Integer]
    def take(number)
      raise ::ArgumentError, 'not an integer' unless number.is_a?(::Integer)

      taken = number
      RecurringDate::Enumerator.new(self) do |result, value|
        raise ::StopIteration if taken.zero?

        result << value
        taken -= 1
      end
    end

    # Take only dates until the expression in given block has been met.
    def take_while
      RecurringDate::Enumerator.new(self) do |result, value|
        raise ::StopIteration unless yield(value)

        result << value
      end
    end

    # Dummy inspect for enumerator.
    def inspect
      ['#<RecurringDate::Enumerator:0x', object_id, '>'].join
    end

    # The actual enumerator.
    # The +infinity+ method returns an Enumerator that iterates over a dates, day by day, starting from +date+.
    # @param date [Date] starting date
    def self.infinity(date)
      raise ::ArgumentError, 'not a date' unless date.is_a?(::Date)

      ::Enumerator.new do |y|
        i = date.prev_day
        loop { y << (i = i.next) }
      end
    end
  end
end
