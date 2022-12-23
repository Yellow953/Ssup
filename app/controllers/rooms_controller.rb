class RoomsController < ApplicationController
    include RoomsHelper
    before_action :authenticate_user!, except: %i[index]

    def index
        @room = Room.new
        @joined_rooms = current_user&.joined_rooms
        @rooms = search_rooms
        @users = User.all_except(current_user)
        @current_user = current_user
        render 'index'
    end

    def create
        @room = Room.create(name: params["room"]["name"])       
        @current_user = current_user 
    end
    
    def show
        @selected_room = Room.find(params[:id]) 
        
        @room = Room.new
        @joined_rooms = current_user.joined_rooms
        @rooms = search_rooms
        @users = User.all_except(current_user)
        @current_user = current_user

        @message = Message.new
        @messages = @selected_room.messages.order(created_at: :asc)

        set_notifications_to_read

        render 'index'
    end

    def search
        @rooms = search_rooms
        respond_to do |format|
            format.turbo_stream do
                render turbo_stream: [
                    turbo_stream.update('search_results', partial: 'rooms/search_results', locals: {rooms: @rooms})
                ]
            end
        end
    end

    def join
        @room = Room.find(params[:id])
        current_user.joined_rooms << @room
        redirect_to @room, allow_other_host: true
    end
    
    def leave
        @room = Room.find(params[:id])
        current_user.joined_rooms.delete @room
        redirect_to root_path, allow_other_host: true
    end
    
    private

    def set_notifications_to_read
        notifications = @selected_room.notifications_as_room.where(recipient: current_user).unread
        notifications.update_all(read_at: Time.zone.now)
    end
end