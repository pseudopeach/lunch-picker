class VotesController < ApplicationController
  respond_to :html, :json
  before_filter :find_membership #sets @current_member
  before_filter :require_admin, :only=>[:cancel_user_votes]
  
  #GET /vote
  def show
    #shows ballot form, or returns ballot options in json form
    @group = @current_member.group
    @ballot_options = @group.eligible_ballot_options
    @current_vote = @current_member.cast_ballot_today? ? @current_member.last_ballot : nil
    respond_to do |format|
      format.html
      format.json {render :json=>{group:@group, ballot_options:@ballot_options, current_vote:@current_vote} }
    end
  end
  
  #POST /vote
  def create
    #record ballot 
    if @current_member.cast_ballot params
      flash[:notice] = "Ballot was cast :)"
      respond_to do |format|
        format.html {redirect_to :controller=>:election}
        format.json{render :json=>{success:true} }
      end
    else
      flash[:notice] = "Ballot failed :("
      respond_to do |format|
        format.html {render :show}
        format.json{render :json=>{success:false, errors:@current_member.ballot_error  } }
      end
    end
  end
  
  #DELTE /vote/cancel_user_votes
  def cancel_user_votes
    #admin can remove votes from a voter
    unless @voter = @current_member.group.members.where(:id=>params[:id])
      render :json=>{success:false, :errors=>{:id=>"Member not found."}}
    end
    
    result = @voter.cancel_votes
    render :json=>result
  end
  
end
