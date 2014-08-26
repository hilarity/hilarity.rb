require File.expand_path("#{File.dirname(__FILE__)}/test_helper")

class TestReleases < Minitest::Test

  def test_get_releases
    with_app do |app_data|
      response = hilarity.get_releases(app_data['name'])

      assert_equal(200, response.status)
      # body assertion?
    end
  end

  def test_get_releases_app_not_found
    assert_raises(Hilarity::API::Errors::NotFound) do
      hilarity.get_releases(random_name)
    end
  end

  def test_get_release
    with_app do |app_data|
      current = hilarity.get_releases(app_data['name']).body.last['name']
      response = hilarity.get_release(app_data['name'], current)

      assert_equal(200, response.status)
      # body assertion?
    end
  end

  def test_get_release_current
    with_app do |app_data|
      response = hilarity.get_release(app_data['name'], 'current')

      assert_equal(200, response.status)
      # body assertion?
    end
  end

  def test_get_release_app_not_found
    assert_raises(Hilarity::API::Errors::NotFound) do
      hilarity.get_release(random_name, 'v2')
    end
  end

  def test_get_release_release_not_found
    assert_raises(Hilarity::API::Errors::NotFound) do
      hilarity.get_release(random_name, 'v0')
    end
  end

  def test_post_release
    with_app do |app_data|
      current = hilarity.get_releases(app_data['name']).body.last['name']
      response = hilarity.post_release(app_data['name'], current)

      assert_equal(200, response.status)
      # body assertion?
    end
  end

  def test_post_release_app_not_found
    assert_raises(Hilarity::API::Errors::NotFound) do
      hilarity.post_release(random_name, 'v3')
    end
  end

  def test_post_release_release_not_found
    assert_raises(Hilarity::API::Errors::NotFound) do
      hilarity.post_release(random_name, 'v0')
    end
  end

end
