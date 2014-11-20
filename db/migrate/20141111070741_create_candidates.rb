class CreateCandidates < ActiveRecord::Migration
  def change
    create_table :candidates do |t|
      t.string :name

      t.belongs_to :election, :index => true

      t.timestamps
    end
  end
end
