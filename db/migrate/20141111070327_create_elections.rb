class CreateElections < ActiveRecord::Migration
  def change
    create_table :elections do |t|
      t.string :title
      t.text :description
      t.integer :quota
      t.integer :status

      t.timestamps
    end
  end
end
