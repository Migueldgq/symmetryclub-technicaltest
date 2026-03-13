import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/publisher/publisher_cubit.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/publisher/publisher_state.dart';
import 'package:news_app_clean_architecture/injection_container.dart';

class PublisherScreen extends StatelessWidget {
  const PublisherScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PublisherCubit>(),
      child: const _PublisherView(),
    );
  }
}

class _PublisherView extends StatefulWidget {
  const _PublisherView({Key? key}) : super(key: key);

  @override
  State<_PublisherView> createState() => _PublisherViewState();
}

class _PublisherViewState extends State<_PublisherView> {
  final _formKey = GlobalKey<FormState>();
  final _authorController = TextEditingController();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _contentController = TextEditingController();

  Uint8List? _imageBytes;
  String? _imageName;

  @override
  void dispose() {
    _authorController.dispose();
    _titleController.dispose();
    _descController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final bytes = await picked.readAsBytes();
      setState(() {
        _imageBytes = bytes;
        _imageName = '${DateTime.now().millisecondsSinceEpoch}_${picked.name}';
      });
    }
  }

  void _publish() {
    if (_formKey.currentState!.validate()) {
      final article = ArticleEntity(
        author: _authorController.text,
        title: _titleController.text,
        description: _descController.text,
        content: _contentController.text,
        publishedAt: DateTime.now().toIso8601String(),
        url: '',
      );

      context.read<PublisherCubit>().publishArticle(
            article,
            imageBytes: _imageBytes,
            imageName: _imageName,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Publish Article',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocConsumer<PublisherCubit, PublisherState>(
        listener: (context, state) {
          if (state is PublisherSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Awesome! Article published successfully.')),
            );
            Navigator.pop(context);
          } else if (state is PublisherError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          }
        },
        builder: (context, state) {
          if (state is PublisherLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Be a Journalist',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  _buildTextField(
                    controller: _authorController,
                    label: 'Author Name',
                    icon: Icons.person,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _titleController,
                    label: 'Headline / Title',
                    icon: Icons.title,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _descController,
                    label: 'Short Description',
                    icon: Icons.short_text,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _contentController,
                    label: 'Full Article Content',
                    icon: Icons.article,
                    maxLines: 8,
                  ),
                  const SizedBox(height: 16),
                  _buildImagePicker(),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _publish,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('PUBLISH',
                        style: TextStyle(fontSize: 16, color: Colors.white)),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[400]!),
        ),
        child: _imageBytes != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.memory(
                  _imageBytes!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              )
            : const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_photo_alternate, size: 48, color: Colors.grey),
                  SizedBox(height: 8),
                  Text(
                    'Tap to select thumbnail image',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: maxLines == 1 ? Icon(icon) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'This field is required';
        }
        return null;
      },
    );
  }
}
