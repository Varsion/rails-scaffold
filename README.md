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

- add `json_expectations`

  can use `include_json` like this

```ruby
  expect(response.body).to include_json({
    data: {
      createRegistration: {
        user: {
          name: "test_account",
          email: "test_account@exm.com"
          }
        }
      }
    })
```

- add the `basic_headers` and `user_headers` in `./rspec/rails_helper`

```ruby
  # about headers
  config.include Module.new {
    def basic_headers
      {
        "Content-Type" => "application/json"
      }
    end

    def user_headers(user: @user)
      jwt =
        JWT.encode({
            user_id: user.id,
            created_at: DateTime.now.strftime("%Q")},
            Rails.application.credentials.secret_key_base
          )
        basic_headers.merge("Authorization": jwt)
    end
  }
```

- add `nyan-cat-formatter` when run rspec

```shell
✘ rspec spec/requests/graphql/                               
8/8: -_-_-_-__,------,   
8/8: -_-_-_-__|  /\_/\ 
0/8: -_-_-_-_~|_( - .-)  
0/8: -_-_-_-_ ""  "" 

You've Nyaned for 0.47 seconds


Finished in 0.47107 seconds (files took 1.32 seconds to load)
8 examples, 0 failures
```

- add the faker gem for test data, ref: https://github.com/faker-ruby/faker

## Authentication

Pending......

