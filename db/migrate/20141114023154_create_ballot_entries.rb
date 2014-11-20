class CreateBallotEntries < ActiveRecord::Migration
  def change
    create_table :ballot_entries do |t|
      t.integer :rank
      t.integer :candidate_id

      t.belongs_to :ballot


      t.timestamps
    end
  end
end
