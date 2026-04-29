import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../auth/models/user_model.dart';
import '../auth/presentation/screens/sign_in_screen.dart';
import '../event/models/events_model.dart' as event_model;
import '../more/models/dashboard_model.dart';
import 'app_util.dart';
import 'cash_helper.dart';
import 'ui/app_ui.dart';
import 'ui/components.dart';

/// Centralised state and helpers for the "browse as guest" experience.
///
/// Guest mode lets a user explore the app with mock data without owning an
/// account. [isGuest] is in-memory only for the running process — it does not
/// survive a cold start, so reopening the app shows onboarding again (user can
/// choose guest or sign in). Older builds stored a persisted flag; [load]
/// clears that migration key once at startup.
///
/// Always mutate the flag through [enter] / [exit], and call [load] once during
/// app startup before the first cubit fires.
class GuestMode {
  GuestMode._();

  static const String _kIsGuest = "is_guest";

  /// Cached, synchronous view of the guest flag. Defaults to `false` until
  /// [load] has run; this matches the safe default for screens that mount
  /// before the splash finishes.
  static bool isGuest = false;

  /// Clears any legacy persisted guest flag and resets [isGuest]. Safe to
  /// call multiple times.
  static Future<void> load() async {
    await CashHelper.removeSavedString(_kIsGuest);
    isGuest = false;
  }

  /// Marks the user as a guest until the process ends or [exit] is called.
  /// The caller is expected to navigate to the layout afterwards.
  static Future<void> enter() async {
    isGuest = true;
  }

  /// Clears the guest flag. Called whenever a real session is established
  /// (login / register / verify) so subsequent cubit calls hit the real API.
  static Future<void> exit() async {
    isGuest = false;
    await CashHelper.removeSavedString(_kIsGuest);
  }

  // ---------------------------------------------------------------------------
  // Mock data builders
  // ---------------------------------------------------------------------------

  /// Mock profile used by [AuthCubit.profile] in guest mode so the UI can
  /// render headers, names, and package widgets without a real account.
  static UserModel buildMockProfile() {
    final model = UserModel(
      status: true,
      errNum: "S000",
      msg: "guest",
      data: Data(
        name: "guest".tr(),
        phone: "",
        email: "",
        birthdate: "",
        type: "user",
        package_name: "Free".tr(),
        package_id: 0,
        isVerified: 0,
        id: 0,
        apiToken: "",
      ),
    );
    // `Data` constructor doesn't take photo, set it directly so the avatar
    // placeholder asset kicks in via CachedNetworkImage's errorWidget.
    model.data!.photo = "";
    return model;
  }

  /// Empty events list wrapped in [EventsModel] – the home/events screens
  /// already render an EmptyWidget for this state, which is a friendly
  /// placeholder for guest browsing.
  static event_model.EventsModel buildEmptyEvents() {
    return event_model.EventsModel(
      status: true,
      errNum: "S000",
      msg: "guest",
      data: const [],
    );
  }

  /// Builds a single mock [Event] used to populate guest-mode lists.
  /// Card widgets parse [dateFrom] with `split('-')`, so the date format
  /// must always be `YYYY-MM-DD`.
  static event_model.Event _mockEvent({
    required int id,
    required String name,
    required String location,
    required String dateFrom,
    required String timeFrom,
    required String typeName,
    required String eventStatus,
    String draft = "0",
    int countvisitor = 50,
    int acceptvisitorCount = 30,
  }) {
    return event_model.Event(
      id: id,
      name: name,
      type: event_model.Type(
        id: 1,
        name: typeName,
        photo: "",
        createdAt: "",
        updatedAt: "",
      ),
      userId: "0",
      status: "1",
      eventStatus: eventStatus,
      draft: draft,
      privacy: "public",
      video: "",
      photo: "",
      timeFrom: timeFrom,
      timeTo: timeFrom,
      dateFrom: dateFrom,
      dateTo: dateFrom,
      location: location,
      content: "",
      sharePhotoOne: "",
      sharePhotoTwo: "",
      lat: "0",
      lang: "0",
      guestAvg: "0",
      rate: "0",
      numRate: "0",
      chat: "",
      linkDeep: "",
      createdAt: dateFrom,
      updatedAt: dateFrom,
      countvisitor: countvisitor,
      pendingvisitorCount: 5,
      attendvisitorCount: acceptvisitorCount,
      cancelvisitorCount: 2,
      acceptvisitorCount: acceptvisitorCount,
      visitors: const [],
      guards: const [],
    );
  }

  /// Mock "my events" payload so the home screen and events tab show
  /// realistic-looking cards in guest mode instead of an empty state.
  static event_model.EventsModel buildMockEvents() {
    return event_model.EventsModel(
      status: true,
      errNum: "S000",
      msg: "guest",
      data: [
        _mockEvent(
          id: 1001,
          name: "mockEventWedding".tr(),
          location: "mockLocationRiyadh".tr(),
          dateFrom: "2026-06-12",
          timeFrom: "20:00",
          typeName: "Wedding".tr(),
          eventStatus: "active",
          countvisitor: 120,
          acceptvisitorCount: 84,
        ),
        _mockEvent(
          id: 1002,
          name: "mockEventBirthday".tr(),
          location: "mockLocationJeddah".tr(),
          dateFrom: "2026-07-04",
          timeFrom: "18:30",
          typeName: "Birthday".tr(),
          eventStatus: "pending",
          countvisitor: 45,
          acceptvisitorCount: 20,
        ),
        _mockEvent(
          id: 1003,
          name: "mockEventCorporate".tr(),
          location: "mockLocationDammam".tr(),
          dateFrom: "2026-08-21",
          timeFrom: "10:00",
          typeName: "Meeting".tr(),
          eventStatus: "finished",
          countvisitor: 80,
          acceptvisitorCount: 75,
        ),
      ],
    );
  }

  /// Mock invitations payload used by the home carousel in guest mode.
  static event_model.EventsModel buildMockInvitations() {
    return event_model.EventsModel(
      status: true,
      errNum: "S000",
      msg: "guest",
      data: [
        _mockEvent(
          id: 2001,
          name: "mockEventCharityGala".tr(),
          location: "mockLocationMecca".tr(),
          dateFrom: "2026-05-30",
          timeFrom: "19:00",
          typeName: "Gala".tr(),
          eventStatus: "active",
          countvisitor: 200,
          acceptvisitorCount: 130,
        ),
        _mockEvent(
          id: 2002,
          name: "mockEventGraduation".tr(),
          location: "mockLocationMedina".tr(),
          dateFrom: "2026-09-15",
          timeFrom: "17:30",
          typeName: "Graduation".tr(),
          eventStatus: "pending",
          countvisitor: 60,
          acceptvisitorCount: 25,
        ),
      ],
    );
  }

  /// Invitations hub tabs: `'pending'` (upcoming), `'accept'`, `'reject'`, or `''`.
  static event_model.EventsModel buildMockInvitationsForTab(String endpoint) {
    switch (endpoint) {
      case 'accept':
        return event_model.EventsModel(
          status: true,
          errNum: "S000",
          msg: "guest",
          data: [
            _mockEvent(
              id: 2101,
              name: "mockEventWedding".tr(),
              location: "mockLocationRiyadh".tr(),
              dateFrom: "2026-06-01",
              timeFrom: "18:00",
              typeName: "Wedding".tr(),
              eventStatus: "active",
              countvisitor: 100,
              acceptvisitorCount: 90,
            ),
            _mockEvent(
              id: 2102,
              name: "mockEventCorporate".tr(),
              location: "mockLocationDammam".tr(),
              dateFrom: "2026-07-12",
              timeFrom: "09:30",
              typeName: "Meeting".tr(),
              eventStatus: "active",
              countvisitor: 40,
              acceptvisitorCount: 38,
            ),
          ],
        );
      case 'reject':
        return event_model.EventsModel(
          status: true,
          errNum: "S000",
          msg: "guest",
          data: [
            _mockEvent(
              id: 2201,
              name: "mockEventBirthday".tr(),
              location: "mockLocationJeddah".tr(),
              dateFrom: "2026-04-01",
              timeFrom: "16:00",
              typeName: "Birthday".tr(),
              eventStatus: "canceled",
              countvisitor: 30,
              acceptvisitorCount: 0,
            ),
            _mockEvent(
              id: 2202,
              name: "mockEventGraduation".tr(),
              location: "mockLocationMecca".tr(),
              dateFrom: "2026-03-20",
              timeFrom: "14:00",
              typeName: "Graduation".tr(),
              eventStatus: "canceled",
              countvisitor: 55,
              acceptvisitorCount: 0,
            ),
          ],
        );
      case 'pending':
      default:
        return event_model.EventsModel(
          status: true,
          errNum: "S000",
          msg: "guest",
          data: [
            _mockEvent(
              id: 2003,
              name: "mockEventCharityGala".tr(),
              location: "mockLocationMecca".tr(),
              dateFrom: "2026-05-30",
              timeFrom: "19:00",
              typeName: "Gala".tr(),
              eventStatus: "pending",
              countvisitor: 200,
              acceptvisitorCount: 12,
            ),
            _mockEvent(
              id: 2004,
              name: "mockEventGraduation".tr(),
              location: "mockLocationMedina".tr(),
              dateFrom: "2026-09-15",
              timeFrom: "17:30",
              typeName: "Graduation".tr(),
              eventStatus: "pending",
              countvisitor: 60,
              acceptvisitorCount: 8,
            ),
          ],
        );
    }
  }

  static event_model.EventsModel buildMockDraftEvents() {
    return event_model.EventsModel(
      status: true,
      errNum: "S000",
      msg: "guest",
      data: [
        _mockEvent(
          id: 3001,
          name: "mockEventWedding".tr(),
          location: "mockLocationRiyadh".tr(),
          dateFrom: "2026-10-01",
          timeFrom: "20:00",
          typeName: "Wedding".tr(),
          eventStatus: "draft",
          draft: "1",
        ),
        _mockEvent(
          id: 3002,
          name: "mockEventBirthday".tr(),
          location: "mockLocationJeddah".tr(),
          dateFrom: "2026-10-05",
          timeFrom: "15:00",
          typeName: "Birthday".tr(),
          eventStatus: "draft",
          draft: "1",
          countvisitor: 20,
          acceptvisitorCount: 0,
        ),
      ],
    );
  }

  static event_model.EventsModel buildMockCancelEvents() {
    return event_model.EventsModel(
      status: true,
      errNum: "S000",
      msg: "guest",
      data: [
        _mockEvent(
          id: 3011,
          name: "mockEventCorporate".tr(),
          location: "mockLocationDammam".tr(),
          dateFrom: "2026-03-01",
          timeFrom: "10:00",
          typeName: "Meeting".tr(),
          eventStatus: "canceled",
          countvisitor: 0,
          acceptvisitorCount: 0,
        ),
        _mockEvent(
          id: 3012,
          name: "mockEventCharityGala".tr(),
          location: "mockLocationMecca".tr(),
          dateFrom: "2026-02-15",
          timeFrom: "19:30",
          typeName: "Gala".tr(),
          eventStatus: "canceled",
          countvisitor: 0,
          acceptvisitorCount: 0,
        ),
      ],
    );
  }

  static event_model.EventsModel buildMockWaitEvents() {
    return event_model.EventsModel(
      status: true,
      errNum: "S000",
      msg: "guest",
      data: [
        _mockEvent(
          id: 3021,
          name: "mockEventGraduation".tr(),
          location: "mockLocationMedina".tr(),
          dateFrom: "2026-11-20",
          timeFrom: "16:30",
          typeName: "Graduation".tr(),
          eventStatus: "pending",
        ),
        _mockEvent(
          id: 3022,
          name: "mockEventBirthday".tr(),
          location: "mockLocationJeddah".tr(),
          dateFrom: "2026-08-09",
          timeFrom: "19:15",
          typeName: "Birthday".tr(),
          eventStatus: "pending",
        ),
      ],
    );
  }

  static event_model.EventsModel buildMockActiveTabEvents() {
    return event_model.EventsModel(
      status: true,
      errNum: "S000",
      msg: "guest",
      data: [
        _mockEvent(
          id: 3031,
          name: "mockEventWedding".tr(),
          location: "mockLocationRiyadh".tr(),
          dateFrom: "2026-06-12",
          timeFrom: "20:00",
          typeName: "Wedding".tr(),
          eventStatus: "active",
          countvisitor: 120,
          acceptvisitorCount: 84,
        ),
        _mockEvent(
          id: 3032,
          name: "mockEventCharityGala".tr(),
          location: "mockLocationMecca".tr(),
          dateFrom: "2026-07-03",
          timeFrom: "18:45",
          typeName: "Gala".tr(),
          eventStatus: "active",
          countvisitor: 90,
          acceptvisitorCount: 70,
        ),
      ],
    );
  }

  static event_model.EventsModel buildMockFinishedEvents() {
    return event_model.EventsModel(
      status: true,
      errNum: "S000",
      msg: "guest",
      data: [
        _mockEvent(
          id: 3041,
          name: "mockEventCorporate".tr(),
          location: "mockLocationDammam".tr(),
          dateFrom: "2025-12-01",
          timeFrom: "10:00",
          typeName: "Meeting".tr(),
          eventStatus: "finished",
          countvisitor: 80,
          acceptvisitorCount: 75,
        ),
        _mockEvent(
          id: 3042,
          name: "mockEventBirthday".tr(),
          location: "mockLocationJeddah".tr(),
          dateFrom: "2025-11-11",
          timeFrom: "17:00",
          typeName: "Birthday".tr(),
          eventStatus: "finished",
          countvisitor: 40,
          acceptvisitorCount: 38,
        ),
      ],
    );
  }

  /// Mock analytics/dashboard payload so guests can preview the page with
  /// realistic-looking numbers. Totals are picked so percentages add up
  /// nicely (events: 4+3+5+2+1 = 15, visitors: 60+15+25 = 100).
  static DashboardModel buildMockDashboard() {
    final model = DashboardModel(
      status: true,
      errNum: "S000",
      msg: "guest",
      allevents: 15,
      activeevent: 4,
      pendingevent: 3,
      finishevent: 5,
      cancelevent: 2,
      draftevent: 1,
      allvisitor: 100,
      attendvisitor: 60,
      cancelvisitor: 15,
      waitingvisitor: 25,
      eventsSummary: [
        EventsSummary(id: 1, name: "mockEventWedding".tr(), invites: 120, comments: 18),
        EventsSummary(id: 2, name: "mockEventBirthday".tr(), invites: 45, comments: 7),
        EventsSummary(id: 3, name: "mockEventCorporate".tr(), invites: 80, comments: 12),
      ],
    );
    return model;
  }

  // ---------------------------------------------------------------------------
  // UI helpers
  // ---------------------------------------------------------------------------

  /// Shows a "you must sign in" dialog with a primary CTA that navigates the
  /// user to [SignInScreen] (without clearing the guest flag yet — they can
  /// back out and continue as a guest). Returns once the dialog is dismissed.
  static Future<void> requireLogin(
    BuildContext context, {
    String? title,
    String? message,
  }) {
    return AppUtil.dialog2(
      context,
      title ?? "loginRequired".tr(),
      [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Image.asset(
              "${AppUI.imgPath}logo.png",
              width: 80,
              height: 80,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 16),
            CustomText(
              text: message ?? "loginRequiredMessage".tr(),
              color: AppUI.disableColor,
              fontSize: 14,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomButton(
                  width: 120,
                  height: 40,
                  text: "signIn".tr(),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                    AppUtil.mainNavigator(context, const SignInScreen());
                  },
                ),
                const SizedBox(width: 10),
                CustomButton(
                  width: 120,
                  height: 40,
                  text: "cancel".tr(),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                  textColor: AppUI.mainColor,
                  borderColor: AppUI.mainColor,
                  color: Colors.white,
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ],
    );
  }

  /// Convenience wrapper: if the user is a guest, show the login-required
  /// dialog and return `true` (caller should *not* run the gated action).
  /// If the user is logged in, returns `false` and the caller proceeds.
  static bool guard(BuildContext context, {String? title, String? message}) {
    if (!isGuest) return false;
    requireLogin(context, title: title, message: message);
    return true;
  }

  /// Full-screen placeholder used by Notifications / Wallet when in guest
  /// mode. Keeps the original `customAppBar` so the user can still go back.
  static Widget buildLockedPage(
    BuildContext context, {
    required String appBarTitle,
    required String message,
  }) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            "${AppUI.imgPath}splash.png",
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.fill,
          ),
          Column(
            children: [
              customAppBar(
                title: appBarTitle,
                backgroundColor: Colors.transparent,
              ),
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          "${AppUI.imgPath}logo.png",
                          width: 110,
                          height: 110,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 24),
                        CustomText(
                          text: "loginRequired".tr(),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppUI.mainColor,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        CustomText(
                          text: message,
                          fontSize: 14,
                          color: AppUI.disableColor,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: CustomButton(
                            text: "signIn".tr(),
                            onPressed: () {
                              AppUtil.mainNavigator(
                                  context, const SignInScreen());
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Compact banner used inside otherwise-functional screens (e.g. Profile)
  /// to nudge the guest toward registering.
  static Widget buildRegisterBanner(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppUI.whiteColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppUI.mainColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.lock_outline,
                  color: AppUI.mainColor, size: 22),
              const SizedBox(width: 8),
              Expanded(
                child: CustomText(
                  text: "guestModeBannerTitle".tr(),
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppUI.mainColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          CustomText(
            text: "guestModeBannerMessage".tr(),
            fontSize: 12,
            color: AppUI.disableColor,
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 38,
            child: CustomButton(
              text: "signIn".tr(),
              onPressed: () {
                AppUtil.mainNavigator(context, const SignInScreen());
              },
            ),
          ),
        ],
      ),
    );
  }
}
