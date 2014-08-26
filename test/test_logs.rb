require File.expand_path("#{File.dirname(__FILE__)}/test_helper")

class TestLogs < Minitest::Test

  def test_get_logs
    with_app do |app_data|
      response = hilarity.get_logs(app_data['name'], 'logplex' => true)

      assert_equal(200, response.status)
      assert_match(%r{^https://logplex\.hilarity\.com/sessions/[-a-zA-Z0-9]*\?srv=[0-9]*$}, response.body)
    end
  end

  def test_get_logs_no_options
    with_app do |app_data|
      response = hilarity.get_logs(app_data['name'])

      assert_equal(200, response.status)
      assert_match(%r{^https://logplex\.hilarity\.com/sessions/[-a-zA-Z0-9]*\?srv=[0-9]*$}, response.body)
    end
  end
  
  def test_get_logs_app_not_found
    assert_raises(Hilarity::API::Errors::NotFound) do
      hilarity.get_logs(random_name, 'logplex' => true)
    end
  end

end
