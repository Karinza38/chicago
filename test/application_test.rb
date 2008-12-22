require File.join(File.dirname(__FILE__), 'test_helper')

class ApplicationTest < Test::Unit::TestCase
  
  context "catching all css" do
    context "with default path" do
      setup do
        get_it '/stylesheets/foo.css'
      end

      should_have_response_status 200
      should_have_content_type 'text/css'
      should_have_response_body %r[.bar \{\s+display: none; \}\s]
    end

    context "with specified path" do
      setup do
        get_it '/css/goo.css'
      end

      should_have_response_status 200
      should_have_content_type 'text/css'
      should_have_response_body %r[.car \{\s+display: some; \}\s]
    end
  end # catching all css

  context "getting obvious views" do
    setup do
      get_it '/baz'
    end

    should_have_response_body "Whatever man. That's just like, your opinion."
  end

end
