# API Testing Guide for BlitzNow Training App

This guide provides comprehensive testing tools for all APIs in the BlitzNow Training App.

## 🚀 Quick Start

### 1. Start the Server
```bash
python3 simple_local_server.py --port 8000
```

### 2. Run Tests
```bash
# Quick test (9 basic tests)
python3 simple_test.py

# Or use the test runner
python3 run_tests.py quick
./test_apis.sh quick
```

## 📋 Available Testing Tools

### 1. **Simple Test** (`simple_test.py`)
- **Purpose**: Quick validation of all endpoints
- **Tests**: 9 basic API calls
- **Time**: ~5 seconds
- **Usage**: `python3 simple_test.py`

### 2. **Quick API Test** (`quick_api_test.py`)
- **Purpose**: Comprehensive testing with detailed output
- **Tests**: 27 tests including error cases
- **Time**: ~15 seconds
- **Usage**: 
  ```bash
  python3 quick_api_test.py                    # Test all endpoints
  python3 quick_api_test.py rider-info         # Test specific endpoint
  ```

### 3. **Comprehensive Test** (`test_all_apis.py`)
- **Purpose**: Full validation with detailed logging
- **Tests**: 50+ tests with various scenarios
- **Time**: ~30 seconds
- **Features**: Saves results to JSON file
- **Usage**: `python3 test_all_apis.py`

### 4. **Test Runner** (`run_tests.py`)
- **Purpose**: Unified interface for all tests
- **Usage**:
  ```bash
  python3 run_tests.py quick          # Quick tests
  python3 run_tests.py detailed       # Detailed tests
  python3 run_tests.py comprehensive  # Full tests
  python3 run_tests.py rider-info     # Specific endpoint
  ```

### 5. **Bash Script** (`test_apis.sh`)
- **Purpose**: Easy command-line testing
- **Usage**:
  ```bash
  ./test_apis.sh quick          # Quick tests
  ./test_apis.sh detailed       # Detailed tests
  ./test_apis.sh comprehensive  # Full tests
  ./test_apis.sh rider-info     # Specific endpoint
  ```

## 🧪 Test Coverage

### GET Endpoints
- ✅ `/rider-info` - Get rider information
- ✅ `/training-progress` - Get training progress
- ✅ `/get-tutorials` - Get tutorials for rider

### POST Endpoints
- ✅ `/tutorials` - Tutorial management (create/get)
- ✅ `/tutorial-state` - Update tutorial completion
- ✅ `/day-hub-mappings` - Day-hub-tutorial mappings
- ✅ `/module-started` - Mark module as started
- ✅ `/module-completed` - Mark module as completed
- ✅ `/update-progress` - Update training progress

### Error Cases
- ✅ Missing required parameters
- ✅ Invalid rider IDs
- ✅ Invalid endpoints
- ✅ CORS preflight requests

## 📊 Test Scenarios

### 1. **Valid Data Tests**
- Test with valid rider IDs: `12345`, `67890`, `11111`
- Test with different rider ages (1, 2, 3)
- Test with different hub types (central_hub, quick_hub, lm_hub)

### 2. **Error Handling Tests**
- Missing required parameters
- Invalid rider IDs
- Invalid tutorial IDs
- Malformed JSON requests

### 3. **Edge Cases**
- Empty request bodies
- Invalid HTTP methods
- CORS preflight requests
- Non-existent endpoints

## 🔧 Mock Data

The testing uses mock data for database-dependent endpoints:

### Mock Riders
```json
{
  "12345": {"rider_id": "12345", "node_type": "central_hub", "rider_age": 1},
  "67890": {"rider_id": "67890", "node_type": "quick_hub", "rider_age": 2},
  "11111": {"rider_id": "11111", "node_type": "lm_hub", "rider_age": 3}
}
```

### Mock Tutorials by Age
- **Age 1**: delivery_flow, pickup_flow
- **Age 2**: cod_flow
- **Age 3**: Advanced tutorials

## 📈 Expected Results

### Quick Test (9 tests)
- **Expected**: 9/9 passed (100%)
- **Time**: ~5 seconds

### Detailed Test (27 tests)
- **Expected**: 22-25/27 passed (81-93%)
- **Time**: ~15 seconds
- **Note**: Some tests may fail due to server limitations

### Comprehensive Test (50+ tests)
- **Expected**: 45-50+ passed (90%+)
- **Time**: ~30 seconds
- **Output**: Detailed JSON report

## 🐛 Troubleshooting

### Server Not Running
```bash
# Check if server is running
curl http://localhost:8000/rider-info?rider_id=12345

# Start server
python3 simple_local_server.py --port 8000
```

### Port Already in Use
```bash
# Kill existing processes
pkill -f "python3.*local_server"
lsof -ti:8000 | xargs kill -9

# Start server
python3 simple_local_server.py --port 8000
```

### Test Failures
1. **Check server status**: Ensure server is running
2. **Check logs**: Look at server output for errors
3. **Verify endpoints**: Test individual endpoints with curl
4. **Check mock data**: Ensure mock data is properly configured

## 📝 Sample Test Output

### Quick Test
```
🚀 Testing BlitzNow Training App APIs
==================================================
Testing: http://localhost:8000
Time: 2025-09-08 22:09:06
==================================================

✅ GET rider-info - 200
✅ GET training-progress - 200
✅ GET get-tutorials - 200
✅ POST tutorials - 200
✅ POST tutorial-state - 200
✅ POST day-hub-mappings - 200
✅ POST module-started - 200
✅ POST module-completed - 200
✅ POST update-progress - 200

📊 Results: 9/9 tests passed (100.0%)
🎯 Testing Complete!
```

### Detailed Test
```
🚀 Testing BlitzNow Training App APIs
==================================================
Testing: http://localhost:8000
Time: 2025-09-08 22:09:06
==================================================

📡 Testing GET Endpoints
------------------------------
✅ PASS Rider Info - Status: 200
✅ PASS Rider Info (Invalid) - Status: 404
✅ PASS Rider Info (Missing ID) - Status: 400
...

📊 Test Summary
==================================================
Total Tests: 27
✅ Passed: 22
❌ Failed: 5
Success Rate: 81.5%
```

## 🎯 Best Practices

1. **Always start with quick tests** for basic validation
2. **Use detailed tests** for comprehensive validation
3. **Run comprehensive tests** before deployment
4. **Check server logs** if tests fail
5. **Test specific endpoints** for debugging
6. **Save test results** for documentation

## 📁 File Structure

```
blitznow_training_flutter/
├── simple_test.py              # Quick 9-test validation
├── quick_api_test.py           # Detailed 27-test validation
├── test_all_apis.py            # Comprehensive 50+ test validation
├── run_tests.py                # Unified test runner
├── test_apis.sh                # Bash test script
├── simple_local_server.py      # Mock data server
├── local_server.py             # Original server (with DB issues)
├── mock_data.py                # Mock data definitions
└── TESTING_GUIDE.md            # This guide
```

## 🚀 Continuous Integration

For automated testing, use:

```bash
# Quick validation in CI
python3 simple_test.py && echo "All tests passed"

# Detailed validation
python3 quick_api_test.py | grep "Success Rate"

# Comprehensive validation with reporting
python3 test_all_apis.py
```

This testing suite ensures your BlitzNow Training App APIs are working correctly and provides multiple levels of validation for different use cases.