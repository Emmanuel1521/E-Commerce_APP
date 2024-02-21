import 'package:flutter/material.dart';

void main() {
  runApp(ECommerceApp());
}

class ECommerceApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Commerce App',
      theme: ThemeData(
        primaryColor: Colors.indigo, // Updated primary color
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.indigo, accentColor: Colors.pink), // Updated color scheme
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginPage(),
    );
  }
}

class User {
  final String username;
  final String password;

  User(this.username, this.password);
}

class LoginPage extends StatelessWidget {
  final List<User> registeredUsers = [
    User('user1', 'password1'),
    User('user2', 'password2'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: LoginForm(registeredUsers: registeredUsers),
    );
  }
}

class LoginForm extends StatefulWidget {
  final List<User> registeredUsers;

  const LoginForm({Key? key, required this.registeredUsers}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _errorMessage = '';
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: _usernameController,
            decoration: InputDecoration(
              labelText: 'Username',
              border: OutlineInputBorder(), // Add border
            ),
          ),
          SizedBox(height: 16.0),
          TextField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(), // Add border
              suffixIcon: IconButton(
                icon: Icon(_isPasswordVisible ? Icons.visibility_off : Icons.visibility),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              ),
            ),
            obscureText: !_isPasswordVisible,
          ),
          SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () {
              // Validate login credentials
              String enteredUsername = _usernameController.text;
              String enteredPassword = _passwordController.text;
              bool isValidUser = false;

              for (User user in widget.registeredUsers) {
                if (user.username == enteredUsername && user.password == enteredPassword) {
                  isValidUser = true;
                  break;
                }
              }

              if (isValidUser) {
                // Authentication successful, navigate to ProductPage
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProductPage()),
                );
              } else {
                // Display error message for incorrect username or password
                setState(() {
                  _errorMessage = 'Incorrect username or password';
                });
              }
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0), // Add padding
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0), // Add border radius
              ),
            ),
            child: Text('Login', style: TextStyle(fontSize: 18.0)), // Increase font size
          ),
          SizedBox(height: 8.0),
          Text(
            _errorMessage,
            style: TextStyle(color: Colors.red),
          ),
                    SizedBox(height: 20.0),
          Text(
            'If you don\'t have an account, please create one.',
            style: TextStyle(color: Colors.blueAccent),
          ),
          SizedBox(height: 20.0),
          TextButton(
            onPressed: () {
              // Navigate to RegistrationPage and pass the registeredUsers list
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RegistrationPage(registeredUsers: widget.registeredUsers)),
              );
            },
            child: Text('Create an account', style: TextStyle(color: Colors.indigo)), // Change text color
          ),
        ],
      ),
    );
  }
}

class RegistrationPage extends StatelessWidget {
  final List<User> registeredUsers;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  RegistrationPage({required this.registeredUsers});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(), // Add border
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(), // Add border
              ),
              obscureText: true,
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Register new user
                String newUsername = _usernameController.text;
                String newPassword = _passwordController.text;

                if (newUsername.isNotEmpty && _isStrongPassword(newPassword)) {
                  // Add the new user to the list of registered users
                  registeredUsers.add(User(newUsername, newPassword));
                  Navigator.pop(context); // Navigate back to LoginPage
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Registration successful. You can now login.')),
                  );
                } else {
                  // Display error message for missing username or weak password
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter a username and a strong password (8 characters long, at least one capital letter, and one number)')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0), // Add padding
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0), // Add border radius
                ),
              ),
              child: Text('Register', style: TextStyle(fontSize: 18.0)), // Increase font size
            ),
            SizedBox(height: 20.0),
            Text('If you already have an account, please login instead.', style: TextStyle(color: Colors.blueAccent)),
          ],
        ),
      ),
    );
  }

  // Function to check if the password is strong
  bool _isStrongPassword(String password) {
    // Check if password length is at least 8 characters
    if (password.length < 8) {
      return false;
    }

    // Check if password contains at least one capital letter
    if (!password.contains(RegExp(r'[A-Z]'))) {
      return false;
    }

    // Check if password contains at least one number
    if (!password.contains(RegExp(r'[0-9]'))) {
      return false;
    }

    return true;
  }
}


class Product {
  final String name;
  final double price;
  final String description;
  final String imageUrl;
  int quantity; // Added quantity property

  Product({
    required this.name,
    required this.price,
    required this.description,
    required this.imageUrl,
    this.quantity = 1, // Initialized quantity to 1 by default
  });
}

class ProductPage extends StatefulWidget {
  static List<Product> cartItems = [];
  static List<Product> wishlistItems = [];
  static int cartItemCount = 0; // Track cart item count

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final List<Product> products = [
    Product(
      name: 'Product 1',
      price: 20.0,
      description: 'Description of Product 1',
      imageUrl: 'https://via.placeholder.com/150',
    ),
    Product(
      name: 'Product 2',
      price: 30.0,
      description: 'Description of Product 2',
      imageUrl: 'https://via.placeholder.com/150',
    ),
    Product(
      name: 'Product 3',
      price: 25.0,
      description: 'Description of Product 3',
      imageUrl: 'https://via.placeholder.com/150',
    ),
    Product(
      name: 'Product 4',
      price: 40.0,
      description: 'Description of Product 4',
      imageUrl: 'https://via.placeholder.com/150',
    ),
    Product(
      name: 'Product 5',
      price: 35.0,
      description: 'Description of Product 5',
      imageUrl: 'https://via.placeholder.com/150',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
        actions: [
          Stack(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CartPage(cartItems: ProductPage.cartItems)),
                  );
                },
                icon: Icon(Icons.shopping_cart),
              ),
              if (ProductPage.cartItemCount > 0) // Use cart item count from global variable
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${ProductPage.cartItemCount}', // Display cart item count
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WishlistPage()),
              );
            },
            icon: Icon(Icons.favorite),
          ),
        ],
      ),
      drawer: Drawer(
        child: MainPageSlider(),
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(products[index].imageUrl),
            ),
            title: Text(products[index].name),
            subtitle: Text('\$${products[index].price.toString()}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailPage(product: products[index]),
                ),
              ).then((_) {
                // Update cart item count when returning from ProductDetailPage
                setState(() {
                  ProductPage.cartItemCount = ProductPage.cartItems.length;
                });
              });
            },
          );
        },
      ),
    );
  }
}

class MainPageSlider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          leading: Icon(Icons.person),
          title: Text('View User Profile'),
          onTap: () {
            // Navigate to user profile page
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UserProfilePage()),
            );
          },
        ),
        ListTile(
          leading: Icon(Icons.shopping_bag),
          title: Text('Products Page'),
          onTap: () {
            Navigator.pop(context); // Close drawer
            // Navigate to products page
          },
        ),
        ListTile(
          leading: Icon(Icons.track_changes),
          title: Text('Track Your Orders'),
          onTap: () {
            // Navigate to orders tracking page
          },
        ),
        ListTile(
          leading: Icon(Icons.logout),
          title: Text('Logout'),
          onTap: () {
            // Perform logout action
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
              (route) => false, // Clear all existing routes
            );
          },
        ),
      ],
    );
  }
}

class UserProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'User Profile Details',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Name: prem',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Address: 123 Main St, City',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}



class ProductDetailPage extends StatelessWidget {
  final Product product;

  ProductDetailPage({required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        actions: [
          Stack(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CartPage(cartItems: ProductPage.cartItems)),
                  );
                },
                icon: Icon(Icons.shopping_cart),
              ),
              if (ProductPage.cartItemCount > 0) // Use cart item count from global variable
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${ProductPage.cartItemCount}', // Display cart item count
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WishlistPage()),
              );
            },
            icon: Icon(Icons.favorite),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(product.imageUrl),
            SizedBox(height: 16.0),
            Text(
              'Price: \$${product.price.toString()}',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              'Description:',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            Text(product.description),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Product existingProduct = ProductPage.cartItems.firstWhere(
                      (element) => element.name == product.name,
                      orElse: () => product,
                    );
                    if (ProductPage.cartItems.contains(existingProduct)) {
                      int index = ProductPage.cartItems.indexOf(existingProduct);
                      ProductPage.cartItems[index].quantity++;
                    } else {
                      product.quantity = 1;
                      ProductPage.cartItems.add(product);
                    }
                    ProductPage.cartItemCount = ProductPage.cartItems.length; // Update cart item count
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Item added to cart')),
                    );
                  },
                  child: Text('Add to Cart'),
                ),
                SizedBox(width: 16.0),
                ElevatedButton(
                  onPressed: () {
                    if (!ProductPage.wishlistItems.contains(product)) {
                      ProductPage.wishlistItems.add(product);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Item added to wishlist')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Item already in wishlist')),
                      );
                    }
                  },
                  child: Text('Add to Wishlist'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CartPage extends StatefulWidget {
  final List<Product> cartItems;

  CartPage({required this.cartItems});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: ListView.builder(
        itemCount: widget.cartItems.length,
        itemBuilder: (context, index) {
          return CartItem(
            product: widget.cartItems[index],
            onRemove: () {
              setState(() {
                widget.cartItems.removeAt(index);
                ProductPage.cartItemCount = widget.cartItems.length; // Update cart item count
              });
            },
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BillingDetailsPage()),
                );
              },
              child: Text('Checkout'),
            ),
          ],
        ),
      ),
    );
  }
}

class CartItem extends StatefulWidget {
  final Product product;
  final VoidCallback onRemove;

  const CartItem({Key? key, required this.product, required this.onRemove}) : super(key: key);

  @override
  _CartItemState createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(widget.product.name),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    if (widget.product.quantity > 1) {
                      widget.product.quantity--;
                    }
                  });
                },
                icon: Icon(Icons.remove),
              ),
              Text('${widget.product.quantity}'),
              IconButton(
                onPressed: () {
                  setState(() {
                    widget.product.quantity++;
                  });
                },
                icon: Icon(Icons.add),
              ),
              IconButton(
                onPressed: () {
                  // Call the onRemove callback to remove the product
                  widget.onRemove();
                },
                icon: Icon(Icons.delete),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class WishlistPage extends StatefulWidget {
  @override
  _WishlistPageState createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wishlist'),
      ),
      body: ListView.builder(
        itemCount: ProductPage.wishlistItems.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(ProductPage.wishlistItems[index].name),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          ProductPage.wishlistItems.removeAt(index);
                        });
                      },
                      icon: Icon(Icons.delete),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Product existingProduct = ProductPage.cartItems.firstWhere(
                          (element) => element.name == ProductPage.wishlistItems[index].name,
                          orElse: () => ProductPage.wishlistItems[index],
                        );
                        if (ProductPage.cartItems.contains(existingProduct)) {
                          int cartIndex = ProductPage.cartItems.indexOf(existingProduct);
                          ProductPage.cartItems[cartIndex].quantity++;
                        } else {
                          ProductPage.cartItems.add(ProductPage.wishlistItems[index]);
                        }
                        ProductPage.cartItemCount = ProductPage.cartItems.length; // Update cart item count
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Item added to cart')),
                        );
                      },
                      child: Text('Add to Cart'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}


class BillingDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Billing Details'),
      ),
      body: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(labelText: 'Name'),
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Address'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PaymentPage()),
              );
            },
            child: Text('Next'),
          ),
        ],
      ),
    );
  }
}

class PaymentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
      ),
      body: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(labelText: 'Card Number'),
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Expiration Date'),
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'CVV'),
          ),
          ElevatedButton(
            onPressed: () {
              // Implement payment processing logic here
            },
            child: Text('Pay Now'),
          ),
        ],
      ),
    );
  }
}
