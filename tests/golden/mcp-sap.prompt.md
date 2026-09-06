# Implement MCP Tool for SAP Production Order Status

## Objective
Expose production-order status through a safe, typed MCP tool that follows the existing project architecture and conventions.

## Context
- Inspect existing MCP server patterns, SAP integration layer, auth, and tool registration.
- Reuse existing integration; do not create a parallel SAP stack.

## Constraints
- Typed input/output contract
- Reuse existing authentication and error handling
- Do not modify unrelated tools

## Execution Steps
1. Inspect the repository for MCP server patterns and SAP integration code.
2. Identify auth, authorization, and error-handling mechanisms in use.
3. Design a typed contract for production-order status lookup.
4. Implement the tool on the existing integration architecture.
5. Register the tool per project conventions.
6. Add tests for valid requests, invalid order IDs, SAP failures/timeouts, and authorization cases.
7. Run existing tests; fix regressions.

## Expected Output
- MCP tool implementation + registration
- Tests for success, invalid input, upstream failure, auth
- Brief change summary

## Validation
- Tool schema valid
- Valid order IDs return status
- Invalid IDs and upstream failures handled cleanly
- Authorization enforced
- Existing tests pass

## Failure Handling
- Missing SAP client: locate existing integration modules before adding new clients
- MCP patterns unclear: follow the closest existing tool definition in-repo

## Definition of Done
MCP tool implemented, integrated with existing architecture, tested, and validated without breaking existing functionality.
