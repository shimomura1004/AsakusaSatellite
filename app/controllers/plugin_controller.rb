require 'pathname'
class PluginController < ApplicationController
  def asset
    plugin        = params[:plugin]
    type          = params[:type]+"s"
    filename      = params[:file]+"."+params[:format]
    asset_path    = remove_illegal_path "plugins/#{plugin}/app/assets/#{type}/#{filename}"
    absolute_path = Rails.root.join asset_path
    content_type  = Rack::Mime.mime_type(File.extname filename)

    begin
      content = File.read absolute_path
      render :text => content, :content_type => content_type
    rescue
      render :nothing => true, :status => 404
    end
  end

  private
  def remove_illegal_path(path)
    path.split("/").reject{|p| p==".."}.join("/")
  end
end
