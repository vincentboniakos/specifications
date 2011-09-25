# By using the symbol ':user', we get Factory Girl to simulate the User model.
Factory.define :user do |user|
  user.first_name            "Michael"
  user.last_name             "Hartl"
  user.email                 "mhartl@example.com"
  user.password              "foobar"
  user.password_confirmation "foobar"
end
Factory.sequence :email do |n|
  "person-#{n}@example.com"
end
Factory.sequence :name do |n|
  "Project-#{n}"
end
Factory.define :project do |project|
  project.name              "Gaming"
  project.description       "Pellentesque faucibus congue mauris, in fringilla libero interdum sit amet. Suspendisse potenti. Donec pulvinar sapien nec elit pretium aliquam. Proin egestas fringilla porttitor. Vivamus mauris nibh, elementum nec porttitor eget, vehicula in massa. Nam ultricies, sem ac feugiat rhoncus, lacus libero tempus purus, ac faucibus mi nunc sit amet sem. Aenean ornare convallis nisl quis accumsan. Nulla pellentesque sagittis pharetra."
end