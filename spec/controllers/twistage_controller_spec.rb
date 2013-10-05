require 'spec_helper'

describe TwistageController do

  describe "GET 'mainpage'" do
    it "returns http success" do
      get 'mainpage'
      response.should be_success
    end
  end

end
