# Histomatic

Quick n' dirty histograms for Rails.

## Notice

Currently in development, and only supports the mysql2 driver.

## Usage

Generate a histogram providing an input source, which is either an
ActiveRecord class or instance of ActiveRelation, a column as a string,
and groupings.  

Currently the column must return a numeric.

### Examples

Provide a class:

```ruby
Histomatic.generate(
  Purchase, 
  'amount', 
  [0, 10, 20]
).to_hash # { 0 => 2, 10 => 0, 20 => 0 }
```

Provide an ActiveRelation:

```ruby
Histomatic.generate(
  Purchase.where(:name => 'Chris'), 
  'amount', 
  [0, 10, 20]
).to_hash # { 0 => 1, 10 => 0, 20 => 0 }
```

Provide a transformation as the column:

```ruby
Histomatic.generate(
  Purchase.where(:name => 'Chris'), 
  'datediff(current_date, purchases.created_at)', 
  [0, 10, 20]
).to_hash # { 0 => 0, 10 => 1, 20 => 0 }
```

## License

Histomatic is Copyright © 2012 Christopher Meiklejohn.  Histomatic is
free software, and may be redistributed under the terms specified in the
LICENSE file.
