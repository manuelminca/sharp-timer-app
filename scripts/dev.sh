#!/bin/bash

# Sharp Timer App Development Script
# Usage: ./scripts/dev.sh [build|run|logs|crash|clean|test]

set -e

# Get absolute path to repo root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

PROJECT_DIR="$PROJECT_ROOT/Sharp Timer App"
PROJECT_NAME="Sharp Timer App"
SCHEME="Sharp Timer App"
BUILD_DIR="$PROJECT_DIR/build/Debug"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_usage() {
    echo "Usage: $0 [build|run|logs|crash|clean|test|help]"
    echo ""
    echo "Commands:"
    echo "  build   - Build the app"
    echo "  run     - Build and run the app"
    echo "  logs    - Show real-time logs"
    echo "  crash   - Show crash reports"
    echo "  clean   - Clean build artifacts"
    echo "  test    - Run unit tests"
    echo "  help    - Show this help message"
}

build_app() {
    echo -e "${BLUE}Building Sharp Timer App...${NC}"
    cd "$PROJECT_DIR"
    # Use -target instead of -scheme because schemes might not be shared
    xcodebuild -project "$PROJECT_NAME.xcodeproj" -target "$PROJECT_NAME" -configuration Debug build | tee build.log
    echo -e "${GREEN}Build completed!${NC}"
}

run_app() {
    echo -e "${BLUE}Building and running Sharp Timer App...${NC}"
    build_app
    
    APP_PATH="$BUILD_DIR/$PROJECT_NAME.app"
    echo -e "${YELLOW}Launching app from: $APP_PATH${NC}"
    
    if [ -d "$APP_PATH" ]; then
        # Kill existing instances first
        pkill -f "$PROJECT_NAME" || true
        
        # Open the app
        open "$APP_PATH"
        echo -e "${GREEN}App launched! Check your menu bar.${NC}"
    else
        echo -e "${RED}Error: App not found at $APP_PATH${NC}"
        exit 1
    fi
}

show_logs() {
    echo -e "${BLUE}Monitoring Sharp Timer App logs (Ctrl+C to stop)...${NC}"
    log stream --predicate 'processImagePath CONTAINS "Sharp Timer App"' --info
}

show_crash_reports() {
    echo -e "${BLUE}Looking for crash reports...${NC}"
    CRASH_REPORTS=$(find ~/Library/Logs/DiagnosticReports -name "*Sharp Timer App*" -type f | head -5)
    
    if [ -z "$CRASH_REPORTS" ]; then
        echo -e "${GREEN}No crash reports found.${NC}"
    else
        echo -e "${YELLOW}Recent crash reports:${NC}"
        echo "$CRASH_REPORTS"
        echo ""
        echo -e "${YELLOW}Opening most recent crash report...${NC}"
        open "$(echo "$CRASH_REPORTS" | head -1)"
    fi
}

clean_build() {
    echo -e "${BLUE}Cleaning build artifacts...${NC}"
    cd "$PROJECT_DIR"
    xcodebuild clean -project "$PROJECT_NAME.xcodeproj" -target "$PROJECT_NAME" -configuration Debug
    echo -e "${GREEN}Clean completed!${NC}"
}

run_tests() {
    echo -e "${BLUE}Running unit tests...${NC}"
    cd "$PROJECT_DIR"
    xcodebuild test -project "$PROJECT_NAME.xcodeproj" -scheme "$SCHEME" -destination 'platform=macOS'
    echo -e "${GREEN}Tests completed!${NC}"
}

show_help() {
    print_usage
}

# Main script logic
case "${1:-help}" in
    build)
        build_app
        ;;
    run)
        run_app
        ;;
    logs)
        show_logs
        ;;
    crash)
        show_crash_reports
        ;;
    clean)
        clean_build
        ;;
    test)
        run_tests
        ;;
    help|*)
        show_help
        ;;
esac