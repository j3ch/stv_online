class BallotEntry < ActiveRecord::Base
    belongs_to :ballot
    validates_uniqueness_of :rank, scope: :ballot_id


    def candidate=(candidate)
        self.candidate_id = candidate.id
        self.save!
    end

    def candidate
        return Candidate.find(self.candidate_id)
    end

end
