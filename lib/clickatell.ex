defmodule ExSMSSimple.Clickatell do
  @moduledoc """
  The implementation of the ExSMSSimple behaviour for 
  Clickatell (https://www.clickatell.com)

  You must use a HTTP Integration (per Clicketell setup).  The REST
  Integration is not supported at this time.

  """

  @behaviour ExSMSSimple

  def get_url do
    api_key = Application.get_env(:ex_sms_simple, :clickatell_api_key)
    # This should absolutely be a fatal error!
    if is_nil(api_key) do
      raise "No Clickatell API key!"
    end

    "https://platform.clickatell.com/messages/http/send?apiKey=#{api_key}"
  end

  defp handle_poison_error(result, response_body) do
    {:error, %{poison_error: result, response_body: response_body}}
  end

  defp handle_result(%{"accepted" => false} = result),
    do: {:error, result}

  defp handle_result(%{"errorCode" => error_code} = result) do
    case error_code do
      # {:ok,result}
      nil ->
        if Map.has_key?(result, "messages") do
          result
          |> Map.get("messages")
          |> hd()
          |> handle_result()
        else
          {:ok, result}
        end

      _ ->
        {:error, result}
    end
  end

  defp decode_response(response_body) do
    case Poison.decode(response_body) do
      {:ok, result} -> handle_result(result)
      {:error, poison_error} -> handle_poison_error(poison_error, response_body)
    end
  end

  @doc """
  to -- A string representing the phone number to send the SMS text recipient
  (must already be in EL64 format, and all non-digit characters removed, except
  the leading "+")

  content -- The text message


  On success returns {:ok,message_reply_map}
  On any error returns {:error, appropriate_map} -- either Clickatell, Poison,
                                                    or HTTPoison
  The function get_url(), which is called in this function, will `raise` if
  a `clicatell_api_key` value isn't defined in the Application config
  """
  def send(to, content) do
    url = get_url() <> "&to=#{to}&" <> URI.encode_query(%{"content" => content})

    case HTTPoison.get(url, [{"Accepts", "application/json"}]) do
      {:ok, response} ->
        case response.status_code do
          201 -> decode_response(response.body)
          202 -> decode_response(response.body)
          _ -> {:error, response}
        end

      {:error, response} ->
        {:error, response}
    end
  end
end
