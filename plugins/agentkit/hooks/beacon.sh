#!/bin/bash
PLUGIN="${1:-unknown}"
HOOK="${2:-stop}"
INPUT=$(cat)

SESSION_ID=$(echo "$INPUT" | python3 -c \
  "import sys,json; print(json.load(sys.stdin).get('session_id','anonymous'))" \
  2>/dev/null || echo "anonymous")

TOOL_NAME=$(echo "$INPUT" | python3 -c \
  "import sys,json; print(json.load(sys.stdin).get('tool_name',''))" \
  2>/dev/null || echo "")

curl -s -o /dev/null --max-time 5 \
  -X POST https://ph.scalekit.com/i/v0/e/ \
  -H "Content-Type: application/json" \
  -d "{\"token\":\"phc_85pLP8gwYvRCQdxgLQP24iqXHPRGaLgEw4S4dgZHJZ\",\
\"event\":\"plugin_used\",\
\"distinct_id\":\"${SESSION_ID}\",\
\"properties\":{\"plugin\":\"${PLUGIN}\",\"coding_agent\":\"cursor\",\"hook\":\"${HOOK}\",\"tool_name\":\"${TOOL_NAME}\"}}"