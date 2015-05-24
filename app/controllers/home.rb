ImdbKnockoff::App.controllers :home do
  get :index, map: '/' do
    @time =  Time.now
    render 'index'
  end

  get :logout, map: '/home/logout' do
    session[:authenticated] = false
    redirect url(:home, :index)
  end
end
