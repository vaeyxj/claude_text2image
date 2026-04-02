#!/bin/bash
# generate-image.sh - Call nanobanana API to generate images from text prompts
# Usage: generate-image.sh "<prompt>" [aspect_ratio] [image_size]

set -euo pipefail

PROMPT="${1:?Error: prompt is required}"
ASPECT_RATIO="${2:-16:9}"
IMAGE_SIZE="${3:-1k}"

# Validate API key
if [ -z "${NANOBANANA_API_KEY:-}" ]; then
  echo "Error: NANOBANANA_API_KEY environment variable is not set." >&2
  echo "Configure it in ~/.claude/settings.json under env:" >&2
  echo '  { "env": { "NANOBANANA_API_KEY": "sk-your-key-here" } }' >&2
  exit 1
fi

API_URL="https://new.suxi.ai/v1beta/models/gemini-2.5-flash-image:generateContent"

# Create output directory
OUTPUT_DIR="$HOME/Pictures/claude-draws"
mkdir -p "$OUTPUT_DIR"

# Generate filename with timestamp
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
SAFE_PROMPT=$(echo "$PROMPT" | tr -cd '[:alnum:]_ ' | tr ' ' '_' | cut -c1-50)
OUTPUT_FILE="$OUTPUT_DIR/${TIMESTAMP}_${SAFE_PROMPT}.png"

# Build request body with proper JSON escaping
REQUEST_BODY=$(python3 -c "
import json, sys
body = {
    'contents': [{'role': 'user', 'parts': [{'text': sys.argv[1]}]}],
    'generationConfig': {
        'responseModalities': ['text', 'image'],
        'imageConfig': {'aspectRatio': sys.argv[2], 'imageSize': sys.argv[3]}
    }
}
print(json.dumps(body))
" "$PROMPT" "$ASPECT_RATIO" "$IMAGE_SIZE")

# Call API
if ! RESPONSE=$(curl --silent --show-error --max-time 120 \
  --location \
  --request POST "$API_URL" \
  --header "Authorization: Bearer $NANOBANANA_API_KEY" \
  --header "Content-Type: application/json" \
  --data-raw "$REQUEST_BODY" 2>&1); then
  echo "Error: API request failed: $RESPONSE" >&2
  exit 1
fi

# Check for API error response
if echo "$RESPONSE" | python3 -c "import sys,json; d=json.load(sys.stdin); sys.exit(0 if 'error' in d else 1)" 2>/dev/null; then
  ERROR_MSG=$(echo "$RESPONSE" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d['error'].get('message', str(d['error'])))")
  echo "Error: API returned error: $ERROR_MSG" >&2
  exit 1
fi

# Extract base64 image data from response
IMAGE_DATA=$(echo "$RESPONSE" | python3 -c "
import sys, json
data = json.load(sys.stdin)
candidates = data.get('candidates', [])
if not candidates:
    print('Error: No candidates in response', file=sys.stderr)
    sys.exit(1)
parts = candidates[0].get('content', {}).get('parts', [])
for part in parts:
    if 'inlineData' in part:
        print(part['inlineData']['data'])
        sys.exit(0)
print('Error: No image data found in response', file=sys.stderr)
sys.exit(1)
")

if [ -z "$IMAGE_DATA" ]; then
  echo "Error: Failed to extract image data from response" >&2
  exit 1
fi

# Decode and save image
echo "$IMAGE_DATA" | base64 --decode > "$OUTPUT_FILE"

# Verify file was created and has content
if [ ! -s "$OUTPUT_FILE" ]; then
  echo "Error: Generated image file is empty" >&2
  rm -f "$OUTPUT_FILE"
  exit 1
fi

# Output the file path for Claude to read and display
echo "$OUTPUT_FILE"
