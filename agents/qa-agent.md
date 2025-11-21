# Sharp Timer App QA Agent

A specialized QA agent for monitoring, testing, and providing feedback on the Sharp Timer App macOS application.

## Purpose

This agent is designed to work in parallel with the Build Agent to:
- Build and run the application (using existing dev.sh script)
- Monitor logs and crashes in real-time
- Perform automated testing
- Provide retrospective feedback to the Build Agent
- Identify and report issues

**Important**: This QA agent leverages the existing `scripts/dev.sh` for core build, run, test, and monitoring functionality to avoid code duplication.

## Core Capabilities

### 1. Build Management
- Build the app using existing dev.sh script
- Clean build artifacts via dev.sh
- Run unit tests via dev.sh
- Validate build success/failure
- Enhanced logging and monitoring on top of dev.sh

### 2. Runtime Monitoring
- Real-time log monitoring
- Crash report detection and analysis
- Performance monitoring (CPU, memory)
- Menu bar functionality verification

### 3. Quality Assurance
- Automated test execution
- UI interaction testing
- Notification system testing
- Data persistence validation

### 4. Feedback System
- Issue detection and reporting
- Build status communication
- Performance metrics collection
- Bug reproduction assistance

## Available Commands

### Build Commands
```bash
# Build the app (uses dev.sh)
./agents/qa-agent.sh build

# Clean and rebuild (uses dev.sh)
./agents/qa-agent.sh rebuild

# Build and run (uses dev.sh)
./agents/qa-agent.sh run
```

### Monitoring Commands
```bash
# Monitor real-time logs (uses dev.sh)
./agents/qa-agent.sh monitor

# Check for crashes (uses dev.sh)
./agents/qa-agent.sh crash-check

# Performance monitoring (QA agent specific)
./agents/qa-agent.sh performance

# Full health check
./agents/qa-agent.sh health
```

### Testing Commands
```bash
# Run unit tests (uses dev.sh)
./agents/qa-agent.sh test-unit

# Run UI tests (QA agent specific)
./agents/qa-agent.sh test-ui

# Run all tests
./agents/qa-agent.sh test-all

# Integration testing
./agents/qa-agent.sh test-integration
```

### Feedback Commands
```bash
# Generate status report
./agents/qa-agent.sh report

# Check app functionality
./agents/qa-agent.sh verify

# Compare with previous build
./agents/qa-agent.sh compare
```

## Agent Communication Protocol

### To Build Agent
- **Build Status**: `{ "type": "build_status", "status": "success|failed", "details": "..." }`
- **Test Results**: `{ "type": "test_results", "passed": 10, "failed": 2, "details": "..." }`
- **Issues Found**: `{ "type": "issue", "severity": "critical|warning|info", "description": "..." }`
- **Performance**: `{ "type": "performance", "cpu": "15%", "memory": "45MB", "status": "normal|high" }`

### From Build Agent
- **Build Request**: `{ "type": "build_request", "clean": true|false }`
- **Test Request**: `{ "type": "test_request", "test_type": "unit|ui|all" }`
- **Monitor Request**: `{ "type": "monitor_request", "duration": 300 }`

## Monitoring Features

### Real-time Log Analysis
- Error detection and categorization
- Warning identification
- Performance bottleneck detection
- User interaction tracking

### Crash Detection
- Automatic crash report monitoring
- Crash pattern analysis
- Stack trace collection
- Reproduction attempt assistance

### Performance Metrics
- CPU usage monitoring
- Memory usage tracking
- Launch time measurement
- UI responsiveness testing

## Quality Checks

### Functional Testing
- Timer start/stop/reset functionality
- Mode switching (Work, Rest Eyes, Long Rest)
- Notification delivery
- Settings persistence
- Menu bar integration

### UI Testing
- Menu bar icon visibility
- Timer display accuracy
- Button responsiveness
- Settings panel functionality
- Quit confirmation dialog

### Integration Testing
- Notification system integration
- Data persistence across launches
- macOS permission handling
- Multi-monitor support

## Usage Examples

### Basic QA Workflow
```bash
# 1. Clean build and test
./agents/qa-agent.sh rebuild
./agents/qa-agent.sh test-all

# 2. Run and monitor
./agents/qa-agent.sh run &
./agents/qa-agent.sh monitor

# 3. Generate report
./agents/qa-agent.sh report
```

### Continuous Monitoring
```bash
# Start continuous monitoring
./agents/qa-agent.sh monitor --continuous

# Periodic health checks
./agents/qa-agent.sh health --interval 60
```

### Issue Investigation
```bash
# When an issue is suspected
./agents/qa-agent.sh crash-check
./agents/qa-agent.sh performance
./agents/qa-agent.sh verify
```

## Configuration

The agent can be configured through:
- Environment variables
- Configuration file (`agents/qa-config.json`)
- Command-line parameters

### Environment Variables
```bash
QA_LOG_LEVEL=info|debug|error
QA_MONITOR_INTERVAL=30
QA_TEST_TIMEOUT=300
QA_REPORT_FORMAT=json|text
```

## Integration with Build Agent

### Parallel Workflow
1. **Build Agent** builds the app
2. **QA Agent** runs tests and monitors
3. **QA Agent** provides feedback to Build Agent
4. **Build Agent** adjusts based on feedback
5. Repeat cycle

### Feedback Loop
- Real-time status updates
- Issue notifications
- Performance alerts
- Test failure reports

## Troubleshooting

### Common Issues
- **Build fails**: Check Xcode installation and project configuration
- **Tests fail**: Verify test environment and dependencies
- **Monitoring issues**: Check log permissions and system access
- **Performance issues**: Monitor system resources

### Debug Mode
```bash
./agents/qa-agent.sh --debug <command>
```

This QA agent provides comprehensive testing and monitoring capabilities for the Sharp Timer App, ensuring high quality and reliability through continuous monitoring and feedback.