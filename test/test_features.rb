require File.expand_path("#{File.dirname(__FILE__)}/test_helper")

class TestFeatures < Minitest::Test

  def setup
    @feature_data ||= begin
      data = File.read("#{File.dirname(__FILE__)}/../lib/hilarity/api/mock/cache/get_features.json")
      features_data = MultiJson.load(data)
      features_data.detect {|feature| feature['name'] == 'user_env_compile'}
    end
  end

  def test_delete_feature
    with_app do |app_data|
      hilarity.post_feature('user_env_compile', app_data['name'])
      response = hilarity.delete_feature('user_env_compile', app_data['name'])

      assert_equal(200, response.status)
      assert_equal(@feature_data, response.body)
    end
  end

  def test_delete_feature_app_not_found
    assert_raises(Hilarity::API::Errors::RequestFailed) do
      hilarity.delete_feature('user_env_compile', random_name)
    end
  end

  def test_delete_feature_feature_not_found
    with_app do |app_data|
      assert_raises(Hilarity::API::Errors::NotFound) do
        hilarity.delete_feature(random_name, app_data['name'])
      end
    end
  end

  def test_get_features
    with_app do |app_data|
      response = hilarity.get_features(app_data['name'])
      data = File.read("#{File.dirname(__FILE__)}/../lib/hilarity/api/mock/cache/get_features.json")

      assert_equal(200, response.status)
      assert_equal(MultiJson.load(data), response.body)
    end
  end

  def test_get_feature
    with_app do |app_data|
      response = hilarity.get_feature('user_env_compile', app_data['name'])

      assert_equal(200, response.status)
      assert_equal(@feature_data, response.body)
    end
  end

  def test_get_features_feature_not_found
    with_app do |app_data|
      assert_raises(Hilarity::API::Errors::NotFound) do
        hilarity.get_feature(random_name, app_data['name'])
      end
    end
  end

  def test_post_feature
    with_app do |app_data|
      response = hilarity.post_feature('user_env_compile', app_data['name'])

      assert_equal(201, response.status)
      assert_equal(@feature_data.merge('enabled' => true), response.body)
    end
  end

  def test_post_feature_app_not_found
    assert_raises(Hilarity::API::Errors::NotFound) do
      hilarity.post_feature('user_env_compile', random_name)
    end
  end

  def test_post_feature_feature_not_found
    with_app do |app_data|
      assert_raises(Hilarity::API::Errors::NotFound) do
        hilarity.post_feature(random_name, app_data['name'])
      end
    end
  end

end
