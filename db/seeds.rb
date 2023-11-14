# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#

user_hinkle = User.create({ first_name: 'Professor', last_name: 'Hinkle' })
user_cornelius = User.create({ first_name: 'Yukon', last_name: 'Cornelius' })
user_brown = User.create({ first_name: 'Charlie', last_name: 'Brown' })

post = Post.create({ title: 'Should I wash my top hat?', content: "I'm unsure of how to wash silk. Can anyone provide advice?", user: user_hinkle })

comment = Comment.create({ post: post, content: "Turn it inside out, add your detergent and use the 'Delicate' or 'Gentle' wash setting with cold water.", user: user_cornelius })
Comment.create({ post: post, comment: comment, content: "Mix a 50/50 vinegar and water solution in a bowl and use a microfiber cloth to apply. Rub in a circular motion.", user: user_brown })