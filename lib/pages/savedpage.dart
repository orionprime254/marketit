import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:marketit/pages/displaypage.dart';
import 'package:provider/provider.dart';
import '../components/item_provider.dart';

class SavedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Items'),
      ),
      body: Consumer<ItemProvider>(
        builder: (context, itemProvider, child) {
          var savedItems = itemProvider.savedItems;

          if (savedItems.isEmpty) {
            return Center(child: Text('No saved items.'));
          }

          return ListView.builder(
            itemCount: savedItems.length,
            itemBuilder: (context, index) {
              var item = savedItems[index];

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).colorScheme.primary,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 4,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: CachedNetworkImage(
                      imageUrl: item.imageUrl,
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                      // height: 50,
                      // width: double.infinity,
                      // fit: BoxFit.cover,
                    ),
                    title: Text(item.title),
                    subtitle: Text('Ksh' + item.price),
                    trailing: IconButton(
                      icon: Icon(Icons.cancel),
                      onPressed: () {
                        itemProvider.removeItem(item.id);
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DisplayPage(
                            imageUrls: [item.imageUrl],
                            name: item.title,
                            price: item.price,
                            description: item.description,
                            userEmail: item.userId,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
