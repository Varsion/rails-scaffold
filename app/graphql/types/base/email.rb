# frozen_string_literal: true

module Types
  module Base
    class Email < Scalar
      description "A valid Email"
      def self.coerce_input(input_value, context)
        if input_value.match?(CommonRegexp.email_regexp)
          input_value
        else
          raise GraphQL::CoercionError, "#{input_value} is not a valid email"
        end
      end

      def self.coerce_result(ruby_value, context)
        super
      end
    end
  end
end
