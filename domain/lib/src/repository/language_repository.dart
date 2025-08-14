abstract class ILanguageRepository {
  Future<void> changeLanguage(String locale);
  Future<void> clearAllData();
}
