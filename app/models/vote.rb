class Vote < ActiveRecord::Base
  belongs_to :ballot_option
  belongs_to :lunch_group
  belongs_to :group_member
  belongs_to :ballot_option_tag
end
