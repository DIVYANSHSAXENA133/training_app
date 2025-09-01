#!/usr/bin/env python3
"""
Deploy BlitzNow Training App Lambda Function
This script packages and deploys the Lambda function to AWS.
"""

import os
import subprocess
import json
import base64
import zipfile
import shutil
from pathlib import Path

def create_deployment_package():
    """Create deployment package for Lambda function."""
    print("📦 Creating deployment package...")
    
    # Create deployment directory
    deploy_dir = Path("lambda_deployment")
    if deploy_dir.exists():
        shutil.rmtree(deploy_dir)
    deploy_dir.mkdir()
    
    # Copy Lambda function
    shutil.copy("lambda_function.py", deploy_dir)
    
    # Install dependencies
    print("📥 Installing dependencies...")
    subprocess.run([
        "pip", "install", "-r", "requirements.txt", 
        "-t", str(deploy_dir)
    ], check=True)
    
    # Create ZIP file
    zip_path = "blitznow-training-lambda.zip"
    if os.path.exists(zip_path):
        os.remove(zip_path)
    
    print("🗜️  Creating ZIP package...")
    with zipfile.ZipFile(zip_path, 'w', zipfile.ZIP_DEFLATED) as zipf:
        for root, dirs, files in os.walk(deploy_dir):
            for file in files:
                file_path = os.path.join(root, file)
                arc_path = os.path.relpath(file_path, deploy_dir)
                zipf.write(file_path, arc_path)
    
    # Clean up
    shutil.rmtree(deploy_dir)
    
    print(f"✅ Deployment package created: {zip_path}")
    return zip_path

def prepare_credentials():
    """Prepare Google Sheets credentials for Lambda."""
    print("🔐 Preparing Google Sheets credentials...")
    
    credentials_file = "blitznow-sheets-credentials.json"
    if not os.path.exists(credentials_file):
        print(f"❌ Error: {credentials_file} not found!")
        return None
    
    # Read and encode credentials
    with open(credentials_file, 'r') as f:
        credentials_data = f.read()
    
    # Encode to base64
    credentials_b64 = base64.b64encode(credentials_data.encode('utf-8')).decode('utf-8')
    
    print("✅ Credentials prepared for Lambda environment variable")
    return credentials_b64

def create_lambda_config():
    """Create Lambda configuration file."""
    config = {
        "function_name": "blitznow-training-app",
        "runtime": "python3.9",
        "role": "arn:aws:iam::YOUR_ACCOUNT_ID:role/lambda-execution-role",
        "handler": "lambda_function.lambda_handler",
        "description": "BlitzNow Training App - Rider training and progress tracking",
        "timeout": 30,
        "memory_size": 256,
        "environment_variables": {
            "GOOGLE_SHEETS_CREDENTIALS": "BASE64_ENCODED_CREDENTIALS",
            "DB_HOST": "your-read-replica-endpoint.amazonaws.com",
            "DB_NAME": "your_database_name",
            "DB_USER": "your_username",
            "DB_PASSWORD": "your_password",
            "DB_PORT": "5432"
        },
        "api_gateway": {
            "name": "blitznow-training-api",
            "description": "API Gateway for BlitzNow Training App",
            "endpoints": [
                {
                    "path": "/rider-info",
                    "method": "POST",
                    "description": "Get rider information"
                },
                {
                    "path": "/update-progress",
                    "method": "POST",
                    "description": "Update training progress"
                },
                {
                    "path": "/module-started",
                    "method": "POST",
                    "description": "Mark module as started"
                },
                {
                    "path": "/module-completed",
                    "method": "POST",
                    "description": "Mark module as completed"
                }
            ]
        }
    }
    
    with open("lambda_config.json", "w") as f:
        json.dump(config, f, indent=2)
    
    print("✅ Lambda configuration created: lambda_config.json")
    return config

def main():
    """Main deployment function."""
    print("🚀 BlitzNow Training App - Lambda Deployment")
    print("=" * 50)
    
    try:
        # Step 1: Create deployment package
        zip_path = create_deployment_package()
        
        # Step 2: Prepare credentials
        credentials_b64 = prepare_credentials()
        if not credentials_b64:
            return False
        
        # Step 3: Create configuration
        config = create_lambda_config()
        
        print("\n" + "=" * 50)
        print("🎯 Deployment Package Ready!")
        print("=" * 50)
        print(f"📦 Package: {zip_path}")
        print(f"📋 Config: lambda_config.json")
        print(f"🔐 Credentials: Ready for environment variable")
        
        print("\n📋 Next Steps:")
        print("1. Update lambda_config.json with your AWS account details")
        print("2. Set environment variables in Lambda console")
        print("3. Upload the ZIP file to Lambda")
        print("4. Create API Gateway endpoints")
        print("5. Test the integration")
        
        print(f"\n🔐 Google Sheets Credentials (Base64):")
        print(f"Copy this to your Lambda environment variable 'GOOGLE_SHEETS_CREDENTIALS':")
        print(credentials_b64[:100] + "...")
        
        return True
        
    except Exception as e:
        print(f"❌ Deployment failed: {str(e)}")
        return False

if __name__ == "__main__":
    success = main()
    if success:
        print("\n✅ Deployment preparation completed successfully!")
    else:
        print("\n❌ Deployment preparation failed!")
