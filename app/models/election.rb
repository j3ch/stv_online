class Election < ActiveRecord::Base
    has_many :candidates
    has_many :voters

    obfuscate_id :spin => 32767
end
