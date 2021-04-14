defmodule BSTMicro.Application do
  use Application

  def start(_type, _args) do
    Server.start()
  end
end
