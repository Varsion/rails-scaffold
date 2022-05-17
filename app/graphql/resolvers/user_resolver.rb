module Resolvers
  class UserResolver < BaseResolver
    type Types::UserType, null: true

    def resolve
      authenticate_user!
      current_user
    end
  end
end