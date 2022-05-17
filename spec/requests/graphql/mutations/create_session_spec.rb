require "rails_helper"

RSpec.describe "GraphQL - Create Session Mutations", type: :request do

  before :each do
    @user = create(:user)
  end

  let(:query) do
    "
      mutation CreateSession($input: CreateSessionInput!) {
        createSession(input: $input) {
          user {
            token
          }
          errors {
            attribute
            message
          }
        }
      }
    "
  end

  it "work! login success" do
    post "/graphql",
      params: {
        query: query, 
        variables: {
          input: {
            email: @user.email,
            password: "123456"
          }
        }
      }.to_json, headers: basic_headers
    expect(response.status).to eq 200
    expect(response.body).to include_json({
      data: {
        createSession: {
          user: {
            token: /\w+/
          }
        }
      }
    })
  end

  it "work! login error - password error" do
    post "/graphql",
      params: {
        query: query, 
        variables: {
          input: {
            email: @user.email,
            password: "123456777"
          }
        }
      }.to_json, headers: basic_headers
    expect(response.status).to eq 200
    expect(response.body).to include_json({
      data: {
        createSession: {
          errors: [{
            attribute: "user",
            message: "Invalid email or password"
          }]
        }
      }
    })
  end

  it "work! login error - email error" do
    post "/graphql",
      params: {
        query: query, 
        variables: {
          input: {
            email: "aaa" + @user.email,
            password: "123456777"
          }
        }
      }.to_json, headers: basic_headers
    expect(response.status).to eq 200
    expect(response.body).to include_json({
      data: {
        createSession: {
          errors: [{
            attribute: "user",
            message: "Invalid email or password"
          }]
        }
      }
    })
  end
end