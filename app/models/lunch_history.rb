class LunchHistory < ActiveRecord::Base
  set_table_name "lunch_history"

  belongs_to :ballot_option
  belongs_to :lunch_group, :inverse_of => :win_history

end
