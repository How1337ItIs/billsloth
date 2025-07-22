# Bill Sloth Integration Test Suite

Comprehensive testing framework for validating the entire Bill Sloth system works correctly as an integrated whole.

## Overview

The integration test suite ensures all modules, libraries, and Bill-specific customizations work together seamlessly. It validates:

- Core system functionality
- Cross-module data sharing
- Workflow orchestration
- Bill-specific integrations (VRBO, EdBoiGames, Google Tasks)
- Backup management
- Unified architecture
- Command center operations

## Quick Start

### Run All Integration Tests
```bash
cd ~/bill\ sloth/tests
./integration_test_suite.sh
```

### Run Quick Test Menu
```bash
./run_tests.sh
```

### Run Specific Test Category
```bash
# Source the test suite
source integration_test_suite.sh

# Run only core tests
run_test "directories" "core" test_core_directories
run_test "libraries" "core" test_core_libraries

# Run only Bill-specific tests
source module_tests/test_bill_integrations.sh
run_bill_integration_tests
```

## Test Structure

```
tests/
├── integration_test_suite.sh    # Main test runner
├── run_tests.sh                # Quick test menu
├── test_fixtures.sh            # Test utilities and mock data
├── README.md                   # This file
├── module_tests/               # Detailed module tests
│   ├── test_data_sharing.sh
│   ├── test_workflow_orchestration.sh
│   └── test_bill_integrations.sh
└── output/                     # Test results (created on run)
    └── [timestamp]/
        ├── integration_test.log
        ├── test_report.txt
        └── [category]_[test].log
```

## Test Categories

### 1. Core System Tests
- Directory structure validation
- Library loading verification
- Command center initialization

### 2. Data Sharing Tests
- Cross-module data synchronization
- Cache operations
- Performance benchmarks
- Concurrent access handling

### 3. Workflow Orchestration Tests
- Workflow creation and execution
- Conditional workflows
- Parallel execution
- Error handling
- Data passing between steps

### 4. Bill-Specific Integration Tests
- VRBO guest workflow automation
- EdBoiGames content pipeline
- Google Tasks integration
- ChatGPT content generation
- CSV processing (Excel replacement)

### 5. Backup Management Tests
- Backup creation and restoration
- Compression and encryption
- Retention policies
- Cloud upload simulation

### 6. Architecture Tests
- Unified overlay system
- Module wrapper validation
- Bill feature enablement

### 7. Command Center Tests
- Health check functionality
- Module launching
- Quick action validation

## Test Output

### Console Output
- Color-coded results (GREEN=passed, RED=failed, YELLOW=skipped)
- Progress indicators for each test
- Summary statistics

### Log Files
- `integration_test.log` - Main test execution log
- `[category]_[test].log` - Individual test output
- `test_report.txt` - Comprehensive test report

### Test Report Contents
- Summary statistics (passed/failed/skipped)
- Detailed results by category
- Recommendations for failed tests
- Performance metrics where applicable

## Writing New Tests

### Test Function Template
```bash
test_my_new_feature() {
    echo "Testing my new feature..."
    
    # Setup
    source "$BASE_DIR/lib/my_library.sh"
    
    # Test logic
    if ! my_function_to_test; then
        echo "FAILED: Description of failure"
        return 1
    fi
    
    # Cleanup if needed
    
    echo "PASSED: My new feature works correctly"
    return 0
}
```

### Adding to Test Suite
1. Add test function to appropriate module test file
2. Include in test runner loop
3. Update test categories if needed

## Performance Benchmarks

The test suite includes performance tests for critical operations:

- Data sharing: Target < 5ms per operation
- Workflow execution: Parallel steps should complete concurrently
- Large data handling: Support for 1MB+ JSON objects

## Troubleshooting

### Common Issues

1. **Missing directories**
   - Run `bill_command_center.sh` first to initialize system
   - Check `quick_setup_missing()` function

2. **Library loading failures**
   - Verify all files have execute permissions
   - Check for syntax errors in modified files

3. **Test timeouts**
   - Increase timeout values for slow systems
   - Check for blocking operations

### Debug Mode
```bash
# Run with verbose output
bash -x integration_test_suite.sh

# Check specific test output
cat output/[timestamp]/[category]_[test].log
```

## Continuous Integration

### GitHub Actions Setup (Future)
```yaml
name: Integration Tests
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Run integration tests
        run: |
          cd tests
          ./integration_test_suite.sh
```

## Best Practices

1. **Run tests after major changes**
   - New module additions
   - Cross-module integration changes
   - Architecture modifications

2. **Keep tests fast**
   - Use mock data where possible
   - Avoid long sleep operations
   - Parallelize independent tests

3. **Maintain test independence**
   - Each test should be runnable alone
   - Clean up test artifacts
   - Don't rely on test execution order

4. **Update tests with features**
   - Add tests for new functionality
   - Update existing tests when behavior changes
   - Remove obsolete tests

## Next Steps

1. **Expand test coverage**
   - Add stress tests for production loads
   - Create integration scenarios
   - Add security validation tests

2. **Automation**
   - Set up scheduled test runs
   - Create pre-commit hooks
   - Add CI/CD pipeline

3. **Monitoring**
   - Track test execution times
   - Monitor test flakiness
   - Generate coverage reports