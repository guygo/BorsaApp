class SharesDb < ActiveRecord::Migration
  def change
    create_table :shares do |t|
      t.string :name
      t.string :ShareSerial,:unique => true
      t.string :CompanySerial

      t.timestamps null: false
    end
  end
end

