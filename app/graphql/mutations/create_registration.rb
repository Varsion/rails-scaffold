module Mutations
  class CreateRegistration < Mutations::BaseMutation
    argument :name, String, required: true
    argument :email, Types::Base::Email, required: true
    argument :password, String, required: true

    field :user, Types::UserType, null: true
    field :errors, [Types::Base::ModelError], null: true

    def resolve(input)
      user = User.new(input)
      if user.save && user.errors.blank?
        {user: user}
      else
        {errors: Types::Base::ModelError.errors_of(user)}
      end
    end
  end
end
