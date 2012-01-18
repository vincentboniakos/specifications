namespace :db do

  desc "Fill database with a admin user"
  task :create_admin => :environment do
    invitation = Invitation.create!(:recipient_email => "vincent.boniakos@gmail.com")
    user = User.new(:first_name => "Vincent",
    :last_name => "Boniakos",
    :email => "vincent.boniakos@gmail.com",
    :password => "foobar",
    :password_confirmation => "foobar",
    :invitation_token => invitation.token,
    :invitation_id => invitation.id)
    user.save
    user.toggle!(:admin)
  end

  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke

    Rake::Task['db:create_admin'].invoke

    PaperTrail.enabled = false

    20.times do |n|
      first_name  = Faker::Name.name
      last_name  = Faker::Name.name
      email = "example-#{n+1}@railstutorial.org"
      password  = "password"
      invitation = Invitation.create!(:recipient_email => email)
      user = User.new(:first_name => first_name, :last_name => last_name,
      :email => email,
      :password => password,
      :password_confirmation => password,
      :invitation_token => invitation.token,
      :invitation_id => invitation.id)
      user.save
    end

    

    10.times do |n|
      name  = "Project-#{n}"
      description = "Pellentesque faucibus congue mauris, in fringilla libero interdum sit amet. Suspendisse potenti. Donec pulvinar sapien nec elit pretium aliquam. Proin egestas fringilla porttitor. Vivamus mauris nibh, elementum nec porttitor eget, vehicula in massa. Nam ultricies, sem ac feugiat rhoncus, lacus libero tempus purus, ac faucibus mi nunc sit amet sem. Aenean ornare convallis nisl quis accumsan. Nulla pellentesque sagittis pharetra."
      @project = Project.create!(:name => name, :description => description)
      5.times do |m|
        name = Faker::Name.name
        description = "Pellentesque faucibus congue mauris, in fringilla libero interdum sit amet. Suspendisse potenti."
        @feature = @project.features.create!(:name => name, :description => description)
        5.times do |l|
          content ="Neque porro quisquam #{l}"
          @feature.userstories.create!(:content => content, :position => l)
        end
      end
    end
    
  end
end
