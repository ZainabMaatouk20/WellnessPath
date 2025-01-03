import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wellnesspath/services/api_service.dart';
import 'dart:convert';

class WaterIntakePage extends StatefulWidget {
  const WaterIntakePage({super.key});

  @override
  _WaterIntakePageState createState() => _WaterIntakePageState();
}

class _WaterIntakePageState extends State<WaterIntakePage> {
  final TextEditingController _amountController = TextEditingController();
  int _dailyTotal = 0;

  // Fetch the daily water intake total
  Future<void> fetchDailyTotal() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to view water intake.')),
      );
      return;
    }

    try {
      final response = await ApiService.get('?action=getDailyWaterIntake&user_id=$userId');
      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['total_water'] != null) {
        setState(() {
          _dailyTotal = int.tryParse(data['total_water'].toString()) ?? 0;
        });
      } else {
        throw Exception('Failed to fetch daily total.');
      }
    } catch (e) {
      debugPrint('Error in fetchDailyTotal: $e'); // Log the error
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  // Log water intake to the server
  Future<void> logWaterIntake() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');

    if (userId == null || _amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in and enter water intake amount.')),
      );
      return;
    }

    try {
      final response = await ApiService.post('?action=logWaterIntake', {
        'user_id': userId.toString(),
        'amount': _amountController.text,
        'date': DateTime.now().toIso8601String(),
      });

      if (response.statusCode == 200) {
        // Update the total only after successful API response
        fetchDailyTotal(); // Refetch the daily total
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Water intake logged successfully!')),
        );
        _amountController.clear();
      } else {
        throw Exception('Failed to log water intake.');
      }
    } catch (e) {
      debugPrint('Error in logWaterIntake: $e'); // Log the error
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  void initState() {
    super.initState();
    fetchDailyTotal(); // Fetch the total water intake when the page loads
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Water Intake'),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Header Section
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.green, Colors.lightGreenAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Track Your Water Intake',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Stay hydrated and healthy!',
                      style: TextStyle(fontSize: 16, color: Colors.white70),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Input Field
              TextField(
                controller: _amountController,
                decoration: InputDecoration(
                  labelText: 'Amount (ml)',
                  filled: true,
                  fillColor: Colors.green.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.green),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),

              // Log Water Button
              ElevatedButton(
                onPressed: logWaterIntake,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text(
                  'Log Water',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),

              // Daily Total Card
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.blue, Colors.lightBlueAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Daily Total',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '$_dailyTotal ml',
                        style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
