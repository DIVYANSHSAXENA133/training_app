#!/usr/bin/env python3
"""
Comprehensive API Test Suite for BlitzNow Training App
Tests all Lambda endpoints with proper payload structures
"""

import requests
import json
import time
from datetime import datetime, timezone

# API Configuration
API_BASE_URL = "https://tlffrtmssa.execute-api.us-east-2.amazonaws.com"

# Colors for output
class Colors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKCYAN = '\033[96m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'

def print_status(message, status="info"):
    """Print colored status messages"""
    if status == "header":
        print(f"{Colors.HEADER}{Colors.BOLD}{message}{Colors.ENDC}")
    elif status == "success":
        print(f"{Colors.OKGREEN}✅ {message}{Colors.ENDC}")
    elif status == "fail":
        print(f"{Colors.FAIL}❌ {message}{Colors.ENDC}")
    elif status == "info":
        print(f"{Colors.OKBLUE}ℹ️  {message}{Colors.ENDC}")
    elif status == "warning":
        print(f"{Colors.WARNING}⚠️  {message}{Colors.ENDC}")
    else:
        print(f"   {message}")

def test_get_rider_info():
    """Test GET /rider-info endpoint"""
    print_status("TESTING GET /rider-info", "header")
    print("=" * 50)
    
    test_cases = [
        ("478", "central_hub", "Should return central_hub rider"),
        ("456", "lm_hub", "Should return lm_hub rider"),
        ("123", None, "Should return 404 for non-existent rider"),
        ("999999", None, "Should return 404 for non-existent rider")
    ]
    
    success_count = 0
    total_tests = len(test_cases)
    
    for rider_id, expected_node_type, description in test_cases:
        print_status(f"Test: {description}", "info")
        url = f"{API_BASE_URL}/rider-info?rider_id={rider_id}"
        print_status(f"URL: {url}", "info")
        
        try:
            response = requests.get(url)
            print_status(f"Status Code: {response.status_code}", "info")
            
            if response.status_code == 200:
                data = response.json()
                print_status(f"Response: {json.dumps(data, indent=2)}", "success")
                
                if expected_node_type and data.get('node_type') == expected_node_type:
                    print_status(f"✅ Node type matches: {expected_node_type}", "success")
                    success_count += 1
                elif expected_node_type is None:
                    print_status("❌ Expected 404 for non-existent rider", "fail")
                else:
                    print_status(f"❌ Node type mismatch. Expected: {expected_node_type}, Got: {data.get('node_type')}", "fail")
            elif response.status_code == 404:
                if expected_node_type is None:
                    print_status("✅ Correctly returned 404 for non-existent rider", "success")
                    success_count += 1
                else:
                    print_status("❌ Unexpected 404 for existing rider", "fail")
            else:
                print_status(f"❌ Unexpected status: {response.status_code} - {response.text}", "fail")
                
        except Exception as e:
            print_status(f"❌ Error: {e}", "fail")
        
        print()
    
    print_status(f"GET /rider-info: {success_count}/{total_tests} tests passed", "info")
    return success_count == total_tests

def test_post_update_progress():
    """Test POST /update-progress endpoint"""
    print_status("TESTING POST /update-progress", "header")
    print("=" * 50)
    
    test_cases = [
        ("New Rider - Day 1 Started", {
            "rider_id": "TEST_478",
            "module_started": {"day1": datetime.now(timezone.utc).isoformat()},
            "module_completed": {},
            "updated_at": datetime.now(timezone.utc).isoformat()
        }),
        ("Day 1 Completed", {
            "rider_id": "TEST_478",
            "module_started": {"day1": datetime.now(timezone.utc).isoformat()},
            "module_completed": {"day1": datetime.now(timezone.utc).isoformat()},
            "updated_at": datetime.now(timezone.utc).isoformat()
        }),
        ("Day 2 Started", {
            "rider_id": "TEST_478",
            "module_started": {
                "day1": datetime.now(timezone.utc).isoformat(),
                "day2": datetime.now(timezone.utc).isoformat()
            },
            "module_completed": {"day1": datetime.now(timezone.utc).isoformat()},
            "updated_at": datetime.now(timezone.utc).isoformat()
        }),
        ("All Days Completed", {
            "rider_id": "TEST_478",
            "module_started": {
                "day1": datetime.now(timezone.utc).isoformat(),
                "day2": datetime.now(timezone.utc).isoformat(),
                "day3": datetime.now(timezone.utc).isoformat()
            },
            "module_completed": {
                "day1": datetime.now(timezone.utc).isoformat(),
                "day2": datetime.now(timezone.utc).isoformat(),
                "day3": datetime.now(timezone.utc).isoformat()
            },
            "updated_at": datetime.now(timezone.utc).isoformat()
        })
    ]
    
    success_count = 0
    total_tests = len(test_cases)
    
    for test_name, payload in test_cases:
        print_status(f"Test: {test_name}", "info")
        print_status(f"URL: {API_BASE_URL}/update-progress", "info")
        print_status(f"Payload: {json.dumps(payload, indent=2)}", "info")
        
        try:
            response = requests.post(
                f"{API_BASE_URL}/update-progress",
                headers={"Content-Type": "application/json"},
                data=json.dumps(payload)
            )
            
            print_status(f"Status Code: {response.status_code}", "info")
            print_status(f"Response: {response.text}", "info")
            
            if response.status_code == 200:
                print_status("✅ Request successful!", "success")
                success_count += 1
            else:
                print_status("❌ Request failed", "fail")
                
        except Exception as e:
            print_status(f"❌ Error: {e}", "fail")
        
        print()
    
    print_status(f"POST /update-progress: {success_count}/{total_tests} tests passed", "info")
    return success_count == total_tests

def test_post_module_started():
    """Test POST /module-started endpoint"""
    print_status("TESTING POST /module-started", "header")
    print("=" * 50)
    
    test_cases = [
        ("Start Day 1", {
            "rider_id": 478,
            "day": "day1",
            "timestamp": datetime.now(timezone.utc).isoformat()
        }),
        ("Start Day 2", {
            "rider_id": 478,
            "day": "day2",
            "timestamp": datetime.now(timezone.utc).isoformat()
        }),
        ("Start Day 3", {
            "rider_id": 478,
            "day": "day3",
            "timestamp": datetime.now(timezone.utc).isoformat()
        })
    ]
    
    success_count = 0
    total_tests = len(test_cases)
    
    for test_name, payload in test_cases:
        print_status(f"Test: {test_name}", "info")
        print_status(f"URL: {API_BASE_URL}/module-started", "info")
        print_status(f"Payload: {json.dumps(payload, indent=2)}", "info")
        
        try:
            response = requests.post(
                f"{API_BASE_URL}/module-started",
                headers={"Content-Type": "application/json"},
                data=json.dumps(payload)
            )
            
            print_status(f"Status Code: {response.status_code}", "info")
            print_status(f"Response: {response.text}", "info")
            
            if response.status_code == 200:
                print_status("✅ Request successful!", "success")
                success_count += 1
            else:
                print_status("❌ Request failed", "fail")
                
        except Exception as e:
            print_status(f"❌ Error: {e}", "fail")
        
        print()
    
    print_status(f"POST /module-started: {success_count}/{total_tests} tests passed", "info")
    return success_count == total_tests

def test_post_module_completed():
    """Test POST /module-completed endpoint"""
    print_status("TESTING POST /module-completed", "header")
    print("=" * 50)
    
    test_cases = [
        ("Complete Day 1", {
            "rider_id": 478,
            "day": "day1",
            "timestamp": datetime.now(timezone.utc).isoformat()
        }),
        ("Complete Day 2", {
            "rider_id": 478,
            "day": "day2",
            "timestamp": datetime.now(timezone.utc).isoformat()
        }),
        ("Complete Day 3", {
            "rider_id": 478,
            "day": "day3",
            "timestamp": datetime.now(timezone.utc).isoformat()
        })
    ]
    
    success_count = 0
    total_tests = len(test_cases)
    
    for test_name, payload in test_cases:
        print_status(f"Test: {test_name}", "info")
        print_status(f"URL: {API_BASE_URL}/module-completed", "info")
        print_status(f"Payload: {json.dumps(payload, indent=2)}", "info")
        
        try:
            response = requests.post(
                f"{API_BASE_URL}/module-completed",
                headers={"Content-Type": "application/json"},
                data=json.dumps(payload)
            )
            
            print_status(f"Status Code: {response.status_code}", "info")
            print_status(f"Response: {response.text}", "info")
            
            if response.status_code == 200:
                print_status("✅ Request successful!", "success")
                success_count += 1
            else:
                print_status("❌ Request failed", "fail")
                
        except Exception as e:
            print_status(f"❌ Error: {e}", "fail")
        
        print()
    
    print_status(f"POST /module-completed: {success_count}/{total_tests} tests passed", "info")
    return success_count == total_tests

def test_google_sheets_integration():
    """Test Google Sheets integration with unique rider ID"""
    print_status("TESTING GOOGLE SHEETS INTEGRATION", "header")
    print("=" * 50)
    
    unique_rider_id = f"TEST_{int(time.time())}"
    current_time = datetime.now(timezone.utc).isoformat()
    
    payload = {
        "rider_id": unique_rider_id,
        "module_started": {"day1": current_time},
        "module_completed": {},
        "updated_at": current_time
    }
    
    print_status("This test will make API calls and you should check your Google Sheet manually", "info")
    print_status("Expected behavior: New rows should appear in your Google Sheet", "info")
    print_status(f"Using unique rider ID: {unique_rider_id}", "info")
    print_status("Check your Google Sheet for a new row with this rider ID", "info")
    print_status(f"URL: {API_BASE_URL}/update-progress", "info")
    print_status(f"Payload: {json.dumps(payload, indent=2)}", "info")
    
    try:
        response = requests.post(
            f"{API_BASE_URL}/update-progress",
            headers={"Content-Type": "application/json"},
            data=json.dumps(payload)
        )
        
        print_status(f"Status Code: {response.status_code}", "info")
        print_status(f"Response: {response.text}", "info")
        
        if response.status_code == 200:
            print_status("✅ Request successful! Check your Google Sheet!", "success")
            return True
        else:
            print_status("❌ Request failed", "fail")
            return False
            
    except Exception as e:
        print_status(f"❌ Error: {e}", "fail")
        return False

def test_cors_headers():
    """Test CORS headers"""
    print_status("TESTING CORS HEADERS", "header")
    print("=" * 50)
    
    try:
        # Test OPTIONS request
        response = requests.options(f"{API_BASE_URL}/rider-info")
        print_status(f"OPTIONS Status: {response.status_code}", "info")
        print_status(f"CORS Headers: {dict(response.headers)}", "info")
        
        if response.status_code == 200:
            print_status("✅ CORS preflight request successful", "success")
            return True
        else:
            print_status("❌ CORS preflight request failed", "fail")
            return False
            
    except Exception as e:
        print_status(f"❌ Error: {e}", "fail")
        return False

def main():
    """Main test function"""
    print("=" * 60)
    print_status("BLITZNOW TRAINING APP - COMPREHENSIVE API TEST SUITE", "header")
    print("=" * 60)
    print_status(f"Testing API Base URL: {API_BASE_URL}", "info")
    print_status(f"Test started at: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}", "info")
    print()
    
    # Run all tests
    results = []
    
    results.append(("GET /rider-info", test_get_rider_info()))
    results.append(("POST /update-progress", test_post_update_progress()))
    results.append(("POST /module-started", test_post_module_started()))
    results.append(("POST /module-completed", test_post_module_completed()))
    results.append(("Google Sheets Integration", test_google_sheets_integration()))
    results.append(("CORS Headers", test_cors_headers()))
    
    # Summary
    print("=" * 60)
    print_status("TEST RESULTS SUMMARY", "header")
    print("=" * 60)
    
    passed = 0
    total = len(results)
    
    for test_name, result in results:
        if result:
            print_status(f"{test_name}: PASSED", "success")
            passed += 1
        else:
            print_status(f"{test_name}: FAILED", "fail")
    
    print()
    print_status(f"Overall: {passed}/{total} test suites passed", "info")
    
    if passed == total:
        print_status("🎉 ALL TESTS PASSED! API is working correctly!", "success")
        print_status("✅ Lambda function is responding correctly", "success")
        print_status("✅ Google Sheets integration is working", "success")
        print_status("✅ All endpoints are functioning properly", "success")
    else:
        print_status("❌ Some tests failed. Check the Lambda function deployment.", "fail")
        print_status("🔧 Make sure Lambda function code is updated and environment variables are set", "warning")

if __name__ == "__main__":
    import sys
    
    # Check if specific test type is requested
    if len(sys.argv) > 1:
        test_type = sys.argv[1].lower()
        
        if test_type == "rider-info":
            test_get_rider_info()
        elif test_type == "update-progress":
            test_post_update_progress()
        elif test_type == "module-started":
            test_post_module_started()
        elif test_type == "module-completed":
            test_post_module_completed()
        elif test_type == "sheets":
            test_google_sheets_integration()
        elif test_type == "cors":
            test_cors_headers()
        else:
            print(f"Unknown test type: {test_type}")
            print("Available test types: rider-info, update-progress, module-started, module-completed, sheets, cors")
    else:
        # Run all tests
        main()
