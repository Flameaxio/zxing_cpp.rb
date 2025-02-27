require 'minitest/autorun'
require 'zxing'

class ZXingTest < Minitest::Test
  def setup
    @decoder = ZXing
    @uri = "http://2d-code.co.uk/images/bbc-logo-in-qr-code.gif"
    @path = File.expand_path(File.dirname(__FILE__) + '/qrcode.png')
    @file = File.new(@path)
    @google_logo = "http://www.google.com/logos/grandparentsday10.gif"
    @uri_result = "http://bbc.co.uk/programmes"
    @path_result = "http://rubyflow.com"
  end

  class Foo < Struct.new(:v)
    def to_s
      self.v
    end
  end

  def test_decode_url
    assert_equal @uri_result, @decoder.decode(@uri)
  end

  def test_decode_file_path
    assert_equal @path_result, @decoder.decode(@path)
  end

  def test_decode_returns_nil_on_failure
    assert_nil @decoder.decode(@google_logo)
  end

  def test_decode_bang_raises_exception_on_failure
    assert_raises(ZXing::ReaderException, ZXing::NotFoundException) do
      @decoder.decode!(@google_logo)
    end
  end

  def test_decode_objects_with_path_method
    assert_equal @path_result, @decoder.decode(@file)
  end

  def test_decode_calls_to_s_as_last_resort
    assert_equal @path_result, @decoder.decode(Foo.new(@path))
  end
end

class ZXingModuleTest < Minitest::Test
  def setup
    @ring = Class.new do
      include ZXing
    end.new
  end

  def test_includes_decode_methods
    assert @ring.respond_to?(:decode)
    assert @ring.respond_to?(:decode!)
  end
end