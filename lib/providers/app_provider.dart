import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';
import '../models/workout_model.dart';

class AppProvider extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;
  
  UserModel _user = UserModel(
    name: 'Alex',
    email: 'alex@ironforge.com',
    height: 175,
    weight: 72,
    age: 28,
    gender: 'Male',
    goal: 'Build Muscle',
    profileImageUrl: 'assets/images/strength.png', 
    isPro: false,
  );

  bool _isLoggedIn = false;
  bool _isLoading = false;
  String? _errorMessage;

  AppProvider() {
    _initAuth();
  }

  void _initAuth() {
    _supabase.auth.onAuthStateChange.listen((data) {
      final session = data.session;
      _isLoggedIn = session != null;
      if (_isLoggedIn) {
        _loadUserProfile(session!.user.id);
      } else {
        notifyListeners();
      }
    });
  }

  Future<void> _loadUserProfile(String userId) async {
    try {
      final data = await _supabase
          .from('profiles')
          .select()
          .eq('id', userId)
          .single();
      
      _user = UserModel(
        name: data['full_name'] ?? 'User',
        email: _supabase.auth.currentUser?.email ?? '',
        height: (data['height'] as num?)?.toDouble() ?? 175,
        weight: (data['weight'] as num?)?.toDouble() ?? 72,
        age: data['age'] as int? ?? 28,
        gender: data['gender'] ?? 'Male',
        goal: data['goal'] ?? 'Build Muscle',
        profileImageUrl: data['avatar_url'] ?? 'assets/images/strength.png',
        isPro: data['is_pro'] ?? false,
      );
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading profile: $e');
      notifyListeners();
    }
  }

  // Auth Methods
  Future<bool> loginWithEmail(String email, String password) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      await _supabase.auth.signInWithPassword(email: email, password: password);
      return true;
    } catch (e) {
      if (e.toString().contains('email_not_confirmed')) {
        _errorMessage = 'Please confirm your email address before logging in. Check your inbox!';
      } else {
        _errorMessage = e.toString();
      }
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> signUpWithEmail(String email, String password, String name) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      final response = await _supabase.auth.signUp(email: email, password: password);
      if (response.user != null) {
        await _supabase.from('profiles').insert({
          'id': response.user!.id,
          'full_name': name,
        });
        
        // If email confirmation is enabled, notify the user
        if (response.session == null) {
          _errorMessage = 'Account created! Please check your email to confirm your account.';
          return false; // Return false so UI can show the message
        }
      }
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> loginWithGoogle() async {
    _setLoading(true);
    _errorMessage = null;
    try {
      await _supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'io.supabase.ironforge://login-callback/',
      );
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      // OAuth flow will redirect, but we clear loading just in case
      _setLoading(false);
    }
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Getters
  UserModel get user => _user;
  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // ... (rest of existing getters and methods)
  int _selectedNavIndex = 0;
  int get selectedNavIndex => _selectedNavIndex;
  
  // Re-adding the rest of the existing data and methods from the previous view_file
  // (I'll need to be careful to merge properly)
  
  final int _steps = 8432;
  int _caloriesBurned = 1340;
  int _activeMinutes = 48;
  final int _caloriesGoal = 2000;
  int _waterGlasses = 3;
  final int _waterGoal = 8;
  
  final List<ActivityDataPoint> _hourlyActivity = [
    ActivityDataPoint(hour: 6, steps: 200, calories: 50, minutes: 5, water: 0.5),
    ActivityDataPoint(hour: 7, steps: 800, calories: 120, minutes: 15, water: 1.0),
    ActivityDataPoint(hour: 8, steps: 1200, calories: 200, minutes: 20, water: 0.5),
    ActivityDataPoint(hour: 9, steps: 600, calories: 80, minutes: 8, water: 0.0),
    ActivityDataPoint(hour: 10, steps: 400, calories: 60, minutes: 5, water: 0.5),
    ActivityDataPoint(hour: 11, steps: 300, calories: 40, minutes: 3, water: 0.0),
    ActivityDataPoint(hour: 12, steps: 1500, calories: 250, minutes: 25, water: 1.0),
    ActivityDataPoint(hour: 13, steps: 900, calories: 140, minutes: 12, water: 0.5),
    ActivityDataPoint(hour: 14, steps: 700, calories: 100, minutes: 10, water: 0.5),
    ActivityDataPoint(hour: 15, steps: 500, calories: 70, minutes: 7, water: 0.0),
    ActivityDataPoint(hour: 16, steps: 400, calories: 60, minutes: 5, water: 0.5),
    ActivityDataPoint(hour: 17, steps: 1100, calories: 180, minutes: 18, water: 0.5),
  ];

  DateTime _selectedDate = DateTime.now();

  final List<WorkoutLogEntry> _workoutLog = [
    WorkoutLogEntry(
      workoutName: 'Upper Body Power',
      calories: 320,
      date: DateTime.now(),
      duration: 45,
    ),
    WorkoutLogEntry(
      workoutName: 'Morning Jog',
      calories: 210,
      date: DateTime.now(),
      duration: 30,
    ),
    WorkoutLogEntry(
      workoutName: 'Core Blast',
      calories: 180,
      date: DateTime.now().subtract(const Duration(days: 1)),
      duration: 25,
    ),
  ];

  final List<ProgramModel> _programs = [
    ProgramModel(
      id: '1',
      name: 'Powerlifting Pro',
      category: 'Strength',
      weeks: 8,
      currentDay: 5,
      totalDays: 56,
      difficulty: 'Advanced',
      calories: 450,
      duration: 60,
      imageUrl: 'assets/images/strength.png',
    ),
    ProgramModel(
      id: '2',
      name: 'Muscle Shred',
      category: 'Strength',
      weeks: 6,
      currentDay: 12,
      totalDays: 42,
      difficulty: 'Intermediate',
      calories: 380,
      duration: 45,
      imageUrl: 'assets/images/strength.png',
    ),
    ProgramModel(
      id: '3',
      name: 'Core Ignite',
      category: 'HIIT',
      weeks: 4,
      currentDay: 8,
      totalDays: 28,
      difficulty: 'Beginner',
      calories: 280,
      duration: 30,
      imageUrl: 'assets/images/hiit.png',
    ),
    ProgramModel(
      id: '4',
      name: 'Yoga Flow',
      category: 'Yoga',
      weeks: 4,
      currentDay: 3,
      totalDays: 28,
      difficulty: 'Beginner',
      calories: 150,
      duration: 40,
      imageUrl: 'assets/images/yoga.png',
    ),
    ProgramModel(
      id: '5',
      name: 'Cardio Blast',
      category: 'Cardio',
      weeks: 6,
      currentDay: 20,
      totalDays: 42,
      difficulty: 'Intermediate',
      calories: 420,
      duration: 50,
      imageUrl: 'assets/images/cardio.png',
    ),
  ];

  final List<WorkoutModel> _workouts = [
    WorkoutModel(
      id: 'w1',
      name: 'Leg Day - Heavy Strength',
      category: 'Strength',
      duration: 45,
      calories: 420,
      difficulty: 'Advanced',
      description:
          'A comprehensive leg day focusing on squats, deadlifts, and leg press.',
      imageUrl: 'assets/images/strength.png',
    ),
    WorkoutModel(
      id: 'w2',
      name: 'Upper Body Power',
      category: 'Strength',
      duration: 50,
      calories: 380,
      difficulty: 'Intermediate',
      description:
          'Build upper body strength with bench press, rows, and shoulder work.',
      imageUrl: 'assets/images/strength.png',
    ),
    WorkoutModel(
      id: 'w3',
      name: 'HIIT Cardio Blast',
      category: 'HIIT',
      duration: 30,
      calories: 350,
      difficulty: 'Intermediate',
      description:
          'High intensity intervals to torch calories and boost metabolism.',
      imageUrl: 'assets/images/hiit.png',
    ),
    WorkoutModel(
      id: 'w4',
      name: 'Morning Yoga Flow',
      category: 'Yoga',
      duration: 40,
      calories: 150,
      difficulty: 'Beginner',
      description:
          'Start your day with energizing yoga poses and mindful breathing.',
      imageUrl: 'assets/images/yoga.png',
    ),
    WorkoutModel(
      id: 'w5',
      name: 'Core Crusher',
      category: 'Strength',
      duration: 25,
      calories: 200,
      difficulty: 'Beginner',
      description:
          'Target your core with planks, crunches, and rotational exercises.',
      imageUrl: 'assets/images/strength.png',
    ),
  ];

  int get steps => _steps;
  int get caloriesBurned => _caloriesBurned;
  int get activeMinutes => _activeMinutes;
  int get caloriesGoal => _caloriesGoal;
  int get waterGlasses => _waterGlasses;
  int get waterGoal => _waterGoal;
  DateTime get selectedDate => _selectedDate;
  List<WorkoutLogEntry> get workoutLog => _workoutLog;
  List<ActivityDataPoint> get hourlyActivity => _hourlyActivity;
  List<ProgramModel> get programs => _programs;
  List<WorkoutModel> get workouts => _workouts;
  ProgramModel get currentProgram => _programs.first;

  void setNavIndex(int index) {
    _selectedNavIndex = index;
    notifyListeners();
  }

  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  void addWaterGlass() {
    if (_waterGlasses < _waterGoal) {
      _waterGlasses++;
      notifyListeners();
    }
  }

  void removeWaterGlass() {
    if (_waterGlasses > 0) {
      _waterGlasses--;
      notifyListeners();
    }
  }

  void updateUserHeight(double height) {
    _user = _user.copyWith(height: height);
    notifyListeners();
  }

  void updateUserWeight(double weight) {
    _user = _user.copyWith(weight: weight);
    notifyListeners();
  }

  void upgradeToPro() {
    _user = _user.copyWith(isPro: true);
    notifyListeners();
  }

  void logCalories(int calories) {
    _caloriesBurned += calories;
    notifyListeners();
  }

  void addWorkoutLog(WorkoutLogEntry entry) {
    _workoutLog.insert(0, entry);
    notifyListeners();
  }

  void startWorkout(WorkoutModel workout) {
    _caloriesBurned += workout.calories ~/ 2;
    _activeMinutes += workout.duration ~/ 2;
    notifyListeners();
  }

  List<WorkoutLogEntry> get todayLog {
    final today = DateTime.now();
    return _workoutLog
        .where((e) =>
            e.date.year == today.year &&
            e.date.month == today.month &&
            e.date.day == today.day)
        .toList();
  }


}
