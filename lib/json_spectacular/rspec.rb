# frozen_string_literal: true

require 'json_spectacular/matcher'

module JSONSpectacular
  # Module containing JSON helper methods that can be mixed into RSpec test scope
  #
  # @author Aleck Greenham
  module RSpec
    # Parses the last response body in a Rails RSpec controller or request test as JSON
    #
    # @return [Hash{String => Boolean, String, Number, Hash, Array}] Ruby representation
    #         of the JSON response body.
    def json_response
      JSON.parse(response.body)
    rescue JSON::ParserError
      '< INVALID JSON RESPONSE >'
    end

    # Creates a new JSONSpectacular::Matcher instance so it can be passed to RSpec to
    # match <tt>expected</tt> against an actual value.
    #
    # @see JSONSpectacular::Matcher
    #
    # @example Use the eql_json expectation
    #   expect(actual).to eql_json(expected)
    #
    # @example Use the eql_json expectation with json_response
    #   expect(json_response).to eql_json(expected)
    #
    # @param [Boolean, Hash, String, Number, Array] expected The expected value the RSpec
    #        matcher should match against.
    # @return [JSONSpectacular::Matcher] New matcher object
    def eql_json(expected)
      JSONSpectacular::Matcher.new(expected)
    end
  end
end
