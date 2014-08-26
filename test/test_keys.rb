require File.expand_path("#{File.dirname(__FILE__)}/test_helper")

class TestKeys < Minitest::Test
  KEY_DATA = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCz29znMi/UJX/nvkRSO5FFugKhU9DkkI53E0vXUnP8zeLFxMgyUqmXryPVjWtGzz2LRWqjm14SbqHAmM44pGHVfBIp6wCKBWSUYGv/FxOulwYgtWzz4moxWLZrFyWWgJAnehcVUifHNgzKwT2ovWm2ns52681Z8yFK3K8/uLStDjLIaPePEOaxaTvgIxZNsfyEoXoHcyTPwdR1GtQuDTuDYqYmjmPCoKybYnXrTQ1QFuQxDneBkswQYSl0H2aLf3uBK4F01hr+azXQuSe39eSV4I/TqzmNJlanpILT9Jz3/J1i4r6brpF3AxLnFnb9ufIbzQAIa/VZIulfrZkcBsUl david@carbon.local"

  def test_delete_key_key_not_found
    assert_raises(Hilarity::API::Errors::NotFound) do
      hilarity.delete_key(random_name)
    end
  end

  def test_delete_key
    hilarity.post_key(KEY_DATA)
    response = hilarity.delete_key('david@carbon.local')

    assert_equal(200, response.status)
  end

  def test_delete_keys
    response = hilarity.delete_keys

    assert_equal(200, response.status)
  end

  def test_get_keys
    response = hilarity.get_keys

    assert_equal(200, response.status)
  end

  def test_post_key
    response = hilarity.post_key(KEY_DATA)

    assert_equal(200, response.status)

    hilarity.delete_key('david@carbon.local')
  end

end
