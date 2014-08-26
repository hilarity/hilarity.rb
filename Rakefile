require "bundler/gem_tasks"

require 'rake/testtask'

task :default => :test

Rake::TestTask.new do |task|
  task.name = :test
  task.test_files = FileList['test/test*.rb']
end

task :cache, [:api_key] do |task, args|
  unless args.api_key
    puts('cache requires an api key, please call as `cache[api_key]`')
  else
    require "#{File.dirname(__FILE__)}/lib/hilarity/api"
    hilarity = Hilarity::API.new(:api_key => args.api_key)

    addons = MultiJson.dump(hilarity.get_addons.body)
    File.open("#{File.dirname(__FILE__)}/lib/hilarity/api/mock/cache/get_addons.json", 'w') do |file|
      file.write(addons)
    end

    app_name = "hilarity-api-#{Time.now.to_i}"
    app = hilarity.post_app('name' => app_name)
    features = MultiJson.dump(hilarity.get_features(app_name).body)
    File.open("#{File.dirname(__FILE__)}/lib/hilarity/api/mock/cache/get_features.json", 'w') do |file|
      file.write(features)
    end
    hilarity.delete_app(app_name)

    user = hilarity.get_user.body
    user["email"] = "user@example.com"
    user["id"] = "123456@users.hilarity.com"
    user = MultiJson.dump(user)
    File.open("#{File.dirname(__FILE__)}/lib/hilarity/api/mock/cache/get_user.json", 'w') do |file|
      file.write(user)
    end

  end
end
