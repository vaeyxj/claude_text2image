---
name: draw
description: Generate images from text prompts using AI. Use /draw followed by a description of the image you want to create.
argument-hint: <prompt> [--ratio 16:9|1:1|9:16|4:3|3:4] [--size 1k|2k]
allowed-tools: [Bash, Read]
---

# Draw - AI Image Generation

Generate images from text descriptions using the nanobanana API (Gemini 2.5 Flash Image model).

## Arguments

The user invoked this command with: $ARGUMENTS

## Instructions

When this command is invoked, follow these steps:

### 1. Parse Arguments

Extract from `$ARGUMENTS`:
- **prompt** (required): The text description of the image. This is everything except the optional flags.
- **--ratio** (optional): Aspect ratio. Supported values: `16:9`, `1:1`, `9:16`, `4:3`, `3:4`. Default: `16:9`
- **--size** (optional): Image size. Supported values: `1k`, `2k`. Default: `1k`

If no prompt is provided, ask the user what image they want to generate.

### 2. Generate the Image

Run the generation script using Bash:

```bash
bash "${CLAUDE_SKILL_DIR}/scripts/generate-image.sh" "<prompt>" "<aspect_ratio>" "<image_size>"
```

The script will:
- Call the nanobanana API with the prompt
- Save the generated image as a PNG file
- Output the file path on success
- Output an error message on failure

### 3. Display the Result

If the script succeeds and outputs a file path:
- Use the **Read** tool to display the generated image to the user
- Tell the user where the image was saved

If the script fails:
- Show the error message to the user
- Common issues:
  - `NANOBANANA_API_KEY` not set: Guide the user to configure it in `~/.claude/settings.json` under `env`
  - API error: Show the error details

## API Key Configuration

The API key must be set as the environment variable `NANOBANANA_API_KEY`. Configure it in one of these ways:

1. **Claude settings** (recommended): Add to `~/.claude/settings.json`:
   ```json
   {
     "env": {
       "NANOBANANA_API_KEY": "sk-your-key-here"
     }
   }
   ```

2. **Shell profile**: Add `export NANOBANANA_API_KEY=sk-your-key-here` to `~/.zshrc` or `~/.bashrc`

## Example Usage

```
/draw 白玉兰摄影
/draw a cat sitting on the moon --ratio 1:1
/draw 赛博朋克城市夜景 --ratio 16:9 --size 2k
```
