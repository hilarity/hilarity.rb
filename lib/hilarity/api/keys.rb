module Hilarity
	class API

		# DELETE /ssh_keys/:key
		def delete_key(key)
			request(
				:expects	=> 200,
				:method	 => :delete,
				:path		 => "/api/v1/ssh_keys/#{escape(key)}"
			)
		end

		# DELETE /ssh_keys
		def delete_keys
			request(
				:expects	=> 200,
				:method	 => :delete,
				:path		 => "/api/v1/ssh_keys"
			)
		end

		# GET /ssh_keys
		def get_keys
			request(
				:expects	=> 200,
				:method	 => :get,
				:path		 => "/api/v1/ssh_keys"
			)
		end

		# POST /ssh_keys
		def post_key(key)
			request(
				:body		 => key,
				:expects	=> 200,
				:method	 => :post,
				:path		 => "/api/v1/ssh_keys"
			)
		end

	end
end
