class ElectionsController < ApplicationController

    def index
        @elections = Election.all
    end

    def create
        @user = User.new({
            :name => election_params[:user_name],
            :email => election_params[:user_email]
        })
        @user.save
        @election = Election.new({
            :user => @user,
            :title => election_params[:title], 
            :description => election_params[:description], 
            :seats => election_params[:seats], 
            :status => 0, 
            :end_date => election_params[:end_date] })


        if not @election.save
            flash[:error] = @election.errors.full_messages.first
            render 'new' and return
        end

        @candidateList = election_params[:candidate_list].split(/\r?\n/)

        @successCandidate = Array.new
        @candidateList.each do |candidateName|
            if not candidateName.empty?
                @successCandidate << create_candidate(@election, candidateName)
            end
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
            @electionResult = @election.compute_result
        end
    end

#### private helpers ####
    private 
        def election_params
            params.require(:election).permit(:title,:description,:candidate_list, :seats, :end_date, :user_name, :user_email)
        end


        def create_candidate(election, name)
            @candidate_params = {:name => name}
    
            @candidate = Candidate.new(@candidate_params)
            @candidate.save
            @election.candidates<<(@candidate)

            return @candidate
        end

end
