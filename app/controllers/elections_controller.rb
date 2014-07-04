class ElectionsController < ApplicationController
  respond_to :html, :json
  before_filter :find_membership, :except=>[:new, :create] #sets @current_member
  before_filter :require_admin, :except=>[:show, :results, :new, :create] #sets @current_member
  
  #GET /election
  def show
    #main entry point of app, redirects user to whichever action is needed
    @group = @current_member.group
    if @group.polls_open?
      #send them to vote
      redirect_to :controller=>:votes
    else
      #show last results
      redirect_to :action=>:results
    end
  end
  
  #GET /election/new
  #form for creating a new voting group
  def new
    @group = LunchGroup.new
    respond_to do |format|
      format.html {render :new}
      format.json{render :json=>{fuckyou:true} }
    end
  end
  
  #POST /election
  #actually creates a new voting group
  def create 
    LunchGroup.transaction do
      @group = LunchGroup.new(params[:lunch_group])
      @group.prefs = params[:prefs] || {}
      if success = @group.save
        @admin_user = GroupMember.new(:email=>params[:admin_email])
        @group.add_admin @admin_user
      end
 
      if success
        flash[:notice] = "New group was created!"
        respond_to do |format|
          format.html {redirect_to controller: :group_members}
          format.json{render :json=>{success:true} }
        end
      else
        flash[:notice] = "Please fix the errors."
        respond_to do |format|
          format.html {render :new}
          format.json{render :json=>{success:false, :errors=>@group.errors} }
        end
     end
   end
     
  end
  
  ##GET /election/[group_id]
  #form for editing an existing election group
  def edit
    @group = LunchGroup.find_by_id params[:id]
  end
  
  #PUT /election/[group_id]
  def update
    #updates group options
    @group = @current_member.group
    @group.assign_attributes params
    if @group.save
      flash[:notice] = "Changes were saved."
      respond_to do |format|
        format.html {redirect_to :show}
        format.json{render :json=>{success:true} }
      end
    else
      flash[:notice] = "Changes failed."
      respond_to do |format|
        format.html {render :edit}
        format.json{render :json=>{success:false, :errors=>@group.errors} }
      end
    end
  end
  
  #DELETE /election/[group_id]
  def destroy
    #removes a group
    @group = @current_member.group
    @group.deactivate
    session.delete :group_id
    redirect_to :show
  end
  
  #GET /election/results
  def results
    @group = @current_member.group
    if @group.polls_open?
    else
      
    end
    @results = @group.polls_open? ? nil : @group.last_results 
    @turnout = @group.voters
    #add a history entry
    
    #responses
    respond_to do |format|
      format.html
      format.json{render :json=>{results:@results, turnout:@turnout} }
    end
  end
  
end
