#!/usr/bin/env python3
"""
Test script to verify that duplicate entries are not created for the same rider_id.
This script will test the updated Lambda function to ensure it updates existing rows
instead of creating new ones.
"""

import requests
import json
import time
from datetime import datetime

# Replace with your actual Lambda API endpoint
LAMBDA_ENDPOINT = "https://YOUR_LAMBDA_API_ENDPOINT"

def test_rider_info(rider_id):
    """Test getting rider info."""
    print(f"\n🔍 Testing rider info for ID: {rider_id}")
    
    url = f"{LAMBDA_ENDPOINT}/rider-info"
    params = {"rider_id": rider_id}
    
    try:
        response = requests.get(url, params=params)
        print(f"Status: {response.status_code}")
        
        if response.status_code == 200:
            data = response.json()
            print(f"✅ Rider found: {data}")
            return data
        else:
            print(f"❌ Error: {response.text}")
            return None
    except Exception as e:
        print(f"❌ Exception: {e}")
        return None

def test_update_progress(rider_id, module_started=None, module_completed=None):
    """Test updating training progress."""
    print(f"\n📝 Testing progress update for rider: {rider_id}")
    
    url = f"{LAMBDA_ENDPOINT}/update-progress"
    
    payload = {
        "rider_id": rider_id,
        "module_started": module_started or {},
        "module_completed": module_completed or {},
        "updated_at": datetime.now().isoformat()
    }
    
    print(f"Payload: {json.dumps(payload, indent=2)}")
    
    try:
        response = requests.post(url, json=payload)
        print(f"Status: {response.status_code}")
        
        if response.status_code == 200:
            data = response.json()
            print(f"✅ Progress updated: {data}")
            return True
        else:
            print(f"❌ Error: {response.text}")
            return False
    except Exception as e:
        print(f"❌ Exception: {e}")
        return False

def main():
    """Main test function."""
    print("🧪 Testing Duplicate Entry Fix")
    print("=" * 50)
    
    test_rider_id = "478"  # Use the same rider ID that was creating duplicates
    
    # Test 1: Get rider info
    rider_info = test_rider_info(test_rider_id)
    if not rider_info:
        print("❌ Cannot proceed without rider info")
        return
    
    # Test 2: First update - should create new row
    print(f"\n🔄 Test 1: First update (should create new row)")
    success1 = test_update_progress(
        test_rider_id,
        module_started={"day1": datetime.now().isoformat()}
    )
    
    if success1:
        print("✅ First update successful")
    else:
        print("❌ First update failed")
        return
    
    # Wait a moment
    time.sleep(2)
    
    # Test 3: Second update - should update existing row
    print(f"\n🔄 Test 2: Second update (should update existing row)")
    success2 = test_update_progress(
        test_rider_id,
        module_started={"day1": datetime.now().isoformat()},
        module_completed={"day1": datetime.now().isoformat()}
    )
    
    if success2:
        print("✅ Second update successful")
    else:
        print("❌ Second update failed")
        return
    
    # Wait a moment
    time.sleep(2)
    
    # Test 4: Third update - should still update existing row
    print(f"\n🔄 Test 3: Third update (should update existing row)")
    success3 = test_update_progress(
        test_rider_id,
        module_started={"day2": datetime.now().isoformat()}
    )
    
    if success3:
        print("✅ Third update successful")
    else:
        print("❌ Third update failed")
        return
    
    print(f"\n🎉 All tests completed!")
    print(f"📊 Check your Google Sheet to verify:")
    print(f"   - Only ONE row exists for rider_id {test_rider_id}")
    print(f"   - The row contains all the updates (day1 started, day1 completed, day2 started)")
    print(f"   - updated_at timestamp reflects the latest update")

if __name__ == "__main__":
    main()
