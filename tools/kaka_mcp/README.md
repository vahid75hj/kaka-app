# kaka-mcp

A **read-only** [MCP](https://modelcontextprotocol.io) server (stdio) that lets Claude Desktop, Cursor or any MCP client
answer questions about your money from an encrypted Kaka backup (`.kaka`, made with Settings → Back up).

- It decrypts the backup into a RAM-only database. Nothing is written to disk and nothing is sent anywhere by the server.
- It offers the same read tools as the in-app AI: `list_accounts`, `get_balance`, `list_transactions`,
  `summarize_spending` and `list_budgets`. `add_transaction` is not offered.
- Card, account and IBAN numbers are masked in every result.

## Use

```sh
cd kaka-app && dart pub get
echo 'your backup password' > ~/.kaka-pass && chmod 600 ~/.kaka-pass
KAKA_BACKUP_PASSWORD_FILE=~/.kaka-pass dart run tools/kaka_mcp/bin/kaka_mcp.dart ~/kaka-20261028.kaka
```

Claude Desktop (`claude_desktop_config.json`) or Cursor (`.cursor/mcp.json`):

```json
{
  "mcpServers": {
    "kaka": {
      "command": "dart",
      "args": ["run", "/abs/kaka-app/tools/kaka_mcp/bin/kaka_mcp.dart", "/abs/kaka-20261028.kaka"],
      "env": { "KAKA_BACKUP_PASSWORD_FILE": "/abs/.kaka-pass" }
    }
  }
}
```

The password is never accepted as a command-line argument, because arguments are visible in process lists.

Note that the MCP client sends the tool results (balances, transactions) to its model provider. Kaka masks card
numbers, but amounts and notes are sent as they are.
