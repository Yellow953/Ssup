class RoomsController < ApplicationController
    include RoomsHelper
    before_action :authenticate_user!

    def index
        @room = Room.new
        @joined_rooms = current_user.joined_rooms
        @rooms = search_rooms
        @users = User.all_except(current_user)
        render 'index'
    end

    def create
        @room = Room.create(name: params["room"]["name"])        
    end
    
    def show
        @selected_room = Room.find(params[:id]) 
        
        @room = Room.new
        @joined_rooms = current_user.joined_rooms
        @rooms = search_rooms
        @users = User.all_except(current_user)

        @message = Message.new
        @messages = @selected_room.messages.order(created_at: :asc)
        
        @selected_room.messages.where(read: false).each do |message|
            message.read = true
            message.save
        end

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
        redirect_to @room
    end
    
    def leave
        @room = Room.find(params[:id])
        current_user.joined_rooms.delete @room
        redirect_to root_path
    end
    
end