abstract class HomeStates{}
class HomeInitStates extends HomeStates{}

class EventsLoadingState extends HomeStates{}
class EventsLoadedState extends HomeStates{}
class EventsErrorState extends HomeStates{}
class EventsEmptyState extends HomeStates{}

class InvitationsLoadingState extends HomeStates{}
class InvitationsLoadedState extends HomeStates{}
class InvitationsEmptyState extends HomeStates{}
class InvitationsErrorState extends HomeStates{}

class NotificationLoadingState extends HomeStates{}
class NotificationLoadedState extends HomeStates{}
class NotificationEmptyState extends HomeStates{}
class NotificationErrorState extends HomeStates{}
