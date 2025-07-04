class CreateReadings < ActiveRecord::Migration[8.0]
  def change
    create_table :readings do |t|
      t.integer :blood_sugar

      t.timestamps
    end
  end
end
