import '/data/model/preference_model.dart';
import '/data/provider/preference_provider.dart';

class PreferenceRepository {
    final PreferenceProvider provider;
    PreferenceRepository({required this.provider});

    Future<UserPreference> getPreference() async {
        return await provider.getPreference();
    }

    setPreference(UserPreference user) async {
        await provider.setPreference(user);
    }

    removePreference() async {
        await provider.removePreference();
    }
}