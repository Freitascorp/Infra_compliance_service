# Architecture Document

## 1. Core System Components

The system appears to be a backend service built on the **.NET** platform. The core components identified are:

- **AuditService**: The main entry point and host for the application. It is configured to run a hosted service.
- **Workers**: A dedicated project for background tasks. It includes a `Worker` class that performs a timed, scripted operation. This suggests a microservice or worker service architecture.
- **Client**: A component responsible for making HTTP requests to external services (via `HttpClient`). It's configured to handle authentication, specifically with a `ClientAuthInterceptor`.

---

## 2. Architectural Patterns and Design

The codebase demonstrates several key architectural patterns:

- **Worker Service Pattern**: The use of `IHostedService` in `AuditService` and a separate `Worker` class indicates a worker service pattern. This is a common approach for long-running background tasks, separate from a web API.
- **Dependency Injection**: The system is heavily configured for DI, with services like `IClient` and `IHttpClientFactory` registered (e.g., in `Startup.cs`).
- **Layered Architecture**: Clear separation of concerns: the main service (host), a dedicated worker, and a client layer for external communication. This promotes maintainability and scalability.
- **Configuration-Driven**: The `WorkerSettings` class shows that the service is configured via a settings file (likely `appsettings.json`), enabling parameter changes (e.g., script execution interval) without code changes.

---

## 3. Data Flow and Interactions

Primary flow:

1. `AuditService` starts and hosts the **Worker** service.
2. The Worker runs on a schedule defined by `WorkerSettings.IntervalHours`.
3. The Worker executes an external **PowerShell** script.
4. The script’s **standard output** and **error** streams are captured and logged.

Given the presence of a **Client** component, the system is likely designed to **push data to** or **pull data from** external systems, though specific targets and data schemas are not detailed in the provided code.

---

## 4. Technical Stack

- **.NET**: Primary framework
- **C#**: Main programming language
- **PowerShell**: Used for background scripts (system automation)
- **Entity Framework (EF) Core**: Referenced via `dotnet-tools.json`, suggesting a database component (models/contexts not shown in provided files)

---

## 5. Detailed Rationale

- **Architectural Choices**: The design is robust for a background service. Separating the Worker from the main host allows independent scaling if needed. A **Client** layer abstracts external API interactions, improving testability and code cleanliness.
- **Assumptions**: The PowerShell script contains core business logic for the Worker; the Client manages communication with external APIs. The presence of `dotnet-ef` implies a database exists outside the provided code.
- **Potential Concerns**: Executing external PowerShell scripts can raise **security** and **portability** issues, tying the app to a specific OS/environment. Where feasible, consider migrating critical logic into **C#** for improved cross-platform compatibility and robustness.
