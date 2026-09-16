import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/asset_model.dart';
import '../repositories/asset_repository.dart';
import '../services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final authService = context.read<AuthService>();

    final user = context.watch<AuthService>().user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Assets'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              authService.signOut();
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: Column(
        children: [
          if (user != null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: FutureBuilder<Map<String, dynamic>?>(
                future: context.read<AssetRepository>().getUserData(user.uid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const LinearProgressIndicator();
                  }

                  final data = snapshot.data;

                  if (data == null) {
                    return Text(
                      user.email ?? 'Authenticated user',
                    );
                  }

                  return ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.person),
                    ),
                    title: Text(
                      data['name'] ?? 'User',
                    ),
                    subtitle: Text(
                      data['email'] ?? user.email ?? '',
                    ),
                  );
                },
              ),
            ),
          Expanded(
            child: StreamBuilder<List<AssetModel>>(
              stream: context.read<AssetRepository>().getAssetsStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return const Center(
                    child: Text(
                      'Failed to load assets.',
                    ),
                  );
                }

                final assets = snapshot.data ?? [];

                if (assets.isEmpty) {
                  return const Center(
                    child: Text(
                      'No assets available.',
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: assets.length,
                  itemBuilder: (context, index) {
                    final asset = assets[index];

                    return Card(
                      margin: const EdgeInsets.only(
                        bottom: 12,
                      ),
                      child: ListTile(
                        leading: const CircleAvatar(
                          child: Icon(
                            Icons.location_city,
                          ),
                        ),
                        title: Text(
                          asset.location,
                        ),
                        subtitle: Text(
                          'ID: ${asset.id}\n'
                          'Status: ${asset.status}\n'
                          'Lat: ${asset.latitude}, '
                          'Lng: ${asset.longitude}',
                        ),
                        isThreeLine: true,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
