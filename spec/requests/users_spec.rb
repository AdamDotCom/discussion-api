require 'swagger_helper'

RSpec.describe 'users', type: :request do

  path '/users' do

    get('list users') do
      response(200, 'successful') do

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end

    post('create user') do
      consumes 'application/json'
      parameter name: :user, in: :body, required: true, schema: {
        type: :object,
        properties: {
          first_name: { type: :string },
          last_name: { type: :string }
        },
      }

      response(201, 'successful') do
        let(:user) { { first_name: 'first', last_name: 'last' } }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end
  end
end
