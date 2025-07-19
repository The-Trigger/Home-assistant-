import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../services/auth_service.dart';
import '../services/bluetooth_service.dart';
import '../utils/app_colors.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  
  final List<Widget> _screens = [
    const DashboardScreen(),
    const ControlScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Bag Controller'),
        actions: [
          Consumer<BluetoothService>(
            builder: (context, bluetoothService, child) {
              return IconButton(
                icon: Icon(
                  bluetoothService.isConnected 
                      ? FontAwesomeIcons.bluetooth 
                      : FontAwesomeIcons.bluetoothB,
                  color: bluetoothService.isConnected 
                      ? AppColors.success 
                      : AppColors.textSecondary,
                ),
                onPressed: () {
                  // TODO: Implement Bluetooth connection dialog
                },
              );
            },
          ),
          IconButton(
            icon: const Icon(FontAwesomeIcons.rightFromBracket),
            onPressed: () async {
              final authService = Provider.of<AuthService>(context, listen: false);
              authService.logout();
              Navigator.of(context).pushReplacementNamed('/auth');
            },
          ),
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primaryBlue,
        unselectedItemColor: AppColors.textSecondary,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.gaugeHigh),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.gamepad),
            label: 'Control',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.gear),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            FontAwesomeIcons.briefcase,
            size: 64,
            color: AppColors.primaryBlue,
          ),
          SizedBox(height: 24),
          Text(
            'Smart Bag Dashboard',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Dashboard implementation coming soon...',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class ControlScreen extends StatelessWidget {
  const ControlScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            FontAwesomeIcons.gamepad,
            size: 64,
            color: AppColors.primaryBlue,
          ),
          SizedBox(height: 24),
          Text(
            'Smart Bag Controls',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Control implementation coming soon...',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            FontAwesomeIcons.gear,
            size: 64,
            color: AppColors.primaryBlue,
          ),
          SizedBox(height: 24),
          Text(
            'Settings',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Settings implementation coming soon...',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}