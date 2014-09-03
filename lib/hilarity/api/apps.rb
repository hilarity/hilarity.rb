module Hilarity
	class API

		# DELETE /apps/:app
		def delete_app(app)
			request(
				:expects	=> 200,
				:method	 => :delete,
				:path		 => "/api/v1/apps/#{app}"
			)
		end

		# GET /apps
		def get_apps
			request(
				:expects	=> 200,
				:method	 => :get,
				:path		 => "/api/v1/apps"
			)
		end

		# GET /apps/:app
		def get_app(app)
			request(
				:expects	=> 200,
				:method	 => :get,
				:path		 => "/api/v1/apps/#{app}"
			)
		end

		# GET /apps/:app/server/maintenance
		def get_app_maintenance(app)
			request(
				:expects	=> 200,
				:method	 => :get,
				:path		 => "/api/v1/apps/#{app}/server/maintenance"
			)
		end

		# POST /apps
		def post_app(params={})
			request(
				:expects	=> 202,
				:method	 => :post,
				:path		 => '/api/v1/apps',
				:query		=> app_params(params)
			)
		end

		# POST /apps/:app/server/maintenance
		def post_app_maintenance(app, maintenance_mode)
			request(
				:expects	=> 200,
				:method	 => :post,
				:path		 => "/api/v1/apps/#{app}/server/maintenance",
				:query		=> {'maintenance_mode' => maintenance_mode}
			)
		end

		# PUT /apps/:app
		def put_app(app, params)
			request(
				:expects	=> 200,
				:method	 => :put,
				:path		 => "/api/v1/apps/#{app}",
				:query		=> app_params(params)
			)
		end

	end
end
