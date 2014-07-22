class AddIndexBallotOptionsLunchGroups < ActiveRecord::Migration
  def up
    add_index :ballot_options_lunch_groups, [:ballot_option_id, :lunch_group_id], :name => 'index_ballot_options_lunch_groups'
  end

  def down
    remove_index :ballot_options_lunch_groups, [:ballot_option_id, :lunch_group_id]
  end
end
