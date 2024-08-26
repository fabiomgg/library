module RequestHelpers
  def jwt_for(user)
    post '/api/v1/users/sign_in', params: {
        email: user.email,
        password: user.password
    }.to_json, headers: { "Content-Type" => "application/json" }

    response.body['user']['jwt']
  end
end

module RequestSpecHelper
  def json
    JSON.parse(response.body)
  end
end

RSpec.configure do |config|
  config.include RequestHelpers, type: :request
  config.include RequestSpecHelper, type: :request
end
