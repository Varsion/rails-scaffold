# Rails Scaffold

![Ruby](https://img.shields.io/badge/Ruby-3.1.0-red) ![Rails](https://img.shields.io/badge/Rails-7.0-red)

A Rails development scaffold for me.

## GraphQL

For [graphql-ruby](https://graphql-ruby.org) we can generate the GraphQL files and floder

```shell
 rails generate graphql:install
```

The auto-generated directory structure is not very good for me, so i reorganized the folder logic.

what i did:

- split `resolvers` and `mutatuions`.
- organize the `Types::Base`, i think they are basic.
- make graphql schema as a router file, summarize all `resolvers` and `mutations`.

```shell
✘ tree ./app/graphql
./app/graphql
├── mutations
│   ├── base_mutation.rb
│   ├── ...
├── resolvers
│   ├── base_resolver.rb
│   └── ...
├── *_schema.rb
└── types
    ├── base
    │   ├── argument.rb
    │   ├── ...
    ├── inputs
    │   ├── ...
    ├── *_type.rb
    └── ...
```

and for a new query flow:

- new migration and model is required advance preparation
- create a new type in `./app/graphql/types`, define some need fields
- create a new mutation or resolver
- add the line in router file `./app/graphql/*_schema.rb`
- prepare test cases
- complete the resolver or mutation based on test cases

Btw, I add a email type for argument type with parameter verification.

```ruby
argument :email, Types::Base::Email, required: true
```

## RSpec

Pending......

## Authentication

Pending......

