# MTA-Discord-Webhooks

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

- Add your webhook URL by assigning it a name in [config.lua](/discord_webhooks/config.lua)
- To send a message to the webhook's channel, use the functions explained below

### `send(name, content, callBackEvent)` (Exported function)

Sends a single message to the webhook's channel via a given webhook name.

**Required arguments**:

- `name` is the name of the webhook URL in [config.lua](/discord_webhooks/config.lua)
- `content`: the message to be sent
  - This can be a string (simple message) or a table ([Embed message](#embed-message))

**Optional arguments**:

- [`callBackEvent`](#callbackevent): a table defining the event that will be triggered when the request is made

**Returns**:

- a `request` element if the request was made successfully
- a `string` containing the error message if there was an error before the request was made

### `sendToURL(url, content, callBackEvent)` (Exported function)

Sends a single message to the webhook's channel via a given webhook URL.

**Required arguments**:

- `url`: the URL of the webhook
- `content`: the message to be sent
  - This can be a string (simple message) or a table ([Embed message](#embed-message))

**Optional arguments**:

- [`callBackEvent`](#callbackevent): a table defining the event that will be triggered when the request: made

**Returns**:

- a `request` element if the request was made successfully
- a `string` containing the error message if there was an error before the request was made

### Variables

#### `Embed message`

🎨🚧 Visit [this page](/EMBEDS.md) to learn more about Embed messages.

#### `callBackEvent`

Table structure:

- `name`: the name of the event
- `source`: the source element of the event
- (optional) `args`: a table with the arguments passed to the event

The event will be triggered with the following arguments:

- `name`: the name of the webhook (false if no name)
- `url`: the URL of the webhook
- `content`: the post data sent to the webhook (JSON string)
- `responseData`: the data received from the webhook
- `responseInfo`: the info received from the webhook

E.g.: `{name = "onDiscordWebhookRequestSent", source = root, args = {thePlayer}}`

### Tips

It's important to always handle the return values of the exported functions. E.g.:

```lua
local request, failReason = exports.discord_webhooks:send("test_webhokk", "This is a test")
if not request then
    outputDebugString("discord_webhooks send failed: " .. tostring(failReason), 1)
end
```

## Example implementations

Check the [examples.lua](/discord_webhooks/examples.lua) script to better understand how to write your own scripts.

It is activated by default, so you can test the resource by using command `/testwebhooks` in-game.

To remove the examples, simply delete `examples.lua` from the `discord_webhooks` folder and remove the line that contains `examples.lua` in `meta.xml`.
