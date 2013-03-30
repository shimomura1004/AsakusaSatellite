# -*- encoding: utf-8 -*-
class UserController < ApplicationController
  def direct_message
    user = User.where(:_id => params["user"]).first
    users = [current_user, user].sort
    user_ids = users.map {|user| user._id.to_s}

    dmroom = DirectMessageRoom.find_or_create_by(:users => user_ids)
    if dmroom.room_id
      room = Room.where(:_id => dmroom.room_id).first
      dmroom.room_id = nil if room.deleted
    end

    if dmroom.room_id.nil?
      title = users.map{|user| user.name}.join(" and ")
      room = Room.new(:title => title, :user => user_ids[0], :member_ids => [user_ids[1]], :updated_at => Time.now, :is_public => false)
      room.save
      dmroom.room_id = room._id
      dmroom.save
    end

    redirect_to "/chat/room/#{dmroom.room_id}"
  end
end
