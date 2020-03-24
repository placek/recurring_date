# frozen_string_literal: true

require 'recurring_date/enumerator'

# The RecurringDate module is extension to Date class.
module RecurringDate
  # The week number of the month.
  def mweek
    (mday - 1) / 7 + 1
  end

  # Initiate a lazy, perpetual enumerator over all dates, day by day, after +self+ (including +self+).
  def to_enum
    RecurringDate::Enumerator.from(self)
  end
end

class Date
  include RecurringDate
end
