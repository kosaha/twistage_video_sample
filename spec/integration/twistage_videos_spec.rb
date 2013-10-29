require 'spec_helper'

describe "TwistageVideos" do
  describe "GET /twistage_mainpage", :type => :feature do
    it "displays list of twistage videos" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      visit twistage_mainpage_path
      page.should have_content("Twistage Videos")
    end
  end
  
  describe "GET /twistage_show", :type => :feature do
    it "shows the selected video" do

      visit twistage_mainpage_path
      click_link "WildLife"
      page.should have_content("WildLife")
    end
  end
  
  describe "GET /twistage_get_stillframe", :type => :feature do
    it "shows the stillframes of the video" do

      visit twistage_mainpage_path
      click_link "Get Screenshots"
      expect(page.all("img").count).to eql 5
    end
  end
end
