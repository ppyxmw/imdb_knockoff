ImdbKnockoff::App.controllers :session do
  get :new do
    render :new
  end

  post :create, map: '/session' do
    #NOTE: This is not secure!
    if params[:username] == "aaa" && params[:password] == "aaa"
      session[:authenticated] = true
      redirect url(:movies, :new)
    else
      halt 403, "NOT AUTHORIZED"
    end
  end
end
