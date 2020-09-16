class CreateTrails < ActiveRecord::Migration[5.2]
  def change
    create_table :trails do |t|

      t.string :name
      t.float :latitude
      t.float :longitude
      t.integer :radius
      t.text :cache,  limit: 65535
      t.timestamps
    end
  end
end
