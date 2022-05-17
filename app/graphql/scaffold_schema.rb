class ScaffoldSchema < GraphQL::Schema
  class Query < Types::Base::Object

  end

  class Mutation < Types::Base::Object

  end

  query Query
  mutation Mutation
end
