require 'helix'

class TwistageController < ApplicationController
  def mainpage
    Helix::Config.load('./config/helix.yml')
    @videos = Helix::Video.find_all
    #puts @videos.to_json
  end
  
  def show
    @video_id = params[:id]
    @video_title = params[:title]
  end
  
  def get_thumbnail
    video_id = params[:format]
    video_content = Helix::Video.stillframe_for(video_id, {:width => 200, :height => 200})
    send_data video_content, :type => 'image/jpeg', :disposition => 'inline'
  end
  
  def update_stillframe
    video_id = params[:id]
    @video = Helix::Video.find(video_id)
    video_still_frame_list = VideoStillFrames.where({video_id: video_id}).all
    @video_frames = []
    puts video_still_frame_list
    if video_still_frame_list.blank?
      5.times do |i|
        updated_video = @video.update({stillframe: (@video.duration * i) / 5 })
        puts updated_video.to_xml
        video_content = Helix::Video.stillframe_for(video_id, {:width => 200, :height => 200})
        #screenshot_details = updated_video.screenshots[0]
        #puts screenshot_details["url"]
        #response = RestClient.get screenshot_details["url"]
        #video_content = response.body
        video_frame = VideoStillFrames.new(video_id: video_id, frame_id: i, frame: video_content)
        if video_frame.save
          puts "success #{video_id} : #{i}"
        else
          puts "failure #{video_id} : #{i}"
        end
        @video_frames << i
      end
    else
      video_still_frame_list.each do |video_frame|
        @video_frames << video_frame.frame_id
      end
    end
    
    render 'screenshotspage'
  end
  
  def get_screenshot_image
    video_id = params[:id]
    frame_id = params[:frame_id]
    video_still_frame = VideoStillFrames.where(video_id: video_id, frame_id: frame_id).first
    if video_still_frame.nil?
      # no data to send
    else
      video_content = video_still_frame.frame
      send_data video_content, :type => 'image/jpeg', :disposition => 'inline'
    end
  end
  
  def slice_video
    video_id = params[:id]
    video = Helix::Video.find(video_id)
    duration = video.duration
    xml_str = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><slice><ingest-profile>default</ingest-profile><segments>"
    
    2.times do |i|
      start_seg = (duration / 2 * i).round(1)
      end_seg = (duration / 2 * (i + 1)).round(1)
      puts "#{start_seg} : #{end_seg}"
      xml_str += "<segment><title>Seg#{i + 1}</title><description>Seg#{i + 1}Desc</description><stillframe>1.0</stillframe><start>#{start_seg}</start><end>#{end_seg}</end></segment>"
    end
    
    xml_str += "</segments></slice>"
    
    puts xml_str
    
    licenseKey = "edb7b1084a6e4"
    contributor = "kosaha@lexmark.com"
    ingest_resp = RestClient.get "http://service.twistage.com/api/ingest_key?licenseKey=#{licenseKey}&contributor=#{contributor}&library_id=default"
    ingest_sig = ingest_resp.body
    puts ingest_sig 
    
    response = RestClient.post "http://service.twistage.com/videos/#{video_id}/formats/source/slice.xml?signature=#{ingest_sig}", xml_str, :content_type => 'text/xml'
    puts response.code
    #Helix::Video.slice({ guid: video_id, :log => "", :formats => "source", use_raw_xml: xml_str})
  end
  
  def screenshotspage
    
  end
end
