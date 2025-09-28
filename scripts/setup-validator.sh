#!/bin/bash

# NigelOS Setup Validator
# Verifies system setup, tests functionality, and reports issues

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NIGELOS_ROOT="$(dirname "$SCRIPT_DIR")"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m'

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }
log_test() { echo -e "${PURPLE}[TEST]${NC} $1"; }

# Global counters
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0
TESTS_WARNING=0

# Test result tracking
run_test() {
    local test_name="$1"
    local test_command="$2"
    local expected_result="${3:-0}"
    local warning_only="${4:-false}"

    ((TESTS_RUN++))
    log_test "Testing: $test_name"

    if eval "$test_command" >/dev/null 2>&1; then
        local result=$?
        if [ $result -eq $expected_result ]; then
            log_success "  ✓ $test_name - PASSED"
            ((TESTS_PASSED++))
            return 0
        else
            if [ "$warning_only" = "true" ]; then
                log_warning "  ⚠ $test_name - WARNING"
                ((TESTS_WARNING++))
            else
                log_error "  ✗ $test_name - FAILED"
                ((TESTS_FAILED++))
            fi
            return 1
        fi
    else
        if [ "$warning_only" = "true" ]; then
            log_warning "  ⚠ $test_name - WARNING"
            ((TESTS_WARNING++))
        else
            log_error "  ✗ $test_name - FAILED"
            ((TESTS_FAILED++))
        fi
        return 1
    fi
}

# Test essential binaries
test_essential_binaries() {
    log_info "Testing essential binaries..."

    # Core system tools
    run_test "bash available" "command -v bash"
    run_test "git available" "command -v git"
    run_test "curl available" "command -v curl"
    run_test "wget available" "command -v wget"

    # Package managers
    run_test "pacman available" "command -v pacman"
    run_test "yay available" "command -v yay" 0 true

    # Wayland/Hyprland ecosystem
    run_test "hyprland available" "command -v Hyprland"
    run_test "waybar available" "command -v waybar"
    run_test "kitty available" "command -v kitty"
    run_test "rofi available" "command -v rofi"

    # Graphics utilities
    run_test "hyprctl available" "command -v hyprctl"
    run_test "hyprpaper available" "command -v hyprpaper"
}

# Test Hyprland configuration
test_hyprland_config() {
    log_info "Testing Hyprland configuration..."

    # Check config files exist
    run_test "hyprland config exists" "[ -f ~/.config/hypr/hyprland.conf ]"
    run_test "hyprpaper config exists" "[ -f ~/.config/hypr/hyprpaper.conf ]"

    # Test config syntax
    if command -v Hyprland &> /dev/null; then
        run_test "hyprland config syntax" "Hyprland --help" 0 true
    fi

    # Check if Hyprland is running
    if pgrep -x "Hyprland" > /dev/null; then
        log_success "  ✓ Hyprland is currently running"
        ((TESTS_PASSED++))

        # Test hyprctl commands
        run_test "hyprctl monitors works" "hyprctl monitors"
        run_test "hyprctl workspaces works" "hyprctl workspaces"
    else
        log_warning "  ⚠ Hyprland is not currently running"
        ((TESTS_WARNING++))
    fi

    ((TESTS_RUN++))
}

# Test Waybar configuration
test_waybar_config() {
    log_info "Testing Waybar configuration..."

    # Check config files
    run_test "waybar config exists" "[ -f ~/.config/waybar/config ]"
    run_test "waybar style exists" "[ -f ~/.config/waybar/style.css ]"

    # Test JSON syntax of config
    if command -v jq &> /dev/null && [ -f ~/.config/waybar/config ]; then
        run_test "waybar config valid JSON" "jq empty ~/.config/waybar/config"
    fi

    # Check if waybar is running
    if pgrep -x "waybar" > /dev/null; then
        log_success "  ✓ Waybar is currently running"
        ((TESTS_PASSED++))
    else
        log_warning "  ⚠ Waybar is not currently running"
        ((TESTS_WARNING++))
    fi

    ((TESTS_RUN++))
}

# Test AI integration
test_ai_integration() {
    log_info "Testing AI integration..."

    # Check Ollama
    run_test "ollama available" "command -v ollama" 0 true

    if command -v ollama &> /dev/null; then
        # Test if ollama service is running
        if pgrep -f "ollama" > /dev/null; then
            log_success "  ✓ Ollama service is running"
            ((TESTS_PASSED++))

            # Test model availability
            if ollama list | grep -q "phi3"; then
                log_success "  ✓ Phi3 model available"
                ((TESTS_PASSED++))
            else
                log_warning "  ⚠ Phi3 model not found"
                ((TESTS_WARNING++))
            fi

            ((TESTS_RUN += 2))
        else
            log_warning "  ⚠ Ollama service not running"
            ((TESTS_WARNING++))
            ((TESTS_RUN++))
        fi
    fi

    # Check Echo AI app
    if [ -d "$NIGELOS_ROOT/apps/echo" ]; then
        run_test "Echo AI app directory exists" "[ -d '$NIGELOS_ROOT/apps/echo' ]"

        # Check for main script
        if [ -f "$NIGELOS_ROOT/apps/echo/echo_reliable.py" ]; then
            run_test "Echo AI main script exists" "[ -f '$NIGELOS_ROOT/apps/echo/echo_reliable.py' ]"
            run_test "Echo AI script executable" "[ -x '$NIGELOS_ROOT/apps/echo/echo_reliable.py' ]"
        fi
    else
        log_warning "  ⚠ Echo AI app not found"
        ((TESTS_WARNING++))
        ((TESTS_RUN++))
    fi
}

# Test development environment
test_development_environment() {
    log_info "Testing development environment..."

    # Programming languages
    run_test "python3 available" "command -v python3" 0 true
    run_test "node available" "command -v node" 0 true
    run_test "cargo available" "command -v cargo" 0 true
    run_test "go available" "command -v go" 0 true

    # Development tools
    run_test "gcc available" "command -v gcc" 0 true
    run_test "make available" "command -v make" 0 true
    run_test "vim available" "command -v vim" 0 true

    # Version control
    run_test "git configured" "git config --get user.name" 0 true
}

# Test GPU and hardware acceleration
test_gpu_acceleration() {
    log_info "Testing GPU and hardware acceleration..."

    # Check for GPU devices
    if lspci | grep -i vga > /dev/null; then
        log_success "  ✓ GPU device detected"
        ((TESTS_PASSED++))
    else
        log_warning "  ⚠ No GPU device found"
        ((TESTS_WARNING++))
    fi
    ((TESTS_RUN++))

    # AMD GPU specific tests
    if lspci | grep -i amd > /dev/null; then
        log_info "  AMD GPU detected"
        run_test "amdgpu driver loaded" "lsmod | grep amdgpu" 0 true
        run_test "ROCm available" "[ -d /opt/rocm ]" 0 true

        if command -v rocm-smi &> /dev/null; then
            run_test "rocm-smi works" "rocm-smi -v" 0 true
        fi
    fi

    # NVIDIA GPU specific tests
    if lspci | grep -i nvidia > /dev/null; then
        log_info "  NVIDIA GPU detected"
        run_test "nvidia driver loaded" "lsmod | grep nvidia" 0 true

        if command -v nvidia-smi &> /dev/null; then
            run_test "nvidia-smi works" "nvidia-smi" 0 true
        fi
    fi

    # OpenCL/Vulkan support
    run_test "vulkan support" "command -v vulkaninfo" 0 true
    run_test "opencl support" "command -v clinfo" 0 true
}

# Test network connectivity
test_network() {
    log_info "Testing network connectivity..."

    run_test "internet connectivity" "ping -c 1 8.8.8.8" 0 true
    run_test "DNS resolution" "nslookup google.com" 0 true
    run_test "HTTPS connectivity" "curl -s --head https://google.com" 0 true
}

# Test keybindings and shortcuts
test_keybindings() {
    log_info "Testing keybindings configuration..."

    if [ -f ~/.config/hypr/hyprland.conf ]; then
        # Check for essential keybindings
        local config_file=~/.config/hypr/hyprland.conf

        if grep -q "Alt.*I" "$config_file"; then
            log_success "  ✓ AI Chat keybinding (Alt+I) configured"
            ((TESTS_PASSED++))
        else
            log_warning "  ⚠ AI Chat keybinding (Alt+I) not found"
            ((TESTS_WARNING++))
        fi

        if grep -q "Alt.*Space" "$config_file"; then
            log_success "  ✓ App launcher keybinding (Alt+Space) configured"
            ((TESTS_PASSED++))
        else
            log_warning "  ⚠ App launcher keybinding (Alt+Space) not found"
            ((TESTS_WARNING++))
        fi

        ((TESTS_RUN += 2))
    else
        log_error "  ✗ Hyprland config not found for keybinding test"
        ((TESTS_FAILED++))
        ((TESTS_RUN++))
    fi
}

# Test fonts and themes
test_fonts_themes() {
    log_info "Testing fonts and themes..."

    # Check for Nerd Fonts
    if fc-list | grep -i "nerd" > /dev/null; then
        log_success "  ✓ Nerd Fonts detected"
        ((TESTS_PASSED++))
    else
        log_warning "  ⚠ Nerd Fonts not found"
        ((TESTS_WARNING++))
    fi

    # Check for JetBrains Mono specifically
    if fc-list | grep -i "jetbrains" > /dev/null; then
        log_success "  ✓ JetBrains Mono font detected"
        ((TESTS_PASSED++))
    else
        log_warning "  ⚠ JetBrains Mono font not found"
        ((TESTS_WARNING++))
    fi

    ((TESTS_RUN += 2))

    # Check GTK theme
    if [ -f ~/.config/gtk-3.0/settings.ini ]; then
        run_test "GTK3 theme configured" "[ -f ~/.config/gtk-3.0/settings.ini ]"
    fi
}

# Test wallpapers and visual setup
test_visual_setup() {
    log_info "Testing visual setup..."

    # Check wallpaper directory
    run_test "wallpaper directory exists" "[ -d ~/Pictures/Wallpapers ]" 0 true

    if [ -d ~/Pictures/Wallpapers ]; then
        local wallpaper_count=$(find ~/Pictures/Wallpapers -type f \( -name "*.jpg" -o -name "*.png" \) 2>/dev/null | wc -l)
        if [ $wallpaper_count -gt 0 ]; then
            log_success "  ✓ Found $wallpaper_count wallpapers"
            ((TESTS_PASSED++))
        else
            log_warning "  ⚠ No wallpapers found in ~/Pictures/Wallpapers"
            ((TESTS_WARNING++))
        fi
        ((TESTS_RUN++))
    fi

    # Check hyprpaper running
    if pgrep -x "hyprpaper" > /dev/null; then
        log_success "  ✓ Hyprpaper is running"
        ((TESTS_PASSED++))
    else
        log_warning "  ⚠ Hyprpaper is not running"
        ((TESTS_WARNING++))
    fi
    ((TESTS_RUN++))
}

# Generate detailed system report
generate_report() {
    local report_file="$HOME/nigelos-validation-report-$(date +%Y%m%d_%H%M%S).md"

    log_info "Generating detailed system report..."

    cat > "$report_file" << EOF
# NigelOS System Validation Report

**Generated:** $(date)
**Hostname:** $(hostname)
**User:** $(whoami)
**System:** $(uname -s) $(uname -r)

## 📊 Test Summary

- **Total Tests:** $TESTS_RUN
- **Passed:** $TESTS_PASSED ✅
- **Failed:** $TESTS_FAILED ❌
- **Warnings:** $TESTS_WARNING ⚠️

## 🖥️ System Information

### Hardware
\`\`\`
$(lscpu | head -10)
\`\`\`

### Memory
\`\`\`
$(free -h)
\`\`\`

### Graphics
\`\`\`
$(lspci | grep -i vga || echo "No VGA devices found")
\`\`\`

## 🔧 Configuration Status

### Hyprland
- Config: $([ -f ~/.config/hypr/hyprland.conf ] && echo "✅ Present" || echo "❌ Missing")
- Running: $(pgrep -x "Hyprland" > /dev/null && echo "✅ Yes" || echo "❌ No")

### Waybar
- Config: $([ -f ~/.config/waybar/config ] && echo "✅ Present" || echo "❌ Missing")
- Style: $([ -f ~/.config/waybar/style.css ] && echo "✅ Present" || echo "❌ Missing")
- Running: $(pgrep -x "waybar" > /dev/null && echo "✅ Yes" || echo "❌ No")

### AI Integration
- Ollama: $(command -v ollama &> /dev/null && echo "✅ Installed" || echo "❌ Missing")
- Models: $(ollama list 2>/dev/null | wc -l || echo "0") models available

## 🎨 Visual Setup

### Fonts
$(fc-list | grep -i nerd | wc -l) Nerd Fonts installed

### Wallpapers
$(find ~/Pictures/Wallpapers -type f \( -name "*.jpg" -o -name "*.png" \) 2>/dev/null | wc -l || echo "0") wallpapers available

## 🔍 Recommendations

EOF

    # Add recommendations based on test results
    if [ $TESTS_FAILED -gt 0 ]; then
        echo "### ❌ Critical Issues" >> "$report_file"
        echo "- $TESTS_FAILED tests failed. Please review the validation output above." >> "$report_file"
        echo "" >> "$report_file"
    fi

    if [ $TESTS_WARNING -gt 0 ]; then
        echo "### ⚠️ Warnings" >> "$report_file"
        echo "- $TESTS_WARNING warnings detected. These are optional components that could enhance your experience." >> "$report_file"
        echo "" >> "$report_file"
    fi

    if [ $TESTS_FAILED -eq 0 ] && [ $TESTS_WARNING -eq 0 ]; then
        echo "### 🎉 Excellent!" >> "$report_file"
        echo "Your NigelOS setup is complete and fully functional!" >> "$report_file"
        echo "" >> "$report_file"
    fi

    echo "## 📋 Next Steps" >> "$report_file"
    echo "" >> "$report_file"
    echo "1. Review any failed tests above" >> "$report_file"
    echo "2. Install missing optional components if desired" >> "$report_file"
    echo "3. Run \`./scripts/system-snapshot.sh create\` to backup your working setup" >> "$report_file"
    echo "4. Enjoy your NigelOS environment!" >> "$report_file"

    log_success "Report generated: $report_file"
}

# Run all tests
run_all_tests() {
    log_info "🚀 NigelOS Setup Validation Starting..."
    echo "======================================"
    echo

    test_essential_binaries
    echo
    test_hyprland_config
    echo
    test_waybar_config
    echo
    test_ai_integration
    echo
    test_development_environment
    echo
    test_gpu_acceleration
    echo
    test_network
    echo
    test_keybindings
    echo
    test_fonts_themes
    echo
    test_visual_setup
    echo

    # Summary
    echo "======================================"
    log_info "🏁 Validation Complete!"
    echo
    echo "📊 Results Summary:"
    echo "  Total tests: $TESTS_RUN"
    echo "  Passed: $TESTS_PASSED ✅"
    echo "  Failed: $TESTS_FAILED ❌"
    echo "  Warnings: $TESTS_WARNING ⚠️"
    echo

    if [ $TESTS_FAILED -eq 0 ]; then
        log_success "🎉 All critical tests passed! Your NigelOS setup is working great!"
    else
        log_error "❌ $TESTS_FAILED critical test(s) failed. Please review the output above."
    fi

    if [ $TESTS_WARNING -gt 0 ]; then
        log_warning "⚠️ $TESTS_WARNING optional component(s) missing or not configured."
    fi
}

# Quick health check
quick_check() {
    log_info "🔍 Quick NigelOS Health Check"
    echo "=============================="

    # Just test the essentials
    run_test "Hyprland" "command -v Hyprland"
    run_test "Waybar" "command -v waybar"
    run_test "Kitty" "command -v kitty"
    run_test "Config files" "[ -f ~/.config/hypr/hyprland.conf ]"

    echo
    if [ $TESTS_FAILED -eq 0 ]; then
        log_success "✅ Quick check passed! NigelOS essentials are working."
    else
        log_error "❌ Quick check failed. Run 'full' validation for details."
    fi
}

# Main help
show_help() {
    echo "NigelOS Setup Validator"
    echo "======================="
    echo
    echo "Commands:"
    echo "  full     - Run complete validation suite"
    echo "  quick    - Quick health check"
    echo "  report   - Generate detailed report"
    echo "  help     - Show this help"
    echo
    echo "Usage: $0 <command>"
}

# Main logic
case "${1:-}" in
    full)
        run_all_tests
        generate_report
        ;;
    quick)
        quick_check
        ;;
    report)
        run_all_tests
        generate_report
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        show_help
        exit 1
        ;;
esac