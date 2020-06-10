# frozen_string_literal: true

require 'hashdiff'

module JSONSpectacular
  module DiffDescriptions
    def self.included(base) # rubocop:disable Metrics/MethodLength
      base.class_eval do # rubocop:disable Metrics/BlockLength
        # Adds diff descriptions to the failure message until the all the nodes of the
        # expected and actual values have been compared, and all the differences (and the
        # paths to them) have been included.
        #
        # For Hashes and Arrays, it recursively calls itself to compare all nodes and
        # elements.
        #
        # @param [String, Number, Boolean, Array, Hash] actual_value current node of the
        #        actual value being compared to the corresponding node of the expected
        #        value
        # @param [String, Number, Boolean, Array, Hash] expected_value current node of
        #        the expected value being compared to the corresponding node of the
        #        actual value
        # @param [String] path path to the current nodes being compared, relative to the
        #        root full objects
        # @return void Diff descriptions are appended directly to message
        def add_diff_to_message(actual_value, expected_value, path = '')
          diffs_sorted_by_name = Hashdiff
                                 .diff(actual_value, expected_value)
                                 .sort_by { |a| a[1] }

          diffs_grouped_by_name =
            diffs_sorted_by_name.each_with_object({}) do |diff, memo|
              operator, name, value = diff
              memo[name] ||= {}
              memo[name][operator] = value
            end

          diffs_grouped_by_name.each do |name, difference|
            resolve_and_append_diff_to(
              path, name, expected_value, actual_value, difference
            )
          end
        end

        def resolve_and_append_diff_to(
          path,
          name,
          expected_value,
          actual_value,
          difference
        )
          extra_value, missing_value, different_value =
            resolve_changes(difference, expected_value, actual_value, name)

          full_path = !path.empty? ? "#{path}.#{name}" : name

          if non_empty_hash?(missing_value) && non_empty_hash?(extra_value)
            add_diff_to_message(missing_value, extra_value, full_path)
          elsif non_empty_array?(missing_value) && non_empty_array?(extra_value)
            [missing_value.length, extra_value.length].max.times do |i|
              add_diff_to_message(missing_value[i], extra_value[i], full_path)
            end
          elsif difference.key?('~')
            value = value_at_path(expected_value, name)
            append_diff_to_message(full_path, value, different_value)
          else
            append_diff_to_message(full_path, extra_value, missing_value)
          end
        end

        def resolve_changes(difference, expected_value, actual_value, name)
          missing_value = difference['-'] || value_at_path(actual_value, name)
          extra_value = difference['+'] || value_at_path(expected_value, name)
          different_value = difference['~']

          [extra_value, missing_value, different_value]
        end

        def append_diff_to_message(path, expected, actual)
          append_to_message(
            path,
            get_diff(path, expected: expected, actual: actual)
          )
        end

        def non_empty_hash?(target)
          target.is_a?(Hash) && target.any?
        end

        def non_empty_array?(target)
          target.is_a?(Array) && target.any?
        end

        def append_to_message(attribute, diff_description)
          return if already_reported_difference?(attribute)

          @message += diff_description
          @reported_differences[attribute] = true
        end

        def already_reported_difference?(attribute)
          @reported_differences.key?(attribute)
        end

        def value_at_path(target, attribute_path)
          keys = attribute_path.split(/[\[\].]/)

          keys = keys.map do |key|
            if key.to_i.zero? && key != '0'
              key
            else
              key.to_i
            end
          end

          result = target

          keys.each do |key|
            result = result[key] unless key == ''
          end

          result
        end

        def get_diff(attribute, options = {})
          diff_description = ''
          diff_description += "#{attribute}\n"
          diff_description += "Expected: #{format_value(options[:expected])}\n"
          diff_description + "Actual: #{format_value(options[:actual])}\n\n"
        end

        def format_value(value)
          if value.is_a?(String)
            "'#{value}'"
          else
            value
          end
        end
      end
    end
  end
end
