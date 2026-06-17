## ADDED Requirements

### Requirement: SSE generator must not block event loop
The `generate_sse_events` function SHALL be an async generator using `asyncio.Queue` instead of `queue.Queue`. The function MUST use `await q.get()` instead of `q.get(timeout=...)` to avoid blocking the asyncio event loop.

#### Scenario: Concurrent SSE and API requests
- **WHEN** a client is connected to the SSE endpoint and another client makes an API request
- **THEN** the API request SHALL be processed without delay (not blocked by SSE generator)

#### Scenario: SSE event delivery
- **WHEN** a parse task produces progress events
- **THEN** the SSE generator SHALL yield events to the client in real-time via async iteration

### Requirement: ParseTask subscribers must use asyncio.Queue
The `ParseTask.subscribers` list SHALL store `asyncio.Queue` instances instead of `queue.Queue`. The `_notify_subscribers` method SHALL use `await q.put(item)` instead of `q.put(item)`.

#### Scenario: Subscriber notification
- **WHEN** a parse task progress update occurs
- **THEN** all subscribed SSE connections SHALL receive the update via their asyncio.Queue

### Requirement: SSE endpoint must use async StreamingResponse
The `/api/parse/sse/{task_id}` endpoint SHALL use `StreamingResponse` with the async generator directly, without `run_in_executor`.

#### Scenario: SSE streaming response
- **WHEN** a client connects to the SSE endpoint
- **THEN** the response SHALL stream events using async iteration without blocking the event loop
