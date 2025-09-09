# API Gateway Setup Guide for BlitzNow Training App

## Current Status
Based on the diagnostic results, only 2 endpoints are currently working:
- ✅ `/module-started` (POST)
- ✅ `/module-completed` (POST)

## Missing Endpoints
The following endpoints need to be configured in API Gateway:
- ❌ `/rider-info` (GET)
- ❌ `/training-progress` (GET)
- ❌ `/get-tutorials` (GET)
- ❌ `/tutorial-state` (POST)
- ❌ `/tutorials` (POST)
- ❌ `/day-hub-mappings` (POST)
- ❌ `/update-progress` (POST)

## API Gateway Configuration Steps

### 1. Access API Gateway Console
1. Go to AWS API Gateway Console
2. Find your API: `tlffrtmssa` (or similar)
3. Click on the API to open it

### 2. Configure Missing Routes

#### Route: `/rider-info`
- **Method**: GET
- **Integration Type**: Lambda Function
- **Lambda Function**: `blitznow-training-lambda` (or your function name)
- **Use Lambda Proxy Integration**: ✅ Yes
- **Query String Parameters**: `rider_id` (optional)

#### Route: `/training-progress`
- **Method**: GET
- **Integration Type**: Lambda Function
- **Lambda Function**: `blitznow-training-lambda`
- **Use Lambda Proxy Integration**: ✅ Yes
- **Query String Parameters**: `rider_id` (optional)

#### Route: `/get-tutorials`
- **Method**: GET
- **Integration Type**: Lambda Function
- **Lambda Function**: `blitznow-training-lambda`
- **Use Lambda Proxy Integration**: ✅ Yes
- **Query String Parameters**: `rider_id` (optional)

#### Route: `/tutorial-state`
- **Method**: POST
- **Integration Type**: Lambda Function
- **Lambda Function**: `blitznow-training-lambda`
- **Use Lambda Proxy Integration**: ✅ Yes

#### Route: `/tutorials`
- **Method**: POST
- **Integration Type**: Lambda Function
- **Lambda Function**: `blitznow-training-lambda`
- **Use Lambda Proxy Integration**: ✅ Yes

#### Route: `/day-hub-mappings`
- **Method**: POST
- **Integration Type**: Lambda Function
- **Lambda Function**: `blitznow-training-lambda`
- **Use Lambda Proxy Integration**: ✅ Yes

#### Route: `/update-progress`
- **Method**: POST
- **Integration Type**: Lambda Function
- **Lambda Function**: `blitznow-training-lambda`
- **Use Lambda Proxy Integration**: ✅ Yes

### 3. Enable CORS
For each route, enable CORS:
1. Select the route
2. Click "Actions" → "Enable CORS"
3. Use these settings:
   - **Access-Control-Allow-Origin**: `*`
   - **Access-Control-Allow-Headers**: `Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token`
   - **Access-Control-Allow-Methods**: `GET,POST,OPTIONS`

### 4. Deploy API
1. Click "Actions" → "Deploy API"
2. Select the deployment stage (usually `prod` or `default`)
3. Click "Deploy"

### 5. Test Configuration
After deployment, test each endpoint:
```bash
# Test rider info
curl "https://tlffrtmssa.execute-api.us-east-2.amazonaws.com/rider-info?rider_id=12345"

# Test training progress
curl "https://tlffrtmssa.execute-api.us-east-2.amazonaws.com/training-progress?rider_id=12345"

# Test get tutorials
curl "https://tlffrtmssa.execute-api.us-east-2.amazonaws.com/get-tutorials?rider_id=12345"
```

## Lambda Function Permissions

Ensure your Lambda function has the necessary permissions:

### IAM Role Permissions
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "arn:aws:logs:*:*:*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "rds:DescribeDBInstances",
                "rds:Connect"
            ],
            "Resource": "*"
        }
    ]
}
```

### API Gateway Invoke Permission
The Lambda function needs permission to be invoked by API Gateway:
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "apigateway.amazonaws.com"
            },
            "Action": "lambda:InvokeFunction",
            "Resource": "arn:aws:lambda:us-east-2:*:function:blitznow-training-lambda"
        }
    ]
}
```

## Troubleshooting

### Common Issues

1. **404 Not Found**
   - Check if the route is properly configured in API Gateway
   - Verify the deployment stage is correct
   - Ensure the Lambda function is connected

2. **500 Internal Server Error**
   - Check CloudWatch logs for the Lambda function
   - Verify environment variables are set correctly
   - Check database connectivity

3. **CORS Issues**
   - Ensure CORS is enabled for all routes
   - Check the CORS configuration matches the request headers

4. **Lambda Timeout**
   - Increase the Lambda timeout in the function configuration
   - Check database query performance

### Testing Commands

```bash
# Run comprehensive test
python3 test_all_apis_comprehensive.py

# Run production test
python3 test_production_apis.py

# Run working APIs test
python3 test_working_apis.py

# Run diagnostic
python3 diagnose_api_gateway.py
```

## Next Steps

1. Configure all missing routes in API Gateway
2. Deploy the API
3. Test all endpoints
4. Update the Flutter app to use the working endpoints
5. Monitor CloudWatch logs for any issues

## Support

If you encounter issues:
1. Check CloudWatch logs for detailed error messages
2. Verify the Lambda function is working correctly
3. Test with the provided test scripts
4. Check API Gateway configuration matches the Lambda function paths
