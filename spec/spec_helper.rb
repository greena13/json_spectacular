# frozen_string_literal: true

RSpec.configure do |config|
  config.filter_run_including focus: true
  # noinspection RubyResolve
  config.run_all_when_everything_filtered = true
end
