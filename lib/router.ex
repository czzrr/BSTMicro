defmodule Router do
  @moduledoc """
  The webserver's router.
  Each request sent to the webserver is handled by the router.
  Data is sent to the server for processing.
  """
  use Plug.Router

  plug :match # Match on a case when receiving a response
  plug Plug.Parsers, # Parse body of received response
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Poison
  plug :dispatch # Execute matched case

  # Handle POST /insert request
  post "/insert" do
    case Server.handle_insert(conn.body_params) do # Let the server do the logic
      {:ok, response_body} -> # Successful insertion
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, response_body)
      {:err, response_body} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(402, response_body)
    end
  end

  # We only handle one request, namely POST /insert.
  # All other requests are not handled.
  match _ do
    send_resp(conn, 404, "The server could not handle your request")
  end

  # Send back a response with status code 402 and an error message
  #defp send_err_resp(conn, err_msg) do
  #  response_map = %{"status" => 402, "data" => err_msg}
  #  body = Poison.encode!(response_map)
  #  conn
  #  |> put_resp_content_type("application/json")
  #  |> send_resp(402, body)
  #end
  
end
