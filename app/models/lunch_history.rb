class LunchHistory < ActiveRecord::Base
  self.table_name = "lunch_history"

  belongs_to :ballot_option
  belongs_to :group, :inverse_of => :win_history

end
