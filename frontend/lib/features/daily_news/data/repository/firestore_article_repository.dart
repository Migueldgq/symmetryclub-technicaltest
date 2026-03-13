import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/repository/article_repository.dart';

class FirestoreArticleRepository implements ArticleRepository {
  final FirebaseFirestore _firestore;
  final List<ArticleEntity> _savedArticles = [];

  FirestoreArticleRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference get _articlesCollection =>
      _firestore.collection('articles');

  @override
  Future<DataState<List<ArticleEntity>>> getNewsArticles() async {
    try {
      print('Fetching articles from Firestore...');
      final snapshot = await _articlesCollection
          .orderBy('publishedAt', descending: true)
          .get();
      print('Got ${snapshot.docs.length} articles from Firestore');

      final articles = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return ArticleEntity(
          id: doc.id.hashCode,
          author: data['author'] as String?,
          title: data['title'] as String?,
          description: data['description'] as String?,
          url: data['url'] as String?,
          urlToImage: data['urlToImage'] as String?,
          publishedAt: data['publishedAt'] is Timestamp
              ? (data['publishedAt'] as Timestamp).toDate().toIso8601String()
              : data['publishedAt'] as String?,
          content: data['content'] as String?,
        );
      }).toList();

      return DataSuccess(articles);
    } on Exception catch (e) {
      print('Firestore error: $e');
      return DataFailed(e);
    } catch (e) {
      print('Unexpected error: $e');
      return DataFailed(Exception(e.toString()));
    }
  }

  @override
  Future<void> publishArticle(ArticleEntity article) async {
    print('Publishing article: ${article.title}');
    try {
      final docRef = await _articlesCollection.add({
        'author': article.author ?? '',
        'title': article.title ?? '',
        'description': article.description ?? '',
        'url': article.url ?? '',
        'urlToImage': article.urlToImage ?? '',
        'publishedAt': Timestamp.now(),
        'content': article.content ?? '',
      });
      print('Article published with ID: ${docRef.id}');
    } catch (e) {
      print('Error publishing article: $e');
      rethrow;
    }
  }

  @override
  Future<List<ArticleEntity>> getSavedArticles() async {
    return List.from(_savedArticles);
  }

  @override
  Future<void> saveArticle(ArticleEntity article) async {
    _savedArticles.add(article);
  }

  @override
  Future<void> removeArticle(ArticleEntity article) async {
    _savedArticles.removeWhere((a) => a.id == article.id);
  }
}
