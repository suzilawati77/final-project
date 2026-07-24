import 'package:flutter/material.dart';

import '../data/app_repository.dart';
import '../models/loan.dart';
import '../services/loan_service.dart';
import '../widgets/loan_card.dart';
import 'return_screen.dart';

enum LoanFilter { active, returned, all }

class LoanListScreen extends StatefulWidget {
  const LoanListScreen({super.key});

  @override
  State<LoanListScreen> createState() => _LoanListScreenState();
}

class _LoanListScreenState extends State<LoanListScreen> {
  final AppRepository _repository = AppRepository.instance;

  LoanFilter _filter = LoanFilter.active;

  List<Loan> get _filteredLoans {
    final loans = _repository.loansForCurrentUser();
    switch (_filter) {
      case LoanFilter.active:
        return loans.where((loan) => !loan.isReturned).toList();
      case LoanFilter.returned:
        return loans.where((loan) => loan.isReturned).toList();
      case LoanFilter.all:
        return loans;
    }
  }

  void _renew(Loan loan) {
    final result = LoanService.instance.renew(loan);
    setState(() {});
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text(result.success ? 'Pinjaman dibaharui 14 hari' : result.message),
        ),
      );
  }

  Future<void> _openReturn(Loan loan) async {
    final returned = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => ReturnScreen(loan: loan)),
    );
    if (!mounted) return;
    if (returned == true) {
      setState(() {});
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(const SnackBar(content: Text('Pemulangan berjaya')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final loans = _filteredLoans;

    return Scaffold(
      appBar: AppBar(title: const Text('Senarai Pinjaman Buku')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                _FilterChip(
                  label: 'Aktif',
                  selected: _filter == LoanFilter.active,
                  onSelected: () => setState(() => _filter = LoanFilter.active),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Dipulangkan',
                  selected: _filter == LoanFilter.returned,
                  onSelected: () => setState(() => _filter = LoanFilter.returned),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Semua',
                  selected: _filter == LoanFilter.all,
                  onSelected: () => setState(() => _filter = LoanFilter.all),
                ),
              ],
            ),
          ),
          Expanded(
            child: loans.isEmpty
                ? const Center(
                    child: Text(
                      'Tiada rekod pinjaman.',
                      style: TextStyle(color: Colors.black54),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 16),
                    itemCount: loans.length,
                    itemBuilder: (context, index) {
                      final loan = loans[index];
                      return LoanCard(
                        loan: loan,
                        onRenew: () => _renew(loan),
                        onReturn: () => _openReturn(loan),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onSelected;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onSelected(),
    );
  }
}
