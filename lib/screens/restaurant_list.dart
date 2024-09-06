import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/data_provider.dart';

// the function berlow displays the list of restaurants and includes a search bar to filter the list.

class RestaurantList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final restaurantAsyncValue = ref.watch(restaurantProvider);
    final searchQuery = ref.watch(searchQueryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant List'),
        centerTitle: true, 
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Search restaurants',
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
              ),
              onChanged: (query) {
                ref.read(searchQueryProvider.notifier).state = query;
              },
            ),
            const SizedBox(height: 16), 
            Expanded(
              child: restaurantAsyncValue.when(
                data: (restaurants) {
                  final filteredRestaurants = restaurants
                      .where((restaurant) =>
                          restaurant.name.toLowerCase().contains(searchQuery.toLowerCase()))
                      .toList();

                  // ListView of restaurant cards
                  return ListView.builder(
                    itemCount: filteredRestaurants.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 2.0,
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                          leading: CircleAvatar(
                            backgroundColor: Colors.deepPurpleAccent,
                            child: Text(
                              filteredRestaurants[index].name[0].toUpperCase(),
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          // displaying the naem of the restaurants.
                          title: Text(
                            filteredRestaurants[index].name,
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                          ),
                          trailing: Icon(Icons.arrow_forward_ios, size: 16.0, color: Colors.grey),
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(child: Text('Error: $err')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
