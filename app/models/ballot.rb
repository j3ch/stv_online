class Ballot < ActiveRecord::Base
    belongs_to :voter
    has_many :ballotEntries

    obfuscate_id :spin => 32767
end
