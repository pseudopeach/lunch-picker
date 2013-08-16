class BallotOptionsController < ApplicationController
  respond_to :html, :json
  before_filter :find_membership
  before_filter :require_admin
  
  def index
    @options = @current_member.group.ballot_options
    respond_to do |format|
      format.html
      format.json {render :json=>{options:@options} }
    end
  end
  
  def create
    if params[:existing_id]
      unless @option = BallotOption.find_by_id(params[:existing_id])
        render :json=>{success:false, errors:{id:"Option not found."}}
        return
      end
    else
      #create a new option
      @option = BallotOption.option_from_params params[:ballot_option]
      unless @current_member.group.ballot_options << @option
        render :json=>{success:false, errors:@option.errors}
        return
      end
    end
    
    render :json=>{success:true, option_id:@option.id}

  end
  
  def destroy
    @group = @current_member.group
    @option = @group.ballot_options.where(:id=>params[:id]).first
    if @option && @group.ballot_options.delete(@option)
      render :json=>{success:true}
    else
      render :json=>{success:false, errors:{id:"Member not found."}}
    end
  end
  
end
