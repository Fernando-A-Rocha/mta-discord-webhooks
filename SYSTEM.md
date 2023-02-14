![Banner](/.github/images/banner.png)

# Exported functions

## `send(name, message, callBackEvent)`

Sends a message to the webhook's channel via a given webhook name.

**Required arguments**:

- `name`: a **string** corresponding to a custom webhook name declared in [config.lua](/discord_webhooks/custom/config.lua)
- [`message`](#message): a **mixed variable** corresponding to a message to be sent

**Optional arguments**:

- [`callBackEvent`](#callbackevent): a **table** defining the event that will be triggered when the request is made

**Returns**:

- a **request element** if the request was made successfully
- a **string** containing the error message if there was an error before the request was made

## `sendToURL(url, message, callBackEvent)`

Sends a message to the webhook's channel via a given webhook URL.

**Required arguments**:

- `url`: a **string** corresponding to a valid webhook URL
- [`message`](#message): a **mixed variable** corresponding to a message to be sent

**Optional arguments**:

- [`callBackEvent`](#callbackevent): a **table** defining the event that will be triggered when the request: made

**Returns**:

- a **request element** if the request was made successfully
- a **string** containing the error message if there was an error before the request was made

## `validateMessage(message)`

Validates a message to be sent to a webhook.

**Required arguments**:

- [`message`](#message): a **mixed variable** corresponding to a message to be validated

**Returns**:

- a **table** containing the [message](#message) ready to be sent to the webhook if the message is valid
- a **string** containing the error message if the message is invalid

# Variables

## `Message`

A message can be a **string** (regular text message only) or a **table** (embed(s) and/or regular text message(s)) with the following possible formats:

- A single ([Embed](#embed)) table
- An ordered table with multiple [Embeds](#embed)
- A table with the following **string keys**:
  - `embeds`: an ordered table with multiple [Embeds](#embed)
  - (optional) `content`: regular text message to be sent with the embed(s)

The following message attributes in the `message` table structure are **currently being ignored / not supported** by the script:

- `username`
- `avatar_url`
- `tts`
- `allowed_mentions`
- `components`
- `files`
- `payload_json`
- `attachments`
- `flags`
- `thread_name`

*Source: [Discord API documentation - Webhook JSON/Form Params](https://discord.com/developers/docs/resources/webhook#execute-webhook-jsonform-params)*

## `Embed`

Access [this page](/EMBEDS.md) to learn more about Embed messages.

🎨 A lot of customization is possible!

## `callBackEvent`

Table structure:

- `name`: a **string** corresponding to the name of the event
- `source`: an **MTA element** corresponding to the source which the event will be triggered with
- (optional) `args`: a **table** with any variables which will be passed to the event (see below)

E.g.: `{name = "onDiscordWebhookRequestSent", source = root, args = {thePlayer}}`

The **event will be triggered** with a **table** argument, followed by the `optional arguments (args)` that you passed to `callBackEvent`. This **table** contains the following information:

- `name`: the name of the webhook (false if no name)
- `url`: the URL of the webhook
- `message`: the post data sent to the webhook (JSON string)
- `responseData`: the data received from the webhook
- `responseInfo`: the info received from the webhook

```lua
triggerEvent(callBackEvent.name, callBackEvent.source, {
  name = name, -- false if sendToURL is used
  url = url,
  message = postData,
  responseData = responseData,
  responseInfo = responseInfo
}, unpack(callBackEvent.args or {}))
```

# Error handling

You can handle the return values of the exported functions. This is important when creating complicated embeds that **you are not sure will be validated** and sent to Discord.

E.g.:

```lua
local request, failReason = exports.discord_webhooks:send("test_webhokk", "This is a test")
if not request then
    outputDebugString("discord_webhooks send failed: " .. tostring(failReason), 1)
end
```

In large scale usage, you may want to avoid repeating code and having to check the return values everywhere you call discord_webhooks functions. You can enable the **error logging setting** in [config.lua](/discord_webhooks/custom/config.lua) that will automatically log any pre-request errors to the debug console.

# Example implementations

Check the [examples.lua](/discord_webhooks/examples.lua) script to better understand how the resource's features are used.

It comes **activated by default**, so you can test the resource by using command `/testwebhooks` in-game.

To **disable the examples**, simply remove the line `<script src="custom/examples.lua" type="server"/>` from `meta.xml`.

## [🔗 Back to top](#)

## [🔗 Back to the main page](/README.md)
