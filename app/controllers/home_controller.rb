require 'MathModel'

class HomeController < ApplicationController

  /def download_rating    
      unless params[:foursqare_url].blank?
        begin
          downloader = VenueDownloader.new
          venue = downloader.process_rating(params[:foursqare_url])

          if venue[:rating].nil?
            render :json => { :error => "Unable to get rating for this place" }, :status => 400
          else
            render :json => { rating: venue[:rating], rating_count: venue[:rating_count] }
          end
        rescue Exception => e
          render :json => { :error => "Unable to find this page on Foursquare" }, :status => 400
        end
      end
    end/

  def result
  	@n = params[:n].to_i
    @f = params[:f].map { |i| i.to_i }
    @a = params[:a].map { |i| i.to_i }
    @b = params[:b].map { |i| i.to_i }
    @y = params[:y].map { |i| i.to_i }
    @k_limit = params[:k_limit].map { |i| i.to_i }
    @s_limit = params[:s_limit].map { |i| i.to_i }
    @s_0 = params[:s_0].to_i
    @s_n = params[:s_n].to_i

    model = MathModel.new(@n, @f, @a, @b, @y, @k_limit, @s_limit, @s_0, @s_n)
    model.solve_problem
    result = model.read_result
    
    @z = result[:z]
    @xs = result[:xs_pairs]

    respond_to do |format|
    	format.js   {}
    end

  end

  def index
  end

end
