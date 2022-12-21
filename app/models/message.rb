class Message < ApplicationRecord
  belongs_to :user
  belongs_to :room
  before_create :confirm_participant

  after_create_commit do 
    notify_recipients
    broadcast_append_to room
  end

  def confirm_participant
    return unless room.is_private
    
    is_participant = Participant.where(user_id: user.id, room_id: room.id).first
    throw :abort unless is_participant
  end

  private 

  def notify_recipients
    users_in_room = room.joined_users
    users_in_room.each do |user|
      next if user.eql?(self.user)
      notification = MessageNotification.with(message: self, room: self.room)
      notification.deliver_later(user)      
    end

  end
  
end