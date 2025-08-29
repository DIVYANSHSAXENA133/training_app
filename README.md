# BlitzNow Training Flutter App

A comprehensive training application for BlitzNow delivery partners, built with Flutter for web and mobile platforms.

## 🚀 Features

- **Rider Authentication**: Enter Rider ID to access training modules
- **Dynamic Module Loading**: Automatically loads appropriate training based on rider type and day
- **Progress Tracking**: Visual progress indicators for joining bonus and training completion
- **Attendance System**: Face scan simulation for daily attendance marking
- **Google Sheets Integration**: Automatic progress updates to Google Sheets
- **Responsive Design**: Works seamlessly on mobile browsers and web
- **Easy Customization**: Training content easily configurable without code changes

## 🏗️ Architecture

- **Frontend**: Flutter web app optimized for mobile browsers
- **Backend**: AWS Lambda functions for API endpoints
- **Database**: Replica database for rider information
- **Storage**: Google Sheets for training progress tracking
- **State Management**: Provider pattern for app state

## 📱 Training Modules

### Day 1 Training
- Welcome message and onboarding
- Training program overview
- Attendance marking via face scan
- Guided delivery simulations
- App navigation training
- Test order completion

### Day 2 Training
- Advanced delivery skills
- Earnings module training
- COD (Cash on Delivery) management
- Best practices and guidelines
- Customer interaction practice

### Day 3 Training
- On-demand order access
- Referral program benefits
- Advanced delivery techniques
- Final assessment
- Completion certificate

## 🎯 Module Types

- **LM Hub**: Last Mile delivery specialists
- **Quick Hub**: Express delivery specialists

## 💰 Joining Bonus Structure

- **Day 1**: ₹500
- **Day 2**: ₹500  
- **Day 3**: ₹500
- **Total**: ₹1500

## 🛠️ Setup Instructions

### Prerequisites
- Flutter SDK (3.9.0 or higher)
- Dart SDK
- Web browser for testing

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd blitznow_training_flutter
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure API endpoints**
   - Open `lib/services/api_service.dart`
   - Replace `YOUR_LAMBDA_API_ENDPOINT` with your actual Lambda API endpoint

4. **Customize training content**
   - Open `lib/config/training_config.dart`
   - Modify training content, messages, and configuration as needed

5. **Run the app**
   ```bash
   flutter run -d chrome
   ```

## 🔧 Configuration

### Training Content Customization

All training content is easily customizable in `lib/config/training_config.dart`:

```dart
// Modify training content
static const Map<String, Map<String, String>> trainingContent = {
  'lm_hub': {
    'day1_title': 'Your Custom Title',
    'day1_welcome': 'Your custom welcome message',
    // ... more content
  },
};

// Modify task lists
static const Map<String, Map<String, List<String>>> trainingTasks = {
  'lm_hub': {
    'day1': [
      'Your custom task 1',
      'Your custom task 2',
      // ... more tasks
    ],
  },
};
```

### API Configuration

Update the API service configuration:

```dart
class ApiService {
  static const String baseUrl = 'https://your-lambda-api.amazonaws.com';
  // ... rest of the service
}
```

### Google Sheets Integration

Configure Google Sheets columns and structure:

```dart
static const List<String> sheetColumns = [
  'rider_id',
  'module_started_day1',
  'module_started_day2', 
  'module_started_day3',
  'module_completed_day1',
  'module_completed_day2',
  'module_completed_day3',
  'updated_at'
];
```

## 🌐 Backend Requirements

### AWS Lambda Functions

The app requires the following Lambda functions:

1. **`/rider-info`** - POST endpoint to fetch rider information
   - Input: `{"rider_id": "string"}`
   - Output: Rider object with `rider_id`, `node_type`, `rider_age`

2. **`/update-progress`** - POST endpoint to update training progress
   - Input: TrainingProgress object
   - Output: Success/failure response

3. **`/module-started`** - POST endpoint to mark module as started
   - Input: `{"rider_id": "string", "day": "string", "timestamp": "string"}`
   - Output: Success/failure response

4. **`/module-completed`** - POST endpoint to mark module as completed
   - Input: `{"rider_id": "string", "day": "string", "timestamp": "string"}`
   - Output: Success/failure response

### Database Query

The backend should execute this query to determine rider training day:

```sql
SELECT
  r.rider_id,
  n.node_type,
  CASE
    WHEN (MIN(tu.tour_date)::date - CURRENT_DATE) = 0 THEN 1
    WHEN (MIN(tu.tour_date)::date - CURRENT_DATE) = 1 THEN 2
    WHEN (MIN(tu.tour_date)::date - CURRENT_DATE) = 2 THEN 3
    ELSE NULL
  END AS rider_age
FROM application_db.rider r
JOIN application_db.node n
ON r.node_node_id = n.node_id
RIGHT JOIN application_db.tour tu
ON tu.node_id = n.node_id
GROUP BY r.rider_id, n.node_type;
```

## 📊 Google Sheets Structure

The app automatically updates a Google Sheet with the following columns:

| Column | Description |
|--------|-------------|
| rider_id | Unique rider identifier |
| module_started_day1 | Timestamp when day 1 started |
| module_started_day2 | Timestamp when day 2 started |
| module_started_day3 | Timestamp when day 3 started |
| module_completed_day1 | Timestamp when day 1 completed |
| module_completed_day2 | Timestamp when day 2 completed |
| module_completed_day3 | Timestamp when day 3 completed |
| updated_at | Last update timestamp |

## 🚀 Deployment

### Web Deployment

1. **Build for web**
   ```bash
   flutter build web --release
   ```

2. **Deploy to hosting service**
   - Upload `build/web` folder to your web server
   - Configure CORS if needed for API calls

### Mobile Browser Optimization

The app is optimized for mobile browsers:
- Responsive design for all screen sizes
- Touch-friendly interface
- Optimized for mobile performance

## 🧪 Testing

Run the test suite:

```bash
flutter test
```

## 📱 Usage Flow

1. **Rider enters Rider ID** on the welcome screen
2. **System fetches rider info** from backend (rider type, training day)
3. **App loads appropriate training module** based on rider type and day
4. **Rider starts training** and marks attendance
5. **Rider completes training tasks** and marks completion
6. **Progress is automatically updated** in Google Sheets
7. **Rider can proceed to next day** or complete training

## 🔒 Security Features

- Input validation for Rider ID
- API endpoint security (configure in Lambda)
- Secure Google Sheets integration
- Session management

## 🎨 UI/UX Features

- Modern Material Design 3
- Smooth animations and transitions
- Progress indicators and visual feedback
- Responsive layout for all devices
- Accessibility features

## 📈 Monitoring and Analytics

- Training completion rates
- Rider progress tracking
- Attendance monitoring
- Performance metrics

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is proprietary to BlitzNow.

## 🆘 Support

For technical support or questions:
- Create an issue in the repository
- Contact the development team
- Check the configuration files for common issues

## 🔄 Updates and Maintenance

- Regular content updates via configuration files
- Backend API improvements
- UI/UX enhancements
- Performance optimizations

---

**Built with ❤️ for BlitzNow Delivery Partners**
