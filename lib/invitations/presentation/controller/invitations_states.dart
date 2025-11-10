abstract class InvitationsStates{}
class InvitationsInitState extends InvitationsStates{}

class InvitationsLoadingState extends InvitationsStates{}
class InvitationsLoadedState extends InvitationsStates{}
class InvitationsEmptyState extends InvitationsStates{}
class InvitationsErrorState extends InvitationsStates{}

class AcceptLoadedState extends InvitationsStates{}
class AcceptLoadingState extends InvitationsStates{}

class RejectLoadingState extends InvitationsStates{}
class RejectLoadedState extends InvitationsStates{}

class TypesChangeState extends InvitationsStates{}
