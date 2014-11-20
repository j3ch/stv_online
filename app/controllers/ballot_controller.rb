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
        @voter.save

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
       #render json: @ballot and return

       #render plain: @ballotParams[:ballotEntries].split(",")
    end

    def show
        @ballot = Ballot.find(params[:id]) 
        @voter = @ballot.voter
        @election = @voter.election
    end


    def edit
        @ballot = Ballot.find(params[:id])
        @election = @ballot.voter.election

        @ballot.voter.destroy
        @ballot.destroy

        flash[:notice] = "Your ballot has been deleted, please recast your vote!"
        redirect_to @election
    end 

end
