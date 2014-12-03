class Ballot < ActiveRecord::Base
    belongs_to :voter
    has_many :ballotEntries, dependent: :destroy

    obfuscate_id :spin => 32767

    def eql?(other)
        self.ballotEntries.eql? other.ballotEntries
    end
end
