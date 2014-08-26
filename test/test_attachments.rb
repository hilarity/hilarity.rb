require File.expand_path("#{File.dirname(__FILE__)}/test_helper")

class TestAttachments < Minitest::Test

  def test_get_attachments
    with_app do |app_data|
      response = hilarity.get_attachments(app_data['name'])

      assert_equal(200, response.status)
      assert_equal(
        [],
        response.body
      )
    end
  end

  def test_get_attachments_app_not_found
    assert_raises(Hilarity::API::Errors::NotFound) do
      hilarity.get_attachments(random_name)
    end
  end

end
