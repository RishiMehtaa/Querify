# Querify

An LLM-driven Business Intelligence engine with NL2SQL, iterative EDA, sandboxed Python execution, multilingual querying, and sentiment-aware decision support.

## Overview

Querify is an intelligent business intelligence platform that allows users to interact with structured and unstructured data using natural language. The project includes a Flutter frontend client, a FastAPI backend, and LLM-driven agents that decide whether to run SQL queries or perform iterative EDA using generated Python.

Key capabilities:

- Translate natural language into SQL and execute it against connected databases.
- Perform iterative exploratory data analysis (EDA) using LLM-generated Python code.
- Execute generated Python inside a sandbox and return plots and data safely.
- Support MySQL and MongoDB data sources.
- Provide human-readable explanations and visualizations.

This system is intended for research and prototyping; review sandboxing before production use.

---

## Features

- Natural Language → SQL translation
- Automatic routing between SQL and EDA tasks (LLM router)
- Iterative multi-pass EDA with retries and LLM feedback
- Sandboxed Python execution for generated analysis code
- Support for MySQL and MongoDB
- Multilingual query support
- Sentiment analysis (prototype)
- Human-readable explanation generation and visualization

---

## Architecture

```text
User (Flutter client)
  ↓
Flutter Frontend (querify/lib)
  ↓
FastAPI Backend (api.py)
  ↓
Route Agent (LLM) — decides: SQL_QUERY | EDA_TASK
  ↓
Decision Node
 ├── SQL Agent → Executes SQL against DB
 └── EDA Agent → Generates & executes Python in sandbox
  ↓
Synthesizer LLM → Final natural-language answer
  ↓
User (Flutter client renders answer, plots, tables)
```

Notes:
- A Streamlit prototype UI remains in `ui.py` for quick experimentation, but the primary frontend is the Flutter app under `querify/lib`.

---

## Components (where to look)

- Frontend (Flutter): `querify/lib/main.dart`, chat UI at `querify/lib/pages/chat/chat_home_page.dart`, API client at `querify/lib/services/api_service.dart`.
- Backend (FastAPI): `api.py` (server), `main.py` (CLI prototype).
- Agents: `agents/router.py` (routing), `agents/sql_agent.py` (NL→SQL + execution), `agents/eda_agent.py` (EDA planning, execution, synthesis).
- DB & auth: `db_router.py`, `db_connection.py`, `auth_router.py`.
- LLM integration: `llm_setup.py` and `langchain_core` prompt chains used across agents.

---

## API Contract (important for frontend)

- Base URL used by Flutter client: `http://localhost:8000` (config in `querify/lib/services/api_service.dart`).

- POST /chat
  - Request JSON:
    ```json
    { "text": "<user query>", "connection_id": "<optional>" }
    ```
  - Response JSON (examples):
    - SQL response:
      ```json
      { "type": "sql", "answer": "<natural language answer>" }
      ```
    - EDA response:
      ```json
      {
        "type": "eda",
        "answer": "<natural language conclusion>",
        "steps": [ /* list of attempt logs */ ],
        "image": "<base64 PNG>" ,
        "dataframe": "<JSON string of records>"
      }
      ```

The Flutter client decodes `image` (base64) and `dataframe` (JSON) and renders `steps` in an `ExpansionTile`.

---

## Explainability / "Thinking"

- The EDA Agent returns `steps`: an ordered list of attempt records. Each record typically contains `attempt`, `thought`/`thought_process`, `code`, `error`, and `output`.
- The backend synthesizes a final `answer` (natural-language conclusion) from the logs and final result.
- The SQL Agent synthesizes a concise answer from the executed SQL result; it does not return multi-step logs by default (but can be extended to expose debugging artifacts).
- The Flutter UI displays `steps` as human-readable strings (see `chat_home_page.dart`); consider improving backend serialization for richer UI rendering.

---

## Tech Stack

| Layer               | Technology / Libraries                                  |
| ------------------- | ------------------------------------------------------- |
| Frontend            | Flutter (Dart), `package:http`                          |
| Backend             | FastAPI, Uvicorn                                        |
| LLM Integration     | `llm_setup.py`, `langchain_core` (prompt chains/parsers) |
| Agents              | Custom Python agents (`agents/`)                        |
| Database            | MySQL (primary), MongoDB (supported)                    |
| Data Processing     | Pandas                                                  |
| Visualization       | Matplotlib (Agg), Seaborn (referenced)                  |
| Execution Sandbox   | Python `exec()` in restricted local scope (prototype)   |
| Sentiment Analysis  | DistilBERT (SST-2) — prototype                          |

---

## Dev / Run Checklist (quick)

1. Install Python dependencies in virtualenv and set env vars (LLM keys, `DATABASE_URL`).

2. Start backend (FastAPI):

```bash
# from project root
uvicorn api:app --reload --port 8000
```

3. Run Flutter app (ensure emulator/device can reach backend):

```bash
# from querify/ folder
flutter run
```

Notes for emulator networking:
- Android emulator (emulator running on host): use `10.0.2.2` instead of `localhost` if the app cannot reach the host's `localhost`.
- For physical devices, point the Flutter app to the host machine IP on the same network.

---

## Security & Sandbox Notes

- The EDA agent executes LLM-generated Python via `exec()` in a local scope with an injected `engine`. This is prototype-level sandboxing and should be hardened before production.

Recommendations for production hardening:

1. Run generated code in isolated processes or containers.
2. Enforce import whitelists and disable network/file access.
3. Apply resource/time limits (CPU, memory, timeouts).
4. Audit LLM prompts and output parsing to avoid code-injection edge cases.

---

## Known Limitations & Gotchas

- The Flutter client expects the exact JSON shape shown above; changing field names may break the UI.
- `DATABASE_URL` and LLM credentials must be set for EDA flows to work.
- SQL Agent currently does not expose chain-of-thought; only final synthesized answers are returned by default.
- EDA `steps` are currently displayed as plain strings in the Flutter UI; backend-side serialization to a friendly format will improve UX.
- LLM outputs sometimes include markdown fences — agents perform simple cleaning but stricter output parsing is recommended.
- When running on Android emulator, use `10.0.2.2` to reach a host FastAPI server bound to `localhost`.

---

## Example Queries

- SQL: `Show the top 5 products by revenue`
- EDA: `Plot monthly sales trend`
- Sentiment: `Analyze customer review sentiment by month`

---

## Sample API Responses

- SQL response (minimal):

```json
{
  "type": "sql",
  "answer": "Top 5 products by revenue are A, B, C..."
}
```

- EDA response (includes data and image):

```json
{
  "type": "eda",
  "answer": "Monthly sales increased overall; see plot.",
  "steps": [
    {"attempt":1, "thought":"Plan: load table, compute monthly totals", "error": null},
    {"attempt":2, "thought":"Fix plotting call", "error": null}
  ],
  "image": "<base64 PNG string>",
  "dataframe": "[{\"month\":\"2024-01\", \"sales\": 1234}, ... ]"
}
```

---

## Contributors

- Kshayik Doshi
- Krish Shah
- Kartik Sunil
- Rishi Mehta

---

## License

This project is intended for academic and research purposes.

Copyright © 2025

