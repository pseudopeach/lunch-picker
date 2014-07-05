class GroupMember < ActiveRecord::Base
  attr_accessor :ballot_error
  after_initialize :create_key, :if=>:needs_key?
  has_many :votes
  has_many :votes_today, :class_name => 'Vote'
  belongs_to :group, :inverse_of => :members, class_name: "LunchGroup", :foreign_key=>"group_id"
  
  @@Choice_Limit = 3
  validates_presence_of :email
  
  attr_protected :id, :group_id, :is_admin, :votes
  
  def cast_ballot(params)
    #takes a prioritized queue of choices, records them
    return {success:false, errors:{election:"Polls are closed."}} unless lunch_group.polls_open?
    #return {success:false, errors:{election:"Member already voted."}} if cast_ballot_today?
    
    option_ids = lunch_group.eligible_ballot_options.map{|q| q.id}
    
    n=1
    self.transaction do
      while(option_id = params["choice_#{n}"] && n <= @@Choice_Limit)
        #check choice
        unless option_ids.member?(option_id)
          self.ballot_error = {"choice_#{n}" => params["choice_#{n}"]+" is not a legal ballot option."}
          raise ActiveRecord::Rollback 
        end
        votes << Vote.new(:priority=>n, :ballot_option_id=>option_id)
        n += 1
      end
      if votes_today.size > (n-1)
        self.ballot_error = {ballot: "Duplicate ballots were detected"}
        raise ActiveRecord::Rollback 
      end
    end #transaction
    
    self.ballot_error = {ballot: "No votes were passed."}
    
    self.ballot_error = nil
    return true
  end
  
  def cast_ballot_today?
    #true if a ballot has been cast in the current election
    lunch_group.votes_today.any?
    
  end
  
  
  def last_ballot
    cutoff = Vote.where(:priority=>1).maximum(:id)
    return Vote.where(["id > ?",cutoff])
  end
  
  def cancel_user_votes
    #cancells todays votes
    success = true
    self.transaction do
      votes_today.each do |vote|
        vote.purged = true
        success &&= vote.save
      end
    end #transaction
    return success
  end
  
  def create_key
    self.key_phrase = "temp-"+rand(439602930).to_s
  end
  
  def admin?
    return is_admin
  end
  
  def needs_key?
    key_phrase.blank?
  end
  
  def resend_email
    
  end
  
  def votes_today
    self.votes.where(["created_at > ?", self.lunch_group.polls_close_at])
  end
end
