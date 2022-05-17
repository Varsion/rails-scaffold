module Types
    module Base
      class ModelError < Types::Base::Object
        description "ActiveModel::Errors"

        field :attribute, String, null: true
        field :message, String, null: false

        class << self
          def errors_of(model)
            model.errors.collect do |error|
              format(error.attribute, error.message)
            end
          end
  
          def format(attribute, message)
            {
              attribute: attribute.to_s,
              message: message
            }
          end
        end
      end
    end
  end
  