defmodule RouterTest do
  @moduledoc """
  Test module for Router.
  In this module, the API is tested by using a test connection from Plug.Test.
  Various requests are sent and the response is compared to what we expect.
  """
  use ExUnit.Case
  use Plug.Test

  @opts Router.init([]) # Use attribute as constant for router initialization

  test "Request insertion of 1 into empty tree" do
    node = nil
    value = 1
    test_correct_request(node, value)
  end
  
  test "Request insertion of 5 into tree with element 3" do
    node = %BSTNode{value: 3}
    value = 5
    test_correct_request(node, value)
  end

  test "Request insertion of 17 into tree with elements 7, 11, 19" do
    node = BSTNode.fromList([7, 11, 19])
    value = 17
    test_correct_request(node, value)
  end

  test "Request insertion of 42 into tree with elements -17, -62, 2021, 199, -5, 0, 7" do
    node = BSTNode.fromList([-17, -62, 2021, 199, -5, 0, 7])
    value = 42
    test_correct_request(node, value)
  end

  test "Request insertion of random number into tree with 10-100 random elements (numbers in range [-10000, 10000])" do
    value = Enum.random(-10000..10000)
    num_elems = Enum.random(10..100)
    elems = for _ <- 1..num_elems, do: Enum.random(-10000..10000)
    node = BSTNode.fromList(elems)
    test_correct_request(node, value)
  end

  # Helper method for testing correct requests.
  defp test_correct_request(node, value) do
    request_map = %{"value" => value, "data" => node}
    body = Poison.encode!(request_map)

    # Specify request type (POST /insert) and request body
    conn = conn(:post, "insert", body)
    # Set destination and content type
    conn = %{conn | host: "localhost", port: 8080, req_headers: [{"content-type", "application/json"}]}
    # Simulate request
    conn = Router.call(conn, @opts)

    # Update node locally for comparing what is returned from the API
    updated_node = BSTNode.insert(node, value)
    expected_resp_body = Poison.encode!(%{"status" => 200, "data" => updated_node})
    
    assert conn.state == :sent
    assert conn.status == 200
    assert expected_resp_body == conn.resp_body # Locally updated node should match remotely updated node
  end
  
end
