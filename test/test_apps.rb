require File.expand_path("#{File.dirname(__FILE__)}/test_helper")

class TestApps < Minitest::Test

  def test_delete_app
    with_app do |app_data|
      response = hilarity.delete_app(app_data['name'])
      assert_equal({}, response.body)
      assert_equal(200, response.status)
    end
  end

  def test_delete_app_not_found
    assert_raises(Hilarity::API::Errors::NotFound) do
      hilarity.delete_app(random_name)
    end
  end

  def test_get_apps
    with_app do |app_data|
      response = hilarity.get_apps
      assert_equal(200, response.status)
      assert(response.body.detect {|app| app['name'] == app_data['name']})
    end
  end

  def test_get_app
    with_app do |app_data|
      response = hilarity.get_app(app_data['name'])
      assert_equal(200, response.status)
      assert_equal(app_data['name'], response.body['name'])
    end
  end

  def test_get_app_not_found
    assert_raises(Hilarity::API::Errors::NotFound) do
      hilarity.get_app(random_name)
    end
  end

  def test_get_app_maintenance
    with_app do |app_data|
      response = hilarity.get_app_maintenance(app_data['name'])

      assert_equal(200, response.status)
      assert_equal({'maintenance' => false}, response.body)

      hilarity.post_app_maintenance(app_data['name'], '1')
      response = hilarity.get_app_maintenance(app_data['name'])

      assert_equal(200, response.status)
      assert_equal({'maintenance' => true}, response.body)
    end
  end

  def test_post_app
    response = hilarity.post_app

    assert_equal(202, response.status)

    hilarity.delete_app(response.body['name'])
  end

  def test_post_app_with_name
    name = random_name
    response = hilarity.post_app('name' => name)

    assert_equal(202, response.status)
    assert_equal(name, response.body['name'])

    hilarity.delete_app(name)
  end

  def test_post_app_with_duplicate_name
    name = random_name
    response = hilarity.post_app('name' => name)

    assert_raises(Hilarity::API::Errors::RequestFailed) do
      hilarity.post_app('name' => name)
    end

    hilarity.delete_app(name)
  end

  def test_post_app_with_stack
    response = hilarity.post_app('stack' => 'cedar')

    assert_equal(202, response.status)
    assert_equal('cedar', response.body['stack'])

    hilarity.delete_app(response.body['name'])
  end

  def test_put_app_not_found
    name = random_name
    assert_raises(Hilarity::API::Errors::NotFound) do
      hilarity.put_app(name, 'name' => random_name)
    end
  end

  def test_put_app_with_name
    with_app do |app_data|
      new_name = random_name
      response = hilarity.put_app(app_data['name'], 'name' => new_name)

      assert_equal(200, response.status)
      assert_equal({'name' => new_name}, response.body)

      hilarity.delete_app(new_name)
    end
  end

  def test_put_app_with_transfer_owner_non_collaborator
    with_app do |app_data|
      assert_raises(Hilarity::API::Errors::RequestFailed) do
        hilarity.put_app(app_data['name'], 'transfer_owner' => 'wesley@hilarity.com')
      end
    end
  end

  def test_put_app_with_transfer_owner
    with_app do |app_data|
      email_address = 'wesley@hilarity.com'
      hilarity.post_collaborator(app_data['name'], email_address)
      response = hilarity.put_app(app_data['name'], 'transfer_owner' => email_address)

      assert_equal(200, response.status)
      assert_equal({'name' => app_data['name']}, response.body)

      hilarity.delete_collaborator(app_data['name'], email_address)
    end
  end

  def test_post_app_maintenance
    with_app do |app_data|
      response = hilarity.post_app_maintenance(app_data['name'], '1')

      assert_equal(200, response.status)
      assert_equal("", response.body)

      response = hilarity.post_app_maintenance(app_data['name'], '0')

      assert_equal(200, response.status)
      assert_equal("", response.body)
    end
  end
end
