#!/usr/bin/env python3
"""
Simple Lambda deployment script
"""

import os
import shutil
import subprocess
import json

def create_deployment_package():
    """Create Lambda deployment package"""
    print("🚀 Creating Lambda Deployment Package")
    print("=" * 40)
    
    # Clean up any existing deployment directory
    if os.path.exists('deployment'):
        shutil.rmtree('deployment')
    
    # Create deployment directory
    os.makedirs('deployment', exist_ok=True)
    
    # Install dependencies
    print("📥 Installing Python dependencies...")
    try:
        subprocess.run([
            'pip', 'install', '-r', 'requirements.txt', 
            '-t', 'deployment', 
            '--platform', 'manylinux2014_x86_64',
            '--python-version', '3.11',
            '--only-binary=:all:',
            '--no-cache-dir'
        ], check=True)
        print("✅ Dependencies installed successfully")
    except subprocess.CalledProcessError as e:
        print(f"❌ Error installing dependencies: {e}")
        return False
    
    # Copy Lambda function
    print("📋 Copying Lambda function...")
    shutil.copy('lambda_function.py', 'deployment/')
    print("✅ Lambda function copied")
    
    # Create ZIP package
    print("🗜️  Creating ZIP package...")
    try:
        shutil.make_archive('blitznow-training-lambda', 'zip', 'deployment')
        print("✅ ZIP package created: blitznow-training-lambda.zip")
    except Exception as e:
        print(f"❌ Error creating ZIP: {e}")
        return False
    
    # Get package size
    zip_size = os.path.getsize('blitznow-training-lambda.zip')
    print(f"📦 Package size: {zip_size / (1024*1024):.1f} MB")
    
    return True

def create_environment_variables():
    """Create environment variables configuration"""
    print("\n🔐 Creating Environment Variables Configuration")
    print("=" * 40)
    
    # Check if credentials file exists
    if not os.path.exists('blitznow-sheets-credentials.json'):
        print("❌ Error: blitznow-sheets-credentials.json not found")
        return False
    
    # Read credentials file
    with open('blitznow-sheets-credentials.json', 'r') as f:
        credentials_content = f.read().strip()
    
    print(f"✅ Read credentials file ({len(credentials_content)} characters)")
    
    # Validate JSON
    try:
        credentials_json = json.loads(credentials_content)
        print(f"✅ JSON validation successful")
        print(f"✅ Service account: {credentials_json.get('client_email', 'N/A')}")
    except Exception as e:
        print(f"❌ JSON validation failed: {e}")
        return False
    
    # Create environment variables
    env_vars = {
        "GOOGLE_SHEETS_CREDENTIALS": credentials_content,  # Raw JSON string
        "DB_HOST": "blitz-prod-read-replica-v2.cdgpvetprks3.ap-south-1.rds.amazonaws.com",
        "DB_NAME": "sarathy",
        "DB_USER": "product_readuser",
        "DB_PASSWORD": "ih8x80r1C9*o273e",
        "DB_PORT": "5432"
    }
    
    # Save to file
    with open('lambda_env_vars.json', 'w') as f:
        json.dump(env_vars, f, indent=2)
    print(f"✅ Environment variables saved to lambda_env_vars.json")
    
    # Display the credentials for manual copy
    print("\n" + "="*60)
    print("🚀 COPY THIS TO AWS LAMBDA ENVIRONMENT VARIABLES:")
    print("="*60)
    print(f"GOOGLE_SHEETS_CREDENTIALS={credentials_content}")
    print("="*60)
    
    return True

def main():
    """Main deployment function"""
    print("BlitzNow Training App - Lambda Deployment")
    print("=" * 50)
    
    # Create deployment package
    if not create_deployment_package():
        print("❌ Failed to create deployment package")
        return False
    
    # Create environment variables
    if not create_environment_variables():
        print("❌ Failed to create environment variables")
        return False
    
    print("\n" + "="*50)
    print("🎉 DEPLOYMENT PACKAGE READY!")
    print("="*50)
    print("📦 Package: blitznow-training-lambda.zip")
    print("🔐 Env Vars: lambda_env_vars.json")
    print("\n🚀 Next Steps:")
    print("1. Upload blitznow-training-lambda.zip to AWS Lambda")
    print("2. Set environment variables from lambda_env_vars.json")
    print("3. Test with: python3 test_apis.py")
    
    return True

if __name__ == "__main__":
    main()
