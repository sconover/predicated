require "test/test_helper"

apropos "test failures" do

  xtest "you can see test method all the way back to the start of the test, plus an indication of where the failure was" do
    a = 1
    b = 2
    c = 1
    assert{ a == c }
    begin
      assert{ a == b }
    rescue RuntimeError => e
      assert do
        e.message.include?(
%{  test "you can see test method all the way back to the start of the test, plus an indication of where the failure was" do
    a = 1
    b = 2
    c = 1
    assert{ a == c }
    begin
      assert{ a == b }      ASSERTION FAILURE test/test_test.rb:}
        )
      end
    end
  end
end