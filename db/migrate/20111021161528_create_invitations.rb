class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.string :recipient_email
      t.string :token
      t.datetime :sent_at

      t.timestamps
    end
  end
end
