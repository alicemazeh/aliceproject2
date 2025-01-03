import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'item_menu.dart';
import 'cart.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});
  @override
  _MenuState createState() => _MenuState();
}
class _MenuState extends State<Menu> {
  int _selectedIndex = 0;
  int _foodCategoryIndex = 0;
  int _drinkCategoryIndex = 0;
  int _dessertCategoryIndex = 0;
  List<FoodItem> _foodItems = [];
  final List<CartItem> _cartItems = [];
  String _selectionTitle = 'Select Food Category';
  final ScrollController _scrollController = ScrollController();
  final String _apiUrl = 'http://alicemazeh2.atwebpages.com/getFood.php';
  @override
  void initState() {
    super.initState();
    _fetchFoodItems();
  }
  Future<void> _fetchFoodItems() async {
    try {
      final response = await http.get(Uri.parse('http://alicemazeh2.atwebpages.com/getFood.php'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        setState(() {
          _foodItems = data.map((json) => FoodItem.fromJson(json)).toList();
        });
      } else {
        print('Failed to load food items');
      }
    } catch (e) {
      print('Error fetching food items: $e');
    }
  }

  void _addToCart(FoodItem foodItem) {
    setState(() {
      bool itemExists = _cartItems.any((item) => item.foodItem.name == foodItem.name);
      if (itemExists) {
        _cartItems.firstWhere((item) => item.foodItem.name == foodItem.name).quantity++;
      } else {
        _cartItems.add(CartItem(foodItem: foodItem));
      }
    });
  }

  int get _totalCartItems {
    return _cartItems.fold(0, (sum, item) => sum + item.quantity);
  }

  Widget _buildFoodOptions(List<String> categories) {
    List<FoodItem> filteredItems = _foodItems.where((item) {
      return categories.any((category) => item.name.contains(category));
    }).toList();
    double screenWidth = MediaQuery.of(context).size.width;
    double childAspectRatio;
    if (screenWidth <= 645) {
      childAspectRatio = 0.5;
    } else if (screenWidth <= 1267) {
      childAspectRatio = 1.0;
    } else {
      childAspectRatio = 2.0;
    }
    return GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(8.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: filteredItems.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => _addToCart(filteredItems[index]),
          child: Card(
            elevation: 2.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 10.0),
                Image.asset(
                  filteredItems[index].image,
                  height: 200.0,
                  width: 200.0,
                  errorBuilder: (context, error, stackTrace) {
                    print('Failed to load asset image: ${filteredItems[index].image}');
                    return Center(child: Text('Image not available'));
                  },
                ),
                const SizedBox(height: 8.0),
                Text(filteredItems[index].name, style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                Text('\$${filteredItems[index].price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 14.0)),
                const SizedBox(height: 8.0),
                const Icon(Icons.add_circle, color: Color(0xFFD3131D)),
                const SizedBox(height: 10.0),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _foodCategoryIndex = 0;
      _drinkCategoryIndex = 0;
      _dessertCategoryIndex = 0;
      switch (_selectedIndex) {
        case 0:
          _selectionTitle = 'Select Food Category';
          break;
        case 1:
          _selectionTitle = 'Pick a Drink';
          break;
        case 2:
          _selectionTitle = 'Choose Your Dessert';
          break;
      }
    });
    _scrollController.jumpTo(_scrollController.position.minScrollExtent);
  }

  void _resetSelection() {
    setState(() {
      _cartItems.clear();
    });
  }

  void _toggleShowSelected() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return CartPage(cartItems: _cartItems);
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          var tween = Tween(begin: begin, end: end);
          var offsetAnimation = animation.drive(tween.chain(CurveTween(curve: curve)));

          return SlideTransition(position: offsetAnimation, child: child);
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Menu', style: TextStyle(color: Colors.white, fontFamily: 'PlayfairDisplay')),
        centerTitle: true,
        backgroundColor: const Color(0xFFD3131D),
        actions: [
          Tooltip(
            message: 'Reset Cart',
            child: IconButton(
              color: Colors.white,
              onPressed: _resetSelection,
              icon: const Icon(Icons.restore),
            ),
          ),
          Tooltip(
            message: 'Show Cart',
            child: Stack(
              children: [
                IconButton(
                  color: Colors.white,
                  onPressed: _toggleShowSelected,
                  icon: const Icon(Icons.shopping_cart),
                ),
                if (_totalCartItems > 0) ...[
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 10,
                        minHeight: 10,
                      ),
                      child: Center(
                        child: Text(
                          _totalCartItems.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 10.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _selectionTitle,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'PlayfairDisplay'),
                textAlign: TextAlign.center,
              ),
            ),
            if (_selectedIndex == 0) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.resolveWith<Color>(
                            (states) => const Color(0xFFD3131D),
                      ),
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        _foodCategoryIndex = 0;
                        _selectionTitle = 'Sandwiches';
                      });

                      _scrollController.jumpTo(_scrollController.position.minScrollExtent);
                    },
                    child: const Text('Sandwiches', style: TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(width: 10,),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.resolveWith<Color>(
                            (Set<WidgetState> states) => const Color(0xFFD3131D),
                      ),
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        _foodCategoryIndex = 1;
                        _selectionTitle = 'Plates';
                      });
                      // Scroll to the top when switching categories
                      _scrollController.jumpTo(_scrollController.position.minScrollExtent);
                    },
                    child: const Text('Plates', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
              Expanded(
                child: _foodCategoryIndex == 0
                    ? _buildFoodOptions(['Sandwich','Burger'])
                    : _buildFoodOptions(['Plate','Pizza','Pasta','Fries','Salad']),
              ),
            ] else if (_selectedIndex == 1) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.resolveWith<Color>(
                            (Set<WidgetState> states) => const Color(0xFFD3131D),
                      ),
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        _drinkCategoryIndex = 0;
                        _selectionTitle = 'Cold Drinks';
                      });
                      _scrollController.jumpTo(_scrollController.position.minScrollExtent);
                    },
                    child: const Text('Cold Drinks', style: TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(width: 10,),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.resolveWith<Color>(
                            (Set<WidgetState> states) => const Color(0xFFD3131D),
                      ),
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        _drinkCategoryIndex = 1;
                        _selectionTitle = 'Hot Drinks';
                      });
                      // Scroll to the top when switching categories
                      _scrollController.jumpTo(_scrollController.position.minScrollExtent);
                    },
                    child: const Text('Hot Drinks', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
              Expanded(
                child: _drinkCategoryIndex == 0
                    ? _buildFoodOptions(['Cold','Iced','Smoothie'])
                    : _buildFoodOptions(['Hot','Cappuccino']),
              ),
            ] else if (_selectedIndex == 2) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.resolveWith<Color>(
                            (Set<WidgetState> states) => const Color(0xFFD3131D),
                      ),
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        _dessertCategoryIndex = 0;
                        _selectionTitle = 'Sweet Desserts';
                      });
                      // Scroll to the top when switching categories
                      _scrollController.jumpTo(_scrollController.position.minScrollExtent);
                    },
                    child: const Text('Sweet Desserts', style: TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(width: 10,),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.resolveWith<Color>(
                            (Set<WidgetState> states) => const Color(0xFFD3131D),
                      ),
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        _dessertCategoryIndex = 1;
                        _selectionTitle = 'Sour Desserts';
                      });
                      // Scroll to the top when switching categories
                      _scrollController.jumpTo(_scrollController.position.minScrollExtent);
                    },
                    child: const Text('Sour Desserts', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
              Expanded(
                child: _dessertCategoryIndex == 0
                    ? _buildFoodOptions(['Crepe','Cake','Cream','Tiramisu','Waffle','Cinnamon'])
                    : _buildFoodOptions(['Sour','Pie','Lime','Sushi','Fruit','Blueberry','Crumble']),
              ),
            ],
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFFD3131D),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.fastfood), label: 'Food'),
          BottomNavigationBarItem(icon: Icon(Icons.local_cafe_outlined), label: 'Drink'),
          BottomNavigationBarItem(icon: Icon(Icons.cake), label: 'Dessert'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }
}