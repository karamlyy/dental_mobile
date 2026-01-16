# Caching Strategy Documentation

## Overview

This application implements a **stale-while-revalidate** caching strategy using Hive for local data persistence. This approach provides an excellent user experience by:

- Showing cached data immediately when screens are opened
- Fetching fresh data in the background
- Silently updating the UI when new data arrives
- No loading spinners for returning users

## Architecture

### Components

1. **CacheService** (`lib/core/cache/cache_service.dart`)
   - Central service for all caching operations
   - Uses Hive for fast local storage
   - Provides type-safe methods for each data type

2. **Updated Cubits**
   - `AssistantsCubit`
   - `ServicesCubit`
   - `ExpensesCubit`
   - `CollaborationsCubit`
   - `ProfileCubit`

## How It Works

### Initial Load (No Cache)
```
User opens screen → Loading state → API request → Display data + Cache data
```

### Subsequent Loads (With Cache)
```
User opens screen → Display cached data immediately → API request in background → Update UI with fresh data
```

### Data Flow

1. **User opens a screen** (e.g., Assistants page)
2. **Cubit fetches data**:
   - `fetchAssistants(fromCache: true)` is called
3. **Cache check**:
   - If cache exists → Emit cached data immediately
   - Background request starts to get fresh data
   - When fresh data arrives → Cache is updated → UI updates
4. **No cache**:
   - Show loading state
   - Fetch from API
   - Display and cache the data

## Implementation Details

### CacheService

The `CacheService` provides methods for caching and retrieving data:

```dart
// Initialize (done in main.dart)
final cacheService = CacheService();
await cacheService.init();

// Get cached data
final assistants = cacheService.getCachedAssistants();

// Cache data
await cacheService.cacheAssistants(assistantsList);

// Clear specific cache
await cacheService.delete('assistants');

// Clear all caches (used on logout)
await cacheService.clearAllCaches();
```

### Cubit Pattern

Each cubit follows this pattern:

```dart
Future<void> fetchData({bool fromCache = true}) async {
  // Try cache first
  if (fromCache) {
    final cachedData = cache.getCachedData();
    if (cachedData != null && cachedData.isNotEmpty) {
      emit(DataLoaded(cachedData));
      // Continue fetching in background
      _fetchAndUpdateData();
      return;
    }
  }

  // No cache, show loading
  emit(DataLoading());
  await _fetchAndUpdateData();
}

Future<void> _fetchAndUpdateData() async {
  try {
    final token = await storage.read('accessToken');
    final data = await api.getData(token);
    
    // Cache the fresh data
    await cache.cacheData(data);
    
    emit(DataLoaded(data));
  } catch (e) {
    emit(DataError(error.message));
  }
}
```

### Force Refresh

When data is modified (create, update, delete), we force a fresh fetch by passing `fromCache: false`:

```dart
await api.updateService(token, serviceId, body);
await fetchServices(fromCache: false); // Skip cache
```

## Cache Clearing

### On Logout

When a user logs out, all cached data is automatically cleared:

```dart
// In AuthCubit.logout()
await cache.clearAllCaches();
```

### On 401 Error

When the API returns a 401 (Unauthorized), the `AuthInterceptor` clears all caches:

```dart
// In AuthInterceptor.onError()
if (err.response?.statusCode == 401) {
  await cache.clearAllCaches();
  // Redirect to login
}
```

## Benefits

### User Experience
- ✅ Instant screen loads for returning users
- ✅ No loading spinners after first visit
- ✅ Always getting fresh data in background
- ✅ Smooth, responsive app experience

### Technical
- ✅ Reduced API calls on repeated visits
- ✅ Works offline (shows cached data)
- ✅ Automatic background refresh
- ✅ Type-safe caching implementation
- ✅ Centralized cache management

## Cached Data Types

The following data types are cached:

| Data Type        | Cache Key         | Cubit                |
|-----------------|-------------------|----------------------|
| Assistants      | `assistants`      | `AssistantsCubit`    |
| Services        | `services`        | `ServicesCubit`      |
| Expenses        | `expenses`        | `ExpensesCubit`      |
| Collaborations  | `collaborations`  | `CollaborationsCubit`|
| Profile         | `profile`         | `ProfileCubit`       |

## Configuration

### Hive Initialization

Hive is initialized in `main.dart` before dependency injection:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Initialize Hive cache
  final cacheService = CacheService();
  await cacheService.init();
  
  // Initialize DI with cache service
  await init(cacheService: cacheService);
  
  runApp(App(isLoggedIn: token != null));
}
```

### Dependency Injection

The `CacheService` is registered as a singleton in `lib/config/di.dart`:

```dart
Future<void> init({required CacheService cacheService}) async {
  // Register cache service
  sl.registerLazySingleton<CacheService>(() => cacheService);
  
  // Register cubits with cache dependency
  sl.registerFactory(
    () => AssistantsCubit(
      sl<AssistantsApi>(), 
      sl<SecureStorage>(), 
      sl<CacheService>()
    ),
  );
}
```

## Best Practices

1. **Always use `fromCache: true` for normal screen loads**
   - This is the default parameter value
   - Provides instant UI feedback

2. **Use `fromCache: false` after mutations**
   - After create, update, or delete operations
   - Ensures UI shows the latest server state

3. **Clear cache on logout**
   - Prevents data leakage between users
   - Already implemented in `AuthCubit.logout()`

4. **Handle cache errors gracefully**
   - If cached data is corrupted, fall back to API fetch
   - Example in `ProfileCubit.fetchProfile()`

## Testing Cache Behavior

### Test Stale-While-Revalidate

1. Open the app and navigate to Assistants/Services/Expenses
2. Close and reopen the screen
3. Observe: Data appears instantly (from cache)
4. Wait a moment: UI updates with fresh data (background fetch)

### Test Force Refresh

1. Update/delete an item
2. Observe: The list refreshes immediately with fresh data from API

### Test Cache Clearing

1. Log out of the app
2. Log back in
3. Observe: Loading states appear (cache was cleared)

## Storage Location

Hive stores data in the app's document directory:
- **iOS**: `~/Library/Application Support/<app_name>/`
- **Android**: `/data/data/<package_name>/app_flutter/`

## Future Enhancements

Potential improvements for the caching system:

1. **Cache Expiration**
   - Add timestamps to cached data
   - Invalidate cache after N hours

2. **Cache Size Management**
   - Monitor cache size
   - Implement LRU (Least Recently Used) eviction

3. **Selective Cache Updates**
   - Update only changed items instead of full list refresh
   - Implement delta updates

4. **Offline Support**
   - Queue mutations when offline
   - Sync when connection restored

5. **Cache Analytics**
   - Track cache hit/miss rates
   - Monitor cache effectiveness
