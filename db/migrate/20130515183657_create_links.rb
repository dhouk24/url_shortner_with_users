class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.string :long_url
      t.string :short_url
      t.integer :click_count
      t.integer :user_id
    end
  end
end
