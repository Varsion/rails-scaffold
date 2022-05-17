class ScaffoldSchema < GraphQL::Schema
  class Query < Types::Base::Object

  end

  class Mutation < Types::Base::Object
    field :create_registration, mutation: Mutations::CreateRegistration
  end

  query Query
  mutation Mutation
end
