ImdbKnockoff::App.controllers :home do
  get :index, map: '/' do
    @time =  Time.now

    # @username = session[:username]
    render 'index'
  end

  # get :username, map: '/username' do
  #   session[:username] = Time.now
  #   redirect to ('/')
  # end

  get :logout, map: '/home/logout' do
    session[:authenticated] = false
    redirect url(:home, :index)
  end
end

