import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../controllers/favourite-controller.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  final FavoriteController _favoriteController = Get.put(FavoriteController());

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _favoriteController.getFavoritesStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final favorites = snapshot.data!.docs.map((doc) => doc.data() as dynamic).toList();

            return ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final item = favorites[index];
                return TripCard(
                  location: item['fullPrice'] as String,
                  name: item['deliveryTime'] as String,
                  imageUrl: item['productImages'][0] as String,
                  height: 230,
                  width: 500,
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      );
  }
}

class TripCard extends StatelessWidget {
  final String location;
  final String name;
  final String imageUrl;
  final double width;
  final double height;

  TripCard({
    required this.location,
    required this.name,
    required this.imageUrl,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: InkWell(
          child: Column(
            children: [
              Image(
                image: imageUrl.isNotEmpty
                    ? NetworkImage(imageUrl)
                    : AssetImage('assets/placeholder_image.png') as ImageProvider,
                fit: BoxFit.cover,
              ),
              ListTile(
                title: Text(name.isNotEmpty ? name : 'Unknown Name'),
                trailing: Icon(Icons.location_on),
                subtitle: Text(location.isNotEmpty ? location : 'Unknown Location'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
