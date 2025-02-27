require 'minitest/autorun'
require 'zxing/decodable'

class DecodableTest < Minitest::Test
  # Extend File class with Decodable
  File.include(Decodable)

  # Test URL class that includes Decodable
  class URL
    include Decodable
    def initialize(path)
      @path = path
    end
    def path
      @path
    end
  end

  def setup
    @file = File.open(File.expand_path(File.dirname(__FILE__) + '/../qrcode.png'))
    @uri = URL.new("http://2d-code.co.uk/images/bbc-logo-in-qr-code.gif")
    @bad_uri = URL.new("http://google.com")
  end

  def test_decode_provides_decoding_for_path_value
    assert_equal ZXing.decode(@file.path), @file.decode
    assert_equal ZXing.decode(@uri.path), @uri.decode
    assert_nil @bad_uri.decode
  end

  def test_decode_bang_provides_decoding_with_exceptions
    assert_equal ZXing.decode(@file.path), @file.decode!
    assert_equal ZXing.decode(@uri.path), @uri.decode!
    assert_raises(ZXing::BadImageException) { @bad_uri.decode! }
  end
end