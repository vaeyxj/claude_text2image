# claude_text2image

Claude Code AI 绘画插件，通过 `/draw` 命令即可生成图片。基于 nanobanana API，支持多种 Gemini 图像模型。

## 安装

### 1. 添加 Marketplace 并安装插件

在 Claude Code 中运行：

```
/plugin marketplace add vaeyxj/claude_text2image
/plugin install claude-text2image@vaeyxj-claude-text2image
```

或者通过 CLI：

```bash
claude plugin marketplace add vaeyxj/claude_text2image
claude plugin install claude-text2image@vaeyxj-claude-text2image
```

### 2. 配置 API Key

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
/draw 水墨山水画 --model 香蕉pro
/draw pixel art dragon --model 香蕉2 --ratio 1:1
```

## 参数

| 参数 | 说明 | 可选值 | 默认值 |
|------|------|--------|--------|
| `--model` | 模型选择 | `香蕉` `香蕉pro` `香蕉2` | `香蕉` |
| `--ratio` | 宽高比 | `16:9` `1:1` `9:16` `4:3` `3:4` | `16:9` |
| `--size` | 图片尺寸 | `1k` `2k` | `1k` |

### 模型说明

| 模型 | 实际模型 ID | 说明 |
|------|------------|------|
| `香蕉` | gemini-2.5-flash-image | 基础模型，速度快 |
| `香蕉pro` | gemini-3-pro-image-preview | 最佳质量 |
| `香蕉2` | gemini-3.1-flash-image-preview | 新一代快速模型 |

## 输出

生成的图片自动保存到 `~/Pictures/claude-draws/` 目录，文件名格式为 `时间戳_prompt摘要.png`。生成后 Claude 会直接在对话中展示图片。

## API

本插件调用 nanobanana 提供的 Gemini 图像接口：

- 端点：`https://new.suxi.ai/v1beta/models/<model>:generateContent`
- 认证：Bearer Token
- 支持中英文 prompt
