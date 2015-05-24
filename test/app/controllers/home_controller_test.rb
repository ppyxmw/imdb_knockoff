require File.expand_path(File.dirname(__FILE__) + '/../../test_config.rb')

describe "/" do
  it "responds OK" do
    get "/"
    assert last_response.ok?, "Wasn't OK!"
  end
end
