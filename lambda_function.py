#!/usr/bin/env python3
"""
BlitzNow Training App - AWS Lambda Function
This Lambda function handles:
1. Rider information retrieval from database
2. Training progress tracking in Supabase
3. Module start/completion tracking
"""

import json
import psycopg2
from supabase import create_client, Client
import os
from datetime import datetime
import logging
from mock_data import get_mock_rider_info, get_mock_training_progress

# Configure logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

# Supabase configuration
def get_supabase_client():
    """Initialize and return Supabase client."""
    try:
        supabase_url = os.environ.get('SUPABASE_URL')
        supabase_key = os.environ.get('SUPABASE_ANON_KEY')
        
        if not supabase_url or not supabase_key:
            raise Exception("SUPABASE_URL and SUPABASE_ANON_KEY environment variables must be set")
        
        supabase: Client = create_client(supabase_url, supabase_key)
        return supabase
        
    except Exception as e:
        logger.error(f"Error initializing Supabase client: {str(e)}")
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
        # Don't raise the exception, return None instead for fallback
        return None

def get_rider_info(rider_id):
    """Get rider information from database with fallback to mock data."""
    conn = None
    try:
        conn = get_database_connection()
        if conn is None:
            logger.info(f"Database connection failed, using mock data for rider_id: {rider_id}")
            return get_mock_rider_info(rider_id)
        
        cursor = conn.cursor()
        
        # Execute the query with fallback to created_at
        query = """
        WITH tour_min AS (
  SELECT node_id, MIN(tour_date)::date AS min_tour_date
  FROM tour
  GROUP BY node_id
)
SELECT
  r.rider_id,
  n.node_type,
  CASE
    WHEN tm.min_tour_date IS NOT NULL THEN
      CASE
        WHEN (tm.min_tour_date - CURRENT_DATE) = 0 THEN 1
        WHEN (tm.min_tour_date - CURRENT_DATE) = 1 THEN 2
        WHEN (tm.min_tour_date - CURRENT_DATE) = 2 THEN 3
        ELSE NULL
      END
    ELSE
      CASE
        WHEN (r.created_at::date - CURRENT_DATE) = 0 THEN 1
        WHEN (r.created_at::date - CURRENT_DATE) = 1 THEN 2
        WHEN (r.created_at::date - CURRENT_DATE) = 2 THEN 3
        ELSE NULL
      END
  END AS rider_age
FROM rider r
JOIN node n
  ON r.node_node_id = n.node_id
LEFT JOIN tour_min tm
  ON tm.node_id = n.node_id
WHERE r.rider_id = %s;
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
        logger.info(f"Falling back to mock data for rider_id: {rider_id}")
        # Fallback to mock data for local development
        return get_mock_rider_info(rider_id)
    finally:
        if conn:
            conn.close()

def update_training_progress(rider_id, module_started=None, module_completed=None):
    """Update training progress in Supabase."""
    try:
        supabase = get_supabase_client()
        
        # Prepare update data
        update_data = {}
        
        # Update module started timestamps
        if module_started:
            for day, timestamp in module_started.items():
                column_name = f'module_started_{day}'
                update_data[column_name] = timestamp
        
        # Update module completed timestamps
        if module_completed:
            for day, timestamp in module_completed.items():
                column_name = f'module_completed_{day}'
                update_data[column_name] = timestamp
        
        # Always update the updated_at timestamp
        update_data['updated_at'] = datetime.now().isoformat()
        
        # Check if record exists for this rider
        existing_record = supabase.table('training_progress').select('*').eq('rider_id', rider_id).execute()
        
        if existing_record.data:
            # Update existing record
            logger.info(f"Updating existing training progress for rider_id: {rider_id}")
            result = supabase.table('training_progress').update(update_data).eq('rider_id', rider_id).execute()
        else:
            # Create new record
            logger.info(f"Creating new training progress record for rider_id: {rider_id}")
            update_data['rider_id'] = rider_id
            result = supabase.table('training_progress').insert(update_data).execute()
        
        if result.data:
            logger.info(f"Successfully updated training progress for rider_id: {rider_id}")
            return True
        else:
            logger.error(f"Failed to update training progress for rider_id: {rider_id}")
            return False
        
    except Exception as e:
        logger.error(f"Error updating training progress: {str(e)}")
        raise

def get_training_progress(rider_id):
    """Get training progress from Supabase with fallback to mock data."""
    try:
        supabase = get_supabase_client()
        
        result = supabase.table('training_progress').select('*').eq('rider_id', rider_id).execute()
        
        if result.data:
            return result.data[0]
        else:
            return None
        
    except Exception as e:
        logger.error(f"Error getting training progress: {str(e)}")
        logger.info(f"Falling back to mock data for rider_id: {rider_id}")
        # Fallback to mock data for local development
        return get_mock_training_progress(rider_id)

def get_tutorial_mappings(day, hub_type):
    """Get tutorial mappings for a specific day and hub type."""
    try:
        supabase = get_supabase_client()
        
        result = supabase.table('day_hub_tutorial_mappings').select('*').eq('day', day).eq('hub_type', hub_type).order('order_index').execute()
        
        return result.data if result.data else []
        
    except Exception as e:
        logger.error(f"Error getting tutorial mappings: {str(e)}")
        return []

def get_tutorial_states(rider_id):
    """Get tutorial states for a rider."""
    try:
        supabase = get_supabase_client()
        
        result = supabase.table('training_progress').select('tutorial_state').eq('rider_id', rider_id).execute()
        
        if result.data and result.data[0].get('tutorial_state'):
            return result.data[0]['tutorial_state']
        else:
            return {}
        
    except Exception as e:
        logger.error(f"Error getting tutorial states: {str(e)}")
        return {}

def get_tutorial_by_id(tutorial_id):
    """Get tutorial information by ID."""
    try:
        supabase = get_supabase_client()
        
        result = supabase.table('tutorials').select('*').eq('id', tutorial_id).execute()
        
        return result.data[0] if result.data else None
        
    except Exception as e:
        logger.error(f"Error getting tutorial by ID: {str(e)}")
        return None

def get_all_tutorials():
    """Get all tutorials."""
    try:
        supabase = get_supabase_client()
        
        result = supabase.table('tutorials').select('*').order('id').execute()
        
        return result.data if result.data else []
        
    except Exception as e:
        logger.error(f"Error getting all tutorials: {str(e)}")
        return []

def update_tutorial_state(rider_id, tutorial_id, is_done, action='update'):
    """Update tutorial state for a rider."""
    try:
        supabase = get_supabase_client()
        
        # Get current tutorial states
        current_states = get_tutorial_states(rider_id)
        
        # Update the specific tutorial state
        current_states[tutorial_id] = {
            'id': tutorial_id,
            'isDone': is_done
        }
        
        # Update the training progress record
        result = supabase.table('training_progress').update({
            'tutorial_state': current_states
        }).eq('rider_id', rider_id).execute()
        
        # If no record exists, create one
        if not result.data:
            result = supabase.table('training_progress').insert({
                'rider_id': rider_id,
                'tutorial_state': current_states
            }).execute()
        
        return bool(result.data)
        
    except Exception as e:
        logger.error(f"Error updating tutorial state: {str(e)}")
        return False

def create_tutorial(tutorial_id, title, subtitle='', description=''):
    """Create a new tutorial."""
    try:
        supabase = get_supabase_client()
        
        result = supabase.table('tutorials').insert({
            'id': tutorial_id,
            'title': title,
            'subtitle': subtitle,
            'description': description
        }).execute()
        
        return bool(result.data)
        
    except Exception as e:
        logger.error(f"Error creating tutorial: {str(e)}")
        return False

def create_day_hub_mappings(day, hub_type, tutorial_ids):
    """Create day-hub-tutorial mappings."""
    try:
        supabase = get_supabase_client()
        
        # Prepare mapping data
        mappings = []
        for i, tutorial_id in enumerate(tutorial_ids):
            mappings.append({
                'day': day,
                'hub_type': hub_type,
                'tutorial_id': tutorial_id,
                'order_index': i
            })
        
        result = supabase.table('day_hub_tutorial_mappings').insert(mappings).execute()
        
        return bool(result.data)
        
    except Exception as e:
        logger.error(f"Error creating day-hub mappings: {str(e)}")
        return False

def get_all_day_hub_mappings():
    """Get all day-hub-tutorial mappings."""
    try:
        supabase = get_supabase_client()
        
        result = supabase.table('day_hub_tutorial_mappings').select('*').order('day').order('hub_type').order('order_index').execute()
        
        return result.data if result.data else []
        
    except Exception as e:
        logger.error(f"Error getting all day-hub mappings: {str(e)}")
        return []

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
        elif path == '/training-progress':
            # Get query parameters for GET requests
            query_params = event.get('queryStringParameters') or {}
            return handle_training_progress(query_params, headers)
        elif path == '/update-progress':
            return handle_update_progress(body, headers)
        elif path == '/module-started':
            return handle_module_started(body, headers)
        elif path == '/module-completed':
            return handle_module_completed(body, headers)
        elif path == '/get-tutorials':
            # Get query parameters for GET requests
            query_params = event.get('queryStringParameters') or {}
            return handle_get_tutorials(query_params, headers)
        elif path == '/tutorial-state':
            return handle_tutorial_state(body, headers)
        elif path == '/tutorials':
            return handle_tutorials(body, headers)
        elif path == '/day-hub-mappings':
            return handle_day_hub_mappings(body, headers)
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

def handle_training_progress(query_params, headers):
    """Handle training progress endpoint - GET request with query parameters."""
    try:
        rider_id = query_params.get('rider_id') if query_params else None
        
        if not rider_id:
            return {
                'statusCode': 400,
                'headers': headers,
                'body': json.dumps({'error': 'Rider ID is required'})
            }
        
        training_progress = get_training_progress(rider_id)
        
        if training_progress:
            return {
                'statusCode': 200,
                'headers': headers,
                'body': json.dumps(training_progress)
            }
        else:
            return {
                'statusCode': 404,
                'headers': headers,
                'body': json.dumps({'error': 'Training progress not found'})
            }
            
    except Exception as e:
        logger.error(f"Error in handle_training_progress: {str(e)}")
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

def handle_get_tutorials(query_params, headers):
    """Handle get tutorials endpoint - main API for getting tutorials based on rider's day and hub type."""
    try:
        rider_id = query_params.get('rider_id') if query_params else None
        
        if not rider_id:
            return {
                'statusCode': 400,
                'headers': headers,
                'body': json.dumps({
                    'message': 'Something went wrong!',
                    'data': None,
                    'error': 'Rider ID is required'
                })
            }
        
        # Step 1: Get rider info to determine day and hub type
        rider_info = get_rider_info(rider_id)
        if not rider_info:
            return {
                'statusCode': 404,
                'headers': headers,
                'body': json.dumps({
                    'message': 'Something went wrong!',
                    'data': None,
                    'error': 'Rider not found'
                })
            }
        
        rider_age = rider_info.get('rider_age')
        node_type = rider_info.get('node_type')
        
        if not rider_age:
            return {
                'statusCode': 400,
                'headers': headers,
                'body': json.dumps({
                    'message': 'Something went wrong!',
                    'data': None,
                    'error': 'Rider age not determined'
                })
            }
        
        # Step 2: Determine hub type mapping
        # central_hub, franchise_hub, lm_hub use lm_hub mapping
        # quick_hub uses quick_hub mapping
        if node_type in ['central_hub', 'franchise_hub', 'lm_hub']:
            hub_type = 'lm_hub'
        elif node_type == 'quick_hub':
            hub_type = 'quick_hub'
        else:
            hub_type = 'lm_hub'  # Default fallback
        
        # Step 3: Get tutorial mappings for the day and hub type
        tutorial_mappings = get_tutorial_mappings(rider_age, hub_type)
        if not tutorial_mappings:
            return {
                'statusCode': 200,
                'headers': headers,
                'body': json.dumps({
                    'message': 'Success',
                    'data': {
                        'rider_age': rider_age,
                        'tutorials': []
                    }
                })
            }
        
        # Step 4: Get tutorial states for the rider
        tutorial_states = get_tutorial_states(rider_id)
        
        # Step 5: Build response with tutorial details and states
        tutorials = []
        for mapping in tutorial_mappings:
            tutorial_id = mapping['tutorial_id']
            tutorial_info = get_tutorial_by_id(tutorial_id)
            
            if tutorial_info:
                # Check if tutorial is completed
                is_done = tutorial_states.get(tutorial_id, {}).get('isDone', False)
                
                tutorials.append({
                    'id': tutorial_id,
                    'title': tutorial_info['title'],
                    'subtitle': tutorial_info.get('subtitle', ''),
                    'isDone': is_done
                })
        
        return {
            'statusCode': 200,
            'headers': headers,
            'body': json.dumps({
                'message': 'Success',
                'data': {
                    'rider_age': rider_age,
                    'tutorials': tutorials
                }
            })
        }
        
    except Exception as e:
        logger.error(f"Error in handle_get_tutorials: {str(e)}")
        return {
            'statusCode': 500,
            'headers': headers,
            'body': json.dumps({
                'message': 'Something went wrong!',
                'data': None,
                'error': str(e)
            })
        }

def handle_tutorial_state(body, headers):
    """Handle tutorial state management (create/update)."""
    try:
        rider_id = body.get('rider_id')
        tutorial_id = body.get('tutorial_id')
        is_done = body.get('isDone')
        action = body.get('action', 'update')  # 'create' or 'update'
        
        if not rider_id or not tutorial_id or is_done is None:
            return {
                'statusCode': 400,
                'headers': headers,
                'body': json.dumps({
                    'message': 'Something went wrong!',
                    'data': None,
                    'error': 'Rider ID, tutorial ID, and isDone status are required'
                })
            }
        
        success = update_tutorial_state(rider_id, tutorial_id, is_done, action)
        
        if success:
            return {
                'statusCode': 200,
                'headers': headers,
                'body': json.dumps({
                    'message': 'Success',
                    'data': {'updated': True}
                })
            }
        else:
            return {
                'statusCode': 500,
                'headers': headers,
                'body': json.dumps({
                    'message': 'Something went wrong!',
                    'data': None,
                    'error': 'Failed to update tutorial state'
                })
            }
            
    except Exception as e:
        logger.error(f"Error in handle_tutorial_state: {str(e)}")
        return {
            'statusCode': 500,
            'headers': headers,
            'body': json.dumps({
                'message': 'Something went wrong!',
                'data': None,
                'error': str(e)
            })
        }

def handle_tutorials(body, headers):
    """Handle tutorial management (create/update/get)."""
    try:
        action = body.get('action', 'get')  # 'create', 'update', 'get'
        
        if action == 'create':
            tutorial_id = body.get('id')
            title = body.get('title')
            subtitle = body.get('subtitle', '')
            description = body.get('description', '')
            
            if not tutorial_id or not title:
                return {
                    'statusCode': 400,
                    'headers': headers,
                    'body': json.dumps({
                        'message': 'Something went wrong!',
                        'data': None,
                        'error': 'Tutorial ID and title are required'
                    })
                }
            
            success = create_tutorial(tutorial_id, title, subtitle, description)
            
            if success:
                return {
                    'statusCode': 200,
                    'headers': headers,
                    'body': json.dumps({
                        'message': 'Success',
                        'data': {'created': True, 'tutorial_id': tutorial_id}
                    })
                }
            else:
                return {
                    'statusCode': 500,
                    'headers': headers,
                    'body': json.dumps({
                        'message': 'Something went wrong!',
                        'data': None,
                        'error': 'Failed to create tutorial'
                    })
                }
        
        elif action == 'get':
            tutorial_id = body.get('tutorial_id')
            if tutorial_id:
                tutorial = get_tutorial_by_id(tutorial_id)
                if tutorial:
                    return {
                        'statusCode': 200,
                        'headers': headers,
                        'body': json.dumps({
                            'message': 'Success',
                            'data': tutorial
                        })
                    }
                else:
                    return {
                        'statusCode': 404,
                        'headers': headers,
                        'body': json.dumps({
                            'message': 'Something went wrong!',
                            'data': None,
                            'error': 'Tutorial not found'
                        })
                    }
            else:
                # Get all tutorials
                tutorials = get_all_tutorials()
                return {
                    'statusCode': 200,
                    'headers': headers,
                    'body': json.dumps({
                        'message': 'Success',
                        'data': {'tutorials': tutorials}
                    })
                }
        
        else:
            return {
                'statusCode': 400,
                'headers': headers,
                'body': json.dumps({
                    'message': 'Something went wrong!',
                    'data': None,
                    'error': 'Invalid action. Use create, update, or get'
                })
            }
            
    except Exception as e:
        logger.error(f"Error in handle_tutorials: {str(e)}")
        return {
            'statusCode': 500,
            'headers': headers,
            'body': json.dumps({
                'message': 'Something went wrong!',
                'data': None,
                'error': str(e)
            })
        }

def handle_day_hub_mappings(body, headers):
    """Handle day-hub-tutorial mappings management."""
    try:
        action = body.get('action', 'get')  # 'create', 'get'
        
        if action == 'create':
            day = body.get('day')
            hub_type = body.get('hub_type')
            tutorial_ids = body.get('tutorial_ids', [])
            
            if not day or not hub_type or not tutorial_ids:
                return {
                    'statusCode': 400,
                    'headers': headers,
                    'body': json.dumps({
                        'message': 'Something went wrong!',
                        'data': None,
                        'error': 'Day, hub_type, and tutorial_ids are required'
                    })
                }
            
            success = create_day_hub_mappings(day, hub_type, tutorial_ids)
            
            if success:
                return {
                    'statusCode': 200,
                    'headers': headers,
                    'body': json.dumps({
                        'message': 'Success',
                        'data': {'created': True}
                    })
                }
            else:
                return {
                    'statusCode': 500,
                    'headers': headers,
                    'body': json.dumps({
                        'message': 'Something went wrong!',
                        'data': None,
                        'error': 'Failed to create mappings'
                    })
                }
        
        elif action == 'get':
            day = body.get('day')
            hub_type = body.get('hub_type')
            
            if day and hub_type:
                mappings = get_tutorial_mappings(day, hub_type)
                return {
                    'statusCode': 200,
                    'headers': headers,
                    'body': json.dumps({
                        'message': 'Success',
                        'data': {'mappings': mappings}
                    })
                }
            else:
                # Get all mappings
                all_mappings = get_all_day_hub_mappings()
                return {
                    'statusCode': 200,
                    'headers': headers,
                    'body': json.dumps({
                        'message': 'Success',
                        'data': {'mappings': all_mappings}
                    })
                }
        
        else:
            return {
                'statusCode': 400,
                'headers': headers,
                'body': json.dumps({
                    'message': 'Something went wrong!',
                    'data': None,
                    'error': 'Invalid action. Use create or get'
                })
            }
            
    except Exception as e:
        logger.error(f"Error in handle_day_hub_mappings: {str(e)}")
        return {
            'statusCode': 500,
            'headers': headers,
            'body': json.dumps({
                'message': 'Something went wrong!',
                'data': None,
                'error': str(e)
            })
        }


if __name__ == '__main__':
    lambda_handler({rider_}, None)