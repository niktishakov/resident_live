/// Collection of all parameters sent to analytics services.
class AnalyticsParameters {
  static const String description = 'description';

  /// Used in [OfferPaywallClickEvent] to check a countdown visibility
  static const String withCountdown = 'with_countdown';

  /// Used in [EducationChatInteractionRespondEvent] to capture the users input
  static const String answer = 'answer';

  /// Used in [ButtonTapEvent] to capture subscription status of the user
  static const String subscriptionStatus = 'subscription_status';

  /// Used in [EducationAwardShareEvent] to capture the id of the award being shared (badge is the BE name for awards).
  static const String badgeId = 'badge_id';

  static const String name = 'name';

  static const String seconds = "seconds";

  /// Used by [ButtonTapEvent] and represents the text of the button
  /// This is the Google Analytics name, the mixpanel equivalent is [MixpanelReplacementKeys.tileTitle].
  static const String clickText = 'click_text';

  static const String label = 'label';

  /// Used in [PaywallPurchaseEvent] to denote the currency of the purchase.
  static const String currency = 'af_currency';

  /// Used in [PaywallPurchaseEvent] to denote the revenue of the purchase.
  static const String revenue = 'af_revenue';

  /// Used in [AnalyticsFeature.education] to capture message copy during Money Missions.
  /// Usage varies between events, see the parent analytics classes for the exact spec.
  static const String message = 'message';

  /// Used in [AnalyticsFeature.education] Money Mission events to determine if a parent is taking a mission or a child
  /// Can be 'real' (child) or 'demo' (parent)
  static const String mode = 'mode';

  /// Used in [EducationChatInteractionRespondEvent] to denote the amount of XP the user can gain from the Money Mission question.
  static const String rewardValue = 'reward_value';

  /// Represents the current screen name that fired the event.
  static const String screenName = 'screen_name';

  static const String paywallName = 'paywall_name';

  /// Used in [EducationChatInteractionRespondEvent] to denote the number of times the user has attempted the Money Mission question.
  static const String stepNumber = 'step_number';

  /// Used by [ButtonTapEvent], [PromptViewEvent] and denotes the type of action
  /// that dispatches the event - i.e 'copy', 'share'.
  ///
  /// Used in [AnalyticsFeature.education] to capture interaction/message types during Money Missions.
  static const String type = 'type';

  static const String assistantName = 'assistant_name';
  static const String subscriptionName = 'subscription_name';

  static const String value = 'value';

  static const String messageId = 'message_id';

  static const String feedId = 'feed_id';

  static const String productKey = 'product_key';

  static const String promptName = 'prompt_name';

  static const String categoryName = 'category_name';

  static const String pageNumber = 'page_number';

  static const String coinsCount = 'coins_count';

  static const String subscriptionId = 'subscription_id';

  static const String weeklyProductId = 'weekly_product_id';

  static const String monthlyProductId = 'monthly_product_id';

  static const String yearlyProductId = 'yearly_product_id';

  static const String followupDisplayMode = 'followup_display_mode';

  static const String setName = 'set_name';

  static const String onboardingName = 'onboarding_name';

  static const String appEnviroment = 'app_environment';

  /// Used to detect source of analytics events. A possible options: 'web', 'mobile', 'backend'
  static const String source = 'source';

  static const optionName = 'option_name';

  static const topic = 'topic';
}

/// Some event parameters require different names when being sent to mixpanel.
/// This is a collection of all the cases where we to change name based on analytics service
class AppsflyerReplacementKeys {
  static const value = <String, String>{
    AnalyticsParameters.clickText: 'tile_title',
  };
}
