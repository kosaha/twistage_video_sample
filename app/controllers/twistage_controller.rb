require 'helix'

class TwistageController < ApplicationController
  def mainpage
    Helix::Config.load('./config/helix.yml')
    @videos = Helix::Video.find_all
    puts @videos.to_json
  end
  
  def show
    @video_id = params[:id]
    @video_title = params[:title]
  end
end
