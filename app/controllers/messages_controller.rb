class MessagesController < ApplicationController
  def create
    @message = current_user.messages.create(body: msg_params[:body], room_id: params[:room_id])
    
    if @message.room.is_private? 
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update('users', partial: 'users/all', locals: {users: User.all_except(current_user)})
          ]
        end
      end
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update('rooms', partial: 'rooms/all', locals: {joined_rooms: current_user.joined_rooms})
          ]
        end
      end  
    end
  end

  private

  def msg_params
    params.require(:message).permit(:body)
  end
end