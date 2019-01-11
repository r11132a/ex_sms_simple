defmodule ExSMSSimple do
  @moduledoc """
  Entry point into the Application.
  """

  @callback get_url() :: String.t()
  @callback send(to :: String.t(), message :: String.t()) ::
              {:ok, response :: term} | {:error, response :: term}

  def send(module, to, content), do: apply(module, :send, [to, content])
end

defmodule ExSMSSimple.Twilio do
  def get_url do
    account_id = Application.get_env(:ex_sms_simple, :twilio_account_id)

    if is_nil(account_id) do
      raise "No Twilio Account ID!"
    end

    auth_token = Application.get_env(:ex_sms_simple, :twilio_auth_token)

    if is_nil(auth_token) do
      raise "No Twilio Auth Token!"
    end

    "https://#{account_id}:#{auth_token}@api.twilio.com/2010-04-01/Accounts/#{account_id}/Messages.json"
  end

  def send(_to, _content) do
    from_number = Application.get_env(:ex_sms_simple, :twilio_from_number)

    if is_nil(from_number) do
      raise "No Twilio From Number!"
    end

    url = get_url()
    url <> "&from=#{from_number}"
  end
end
