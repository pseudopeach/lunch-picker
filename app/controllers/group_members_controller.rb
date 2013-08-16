class GroupMembersController < ApplicationController
  respond_to :html, :json
  before_filter :find_membership
  before_filter :require_admin
  
  def index
    #index html view should have javascript that calls ajax on the other actions here
    @members = @current_member.group.members.where(:removed=>false)
    respond_to do |format|
      format.html
      format.json {render :json=>{members:@members} }
    end
  end
  
  def create
    @member = GroupMember.new(params[:member])
    if @current_member.group.add_member @member
      render :json=>{success:true, new_id:@member.id}
    else
      render :json=>{success:false, errors:@member.errors}
    end
  end
  
  def destroy
    @member = @current_member.group.members.where(:removed=>false, :id=>params[:id]).first
    @member.removed = true if @member
    if @member && @member.save
      render :json=>{success:true}
    else
      render :json=>{success:false, errors:{id:"Member not found."}}
    end
  end
   
end
