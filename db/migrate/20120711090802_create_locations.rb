class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :name
      t.integer :parent_id
      t.integer :lft
      t.integer :rgt
      t.integer :depth
      t.string  :resource_owner_id
      t.text    :devices
      t.string  :type

      t.timestamps
    end
  end
end
