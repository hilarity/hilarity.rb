require File.expand_path("#{File.dirname(__FILE__)}/test_helper")

class TestDomains < Minitest::Test

  def test_delete_domain_app_not_found
    assert_raises(Hilarity::API::Errors::NotFound) do
      hilarity.delete_domain(random_name, 'example.com')
    end
  end

  def test_delete_domain
    with_app do |app_data|
      domain = random_domain
      hilarity.post_domain(app_data['name'], domain)
      response = hilarity.delete_domain(app_data['name'], domain)

      assert_equal(200, response.status)
      assert_equal({}, response.body)
    end
  end

  def test_delete_domains
    with_app do |app_data|
      hilarity.post_domain(app_data['name'], random_domain)
      response = hilarity.delete_domains(app_data['name'])

      assert_equal(200, response.status)
      assert_equal("", response.body)
    end
  end

  def test_get_domains
    with_app do |app_data|
      response = hilarity.get_domains(app_data['name'])

      assert_equal(200, response.status)
      assert_equal([], response.body)
    end
  end

  def test_get_domains_app_not_found
    assert_raises(Hilarity::API::Errors::NotFound) do
      hilarity.get_domains(random_name)
    end
  end

  def test_post_domain
    with_app do |app_data|
      domain = random_domain
      response = hilarity.post_domain(app_data['name'], domain)

      assert_equal(201, response.status)
      assert_equal({'domain' => domain}, response.body)

      hilarity.delete_domain(app_data['name'], domain)
    end
  end

  def test_post_domain_app_not_found
    assert_raises(Hilarity::API::Errors::NotFound) do
      hilarity.post_domain(random_name, 'example.com')
    end
  end

end
