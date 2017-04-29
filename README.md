# recurring_date

This gem provides an enumerator `RecurringDateEnumerator`, selecting specific dates due to the recursion pattern.

`RecurringDateEnumerator` is lazy so pattern can be applied to an infinite set of dates.

The enumerator operates on objects that implements the `Enumerator#each` and yields `RecurringDate` whitch is a stdlib `Date` on steroids.

## `RecurringDate`

`RecurringDate` inherits from `Date` and adds three methods:

| Method     | Description
|------------|-------------
| `.now`     | It's like `Time.now` but returns `RecurringDate` object.
| `#mweek`   | Returns a number - n'th occurence of the week day in the month.
| `#to_enum` | Returns `RecurringDateEnumerator` enumerator with given range from `self` to 1000 years form now.

## `RecurringDateEnumerator`

The enumerator implements bunch of chainable methods to provide simple DSL for selecting wanted recursion pattern.

| Pattern                                                  | DSL
|----------------------------------------------------------|-----
| dates matching `condition`                               | `enumerator.select { \|d\| condition }`
| dates not matching `condition`                           | `enumerator.reject { \|d\| condition }`
| dates matching `condition` (with index `i`)              | `enumerator.select_with_index { \|d,i\| condition }`
| dates from beginning as long as `condition` is fulfilled | `enumerator.take_while { \|d\| condition }`
| `n` dates from beginning                                 | `enumerator.take(n)`
| every 4th of October                                     | `enumerator.month(10).mday(4)`
| every 3rd and 23rd of August                             | `enumerator.month(8).mday(3, 23)`
| every 17th June and July                                 | `enumerator.month(6, 7).mday(17)`
| every 10th and 12th of February and April                | `enumerator.month(2, 4).mday(10, 12)`
| every 13th of the month                                  | `enumerator.mday(13)`
| every 21st and 23rd of the month                         | `enumerator.mday(21, 23)`
| every Friday                                             | `enumerator.wday(5)`
| every Saturday and Sunday                                | `enumerator.wday(6, 7)`
| every 4th day                                            | `enumerator.pattern(4)`
| every 7th or 10th day                                    | `enumerator.pattern(7, 10)`
| every second Friday                                      | `enumerator.wday(5).pattern(2)`
| every 2nd Monday of the month                            | `enumerator.wday(1).mweek(2)`
| 2nd and 4th Sunday of the month                          | `enumerator.wday(7).mweek(2,4)`
| 3rd Tuesday and Wednesday of the month                   | `enumerator.wday(2,3).mweek(3)`
| until `date`                                             | `enumerator.until(date)`

###### NOTE

* For `rails` models the pattern can be used to select records, like: `Model.where('column::date IN (?)', dates)`.

## Example

    require 'recurring_date'
    rule = RecurringDate.now.to_enum
    rule.wday(5).mweek(1).to_a                              # => all first Fridays of a month
    rule.pattern(2).until(RecurringDate.new(2020,8,1)).to_a # => every second day until 2020-08-01
    rule.wday(6,7).mweek(2,4).take(8).to_a                  # => next four 2nd and 4th weekends of a month
