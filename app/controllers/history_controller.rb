class HistoryController < ApplicationController
  respond_to :html, :json
  before_filter :find_membership
  before_filter :require_admin
  
  #GET /history
  def index
    #get history items for a week
    #index html view should have javascript that calls ajax on the other actions here
    @history = @current_member.group.history_week_of(params[:date] || 0.seconds.ago)
    respond_to do |format|
      format.html
      format.json {render :json=>{history:@history} }
    end
  end
  
  #GET /history/[option_id]
  def show
    #get the history for option with params{:id}
    @option = BallotOption.find_by_id(params[:id]) #all options allowed, not just currently associated
    if @option
      @history = @option.history.where(:group_id=>@group.id)
      render :json=>{success:true, history:@history}
    else
      render :json=>{success:false, errors:{id:"Option not found."}}
    end
  end
  
  #PUT /history/[option_id]?date=[date]
  def update
    @group = @current_member.group
    @option = BallotOption.find_by_id(params[:id]) #all options allowed, not just currently associated
    unless @option
      render :json=>{success:false, errors:{id:"Option not found."}}
      return
    end
    if @group.set_history_item(@option,params[:date])
      render :json=>{success:true}
    else
      render :json=>{success:false}
    end
  end
  
  #` /history/[option_id]?date=[date]
  def destroy
    #params[:id] is taken to be the ballot option id
    @group = @current_member.group
    @item = @group.history.where(:ballot_option_id=>params[:id], :created_at=>params[:date])
    if @item && @item.destroy
      render :json=>{success:true}
    else
      render :json=>{success:false, errors:{id:"History item not found."}}
    end
  end
  
end
