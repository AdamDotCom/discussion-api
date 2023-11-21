# README

Top Hat Backend Technical Assessment

## Problem Description

```
We will build a simple Reddit-style discussion API.

At Top Hat, We have several question types for our professors to support their in-class activities.
We would like to add another question type called a discussion question. As a MVP we would
like to develop a functionality for the professor to start a discussion and students can respond to
a question with their comments. Students can also respond to each other’s comments.

As an example: The professor starts a discussion by asking “How is your day going so far?”.
One student responds with “it is going great, Thanks!”. Another student responds to the
professor by saying “Unfortunately, I had a bad day!” and another student responds to that
student’s comment by saying “Oh no! Sorry to hear that. What happened?” The response chain
can go on and on. The professor can also start a new discussion by asking “What do we want to
learn today?”

With this example in mind, we would like to build API(s) so that:

- Any user can start a new discussion.
- Any user can respond to a discussion or comment.
- Any user can retrieve all the comments available in the database in a flat tree for a given
discussion.

You should write unit tests to validate the correctness of this API.

Things that are out of scope for building this API:

- There won’t be any user authentication layer. Any user should be able to create a new
discussion and respond to other discussions.

General instructions:

- You can choose to work with any backend language and framework that you feel
comfortable with.
- Please include API documentation that explains URL structure and API response
schema
- Upon completion of this exercise, please provide us with your source code and
step-by-step instructions on how to deploy and run the application. To send us the code,
you can either:
  - Provide us with access to your private GitHub repository.
  - Or you can compress your code and send us the zip file.
```

## Solution

My approach uses Ruby on Rails. I makes use of specification tests to verify the happy cases for endpoints (you can run these test via `rake spec`, tests can be found in the `spec/requests` directory).
These same tests are also used to generate swagger documentation (`rake rswag:specs:swaggerize`). This Swagger documentation is then available through the `/api-docs` path by making use of the [Rswag](https://github.com/rswag/rswag) gem. 

Given the problem definition above, the following should meet the requirements for:

1) Any user can start a new discussion.

    Request:
    ```
    curl -X 'POST' \
      'https://top-hat-discussion-api.onrender.com/posts' \
      -H 'accept: application/json' \
      -H 'Content-Type: application/json' \
      -d '{
      "title": "Ice Breakers",
      "content": "What’s your favourite knock-knock joke?",
      "user": {
        "id": "1"
      }
    }'
    ```
    
    Response:
    ```
    {
      "id": 2,
      "user_id": 1,
      "title": "Ice Breakers",
      "content": "What’s your favourite knock-knock joke?",
      "created_at": "2023-11-15T20:24:15.801Z",
      "updated_at": "2023-11-15T20:24:15.801Z"
    }
    ```

2) Any user can respond to a discussion or comment.

    Request:
    ```
    curl -X 'POST' \
      'https://top-hat-discussion-api.onrender.com/posts/2/comments' \
      -H 'accept: application/json' \
      -H 'Content-Type: application/json' \
      -d '{
      "content": "Knock, knock. Who’s there? Tank. Tank who? You’re welcome.",
      "user": {
        "id": "2"
      }
    }'
    ```
    
    Response:
    ```
    {
      "id": 3,
      "user_id": 2,
      "post_id": 2,
      "content": "Knock, knock. Who’s there? Tank. Tank who? You’re welcome.",
      "comment_id": null,
      "created_at": "2023-11-15T20:28:12.008Z",
      "updated_at": "2023-11-15T20:28:12.008Z"
    }
    ```
3) Any user can retrieve all the comments available in the database in a flat tree for a given
  discussion.

    Request:
    ```
    curl -X 'GET' \
      'https://top-hat-discussion-api.onrender.com/posts/2/comments' \
      -H 'accept: application/json'
    ```
    
    Response:
    ```
    [
      {
        "id": 3,
        "user_id": 2,
        "post_id": 2,
        "content": "Knock, knock. Who’s there? Tank. Tank who? You’re welcome.",
        "comment_id": null,
        "created_at": "2023-11-15T20:28:12.008Z",
        "updated_at": "2023-11-15T20:28:12.008Z"
      }
    ]
    ```

### Run it locally

- clone this repository
- [install rails](https://guides.rubyonrails.org/v5.1/getting_started.html)
- setup the database `rails db:setup` (creates, migrates, and seeds)
- run `rails server`
- visit your development server http://127.0.0.1:3000/api-docs/

### Run the tests
- run the specification tests `rake spec`
```
> rake spec
...........

Finished in 0.0884 seconds (files took 1.61 seconds to load)
11 examples, 0 failures

```
### Live

This application is hosted online at https://top-hat-discussion-api.onrender.com/api-docs/

Screen Capture:
![Screen Capture](https://github.com/AdamDotCom/top-hat-discussion-api/blob/main/Swagger-UI.png?raw=true)
