import 'package:flutter/material.dart';
import '../../models/user_profile.dart';

class ProfileForm extends StatefulWidget {
  final UserProfile? initialProfile;
  final void Function(UserProfile) onSave;
  const ProfileForm({super.key, this.initialProfile, required this.onSave});

  @override
  State<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  final _formKey = GlobalKey<FormState>();
  late String _sex;
  late int _age;
  late double _heightCm;
  late double _weightKg;
  late String _activityLevel;
  late String _goal;

  @override
  void initState() {
    super.initState();
    final p = widget.initialProfile;
    _sex = p?.sex ?? 'male';
    _age = p?.age ?? 25;
    _heightCm = p?.heightCm ?? 175;
    _weightKg = p?.weightKg ?? 70;
    _activityLevel = p?.activityLevel ?? 'moderate';
    _goal = p?.goal ?? 'maintain';
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          DropdownButtonFormField<String>(
            value: _sex,
            items: const [
              DropdownMenuItem(value: 'male', child: Text('Male')),
              DropdownMenuItem(value: 'female', child: Text('Female')),
            ],
            onChanged: (v) => setState(() => _sex = v ?? 'male'),
            decoration: const InputDecoration(labelText: 'Sex'),
          ),
          TextFormField(
            initialValue: _age.toString(),
            decoration: const InputDecoration(labelText: 'Age'),
            keyboardType: TextInputType.number,
            onChanged: (v) => _age = int.tryParse(v) ?? _age,
          ),
          TextFormField(
            initialValue: _heightCm.toString(),
            decoration: const InputDecoration(labelText: 'Height (cm)'),
            keyboardType: TextInputType.number,
            onChanged: (v) => _heightCm = double.tryParse(v) ?? _heightCm,
          ),
          TextFormField(
            initialValue: _weightKg.toString(),
            decoration: const InputDecoration(labelText: 'Weight (kg)'),
            keyboardType: TextInputType.number,
            onChanged: (v) => _weightKg = double.tryParse(v) ?? _weightKg,
          ),
          DropdownButtonFormField<String>(
            value: _activityLevel,
            items: const [
              DropdownMenuItem(value: 'sedentary', child: Text('Sedentary')),
              DropdownMenuItem(value: 'light', child: Text('Light')),
              DropdownMenuItem(value: 'moderate', child: Text('Moderate')),
              DropdownMenuItem(value: 'active', child: Text('Active')),
              DropdownMenuItem(value: 'very active', child: Text('Very Active')),
            ],
            onChanged: (v) => setState(() => _activityLevel = v ?? 'moderate'),
            decoration: const InputDecoration(labelText: 'Activity Level'),
          ),
          DropdownButtonFormField<String>(
            value: _goal,
            items: const [
              DropdownMenuItem(value: 'maintain', child: Text('Maintain')),
              DropdownMenuItem(value: 'lose', child: Text('Lose Weight')),
              DropdownMenuItem(value: 'gain', child: Text('Gain Weight')),
            ],
            onChanged: (v) => setState(() => _goal = v ?? 'maintain'),
            decoration: const InputDecoration(labelText: 'Goal'),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                widget.onSave(UserProfile(
                  uid: widget.initialProfile?.uid ?? '',
                  sex: _sex,
                  age: _age,
                  heightCm: _heightCm,
                  weightKg: _weightKg,
                  activityLevel: _activityLevel,
                  goal: _goal,
                ));
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
