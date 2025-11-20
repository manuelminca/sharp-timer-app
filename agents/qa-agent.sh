#!/bin/bash

# Sharp Timer App QA Agent
# A comprehensive QA agent for building, testing, and monitoring the Sharp Timer App

set -e

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
DEV_SCRIPT="$PROJECT_ROOT/scripts/dev.sh"
QA_DIR="$SCRIPT_DIR"
LOG_DIR="$QA_DIR/logs"
REPORT_DIR="$QA_DIR/reports"
CONFIG_FILE="$QA_DIR/qa-config.json"

# Create necessary directories
mkdir -p "$LOG_DIR" "$REPORT_DIR"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Default configuration
QA_LOG_LEVEL="${QA_LOG_LEVEL:-info}"
QA_MONITOR_INTERVAL="${QA_MONITOR_INTERVAL:-30}"
QA_TEST_TIMEOUT="${QA_TEST_TIMEOUT:-300}"
QA_REPORT_FORMAT="${QA_REPORT_FORMAT:-text}"
DEBUG_MODE=false

# Logging function
log() {
    local level=$1
    shift
    local message="$*"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    # Log to file
    echo "[$timestamp] [$level] $message" >> "$LOG_DIR/qa-agent.log"
    
    # Output to console based on log level
    case $level in
        "ERROR")
            [[ "$QA_LOG_LEVEL" == "error" || "$QA_LOG_LEVEL" == "debug" || "$QA_LOG_LEVEL" == "info" ]] && echo -e "${RED}[ERROR]${NC} $message" >&2
            ;;
        "WARN")
            [[ "$QA_LOG_LEVEL" == "debug" || "$QA_LOG_LEVEL" == "info" ]] && echo -e "${YELLOW}[WARN]${NC} $message"
            ;;
        "INFO")
            [[ "$QA_LOG_LEVEL" == "debug" || "$QA_LOG_LEVEL" == "info" ]] && echo -e "${BLUE}[INFO]${NC} $message"
            ;;
        "DEBUG")
            [[ "$QA_LOG_LEVEL" == "debug" ]] && echo -e "${PURPLE}[DEBUG]${NC} $message"
            ;;
    esac
}

# Send message to Build Agent (placeholder for future implementation)
send_to_build_agent() {
    local message_type=$1
    local data=$2
    local timestamp=$(date -u +"%Y-%m-%dT%H:%M:%S.%3NZ")
    
    if [[ "$DEBUG_MODE" == true ]]; then
        echo -e "${CYAN}[TO BUILD AGENT]${NC} $message_type: $data"
    fi
    
    # Log the communication
    echo "[$timestamp] TO_BUILD_AGENT: $message_type: $data" >> "$LOG_DIR/agent-communication.log"
}

# Build functions - using existing dev.sh script
build_app() {
    log "INFO" "Starting build process using dev.sh..."
    send_to_build_agent "build_status" "starting"
    
    if [[ "$DEBUG_MODE" == true ]]; then
        log "DEBUG" "Executing: $DEV_SCRIPT build"
    fi
    
    if "$DEV_SCRIPT" build > "$LOG_DIR/build.log" 2>&1; then
        log "INFO" "Build completed successfully"
        send_to_build_agent "build_status" '{"status": "success", "details": "Build completed without errors"}'
        return 0
    else
        log "ERROR" "Build failed. Check $LOG_DIR/build.log for details"
        send_to_build_agent "build_status" '{"status": "failed", "details": "Build failed - see build log"}'
        return 1
    fi
}

clean_build() {
    log "INFO" "Cleaning build artifacts using dev.sh..."
    "$DEV_SCRIPT" clean > "$LOG_DIR/clean.log" 2>&1
    log "INFO" "Clean completed"
}

rebuild_app() {
    log "INFO" "Starting rebuild process using dev.sh..."
    clean_build
    build_app
}

run_app() {
    log "INFO" "Building and running app using dev.sh..."
    send_to_build_agent "app_status" '{"status": "starting", "action": "launch"}'
    
    if "$DEV_SCRIPT" run > "$LOG_DIR/run.log" 2>&1; then
        log "INFO" "App launched successfully"
        send_to_build_agent "app_status" '{"status": "running", "action": "launched"}'
        return 0
    else
        log "ERROR" "Failed to build and run app"
        send_to_build_agent "app_status" '{"status": "failed", "action": "launch_failed"}'
        return 1
    fi
}

# Testing functions
run_unit_tests() {
    log "INFO" "Running unit tests using dev.sh..."
    send_to_build_agent "test_status" '{"type": "unit", "status": "starting"}'
    
    local test_log="$LOG_DIR/unit-tests.log"
    
    if timeout $QA_TEST_TIMEOUT "$DEV_SCRIPT" test > "$test_log" 2>&1; then
        local passed=$(grep -c "Test Case.*passed" "$test_log" || echo "0")
        local failed=$(grep -c "Test Case.*failed" "$test_log" || echo "0")
        log "INFO" "Unit tests completed: $passed passed, $failed failed"
        send_to_build_agent "test_results" "{\"type\": \"unit\", \"passed\": $passed, \"failed\": $failed}"
        return 0
    else
        log "ERROR" "Unit tests failed or timed out"
        send_to_build_agent "test_results" '{"type": "unit", "status": "failed", "reason": "timeout_or_error"}'
        return 1
    fi
}

run_ui_tests() {
    log "INFO" "Running UI tests..."
    send_to_build_agent "test_status" '{"type": "ui", "status": "starting"}'
    
    local test_log="$LOG_DIR/ui-tests.log"
    
    # Navigate to project directory for UI tests
    cd "$PROJECT_ROOT/Sharp Timer App"
    
    if timeout $QA_TEST_TIMEOUT xcodebuild test -project "Sharp Timer App.xcodeproj" -scheme "Sharp Timer App" -destination 'platform=macOS' -only-testing:"Sharp Timer AppUITests" > "$test_log" 2>&1; then
        local passed=$(grep -c "Test Case.*passed" "$test_log" || echo "0")
        local failed=$(grep -c "Test Case.*failed" "$test_log" || echo "0")
        log "INFO" "UI tests completed: $passed passed, $failed failed"
        send_to_build_agent "test_results" "{\"type\": \"ui\", \"passed\": $passed, \"failed\": $failed}"
        return 0
    else
        log "ERROR" "UI tests failed or timed out"
        send_to_build_agent "test_results" '{"type": "ui", "status": "failed", "reason": "timeout_or_error"}'
        return 1
    fi
}

run_all_tests() {
    log "INFO" "Running all tests..."
    local unit_result=0
    local ui_result=0
    
    run_unit_tests || unit_result=1
    run_ui_tests || ui_result=1
    
    if [[ $unit_result -eq 0 && $ui_result -eq 0 ]]; then
        log "INFO" "All tests passed"
        return 0
    else
        log "ERROR" "Some tests failed"
        return 1
    fi
}

run_integration_tests() {
    log "INFO" "Running integration tests..."
    
    # Test app launch and basic functionality
    if ! run_app; then
        log "ERROR" "Integration test failed: App launch"
        return 1
    fi
    
    sleep 3  # Wait for app to fully launch
    
    # Check if app is running
    if pgrep -f "Sharp Timer App" > /dev/null; then
        log "INFO" "App is running - integration test passed"
        send_to_build_agent "test_results" '{"type": "integration", "status": "passed"}'
        return 0
    else
        log "ERROR" "App not running - integration test failed"
        send_to_build_agent "test_results" '{"type": "integration", "status": "failed"}'
        return 1
    fi
}

# Monitoring functions
monitor_logs() {
    log "INFO" "Starting log monitoring using dev.sh logs (Press Ctrl+C to stop)..."
    send_to_build_agent "monitor_status" '{"type": "logs", "status": "starting"}'
    
    local monitor_log="$LOG_DIR/monitor.log"
    
    # Use dev.sh logs command and capture output
    "$DEV_SCRIPT" logs | tee -a "$monitor_log" &
    local monitor_pid=$!
    
    # Monitor for errors and send alerts
    tail -f "$monitor_log" | while read line; do
        if echo "$line" | grep -qi "error\|crash\|fault"; then
            send_to_build_agent "issue" '{"severity": "critical", "description": "Error detected in logs", "details": "'"$line"'"}'
        elif echo "$line" | grep -qi "warning"; then
            send_to_build_agent "issue" '{"severity": "warning", "description": "Warning detected in logs", "details": "'"$line"'"}'
        fi
    done &
    
    trap "kill $monitor_pid 2>/dev/null; log 'INFO' 'Log monitoring stopped'" EXIT
    wait $monitor_pid
}

check_crashes() {
    log "INFO" "Checking for crash reports using dev.sh..."
    
    # Use dev.sh crash command and capture output
    local crash_output=$("$DEV_SCRIPT" crash 2>&1)
    local crash_log="$LOG_DIR/crash-check.log"
    echo "$crash_output" > "$crash_log"
    
    if echo "$crash_output" | grep -q "No crash reports found"; then
        log "INFO" "No crash reports found"
        send_to_build_agent "crash_status" '{"status": "none_found"}'
        return 0
    else
        log "WARN" "Crash reports found"
        local crash_reports=$(find ~/Library/Logs/DiagnosticReports -name "*Sharp Timer App*" -type f 2>/dev/null | head -5)
        
        echo "$crash_reports" | while read report; do
            log "WARN" "  - $report"
        done
        
        if [[ -n "$crash_reports" ]]; then
            local latest_report=$(echo "$crash_reports" | head -1)
            log "INFO" "Analyzing latest crash report: $latest_report"
            
            # Extract key crash information
            local crash_time=$(grep "Date/Time:" "$latest_report" | head -1 | cut -d: -f2-)
            local crash_reason=$(grep "Exception Type:" "$latest_report" | head -1 | cut -d: -f2-)
            
            send_to_build_agent "crash_detected" "{\"time\": \"$crash_time\", \"reason\": \"$crash_reason\", \"file\": \"$latest_report\"}"
        fi
        
        return 1
    fi
}

monitor_performance() {
    log "INFO" "Monitoring performance..."
    local perf_log="$LOG_DIR/performance.log"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    # Check if app is running
    local pid=$(pgrep -f "Sharp Timer App" | head -1)
    if [[ -z "$pid" ]]; then
        log "WARN" "App not running - cannot monitor performance"
        return 1
    fi
    
    # Get CPU and memory usage
    local ps_output=$(ps -p $pid -o %cpu,rss,vsz 2>/dev/null | tail -1)
    local cpu_usage=$(echo $ps_output | awk '{print $1}')
    local memory_rss=$(echo $ps_output | awk '{print $2}')
    local memory_vsz=$(echo $ps_output | awk '{print $3}')
    
    log "INFO" "Performance - CPU: ${cpu_usage}%, RSS: ${memory_rss}KB, VSZ: ${memory_vsz}KB"
    
    # Log performance data
    echo "$timestamp,$cpu_usage,$memory_rss,$memory_vsz" >> "$perf_log"
    
    # Send performance data to build agent
    send_to_build_agent "performance" "{\"cpu\": \"$cpu_usage\", \"memory_rss\": \"$memory_rss\", \"memory_vsz\": \"$memory_vsz\", \"status\": \"normal\"}"
    
    # Check for performance issues
    local cpu_num=$(echo "$cpu_usage" | cut -d. -f1)
    if [[ $cpu_num -gt 80 ]]; then
        send_to_build_agent "issue" '{"severity": "warning", "description": "High CPU usage detected", "details": "CPU: '"$cpu_usage"'%"}'
    fi
    
    if [[ $memory_rss -gt 100000 ]]; then  # > 100MB
        send_to_build_agent "issue" '{"severity": "warning", "description": "High memory usage detected", "details": "RSS: '"$memory_rss"'KB"}'
    fi
}

health_check() {
    log "INFO" "Performing health check..."
    local health_status="healthy"
    local issues=()
    
    # Check if app can be built
    if ! build_app; then
        health_status="unhealthy"
        issues+=("build_failed")
    fi
    
    # Check for crashes
    if check_crashes; then
        issues+=("crashes_found")
        health_status="unhealthy"
    fi
    
    # Check if app is running (optional)
    if pgrep -f "Sharp Timer App" > /dev/null; then
        monitor_performance
    fi
    
    # Run quick tests
    if ! run_integration_tests; then
        health_status="degraded"
        issues+=("integration_failed")
    fi
    
    log "INFO" "Health check completed: $health_status"
    if [[ ${#issues[@]} -gt 0 ]]; then
        log "WARN" "Issues detected: ${issues[*]}"
    fi
    
    send_to_build_agent "health_status" "{\"status\": \"$health_status\", \"issues\": [$(printf '"%s",' "${issues[@]}" | sed 's/,$//')]}"
    
    [[ "$health_status" == "healthy" ]]
}

# Verification functions
verify_app_functionality() {
    log "INFO" "Verifying app functionality..."
    local verification_log="$LOG_DIR/verification.log"
    
    # Get build directory from dev.sh script
    local BUILD_DIR=$(grep "BUILD_DIR=" "$DEV_SCRIPT" | cut -d'=' -f2 | tr -d '"')
    
    # Check app structure
    local app_path="$BUILD_DIR/Sharp Timer App.app"
    if [[ ! -d "$app_path" ]]; then
        log "ERROR" "App not found at $app_path"
        return 1
    fi
    
    # Check main executable
    local executable="$app_path/Contents/MacOS/Sharp Timer App"
    if [[ ! -x "$executable" ]]; then
        log "ERROR" "App executable not found or not executable"
        return 1
    fi
    
    # Check Info.plist
    local info_plist="$app_path/Contents/Info.plist"
    if [[ ! -f "$info_plist" ]]; then
        log "ERROR" "Info.plist not found"
        return 1
    fi
    
    # Verify bundle identifier
    local bundle_id=$(defaults read "$info_plist" CFBundleIdentifier 2>/dev/null)
    log "INFO" "Bundle ID: $bundle_id"
    
    log "INFO" "App functionality verification passed"
    return 0
}

# Reporting functions
generate_report() {
    log "INFO" "Generating QA report..."
    local report_file="$REPORT_DIR/qa-report-$(date +%Y%m%d-%H%M%S).$QA_REPORT_FORMAT"
    
    case $QA_REPORT_FORMAT in
        "json")
            generate_json_report > "$report_file"
            ;;
        "text"|*)
            generate_text_report > "$report_file"
            ;;
    esac
    
    log "INFO" "Report generated: $report_file"
    echo "Report saved to: $report_file"
}

generate_text_report() {
    echo "Sharp Timer App QA Report"
    echo "========================="
    echo "Generated: $(date)"
    echo ""
    
    echo "Build Status:"
    if [[ -f "$LOG_DIR/build.log" ]]; then
        if grep -q "BUILD SUCCEEDED" "$LOG_DIR/build.log"; then
            echo "  ✓ Build successful"
        else
            echo "  ✗ Build failed"
        fi
    else
        echo "  ? No build log found"
    fi
    
    echo ""
    echo "Test Results:"
    if [[ -f "$LOG_DIR/unit-tests.log" ]]; then
        local unit_passed=$(grep -c "Test Case.*passed" "$LOG_DIR/unit-tests.log" 2>/dev/null || echo "0")
        local unit_failed=$(grep -c "Test Case.*failed" "$LOG_DIR/unit-tests.log" 2>/dev/null || echo "0")
        echo "  Unit Tests: $unit_passed passed, $unit_failed failed"
    fi
    
    if [[ -f "$LOG_DIR/ui-tests.log" ]]; then
        local ui_passed=$(grep -c "Test Case.*passed" "$LOG_DIR/ui-tests.log" 2>/dev/null || echo "0")
        local ui_failed=$(grep -c "Test Case.*failed" "$LOG_DIR/ui-tests.log" 2>/dev/null || echo "0")
        echo "  UI Tests: $ui_passed passed, $ui_failed failed"
    fi
    
    echo ""
    echo "Crash Reports:"
    local crash_count=$(find ~/Library/Logs/DiagnosticReports -name "*Sharp Timer App*" -type f 2>/dev/null | wc -l)
    echo "  Found $crash_count crash report(s)"
    
    echo ""
    echo "Performance:"
    if [[ -f "$LOG_DIR/performance.log" ]]; then
        local latest_perf=$(tail -1 "$LOG_DIR/performance.log" 2>/dev/null)
        if [[ -n "$latest_perf" ]]; then
            echo "  Latest: $latest_perf"
        fi
    fi
    
    echo ""
    echo "Recent Issues:"
    if [[ -f "$LOG_DIR/qa-agent.log" ]]; then
        grep "ERROR\|WARN" "$LOG_DIR/qa-agent.log" | tail -5 | while read line; do
            echo "  $line"
        done
    fi
}

generate_json_report() {
    echo "{"
    echo "  \"timestamp\": \"$(date -u +"%Y-%m-%dT%H:%M:%S.%3NZ")\","
    echo "  \"project\": \"Sharp Timer App\","
    echo "  \"build\": {"
    
    if [[ -f "$LOG_DIR/build.log" ]]; then
        if grep -q "BUILD SUCCEEDED" "$LOG_DIR/build.log"; then
            echo "    \"status\": \"success\""
        else
            echo "    \"status\": \"failed\""
        fi
    else
        echo "    \"status\": \"unknown\""
    fi
    
    echo "  },"
    echo "  \"tests\": {"
    
    if [[ -f "$LOG_DIR/unit-tests.log" ]]; then
        local unit_passed=$(grep -c "Test Case.*passed" "$LOG_DIR/unit-tests.log" 2>/dev/null || echo "0")
        local unit_failed=$(grep -c "Test Case.*failed" "$LOG_DIR/unit-tests.log" 2>/dev/null || echo "0")
        echo "    \"unit\": { \"passed\": $unit_passed, \"failed\": $unit_failed }"
    fi
    
    if [[ -f "$LOG_DIR/ui-tests.log" ]]; then
        local ui_passed=$(grep -c "Test Case.*passed" "$LOG_DIR/ui-tests.log" 2>/dev/null || echo "0")
        local ui_failed=$(grep -c "Test Case.*failed" "$LOG_DIR/ui-tests.log" 2>/dev/null || echo "0")
        echo "    \"ui\": { \"passed\": $ui_passed, \"failed\": $ui_failed }"
    fi
    
    echo "  },"
    echo "  \"crashes\": $(find ~/Library/Logs/DiagnosticReports -name "*Sharp Timer App*" -type f 2>/dev/null | wc -l)"
    echo "}"
}

# Continuous monitoring
continuous_monitor() {
    log "INFO" "Starting continuous monitoring..."
    
    while true; do
        health_check
        sleep $QA_MONITOR_INTERVAL
    done
}

# Help function
print_usage() {
    echo "Sharp Timer App QA Agent"
    echo "========================"
    echo "Usage: $0 [COMMAND] [OPTIONS]"
    echo ""
    echo "Build Commands (uses dev.sh):"
    echo "  build              Build the app (via dev.sh)"
    echo "  rebuild            Clean and rebuild (via dev.sh)"
    echo "  run                Build and run the app (via dev.sh)"
    echo ""
    echo "Testing Commands:"
    echo "  test-unit          Run unit tests (via dev.sh)"
    echo "  test-ui            Run UI tests"
    echo "  test-all           Run all tests"
    echo "  test-integration   Run integration tests"
    echo ""
    echo "Monitoring Commands (uses dev.sh):"
    echo "  monitor            Monitor real-time logs (via dev.sh)"
    echo "  crash-check        Check for crash reports (via dev.sh)"
    echo "  performance        Monitor performance"
    echo "  health             Perform health check"
    echo ""
    echo "Reporting Commands:"
    echo "  report             Generate QA report"
    echo "  verify             Verify app functionality"
    echo ""
    echo "Advanced Commands:"
    echo "  continuous         Start continuous monitoring"
    echo ""
    echo "Options:"
    echo "  --debug            Enable debug mode"
    echo "  --help             Show this help message"
    echo ""
    echo "Environment Variables:"
    echo "  QA_LOG_LEVEL       Log level (error|warn|info|debug)"
    echo "  QA_MONITOR_INTERVAL Monitoring interval in seconds (default: 30)"
    echo "  QA_TEST_TIMEOUT    Test timeout in seconds (default: 300)"
    echo "  QA_REPORT_FORMAT   Report format (text|json, default: text)"
    echo ""
    echo "Note: This QA agent leverages the existing dev.sh script for core functionality"
}

# Main script logic
main() {
    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --debug)
                DEBUG_MODE=true
                QA_LOG_LEVEL="debug"
                shift
                ;;
            --help)
                print_usage
                exit 0
                ;;
            *)
                COMMAND=$1
                shift
                ;;
        esac
    done
    
    # Initialize
    log "INFO" "QA Agent starting with command: ${COMMAND:-help}"
    
    # Execute command
    case "${COMMAND:-help}" in
        build)
            build_app
            ;;
        rebuild)
            rebuild_app
            ;;
        run)
            run_app
            ;;
        test-unit)
            run_unit_tests
            ;;
        test-ui)
            run_ui_tests
            ;;
        test-all)
            run_all_tests
            ;;
        test-integration)
            run_integration_tests
            ;;
        monitor)
            monitor_logs
            ;;
        crash-check)
            check_crashes
            ;;
        performance)
            monitor_performance
            ;;
        health)
            health_check
            ;;
        report)
            generate_report
            ;;
        verify)
            verify_app_functionality
            ;;
        continuous)
            continuous_monitor
            ;;
        help|*)
            print_usage
            ;;
    esac
}

# Run main function with all arguments
main "$@"