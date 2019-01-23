# ExSMSSimple

Elixir library for simple sending of SMS messages via popular services.

Very simple, only supports sending message and receiving the success or error
response from the service.

Depends on HTTPoison and Poison

**Currently Supported Services**
-[Twilio](https://www.twilio.com)
-[Clickatell](https://www.clickatell.com)

## Installation

Currently not available via hex.

```
def deps do
  [
    {:ex_sms_simple, github: "r11132a\ex_sms_simple", branch: "master"}
  ]
end
```

## Usage

There are two interfaces.

First is via `ExSMSSimple.send/3`

```
# For Twilio
alias ExSMSSimple.Twilio

to = "+16265551212"
content = "Message from ExSMSSimple.Twilio!"

case ExSMSSimple.send(Twilio,to,content) do
  {:ok, twilio_success_map} -> # do something
  {:error, twilio_error_map} -> # do something else
end

```

Alternatly, one could go directly to 
```
  ExSMSSimple.Twilio.send(to,content)
```

Clickatell works the same, just replace `Twilio` with `Clickatell`
