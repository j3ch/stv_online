
require 'PasswordHash'

class Voter < ActiveRecord::Base

    belongs_to :election
    has_one :ballot, dependent: :destroy
    validates :name, presence: true, allow_blank: false
    validates_uniqueness_of :name, scope: :election_id

    obfuscate_id :spin => 32767

    def password
        self.hashed_password
    end

    def password=(pass)
        hashed = PasswordHash.createHash(pass)
        self.hashed_password = hashed
        self.save!
        self
    end
    
    def password_eql?(pass)
        if self.hashed_password.nil? and pass.empty?
            return true
        end

        return PasswordHash.validatePassword(pass,self.hashed_password)
    end



end
