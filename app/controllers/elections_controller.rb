class ElectionsController < ApplicationController
    def create
        @election = Election.new({
            :title => election_params[:title], 
            :description => election_params[:description], 
            :quota => election_params[:quota], 
            :status => 0, 
            :end_date => 2.days.from_now })


        if not @election.save
            flash[:error] = "Cannot create election."
            render 'new' and return
        end

        @candidateList = election_params[:candidate_list].split(/\r?\n/)

        @successCandidate = Array.new
        @candidateList.each do |candidateName|
            @successCandidate << create_candidate(@election, candidateName)
        end

        flash[:notice] = "Election created"
        #render plain: @successCandidate

        redirect_to @election

    end

    def new
    end

    def show
        @election = Election.find(params[:id])
        if (Date.today > @election.end_date)
            @election.status = 1 # ended
        end
    end

#### private helpers ####
    private 
        def election_params
            params.require(:election).permit(:title,:description,:candidate_list, :quota)
        end


        def create_candidate(election, name)
            @candidate_params = {:name => name}
    
            @candidate = Candidate.new(@candidate_params)
            @candidate.save
            @election.candidates<<(@candidate)

            return @candidate
        end

end
