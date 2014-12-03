class Election < ActiveRecord::Base
    belongs_to :user
    has_many :candidates, dependent: :destroy
    has_many :voters, dependent: :destroy
    has_one :electionResult, dependent: :destroy

    validates :end_date, presence: true, :date => { after: Date.today }

    obfuscate_id :spin => 32767


end
