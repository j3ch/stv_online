class CreateElections < ActiveRecord::Migration
  def change
    create_table :elections do |t|
      t.string :title
      t.text :description
      t.integer :quota
      t.integer :status, :index => true, :default => 0
      t.date :end_date

      t.timestamps
    end
  end
end
