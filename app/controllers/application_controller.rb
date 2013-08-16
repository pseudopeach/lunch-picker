class ApplicationController < ActionController::Base
  
  protected
  def find_membership
    if session[:group_id]
      @current_member = GroupMember.find_by_id(session[:member_id])
    elsif params[:key]
      if @current_member = GroupMember.where(:key=>params[:key]).first
        session[:member_id] = @current_member.id
      end
    end
    return true if @current_member
    redirect_to :controller => :elections, :action=>:new
    return false
  end
end
