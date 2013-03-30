# -*- coding: utf-8 -*-
AsakusaSatellite::Application.routes.draw do
  get 'user/direct_message', :controller => "user", :action => "direct_message"
end
