class BallotController < ApplicationController

    def create
        @ballotParams = params[:ballot]
        @election = Election.find(@ballotParams[:electionId])

        @entries = @ballotParams[:ballotEntries].split(",")
        if @entries.size == 0
            flash[:error] = "You must select at least one candidate"
            redirect_to @election and return
        end

        if @ballotParams[:voterName].empty?
            flash[:error] = "You must enter your name"
            redirect_to @election and return
        end


        @voter = Voter.new({ :name => @ballotParams[:voterName], :election => @election })
        if not @voter.save
            @voter = Voter.where({:name => @ballotParams[:voterName]}).first
            if not @voter.nil?
                flash[:notice] = "You have already submitted a ballot."
                redirect_to @voter.ballot and return
            else
                flash[:error] = "An error occurred saving your ballot. Sorry :("
                redirect_to '/'
            end
        end

        @ballot = Ballot.new({ :voter => @voter })
        @ballot.save



        @ballotParams[:ballotEntries].split(",").each_with_index do |candidateId, index|

            @candidate = Candidate.find(candidateId)
            if not @candidate.nil? 
                @ballotEntry = BallotEntry.new({ :rank => index })
                @ballotEntry.save

                @ballotEntry.candidate = @candidate
                @ballot.ballotEntries << @ballotEntry
            end
        end

        redirect_to @ballot
        #render json: @voter and return
        #render plain: @election.to_json and return
    end

    def show
        @ballot = Ballot.find_by_id(Ballot.deobfuscate_id(params[:id]))
        @voter = @ballot.voter
        @election = @voter.election
    end


    def destroy
        @ballot = Ballot.find_by_id(Ballot.deobfuscate_id(params[:id]))
        if not (@ballot.nil?)
            @voter = @ballot.voter
            @election = @voter.election
            @voter.destroy
            flash[:notice] = "Your ballot has been deleted, please recast your vote!"
            redirect_to @election
        else 
            flash[:error] = "An error occurred editing your ballot. Sorry :("
            redirect_to '/'
        end

    end 

end
