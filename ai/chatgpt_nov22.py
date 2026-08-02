#!/usr/bin/env python3
"""Stage 1 — ChatGPT, November 2022.

The entire harness is a loop around one stateless HTTP call.
No tools. No memory between runs. No context management. On purpose.

Provider: OpenRouter. OpenAI-shaped API.
"""

import json
import os
import sys
import urllib.error
import urllib.request

BASE_URL = os.environ.get("BASE_URL", "https://openrouter.ai/api/v1")
MODEL = os.environ.get("MODEL", "deepseek/deepseek-v4-flash-0731")
API_KEY = os.environ.get("API_KEY")

URL = BASE_URL.rstrip("/") + "/chat/completions"

if not API_KEY:
    sys.exit("set API_KEY in .env first")


def call(messages):
    """One request. The server remembers nothing, so we send the whole history."""
    body = json.dumps({     # json.dumps converts the Python data structure to JSON text
        "model": MODEL,
        "max_tokens": 4096,
        "messages": messages,
    }).encode()            # encode converts the JSON text to bytes, using UFT-8

    request = urllib.request.Request(
        URL,
        data=body,
        headers={
            "content-type": "application/json",
            "authorization": f"Bearer {API_KEY}",
        },
    )
    with urllib.request.urlopen(request) as response:
        return json.load(response)


# This list is the only memory this program has.
messages = []

while True:
    try:
        user = input("\nyou > ").strip()
    except (EOFError, KeyboardInterrupt):
        print()
        break
    if not user:
        continue

    messages.append({"role": "user", "content": user})

    try:
        reply = call(messages)
    except urllib.error.HTTPError as error:
        print(f"\nHTTP {error.code}: {error.read().decode()}", file=sys.stderr)
        messages.pop()  # don't poison the history with a failed turn
        continue

    choice = reply["choices"][0]
    text = choice["message"]["content"]

    if not text:
        print(f"\n[no text; finish_reason={choice['finish_reason']}]")
        messages.pop()
        continue

    print(f"\nLLM > {text}")
    messages.append({"role": "assistant", "content": text})
