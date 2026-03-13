# Project Report

## 1. Introduction

When I first received this technical test, I'll be completely honest: I had very little experience with Flutter. My background is not in mobile/frontend development with Dart, so this project represented a genuine challenge and learning opportunity. My initial feeling was a mix of excitement and uncertainty, the project structure looked well-organized but the technologies (Flutter, BLoC, Firebase) were largely new to me.

I want to be fully transparent about my approach: I used **Claude Code (AI assistant)** extensively throughout this project. Symmetry values "Truth is King," and in that spirit, I believe it's important to acknowledge that AI was a core part of my workflow. I didn't just copy-paste solutions — I worked interactively with the AI, asking questions, debugging together, and making decisions along the way. Every line of code went through my understanding before being committed, and I learned a tremendous amount in the process.

## 2. Learning Journey

### Technologies I Learned

- **Flutter & Dart**: I started with zero practical experience. I learned about widgets, the widget tree, StatelessWidget vs HookWidget, navigation, and Flutter's web platform limitations.
- **Flutter BLoC**: Understanding the BLoC pattern (Events → Bloc → States) and Cubits was critical. I learned how Equatable works for state comparison, how BlocProvider injects blocs, and how BlocBuilder rebuilds UI reactively.
- **Firebase**: I set up Firestore as the database, Cloud Storage for article images, deployed Firestore security rules, and configured CORS for web compatibility.

### Resources Used

- The project's own documentation (`APP_ARCHITECTURE.md`, `CONTRIBUTION_GUIDELINES.md`) was very helpful for understanding the codebase structure.
- Flutter and Firebase official documentation.
- Claude Code as an interactive learning tool — rather than passively reading tutorials, I learned by doing, asking questions when I got stuck, and understanding the "why" behind each solution.

### How I Applied My Knowledge

The biggest application of my learning was building the **article publishing feature** end-to-end:
1. Designed the Firestore schema and security rules (backend)
2. Created `FirestoreArticleRepository` to replace the API-based data layer (data layer)
3. Built `PublishArticleUseCase` following Clean Architecture principles (domain layer)
4. Created `PublisherCubit` with proper state management (presentation/business logic)
5. Built the publisher screen UI with image upload (presentation layer)

## 3. Challenges Faced

### Challenge 1: Flutter Web Compatibility
**Problem**: The app showed a blank page on Chrome. The original codebase used `dart:io` (not available on web) and `sqflite` (uses native platform APIs).
**Solution**: Removed `dart:io` imports, replaced `HttpStatus.ok` with literal `200`, and eventually replaced the SQLite-based local storage with an in-memory solution for web compatibility.
**Lesson**: Flutter web has significant platform limitations that aren't always obvious from the code.

### Challenge 2: CORS Issues
**Problem**: The original NewsAPI blocked browser requests due to CORS. Later, Firebase Storage images also had CORS issues.
**Solution**: Replaced the external API with Firestore (eliminating the first CORS issue). For Storage, configured CORS with `gsutil cors set`.
**Lesson**: Web apps face unique networking constraints that native apps don't.

### Challenge 3: The "Silent Mock" Bug
**Problem**: After building the entire publish flow, articles weren't appearing in Firestore. The console showed "MOCK: Article published successfully!" — the use case was still mocked with a `print` statement and `Future.delayed` instead of calling the actual repository.
**Solution**: Updated `PublishArticleUseCase` to call `_articleRepository.publishArticle(params!)`.
**Lesson**: Always trace the full execution path. Debug prints saved me here — seeing "MOCK:" in the console immediately pointed to the problem.

### Challenge 4: Equatable and State Management
**Problem**: The saved articles remove button appeared to do nothing. The article was being removed from the list, but BLoC wasn't emitting a new state.
**Solution**: Two issues: (1) `getSavedArticles` returned the same list reference, and Equatable compared references, concluding the state hadn't changed. Fixed by returning `List.from(_savedArticles)`. (2) Nested `GestureDetector` tap conflicts — replaced with `IconButton`.
**Lesson**: Equatable's equality check is powerful but can be tricky with mutable collections.

### Challenge 5: Null Safety in Equatable Props
**Problem**: The app crashed with null errors in `RemoteArticlesState.props` because nullable fields (`articles`, `error`) were accessed with `!`.
**Solution**: Changed `List<Object>` to `List<Object?>` in props getters across multiple state classes.
**Lesson**: Dart's null safety requires careful attention, especially in abstract base classes.

## 4. Reflection and Future Directions

### What I Learned

**Technically:**
- Flutter's widget composition model and how BLoC provides clean state management
- Firebase's ecosystem (Firestore, Storage, Rules, CLI tooling)

**Professionally:**
- "Truth is King" resonates with me. Being honest about using AI assistance is more valuable than pretending I did everything from memory.

### Future Improvements

If I had more time, I would:

1. **User Authentication**: Add Firebase Auth so articles are associated with specific journalists. This would enable author profiles and article ownership.
2. **Article Editing/Deletion**: Allow authors to edit or delete their published articles from the main feed.
3. **Rich Text Editor**: Replace the plain text content field with a rich text editor for better article formatting.
4. **Categories & Tags**: Add article categorization so users can filter news by topic.
5. **Search Functionality**: Implement full-text search across article titles and content.
6. **Offline Support**: Use Firestore's offline persistence to allow reading articles without internet.
7. **Push Notifications**: Notify users when new articles are published.
8. **Image Optimization**: Compress images before upload and generate thumbnails for the article list.
9. **Pagination**: Implement lazy loading for the article list instead of fetching all articles at once.
10. **Testing**: Add unit tests for blocs/cubits and widget tests for key screens.

## 5. Proof of the Project

https://youtube.com/shorts/q71ZJ8WruzE?feature=share

### Features Implemented

1. **Article Feed**: Displays all published articles from Firestore, ordered by date (newest first).
2. **Article Detail View**: Shows full article with title, date, image, description, and content.
3. **Article Publishing**: Journalists can create articles with title, description, content, and an image uploaded to Firebase Cloud Storage.
4. **Image Upload**: Uses `image_picker` to select images from the device, uploads to Firebase Storage under `media/articles/`.
5. **Save Articles Locally**: Bookmark articles for quick access.
6. **Remove Saved Articles**: Remove bookmarked articles from the saved list.
7. **Date Formatting**: Articles display formatted dates (e.g., "Mar 5, 2026 • 3:45 PM").
8. **Empty State**: Shows a helpful message when no articles exist yet.
9. **Firestore Security Rules**: Backend enforces schema validation on article documents.

*Screenshots should be added here showing the app in action.*

## 6. Overdelivery

### 1. New Features Implemented

- **Image Upload via Picker**: The original approach would have required journalists to manually enter image URLs. I replaced this with a proper image picker that uploads directly to Firebase Cloud Storage, making the UX much more intuitive.

### 2. Prototypes and Ideas

- **DB Schema Documentation**: Created `backend/docs/DB_SCHEMA.md` documenting the Firestore schema design decisions.
- **Firestore Security Rules**: Implemented validation rules in `backend/firestore.rules` to enforce data integrity at the backend level.

### 3. How Can This Be Improved

- **Real-time Updates**: Use Firestore snapshots instead of one-time reads so the article feed updates in real-time when new articles are published by other users.
- **Image Compression**: Add client-side image compression before upload to reduce storage costs and improve load times.
- **Article Draft System**: Allow journalists to save drafts before publishing.
- **Comment System**: Add a comments collection as a subcollection of articles for reader engagement.
- **Analytics Dashboard**: Track article views and engagement metrics.
- **Multi-platform**: The app currently runs on web; with minimal changes to the data layer (replacing in-memory saved articles with Firestore or Hive), it could work seamlessly on iOS and Android.

## 7. Extra Sections

