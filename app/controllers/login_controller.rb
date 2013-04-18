# -*- encoding: utf-8 -*-
class LoginController < ApplicationController
  protect_from_forgery :only => ["logout"]

  def index
  end

  # This is an old login URL. Please use omniauth login URL like /auth/:provider
  def oauth
    redirect_to "#{root_path}auth/#{Setting['omniauth']['provider']}"
  end

  def omniauth_callback
    user_info = AsakusaSatellite::OmniAuth::Adapter.adapt(request.env['omniauth.auth'])

    User.find_or_create_by({:screen_name => user_info[:screen_name]}).tap do |user|
      user.name              = user_info[:name]
      user.email             = user_info[:email]
      if user.profile_image_url.nil? || user.profile_image_url.empty? || (not user.profile_image_url.start_with?("http"))
        user.profile_image_url = user_info[:profile_image_url]
      end
      user.save
      set_current_user(user)
    end

    if request.env['omniauth.origin'].blank?
      redirect_to :controller => :chat, :action => :index
    else
      redirect_to request.env['omniauth.origin']
    end
  end

  def logout
    if request.post?
      session.delete :cached_current_user
      session.delete :current_user_id
    end
    redirect_to request.referer
  end

  def failure
    redirect_to :back, :alert => params[:message]
  end
end
