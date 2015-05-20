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
  it "responds OK" do
    get "/movies/new"

    assert last_response.ok?
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
  before do
    post "/movies", { name: "Jaws", rating: 5 }
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
