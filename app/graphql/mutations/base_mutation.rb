module Mutations
  class BaseMutation < GraphQL::Schema::RelayClassicMutation
    argument_class Types::Base::Argument
    field_class Types::Base::Field
    input_object_class Types::Base::InputObject
    object_class Types::Base::Object

    protected

    def authenticate_user!
      raise GraphQL::ExecutionError, "unauthenticated" unless current_user
    end

    private

    def current_user
      @current_user ||= context[:user]
    end
  end
end
