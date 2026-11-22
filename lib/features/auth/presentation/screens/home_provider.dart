  import 'package:flutter/material.dart';
  import 'package:go_router/go_router.dart';
  import 'package:supabase_flutter/supabase_flutter.dart';

  class HomeProvider extends StatelessWidget {
    const HomeProvider({super.key});

    @override
    Widget build(BuildContext context) {
      final user = Supabase.instance.client.auth.currentUser;

      return Scaffold(
        appBar: AppBar(
          title: const Text('Home Provider'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                await Supabase.instance.client.auth.signOut();
                if (context.mounted) context.go('/loginUser');
              },
            ),
          ],
        ),
        body: Center(
          child: Text(user?.email ?? 'No user'),
        ),
      );
    }
  }