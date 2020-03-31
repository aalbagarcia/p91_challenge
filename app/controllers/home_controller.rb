class HomeController < ApplicationController
	def show
		Visit.create
		@total_view_count = Visit.count
	end
end