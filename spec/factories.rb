# By using the symbol ':user', we get Factory Girl to simulate the User model.
Factory.define :user do |user|
  user.first_name            "Michael"
  user.last_name             "Hartl"
  user.email                 "mhartl@example.com"
  user.password              "foobar"
  user.password_confirmation "foobar"
end
Factory.define :project do |project|
  project.namee              "Gaming"
  project.description        "This project is an e-commerce website. It sales fantastic games !"
end