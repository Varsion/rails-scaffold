require "rails_helper"

RSpec.describe "GraphQL - User Query", type: :request do
  before :each do
    @user = create(:user)
  end
  let(:query) do
    "
      query {
        user {
          id
          name
          email
        }
      }
    "
  end

  it "work! get current user success" do
    post "/graphql",
      params: {
        query: query, 
        variables: {}
      }.to_json, headers: user_headers
    expect(response.status).to eq 200
    expect(response.body).to include_json({
      data: {
        user: {
          id: @user.id,
          name: @user.name,
          email: @user.email
        }
      }
    })
  end

  it "work! no login" do
    post "/graphql",
      params: {
        query: query, 
        variables: {}
      }.to_json, headers: basic_headers
    expect(response.status).to eq 200
    expect(response.body).to include_json({
      data: {
        user: nil
      }
    })
  end
end