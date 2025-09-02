# 🚀 BlitzNow Training App - Complete Deployment Guide

## ✅ What's Ready

- ✅ **Flutter Web App**: Built and tested
- ✅ **Lambda Function**: Code ready with GET requests for rider-info
- ✅ **Database**: Production credentials configured
- ✅ **Google Sheets**: API integration ready
- ✅ **Deployment Package**: `blitznow-training-lambda.zip` created

## 📋 Deployment Steps

### Step 1: Deploy Lambda Function

1. **Go to AWS Lambda Console**
   - Navigate to: https://console.aws.amazon.com/lambda/
   - Sign in to your AWS account

2. **Create Lambda Function**
   - Click "Create function"
   - Choose "Author from scratch"
   - Function name: `blitznow-training-app`
   - Runtime: `Python 3.9`
   - Architecture: `x86_64`
   - Click "Create function"

3. **Upload Code**
   - In the "Code" tab, click "Upload from" → ".zip file"
   - Upload the `blitznow-training-lambda.zip` file
   - Handler: `lambda_function.lambda_handler`

4. **Set Environment Variables**
   - Go to "Configuration" → "Environment variables"
   - Add these variables:

   ```
   GOOGLE_SHEETS_CREDENTIALS=ewogICJ0eXBlIjogInNlcnZpY2VfYWNjb3VudCIsCiAgInByb2plY3RfaWQiOiAiYmxpdHpub3ctdHJhaW5pbmctYXBwIiwKICAi...
   DB_HOST=blitz-prod-read-replica-v2.cdgpvetprks3.ap-south-1.rds.amazonaws.com
   DB_NAME=sarathy
   DB_USER=product_readuser
   DB_PASSWORD=ih8x80r1C9*o273e
   DB_PORT=5432
   ```

5. **Configure Function Settings**
   - Timeout: 30 seconds
   - Memory: 256 MB
   - Click "Save"

### Step 2: Create API Gateway

1. **Create REST API**
   - Go to API Gateway console
   - Click "Create API"
   - Choose "REST API" → "Build"
   - API name: `blitznow-training-api`
   - Description: `API for BlitzNow Training App`
   - Click "Create API"

2. **Create Resources and Methods**

   **For `/rider-info` (GET):**
   - Create resource: `rider-info`
   - Create method: `GET`
   - Integration type: Lambda Function
   - Lambda Function: `blitznow-training-app`
   - Enable CORS: Yes

   **For `/update-progress` (POST):**
   - Create resource: `update-progress`
   - Create method: `POST`
   - Integration type: Lambda Function
   - Lambda Function: `blitznow-training-app`
   - Enable CORS: Yes

   **For `/module-started` (POST):**
   - Create resource: `module-started`
   - Create method: `POST`
   - Integration type: Lambda Function
   - Lambda Function: `blitznow-training-app`
   - Enable CORS: Yes

   **For `/module-completed` (POST):**
   - Create resource: `module-completed`
   - Create method: `POST`
   - Integration type: Lambda Function
   - Lambda Function: `blitznow-training-app`
   - Enable CORS: Yes

3. **Deploy API**
   - Click "Actions" → "Deploy API"
   - Deployment stage: `prod`
   - Click "Deploy"

4. **Get API Endpoint URL**
   - Copy the "Invoke URL" (e.g., `https://abc123.execute-api.us-east-1.amazonaws.com/prod`)

### Step 3: Update Flutter App

1. **Update API Endpoint**
   - Open `lib/services/api_service.dart`
   - Replace `YOUR_LAMBDA_API_ENDPOINT` with your actual API Gateway URL
   - Example: `static const String baseUrl = 'https://abc123.execute-api.us-east-1.amazonaws.com/prod';`

2. **Rebuild Flutter App**
   ```bash
   flutter build web --release
   ```

### Step 4: Test Integration

1. **Test Lambda Function**
   - Go to Lambda console
   - Click "Test"
   - Create test event for GET request:
   ```json
   {
     "httpMethod": "GET",
     "path": "/rider-info",
     "queryStringParameters": {
       "rider_id": "TEST_RIDER_001"
     }
   }
   ```

2. **Test API Gateway**
   - Use the API Gateway URL to test endpoints
   - Example: `GET https://your-api-url/prod/rider-info?rider_id=TEST_RIDER_001`

3. **Test Flutter App**
   - Deploy the updated Flutter app
   - Test with real rider IDs from your database

## 🔧 API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/rider-info?rider_id=<id>` | Get rider information |
| POST | `/update-progress` | Update training progress |
| POST | `/module-started` | Mark module as started |
| POST | `/module-completed` | Mark module as completed |

## 🧪 Test Rider IDs

You can test with these sample rider IDs:
- `TEST_RIDER_001` - LM Hub Day 1
- `TEST_RIDER_002` - Quick Hub Day 2
- `TEST_RIDER_003` - LM Hub Day 3

## 🚨 Troubleshooting

### Common Issues:

1. **CORS Errors**
   - Ensure CORS is enabled on all API Gateway methods
   - Check that `Access-Control-Allow-Origin: *` is set

2. **Database Connection Issues**
   - Verify environment variables are set correctly
   - Check that Lambda has VPC access to RDS (if needed)

3. **Google Sheets Access Issues**
   - Verify the service account has access to the sheet
   - Check that the sheet ID is correct

4. **Lambda Timeout**
   - Increase timeout to 30 seconds
   - Check database query performance

## 📱 Production Deployment

1. **Deploy Flutter App**
   - Use AWS S3 + CloudFront for hosting
   - Or use any web hosting service

2. **Monitor Lambda**
   - Set up CloudWatch alarms
   - Monitor error rates and performance

3. **Security**
   - Consider using AWS Secrets Manager for credentials
   - Implement proper IAM roles and policies

## ✅ Success Checklist

- [ ] Lambda function deployed and tested
- [ ] API Gateway created with all endpoints
- [ ] Environment variables configured
- [ ] Database connection working
- [ ] Google Sheets integration working
- [ ] Flutter app updated with API endpoint
- [ ] End-to-end testing completed

Your BlitzNow Training App is now ready for production! 🎉
