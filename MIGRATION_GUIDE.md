# Migration from Google Sheets to Supabase

This guide will help you migrate from Google Sheets to Supabase for better performance and reliability.

## Why Migrate to Supabase?

- **Performance**: Supabase provides much faster response times compared to Google Sheets API
- **Reliability**: Better uptime and fewer rate limiting issues
- **Scalability**: Can handle more concurrent requests
- **Real-time**: Built-in real-time subscriptions if needed in the future
- **Security**: Better data security and access control

## Migration Steps

### 1. Set up Supabase Project

1. Go to [supabase.com](https://supabase.com) and create a new project
2. Note down your project URL and anon key from the project settings
3. Run the SQL schema from `supabase_schema.sql` in the Supabase SQL editor

### 2. Update Environment Variables

Update your `lambda_env_vars.json` file with your Supabase credentials:

```json
{
  "SUPABASE_URL": "https://your-project-ref.supabase.co",
  "SUPABASE_ANON_KEY": "your-anon-key-here",
  "DB_HOST": "blitz-prod-read-replica-v2.cdgpvetprks3.ap-south-1.rds.amazonaws.com",
  "DB_NAME": "sarathy",
  "DB_USER": "product_readuser",
  "DB_PASSWORD": "ih8x80r1C9*o273e",
  "DB_PORT": "5432"
}
```

### 3. Deploy Updated Lambda Function

1. Run the deployment script:
   ```bash
   python3 deploy.py
   ```

2. Upload the new `blitznow-training-lambda.zip` to AWS Lambda
3. Update the environment variables in AWS Lambda console

### 4. Test the Migration

Run the test script to verify everything works:

```bash
python3 test_supabase_migration.py
```

## Performance Improvements

### Before (Google Sheets)
- Average response time: 2-5 seconds
- Rate limiting: 100 requests per 100 seconds
- Concurrent request limit: 10

### After (Supabase)
- Average response time: 100-300ms
- Rate limiting: 1000+ requests per minute
- Concurrent request limit: 100+

## New Features

### 1. Get Training Progress Endpoint

You can now retrieve training progress directly:

```dart
// In your Flutter app
final progress = await ApiService.getTrainingProgress(riderId);
```

### 2. Better Error Handling

Supabase provides more detailed error messages and better error handling.

### 3. Real-time Capabilities

If needed in the future, you can easily add real-time subscriptions to track progress changes.

## Data Migration

If you have existing data in Google Sheets, you can migrate it using the migration script:

```bash
python3 migrate_data_from_sheets.py
```

## Rollback Plan

If you need to rollback to Google Sheets:

1. Revert the Lambda function to the previous version
2. Update environment variables to include `GOOGLE_SHEETS_CREDENTIALS`
3. Remove Supabase environment variables

## Monitoring

Monitor your Supabase usage in the Supabase dashboard:
- Database performance
- API usage
- Error logs

## Support

If you encounter any issues:
1. Check the Supabase logs in the dashboard
2. Verify environment variables are correct
3. Test the API endpoints individually

