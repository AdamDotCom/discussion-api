require 'swagger_helper'
require 'faker'

def create_test_data
  user = User.create({ first_name: Faker::Name.first_name, last_name: Faker::Name.last_name })
  post = Post.create({ title: Faker::Lorem.sentence, content: Faker::Lorem.paragraph, user: user })
  comment = post.comments.create({ content: Faker::Lorem.paragraph, user: user })
  [user, post, comment]
end

RSpec.describe 'comments', type: :request do

  path '/users/{user_id}/comments' do
    parameter name: 'user_id', in: :path, type: :string

    get('list comments') do
      response(200, 'successful') do
        user, _post = create_test_data()

        let(:user_id) { user.id }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end

        run_test! do |response|
          result = JSON.parse(response.body)

          expect(result.length).to eq(1)
          expect(result.first.fetch('user_id')).to eq(user.id)
        end
      end
    end

    post('create comment') do
      consumes 'application/json'
      parameter name: :comment, in: :body, required: true, schema: {
        type: :object,
        properties: {
          content: { type: :string },
          post: {
            properties: {
              id: { type: :string }
            }
          }
        },
      }

      response(201, 'successful') do
        user, post = create_test_data()

        let(:user_id) { user.id }
        let(:comment) { { content: Faker::Lorem.sentence, post: { id: post.id } } }

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

  path '/comments' do

    get('list comments') do
      response(200, 'successful') do
        comment_ids = (1..3).map do
          _user, _post, comment = create_test_data()
          comment.id
        end

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end

        run_test! do |response|
          result = JSON.parse(response.body)

          expect(result.length).to be >= comment_ids.length
        end
      end
    end
  end

  path '/comments/{id}' do
    parameter name: 'id', in: :path, type: :string

    get('show comment') do
      response(200, 'successful') do
        _user, _post, comment = create_test_data()

        let(:id) { comment.id }

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

  path '/posts/{post_id}/comments' do
    parameter name: 'post_id', in: :path, type: :string

    get('list comments') do
      response(200, 'successful') do
        _user, post, _comment = create_test_data()

        let(:post_id) { post.id }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end

        run_test! do |response|
          result = JSON.parse(response.body)

          expect(result.length).to eq(1)
          expect(result.first.fetch('post_id')).to eq(post.id)
        end
      end
    end

    post('create comment') do
      consumes 'application/json'
      parameter name: :comment, in: :body, required: true, schema: {
        type: :object,
        properties: {
          content: { type: :string },
          user: {
            properties: {
              id: { type: :string }
            }
          }
        },
      }

      response(201, 'successful') do
        user, post = create_test_data()

        let(:post_id) { post.id }
        let(:comment) { { content: Faker::Lorem.sentence, user: { id: user.id } } }

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
