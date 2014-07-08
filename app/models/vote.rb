class Vote < ActiveRecord::Base
  belongs_to :ballot_option, inverse_of :votes
  belongs_to :lunch_group, inverse_of :votes
  belongs_to :group_member, inverse_of :votes, :dependent => :destroy
  belongs_to :ballot_option_tag, inverse_of :votes
end
