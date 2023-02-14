![Banner](/.github/images/banner.png)

# About

Resource for using Discord Webhooks to send messages in a Multi Theft Auto: San Andreas server. Supports simple text and Embed messages.

**MTA forum topic**: [Link](https://forum.multitheftauto.com/topic/139741-rel-discord-webhooks-tool-supports-embeds/)

# What are Discord Webhooks?

Webhooks are a low-effort way to post messages to channels in Discord. They do not require a bot user or authentication to use.

*Source: [Discord Webhooks Guide](https://support.discord.com/hc/en-us/articles/228383668-Intro-to-Webhooks)*

# Installing the resource

- Get the latest version: [mta-discord-webhooks/releases/latest](https://github.com/Fernando-A-Rocha/mta-discord-webhooks/releases/latest)
- Extract the downloaded ZIP file
- Place the `discord_webhooks` folder in your server's `resources` directory
- Use the `refresh` command in your server's console to load the resource

# Creating a Webhook

- Select a Discord channel in which you have the 'Manage Webhooks' permission
- Right click it then select 'Edit Channel'
- Go to the 'Integrations' tab
- Click on 'Webhooks'
- Create a webhook, customize its name and avatar
- Copy webhook URL

# Using the resource

- Add webhook URLs by assigning names to them in [config.lua](/discord_webhooks/custom/config.lua)
- To send a message to the webhook's channel, use the functions explained below

Access [this page](/SYSTEM.md) to view the full documentation.

# Discord Bots

Check out [botder](https://github.com/botder)'s [mtasa-discord-bot Project](https://github.com/botder/mtasa-discord-bot) that lets you connect a Discord Bot application to your MTA:SA server, which are more powerful than webhooks.

# Support & Suggestions

Found a bug? Want to suggest a feature? Feel free to open an issue in the [Issues](https://github.com/Fernando-A-Rocha/mta-discord-webhooks/issues) section.

Need help? Read the Support section on the MTA forum thread linked in the [About](#about) section.

# Final Note

Feel free to contribute to the project by improving the code & documentation via Pull Requests. Thank you!

## [🔗 Back to top](#)
