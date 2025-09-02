#!/usr/bin/env python3
"""
BlitzNow Training App - AWS Lambda Function
This Lambda function handles:
1. Rider information retrieval from database
2. Training progress tracking in Google Sheets
3. Module start/completion tracking
"""

import json
import psycopg2
import gspread
from google.oauth2.service_account import Credentials
import os
import base64
from datetime import datetime
import logging

# Configure logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

# Google Sheets configuration
SHEET_ID = '1uHaV50xWxJal6f4IIbIleBcgj9fAN6FhXq-qqzIgRH4'
SHEET_NAME = 'Sheet1'

def get_google_sheets_client():
    """Initialize and return Google Sheets client."""
    try:
        # Get credentials from environment variable
        credentials_json = os.environ.get('GOOGLE_SHEETS_CREDENTIALS')
        if not credentials_json:
            raise Exception("GOOGLE_SHEETS_CREDENTIALS environment variable not set")
        
        # Decode base64 credentials
        credentials_data = json.loads(base64.b64decode(credentials_json).decode('utf-8'))
        
        # Create credentials object
        credentials = Credentials.from_service_account_info(
            credentials_data,
            scopes=['https://www.googleapis.com/auth/spreadsheets']
        )
        
        # Authorize and return client
        gc = gspread.authorize(credentials)
        return gc
        
    except Exception as e:
        logger.error(f"Error initializing Google Sheets client: {str(e)}")
        raise

def get_database_connection():
    """Get database connection to read replica."""
    try:
        conn = psycopg2.connect(
            host=os.environ['DB_HOST'],
            database=os.environ['DB_NAME'],
            user=os.environ['DB_USER'],
            password=os.environ['DB_PASSWORD'],
            port=os.environ.get('DB_PORT', '5432')
        )
        return conn
    except Exception as e:
        logger.error(f"Error connecting to database: {str(e)}")
        raise

def get_rider_info(rider_id):
    """Get rider information from database."""
    conn = None
    try:
        conn = get_database_connection()
        cursor = conn.cursor()
        
        # Execute the query with fallback to created_at
        query = """
        SELECT
            r.rider_id,
            n.node_type,
            CASE
                -- First check if tour dates exist and calculate based on tour_date
                WHEN EXISTS (
                    SELECT 1 FROM application_db.tour tu 
                    WHERE tu.node_id = n.node_id
                ) THEN
                    CASE
                        WHEN (MIN(tu.tour_date)::date - CURRENT_DATE) = 0 THEN 1
                        WHEN (MIN(tu.tour_date)::date - CURRENT_DATE) = 1 THEN 2
                        WHEN (MIN(tu.tour_date)::date - CURRENT_DATE) = 2 THEN 3
                        ELSE NULL
                    END
                -- Fallback: if no tour dates exist, use rider.created_at
                ELSE
                    CASE
                        WHEN (r.created_at::date - CURRENT_DATE) = 0 THEN 1
                        WHEN (r.created_at::date - CURRENT_DATE) = 1 THEN 2
                        WHEN (r.created_at::date - CURRENT_DATE) = 2 THEN 3
                        ELSE NULL
                    END
            END AS rider_age
        FROM application_db.rider r
        JOIN application_db.node n
        ON r.node_node_id = n.node_id
        LEFT JOIN application_db.tour tu
        ON tu.node_id = n.node_id
        WHERE r.rider_id = %s
        GROUP BY r.rider_id, n.node_type, r.created_at;
        """
        
        cursor.execute(query, (rider_id,))
        result = cursor.fetchone()
        
        if result:
            return {
                'rider_id': result[0],
                'node_type': result[1],
                'rider_age': result[2]
            }
        else:
            return None
            
    except Exception as e:
        logger.error(f"Error fetching rider info: {str(e)}")
        raise
    finally:
        if conn:
            conn.close()

def update_training_progress(rider_id, module_started=None, module_completed=None):
    """Update training progress in Google Sheets."""
    try:
        gc = get_google_sheets_client()
        sheet = gc.open_by_key(SHEET_ID).sheet1
        
        # Get headers
        headers = sheet.row_values(1)
        if not headers:
            # Create headers if they don't exist
            headers = [
                'rider_id', 'module_started_day1', 'module_started_day2', 
                'module_started_day3', 'module_completed_day1', 
                'module_completed_day2', 'module_completed_day3', 'updated_at'
            ]
            sheet.append_row(headers)
        
        # Find existing row or create new one
        try:
            cell = sheet.find(rider_id)
            row_num = cell.row
        except:
            # Create new row
            row_num = len(sheet.get_all_values()) + 1
            sheet.update_cell(row_num, 1, rider_id)
        
        current_time = datetime.now().isoformat()
        
        # Update module started
        if module_started:
            for day, timestamp in module_started.items():
                col_name = f'module_started_{day}'
                if col_name in headers:
                    col_index = headers.index(col_name) + 1
                    sheet.update_cell(row_num, col_index, timestamp)
        
        # Update module completed
        if module_completed:
            for day, timestamp in module_completed.items():
                col_name = f'module_completed_{day}'
                if col_name in headers:
                    col_index = headers.index(col_name) + 1
                    sheet.update_cell(row_num, col_index, timestamp)
        
        # Update timestamp
        updated_at_col = headers.index('updated_at') + 1
        sheet.update_cell(row_num, updated_at_col, current_time)
        
        return True
        
    except Exception as e:
        logger.error(f"Error updating training progress: {str(e)}")
        raise

def lambda_handler(event, context):
    """Main Lambda handler function."""
    
    # Set CORS headers
    headers = {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Headers': 'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token',
        'Access-Control-Allow-Methods': 'GET,POST,OPTIONS'
    }
    
    # Handle preflight OPTIONS request
    if event.get('httpMethod') == 'OPTIONS':
        return {
            'statusCode': 200,
            'headers': headers,
            'body': json.dumps({'message': 'CORS preflight'})
        }
    
    try:
        # Parse request body
        if isinstance(event.get('body'), str):
            body = json.loads(event['body'])
        else:
            body = event.get('body', {})
        
        # Get the path to determine which endpoint to call
        path = event.get('path', '')
        
        if path == '/rider-info':
            # Get query parameters for GET requests
            query_params = event.get('queryStringParameters') or {}
            return handle_rider_info(query_params, headers)
        elif path == '/update-progress':
            return handle_update_progress(body, headers)
        elif path == '/module-started':
            return handle_module_started(body, headers)
        elif path == '/module-completed':
            return handle_module_completed(body, headers)
        else:
            return {
                'statusCode': 404,
                'headers': headers,
                'body': json.dumps({'error': 'Endpoint not found'})
            }
            
    except Exception as e:
        logger.error(f"Lambda error: {str(e)}")
        return {
            'statusCode': 500,
            'headers': headers,
            'body': json.dumps({'error': str(e)})
        }

def handle_rider_info(query_params, headers):
    """Handle rider info endpoint - GET request with query parameters."""
    try:
        rider_id = query_params.get('rider_id') if query_params else None
        
        if not rider_id:
            return {
                'statusCode': 400,
                'headers': headers,
                'body': json.dumps({'error': 'Rider ID is required'})
            }
        
        rider_info = get_rider_info(rider_id)
        
        if rider_info:
            return {
                'statusCode': 200,
                'headers': headers,
                'body': json.dumps(rider_info)
            }
        else:
            return {
                'statusCode': 404,
                'headers': headers,
                'body': json.dumps({'error': 'Rider not found'})
            }
            
    except Exception as e:
        logger.error(f"Error in handle_rider_info: {str(e)}")
        return {
            'statusCode': 500,
            'headers': headers,
            'body': json.dumps({'error': str(e)})
        }

def handle_update_progress(body, headers):
    """Handle update progress endpoint."""
    try:
        rider_id = body.get('rider_id')
        if not rider_id:
            return {
                'statusCode': 400,
                'headers': headers,
                'body': json.dumps({'error': 'Rider ID is required'})
            }
        
        module_started = body.get('module_started', {})
        module_completed = body.get('module_completed', {})
        
        success = update_training_progress(rider_id, module_started, module_completed)
        
        if success:
            return {
                'statusCode': 200,
                'headers': headers,
                'body': json.dumps({'success': True, 'message': 'Progress updated successfully'})
            }
        else:
            return {
                'statusCode': 500,
                'headers': headers,
                'body': json.dumps({'error': 'Failed to update progress'})
            }
            
    except Exception as e:
        logger.error(f"Error in handle_update_progress: {str(e)}")
        return {
            'statusCode': 500,
            'headers': headers,
            'body': json.dumps({'error': str(e)})
        }

def handle_module_started(body, headers):
    """Handle module started endpoint."""
    try:
        rider_id = body.get('rider_id')
        day = body.get('day')
        timestamp = body.get('timestamp', datetime.now().isoformat())
        
        if not rider_id or not day:
            return {
                'statusCode': 400,
                'headers': headers,
                'body': json.dumps({'error': 'Rider ID and day are required'})
            }
        
        module_started = {day: timestamp}
        success = update_training_progress(rider_id, module_started=module_started)
        
        if success:
            return {
                'statusCode': 200,
                'headers': headers,
                'body': json.dumps({'success': True, 'message': f'Module {day} started successfully'})
            }
        else:
            return {
                'statusCode': 500,
                'headers': headers,
                'body': json.dumps({'error': 'Failed to mark module as started'})
            }
            
    except Exception as e:
        logger.error(f"Error in handle_module_started: {str(e)}")
        return {
            'statusCode': 500,
            'headers': headers,
            'body': json.dumps({'error': str(e)})
        }

def handle_module_completed(body, headers):
    """Handle module completed endpoint."""
    try:
        rider_id = body.get('rider_id')
        day = body.get('day')
        timestamp = body.get('timestamp', datetime.now().isoformat())
        
        if not rider_id or not day:
            return {
                'statusCode': 400,
                'headers': headers,
                'body': json.dumps({'error': 'Rider ID and day are required'})
            }
        
        module_completed = {day: timestamp}
        success = update_training_progress(rider_id, module_completed=module_completed)
        
        if success:
            return {
                'statusCode': 200,
                'headers': headers,
                'body': json.dumps({'success': True, 'message': f'Module {day} completed successfully'})
            }
        else:
            return {
                'statusCode': 500,
                'headers': headers,
                'body': json.dumps({'error': 'Failed to mark module as completed'})
            }
            
    except Exception as e:
        logger.error(f"Error in handle_module_completed: {str(e)}")
        return {
            'statusCode': 500,
            'headers': headers,
            'body': json.dumps({'error': str(e)})
        }
