# BlitzNow Training App - Lambda Architecture Diagram

## System Architecture Overview

```mermaid
graph TB
    %% Client Layer
    subgraph "Client Layer"
        FA[Flutter App<br/>Mobile/Web]
    end
    
    %% API Gateway Layer
    subgraph "AWS API Gateway"
        AG[API Gateway<br/>REST API]
    end
    
    %% Lambda Function
    subgraph "AWS Lambda"
        LF[Lambda Function<br/>Python 3.11<br/>lambda_function.py]
        
        subgraph "Core Handlers"
            RH[handle_rider_info]
            TH[handle_training_progress]
            UH[handle_update_progress]
            MH[handle_module_started]
            CH[handle_module_completed]
            GTH[handle_get_tutorials]
            TSH[handle_tutorial_state]
        end
        
        subgraph "Business Logic"
            RI[get_rider_info]
            TP[update_training_progress]
            GT[get_tutorial_mappings]
            TS[get_tutorial_states]
            TU[update_tutorial_state]
        end
    end
    
    %% Database Layer
    subgraph "Database Layer"
        subgraph "PostgreSQL Read Replica"
            DB[(PostgreSQL<br/>Read Replica)]
            RT[rider table]
            NT[node table]
            TT[tour table]
        end
        
        subgraph "Supabase"
            SB[(Supabase<br/>PostgreSQL)]
            TUT[tutorials table]
            DHT[day_hub_tutorial_mappings]
            TRP[training_progress table]
        end
    end
    
    %% Connections
    FA -->|HTTP Requests| AG
    AG -->|Route to Handlers| LF
    
    LF --> RH
    LF --> TH
    LF --> UH
    LF --> MH
    LF --> CH
    LF --> GTH
    LF --> TSH
    
    RH --> RI
    TH --> TP
    UH --> TP
    MH --> TP
    CH --> TP
    GTH --> GT
    GTH --> TS
    TSH --> TU
    
    RI -->|SQL Queries| DB
    DB --> RT
    DB --> NT
    DB --> TT
    
    TP -->|CRUD Operations| SB
    GT -->|Query Mappings| SB
    TS -->|Get States| SB
    TU -->|Update States| SB
    
    SB --> TUT
    SB --> DHT
    SB --> TRP
    
    %% Response Flow
    SB -.->|JSON Response| LF
    DB -.->|Rider Data| LF
    LF -.->|API Response| AG
    AG -.->|JSON Response| FA
```

## Detailed Data Flow

```mermaid
sequenceDiagram
    participant FA as Flutter App
    participant AG as API Gateway
    participant LF as Lambda Function
    participant DB as PostgreSQL
    participant SB as Supabase
    
    Note over FA,SB: Tutorial Request Flow
    
    FA->>AG: GET /get-tutorials?rider_id=12345
    AG->>LF: Route to handle_get_tutorials()
    
    LF->>DB: get_rider_info(rider_id)
    DB-->>LF: {rider_id, node_type, rider_age}
    
    alt rider_age exists
        LF->>LF: Map node_type to hub_type
        LF->>SB: get_tutorial_mappings(day, hub_type)
        SB-->>LF: tutorial mappings list
        
        LF->>SB: get_tutorial_states(rider_id)
        SB-->>LF: tutorial completion states
        
        LF->>LF: Combine data and build response
        LF-->>AG: {tutorials: [...], rider_age: 1}
    else rider not found
        LF-->>AG: 404 Error
    end
    
    AG-->>FA: JSON Response
```

## Database Schema Relationships

```mermaid
erDiagram
    RIDER ||--o{ TRAINING_PROGRESS : has
    NODE ||--o{ RIDER : contains
    TOUR ||--o{ NODE : belongs_to
    TUTORIAL ||--o{ DAY_HUB_TUTORIAL_MAPPINGS : mapped_in
    DAY_HUB_TUTORIAL_MAPPINGS ||--o{ TRAINING_PROGRESS : tracks
    
    RIDER {
        int rider_id PK
        int node_node_id FK
        timestamp created_at
    }
    
    NODE {
        int node_id PK
        string node_type
    }
    
    TOUR {
        int tour_id PK
        int node_id FK
        date tour_date
    }
    
    TUTORIAL {
        string id PK
        string title
        string subtitle
        text description
        timestamp created_at
        timestamp updated_at
    }
    
    DAY_HUB_TUTORIAL_MAPPINGS {
        int id PK
        int day
        string hub_type
        string tutorial_id FK
        int order_index
        timestamp created_at
        timestamp updated_at
    }
    
    TRAINING_PROGRESS {
        int id PK
        int rider_id FK
        jsonb tutorial_state
        timestamp module_started_day1
        timestamp module_started_day2
        timestamp module_started_day3
        timestamp module_completed_day1
        timestamp module_completed_day2
        timestamp module_completed_day3
        timestamp created_at
        timestamp updated_at
    }
```

## API Endpoints Flow

```mermaid
graph LR
    subgraph "API Endpoints"
        E1["/rider-info<br/>GET"]
        E2["/training-progress<br/>GET"]
        E3["/update-progress<br/>POST"]
        E4["/module-started<br/>POST"]
        E5["/module-completed<br/>POST"]
        E6["/get-tutorials<br/>GET"]
        E7["/tutorial-state<br/>POST"]
        E8["/tutorials<br/>POST"]
        E9["/day-hub-mappings<br/>POST"]
    end
    
    subgraph "Data Sources"
        DS1[PostgreSQL<br/>Rider Info]
        DS2[Supabase<br/>Progress & Tutorials]
    end
    
    E1 --> DS1
    E2 --> DS2
    E3 --> DS2
    E4 --> DS2
    E5 --> DS2
    E6 --> DS1
    E6 --> DS2
    E7 --> DS2
    E8 --> DS2
    E9 --> DS2
```

## Deployment Architecture

```mermaid
graph TB
    subgraph "Development Environment"
        DEV[Local Development<br/>Flutter App]
        LOCAL[Local Server<br/>local_server.py]
    end
    
    subgraph "AWS Cloud"
        subgraph "Lambda Service"
            LAMBDA[Lambda Function<br/>blitznow-training-lambda.zip]
            ENV[Environment Variables<br/>SUPABASE_URL<br/>SUPABASE_ANON_KEY<br/>DB_HOST, DB_NAME, etc.]
        end
        
        subgraph "API Gateway"
            API[API Gateway<br/>REST API Endpoints]
        end
        
        subgraph "External Services"
            PG[PostgreSQL<br/>Read Replica]
            SUP[Supabase<br/>PostgreSQL + Auth]
        end
    end
    
    subgraph "Deployment Process"
        DEPLOY[deploy.py<br/>Package Creation]
        ZIP[ZIP Package<br/>Dependencies + Code]
    end
    
    DEV --> LOCAL
    LOCAL --> PG
    LOCAL --> SUP
    
    DEPLOY --> ZIP
    ZIP --> LAMBDA
    ENV --> LAMBDA
    LAMBDA --> API
    API --> PG
    API --> SUP
    
    DEV -.->|Production| API
```

## Key Features Highlighted

### 1. **Serverless Architecture**
- Auto-scaling Lambda function
- Pay-per-request pricing model
- No server management required

### 2. **Multi-Database Strategy**
- PostgreSQL for business logic (rider data)
- Supabase for tutorial management and progress tracking
- Read replicas for performance

### 3. **RESTful API Design**
- Clean endpoint structure
- Consistent error handling
- CORS support for web clients

### 4. **Business Logic Separation**
- Rider age calculation (1, 2, 3 days)
- Hub type mapping (lm_hub, quick_hub)
- Tutorial personalization based on rider profile

### 5. **Progress Tracking**
- Module start/completion timestamps
- Individual tutorial completion states
- JSONB storage for flexible state management

This architecture provides a scalable, maintainable solution for the BlitzNow training system with clear separation of concerns and efficient data management.
