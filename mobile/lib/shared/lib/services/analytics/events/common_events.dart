import "package:resident_live/shared/lib/services/analytics/analytics_parameters.dart";
import "package:resident_live/shared/lib/services/analytics/events/analytics_event.dart";

class SubRenewFailed extends AnalyticsEvent {
  SubRenewFailed(String subName)
      : super(
          name: "sub_renew_failed",
          params: {AnalyticsParameters.subscriptionName: subName},
        );
}

class SubRenewSuccess extends AnalyticsEvent {
  SubRenewSuccess(String subName)
      : super(
          name: "sub_renew_success",
          params: {
            AnalyticsParameters.subscriptionName: subName,
          },
        );
}

class AllowATTEvent extends AnalyticsEvent {
  AllowATTEvent() : super(name: "allow_att");
}

class DenyATTEvent extends AnalyticsEvent {
  DenyATTEvent() : super(name: "deny_att");
}

class CoinsClickEvent extends AnalyticsEvent {
  CoinsClickEvent() : super(name: "click_coins");
}

class AssistantClickEvent extends AnalyticsEvent {
  AssistantClickEvent(String name)
      : super(
          name: "click_assistant",
          params: {AnalyticsParameters.assistantName: name},
        );
}

class FirebaseABNavEvent extends AnalyticsEvent {
  FirebaseABNavEvent() : super(name: "fb_ab_navigation");
}

class BurgerMenuClickEvent extends AnalyticsEvent {
  BurgerMenuClickEvent() : super(name: "click_burger");
}

class SettingsClickEvent extends AnalyticsEvent {
  SettingsClickEvent() : super(name: "click_settings");
}

class HistoryClickEvent extends AnalyticsEvent {
  HistoryClickEvent() : super(name: "click_history");
}

class AdsProductsReceivedEvent extends AnalyticsEvent {
  AdsProductsReceivedEvent({
    String? weeklyProductId,
    String? monthlyProductId,
    String? yearlyProductId,
  }) : super(name: "ads_products_received", params: {
          if (weeklyProductId != null)
            AnalyticsParameters.weeklyProductId: weeklyProductId,
          if (monthlyProductId != null)
            AnalyticsParameters.monthlyProductId: monthlyProductId,
          if (yearlyProductId != null)
            AnalyticsParameters.yearlyProductId: yearlyProductId,
        },);
}

class NativeQuickActionClickEvent extends AnalyticsEvent {
  NativeQuickActionClickEvent({
    required actionName,
    required String setName,
  }) : super(name: "native_quick_action_click", params: {
          AnalyticsParameters.name: actionName,
          AnalyticsParameters.setName: setName,
        },);
}

class OfferBannerClickEvent extends AnalyticsEvent {
  OfferBannerClickEvent({required bool withCountdown})
      : super(
          name: "offer_banner_click",
          params: {
            AnalyticsParameters.withCountdown: withCountdown.toString(),
          },
        );
}

class OfferBannerShowEvent extends AnalyticsEvent {
  OfferBannerShowEvent({required bool withCountdown})
      : super(
          name: "offer_banner_show",
          params: {
            AnalyticsParameters.withCountdown: withCountdown.toString(),
          },
        );
}

class RatingOnChatExit extends AnalyticsEvent {
  RatingOnChatExit() : super(name: "rating_on_chat_exit");
}
