require 'spec_helper'

describe TwistageController do
  render_views
    
  describe "GET 'mainpage'" do
    
    it "returns http success" do
      get 'mainpage'
      response.should be_success
    end
    
    it "renders mainpage.html.erb" do
      get 'mainpage'
      expect(response).to render_template("mainpage")
    end
    
    it "says 'Twistage Videos'" do
      get 'mainpage'
      expect(response.body).to match(/Twistage Videos/)
    end
    
    it "contains video with title retrieved from twistage server" do
      get 'mainpage'
      video_title = assigns(:videos)[0].title
      expect(response.body).to match(video_title)
    end
  end

  describe "GET 'show'" do
    
    it "returns http success" do
      get 'show'
      response.should be_success
    end
    
    it "renders show.html.erb" do
      get 'show'
      expect(response).to render_template("show")
    end
    
    it "says 'Watch Video'" do
      get 'show'
      expect(response.body).to match(/Watch Video/)
    end
    
    it "contains video with title retrieved from twistage server" do
      get 'show', { :id => 'a4f3f53d377c3', :title => 'WildLife' }
      expect(response.body).to match('WildLife')
    end
  end

end
