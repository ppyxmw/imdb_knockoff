ImdbKnockoff::App.controllers :movies do
  before :new, :create do
    redirect url(:session, :new) unless session[:authenticated]
  end

  get :index do
  @movies = Movie.all
  render :index
  end

  get :new do
    @movie = Movie.new
    render :new
  end

  post :create, map: '/movies' do
    @movie = Movie.create(params[:movie])

    if @movie.valid?
      redirect url(:movies, :show, id: @movie.id)
    else
      render :new
    end
  end

  get :show, map: '/movies/:id' do
    @movie = Movie.find(params[:id])
    render :show
  end

  get :edit, map: 'movies/:id/edit' do
    @movie = Movie.find(params[:id])
    render :edit
  end
end
