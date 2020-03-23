# recurring_date

[![Gem Version](https://badge.fury.io/rb/recurring_date.svg)](https://badge.fury.io/rb/recurring_date)
[![Build Status](https://travis-ci.org/placek/recurring_date.svg?branch=master)](https://travis-ci.org/placek/recurring_date)
[![Maintainability](https://api.codeclimate.com/v1/badges/8b2339034c78677126e7/maintainability)](https://codeclimate.com/github/placek/recurring_date/maintainability)

Iterate over a set of dates, giving an iteration conditions.

This gem provides an enumerator `RecurringDate::Enumerator`, selecting specific dates due to the recursion pattern.

`RecurringDate::Enumerator` is lazy so pattern can be applied to an infinite set of dates.

The enumerator operates on objects that implements the `Enumerator#each` and yields `Date`.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'recurring_date'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install recurring_date

## Usage


### `RecurringDate`

`RecurringDate` module adds two methods to class `Date`:

| Method     | Description
|------------|-------------
| `#mweek`   | Returns a number - n'th occurence of the week day in the month.
| `#to_enum` | Returns `RecurringDate::Enumerator` enumerator with given range from `self` iterating forever (infinite set).

### `RecurringDate::Enumerator`

The enumerator implements bunch of chainable methods to provide simple DSL for selecting wanted recursion pattern.

| Pattern                                                  | DSL
|----------------------------------------------------------|-----
| dates matching `condition`                               | `enumerator.select { ❘d❘ condition }`
| dates not matching `condition`                           | `enumerator.reject { ❘d❘ condition }`
| dates matching `condition` (with index `i`)              | `enumerator.select_with_index { ❘d, i❘ condition }`
| dates from beginning as long as `condition` is fulfilled | `enumerator.take_while { ❘d❘ condition }`
| `n` dates from beginning                                 | `enumerator.take(n)`
| every 4th of October                                     | `enumerator.month(10).mday(4)`
| every 3rd and 23rd of August                             | `enumerator.month(8).mday(3, 23)`
| every 17th June and July                                 | `enumerator.month(6, 7).mday(17)`
| every 10th and 12th of February and April                | `enumerator.month(2, 4).mday(10, 12)`
| every 13th of the month                                  | `enumerator.mday(13)`
| every 21st and 23rd of the month                         | `enumerator.mday(21, 23)`
| every Friday                                             | `enumerator.wday(5)`
| every Saturday and Sunday                                | `enumerator.wday(6, 0)`
| every Saturday and Sunday                                | `enumerator.matching(6, 0) { ❘d❘ d.wday }`
| every Saturday and Sunday                                | `enumerator.matching(6, 0, &:wday)`
| every 4th day                                            | `enumerator.pattern(4)`
| every 7th or 10th day                                    | `enumerator.pattern(7, 10)`
| every second Friday                                      | `enumerator.wday(5).pattern(2)`
| every 2nd Monday of the month                            | `enumerator.wday(1).mweek(2)`
| 2nd and 4th Sunday of the month                          | `enumerator.wday(0).mweek(2,4)`
| 3rd Tuesday and Wednesday of the month                   | `enumerator.wday(2,3).mweek(3)`
| until `date`                                             | `enumerator.until(date)`

###### NOTE

* There is a method `RecurringDate::Enumerator.eternity` that returns `RecurringDate::Enumerator` instance that iterates perpetualy over every day after _1970-01-01_.
* The `RecurringDate::Enumerator.from(date)` method does the same, but from `date`.
* Every enumerator method (except `select`, `select_with_index`, `reject`, `take`, `take_while` and `until`) has a corresponding method with `not_` prefix.
* For `rails` models the pattern can be used to select records, like: `Model.where('column::date IN (?)', dates)`.

### Example

    require 'recurring_date'
    rule = RecurringDate::Enumerator.eternity
    rule.wday(5).mweek(1)                       # => enumerator of all first Fridays of a month
    rule.pattern(2).until(Date.new(2020, 8, 1)) # => enumerator of every second day until 2020-08-01
    rule.wday(6,0).mweek(2,4).take(8)           # => enumerator of next four 2nd and 4th weekends of a month
    rule.to_a                                   # => array of `Date` instances (be careful - it can be infinite)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `lib/recurring_date/version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/placek/recurring_date.
