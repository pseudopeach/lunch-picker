class Group < ActiveRecord::Base

  self.table_name = "lunch_groups"

  #prefs =======================
  #synchronize text field in DB with ruby hash object named @raw_prefs

  #creates new prefs hash on all new Group objects
  after_initialize :set_defaults  

  #deserializes db column prefs_json into @raw_prefs attribute
  after_find :decode_prefs

  #serializes @raw_prefs attribute into db column prefs_json
  before_save :encode_prefs
  # ============================


  has_many :members, :class_name => "GroupMember", :foreign_key => "group_id", :inverse_of => :group
  #has_many :votes_today, ->(vote) { where starts_on: user.birthday }, class_name: 'Event'
  has_many :votes, :through=>:members
  has_many :votes_today, :class_name=>"Vote", :through=>:members
  has_many :win_history, :class_name => "LunchHistory", :inverse_of => :group
  has_and_belongs_to_many :ballot_options
  
  attr_accessible :name, :polls_close_utc, :prefs
  
  def set_defaults
    @raw_prefs = {
      lightning: true,
      retire_for_week: true,
      daily_election: true
    }
  end
  
  def self.poll_length
    4.hours
  end
  
  def polls_open?
    close = polls_close_at
    if self.pref :lightning
      first = first_vote_of_day_cast_at
      #closing time has past, but either no one has voted, or voting started less than 10 minutes ago
      return true if close.past? && (!first || (first+10.minutes).future?)
    end
    
    return close.future? && (close-Group.poll_length).past?
    #***todo Implement lightning round
  end
  
  def polls_close_at
    #find nearest closing time on same day
    t = self.polls_close_utc
    return t + ((Time.now - t)/3600.0/24).round.days
  end
  
  def election_results(date)
    raw_votes #= votes.select("ballot_options.name")
    
    winners = {}
    voters = {}
    raw_votes.each do |vote|
      
    end
    return {winners:winners, turnout:voters}
  end
  
  
  
  def history_week_of(day)
    #always returns 7 days, inserting empty days where required
    @history_records = @current_member.group.win_history.
      where(["created_at >= ? AND created_at < ?",@week_start, @week_end]).order(:created_at)
    date = @week_start
    
  end
  
  def set_history_item(option,date)
    if history_item = history.where(:created_at=>date).first
      history_item.ballot_option = option
    else
      history_item = LunchHistory.new(:ballot_option=>option)
      history_item.lunch_group = self
    end
    
    return history_item.save
  end
  
  def last_vote_cast_at
    votes.maximum(:created_at)
  end
  
  def first_vote_of_day_cast_at
    votes.where(["created_at > ?",polls_close_at-12.hours]).minimum(:created_at)
  end
  
  def eligible_ballot_options
    ballot_options
  end
  
  def prefs=(input)
    input.each_pair do |k,v|
      if @raw_prefs.key? k
        @raw_prefs[k] = v
      end
    end
  end
  
  def pref(key)
    @raw_prefs[key]
  end
  
  def add_admin(admin)
    self.transaction do
      admin.is_admin = true
      members << admin
      #***todo send email
    end
  end
  
  def add_member(member)
    members << member
      #***todo send email
  end

  def add_members(input)
    emails.each |email|
    members << members.email
  end

  
  def encode_prefs
    self.prefs_json = @raw_prefs.to_json
  end

  #trust what's in the DB, or set to default
  def decode_prefs
    if self.prefs_json
      @raw_prefs = JSON.parse(self.prefs_json)
    else
      set_defaults
    end
  end

  #vote by tag i.e. "Mexican" or "Quick Meal"
  def is_tag_election?
  end


end
