class CandidatesController < ApplicationController

    def create
        @candidate_params = params[:candidates]
        @candidate_list = @candidate_params[:candidate_list].split()

        @success_candidates = Array.new
        @candidate_list.each do |candidate|
            @success_candidates << create_one(@candidate_params[:election_id], candidate)
        end
        redirect_to Election.find(@candidate_params[:election_id])
    end

# private method
private
    def create_one(eid, name)
        @candidate_params = {:election_id => eid, :name => name}

        @candidate = Candidate.new(@candidate_params)
        @candidate.save
        return @candidate
    end

end
