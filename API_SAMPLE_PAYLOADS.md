# API Sample Payloads - BlitzNow Training App

This document contains sample requests and responses for all APIs in the BlitzNow Training App.

## Base URL
```
https://tlffrtmssa.execute-api.us-east-2.amazonaws.com
```

## API Endpoints

### 1. Get Rider Info
**Endpoint:** `GET /rider-info`

#### Request
```bash
curl -X GET 'https://tlffrtmssa.execute-api.us-east-2.amazonaws.com/rider-info?rider_id=12345' \
  -H 'Content-Type: application/json'
```

#### Query Parameters
- `rider_id` (required): The rider's ID

#### Success Response (200)
```json
{
  "rider_id": "12345",
  "node_type": "central_hub",
  "rider_age": 1
}
```

#### Error Response (404)
```json
{
  "error": "Rider not found"
}
```

---

### 2. Get Training Progress
**Endpoint:** `GET /training-progress`

#### Request
```bash
curl -X GET 'https://tlffrtmssa.execute-api.us-east-2.amazonaws.com/training-progress?rider_id=12345' \
  -H 'Content-Type: application/json'
```

#### Query Parameters
- `rider_id` (required): The rider's ID

#### Success Response (200)
```json
{
  "id": 1,
  "rider_id": "12345",
  "tutorial_state": {
    "delivery_flow": {
      "id": "delivery_flow",
      "isDone": false
    },
    "pickup_flow": {
      "id": "pickup_flow",
      "isDone": true
    }
  },
  "module_started_day1": "2024-01-15T09:00:00Z",
  "module_started_day2": null,
  "module_started_day3": null,
  "module_completed_day1": null,
  "module_completed_day2": null,
  "module_completed_day3": null,
  "created_at": "2024-01-15T08:45:00Z",
  "updated_at": "2024-01-15T08:45:00Z"
}
```

#### Error Response (404)
```json
{
  "error": "Training progress not found"
}
```

---

### 3. Get Tutorials (Main API)
**Endpoint:** `GET /get-tutorials`

#### Request
```bash
curl -X GET 'https://tlffrtmssa.execute-api.us-east-2.amazonaws.com/get-tutorials?rider_id=12345' \
  -H 'Content-Type: application/json'
```

#### Query Parameters
- `rider_id` (required): The rider's ID

#### Success Response (200)
```json
{
  "message": "Success",
  "data": {
    "rider_age": 1,
    "tutorials": [
      {
        "id": "delivery_flow",
        "title": "Learn how to deliver",
        "subtitle": "The tutorial shows how to deliver an order",
        "isDone": false
      },
      {
        "id": "pickup_flow",
        "title": "Learn how to pickup",
        "subtitle": "The tutorial shows how to pickup an order",
        "isDone": true
      }
    ]
  }
}
```

#### Error Response (400)
```json
{
  "message": "Something went wrong!",
  "data": null,
  "error": "Rider ID is required"
}
```

---

### 4. Update Tutorial State
**Endpoint:** `POST /tutorial-state`

#### Request
```bash
curl -X POST 'https://tlffrtmssa.execute-api.us-east-2.amazonaws.com/tutorial-state' \
  -H 'Content-Type: application/json' \
  -d '{
    "rider_id": "12345",
    "tutorial_id": "delivery_flow",
    "isDone": true,
    "action": "update"
  }'
```

#### Request Body
```json
{
  "rider_id": "12345",
  "tutorial_id": "delivery_flow",
  "isDone": true,
  "action": "update"
}
```

#### Success Response (200)
```json
{
  "message": "Success",
  "data": {
    "updated": true
  }
}
```

#### Error Response (400)
```json
{
  "message": "Something went wrong!",
  "data": null,
  "error": "Rider ID, tutorial ID, and isDone status are required"
}
```

---

### 5. Tutorial Management
**Endpoint:** `POST /tutorials`

#### Create Tutorial Request
```bash
curl -X POST 'https://tlffrtmssa.execute-api.us-east-2.amazonaws.com/tutorials' \
  -H 'Content-Type: application/json' \
  -d '{
    "action": "create",
    "id": "delivery_flow",
    "title": "Learn how to deliver",
    "subtitle": "The tutorial shows how to deliver an order",
    "description": "Complete guide to delivery process"
  }'
```

#### Get All Tutorials Request
```bash
curl -X POST 'https://tlffrtmssa.execute-api.us-east-2.amazonaws.com/tutorials' \
  -H 'Content-Type: application/json' \
  -d '{
    "action": "get"
  }'
```

#### Get Specific Tutorial Request
```bash
curl -X POST 'https://tlffrtmssa.execute-api.us-east-2.amazonaws.com/tutorials' \
  -H 'Content-Type: application/json' \
  -d '{
    "action": "get",
    "tutorial_id": "delivery_flow"
  }'
```

#### Success Response (200)
```json
{
  "message": "Success",
  "data": {
    "tutorials": [
      {
        "id": "delivery_flow",
        "title": "Learn how to deliver",
        "subtitle": "The tutorial shows how to deliver an order",
        "description": "Complete guide to delivery process",
        "created_at": "2024-01-01T00:00:00Z",
        "updated_at": "2024-01-01T00:00:00Z"
      }
    ]
  }
}
```

---

### 6. Module Started
**Endpoint:** `POST /module-started`

#### Request
```bash
curl -X POST 'https://tlffrtmssa.execute-api.us-east-2.amazonaws.com/module-started' \
  -H 'Content-Type: application/json' \
  -d '{
    "rider_id": "12345",
    "day": "day1",
    "timestamp": "2024-01-15T09:00:00Z"
  }'
```

#### Request Body
```json
{
  "rider_id": "12345",
  "day": "day1",
  "timestamp": "2024-01-15T09:00:00Z"
}
```

#### Success Response (200)
```json
{
  "success": true,
  "message": "Module day1 started successfully"
}
```

#### Error Response (400)
```json
{
  "error": "Rider ID and day are required"
}
```

---

### 7. Module Completed
**Endpoint:** `POST /module-completed`

#### Request
```bash
curl -X POST 'https://tlffrtmssa.execute-api.us-east-2.amazonaws.com/module-completed' \
  -H 'Content-Type: application/json' \
  -d '{
    "rider_id": "12345",
    "day": "day1",
    "timestamp": "2024-01-15T10:30:00Z"
  }'
```

#### Request Body
```json
{
  "rider_id": "12345",
  "day": "day1",
  "timestamp": "2024-01-15T10:30:00Z"
}
```

#### Success Response (200)
```json
{
  "success": true,
  "message": "Module day1 completed successfully"
}
```

#### Error Response (400)
```json
{
  "error": "Rider ID and day are required"
}
```

---

### 8. Update Progress
**Endpoint:** `POST /update-progress`

#### Request
```bash
curl -X POST 'https://tlffrtmssa.execute-api.us-east-2.amazonaws.com/update-progress' \
  -H 'Content-Type: application/json' \
  -d '{
    "rider_id": "12345",
    "module_started": {
      "day2": "2024-01-16T09:00:00Z"
    },
    "module_completed": {
      "day1": "2024-01-15T10:30:00Z"
    }
  }'
```

#### Request Body
```json
{
  "rider_id": "12345",
  "module_started": {
    "day2": "2024-01-16T09:00:00Z"
  },
  "module_completed": {
    "day1": "2024-01-15T10:30:00Z"
  }
}
```

#### Success Response (200)
```json
{
  "success": true,
  "message": "Progress updated successfully"
}
```

#### Error Response (400)
```json
{
  "error": "Rider ID is required"
}
```

---

### 9. Day-Hub Mappings
**Endpoint:** `POST /day-hub-mappings`

#### Create Mapping Request
```bash
curl -X POST 'https://tlffrtmssa.execute-api.us-east-2.amazonaws.com/day-hub-mappings' \
  -H 'Content-Type: application/json' \
  -d '{
    "action": "create",
    "day": 1,
    "hub_type": "lm_hub",
    "tutorial_ids": ["delivery_flow", "pickup_flow", "cod_flow"]
  }'
```

#### Get Mapping Request
```bash
curl -X POST 'https://tlffrtmssa.execute-api.us-east-2.amazonaws.com/day-hub-mappings' \
  -H 'Content-Type: application/json' \
  -d '{
    "action": "get",
    "day": 1,
    "hub_type": "lm_hub"
  }'
```

#### Get All Mappings Request
```bash
curl -X POST 'https://tlffrtmssa.execute-api.us-east-2.amazonaws.com/day-hub-mappings' \
  -H 'Content-Type: application/json' \
  -d '{
    "action": "get"
  }'
```

#### Success Response (200)
```json
{
  "message": "Success",
  "data": {
    "mappings": [
      {
        "id": 1,
        "day": 1,
        "hub_type": "lm_hub",
        "tutorial_id": "delivery_flow",
        "order_index": 0
      },
      {
        "id": 2,
        "day": 1,
        "hub_type": "lm_hub",
        "tutorial_id": "pickup_flow",
        "order_index": 1
      }
    ]
  }
}
```

---

## Common Error Responses

### 400 Bad Request
```json
{
  "error": "Bad Request - Missing or invalid parameters"
}
```

### 404 Not Found
```json
{
  "error": "Not Found - Resource not found"
}
```

### 500 Internal Server Error
```json
{
  "error": "Internal Server Error - Server encountered an error"
}
```

## Testing Status

### ✅ Working Endpoints
- `/module-started` (POST)
- `/module-completed` (POST)

### ❌ Missing Endpoints (Need API Gateway Configuration)
- `/rider-info` (GET)
- `/training-progress` (GET)
- `/get-tutorials` (GET)
- `/tutorial-state` (POST)
- `/tutorials` (POST)
- `/day-hub-mappings` (POST)
- `/update-progress` (POST)

## Testing Scripts

Use these scripts to test the APIs:

```bash
# Test working endpoints
python3 test_working_apis.py

# Quick test all endpoints
python3 quick_test_production.py

# Comprehensive testing
python3 test_all_apis_comprehensive.py

# API Gateway diagnostic
python3 diagnose_api_gateway.py

# Run all tests
python3 run_all_tests.py
```

## Flutter Integration

### Dart/Flutter Example
```dart
// Get rider info
final response = await http.get(
  Uri.parse('https://tlffrtmssa.execute-api.us-east-2.amazonaws.com/rider-info?rider_id=12345'),
  headers: {'Content-Type': 'application/json'},
);

// Update tutorial state
final response = await http.post(
  Uri.parse('https://tlffrtmssa.execute-api.us-east-2.amazonaws.com/tutorial-state'),
  headers: {'Content-Type': 'application/json'},
  body: jsonEncode({
    'rider_id': '12345',
    'tutorial_id': 'delivery_flow',
    'isDone': true,
    'action': 'update',
  }),
);
```

## Notes

1. **CORS**: All endpoints support CORS with `Access-Control-Allow-Origin: *`
2. **Content-Type**: All requests should use `application/json`
3. **Timestamps**: Use ISO 8601 format (e.g., `2024-01-15T09:00:00Z`)
4. **Rider ID**: Can be string or integer
5. **Days**: Use `day1`, `day2`, `day3` for module endpoints
6. **Hub Types**: Use `lm_hub` or `quick_hub` for mappings
