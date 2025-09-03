# BlitzNow Training App

A Flutter web application for training BlitzNow delivery partners with AWS Lambda backend integration.

## 🚀 Quick Start

### 1. Deploy Lambda Function
```bash
python3 deploy.py
```

### 2. Test APIs
```bash
python3 test_apis.py
```

### 3. Run Flutter App
```bash
flutter run -d web-server --web-port 8080
```

## 📁 Project Structure

```
├── lib/                          # Flutter app source code
│   ├── config/                   # App configuration
│   ├── models/                   # Data models
│   ├── providers/                # State management
│   ├── screens/                  # UI screens
│   ├── services/                 # API services
│   └── widgets/                  # Reusable widgets
├── lambda_function.py            # AWS Lambda function
├── requirements.txt              # Python dependencies
├── deploy.py                     # Deployment script
├── test_apis.py                  # API test suite
└── blitznow-sheets-credentials.json  # Google Sheets credentials
```

## 🔧 API Endpoints

- **GET** `/rider-info?rider_id={id}` - Get rider information
- **POST** `/update-progress` - Update training progress
- **POST** `/module-started` - Mark module as started
- **POST** `/module-completed` - Mark module as completed

## 🧪 Testing

### Run All Tests
```bash
python3 test_apis.py
```

### Run Specific Tests
```bash
python3 test_apis.py rider-info
python3 test_apis.py update-progress
python3 test_apis.py module-started
python3 test_apis.py module-completed
python3 test_apis.py sheets
python3 test_apis.py cors
```

## 📋 Environment Variables

Required for Lambda function:
- `GOOGLE_SHEETS_CREDENTIALS` - Raw JSON string (not base64)
- `DB_HOST` - Database host
- `DB_NAME` - Database name
- `DB_USER` - Database user
- `DB_PASSWORD` - Database password
- `DB_PORT` - Database port

## 🎯 Features

- ✅ Rider information retrieval from database
- ✅ Training progress tracking in Google Sheets
- ✅ Module start/completion tracking
- ✅ CORS support for web app
- ✅ Comprehensive API testing
- ✅ Mobile-optimized Flutter web app

## 🔍 Troubleshooting

### Common Issues

1. **404 "Endpoint not found"**
   - Lambda function code not updated
   - API Gateway not configured

2. **500 Internal Server Error**
   - Check CloudWatch logs
   - Verify environment variables
   - Check Google Sheets credentials

3. **CORS errors**
   - Enable CORS on API Gateway
   - Check CORS headers in Lambda response

### Debug Commands
```bash
# Test specific endpoint
curl "https://tlffrtmssa.execute-api.us-east-2.amazonaws.com/rider-info?rider_id=478"

# Check Lambda logs
aws logs describe-log-groups --log-group-name-prefix "/aws/lambda/blitznow"
```

## 📞 Support

For issues or questions, check the CloudWatch logs for detailed error messages.