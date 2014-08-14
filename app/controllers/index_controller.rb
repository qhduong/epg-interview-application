require 'net/http'
require 'json'

class IndexController < ApplicationController

	def index
		render "index", :layout => "application"
	end

	def search
		acronymn = params[:sf]
		limit    = params[:limit].to_i

		url = URI.parse("http://www.nactem.ac.uk/software/acromine/dictionary.py?sf=#{acronymn}")
		request  = Net::HTTP::Get.new(url.to_s)
		response = Net::HTTP.start(url.host, url.port) {|http|
		  http.request(request)
		}

		json   = JSON.parse response.body
		result = []

		unless json.empty? 
			json.each do |element| # each element in json response
				element['lfs'].each do |each_lfs| # get the lfs of each array element
					break if result.size >= limit
					result.push each_lfs['lf'] # get the actual long form
				end
			end
		end 
		@result = result

		render "result", :layout => "application"
	end
end
