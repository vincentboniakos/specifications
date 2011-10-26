namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke

    invitation = Invitation.create!(:recipient_email => "vincent.boniakos@gmail.com")

    user = User.create!(:first_name => "Vincent",
    :last_name => "Boniakos",
    :email => "vincent.boniakos@gmail.com",
    :password => "foobar",
    :password_confirmation => "foobar",
    :invitation_token => invitation.token)

    20.times do |n|
      name  = "Project-#{n}"
      description = "Pellentesque faucibus congue mauris, in fringilla libero interdum sit amet. Suspendisse potenti. Donec pulvinar sapien nec elit pretium aliquam. Proin egestas fringilla porttitor. Vivamus mauris nibh, elementum nec porttitor eget, vehicula in massa. Nam ultricies, sem ac feugiat rhoncus, lacus libero tempus purus, ac faucibus mi nunc sit amet sem. Aenean ornare convallis nisl quis accumsan. Nulla pellentesque sagittis pharetra."
      @project = Project.create!(:name => name, :description => description)
      20.times do |m|
        name = Faker::Name.name
        description = "Pellentesque faucibus congue mauris, in fringilla libero interdum sit amet. Suspendisse potenti."
        @feature = @project.features.create!(:name => name, :description => description)
        10.times do |l|
          content ="Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit..."
          @feature.userstories.create!(:content => content)
        end
      end
    end
    
  end
end
