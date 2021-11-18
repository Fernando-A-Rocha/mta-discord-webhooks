# mta-discord-webhooks

Simple scripts to use Discord Webhooks in a Multi Theft Auto: San Andreas server

# Install

Place the [discord](https://github.com/Fernando-A-Rocha/mta-discord-webhooks/tree/main/discord) folder in your server `resources` folder

# Tutorial

## Definition

Webhooks are a low-effort way to post messages to channels in Discord. They do not require a bot user or authentication to use.

## Using

[Official Tutorial](https://support.discord.com/hc/en-us/articles/228383668-Intro-to-Webhooks)

- Go to 'Integrations' in a channel's settings panel
- Click on 'Webhooks'
- Create a webhook, customize its name and avatar
- Copy webhook URL
- Add your webhook URL by assigning it a name in [webhookG.lua](/discord/webhookG.lua) inside `webhook_list`
- To send a message to that channel do like the following example, it's that simple!

```lua
exports.discord:msg("admin-logs", "This is a test message, you can use **basic formatting**!\nAnd go to new lines like this.")
```
