require "test_helper"

class RoutesTest < ActionDispatch::IntegrationTest
  test "should route to quiz feedback" do
    assert_routing({ method: "get", path: "/quiz/1/feedback" },
                   { controller: "quiz", action: "feedback", id: "1" })
  end

  test "should route to quiz answer" do
    assert_routing({ method: "post", path: "/quiz/1/answer" },
                   { controller: "quiz", action: "answer", id: "1" })
  end

  test "should route to quiz result" do
    assert_routing({ method: "get", path: "/quiz/result" },
                   { controller: "quiz", action: "result" })
  end
end
