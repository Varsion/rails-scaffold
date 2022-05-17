module Types
  class BaseUnion < GraphQL::Schema::Union
    edge_type_class(Types::Base::Edge)
    connection_type_class(Types::Base::Connection)
  end
end
