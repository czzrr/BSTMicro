defmodule APITest do
  @moduledoc """
  In this module, the API is tested by sending HTTP requests to the server.
  The response from the server is then compared to the response we expect.
  """
  use ExUnit.Case

  # Start server once before executing all tests
  setup_all _context do
    Server.start()
    []
  end
  
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
    node = BSTNode.from_list([7, 11, 19])
    value = 17
    test_correct_request(node, value)
  end

  test "Request insertion of 42 into tree with elements -17, -62, 2021, 199, -5, 0, 7" do
    node = BSTNode.from_list([-17, -62, 2021, 199, -5, 0, 7])
    value = 42
    test_correct_request(node, value)
  end

  test "Request insertion of random number into tree with 10-100 random elements (numbers in range [-10000, 10000])" do
    value = Enum.random(-10000..10000)
    num_elems = Enum.random(10..100)
    elems = for _ <- 1..num_elems, do: Enum.random(-10000..10000)
    node = BSTNode.from_list(elems)
    test_correct_request(node, value)
  end

  # Helper method for testing correct requests.
  defp test_correct_request(node, value) do
    request_map = %{"value" => value, "data" => node}
    body = Poison.encode!(request_map)

    {:ok, response} = HTTPoison.post("localhost:8080/insert", body, [{"content-type", "application/json"}])
    
    # Update node locally for comparing what is returned from the API
    updated_node = BSTNode.insert(node, value)
    # Locally updated node should match remotely updated node
    expected_resp_body = Poison.encode!(%{"status" => 200, "data" => updated_node})
    
    assert response.status_code == 200
    assert response.body == expected_resp_body
  end

  test "Send a GET /insert request" do
    {:ok, response} = HTTPoison.get("localhost:8080/insert")
    expected_resp_body = Utils.make_err_resp("The server could not handle your request")
    
    assert response.status_code == 402
    assert response.body == expected_resp_body
  end

  test "Send a POST /hello request with random body" do
    body = "random body in here"
    {:ok, response} = HTTPoison.post("localhost:8080/insert", body, [{"content-type", "application/json"}])
    expected_resp_body = Utils.make_err_resp("Error when parsing JSON in request body")

    assert response.status_code == 402
    assert response.body == expected_resp_body
  end

  test "Send a POST /insert request with wrong JSON body" do
    request_map = %{"foo" => 1, "bar" => 2}
    body = Poison.encode!(request_map)
    {:ok, response} = HTTPoison.post("localhost:8080/insert", body, [{"content-type", "application/json"}])
    expected_resp_body = Utils.make_err_resp("JSON parsed successfully but was in the wrong format")

    assert response.status_code == 402
    assert response.body == expected_resp_body
  end
  
  test "Send a POST /insert request with non-JSON body" do
    body = "random body content"
    {:ok, response} = HTTPoison.post("localhost:8080/insert", body, [{"content-type", "application/json"}])
    expected_resp_body = Utils.make_err_resp("Error when parsing JSON in request body")

    assert response.status_code == 402
    assert response.body == expected_resp_body
  end

  test "Send a POST /insert request with empty JSON body" do
    body = ""
    {:ok, response} = HTTPoison.post("localhost:8080/insert", body, [{"content-type", "application/json"}])
    expected_resp_body = Utils.make_err_resp("JSON parsed successfully but was in the wrong format")

    assert response.status_code == 402
    assert response.body == expected_resp_body
  end

  test "Send a POST /insert request with wrong content-type" do
    node = %BSTNode{value: 3}
    value = 5
    request_map = %{"value" => value, "data" => node}
    body = Poison.encode!(request_map)

    {:ok, response} = HTTPoison.post("localhost:8080/insert", body, [{"content-type", "text/plain"}])
    expected_resp_body = Utils.make_err_resp("Error when receiving request")
    
    assert response.status_code == 402
    assert response.body == expected_resp_body
  end

  
end
