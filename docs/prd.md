# Product Requirements Document (PRD)

## 1. Project Overview

This project is a full-stack **.NET application** with a clear separation between:

- **Backend Web API**
- **Background Worker Service**
- **Frontend Client**

The presence of a custom `AGENTS.md` document and specific configuration files suggests a mature project, potentially adopting a **microservices-like architecture** with a focus on **background tasks** and **scheduled operations**. The project may utilize the **BMad-Method framework** for development.

### Key Features

- **Web API**: Provides endpoints for client interaction.
- **Background Worker Service**: Executes scheduled tasks (e.g., PowerShell scripts) at defined intervals.
- **Client Application**: A separate frontend that consumes the Web API.
- **Database Integration**: Uses `dotnet-ef`, indicating Entity Framework is in use.

---

## 2. Technical Components

The codebase is organized into several key directories and files:

### `.config/`
- Contains tooling-specific configurations such as `dotnet-tools.json` (for `dotnet-ef`).

### `Web/`
- Core Web API implementation.
- Includes controllers such as `HelloWorldController.cs` defining the application’s HTTP endpoints.

### `Workers/`
- Contains the background **Worker Service**.
- Includes `WorkerSettings.cs` indicating support for configurable task intervals.

### `Client/`
- Houses the frontend application.
- Presence of `Program.cs` suggests it's a .NET-based client.

### `Services/`
- Contains `PowerShellService.cs` — a key component for executing PowerShell scripts and processing results.

### `AGENTS.md`
- Indicates use of the **BMad-Method framework**.
- Likely outlines specialized agent roles (e.g., PM, Dev, QA) used throughout development.

---

## 3. Dependencies and Environment

- **Platform**: .NET Core / .NET 9
- **Database**: SQL-based (Entity Framework via `dotnet-ef`)
- **Task Scheduling**: Managed via `WorkerSettings.cs` in the Worker Service
- **Script Execution**: External PowerShell scripts run via `PowerShellService`
- **Tooling**:
  - Visual Studio Code (implied by `.gitignore`)
  - Git for version control
  - `dotnet-tools.json` for standardized tooling

---

## 4. Key Functional Flows

The core functionality is driven by **automated background processes**:

1. `WorkerService` operates on a scheduled interval (configured via `WorkerSettings`).
2. It invokes `PowerShellService`, which:
   - Executes external PowerShell scripts.
   - Monitors execution status.
   - Captures output and error streams.
   - Logs execution results.

> This architecture supports automated maintenance, data processing, or diagnostics tasks that run independently of any Web API user interaction.

The **Web API** likely serves a different purpose — such as:

- Hosting a dashboard to view background task results.
- Providing business functions unrelated to background tasks.

---

## 5. Detailed Rationale

This analysis is based on the available codebase and follows several assumptions:

- **Code Completeness**: The provided XML and directory structure are assumed to represent the core project accurately, though some files may be missing.
- **Worker Purpose**: Assumes `WorkerService` acts as a generic, configurable task runner for scheduled PowerShell scripts.
- **Client Technology**: While not explicitly stated, the frontend appears to be a .NET client.
- **BMad Integration**: The `AGENTS.md` file strongly suggests **BMad Method** is actively used within the workflow.
