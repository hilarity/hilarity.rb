require "bundler/gem_tasks"

task :cache, [:api_key] do |task, args|
	unless args.api_key
		puts('cache requires an api key, please call as `cache[api_key]`')
	else
		require "#{File.dirname(__FILE__)}/lib/hilarity/api"
		hilarity = Hilarity::API.new(:api_key => args.api_key)
	end
end
