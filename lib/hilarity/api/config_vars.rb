module Hilarity
	class API

		# DELETE /apps/:app/config/:key
		def delete_config_var(app, key)
			request(
				:expects	=> 200,
				:method	 => :delete,
				:path		 => "/api/v1/apps/#{app}/config/#{escape(key)}"
			)
		end

		# GET /apps/:app/config
		def get_config_vars(app)
			request(
				:expects	=> 200,
				:method	 => :get,
				:path		 => "/api/v1/apps/#{app}/config"
			)
		end

		# PUT /apps/:app/config
		def put_config_vars(app, vars)
			request(
				:body		 => MultiJson.dump(vars),
				:expects	=> 200,
				:method	 => :put,
				:path		 => "/api/v1/apps/#{app}/config"
			)
		end

	end
end
