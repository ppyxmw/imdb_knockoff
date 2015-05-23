require File.expand_path(File.dirname(__FILE__) + '/../../test_config.rb')

def session
  last_request.env['rack.session']
end


describe "POST /session/new" do
  it "responds OK" do
      get '/session/new'

      assert last_response.ok?, "wasn't ok"
    end
  end


describe "POST /session" do
  describe "with valid credentials" do
    it "creates a new session" do
      post "/session", {username: 'aaa', password: 'aaa'}

      assert session[:authenticated], "Not authenticated"
    end

    it "redirects to the new movie action" do
      post "/session", {username: 'aaa', password: 'aaa'}

      assert last_response.redirect?, "Didn't redirect"
    end
  end

  describe "with invalid credentials" do
    it "responds with a 403" do
      post "/session", {username: 'bad', password: 'bad'}

      assert last_response.status == 403, "Not a 403"
    end
  end
end
