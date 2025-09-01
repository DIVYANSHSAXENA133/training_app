# BlitzNow Training App - Lambda Function Deployment Guide

This guide will help you deploy the BlitzNow Training App Lambda function to AWS.

## 📋 Prerequisites

- AWS CLI configured with appropriate permissions
- Python 3.9+ installed locally
- Access to your read replica database
- Google Sheets credentials file (`blitznow-sheets-credentials.json`)

## 🚀 Quick Deployment

### Step 1: Prepare Deployment Package

```bash
# Run the deployment script
python deploy_lambda.py
```

This will create:
- `blitznow-training-lambda.zip` - Deployment package
- `lambda_config.json` - Configuration file
- Base64 encoded credentials for environment variables

### Step 2: Create Lambda Function

1. **Go to AWS Lambda Console**
   - Navigate to: https://console.aws.amazon.com/lambda/

2. **Create Function**
   - Click "Create function"
   - Choose "Author from scratch"
   - Function name: `blitznow-training-app`
   - Runtime: `Python 3.9`
   - Architecture: `x86_64`

3. **Upload Code**
   - Upload the `blitznow-training-lambda.zip` file
   - Handler: `lambda_function.lambda_handler`

### Step 3: Configure Environment Variables

Set these environment variables in Lambda:

```bash
GOOGLE_SHEETS_CREDENTIALS=<base64_encoded_credentials>
DB_HOST=your-read-replica-endpoint.amazonaws.com
DB_NAME=your_database_name
DB_USER=your_username
DB_PASSWORD=your_password
DB_PORT=5432
```

### Step 4: Set Function Configuration

- **Timeout**: 30 seconds
- **Memory**: 256 MB
- **Execution Role**: Create new role with basic Lambda permissions

### Step 5: Create API Gateway

1. **Create API Gateway**
   - Go to API Gateway console
   - Create new REST API
   - Name: `blitznow-training-api`

2. **Create Resources and Methods**
   ```
   POST /rider-info
   POST /update-progress
   POST /module-started
   POST /module-completed
   ```

3. **Configure CORS**
   ```json
   {
     "Access-Control-Allow-Origin": "*",
     "Access-Control-Allow-Headers": "Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token",
     "Access-Control-Allow-Methods": "POST,OPTIONS"
   }
   ```

4. **Deploy API**
   - Create deployment stage (e.g., `prod`)
   - Note the API Gateway URL

## 🔧 Manual Deployment Steps

### Step 1: Create IAM Role

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
```

### Step 2: Attach Policies

Attach these policies to your Lambda execution role:
- `AWSLambdaBasicExecutionRole`
- `AWSLambdaVPCAccessExecutionRole` (if using VPC)

### Step 3: VPC Configuration (if needed)

If your database is in a VPC:
- Configure VPC settings in Lambda
- Set up security groups
- Configure subnets

## 🧪 Testing the Lambda Function

### Test Rider Info Endpoint

```bash
curl -X POST https://your-api-gateway-url.amazonaws.com/prod/rider-info \
  -H "Content-Type: application/json" \
  -d '{"rider_id": "TEST_RIDER_123"}'
```

### Test Module Started Endpoint

```bash
curl -X POST https://your-api-gateway-url.amazonaws.com/prod/module-started \
  -H "Content-Type: application/json" \
  -d '{
    "rider_id": "TEST_RIDER_123",
    "day": "day1",
    "timestamp": "2024-01-15T10:00:00Z"
  }'
```

### Test Module Completed Endpoint

```bash
curl -X POST https://your-api-gateway-url.amazonaws.com/prod/module-completed \
  -H "Content-Type: application/json" \
  -d '{
    "rider_id": "TEST_RIDER_123",
    "day": "day1",
    "timestamp": "2024-01-15T11:30:00Z"
  }'
```

## 📊 Lambda Function Endpoints

### 1. `/rider-info` - Get Rider Information

**Request:**
```json
{
  "rider_id": "RIDER_123"
}
```

**Response:**
```json
{
  "rider_id": "RIDER_123",
  "node_type": "lm_hub",
  "rider_age": 1
}
```

### 2. `/module-started` - Mark Module as Started

**Request:**
```json
{
  "rider_id": "RIDER_123",
  "day": "day1",
  "timestamp": "2024-01-15T10:00:00Z"
}
```

**Response:**
```json
{
  "success": true,
  "message": "Module day1 started successfully"
}
```

### 3. `/module-completed` - Mark Module as Completed

**Request:**
```json
{
  "rider_id": "RIDER_123",
  "day": "day1",
  "timestamp": "2024-01-15T11:30:00Z"
}
```

**Response:**
```json
{
  "success": true,
  "message": "Module day1 completed successfully"
}
```

### 4. `/update-progress` - Update Training Progress

**Request:**
```json
{
  "rider_id": "RIDER_123",
  "module_started": {
    "day1": "2024-01-15T10:00:00Z"
  },
  "module_completed": {
    "day1": "2024-01-15T11:30:00Z"
  }
}
```

**Response:**
```json
{
  "success": true,
  "message": "Progress updated successfully"
}
```

## 🔒 Security Configuration

### Database Security
- Use VPC for database access
- Configure security groups
- Use IAM database authentication if possible

### API Security
- Enable API Gateway throttling
- Set up rate limiting
- Consider API keys for production

### Google Sheets Security
- Store credentials securely in environment variables
- Use least privilege access
- Regularly rotate service account keys

## 📈 Monitoring and Logging

### CloudWatch Logs
- Monitor Lambda execution logs
- Set up log retention policies
- Create log groups for different environments

### CloudWatch Metrics
- Monitor invocation count
- Track error rates
- Monitor duration and memory usage

### Alarms
- Set up alarms for error rates
- Monitor function duration
- Alert on high invocation counts

## 🚨 Troubleshooting

### Common Issues

1. **Database Connection Errors**
   - Check VPC configuration
   - Verify security groups
   - Test database connectivity

2. **Google Sheets API Errors**
   - Verify credentials format
   - Check sheet sharing permissions
   - Ensure API is enabled

3. **CORS Errors**
   - Verify API Gateway CORS configuration
   - Check preflight OPTIONS handling

4. **Timeout Errors**
   - Increase Lambda timeout
   - Optimize database queries
   - Check network connectivity

### Debug Steps

1. **Check CloudWatch Logs**
   - Review execution logs
   - Look for error messages
   - Check environment variables

2. **Test Individual Components**
   - Test database connectivity
   - Test Google Sheets access
   - Test API Gateway endpoints

3. **Verify Permissions**
   - Check IAM roles
   - Verify resource access
   - Test with minimal permissions

## 🔄 Updates and Maintenance

### Updating the Function
1. Make code changes
2. Run `python deploy_lambda.py`
3. Upload new ZIP file to Lambda
4. Test the updated function

### Environment Variables
- Update environment variables in Lambda console
- Restart function if needed
- Test with new configuration

### Dependencies
- Update `requirements.txt`
- Rebuild deployment package
- Test with new dependencies

## 📞 Support

For issues with this deployment:
1. Check CloudWatch logs
2. Review this documentation
3. Test individual components
4. Contact the development team

---

**Ready to deploy your BlitzNow Training App Lambda function!** 🚀
