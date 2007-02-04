require "test/unit"
require "ulzss"
require "stringio"
class TC_LZSS < Test::Unit::TestCase
  include ULZSS
  def setup
  end

  def teardown
  end

  def test_window
    window = Window.new "abcabcabcf"
    assert_equal(true, window.next)
    assert_equal(false, window.flag)
    
    window.next
    window.next

    assert_equal(true, window.next)
    assert_equal(true, window.flag)
    assert_equal(3, window.match_pos)
    assert_equal(6, window.match_len)

    assert_equal(true, window.next)
    assert_equal(false, window.flag)
    assert_equal(false, window.next)
  end

  def test_window2    
    text = ""
    96.times do |i|
      text += (32 + i).chr
    end

    96.times do |i|
      text += (127 - i).chr
    end
    window = Window.new text
    i = 0
    while window.next
      assert_equal(false, window.flag)
      i += 1
    end
    assert_equal(96 * 2, i)
  end

  def test_window3
    text = ""
    96.times do |i|
      text += (32 + i).chr
    end
    32.times do |i|
      text += (127 - i).chr
    end

    10.times do |i|
      text += (32 + i).chr
    end
    window = Window.new text
    i = 0
    128.times do 
      window.next
      assert_equal(false, window.flag)
    end
    assert_equal(true, window.next)
    assert_equal(true, window.flag)
    assert_equal(128, window.match_pos)
    assert_equal(10, window.match_len)
    assert_equal(false, window.next)
  end

  def test_window4
    window = Window.new("fあaあb")
    window.next
    window.next
    window.next
    window.next
    assert_equal(true, window.flag)
    assert_equal(4, window.match_pos)
    assert_equal(3, window.match_len)
    window.next
    assert_equal(false, window.next)
  end
  
  def test_encode
    check_string("hogehogehoge")
    check_string("hffffafffddfff")    
    check_string("あなたあなたかぜ")
  end
  
  def check_string(string)
    code = ULZSS.encode(string)
    s = ULZSS.decode(code)
    assert(string ==  s)
  end
end

