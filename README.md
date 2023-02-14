![Banner](/.github/images/banner.png)

Simple resource for using Discord Webhooks to send messages in a Multi Theft Auto: San Andreas server. Supports simple and Embed messages.

## What are Discord Webhooks?

Webhooks are a low-effort way to post messages to channels in Discord. They do not require a bot user or authentication to use.

*Source: [Discord Webhooks Guide](https://support.discord.com/hc/en-us/articles/228383668-Intro-to-Webhooks)*

Check out [botder](https://github.com/botder)'s [mtasa-discord-bot Project](https://github.com/botder/mtasa-discord-bot) that lets you connect Discord Bots to your MTA:SA server, which are more powerful than webhooks.

## Installing the resource

- Get the latest version: [mta-discord-webhooks/releases/latest](https://github.com/Fernando-A-Rocha/mta-discord-webhooks/releases/latest)
- Extract the downloaded ZIP file
- Place the `discord_webhooks` folder in your server's `resources` directory
- Use the `refresh` command in your server's console to load the resource

## Creating a webhook

- Go to 'Integrations' in a channel's settings panel
- Click on 'Webhooks'
- Create a webhook, customize its name and avatar
- Copy webhook URL

## Using the resource

- Add webhook URLs by assigning names to them in [config.lua](/discord_webhooks/custom/config.lua)
- To send a message to the webhook's channel, use the functions explained below

---

### `send(name, message, callBackEvent)` (Exported function)

Sends a message to the webhook's channel via a given webhook name.

**Required arguments**:

- `name`: a **string** corresponding to a custom webhook name declared in [config.lua](/discord_webhooks/custom/config.lua)
- [`message`](#message): a **mixed variable** corresponding to a message to be sent

**Optional arguments**:

- [`callBackEvent`](#callbackevent): a table defining the event that will be triggered when the request is made

**Returns**:

- a **request element** if the request was made successfully
- a **string** containing the error message if there was an error before the request was made

---

### `sendToURL(url, message, callBackEvent)` (Exported function)

Sends a message to the webhook's channel via a given webhook URL.

**Required arguments**:

- `url`: a **string** corresponding to a valid webhook URL
- [`message`](#message): a **mixed variable** corresponding to a message to be sent

**Optional arguments**:

- [`callBackEvent`](#callbackevent): a table defining the event that will be triggered when the request: made

**Returns**:

- a **request element** if the request was made successfully
- a **string** containing the error message if there was an error before the request was made

---

### `validateMessage(message)` (Exported function)

Validates a message to be sent to a webhook.

**Required arguments**:

- [`message`](#message): a **mixed variable** corresponding to a message to be validated

**Returns**:

- a **table** containing the [message](#message) ready to be sent to the webhook if the message is valid
- a **string** containing the error message if the message is invalid

---

### Variables

### `Message`

A message can be a **string** or a **table** with the following possible formats:

- A single ([Embed](#embed)) table
- An ordered table with multiple [Embeds](#embed)
- A table with the following **string keys**:
  - `embeds`: an ordered table with multiple [Embeds](#embed)
  - (optional) `content`: the message to be sent with the embed(s)

---

#### `Embed`

🎨🚧 Visit [this page](/EMBEDS.md) to learn more about Embed messages.

---

#### `callBackEvent`

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

---

### Error handling

You can handle the return values of the exported functions. This is important when creating complicated embeds that **you are not sure will be validated** and sent to Discord.

E.g.:

```lua
local request, failReason = exports.discord_webhooks:send("test_webhokk", "This is a test")
if not request then
    outputDebugString("discord_webhooks send failed: " .. tostring(failReason), 1)
end
```

In large scale usage, you may want to avoid repeating code and having to check the return values everywhere you call discord_webhooks functions. You can enable the **error logging setting** in [config.lua](/discord_webhooks/custom/config.lua) that will automatically log any pre-request errors to the debug console.

## Example implementations

Check the [examples.lua](/discord_webhooks/examples.lua) script to better understand how to write your own scripts.

It is activated by default, so you can test the resource by using command `/testwebhooks` in-game.

To remove the examples, simply delete `examples.lua` from the `discord_webhooks` folder and remove the line that contains `examples.lua` in `meta.xml`.
