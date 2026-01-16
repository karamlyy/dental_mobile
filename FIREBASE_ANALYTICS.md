# Firebase Analytics Integration

Firebase Analytics has been successfully integrated into the Dental Mobile app to track user behavior and important statistics.

## 📊 What's Being Tracked

### 1. **Authentication Events**
- **User Registration** (`sign_up`)
  - Method: email
  - User properties: specialization
- **User Login** (`login`)
  - Method: email
  - User properties: role
- **User Logout** (`logout`)

### 2. **Screen Views** (Automatic)
All screen navigation is automatically tracked using `FirebaseAnalyticsObserver`:
- Login Page
- Register Page
- Home Page
- Patients Page
- Patient Detail Page
- Appointments Page
- Services Page
- Assistants Page
- Expenses Page
- Collaborations Page
- Profile Page
- Edit Profile Page

### 3. **Patient Operations**
- **Patient Created** (`patient_created`)
  - Parameters: patient_id
- **Patient Viewed** (`patient_viewed`)
  - Parameters: patient_id
- **Patient Updated** (`patient_updated`)
  - Parameters: patient_id
- **Patient Deleted** (`patient_deleted`)
  - Parameters: patient_id

### 4. **Appointment Events**
- **Appointment Created** (`appointment_created`)
  - Parameters: appointment_id, patient_id
- **Appointment Updated** (`appointment_updated`)
  - Parameters: appointment_id
- **Appointment Deleted** (`appointment_deleted`)
  - Parameters: appointment_id
- **Appointment Completed** (`appointment_completed`)
  - Parameters: appointment_id

### 5. **Treatment Events**
- **Treatment Created** (`treatment_created`)
  - Parameters: treatment_id, patient_id, treatment_type
- **Treatment Updated** (`treatment_updated`)
  - Parameters: treatment_id

### 6. **Service Events**
- **Service Created** (`service_created`)
  - Parameters: service_id, service_name
- **Service Updated** (`service_updated`)
  - Parameters: service_id
- **Service Deleted** (`service_deleted`)
  - Parameters: service_id

### 7. **Expense Events**
- **Expense Created** (`expense_created`)
  - Parameters: expense_id, amount, category
- **Expense Updated** (`expense_updated`)
  - Parameters: expense_id
- **Expense Deleted** (`expense_deleted`)
  - Parameters: expense_id

### 8. **Assistant Events**
- **Assistant Created** (`assistant_created`)
  - Parameters: assistant_id, name
- **Assistant Updated** (`assistant_updated`)
  - Parameters: assistant_id
- **Assistant Deleted** (`assistant_deleted`)
  - Parameters: assistant_id

### 9. **Collaboration Events**
- **Collaboration Created** (`collaboration_created`)
  - Parameters: collaboration_id, type

### 10. **Profile Events**
- **Profile Viewed** (`profile_viewed`)
- **Profile Updated** (`profile_updated`)

### 11. **Settings Events**
- **Theme Changed** (`theme_changed`)
  - Parameters: theme (light/dark/system)
- **Language Changed** (`language_changed`)
  - Parameters: language (az/en/ru)

### 12. **Search Events**
- **Search Performed** (`search`)
  - Parameters: search_term, category

### 13. **Error Events**
- **Error Occurred** (`error_occurred`)
  - Parameters: error_message, error_code, screen

## 🔧 How It Works

### AnalyticsService
A centralized service (`lib/core/analytics/analytics_service.dart`) handles all analytics tracking. This service:
- Wraps Firebase Analytics API
- Provides type-safe methods for each event
- Includes debug logging in development mode
- Handles errors gracefully

### Integration Points

1. **Dependency Injection** (`lib/config/di.dart`)
   - `AnalyticsService` is registered as a singleton
   - Injected into all relevant Cubits

2. **Navigation Observer** (`lib/app.dart`)
   - `FirebaseAnalyticsObserver` automatically tracks screen views
   - Attached to MaterialApp's navigatorObservers

3. **Cubit Integration**
   - `AuthCubit`: Tracks login, register, logout
   - `AddPatientCubit`: Tracks patient creation
   - `ServiceCreationCubit`: Tracks service creation
   - `ExpenseCreationCubit`: Tracks expense creation
   - `AssistantCreationCubit`: Tracks assistant creation
   - `CollaborationCreationCubit`: Tracks collaboration creation
   - `ThemeCubit`: Tracks theme changes
   - `LocaleCubit`: Tracks language changes

## 📱 Viewing Analytics

### Firebase Console
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project
3. Navigate to **Analytics** > **Dashboard**
4. View real-time events and user behavior

### Key Metrics to Monitor
- **Daily Active Users (DAU)**
- **Screen Views**: Which screens are most used
- **Patient Operations**: How many patients are being created/viewed
- **Appointment Activity**: Appointment creation and completion rates
- **Feature Usage**: Which features (services, expenses, etc.) are most used
- **User Retention**: How often users return
- **Theme Preference**: Light vs Dark mode usage
- **Language Preference**: Which languages users prefer

## 🎯 Custom Events

You can log custom events using the `AnalyticsService`:

```dart
// Get the analytics service
final analytics = sl<AnalyticsService>();

// Log a custom event
await analytics.logCustomEvent(
  eventName: 'custom_event_name',
  parameters: {
    'param1': 'value1',
    'param2': 123,
  },
);
```

## 🔍 Debugging

In debug mode, all analytics events are logged to the console with the prefix `Analytics:`:

```
Analytics: Login with email
Analytics: Patient created: 123
Analytics: Theme changed to dark
```

## ⚙️ Configuration

No additional configuration is needed. Analytics uses the existing Firebase setup:
- iOS: `ios/Runner/GoogleService-Info.plist`
- Android: `android/app/google-services.json`

## 📦 Dependencies

```yaml
firebase_core: ^4.3.0
firebase_analytics: ^12.1.0
```

## 🚀 Benefits

1. **User Behavior Insights**: Understand how users interact with the app
2. **Feature Usage**: Identify which features are most/least used
3. **Performance Tracking**: Monitor patient, appointment, and service operations
4. **User Segmentation**: Analyze user behavior by role, language, theme preference
5. **Data-Driven Decisions**: Make informed decisions about feature development
6. **Retention Analysis**: Track user engagement over time
7. **Error Monitoring**: Combined with Crashlytics for complete monitoring

## 🔐 Privacy

- User IDs are tracked but can be anonymized
- No personally identifiable information (PII) is logged
- Analytics data is stored securely by Firebase
- Complies with Firebase's privacy policies

## 📝 Notes

- Analytics events may take up to 24 hours to appear in the Firebase Console
- Debug mode events appear immediately in DebugView
- Some events are automatically tracked by Firebase (app_open, first_open, etc.)
- Custom dimensions and metrics can be configured in Firebase Console
