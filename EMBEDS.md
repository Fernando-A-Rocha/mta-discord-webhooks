# Embed Messages

A Message Embed represents a Discord Embed object. An Embed object is another component of Discord messages that can be used to present data with special formatting and structure.

E.g.:

![Embed example](https://i.imgur.com/xHUfaJE.png)

## Structure

In reality, for the Discord API, an embed is represented as a JSON object. This resource mimics the [Embed Structure (Discord Developer Portal)](https://discord.com/developers/docs/resources/channel#embed-object-embed-structure) format expected.

The `Embed message` argument you pass to the exported functions is a Lua `table` with a **specific structure**, similar to the JSON object expected by the Discord API, with some useful features.

All attributes are optional.

- `title` (string): embed title
- `description` (string): embed description
- `url` (string): embed URL on the title
- `timestamp` (number|string): embed timestamp
  - number: timestamp in milliseconds
  - "now": current timestamp
- `color` (number): embed color (integer hexadecimal number)
- `thumbnail` (table): embed thumbnail image
  - `url` (string): thumbnail image URL
- `image` (table): embed image
  - `url` (string): image URL
- `author` (table): embed author
  - `name` (string): author name
  - `url` (string): author URL on the name
  - `icon_url` (string): author icon URL
- `footer`: embed footer
  - `text` (string): footer text
  - `icon_url` (string): footer icon image URL
- `fields` (table of tables): embed fields
  - `name` (string): field name
  - `value` (string): field value
  - `inline` (boolean): whether the field is inline with other fields

*For the full list of attributes, see [embeds.lua](/discord_webhooks/embeds.lua) (some have not been specified here for simplicity).*

### Important notes

- `color` can be generated using the `tocolor` MTA function. It returns a **color number** (the alpha value (R,G,B,**A**) won't be sent to Discord).
- `timestamp` can be set to **"now"** to use the current timestamp or a **number** to use a custom timestamp in **seconds**.
- To add a blank field to the embed, you can use `{ name='\u200b', value='\u200b' }`.
- To **display fields side-by-side**, you need at least **two consecutive fields set to inline**.
- **Mentions** of any kind in embeds will only render correctly within embed **description and field** values
- **Mentions** in embeds will **not trigger a notification**
- Embeds allow **masked links** (e.g. `[Guide](https://example.com/guide)`), but only in **description and field** values

### Embed limits

There are a few limits to be aware of while planning your embeds due to the API's limitations. Here is a quick reference you can come back to:

- Embed titles are limited to 256 characters
- Embed descriptions are limited to 4096 characters
- There can be up to 25 fields
- A field's name is limited to 256 characters and its value to 1024 characters
- The footer text is limited to 2048 characters
- The author name is limited to 256 characters
- The sum of all characters from all embed structures in a message must not exceed 6000 characters
- 10 embeds can be sent per message (irrelevant in our case because we only send one embed per message)

*Source: [Discord API documentation](https://discord.com/developers/docs/resources/channel#embed-object-embed-limits)*

### Example

```lua
{
    -- Special
    timestamp = "now",
    color = tocolor(255, 194, 14),

    title = "Embed title",
    description = "Embed description",
    url = "https://example.com",
    author = {
        name = "Author name",
        url = "https://example.com",
        icon_url = "https://example.com/icon.png"
    },
    fields = {
        {
            name = "Field name",
            value = "Field value",
            inline = true
        }
    },
    image = {
        url = "https://example.com/image.png"
    },
    thumbnail = {
        url = "https://example.com/thumbnail.png"
    },
    footer = {
        text = "Footer text",
        icon_url = "https://example.com/icon.png"
    }
}
```

*Inspiration: [discord.js Embeds](https://discordjs.guide/popular-topics/embeds.html#embeds)*
