module Mutations
  class CreateSession < Mutations::BaseMutation
    argument :email, Types::Base::Email, required: true
    argument :password, String, required: true

    field :user, Types::UserType, null: true
    field :errors, [Types::Base::ModelError], null: true

    def resolve(input)
      user = User.find_by(email: input[:email])
      if user && user.authenticate(input[:password])
        token = user.login
        {
          user: {
            id: user.id,
            name: user.name,
            email: user.email,
            token: token
          }
        }
      else
        {errors: [{attribute: "user", message: "Invalid email or password"}]}
      end
    end
  end
end
