# frozen_string_literal: true

require 'json_spectacular/diff_descriptions'

module JSONSpectacular
  # Backing class for the eql_json RSpec matcher. Used for matching Ruby representations
  # of JSON response bodies. Provides clear diff representations for simple and complex
  # or nested JSON objects, highlighting only the values that are different, and where
  # they are in the larger JSON object.
  #
  # Expected to be used as part of a RSpec test suite and with
  # {JSONSpectacular::RSpec#json_response}.
  #
  # @see JSONSpectacular::RSpec#json_response
  # @see JSONSpectacular::RSpec#eql_json
  #
  # @author Aleck Greenham
  class Matcher
    include DiffDescriptions

    # Creates a new JSONSpectacular::Matcher object.
    #
    # @see JSONSpectacular::RSpec#eql_json
    #
    # @param [String, Number, Boolean, Array, Hash] expected The expected value that will
    #        be compared with the actual value
    # @return [JSONSpectacular::Matcher] New matcher object
    def initialize(expected)
      @expected = expected
      @message = ''
      @reported_differences = {}
    end

    # Declares that RSpec should not attempt to diff the actual and expected values
    # to put in the failure message. This class takes care of diffing and presenting
    # the differences, itself.
    # @return [false] Always false
    def diffable?
      false
    end

    # Whether the actual value and the expected value are considered equal.
    # @param [String, Number, Boolean, Array, Hash] actual The value to be compared to
    #        <tt>expected</tt> for equality
    # @return [Boolean] True when <tt>actual</tt> equals <tt>expected</tt>.
    def matches?(actual)
      @actual = actual
      @expected.eql?(@actual)
    end

    # Message to display to StdOut by RSpec if the equality check fails. Includes a
    # complete serialisation of <tt>expected</tt> and <tt>actual</tt> values and is
    # then followed by a description of only the (possibly deeply nested) attributes
    # that are different
    # @return [String] message full failure message with explanation of why actual
    #         failed the equality check with expected
    def failure_message
      @message += "Expected: #{@expected}\n\n"
      @message += "Actual: #{@actual}\n\n"
      @message += "Differences\n\n"

      add_diff_to_message(@actual, @expected)

      @message
    end
  end
end
