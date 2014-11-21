class Election < ActiveRecord::Base
    has_many :candidates
    has_many :voters

    validates :end_date, presence: true, :date => { after: Date.today }

    obfuscate_id :spin => 32767
end
