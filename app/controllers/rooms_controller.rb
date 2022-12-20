class RoomsController < ApplicationController
    before_action :authenticate_user!

    def index
        @room = Room.new
        @rooms = Room.public_rooms
        @users = User.all_except(current_user)
        render 'index'
    end

    def create
        @room = Room.create(name: params["room"]["name"])        
    end
    
    def show
        @selected_room = Room.find(params[:id]) 
        
        @room = Room.new
        @rooms = Room.public_rooms
        @users = User.all_except(current_user)

        @message = Message.new
        @messages = @selected_room.messages.order(created_at: :asc)
        
        @selected_room.messages.where(read: false).each do |message|
            message.read = true
            message.save
        end

        render 'index'
    end
end