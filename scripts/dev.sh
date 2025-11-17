#!/bin/bash

# Sharp Timer App Development Script
# Usage: ./scripts/dev.sh [build|run|logs|crash|clean|test]

set -e

PROJECT_DIR="Sharp Timer App"
PROJECT_NAME="Sharp Timer App"
SCHEME="Sharp Timer App"
BUILD_DIR="/Users/valutico/Library/Developer/Xcode/DerivedData/Sharp_Timer_App-dqcdjekvnfcrboekjfmhmgmmhdlj/Build/Products/Debug"

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
    xcodebuild -project "$PROJECT_NAME.xcodeproj" -scheme "$SCHEME" -configuration Debug build | tee build.log
    echo -e "${GREEN}Build completed!${NC}"
}

run_app() {
    echo -e "${BLUE}Building and running Sharp Timer App...${NC}"
    build_app
    echo -e "${YELLOW}Launching app...${NC}"
    open "$BUILD_DIR/$PROJECT_NAME.app"
    echo -e "${GREEN}App launched! Check your menu bar.${NC}"
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
    xcodebuild clean -project "$PROJECT_NAME.xcodeproj" -scheme "$SCHEME"
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
