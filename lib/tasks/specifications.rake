namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    user = User.create!(:first_name => "Vincent",
    :last_name => "Boniakos",
    :email => "vincent.boniakos@gmail.com",
    :password => "foobar",
    :password_confirmation => "foobar")

    20.times do |n|
      name  = Faker::Name.name
      description = "Pellentesque faucibus congue mauris, in fringilla libero interdum sit amet. Suspendisse potenti. Donec pulvinar sapien nec elit pretium aliquam. Proin egestas fringilla porttitor. Vivamus mauris nibh, elementum nec porttitor eget, vehicula in massa. Nam ultricies, sem ac feugiat rhoncus, lacus libero tempus purus, ac faucibus mi nunc sit amet sem. Aenean ornare convallis nisl quis accumsan. Nulla pellentesque sagittis pharetra."
      Project.create!(:name => name, :description => description)
    end
    
  end
end
