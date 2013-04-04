# -*- encoding: utf-8 -*-
class ProfileSettingController < ApplicationController
  def update
    unless logged?
      redirect_to :controller => 'chat', :action => 'index'
      return
    end

    update_profile(params["account"])
    redirect_to :controller => 'account'
  end

  private
  def update_profile(profile_info)
    user = User.first(:conditions => {:_id => current_user.id})
    user.update_attributes(:profile_image_url => profile_info["image_url"])
    user.update_attributes(:name => profile_info["name"])
    user.save
  end
end
