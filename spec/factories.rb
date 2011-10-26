# By using the symbol ':user', we get Factory Girl to simulate the User model.
Factory.define :invitation do |invitation|
  invitation.recipient_email "francis.gallet@example.com"
end
Factory.define :user do |user|
  user.first_name            "Francis"
  user.last_name             "Gallet"
  user.email                 "francis.gallet@example.com"
  user.password              "foobar"
  user.password_confirmation "foobar"
  user.association           :invitation
end
Factory.sequence :email do |n|
  "person-#{n}@example.com"
end
Factory.sequence :name do |n|
  "Project-#{n}"
end
Factory.sequence :name_feature do |n|
  "Feature-#{n}"
end
Factory.define :project do |project|
  project.name              "Gaming"
  project.description       "Lorem ipsum dolor sit amet"
end
Factory.define :feature do |feature|
  feature.name "feature name"
  feature.description "Foo bar"
  feature.association :project
end
Factory.define :userstory do |userstory|
  userstory.content "userstory name"
  userstory.association :feature
end