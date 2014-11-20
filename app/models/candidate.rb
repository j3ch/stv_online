class Candidate < ActiveRecord::Base
    belongs_to :election
    validates_uniqueness_of :name, scope: :election_id
end
