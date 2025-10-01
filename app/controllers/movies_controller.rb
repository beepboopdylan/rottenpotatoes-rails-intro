class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    # # variables from index.html.erb: movies, all
    # @all_ratings = Movie.ratings

    # if params[:ratings].present?
    #   @ratings_to_show = params[:ratings].keys # -->["G", "PG"]
    # else
    #   @ratings_to_show = @all_ratings # empty, so return everything
    # end

    # @sort_by = params[:sort_by]
    # @movies = Movie.with_ratings(@ratings_to_show)

    # if @sort_by != nil
    #   # user selected, so return sorted
    #   @movies = @movies.order(@sort_by)
    # end

    @all_ratings = Movie.ratings
    # we need to save ratings
    # idea: when off, save into session, when on, load
    if params[:ratings] != nil
      # user just submits form
      session[:ratings] = params[:ratings]
      @ratings_to_show = params[:ratings].keys
      # save everything so we remember the request
    elsif params[:commit] != nil
      # if all are unchecked, return everything
      @ratings_to_show = @all_ratings
    elsif session[:ratings] != nil
      # user didn't pass params, but have saved
      @ratings_to_show = session[:ratings].keys
    else
      # default
      @ratings_to_show = @all_ratings
    end
    
    # another thing to remember is the sorted by
    if params[:sort_by] != nil
      session[:sort_by] = params[:sort_by]
      @sort_by = params[:sort_by]
    elsif session[:sort_by]!= nil
      @sort_by = session[:sort_by]
    else
      @sort_by = nil
    end

    # one more thing: if we have remembered states but no params,
    # we can use redirect_to movies_path

    if (params[:ratings] == nil && params[:sort_by] == nil)
      if session[:ratings] != nil || session[:sort_by] != nil
        return redirect_to movies_path(ratings: session[:ratings], sort_by: session[:sort_by])
      end
    end
    
    @movies = Movie.with_ratings(@ratings_to_show)
    if @sort_by != nil
      # user selected, so return sorted
      @movies = @movies.order(@sort_by)
    end

  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
