require 'swagger_helper'
require 'faker'

RSpec.describe 'posts', type: :request do

  path '/posts' do

    get('list posts') do
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

    post('create post') do
      consumes 'application/json'
      parameter name: :discussion, in: :body, required: true, schema: {
        type: :object,
        properties: {
          title: { type: :string },
          content: { type: :string },
          user: {
            properties: {
              id: { type: :string }
            }
          }
        },
      }

      response(201, 'successful') do
        user = User.create({ first_name: Faker::Name.first_name, last_name: Faker::Name.last_name })
        let(:discussion) { { title: Faker::Lorem.sentence, content: Faker::Lorem.paragraph, user: { id: user.id } } }

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

  path '/posts/{id}' do
    parameter name: 'id', in: :path, type: :string

    get('show post') do
      response(200, 'successful') do
        user = User.create({ first_name: Faker::Name.first_name, last_name: Faker::Name.last_name })
        post = Post.create({ title: Faker::Lorem.sentence, content: Faker::Lorem.paragraph, user: user })
        let(:id) { post.id }

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
