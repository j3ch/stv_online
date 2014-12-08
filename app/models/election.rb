class Election < ActiveRecord::Base
    require 'stv'

    belongs_to :user
    has_many :candidates, dependent: :destroy
    has_many :voters, dependent: :destroy
    has_one :electionResult, dependent: :destroy

    validates :quota, numericality: { greater_than: 0 }

    validates :end_date, presence: true, :date => { after: Date.today }

    obfuscate_id :spin => 32767

    def candidate_list
        self.candidates.join(",")
    end

    def user_name
        self.user.name
    end

    def user_email
        self.user.email
    end



    def compute_result
        return STV.compute_stv(self)
    end

    def to_python_style
        allBallots = {}
        voters.each do |v|
            puts v.to_json
            if allBallots[v.ballot].nil?
                allBallots[v.ballot] = 1
            else
                allBallots[v.ballot] = allBallots[v.ballot]+1
            end
        end


        dict = [] 
        allBallots.each do |ballot,count|
            puts "ballot: " + ballot.to_json
            puts "count: " + count.to_s

            dict << {:ballot => ballot.to_array, :count => count } 
        end

        return dict
    end

end
