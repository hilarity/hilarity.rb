require File.expand_path("#{File.dirname(__FILE__)}/test_helper")

class TestConfigVars < Minitest::Test

  def test_delete_app_config_var
    with_app('stack' => 'cedar') do |app_data|
      hilarity.put_config_vars(app_data['name'], {'KEY' => 'value'})

      response = hilarity.delete_config_var(app_data['name'], 'KEY')

      assert_equal(200, response.status)
      assert_equal({}, response.body)
    end
  end

  def test_delete_app_config_var_app_not_found
    assert_raises(Hilarity::API::Errors::NotFound) do
      hilarity.delete_config_var(random_name, 'key')
    end
  end

  def test_get_app_config_vars
    with_app('stack' => 'cedar') do |app_data|
      response = hilarity.get_config_vars(app_data['name'])

      assert_equal(200, response.status)
      assert_equal({}, response.body)
    end
  end

  def test_get_app_config_vars_app_not_found
    assert_raises(Hilarity::API::Errors::NotFound) do
      hilarity.get_config_vars(random_name)
    end
  end

  def test_put_app_config_vars
    with_app('stack' => 'cedar') do |app_data|
      response = hilarity.put_config_vars(app_data['name'], {'KEY' => 'value'})

      assert_equal(200, response.status)
      assert_equal({'KEY' => 'value'}, response.body)

      hilarity.delete_config_var(app_data['name'], 'KEY')
    end
  end

  def test_put_app_config_vars_app_not_found
    assert_raises(Hilarity::API::Errors::NotFound) do
      hilarity.put_config_vars(random_name, {'KEY' => 'value'})
    end
  end

end
