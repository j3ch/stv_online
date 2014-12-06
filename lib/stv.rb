module STV

    def self.compute_stv (election)

        ballots = election.to_python_style
        seats = election.quota
        candidates = election.candidates.to_set

        return compute_stv_helper(ballots, seats, candidates)
    end

    def self.compute_stv_helper(ballotsOriginal, seats, candidates)
        ballots = ballotsOriginal.dup
        quota  = droop_quota(ballots, seats)
        remaining_candidates = candidates.dup 
        winners = Set.new
        rounds = []

        # iterate
        while ( winners.size < seats and (remaining_candidates.size + winners.size) > seats) 

            # If all the votes have been used up, start from scratch for the remaining candidates

            round = {}

            if ballots.select{|entry| entry[:count] > 0}.size == 0
                round[:note] = "reset"

                ballots = ballotsOriginal.dup
                ballots.each do | ballot|
                    ballot[:ballot] = ballot[:ballot].select{|entry| remaining_candidates.include?(entry)} 
                end

                quota = droop_quota(ballots, seats - winners.size)
            end

            round[:tallies] = tallies(ballots)

            if round[:tallies].nil? or round[:tallies].empty?
                break
            end

           
            if round[:tallies].values.max >= quota

                # Collect candidates as winners
                round[:winners] = round[:tallies].inject(Set.new) do |result, (key,value)|
                    puts "("+key+","+value.to_s+")"
                    if value >= quota
                        result << key
                    end
                    result
                end

                winners.merge( round[:winners] )
                remaining_candidates.delete_if {|c| round[:winners].include?(c) } 

                # Redistribute excess votes
                ballots.each do |ballot|
                    if round[:winners].include?(ballot[:ballot].first)
                        ballot[:count] = ballot[:count] * (round[:tallies][ballot[:ballot].first] - quota) / round[:tallies][ballot[:ballot].first]
                    end
                end

                # Remove candidates from remaining ballots
                ballots = remove_candidates_from_ballots(round[:winners], ballots)

            else  # If no candidate exceeds the quota, elimiate the least preferred

                round.update(get_loser(round[:tallies]))
                remaining_candidates.delete(round[:loser])
                ballots = remove_candidates_from_ballots([round[:loser]], ballots)
            end


            # Record this round's actions
            puts round.to_json
            rounds << round
        end



        # Append the final winner and return

        if winners.size < seats
            
            #winners.merge( remaining_candidates)

            round = {}
            round[:note] = "Adding remaining candidates as winners"
            round[:winners] = winners
        end
        

        return {:quota => quota, :rounds => rounds, :remaining_candidates => remaining_candidates, :winners => winners.to_set }

    end

#### helper methods #####


   def self.get_loser(tallies)

        losers = tallies.select{|key,value| value == tallies.values.min}

        if losers.size == 1
            return {:loser => losers.keys.first}
        else
            return {
                :tied_losers => losers,
                :loser => losers.keys.first # break ties somehow
            }
        end
    end



    def self.remove_candidates_from_ballots(candidates, ballots)

        ballots.each do |ballot|

            candidates.each do |candidate|

                ballot[:ballot].delete(candidate)

            end
        end

        return ballots
    end


    def self.sum_ballots(election)
        ballots = Hash.new(0)
        election.voters.inject(ballots) do |hash, voter|
            hash[:ballot => voter.ballot]+= 1
            return hash
        end
    end

    def self.tallies(ballots)

        tallies = viable_candidates(ballots).inject(Hash.new) do |total, candidate|
            total[candidate] = 0
            total
        end

        for ballot in ballots

            if ballot[:ballot].size > 0

                tallies[ballot[:ballot].first] += ballot[:count]
            end
        end

        return tallies.select{|k,v| v  > 0}
    end


    def self.viable_candidates(ballots)

        candidates = Set.new

        for ballot in ballots

            candidates = candidates | ballot[:ballot].to_set
        end

        return candidates
    end


    def self.droop_quota(ballots, seats=1)

        voters = 0
        for ballot in ballots

            voters += ballot[:count]
        end

        return (voters.to_f / (seats + 1)).to_i + 1
    end
end
