# claude_text2image

Claude Code AI 绘画插件，通过 `/draw` 命令即可生成图片。基于 nanobanana API（Gemini 2.5 Flash Image 模型）。

## 安装

### 方式一：手动安装（推荐）

1. 克隆仓库：

```bash
git clone https://github.com/vaeyxj/claude_text2image.git
```

2. 将 skill 目录复制到 Claude Code skills 目录：

```bash
# 用户级安装（所有项目可用）
cp -r claude_text2image/skills/draw ~/.claude/skills/

# 或项目级安装（仅当前项目可用）
cp -r claude_text2image/skills/draw .claude/skills/
```

3. 配置 API Key（见下方）

### 方式二：直接下载 skill

如果不想克隆整个仓库，可以只下载 skill 目录：

```bash
mkdir -p ~/.claude/skills/draw/scripts

curl -sL https://raw.githubusercontent.com/vaeyxj/claude_text2image/main/skills/draw/SKILL.md \
  -o ~/.claude/skills/draw/SKILL.md

curl -sL https://raw.githubusercontent.com/vaeyxj/claude_text2image/main/skills/draw/scripts/generate-image.sh \
  -o ~/.claude/skills/draw/scripts/generate-image.sh

chmod +x ~/.claude/skills/draw/scripts/generate-image.sh
```

### 配置 API Key

在 `~/.claude/settings.json` 的 `env` 中添加你的 nanobanana API Key：

```json
{
  "env": {
    "NANOBANANA_API_KEY": "sk-your-key-here"
  }
}
```

或者添加到 shell profile（`~/.zshrc` 或 `~/.bashrc`）：

```bash
export NANOBANANA_API_KEY="sk-your-key-here"
```

配置后重启 Claude Code 使环境变量生效。

## 使用

```
/draw 白玉兰摄影
/draw a cat sitting on the moon --ratio 1:1
/draw 赛博朋克城市夜景 --ratio 16:9 --size 2k
```

## 参数

| 参数 | 说明 | 可选值 | 默认值 |
|------|------|--------|--------|
| `--ratio` | 宽高比 | `16:9` `1:1` `9:16` `4:3` `3:4` | `16:9` |
| `--size` | 图片尺寸 | `1k` `2k` | `1k` |

## 输出

生成的图片自动保存到 `~/Pictures/claude-draws/` 目录，文件名格式为 `时间戳_prompt摘要.png`。生成后 Claude 会直接在对话中展示图片。

## API

本插件调用 nanobanana 提供的 Gemini 2.5 Flash Image 接口：

- 端点：`https://new.suxi.ai/v1beta/models/gemini-2.5-flash-image:generateContent`
- 认证：Bearer Token
- 支持中英文 prompt
