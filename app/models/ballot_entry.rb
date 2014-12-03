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

    def eql?(other)
        self.candidate_id.eql? other.candidate_id and self.rank.eql? other.rank
    end
end
