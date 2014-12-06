require 'test_helper'

class ElectionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "compute result" do
    
        # Generate data
        input = [
            {:count => 56, :ballot => ["c1", "c2", "c3"]},
            {:count => 40, :ballot => ["c2", "c3", "c1"]},
            {:count => 20, :ballot => ["c3", "c1", "c2"]}
        ]

        output = STV.compute_stv_helper(input, 2, ["c1", "c2", "c3"].to_set)

        # Run tests

        assert_equal({

            :quota => 39,

            :rounds=> [{

                :tallies=> {'c3' => 20.0, 'c2' => 40.0, 'c1' => 56.0},

                :winners => ['c2', 'c1'].to_set

            }],

            :winners => ['c2', 'c1'].to_set

        }, output,  "result differ: " + output.to_json)
    



  end


  test "compute result wikipedia example" do 

       # Generate data
        input = [

            {:count=> 4, :ballot=> ["orange"]},
            {:count=> 2, :ballot=> ["pear", "orange"]},
            {:count=> 8, :ballot=> ["chocolate", "strawberry"]},
            {:count=> 4, :ballot=> ["chocolate", "sweets"]},
            {:count=> 1, :ballot=> ["strawberry"]},
            {:count=> 1, :ballot=> ["sweets"]}

        ]

        output = STV.compute_stv_helper(input, 3, ['orange', 'pear', 'chocolate', 'strawberry', 'sweets'].to_set  )



        # Run tests
        assert_equal({

            :quota=> 6,

            :rounds=> [

                {:tallies => {'orange'=> 4.0, 'strawberry'=> 1.0, 'pear'=> 2.0, 'sweets'=> 1.0, 'chocolate'=> 12.0}, 'winners'=> ['chocolate'].to_set},

                {:tallies => {'orange'=> 4.0, 'strawberry'=> 5.0, 'pear'=> 2.0, 'sweets'=> 3.0}, 'loser'=> 'pear'},

                {:tallies => {'orange'=> 6.0, 'strawberry'=> 5.0, 'sweets'=> 3.0}, 'winners'=> ['orange'].to_set},

                {:tallies => {'strawberry'=> 5.0, 'sweets'=> 3.0}, 'loser'=> 'sweets'}

            ],

            :remaining_candidates => ['strawberry'].to_set,

            :winners=> ['orange', 'strawberry', 'chocolate'].to_set

        }, output, "result differ: " + output.to_json)



  end

end
