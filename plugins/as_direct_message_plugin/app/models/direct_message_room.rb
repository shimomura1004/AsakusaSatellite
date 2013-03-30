class DirectMessageRoom
  include Mongoid::Document
  index :user_ids

  field :user_ids, :type => Array
  field :room_id
end
