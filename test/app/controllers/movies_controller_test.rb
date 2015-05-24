require File.expand_path(File.dirname(__FILE__) + '/../../test_config.rb')

describe "GET /movies" do
  it "responds OK" do

    get "/movies"
    assert last_response.ok?
  end

  it "lists the saved movies" do
    @dogs_movie = Movie.create!(name: 'Dogs', rating: 3)
    @cats_movie = Movie.create!(name: 'Cats', rating: 1)

    get "/movies"

    assert_includes last_response.body, @dogs_movie.name
    assert_includes last_response.body, @cats_movie.name
  end

  it "has a 'new movie' link" do

    get "/movies"
    assert_includes last_response.body, 'http://localhost:3000/movies/new'
  end
end

describe "GET /movies/new" do
  describe "with  invalid credentials" do
    it "redirects to  the login page" do
      get "/movies/new"

      assert last_response.redirect?, "Didn't redirect"
    end
  end

  describe "with valid credentials" do
    it "responds OK" do
      get "/movies/new", {}, { 'rack.session' => {authenticated: true} }

      assert last_response.ok?
    end
  end
end

describe "GET /movies/:id" do
  before do
    @movie = Movie.create!(name: 'Jaws', rating: 5)
    get "/movies/#{@movie.id}"
  end

  it "displays the name" do
    assert_includes last_response.body, @movie.name
  end

  it "displays the rating" do
    assert_includes last_response.body, @movie.rating.to_s
  end
end

describe "POST /movies" do

  def create_movie(authenticated:)
    args = if authenticated
      { 'rack.session' => {authenticated: true }}
    else
      {}
    end
    post "/movies", {movie: {name: "Jaws", rating: 5}}, args
  end

  describe "when unauthenticated" do
    it "redirects to the login page" do
      create_movie(authenticated: false)

      assert last_response.redirect?, "Not redirected"
      assert_includes last_response.location,  "/session/new"
    end
  end


  describe "when authenticated" do
    before do
      create_movie(authenticated: true)
    end

    it "creates a movie" do
      jaws = Movie.first

      assert_equal jaws.name, "Jaws"
      assert_equal jaws.rating, 5
    end

    it "redirects to our new movie" do
      assert last_response.redirect?
    end
  end
end

describe "GET /movies/:id/edit" do
  before do
    @movie = Movie.create!(name: 'The ODB', rating: 3)
    get "/movies/#{@movie.id}/edit"
  end

  it "shows a selected movie's params" do
    assert_includes last_response.body, @movie.name
    assert_includes last_response.body, @movie.rating.to_s
  end

  it "it renders the edit page" do
    assert last_response.ok?
    assert_includes last_response.body, "update"
  end
end

describe "GET /movies/:id/delete" do
  before do
    @movie = Movie.create!(name: 'The ODB', rating: 3)
    @movie2 = Movie.create!(name: 'The Job', rating: 2)
  end

  it "check movie added" do
    get "/movies"
    assert_includes last_response.body, @movie.name
  end

  it "deletes a movie" do
    get "/movies/#{@movie.id}/delete"
    refute_includes last_response.body, @movie.name
  end
end
