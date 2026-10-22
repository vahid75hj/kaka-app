/// Whether a tool only reads, or creates a draft the user must approve.
enum ToolAccess { read, writeDraft }

/// A tool as exposed to models: name, description and JSON Schema input.
class ToolSpec {
  const ToolSpec({required this.name, required this.description, required this.inputSchema, required this.access});

  final String name;
  final String description;
  final Map<String, Object?> inputSchema;
  final ToolAccess access;

  /// MCP `tools/list` entry.
  Map<String, Object?> toMcp() => {
    'name': name,
    'description': description,
    'inputSchema': inputSchema,
    'annotations': {'readOnlyHint': access == ToolAccess.read},
  };

  /// OpenAI-compatible `tools[]` entry.
  Map<String, Object?> toOpenAi() => {
    'type': 'function',
    'function': {'name': name, 'description': description, 'parameters': inputSchema},
  };
}
