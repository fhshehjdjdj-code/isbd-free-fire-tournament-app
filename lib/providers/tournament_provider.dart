import 'package:flutter/material.dart';
import '../models/tournament_model.dart';

class TournamentProvider extends ChangeNotifier {
  List<Tournament> _tournaments = [];
  bool _isLoading = false;

  List<Tournament> get tournaments => _tournaments;
  bool get isLoading => _isLoading;

  Future<void> fetchTournaments() async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 2));
      _tournaments = [
        Tournament(
          id: '1',
          name: 'Spring Championship 2024',
          description: 'Biggest Free Fire tournament of the season',
          prizePool: 10000,
          participants: 45,
          maxParticipants: 100,
          startDate: DateTime.now().add(const Duration(days: 7)),
          status: 'Open',
        ),
        Tournament(
          id: '2',
          name: 'Summer Clash',
          description: 'Team-based tournament',
          prizePool: 5000,
          participants: 32,
          maxParticipants: 64,
          startDate: DateTime.now().add(const Duration(days: 14)),
          status: 'Open',
        ),
      ];
    } catch (e) {
      debugPrint('Error fetching tournaments: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void addTournament(Tournament tournament) {
    _tournaments.add(tournament);
    notifyListeners();
  }
}
