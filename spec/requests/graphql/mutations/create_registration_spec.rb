require "rails_helper"

RSpec.describe "GraphQL - Create Registration Mutations", type: :request do
  let(:query) do
    "
      mutation CreateRegistration($input: CreateRegistrationInput!) {
        createRegistration(input: $input) {
          user {
            id
            name
            email
          }
          errors {
            attribute
            message
          }
        }
      }
    "
  end

  it "work! register success" do
    post "/graphql",
      params: {
        query: query, 
        variables: {
          input: {
            name: "test_account",
            email: "test_account@exm.com",
            password: "test_account_pwd"
          }
        }
      }.to_json, headers: basic_headers
    expect(response.status).to eq 200
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
  end

  it "work! argument - email check failed" do
    post "/graphql",
      params: {
        query: query, 
        variables: {
          input: {
            name: "test_account",
            email: "test_account",
            password: "test_account_pwd"
          }
        }
      }.to_json, headers: basic_headers
    expect(response.status).to eq 200
    expect(response.body).to include_json({
      errors: [{
        message: "Variable $input of type CreateRegistrationInput! was provided invalid value for email (test_account is not a valid email)"
      }]
    })
  end

  it "work! email already exists" do
    user = create(:user)
    post "/graphql",
      params: {
        query: query, 
        variables: {
          input: {
            name: "test_account",
            email: user.email,
            password: "test_account_pwd"
          }
        }
      }.to_json, headers: basic_headers
    expect(response.status).to eq 200
    expect(response.body).to include_json({
      data: {
        createRegistration: {
          errors: [{
            attribute: "email",
            message: "has already been taken"
          }]
        }
      }
    })
  end
end