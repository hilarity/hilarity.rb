module Hilarity
	class API

		# GET /user/me
		def get_user
			request(
				:expects	=> 200,
				:method	 => :get,
				:path		 => "/api/v1/users/me"
			)
		end

	end
end
