class ScaffoldSchema < GraphQL::Schema
  class Query < Types::Base::Object

  end

  class Mutation < Types::Base::Object
    field :create_registration, mutation: Mutations::CreateRegistration
    field :create_session, mutation: Mutations::CreateSession
  end

  query Query
  mutation Mutation
end
