# Example: Build Agent and QA Agent Workflow

This document demonstrates how the Build Agent and QA Agent work together in parallel.

## Typical Workflow

### 1. Build Agent Initiates Build
```bash
# Build Agent builds the app
./scripts/dev.sh build
```

### 2. QA Agent Runs in Parallel
```bash
# QA Agent monitors and tests
./agents/qa-agent.sh health &
```

### 3. Communication Between Agents

The agents communicate through log files and status updates:

**QA Agent sends to Build Agent:**
```json
{"type": "build_status", "status": "success", "details": "Build completed without errors"}
{"type": "test_results", "passed": 10, "failed": 0, "details": "All tests passed"}
{"type": "performance", "cpu": "15%", "memory": "45MB", "status": "normal"}
{"type": "crash_detected", "time": "2025-11-20 15:15:56", "reason": "EXC_BAD_ACCESS", "file": "/path/to/crash.ips"}
```

**Build Agent responds:**
```json
{"type": "build_request", "clean": true}
{"type": "test_request", "test_type": "all"}
{"type": "monitor_request", "duration": 300}
```

## Example Session

```bash
# Terminal 1: Build Agent
$ ./scripts/dev.sh run
Building Sharp Timer App...
Build completed!
Launching app...
App launched! Check your menu bar.

# Terminal 2: QA Agent (running in parallel)
$ ./agents/qa-agent.sh continuous
[INFO] Starting continuous monitoring...
[INFO] Performing health check...
[INFO] Build completed successfully
[INFO] Unit tests completed: 5 passed, 0 failed
[WARN] Crash reports found: 2
[INFO] Performance - CPU: 12%, RSS: 35MB, VSZ: 120MB
[INFO] Health check completed: degraded

# QA Agent detects issues and notifies Build Agent
[TO BUILD AGENT] issue: {"severity": "warning", "description": "Crash reports found", "details": "2 recent crashes detected"}
```

## Feedback Loop

1. **Build Agent** builds and runs the app
2. **QA Agent** monitors, tests, and analyzes
3. **QA Agent** reports issues and performance metrics
4. **Build Agent** adjusts based on feedback
5. **Cycle repeats** until quality standards are met

## Benefits

- **Parallel Processing**: Both agents work simultaneously
- **Real-time Feedback**: Issues are detected immediately
- **Comprehensive Testing**: Build + QA coverage
- **Performance Monitoring**: Continuous performance tracking
- **Issue Detection**: Proactive problem identification
- **Quality Assurance**: Systematic quality checks

This workflow ensures that the Sharp Timer App is thoroughly tested and monitored throughout the development process.