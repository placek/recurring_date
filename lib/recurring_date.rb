require_relative 'recurring_date_enumerator'

module RecurringDate
  def mweek
    (mday - 1) / 7 + 1
  end

  def to_enum
    RecurringDateEnumerator.from(self)
  end
end

class Date
  include RecurringDate
end
