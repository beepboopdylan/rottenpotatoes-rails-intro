class Movie < ActiveRecord::Base
  def self.with_ratings(ratings_list)
  # if ratings_list is an array such as ['G', 'PG', 'R'], retrieve all
  #  movies with those ratings

  # if ratings_list is nil, retrieve ALL movies
    if ratings_list.nil? || ratings_list.empty?
      # https://guides.rubyonrails.org/active_record_querying.html#removing-all-scoping
      # here is where all is
      return all
    else
      # https://api.rubyonrails.org/classes/ActiveRecord/QueryMethods.html#method-i-where
      return where(rating: ratings_list)
    end
  end

  # must be here because distinct is in scope of only this class. 
  # In order to access, it must be called anywhere outside in here
  # This is AKA  SELECT DISTINCT rating FROM movies ORDER BY rating
  def self.ratings
    # https://guides.rubyonrails.org/active_record_querying.html
    distinct.order(:rating).pluck(:rating)
  end

end