import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

List<Map<String, dynamic>> users = [];

Future<void> fetchUsers() async {
  try {
    final url = Uri.parse("https://jsonplaceholder.typicode.com/users");
    final response = await http.get(url);
    final List data = jsonDecode(response.body);
    users = List<Map<String, dynamic>>.from(data);
  } catch (e) {
    print("Failed to load users. Please check your internet.");
  }
}

void showMenu() {
  print("\nUser Manager Menu");
  print("1. Show all usernames");
  print("2. Show user details by ID");
  print("3. Filter users by city");
  print("4. Exit");
  stdout.write("Enter your choice: ");
}

void showUsernames() {
  print("\nAll Users:");
  for (var user in users) {
    print("- ${user['username']}");
  }
}

void showUserDetailsById() {
  stdout.write("Enter user ID: ");
  String? input = stdin.readLineSync();
  int? id = int.tryParse(input ?? "");

  if (id == null) {
    print("Please enter a valid number.");
    return;
  }

  var user = users.firstWhere(
    (u) => u['id'] == id,
    orElse: () => {},
  );

  if (user.isEmpty) {
    print("User not found.");
    return;
  }

  print("\nUser Details:");
  print("Name    : ${user['name']}");
  print("Username: ${user['username']}");
  print("Email   : ${user['email']}");
  print("City    : ${user['address']['city']}");
  print("Company : ${user['company']['name']}");
}

void filterUsersByCity() {
  stdout.write("Enter city name: ");
  String? city = stdin.readLineSync();

  if (city == null || city.trim().isEmpty) {
    print("City name cannot be empty.");
    return;
  }

  final results = users.where((user) =>
    user['address']['city'].toString().toLowerCase() == city.toLowerCase());

  print("\nUsers in $city:");
  for (var user in results) {
    print("- ${user['name']} (${user['username']})");
  }
}

void main() async {
  await fetchUsers();

  while (true) {
    showMenu();
    String? choice = stdin.readLineSync();

    switch (choice) {
      case '1':
        showUsernames();
        break;
      case '2':
        showUserDetailsById();
        break;
      case '3':
        filterUsersByCity();
        break;
      case '4':
        print("Goodbye!");
        return;
      default:
        print("Invalid choice. Please try again.");
    }
  }
}