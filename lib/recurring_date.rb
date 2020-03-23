# frozen_string_literal: true

require 'recurring_date/enumerator'

module RecurringDate
  def mweek
    (mday - 1) / 7 + 1
  end

  def to_enum
    RecurringDate::Enumerator.from(self)
  end
end

class Date
  include RecurringDate
end
