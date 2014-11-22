class Voter < ActiveRecord::Base
    belongs_to :election
    has_one :ballot, dependent: :destroy
    validates :name, presence: true, allow_blank: false
    validates_uniqueness_of :name, scope: :election_id

    obfuscate_id :spin => 32767

end
