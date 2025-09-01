#!/usr/bin/env python3
"""
Setup Lambda Environment Variables
This script helps you set up the environment variables for your Lambda function.
"""

import json
import base64
import os

def setup_lambda_environment():
    """Setup Lambda environment variables with your credentials."""
    
    print("🔧 BlitzNow Training App - Lambda Environment Setup")
    print("=" * 60)
    
    # Database credentials
    db_credentials = {
        "DB_USER": "product_readuser",
        "DB_PASSWORD": "ih8x80r1C9*o273e",
        "DB_PORT": "5432"
    }
    
    print("✅ Database credentials configured:")
    print(f"   Username: {db_credentials['DB_USER']}")
    print(f"   Password: {'*' * len(db_credentials['DB_PASSWORD'])}")
    print(f"   Port: {db_credentials['DB_PORT']}")
    
    # Google Sheets credentials
    credentials_file = "blitznow-sheets-credentials.json"
    if os.path.exists(credentials_file):
        print(f"\n✅ Found Google Sheets credentials: {credentials_file}")
        
        with open(credentials_file, 'r') as f:
            credentials_data = f.read()
        
        credentials_b64 = base64.b64encode(credentials_data.encode('utf-8')).decode('utf-8')
        print("✅ Google Sheets credentials encoded for Lambda")
    else:
        print(f"\n❌ Google Sheets credentials file not found: {credentials_file}")
        credentials_b64 = "BASE64_ENCODED_CREDENTIALS"
    
    # Complete environment variables
    environment_variables = {
        "GOOGLE_SHEETS_CREDENTIALS": credentials_b64,
        "DB_HOST": "blitz-prod-read-replica-v2.cdgpvetprks3.ap-south-1.rds.amazonaws.com",
        "DB_NAME": "sarathy",
        **db_credentials
    }
    
    print("\n📋 Lambda Environment Variables:")
    print("=" * 40)
    for key, value in environment_variables.items():
        if key == "DB_PASSWORD":
            display_value = "*" * len(value)
        elif key == "GOOGLE_SHEETS_CREDENTIALS":
            display_value = f"{value[:50]}..." if len(value) > 50 else value
        else:
            display_value = value
        print(f"{key}={display_value}")
    
    # Save to file
    with open("lambda_env_vars.json", "w") as f:
        json.dump(environment_variables, f, indent=2)
    
    print(f"\n💾 Environment variables saved to: lambda_env_vars.json")
    
    print("\n✅ Database configuration complete!")
    print("   All environment variables are ready for Lambda deployment")
    
    print("\n📋 Next Steps:")
    print("   1. Go to AWS Lambda Console")
    print("   2. Open your Lambda function")
    print("   3. Go to Configuration > Environment variables")
    print("   4. Add each variable from the list above")
    print("   5. Deploy your Lambda function")
    
    return environment_variables

def main():
    """Main setup function."""
    try:
        env_vars = setup_lambda_environment()
        print("\n✅ Environment setup completed successfully!")
        return True
    except Exception as e:
        print(f"\n❌ Setup failed: {str(e)}")
        return False

if __name__ == "__main__":
    success = main()
    if success:
        print("\n🎯 Ready to configure your Lambda function!")
    else:
        print("\n🚨 Setup failed. Please check the error messages above.")
