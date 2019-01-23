defmodule ExSMSSimple.Twilio do
  @moduledoc """
  The implementation of the ExSMSSimple behaviour for 
  Twilio (https://www.twilio.com)

  Currently assumes only one number (and configured via 
  :ex_sms_simple, :twilio_from_phone)
  """

  @behaviour ExSMSSimple

  def get_url do
    sid = Application.get_env(:ex_sms_simple, :twilio_account_sid)
    token = Application.get_env(:ex_sms_simple, :twilio_auth_token)

    "https://#{sid}:#{token}@api.twilio.com/2010-04-01/Accounts/" <> "#{sid}/Messages.json"
  end

  defp get_sending_phone_number do
    Application.get_env(:ex_sms_simple, :twilio_from_number)
  end

  defp payload(to, content) do
    params =
      []
      |> List.insert_at(0, {"To", to})
      |> List.insert_at(0, {"From", get_sending_phone_number()})
      |> List.insert_at(0, {"Body", content})

    {:form, params}
  end

  defp handle_ok_response(response) do
    body = Poison.decode!(response.body)

    case response.status_code do
      201 ->
        {:ok, body}

      200 ->
        {:ok, body}

      # This would be a Twilio error
      _ ->
        {:error, body}
    end
  end

  def send(to, content) do
    body = payload(to, content)

    res =
      get_url()
      |> HTTPoison.post(body, [{"Accept", "application/json"}])

    case res do
      {:ok, response} ->
        handle_ok_response(response)

      # This would be a HTTPoison error
      {:error, response} ->
        {:error, response}
    end
  end
end
