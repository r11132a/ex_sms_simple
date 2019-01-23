defmodule ExSMSSimple do
  @moduledoc """
  Entry point into the Application.
  """

  @callback get_url() :: String.t()
  @callback send(to :: String.t(), message :: String.t()) ::
              {:ok, response :: term} | {:error, response :: term}

  def send(module, to, content), do: apply(module, :send, [to, content])
end
