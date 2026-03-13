import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/repository/article_repository.dart';

class MockArticleRepository implements ArticleRepository {
  final List<ArticleEntity> _savedArticles = [];
  final List<ArticleEntity> _publishedArticles = [];

  static final List<ArticleEntity> _fakeArticles = [
    const ArticleEntity(
      id: 1,
      author: 'John Doe',
      title: 'Flutter 4.0 Released with Revolutionary Features',
      description:
          'Google announces Flutter 4.0 with groundbreaking performance improvements and new widgets that simplify cross-platform development.',
      url: 'https://example.com/flutter-4',
      urlToImage: 'https://picsum.photos/seed/flutter/800/400',
      publishedAt: '2026-03-13',
      content:
          'Flutter 4.0 brings a complete overhaul of the rendering engine, making apps faster than ever before. The new release includes improved hot reload, better web support, and a redesigned widget catalog.',
    ),
    const ArticleEntity(
      id: 2,
      author: 'Jane Smith',
      title: 'The Future of Mobile Development in 2026',
      description:
          'Industry experts weigh in on the trends shaping mobile app development this year, from AI integration to cross-platform frameworks.',
      url: 'https://example.com/mobile-future',
      urlToImage: 'https://picsum.photos/seed/mobile/800/400',
      publishedAt: '2026-03-12',
      content:
          'Mobile development continues to evolve rapidly. Cross-platform solutions are becoming the norm, with Flutter and React Native leading the charge. AI-powered features are now expected in every major app.',
    ),
    const ArticleEntity(
      id: 3,
      author: 'Carlos García',
      title: 'Firebase Firestore: Best Practices for Scalable Apps',
      description:
          'Learn the best practices for designing Firestore schemas that scale with your application as it grows.',
      url: 'https://example.com/firestore-tips',
      urlToImage: 'https://picsum.photos/seed/firebase/800/400',
      publishedAt: '2026-03-11',
      content:
          'Designing a good Firestore schema is crucial for app performance. This guide covers denormalization strategies, subcollection patterns, and security rules that keep your data safe.',
    ),
    const ArticleEntity(
      id: 4,
      author: 'Sarah Johnson',
      title: 'Clean Architecture in Flutter: A Practical Guide',
      description:
          'How to structure your Flutter projects using clean architecture principles for maintainable and testable code.',
      url: 'https://example.com/clean-arch',
      urlToImage: 'https://picsum.photos/seed/architecture/800/400',
      publishedAt: '2026-03-10',
      content:
          'Clean architecture separates your code into layers: domain, data, and presentation. This separation makes your code easier to test, maintain, and scale over time.',
    ),
    const ArticleEntity(
      id: 5,
      author: 'Mike Chen',
      title: 'State Management Wars: BLoC vs Riverpod in 2026',
      description:
          'A comprehensive comparison of the two most popular state management solutions in the Flutter ecosystem.',
      url: 'https://example.com/bloc-vs-riverpod',
      urlToImage: 'https://picsum.photos/seed/statemgmt/800/400',
      publishedAt: '2026-03-09',
      content:
          'BLoC remains a solid choice for enterprise applications due to its strict separation of concerns. Riverpod offers a more flexible approach with less boilerplate. Both are production-ready.',
    ),
  ];

  @override
  Future<DataState<List<ArticleEntity>>> getNewsArticles() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return DataSuccess([..._fakeArticles, ..._publishedArticles]);
  }

  @override
  Future<List<ArticleEntity>> getSavedArticles() async {
    return _savedArticles;
  }

  @override
  Future<void> saveArticle(ArticleEntity article) async {
    _savedArticles.add(article);
  }

  @override
  Future<void> removeArticle(ArticleEntity article) async {
    _savedArticles.removeWhere((a) => a.id == article.id);
  }

  @override
  Future<void> publishArticle(ArticleEntity article) async {
    _publishedArticles.add(article);
  }
}
