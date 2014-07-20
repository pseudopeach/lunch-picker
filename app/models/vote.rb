class Vote < ActiveRecord::Base
  belongs_to :ballot_option, inverse_of :votes
  belongs_to :group, inverse_of :votes
  belongs_to :group_member, inverse_of :votes
  belongs_to :ballot_option_tag, inverse_of :votes
end
