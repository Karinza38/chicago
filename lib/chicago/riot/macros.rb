require 'json'

module Chicago
  module Riot
    module Macros
      def asserts_response_status(expected)
        asserts("response status is #{expected}") { last_response.status }.equals(expected)
      end
      
      def asserts_content_type(expected)
        asserts("content type is #{expected}") { last_response.headers['Content-type'] }.equals(expected)
      end

      def asserts_response_body(expected)
        if (expected.kind_of?(Regexp))
          asserts("response body matches #{expected.inspect}") { last_response.body }.matches(expected)
        else
          asserts("response body is exactly #{expected.inspect}") { last_response.body }.equals(expected)
        end
      end

      def asserts_location(expected_path)
        asserts("location matches #{expected_path}") do
          last_response.headers["Location"]
        end.matches(expected_path)
      end

      # Usage:
      #   asserts_json_response({"foo" => "bar"})
      #   asserts_json_response('{"foo":"bar"}')
      #   asserts_json_response("text/javascript;charset=utf-8", {"foo" => "bar"})
      #   asserts_json_response { {"foo" => @some_value} }
      #   asserts_json_response("text/javascript;charset=utf-8") { {"foo" => @some_value} }
      def asserts_json_response(*args, &block)
        json = block_given? ? instance_eval(&block) : args.pop

        json = json.to_json unless json.instance_of?(String)
        asserts("response body has JSON") do
          last_response.body
        end.equals(json)

        asserts_content_type(args.empty? ? 'application/json' : args.shift)
      end

      # Usage:
      #   assert_redirected_to '/foo/bar'
      #   assert_redirected_to %r[foo/bar]
      def asserts_redirected_to(expected_path)
        asserts_response_status 302
        asserts_location expected_path
      end
    end # Macros
  end # Riot
end # Chicago

Riot::Context.instance_eval { include Chicago::Riot::Macros }
