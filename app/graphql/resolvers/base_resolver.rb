module Resolvers
  class BaseResolver < GraphQL::Schema::Resolver
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