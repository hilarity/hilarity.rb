require File.expand_path("#{File.dirname(__FILE__)}/test_helper")

class TestAddons < Minitest::Test

  def test_delete_addon_addon_not_found
    with_app do |app_data|
      assert_raises(Hilarity::API::Errors::RequestFailed) do
        hilarity.delete_addon(app_data['name'], random_name)
      end
    end
  end

  def test_delete_addon_addon_not_installed
    with_app do |app_data|
      assert_raises(Hilarity::API::Errors::RequestFailed) do
        hilarity.delete_addon(app_data['name'], 'custom_domains:basic')
      end
    end
  end

  def test_delete_addon_app_not_found
    assert_raises(Hilarity::API::Errors::NotFound) do
      hilarity.delete_addon(random_name, 'logging:basic')
    end
  end

  def test_delete_addon
    with_app do |app_data|
      hilarity.post_addon(app_data['name'], 'deployhooks:http')
      response = hilarity.delete_addon(app_data['name'], 'deployhooks:http')

      assert_equal(200, response.status)
      assert_equal({
        'message' => nil,
        'price'   => 'free',
        'status'  => 'Uninstalled'
      }, response.body)
    end
  end

  def test_get_addons
    response = hilarity.get_addons
    data = File.read("#{File.dirname(__FILE__)}/../lib/hilarity/api/mock/cache/get_addons.json")

    assert_equal(200, response.status)
    assert_equal(MultiJson.load(data), response.body)
  end

  def test_get_addons_with_app
    with_app do |app_data|
      response = hilarity.get_addons(app_data['name'])

      assert_equal(200, response.status)
      assert_equal([{
        'attachable'          => false,
        'beta'                => false,
        'configured'          => true,
        'consumes_dyno_hours' => false,
        'description'         => 'Shared Database 5MB',
        'group_description'   => 'Shared Database',
        'name'                => 'shared-database:5mb',
        'plan_description'    => '5mb',
        'price'               => { 'cents' => 0, 'unit' => 'month' },
        'slug'                => '5mb',
        'state'               => 'public',
        'terms_of_service'    => false,
        'url'                 => nil
      }], response.body)
    end
  end

  def test_get_addons_with_app_app_not_found
    assert_raises(Hilarity::API::Errors::NotFound) do
      hilarity.get_addons(random_name)
    end
  end

  def test_post_addon
    with_app do |app_data|
      response = hilarity.post_addon(app_data['name'], 'deployhooks:http')

      assert_equal(200, response.status)
      assert_equal({
        'message' => nil,
        'price'   => 'free',
        'status'  => 'Installed'
      }, response.body)
    end
  end

  def test_post_addon_with_config
    with_app do |app_data|
      response = hilarity.post_addon(app_data['name'], 'deployhooks:http', {"url"=>"http://example.com"})

      assert_equal(200, response.status)
      assert_equal({
        'message' => nil,
        'price'   => 'free',
        'status'  => 'Installed'
      }, response.body)
    end
  end

  def test_post_add_on_with_config_parses_config_correctly
    with_app do |app_data|
      addon_post_path = "/apps/#{app_data['name']}/addons/deployhooks:http"
      Excon.stub({:method => :post, :path => addon_post_path}) do |params|
        {:body => params[:query], :status => 200}
      end
      response = hilarity.post_addon(app_data['name'], 'deployhooks:http', {"url"=>"http://example.com"})
      assert_equal({ "config[url]" => "http://example.com"}, response.body)
    end
    Excon.stubs.shift
  end

  def test_post_addon_addon_already_installed
    with_app do |app_data|
      assert_raises(Hilarity::API::Errors::RequestFailed) do
        hilarity.post_addon(app_data['name'], 'logging:basic')
        hilarity.post_addon(app_data['name'], 'logging:basic')
      end
    end
  end

  def test_post_addon_addon_type_already_installed
    with_app do |app_data|
      assert_raises(Hilarity::API::Errors::RequestFailed) do
        hilarity.post_addon(app_data['name'], 'logging:basic')
        hilarity.post_addon(app_data['name'], 'logging:expanded')
      end
    end
  end

  def test_post_addon_addon_not_found
    with_app do |app_data|
      assert_raises(Hilarity::API::Errors::NotFound) do
        hilarity.post_addon(app_data['name'], random_name)
      end
    end
  end

  def test_post_addon_app_not_found
    assert_raises(Hilarity::API::Errors::NotFound) do
      hilarity.post_addon(random_name, 'shared-database:5mb')
    end
  end

  def test_put_addon
    with_app do |app_data|
      response = hilarity.post_addon(app_data['name'], 'pgbackups:basic')
      response = hilarity.put_addon(app_data['name'], 'pgbackups:plus')

      assert_equal(200, response.status)
      assert_equal({
        'message' => 'Plan upgraded',
        'price'   => 'free',
        'status'  => 'Updated'
      }, response.body)
    end
  end

  def test_put_addon_addon_already_installed
    with_app do |app_data|
      assert_raises(Hilarity::API::Errors::RequestFailed) do
        hilarity.post_addon(app_data['name'], 'logging:basic')
        hilarity.put_addon(app_data['name'], 'logging:basic')
      end
    end
  end

  def test_put_addon_addon_not_found
    with_app do |app_data|
      assert_raises(Hilarity::API::Errors::NotFound) do
        hilarity.put_addon(app_data['name'], random_name)
      end
    end
  end

  def test_put_addon_addon_type_not_installed
    with_app do |app_data|
      assert_raises(Hilarity::API::Errors::RequestFailed) do
        hilarity.put_addon(app_data['name'], 'releases:basic')
      end
    end
  end

  def test_put_addon_app_not_found
    assert_raises(Hilarity::API::Errors::NotFound) do
      hilarity.put_addon(random_name, 'logging:basic')
    end
  end

end
