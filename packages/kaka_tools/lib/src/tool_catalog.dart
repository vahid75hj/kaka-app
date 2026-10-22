import 'tool_spec.dart';

/// Version of the tool contract. Breaking change = a new tool, never an edit.
const toolsVersion = 1;

const _date = {'type': 'string', 'format': 'date', 'description': 'ISO-8601 date (Gregorian), e.g. 2026-10-23'};

/// The tools Kaka offers to any AI. `schema/tools.v1.json` is generated from this list.
const kakaTools = <ToolSpec>[
  ToolSpec(
    name: 'list_accounts',
    description: 'List the user\'s accounts (wallets, bank accounts, cards) with id, name, type and currency.',
    access: ToolAccess.read,
    inputSchema: {'type': 'object', 'properties': {}, 'additionalProperties': false},
  ),
  ToolSpec(
    name: 'get_balance',
    description:
        'Current balance of one account, or of all accounts when account_id is omitted. '
        'Amounts are integers in minor units: value = amount_minor / 10^scale.',
    access: ToolAccess.read,
    inputSchema: {
      'type': 'object',
      'properties': {
        'account_id': {'type': 'string'},
      },
      'additionalProperties': false,
    },
  ),
  ToolSpec(
    name: 'list_transactions',
    description: 'Transactions, newest first, optionally filtered by date range, account and text.',
    access: ToolAccess.read,
    inputSchema: {
      'type': 'object',
      'properties': {
        'from': _date,
        'to': _date,
        'account_id': {'type': 'string'},
        'query': {'type': 'string', 'description': 'Matches note or category/account name'},
        'limit': {'type': 'integer', 'minimum': 1, 'maximum': 200, 'default': 50},
      },
      'additionalProperties': false,
    },
  ),
  ToolSpec(
    name: 'summarize_spending',
    description: 'Total expenses per category between two dates, per currency.',
    access: ToolAccess.read,
    inputSchema: {
      'type': 'object',
      'properties': {'from': _date, 'to': _date},
      'required': ['from', 'to'],
      'additionalProperties': false,
    },
  ),
  ToolSpec(
    name: 'add_transaction',
    description: 'Propose a new expense, income or transfer. Nothing is recorded until the user approves it in Kaka.',
    access: ToolAccess.writeDraft,
    inputSchema: {
      'type': 'object',
      'properties': {
        'kind': {
          'type': 'string',
          'enum': ['expense', 'income', 'transfer'],
        },
        'amount': {'type': 'string', 'description': 'Decimal amount in the account currency, e.g. "12.50"'},
        'account_id': {'type': 'string'},
        'to_account_id': {'type': 'string', 'description': 'Only for transfers'},
        'category': {'type': 'string'},
        'date': _date,
        'note': {'type': 'string'},
      },
      'required': ['kind', 'amount', 'account_id'],
      'additionalProperties': false,
    },
  ),
];
