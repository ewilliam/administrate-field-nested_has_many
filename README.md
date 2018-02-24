# Administrate::Field::NestedHasMany

A plugin for nested has_many forms in [Administrate], forked for rails 5 support.

## Usage

Add to your `Gemfile`:

```ruby
gem "administrate-field-nested_has_many",
      git: "https://github.com/NedelescuVlad/administrate-field-nested_has_many"
```

Run:

```bash
$ bundle install
```

Add to your `application.js`:
```
//=require cocoon
```

Add to your `Foo` model:
```ruby
accepts_nested_attributes_for :bars
```

Add to your `FooDashboard`:
```ruby
ATTRIBUTE_TYPES = [
  bars: Field::NestedHasMany.with_options(skip: :foo),
]
```

The `skip` option takes a single symbol or list of symbols.
It will prevent the nested form from displaying the fields for those attributes.

If a `Customer` `has_many :orders`,
and you want to render `orders` as a nested form on the customer edit page,
then it is generally necessary to add `skip: :customer` to the options
for the `NestedHasMany` field.
Otherwise, Administrate will try to render a field
for the order's `:customer` attribute,
which breaks the nested form logic.

[Administrate]: https://github.com/thoughtbot/administrate
