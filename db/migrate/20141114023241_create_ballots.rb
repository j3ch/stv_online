class CreateBallots < ActiveRecord::Migration
  def change
    create_table :ballots do |t|
      t.integer :currentPosition

      t.belongs_to :voter, :index => true

      t.timestamps
    end
  end
end
