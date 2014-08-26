require File.expand_path("#{File.dirname(__FILE__)}/test_helper")

class TestSslEndpoints < Minitest::Test

  def test_delete_ssl_endpoint
    skip if MOCK
    with_app do |app_data|
      hilarity.post_addon(app_data['name'], 'ssl:endpoint')
      ssl_endpoint_data = hilarity.post_ssl_endpoint(app_data['name'], data_site_crt, data_site_key).body

      response = hilarity.delete_ssl_endpoint(app_data['name'], ssl_endpoint_data['cname'])

      data = response.body['ssl_cert']
      assert_equal(false, data['ca_signed?'])
      assert_equal(true, data['self_signed?'])
      assert_equal(['example.com'], data['cert_domains'])
      assert_equal('2013/08/01 15:32:09 -0700', data['expires_at'])
      assert_equal('/C=US/ST=CA/O=Hilarity/CN=example.com', data['issuer'])
      assert_equal('2012/08/01 15:32:09 -0700', data['starts_at'])
      assert_equal('/C=US/ST=CA/O=Hilarity/CN=example.com', data['subject'])
      assert_equal(200, response.status)
    end
  end

  def test_delete_ssl_endpoint_app_not_found
    skip if MOCK
    assert_raises(Hilarity::API::Errors::NotFound) do
      hilarity.delete_ssl_endpoint(random_name, 'key')
    end
  end

  def test_get_ssl_endpoint
    skip if MOCK
    with_app do |app_data|
      hilarity.post_addon(app_data['name'], 'ssl:endpoint')
      ssl_endpoint_data = hilarity.post_ssl_endpoint(app_data['name'], data_site_crt, data_site_key).body

      response = hilarity.get_ssl_endpoint(app_data['name'], ssl_endpoint_data['cname'])

      data = response.body['ssl_cert']
      assert_equal(false, data['ca_signed?'])
      assert_equal(true, data['self_signed?'])
      assert_equal(['example.com'], data['cert_domains'])
      assert_equal('2013/08/01 15:32:09 -0700', data['expires_at'])
      assert_equal('/C=US/ST=CA/O=Hilarity/CN=example.com', data['issuer'])
      assert_equal('2012/08/01 15:32:09 -0700', data['starts_at'])
      assert_equal('/C=US/ST=CA/O=Hilarity/CN=example.com', data['subject'])
      assert_equal(200, response.status)
    end
  end

  def test_get_ssl_endpoints
    skip if MOCK
    with_app do |app_data|
      hilarity.post_addon(app_data['name'], 'ssl:endpoint')
      hilarity.post_ssl_endpoint(app_data['name'], data_site_crt, data_site_key)

      response = hilarity.get_ssl_endpoints(app_data['name'])

      data = response.body.first['ssl_cert']
      assert_equal(false, data['ca_signed?'])
      assert_equal(true, data['self_signed?'])
      assert_equal(['example.com'], data['cert_domains'])
      assert_equal('2013/08/01 15:32:09 -0700', data['expires_at'])
      assert_equal('/C=US/ST=CA/O=Hilarity/CN=example.com', data['issuer'])
      assert_equal('2012/08/01 15:32:09 -0700', data['starts_at'])
      assert_equal('/C=US/ST=CA/O=Hilarity/CN=example.com', data['subject'])
      assert_equal(200, response.status)
    end
  end

  def test_post_ssl_endpoint
    skip if MOCK
    with_app do |app_data|
      hilarity.post_addon(app_data['name'], 'ssl:endpoint')

      response = hilarity.post_ssl_endpoint(app_data['name'], data_site_crt, data_site_key)

      data = response.body['ssl_cert']
      assert_equal(false, data['ca_signed?'])
      assert_equal(true, data['self_signed?'])
      assert_equal(['example.com'], data['cert_domains'])
      assert_equal('2013/08/01 15:32:09 -0700', data['expires_at'])
      assert_equal('/C=US/ST=CA/O=Hilarity/CN=example.com', data['issuer'])
      assert_equal('2012/08/01 15:32:09 -0700', data['starts_at'])
      assert_equal('/C=US/ST=CA/O=Hilarity/CN=example.com', data['subject'])
      assert_equal(200, response.status)
    end
  end

  def test_post_ssl_endpoint_rollback
    skip if MOCK
    with_app do |app_data|
      hilarity.post_addon(app_data['name'], 'ssl:endpoint')
      ssl_endpoint_data = hilarity.post_ssl_endpoint(app_data['name'], data_site_crt, data_site_key).body
      hilarity.put_ssl_endpoint(app_data['name'], ssl_endpoint_data['cname'], data_site_crt, data_site_key)

      response = hilarity.post_ssl_endpoint_rollback(app_data['name'], ssl_endpoint_data['cname'])

      data = response.body['ssl_cert']
      assert_equal(false, data['ca_signed?'])
      assert_equal(true, data['self_signed?'])
      assert_equal(['example.com'], data['cert_domains'])
      assert_equal('2013/08/01 15:32:09 -0700', data['expires_at'])
      assert_equal('/C=US/ST=CA/O=Hilarity/CN=example.com', data['issuer'])
      assert_equal('2012/08/01 15:32:09 -0700', data['starts_at'])
      assert_equal('/C=US/ST=CA/O=Hilarity/CN=example.com', data['subject'])
      assert_equal(200, response.status)
    end
  end

  def test_put_ssl_endpoint
    skip if MOCK
    with_app do |app_data|
      hilarity.post_addon(app_data['name'], 'ssl:endpoint')
      ssl_endpoint_data = hilarity.post_ssl_endpoint(app_data['name'], data_site_crt, data_site_key).body

      response = hilarity.put_ssl_endpoint(app_data['name'], ssl_endpoint_data['cname'], data_site_crt, data_site_key)

      data = response.body['ssl_cert']
      assert_equal(false, data['ca_signed?'])
      assert_equal(true, data['self_signed?'])
      assert_equal(['example.com'], data['cert_domains'])
      assert_equal('2013/08/01 15:32:09 -0700', data['expires_at'])
      assert_equal('/C=US/ST=CA/O=Hilarity/CN=example.com', data['issuer'])
      assert_equal('2012/08/01 15:32:09 -0700', data['starts_at'])
      assert_equal('/C=US/ST=CA/O=Hilarity/CN=example.com', data['subject'])
      assert_equal(200, response.status)
    end
  end

end
