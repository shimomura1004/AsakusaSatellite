# -*- coding: utf-8 -*-
require File.dirname(__FILE__) + '/../spec_helper'

describe LoginController do
  before {
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new({
      :provider => 'twitter',
      :info => Hashie::Mash.new(:name => 'name', :nickname => 'nickname', :image => 'http://example.com/a.jpg')
    })

  }
  context "ログアウト後" do
    context "referer is nil" do
      before do
        @user = User.new.tap{|user| user.save! }
        session[:current_user_id] = @user.id
        post :logout
      end
      subject { response }
      it { should redirect_to root_path }
    end
    context "referer is not nil" do
      before do
        @user = User.new.tap{|user| user.save! }
        session[:current_user_id] = @user.id
        request.stub(:referer) { 'http://localhost' }
        post :logout
      end
      subject { session }
      its([:current_user_id]) { should be_nil }
    end
  end

  context "callback" do
    before do
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:twitter] 
      post :omniauth_callback, :provider => 'twitter'
    end
    subject { controller.current_user }
    its(:name) { should == 'name' }
    its(:screen_name) { should == 'nickname' }
    its(:profile_image_url) { should == 'http://example.com/a.jpg' }
  end
end
