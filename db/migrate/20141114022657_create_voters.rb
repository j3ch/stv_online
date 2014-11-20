class CreateVoters < ActiveRecord::Migration
  def change
    create_table :voters do |t|
      t.string :name
      t.string :hashed_password

      t.belongs_to :election

      t.timestamps
    end
  end
end
