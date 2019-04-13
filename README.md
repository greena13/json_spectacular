<p align="center">
  <img src="https://svgshare.com/i/CRw.svg" width="200px"><br/>
  <h2 align="center">JSONSpectacular</h2>
</p>

[![Gem](https://img.shields.io/gem/dt/json_spectacular.svg)]()
[![Build Status](https://travis-ci.org/greena13/json_spectacular.svg)](https://travis-ci.org/greena13/json_spectacular)
[![GitHub license](https://img.shields.io/github/license/greena13/json_spectacular.svg)](https://github.com/greena13/json_spectacular/blob/master/LICENSE)

JSON assertions with noise-free reports on complex nested structures.

## Installation

Add this line to your application's Gemfile:

```ruby
group :test do
  gem 'json_spectacular', require: false
end
```

Add `json_spectacular` to your `spec/rails_helper.rb`

```ruby

require 'json_spectacular'

# ...

RSpec.configure do |config|
  # ...

  %i[request controller].each do |spec_type|
    config.include JSONSpectacular::RSpec, type: spec_type
  end
end
```

And then execute:

```bash
bundle install
```

## Usage

### Asserting JSON responses

```ruby
RSpec.describe 'making some valid request', type: :request do
  context 'some important context' do
    it 'should return some complicated JSON' do
      perform_request

      expect(json_response).to eql_json([
        {
            "a" => [
                1, 2, 3
           ],
           "c" => { "d" => "d'"}
        },
        {
            "b" => [
                1, 2, 3
           ],
           "c" => { "d" => "d'"}
        }
      ])
    end
  end
end
```

The `json_response` helper automatically parses the last response object as json, and the assertion `eql_json` reports failures in a format that is much clearer than anything provided by RSpec.

The full `expected` and `actual` values are still reported, but below is a separate report that only includes the paths to the failed nested values and their differences, removing the need to manually compare the two complete objects to find the difference.

## Test suite

`json_spectacular` comes with close-to-complete test coverage. You can run the test suite as follows:

```bash
rspec
```

## Contributing

1. Fork it ( https://github.com/greena13/json_spectacular/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
