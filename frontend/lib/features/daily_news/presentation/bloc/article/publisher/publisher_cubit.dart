import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/usecases/publish_article.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/publisher/publisher_state.dart';

class PublisherCubit extends Cubit<PublisherState> {
  final PublishArticleUseCase _publishArticleUseCase;

  PublisherCubit(this._publishArticleUseCase) : super(PublisherInitial());

  Future<void> publishArticle(ArticleEntity article, {Uint8List? imageBytes, String? imageName}) async {
    emit(PublisherLoading());
    try {
      String imageUrl = article.urlToImage ?? '';

      if (imageBytes != null && imageName != null) {
        final ref = FirebaseStorage.instance
            .ref()
            .child('media/articles/$imageName');
        final uploadTask = await ref.putData(imageBytes);
        imageUrl = await uploadTask.ref.getDownloadURL();
      }

      final articleWithImage = ArticleEntity(
        id: article.id,
        author: article.author,
        title: article.title,
        description: article.description,
        url: article.url,
        urlToImage: imageUrl,
        publishedAt: article.publishedAt,
        content: article.content,
      );

      await _publishArticleUseCase(params: articleWithImage);
      emit(PublisherSuccess());
    } catch (e) {
      emit(PublisherError(e.toString()));
    }
  }
}
