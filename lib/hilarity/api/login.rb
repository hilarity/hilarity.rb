module Hilarity
	class API

		def post_login(username, password)
			request(
				:expects	=> 200,
				:method	 => :post,
				:path		 => '/api/v1/users/login',
				:query		=> { 'username' => username, 'password' => password }
			)
		end

	end
end
