
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
    
    # Check if environment variables file exists
    if not os.path.exists('lambda_env_vars.json'):
        print("❌ Error: lambda_env_vars.json not found")
        print("📝 Please create lambda_env_vars.json with your Supabase credentials:")
        print("   - SUPABASE_URL: Your Supabase project URL")
        print("   - SUPABASE_ANON_KEY: Your Supabase anonymous key")
        return False
    
    # Read environment variables file
    with open('lambda_env_vars.json', 'r') as f:
        env_vars = json.load(f)
    
    print(f"✅ Read environment variables file")
    
    # Validate required Supabase environment variables
    required_vars = ['SUPABASE_URL', 'SUPABASE_ANON_KEY']
    missing_vars = [var for var in required_vars if not env_vars.get(var)]
    
    if missing_vars:
        print(f"❌ Missing required environment variables: {missing_vars}")
        return False
    
    # Validate Supabase URL format
    supabase_url = env_vars.get('SUPABASE_URL', '')
    if not supabase_url.startswith('https://') or '.supabase.co' not in supabase_url:
        print(f"❌ Invalid SUPABASE_URL format. Should be: https://your-project-ref.supabase.co")
        return False
    
    print(f"✅ Supabase URL: {supabase_url}")
    print(f"✅ Supabase Key: {env_vars.get('SUPABASE_ANON_KEY', '')[:20]}...")
    
    # Save to file (already exists, just confirm)
    print(f"✅ Environment variables configuration ready")
    
    # Display the environment variables for manual copy
    print("\n" + "="*60)
    print("🚀 COPY THESE TO AWS LAMBDA ENVIRONMENT VARIABLES:")
    print("="*60)
    for key, value in env_vars.items():
        print(f"{key}={value}")
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
