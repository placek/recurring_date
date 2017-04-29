require_relative 'recurring_date_enumerator'

class RecurringDate < Date
  def mweek
    (mday - 1) / 7 + 1
  end

  def to_enum
    RecurringDateEnumerator.new(self..distant_future)
  end

  def self.now
    parse(Time.zone.now.to_s)
  end

  def inspect
    to_s
  end

  private

  def distant_future
    RecurringDate.new(year + 1000)
  end
end
