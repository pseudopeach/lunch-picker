class BallotOptionTag < ActiveRecord::Base
  has_and_belongs_to_many :ballot_options
  has_many :votes
end
