# Rails Scaffold

![Ruby](https://img.shields.io/badge/Ruby-3.1.0-red) ![Rails](https://img.shields.io/badge/Rails-7.0-red)

A Rails development scaffold for me.

## Get Started

### Overview

- PostgreSQL
- GraphQL
- Rspec with FactoryBotstandardrb
- standardrb

### Qucikly Development

```shell
# Please implement to download&open docker
docker composer-up
```

in `./docker-compose.yml` i prepare the basic database:

- PostgreSQL: username and password is default `postgres`.
- Redis: default settings.

then, update the database settings on `./config/database.yml` if need.

```shell
rails db:create
# bin/rails db:create
```

Create the default database.

```shell
rails db:migrate
# bin/rails db:migrate
```

Run the migration file, i prepare the `User` and basic authentication, pls ref to: [Authentication](#Authentication)

Pls update the `User` miragtion if you need.

---

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

### Premise

- [Rails Sessions](https://edgeguides.rubyonrails.org/security.html#sessions)

- [Rails Credentials](https://www.freshworks.com/eng-blogs/managing-rails-application-secrets-with-encrypted-credentials-blog/)

- [How to use `config/credentials` file in rails](https://dev.to/vishal8236/how-to-use-config-credentials-file-in-rails-j)

### What i did

I store a `secret_key_base` in credentials files.

```ruby
# app/models/user.rb

def login
  JWT.encode({
    user_id: id,
    created_at: DateTime.now.strftime("%Q")
    }, Rails.application.credentials.secret_key_base)
end
```

Generate the token of the logged in user through this method.

And in GraphQL entry file (entry controller)

```ruby
# app/controllers/graphql_controller.rb:50

def current_user
  token = request.headers["Authorization"]
  begin
    data = JWT.decode(token, Rails.application.credentials.secret_key_base)[0]
    user = User.find_by(id: data["user_id"])

    {user: user, token: token}
  rescue JWT::DecodeError
    {}
  end
end
```

I get the `user_id `of the logged in user by getting the token and decrypting it. Then take out all the information of the current user

```ruby
# app/controllers/graphql_controller.rb:12

user_data = current_user.presence || {}
context = user_data.merge(request: request, response: response)
```

And merge the current user infos into the `request_life_cycle` ( `context`

### Regenerate `master.key` & `credentials.yml.enc`

https://gist.github.com/Varsion/db1fc4fc360a684b85034edbc81c70c5

Need to add `secret_key_base` into `credentials.yml.enc` after regeneration.
