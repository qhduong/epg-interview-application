require 'net/http'
require 'json'

class IndexController < ApplicationController

	def index
		render "index", :layout => "application"
	end

	def search
		acronymn = params[:sf]
		limit    = params[:limit] 
		result   = []

		# get int from limit
		if is_int_string(limit)
			limit = limit.to_i
		else 
			limit = nil
		end
			
		if acronymn.blank?
			render "result", :layout => "application", :locals => {:result => result}
			return
		end

		url      = URI.parse("http://www.nactem.ac.uk/software/acromine/dictionary.py?sf=#{acronymn}")
		request  = Net::HTTP::Get.new(url.to_s)
		response = Net::HTTP.start(url.host, url.port) {|http|
		  http.request(request)
		}

		json = JSON.parse(response.body)
		
		unless json.empty? 
			json.each do |element| # each element in json response
				element['lfs'].each do |each_lfs| # get the lfs of each array element
					break unless limit.nil? or result.size < limit
					result.push each_lfs['lf'] # get the actual long form
				end
			end
		end 
		
		render "result", :layout => "application", :locals => {:result => result}
	end

	private 

	def is_int_string(string)
		return if string.blank?

		return !string.match(/^\d+$/).nil?
	end
end
