module Types
  class UserType < Types::Base::Object
    field :id, ID, null: false
    field :name, String, null: true
    field :email, String, null: false
    field :token, String, null: true
  end
end
