class Ballot < ActiveRecord::Base
    belongs_to :voter
    has_many :ballotEntries
end
